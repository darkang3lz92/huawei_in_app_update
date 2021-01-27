package com.domago.huawei_in_app_update

import android.app.Activity
import android.content.Intent
import androidx.annotation.NonNull
import com.huawei.hms.jos.AppUpdateClient
import com.huawei.hms.jos.JosApps
import com.huawei.updatesdk.service.appmgr.bean.ApkUpgradeInfo
import com.huawei.updatesdk.service.otaupdate.CheckUpdateCallBack
import com.huawei.updatesdk.service.otaupdate.UpdateKey
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry


interface ActivityProvider {
    fun addActivityResultListener(callback: PluginRegistry.ActivityResultListener)
    fun activity(): Activity?
}

/** HuaweiInAppUpdatePlugin */
class HuaweiInAppUpdatePlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private var activityProvider: ActivityProvider? = null
    private var client: AppUpdateClient? = null
    private var upgradeInfo: ApkUpgradeInfo? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "huawei_in_app_update")
        channel.setMethodCallHandler(this)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityProvider = object : ActivityProvider {
            override fun addActivityResultListener(callback: PluginRegistry.ActivityResultListener) {
                TODO("Not yet implemented")
            }

            override fun activity(): Activity {
                return binding.activity
            }
        }
    }

    override fun onDetachedFromActivity() {
        activityProvider = null
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityProvider = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityProvider = object : ActivityProvider {
            override fun addActivityResultListener(callback: PluginRegistry.ActivityResultListener) {
                TODO("Not yet implemented")
            }

            override fun activity(): Activity {
                return binding.activity
            }
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "checkForUpdate" -> checkForUpdate(result)
            "showUpdateDialog" -> showUpdateDialog(call, result)
        }


//        if (call.method == "getPlatformVersion") {
//            result.success("Android ${android.os.Build.VERSION.RELEASE}")
//        } else if (call.method == "checkForUpdate") {
//
//        } else {
//            result.notImplemented()
//        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun checkForUpdate(@NonNull result: Result) {
        requireNotNull(activityProvider?.activity()) {
            result.error("REQUIRE_FOREGROUND_ACTIVITY", "Require foreground activity", null)
        }

        client = JosApps.getAppUpdateClient(activityProvider?.activity())
        client?.checkAppUpdate(activityProvider?.activity(), object : CheckUpdateCallBack {
            override fun onUpdateInfo(intent: Intent?) {
                requireNotNull(intent) {
                    result.error("NULL_INTENT", "onUpdateInfo provide null intent", null)
                }

                val status = intent.getIntExtra(UpdateKey.STATUS, -1)
                val failCode = intent.getIntExtra(UpdateKey.FAIL_CODE, -1)

                val failReason = intent.getStringExtra(UpdateKey.FAIL_REASON)
                val info = intent.getSerializableExtra(UpdateKey.INFO)

                if (info is ApkUpgradeInfo) {

                    upgradeInfo = info
                    val successResult = hashMapOf(
                            "versionCode" to info.versionCode_,
                            "versionName" to info.version_,
                            "bundleSize" to info.bundleSize_,
                            "devType" to info.devType_,
                            "isAutoUpdate" to info.isAutoUpdate_,
                            "oldVersionCode" to info.oldVersionCode_,
                            "oldVersionName" to info.oldVersionName_

                    )

                    result.success(successResult)
                }
            }

            override fun onMarketInstallInfo(intent: Intent?) {
                TODO("Not yet implemented")
            }

            override fun onMarketStoreError(intent: Int) {
                TODO("Not yet implemented")
            }

            override fun onUpdateStoreError(p0: Int) {
                TODO("Not yet implemented")
            }

        })
    }

    private fun showUpdateDialog(@NonNull call: MethodCall, @NonNull result: Result) {
        requireNotNull(client) {
            result.error("REQUIRE_CHECK_FOR_UPDATE", "Require calling check for update first", null)
        }
        requireNotNull(upgradeInfo) {
            result.error("NO_UPDATE_AVAILABLE", "No update info available", null)
        }

        client?.showUpdateDialog(activityProvider?.activity(), upgradeInfo, false)
    }

}
