package ir.nanegha.impo


import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin
//import dev.fluttercommunity.plus.androidalarmmanager.AlarmService
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
//import io.flutter.plugins.androidalarmmanager.AlarmService
//import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService
//import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin
//import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService
import io.flutter.view.FlutterMain


class Application : MyFlutterApplication(), PluginRegistrantCallback {

    override fun onCreate(){
        super.onCreate()
//        FlutterFirebaseMessagingService.setPluginRegistrant(this)
//        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this)
        FlutterMain.startInitialization(this)
//        AlarmService.setPluginRegistrant(this)
    }

    override fun registerWith(registry: PluginRegistry) {
        try {
            //FlutterFirebaseMessagingPlugin.registerWith(registry!!.registrarFor("io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin"))
            // FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"))
        }catch (e: Exception){
            e.printStackTrace()
        }
    }
}