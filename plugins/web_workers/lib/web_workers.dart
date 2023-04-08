
import 'web_workers_platform_interface.dart';

class WebWorkers {
  Future<String?> getPlatformVersion() {
    return WebWorkersPlatform.instance.getPlatformVersion();
  }
}
