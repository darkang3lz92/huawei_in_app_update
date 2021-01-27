import 'dart:async';

import 'package:flutter/services.dart';

class HuaweiInAppUpdate {
  static const MethodChannel _channel =
      const MethodChannel('huawei_in_app_update');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<Map<String, dynamic>> checkForUpdate() async {
    try {
      return await _channel
          .invokeMethod<Map<String, dynamic>>('checkForUpdate');
    } on PlatformException catch (e) {
      throw e;
    }
  }

  static void showUpdateDialog() async {
    try {
      await _channel.invokeMethod('showUpdateDialog');
    } on PlatformException catch (e) {
      throw e;
    }
  }
}
