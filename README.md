# huawei_in_app_update

This flutter plugin project use official [Huawei App Update API](https://developer.huawei.com/consumer/en/doc/development/AppGallery-connect-Guides/appgallerykit-app-update) to check update from AppGallery. Please note that this plugin for Android use only.

## Prerequisite
You must add the [AppGallery Connect configuration file of your app](https://developer.huawei.com/consumer/en/doc/development/AppGallery-connect-Guides/appgallerykit-preparation#addconfig) to your project before you run it.


## Usage

Calling `HuaweiInAppUpdate.checkForUpdate()` will return `UpgradeInfo`. You may use `upgradeInfo.updateAvailable` to check if there is an update available. If update is available, you may show a update dialog using `HuaweiInAppUpdate.showUpdateDialog()`. If force specify as true, dialog will not dismissable and back button will not pop the dialog.

```dart
void checkForUpdate() async {
    if (Platform.isAndroid) {
      try {
        final upgradeInfo = await HuaweiInAppUpdate.checkForUpdate();
        if (upgradeInfo.updateAvailable) {
          HuaweiInAppUpdate.showUpdateDialog(
            context: context,
            force: false,
          );
        }
      } on PlatformException catch (e) {
        showErrorDialog(e.code, e.message);
      }
    } else {
      showErrorDialog('IOS_NOT_SUPPORTED', 'iOS device is not supported');
    }
  }

```

If you would like to have a different app update presentation in your app, you may try to create your own custom widget design using the information provided from `UpgradeInfo`.
