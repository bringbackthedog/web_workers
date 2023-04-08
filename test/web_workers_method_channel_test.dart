import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_workers/src/web_workers_method_channel.dart';

void main() {
  MethodChannelWebWorkers platform = MethodChannelWebWorkers();
  const MethodChannel channel = MethodChannel('web_workers');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
