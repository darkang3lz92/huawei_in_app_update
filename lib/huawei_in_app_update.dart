import 'dart:async';

import 'package:flutter/services.dart';

class HuaweiInAppUpdate {
  static const MethodChannel _channel =
      const MethodChannel('huawei_in_app_update');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<UpgradeInfo> checkForUpdate() async {
    try {
      final info = await _channel.invokeMethod('checkForUpdate');

      print(info);
      return UpgradeInfo(
        versionCode: info["versionCode"],
        versionName: info["versionName"],
        bundleSize: info["bundleSize"],
        devType: info["devType"],
        isAutoUpdate: info["isAutoUpdate"],
        oldVersionCode: info["oldVersionCode"],
        oldVersionName: info["oldVersionName"],
      );
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

class UpgradeInfo {
  final int versionCode;
  final String versionName;
  final int oldVersionCode;
  final String oldVersionName;
  final int devType;
  final int bundleSize;
  final bool isAutoUpdate;

  UpgradeInfo({
    this.versionCode,
    this.versionName,
    this.oldVersionCode,
    this.oldVersionName,
    this.devType,
    this.bundleSize,
    this.isAutoUpdate,
  });
}
