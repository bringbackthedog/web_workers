import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:web_workers/web_workers.dart';
import 'package:web_workers_example/models/custom_worker.dart';
import 'dart:math' as math;

// This example creates a web app that can create a web worker and do some heavy
// calculations in the worker without blocking the main app.

const workerName = 'worker.dart.js';
final _numToSumTo = math.pow(10, 10).toInt();
const String jsSumUpToFuncName = "sumUpTo";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plugin example app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _platformVersion = 'Unknown';
  final _webWorkersPlugin = WebWorkers();

  CustomWorker? _worker;

  Color _bgColor = Colors.white;

  final List<StreamSubscription<String>> _subscriptions = [];

  void _toggleBgColor() {
    setState(() {
      _bgColor = _bgColor == Colors.white ? Colors.red : Colors.white;
    });
  }

  // Calculates the sum of all numbers from 1 to n.
  int _sumUpTo(int n) {
    int sum = 0;
    for (int i = 1; i <= n; i++) {
      sum += i;
    }

    return sum;
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _webWorkersPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  // dispose all subscriptions
  @override
  void dispose() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void addSubscription(Stream<String> stream) {
      //
      // Listen for messages from the worker and show an alert dialog with the result
      //
      var subscription = stream.listen((event) {
        print('DEBUG: received message from worker: $event');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sum'),
            content: Text('Sum calculated by separate worker: $event'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      });

      _subscriptions.add(subscription);
      print('DEBUG: added subscription');
    }

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Running on: $_platformVersion\n'),

            // Create worker
            ElevatedButton(
              child: const Text('Create worker'),
              onPressed: _worker != null
                  // deactivate button if worker already exists
                  ? null
                  : () async {
                      try {
                        final workerId =
                            await _webWorkersPlugin.create(workerName);
                        _worker = CustomWorker(workerId);

                        // Listen for messages from the worker
                        addSubscription(_worker!.onMessage);

                        setState(() {});
                      } catch (e) {
                        print('DEBUG error: $e');
                      }
                    },
            ),

            const SizedBox(height: 20),

            // Calculate sum - Very slow
            ElevatedButton(
              child:
                  const Text('Calculate sum on main app worker (very slow!)'),
              onPressed: () async {
                try {
                  int sum = _sumUpTo(_numToSumTo);

                  // Show an alert dialog with the result
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Sum'),
                      content: Text('Sum calculated by main app worker: $sum'),
                      actions: [
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  print('DEBUG error: $e');
                }
              },
            ),

            const SizedBox(height: 20),

            // Calculate sum in separate worker
            ElevatedButton(
              child: const Text('Calculate sum in separate worker'),
              onPressed: () async {
                try {
                  if (_worker == null) {
                    throw Exception('Worker not created. Create worker first.');
                  }

                  // encode the function name and arguments as JSON
                  var msg = {
                    "function": jsSumUpToFuncName,
                    "args": [_numToSumTo],
                  };

                  // Send a message to the worker to calculate the sum
                  await _webWorkersPlugin.postMessage(
                    _worker!.id,
                    jsonEncode(msg),
                  );
                } catch (e) {
                  print('DEBUG error: $e');
                }
              },
            ),

            const SizedBox(height: 20),

            // Change background color
            ElevatedButton(
              child: const Text('Change background color'),
              onPressed: () async {
                try {
                  setState(() {
                    _toggleBgColor();
                  });
                } catch (e) {
                  print('DEBUG error: $e');
                }
              },
            ),

            const SizedBox(height: 20),

            // Terminate the last worker created
            ElevatedButton(
              child: const Text('Terminate worker'),
              onPressed: () async {
                try {
                  await _webWorkersPlugin.terminate(_worker!.id);

                  setState(() {
                    _worker = null;
                  });
                } catch (e) {
                  print('DEBUG error: $e');
                }
              },
            ),

            const SizedBox(height: 20),

            if (_worker != null)
              StreamBuilder<String>(
                stream: _webWorkersPlugin.onMessage(_worker!.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('Message from worker: ${snapshot.data}');
                  } else {
                    return const Text('No message from worker');
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
