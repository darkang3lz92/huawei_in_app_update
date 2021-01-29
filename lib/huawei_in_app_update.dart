import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huawei_in_app_update/src/formatter.dart';
import 'package:url_launcher/url_launcher.dart';

class HuaweiInAppUpdate {
  static const MethodChannel _channel =
      const MethodChannel('huawei_in_app_update');

  static UpgradeInfo _upgradeInfo;

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
  static void showUpdateDialog({
    @required BuildContext context,
    bool force = false,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => UpdateDialog(
        info: _upgradeInfo,
        forceUpdate: force,
      ),
      barrierDismissible: !force,
    );

    // try {
    //   await _channel.invokeMethod('showUpdateDialog');
    // } on PlatformException catch (e) {
    //   throw e;
    // }
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

class UpdateDialog extends StatelessWidget {
  final UpgradeInfo info;
  final bool forceUpdate;

  UpdateDialog({
    @required this.info,
    this.forceUpdate = false,
  }) : assert(info != null);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => forceUpdate ? false : Navigator.canPop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Material(
                color: Theme.of(context).dialogBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                clipBehavior: Clip.hardEdge,
                child: Container(
                  child: Column(
                    children: [
                      Text('New Version'),
                      _buildTextRow(
                        'App',
                        info?.appName,
                      ),
                      _buildTextRow(
                        'Version',
                        info?.versionName,
                      ),
                      _buildTextRow(
                        'Size',
                        info?.size?.formatBytes(),
                      ),
                      Text('Details'),
                      Text(info?.newFeatures),
                      _buildButtons(context)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    var buttonsRow = [];

    if (!forceUpdate) {
      buttonsRow.add(
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('LATER'),
          ),
        ),
      );

      buttonsRow.add(VerticalDivider());
    }
    buttonsRow.add(
      Expanded(
        child: TextButton(
          onPressed: () async {
            if (info?.appId != null && info?.appName != null) {
              final appGalleryDeeplink =
                  'appmarket://details?id=${info?.appName}';

              if (await canLaunch(appGalleryDeeplink)) {
                await launch(appGalleryDeeplink);
              } else {
                final appGalleryUrl =
                    'https://appgallery.huawei.com/#/app/${info.appId}';
                if (await canLaunch(appGalleryUrl)) {
                  await launch(appGalleryUrl);
                }
              }
            }
          },
          child: Text('UPDATE'),
        ),
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: buttonsRow,
    );
  }

  Widget _buildTextRow(String title, String description) {
    return Row(
      children: [
        Text(title),
        Text(description),
      ],
    );
  }
}
