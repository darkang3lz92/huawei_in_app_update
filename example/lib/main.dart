import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huawei_in_app_update/huawei_in_app_update.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  void checkForUpdate() async {
    if (Platform.isAndroid) {
      try {
        final upgradeInfo = await HuaweiInAppUpdate.checkForUpdate();
        if (upgradeInfo.updateAvailable) {
          HuaweiInAppUpdate.showUpdateDialog();
        }
      } on PlatformException catch (e) {
        showErrorDialog(e.code, e.message);
      }
    } else {
      showErrorDialog('IOS_NOT_SUPPORTED', 'iOS device is not supported');
    }
  }

  void showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Huawei App Update Plugin'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () => checkForUpdate(),
            child: Text('Check Update'),
          ),
        ),
      ),
    );
  }
}
