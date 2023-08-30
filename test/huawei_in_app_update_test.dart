import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:huawei_in_app_update/huawei_in_app_update.dart';

void main() {
  const MethodChannel channel = MethodChannel('huawei_in_app_update');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    final handler = (MethodCall methodCall) async {
      if (methodCall.method == 'checkForUpdate') {
        return {'appId': "1234"};
      }
      return null;
    };

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, handler);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('checkForUpdate', () async {
    final info = await HuaweiInAppUpdate.checkForUpdate();
    expect(info.updateAvailable, true);
    expect(info.appId, '1234');
  });
}
