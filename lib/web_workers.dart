import 'src/web_workers_platform_interface.dart';

class WebWorkers {
  Future<String?> getPlatformVersion() {
    return WebWorkersPlatform.instance.getPlatformVersion();
  }

  /// Create a new web worker
  Future<int> create(String url) {
    return WebWorkersPlatform.instance.create(url);
  }

  /// Post a message to a web worker
  ///
  /// [id] is the id of the web worker
  /// [message] is the message to post
  ///
  /// Returns a [Future] that completes when the message has been posted
  /// to the web worker.
  Future<void> postMessage(int id, String message) {
    return WebWorkersPlatform.instance.postMessage(id, message);
  }

  /// Terminate a web worker
  ///
  /// [id] is the id of the web worker
  ///
  /// Returns a [Future] that completes when the web worker has been terminated.
  Future<void> terminate(int id) {
    return WebWorkersPlatform.instance.terminate(id);
  }

  /// Listen for messages from a web worker
  ///
  /// [id] is the id of the web worker
  ///
  /// Returns a [Stream] that emits messages from the web worker.
  ///
  /// The stream will not emit any messages until the first listener is added.
  ///
  /// The stream will not emit any messages after the last listener is removed.
  ///
  /// The stream will not emit any messages after the web worker has been terminated.
  Stream<String> onMessage(int id) {
    return WebWorkersPlatform.instance.onMessage(id);
  }
}
