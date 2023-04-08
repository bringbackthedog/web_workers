import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'web_workers_method_channel.dart';

abstract class WebWorkersPlatform extends PlatformInterface {
  /// Constructs a WebWorkersPlatform.
  WebWorkersPlatform() : super(token: _token);

  static final Object _token = Object();

  static WebWorkersPlatform _instance = MethodChannelWebWorkers();

  /// The default instance of [WebWorkersPlatform] to use.
  ///
  /// Defaults to [MethodChannelWebWorkers].
  static WebWorkersPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WebWorkersPlatform] when
  /// they register themselves.
  static set instance(WebWorkersPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
