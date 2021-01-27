import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:huawei_in_app_update/huawei_in_app_update.dart';

void main() {
  const MethodChannel channel = MethodChannel('huawei_in_app_update');

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
    expect(await HuaweiInAppUpdate.platformVersion, '42');
  });
}
