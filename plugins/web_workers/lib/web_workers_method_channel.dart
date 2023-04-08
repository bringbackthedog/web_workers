import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'web_workers_platform_interface.dart';

/// An implementation of [WebWorkersPlatform] that uses method channels.
class MethodChannelWebWorkers extends WebWorkersPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('web_workers');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
