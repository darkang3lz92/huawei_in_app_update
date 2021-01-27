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

      return UpgradeInfo(
        true,
        appId: info['appId'],
        appName: info['appName'],
        packageName: info['packageName'],
        versionName: info['versionName'],
        diffSize: info['diffSize'],
        diffDownUrl: info['diffDownUrl'],
        diffSha2: info['diffSha2'],
        sameS: info['sameS'],
        size: info['size'],
        releaseDate: info['releaseDate'],
        icon: info['icon'],
        oldVersionCode: info['oldVersionCode'],
        downUrl: info['downurl'],
        versionCode: info['versionCode'],
        newFeatures: info['newFeatures'],
        releaseDateDesc: info['releaseDateDesc'],
        detailId: info['detailId'],
        fullDownUrl: info['fullDownUrl'],
        bundleSize: info['bundleSize'],
        devType: info['devType'],
        isAutoUpdate: info['isAutoUpdate'] == 1,
        oldVersionName: info['oldVersionName'],
        isCompulsoryUpdate: info['isCompulsoryUpdate'] == 1,
        notRcmReason: info['notRcmReason'],
      );
    } on PlatformException catch (e) {
      if (e.code == 'NO_UPGRADE_INFO') {
        return UpgradeInfo(false);
      }

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
  final bool updateAvailable;
  final String appId;
  final String appName;
  final String packageName;
  final int diffSize;
  final String diffDownUrl;
  final String diffSha2;
  final int sameS;
  final int size;
  final String releaseDate;
  final String icon;
  final int versionCode;
  final String versionName;
  final int oldVersionCode;
  final String oldVersionName;
  final String downUrl;
  final String newFeatures;
  final String releaseDateDesc;
  final String detailId;
  final String fullDownUrl;
  final int bundleSize;
  final int devType;
  final bool isCompulsoryUpdate;
  final bool isAutoUpdate;
  final int notRcmReason;

  UpgradeInfo(
    this.updateAvailable, {
    this.appId,
    this.appName,
    this.packageName,
    this.diffSize,
    this.diffDownUrl,
    this.diffSha2,
    this.sameS,
    this.size,
    this.releaseDate,
    this.icon,
    this.versionCode,
    this.versionName,
    this.oldVersionCode,
    this.oldVersionName,
    this.downUrl,
    this.newFeatures,
    this.releaseDateDesc,
    this.detailId,
    this.fullDownUrl,
    this.bundleSize,
    this.devType,
    this.isCompulsoryUpdate,
    this.isAutoUpdate,
    this.notRcmReason,
  });

  @override
  String toString() => 'UpgradeInfo{'
      'appId: $appId, '
      'appName: $appName, '
      'packageName: $packageName, '
      'diffSize: $diffSize, '
      'diffDownUrl: $diffDownUrl, '
      'diffSha2: $diffSha2, '
      'sameS: $sameS, '
      'size: $size, '
      'releaseDate: $releaseDate, '
      'icon: $icon, '
      'versionCode: $versionCode, '
      'versionName: $versionName, '
      'oldVersionCode: $oldVersionCode, '
      'oldVersionName: $oldVersionName, '
      'downUrl: $downUrl, '
      'newFeatures: $newFeatures, '
      'releaseDateDesc: $releaseDateDesc, '
      'detailId: $detailId, '
      'fullDownUrl: $fullDownUrl, '
      'bundleSize: $bundleSize, '
      'devType: $devType, '
      'isCompulsoryUpdate: $isCompulsoryUpdate, '
      'isAutoUpdate: $isAutoUpdate, '
      'notRcmReason: $notRcmReason'
      '}';
}
