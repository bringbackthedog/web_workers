// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// import 'dart:html' as html show window;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'web_workers_platform_interface.dart';

/// A web implementation of the WebWorkersPlatform of the WebWorkers plugin.
class WebWorkersWeb extends WebWorkersPlatform {
  /// Constructs a WebWorkersWeb
  WebWorkersWeb();

  final _workers = <int, html.Worker>{};

  static void registerWith(Registrar registrar) {
    WebWorkersPlatform.instance = WebWorkersWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }

  /// Create
  @override
  Future<int> create(String url) async {
    print('WebWorkersWeb.create: $url');
    final worker = html.Worker(url);
    final id = _workers.length;
    _workers[id] = worker;
    return id;
  }

  /// Post Message
  @override
  Future<void> postMessage(int id, String message) async {
    print('WebWorkersWeb.postMessage: $id, $message');
    final worker = _workers[id];

    if (worker == null) {
      throw PlatformException(
        code: 'Unimplemented',
        details: 'web_worker for web doesn\'t implement \'${id}\'',
      );
    }

    worker.postMessage(message);
  }

  /// Terminate
  @override
  Future<void> terminate(int id) async {
    print('WebWorkersWeb.terminate: $id');
    final worker = _workers[id];

    if (worker == null) {
      throw PlatformException(
        code: 'Unimplemented',
        details: 'web_worker for web doesn\'t implement \'${id}\'',
      );
    }

    worker.terminate();
  }
}
