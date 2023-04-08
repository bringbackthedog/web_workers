import 'package:web_workers/web_workers.dart';

class CustomWorker {
  CustomWorker(this.id);

  int id;
  final _webWorkersPlugin = WebWorkers();

  Stream<String> get onMessage => _webWorkersPlugin.onMessage(id);

  // void postMessage(String message) {
  //   print('Worker sent: $message');
  // }
}
