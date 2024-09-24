package ir.nanegha.impo

import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterFragmentActivity(){

    private val channelName = "action_manage_overlay"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor, channelName).setMethodCallHandler { call, result ->
            if (call.method.equals("getPermissionOverlay", ignoreCase = true)) {
                val p = CheckPermissionOverlay()
                result.success(p)
            } else if (call.method.equals("goToSettingPermissionOverlay", ignoreCase = true)){
                goToSettingPermissionOverlay()
                result.success(true)
            } else if(call.method.equals("finishTask",ignoreCase = true)){
                finish()
            }
            else {
                result.notImplemented()
            }
        }
    }

    override fun onResume() {
        super.onResume()
        closeAllNotifications()
    }


//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        MethodChannel(flutterEngine?.dartExecutor, channelName).setMethodCallHandler { call, result ->
//            if (call.method.equals("getPermissionOverlay", ignoreCase = true)) {
//                val p = CheckPermissionOverlay()
//                result.success(p)
//            } else if (call.method.equals("goToSettingPermissionOverlay", ignoreCase = true)){
//                goToSettingPermissionOverlay()
//                result.success(true)
//            } else if(call.method.equals("finishTask",ignoreCase = true)){
//                finish()
//            }
//            else {
//                result.notImplemented()
//            }
//        }
//    }


    fun CheckPermissionOverlay(): Boolean {
        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.P) {
//            val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:" + context.packageName))
//            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
//            context.startActivity(intent)
            return Settings.canDrawOverlays(this)
        }
        return true
    }

    fun goToSettingPermissionOverlay() {
        val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:" + this.packageName))
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        this.startActivity(intent)
    }


    private fun closeAllNotifications() {
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancelAll()
    }




}
