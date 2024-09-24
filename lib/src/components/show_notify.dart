

import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:impo/src/singleton/notification_init.dart';
import 'package:url_launcher/url_launcher.dart';


class ShowNotify{

  final title;
  final message;
  int id;
  final link;
  final type;
  final drId;
  final topicId;
  final experienceId;
  final ticketId;
  final categoryId;
  final String? groupName;

  ShowNotify({this.title,this.message,required this.id,this.link,this.type,this.drId
    ,this.topicId,this.experienceId,this.ticketId,this.categoryId,this.groupName});

  int count=0;
//  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  show()async{
//
//      var initializationSettingsAndroid = new AndroidInitializationSettings('impo_icon');
//      var initializationSettingsIOS = new IOSInitializationSettings();
//      var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
//      flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: selectedNotification);

    var count = new Random();
    var androidChannel = AndroidNotificationDetails(
      'channel_id$id' , groupName!,
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.max,
      vibrationPattern: Int64List(1000),
      largeIcon: DrawableResourceAndroidBitmap('impo_icon'),
      icon: "not_icon",
      sound: RawResourceAndroidNotificationSound('sound_other'),
      styleInformation: BigTextStyleInformation(''),
    );

    var iosChannel = DarwinNotificationDetails();

    NotificationDetails platformChannel = NotificationDetails(android: androidChannel,iOS: iosChannel);

    // print('counttt');
    print(type);
    print(type.runtimeType);
    await NotificationInit.getGlobal().getNotify().show(
        id, title, message , platformChannel,
        payload: link != '' ? 'link*$link*' :
        type == '72' ? 'type*$type*$topicId*$experienceId*' :
        type == '20' || type == '121' ? 'type*$type*$ticketId*$categoryId*' :
        type != '0' && type != '72' && type != '20' && type != '121' ? 'type*$type*$drId*' :
        '*$message*تایید',
    );


  }

//  Future selectedNotification(String payload) async {
//    print('dfbfdbfdbfdbfdbfdbfd');
//    if(payload != ''){
//      _launchURL(link);
//    }
//
//  }
//
//  _launchURL(url) async {
//    if (await canLaunch(url)) {
//      await launch(url);
//    } else {
//      throw 'Could not launch $url';
//    }
//  }

}