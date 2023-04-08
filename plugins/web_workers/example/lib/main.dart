import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:web_workers/web_workers.dart';
import 'package:web_workers_example/custom_worker.dart';

const workerName = 'worker.dart.js';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _webWorkersPlugin = WebWorkers();

  CustomWorker? _worker;

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                onPressed: () async {
                  try {
                    final workerId = await _webWorkersPlugin.create(workerName);
                    _worker = CustomWorker(workerId);
                  } catch (e) {
                    print('DEBUG error: $e');
                  }
                },
              ),

              const SizedBox(height: 20),

              // Post message to the last worker created
              ElevatedButton(
                child: const Text('Post message'),
                onPressed: () async {
                  if (_worker == null) {
                    throw Exception('No worker created. Create one first.');
                  }

                  try {
                    await _webWorkersPlugin.postMessage(
                      _worker!.id,
                      'Hello from Flutter',
                    );
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
                    _worker = null;
                  } catch (e) {
                    print('DEBUG error: $e');
                  }
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
