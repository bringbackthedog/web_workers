import 'dart:html';

void main() {
  final worker = Worker('worker.dart.js');
  worker.onMessage.listen((event) {
    print('Message received from worker: ${event.data}');
  });
  worker.postMessage('Hello from main!');
}
