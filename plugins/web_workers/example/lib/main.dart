import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:web_workers/web_workers.dart';

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
                    final id = await _webWorkersPlugin.create('worker.dart.js');
                  } catch (e) {
                    print('DEBUG error: $e');
                  }
                },
              ),

              SizedBox(height: 20),

              // Post message
              ElevatedButton(
                child: const Text('Post message'),
                onPressed: () async {
                  try {
                    await _webWorkersPlugin.postMessage(
                        0, 'Hello from Flutter');
                  } catch (e) {
                    print('DEBUG error: $e');
                  }
                },
              ),

              SizedBox(height: 20),

              // Terminate worker
              ElevatedButton(
                child: const Text('Terminate worker'),
                onPressed: () async {
                  try {
                    await _webWorkersPlugin.terminate(0);
                  } catch (e) {
                    print('DEBUG error: $e');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
