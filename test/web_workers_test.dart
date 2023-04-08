// import 'package:flutter_test/flutter_test.dart';
// import 'package:web_workers/web_workers.dart';
// import 'package:web_workers/src/web_workers_platform_interface.dart';
// import 'package:web_workers/src/web_workers_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockWebWorkersPlatform
//     with MockPlatformInterfaceMixin
//     implements WebWorkersPlatform {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final WebWorkersPlatform initialPlatform = WebWorkersPlatform.instance;

//   test('$MethodChannelWebWorkers is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelWebWorkers>());
//   });

//   test('getPlatformVersion', () async {
//     WebWorkers webWorkersPlugin = WebWorkers();
//     MockWebWorkersPlatform fakePlatform = MockWebWorkersPlatform();
//     WebWorkersPlatform.instance = fakePlatform;

//     expect(await webWorkersPlugin.getPlatformVersion(), '42');
//   });
// }
