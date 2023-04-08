import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class WebWorkersPlugin {
  static const methodChannelName = 'web_worker';

  /// Registers the plugin with the [registrar].
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      methodChannelName,
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = WebWorkersPlugin();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'create':
        return _create(call.arguments);
      case 'postMessage':
        return _postMessage(call.arguments);
      case 'terminate':
        return _terminate(call.arguments);
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'web_worker for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  final _workers = <int, html.Worker>{};

  int _create(dynamic arguments) {
    final worker = html.Worker(arguments['url']);
    final id = _workers.length;
    _workers[id] = worker;
    return id;
  }

  void _postMessage(dynamic arguments) {
    final worker = _workers[arguments['id']];

    if (worker == null) {
      throw PlatformException(
        code: 'Unimplemented',
        details: 'web_worker for web doesn\'t implement \'${arguments['id']}\'',
      );
    }

    worker.postMessage(arguments['message']);
  }

  void _terminate(dynamic arguments) {
    final worker = _workers[arguments['id']];

    if (worker == null) {
      throw PlatformException(
        code: 'Unimplemented',
        details: 'web_worker for web doesn\'t implement \'${arguments['id']}\'',
      );
    }

    worker.terminate();
  }
}



// void main() {
//   final worker = html.Worker('worker.dart.js');
//   worker.onMessage.listen((event) {
//     print('Message received from worker: ${event.data}');
//   });
//   worker.postMessage('Hello from main!');
// }
