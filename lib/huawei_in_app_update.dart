import 'dart:async';

import 'package:flutter/services.dart';

class HuaweiInAppUpdate {
  static const MethodChannel _channel =
      const MethodChannel('huawei_in_app_update');

  /// Initiate to check for update from Huawei Server
  /// and retrieve App Update information
  ///
  /// Returns [UpgradeInfo].
  ///
  /// If no update available, [UpgradeInfo.updateAvailable]
  /// will return false.
  ///
  /// Throws a [PlatformException] if error occured.
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

  /// Display a update dialog provided by Huawei API.
  ///
  /// Throws a [PlatformException] if error occured.
  static void showUpdateDialog() async {
    try {
      await _channel.invokeMethod('showUpdateDialog');
    } on PlatformException catch (e) {
      throw e;
    }
  }
}

class UpgradeInfo {
  /// Whether new update is available.
  final bool updateAvailable;

  /// App ID
  final String appId;

  /// App name
  final String appName;

  /// Package name parsed from the APK.
  final String packageName;

  /// Size of the differential package.
  final int diffSize;

  final String diffDownUrl;

  final String diffSha2;

  /// Indicates whether the signature is different. 
  /// 
  /// The options are as follows:
  /// - **0**: no
  /// - **1**: yes
  final int sameS;

  /// Size of the app of the target version.
  final int size;

  /// App release time, accurate to day. The value is in the yyyy-MM-dd format.
  final String releaseDate;

  /// URL of the app icon
  final String icon;

  /// Internal version number parsed from the APK.
  final int versionCode;

  /// Target version name.
  final String versionName;

  /// Source version number.
  final int oldVersionCode;

  /// Source version name.
  final String oldVersionName;

  /// URL for downloading the complete or differential app package.
  final String downUrl;

  /// New features
  final String newFeatures;

  /// App update time description, for example, "released on X."
  /// The value is calculated by the server and displayed on the client.
  final String releaseDateDesc;

  /// ID of the AppGallery request details API.
  final String detailId;

  final String fullDownUrl;

  final int bundleSize;

  /// Indicates whether the app is a Huawei-developed app. 
  /// 
  /// The options are as follows:
  /// - **0**: no
  /// - **1**: yes
  final int devType;

  /// Indicates whether the update is forcible.
  final bool isCompulsoryUpdate;

  final bool isAutoUpdate;

  /// Reason for not recommending the update.
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
      'updateAvailable: $updateAvailable, '
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
