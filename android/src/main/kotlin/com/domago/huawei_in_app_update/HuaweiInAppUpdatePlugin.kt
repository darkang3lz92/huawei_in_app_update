package com.domago.huawei_in_app_update

import android.app.Activity
import android.content.Intent
import androidx.annotation.NonNull
import com.huawei.hms.jos.AppUpdateClient
import com.huawei.hms.jos.JosApps
import com.huawei.updatesdk.service.appmgr.bean.ApkUpgradeInfo
import com.huawei.updatesdk.service.otaupdate.CheckUpdateCallBack
import com.huawei.updatesdk.service.otaupdate.UpdateKey
import com.huawei.updatesdk.service.otaupdate.UpdateStatusCode
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


interface ActivityProvider {
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

    companion object {
        private const val DEFAULT_CODE = -99
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "huawei_in_app_update")
        channel.setMethodCallHandler(this)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityProvider = object : ActivityProvider {
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
            override fun activity(): Activity {
                return binding.activity
            }
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "checkForUpdate" -> checkForUpdate(result)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun checkForUpdate(result: Result) {
        requireNotNull(activityProvider?.activity()) {
            result.error("REQUIRE_FOREGROUND_ACTIVITY", "Require foreground activity", null)
        }

        client = JosApps.getAppUpdateClient(activityProvider?.activity())
        client?.checkAppUpdate(activityProvider?.activity(), object : CheckUpdateCallBack {
            override fun onUpdateInfo(intent: Intent?) {
                requireNotNull(intent) {
                    result.error("NULL_INTENT", "onUpdateInfo provide null intent", null)
                }

                val status = intent.getIntExtra(UpdateKey.STATUS, DEFAULT_CODE)

                // error reference: https://developer.huawei.com/consumer/en/doc/development/HMSCore-References/appupdateclient-0000001050123641#section15712187193218
                val errorDetails = ErrorDetails(
                    code = intent.getIntExtra(UpdateKey.FAIL_CODE, DEFAULT_CODE),
                    reason = intent.getStringExtra(UpdateKey.FAIL_REASON)
                ).asMap()

                if (status == UpdateStatusCode.HAS_UPGRADE_INFO) {


                    val info = intent.getSerializableExtra(UpdateKey.INFO)

                    if (info is ApkUpgradeInfo) {

                        upgradeInfo = info
                        val successResult = hashMapOf(
                            "appId" to info.id_,
                            "appName" to info.name_,
                            "packageName" to info.package_,
                            "versionName" to info.version_,
                            "diffSize" to info.diffSize_,
                            "diffDownUrl" to info.diffDownUrl_,
                            "diffSha2" to info.diffSha2_,
                            "sameS" to info.sameS_,
                            "size" to info.longSize_,
                            "releaseDate" to info.releaseDate_,
                            "icon" to info.icon_,
                            "oldVersionCode" to info.oldVersionCode_,
                            "versionCode" to info.versionCode_,
                            "downurl" to info.downurl_,
                            "newFeatures" to info.newFeatures_,
                            "releaseDateDesc" to info.releaseDateDesc_,
                            "detailId" to info.detailId_,
                            "fullDownUrl" to info.fullDownUrl_,
                            "bundleSize" to info.bundleSize_,
                            "devType" to info.devType_,
                            "isAutoUpdate" to info.isAutoUpdate_,
                            "oldVersionName" to info.oldVersionName_,
                            "isCompulsoryUpdate" to info.isCompulsoryUpdate_,
                            "notRcmReason" to info.notRcmReason_

                        )
                        result.success(successResult)
                    } else {
                        result.error("NO_UPGRADE_INFO", "No update is available", errorDetails)
                    }
                } else if (status == UpdateStatusCode.PARAMER_ERROR) {
                    result.error("PARAMETER_ERROR", "Parameter is incorrect", errorDetails)
                } else if (status == UpdateStatusCode.CONNECT_ERROR) {
                    result.error("CONNECT_ERROR", "Network connection is incorrect", errorDetails)
                } else if (status == UpdateStatusCode.NO_UPGRADE_INFO) {
                    result.error("NO_UPGRADE_INFO", "No update is available", errorDetails)
                } else if (status == UpdateStatusCode.CANCEL) {
                    result.error("CANCEL", "User cancels the update", errorDetails)
                } else if (status == UpdateStatusCode.INSTALL_FAILED) {
                    result.error("INSTALL_FAILED", "App update fails", errorDetails)
                } else if (status == UpdateStatusCode.CHECK_FAILED) {
                    result.error("CHECK_FAILED", "Update information fails to be queried", errorDetails)
                } else if (status == UpdateStatusCode.MARKET_FORBID) {
                    result.error("MARKET_FORBID", "HUAWEI AppGallery is disabled", errorDetails)
                } else if (status == UpdateStatusCode.IN_MARKET_UPDATING) {
                    result.error("IN_MARKET_UPDATING", "App is being updated", errorDetails)
                } else {
                    result.error("UNKNOWN_STATUS", "Status unknown", errorDetails)
                }
            }

            override fun onMarketInstallInfo(intent: Intent?) {
                // Reserved method. No handling is required.
            }

            override fun onMarketStoreError(responseCode: Int) {
                // Reserved method. No handling is required.
            }

            override fun onUpdateStoreError(responseCode: Int) {
                // Reserved method. No handling is required.
            }

        })
    }
}
