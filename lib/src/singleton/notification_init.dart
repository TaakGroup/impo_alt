import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:impo/main.dart';
import 'package:impo/src/singleton/payload.dart';
import 'package:impo/src/screens/splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationInit{

   static NotificationInit? notify;

   static NotificationInit getGlobal(){
     if(notify == null) {
       // print('create');
       notify = new NotificationInit();
     }
     return notify!;
   }

   static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

     initLocalNotifications()async{
     var initializationSettingsAndroid = new AndroidInitializationSettings('impo_icon');
     var initializationSettingsIOS = new DarwinInitializationSettings();
     var initializationSettings = new InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
     final notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
     if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
       debugPrint('didNotificationLaunchApp');
       await selectNotificationKill(notificationAppLaunchDetails!.notificationResponse!.payload);
     }
     flutterLocalNotificationsPlugin.initialize(
         initializationSettings,
         onDidReceiveBackgroundNotificationResponse: selectNotification,
        onDidReceiveNotificationResponse: selectNotification
     );
   }

   @pragma('vm:entry-point')
   static Future selectNotification(NotificationResponse notificationResponse) async {
       String? payload = notificationResponse.payload;
     if (payload != null) {
       debugPrint('notification payloaddd: ' + payload);
     }
     if(payload != null){
       if(payload.split('*')[0] == 'link'){
         if(payload.split('*')[1].startsWith('http')){
           if (!await launch(payload.split('*')[1])) throw 'Could not launch ${payload.split('*')[1]}';
           // _launchURL(payload.split('*')[1]);
         }else{
           if (!await launch('http://${payload.split('*')[1]}')) throw 'Could not launch ${'http://${payload.split('*')[1]}'}';
           // _launchURL('http://${payload.split('*')[1]}');
         }
       }else{
         if(payload != 'normal'){
           Payload.getGlobal().setPayload(payload);
           Timer(Duration(milliseconds: 50),(){
             Navigator.pushReplacement(
                 navigatorKey.currentContext!,
                 PageTransition(
                     duration: Duration(seconds: 1),
                     type: PageTransitionType.fade,
                     child:  SplashScreen(
                       localPass: true,
                       // index: 2,
                     )
                 )
             );
           });
           // runApp(
           //     MaterialApp(
           //       title: 'Impo',
           //       debugShowCheckedModeBanner: false,
           //       builder: (context, child) =>
           //           MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!),
           //       theme: ImpoTheme.light,
           //       home: SplashScreen(
           //         localPass: true,
           //         // index: 2,
           //       ),
           //     )
           // );
         }
       }
     }
   }


   Future selectNotificationKill(String? payload) async{
     if (payload != null) {
       debugPrint('notification payloaddd: ' + payload);
     }
     if(payload != null){
       if(payload.split('*')[0] == 'link'){
         if(payload.split('*')[1].startsWith('http')){
           _launchURL(payload.split('*')[1]);
         }else{
           _launchURL('http://${payload.split('*')[1]}');
         }
       }else{
         if(payload != 'normal'){
           Payload.getGlobal().setPayload(payload);
         }
       }
     }
   }

   _launchURL(url) async {
     if (!await launch(url)) throw 'Could not launch $url';
   }

   FlutterLocalNotificationsPlugin getNotify(){
     return flutterLocalNotificationsPlugin;
   }

}