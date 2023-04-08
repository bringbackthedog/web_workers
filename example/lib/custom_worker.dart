class CustomWorker {
  CustomWorker(this.id);
  int id;

  void handleMessage(String message) {
    print('Worker received: $message');
  }

  // void postMessage(String message) {
  //   print('Worker sent: $message');
  // }
}
