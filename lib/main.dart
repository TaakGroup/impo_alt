import 'dart:async';
import 'dart:io';

import 'package:adtrace_sdk_flutter/adtrace.dart';
import 'package:adtrace_sdk_flutter/adtrace_config.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:impo/initial_bindings.dart';
import 'package:impo/routes.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/show_notify.dart';
import 'package:impo/src/core/app.dart';
import 'package:impo/src/core/app/constans/app_routes.dart';
import 'package:impo/src/core/app/constans/messages.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/singleton/alarm_manager_init.dart';
import 'package:impo/src/singleton/notification_init.dart';
import 'package:impo/src/screens/splash_screen.dart';
import 'package:impo/src/core/app/view/themes/theme.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social/features/messenger/controller/messenger_controller.dart';

///0=direct / 1=cafe  / 2=myket
// const int typeStore  = 0; //direct
// const int typeStore = 1; //cafe
const int typeStore = 2;    //myket


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();

}

class _AppState extends State<_App> {

   // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


  @override
  void initState() {
//    _initLocalNotifications();
    _initFirebaseMessaging();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Color(0xffffffff), //or set color with: Color(0xFF0000FF)
    ));

    return ScreenUtilInit(
      designSize: const Size(750, 1334),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_,child){
        return MaterialApp(
            title: 'Impo',
            // translations: Messages(),
            locale: const Locale('en', 'US'),
            navigatorKey: navigatorKey,
            // textDirection: TextDirection.rtl,
            debugShowCheckedModeBanner: false,
            // onInit: App.onAppStart,
            // initialBinding: InitialBindings(),
            // getPages: Routs.routs,
            // initialRoute: AppRoutes.splash,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,  // Add global cupertino localiztions.
            ],
            // locale: Locale('en', 'US'),// Current locale
            supportedLocales: [
              const Locale('fa', 'IR'), // Farsi
              const Locale('en', 'US'), // English
            ],
            builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                    alwaysUse24HourFormat: true,
                    textScaler: TextScaler.noScaling
                ), child: child!),
            theme: ImpoTheme.light,
            themeMode: ThemeMode.light,
            home: child
        );
      },
      child: SplashScreen(
        localPass: true,
        index: 4,
      ),
    );
  }

//  _initLocalNotifications() {
//    var initializationSettingsAndroid = new AndroidInitializationSettings('impo_icon');
//    var initializationSettingsIOS = new IOSInitializationSettings();
//    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
//    flutterLocalNotificationsPlugin.initialize(initializationSettings);
//  }

  getVersionAndroid()async{
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var sdkInt = androidInfo.version.sdkInt;
    return sdkInt;
  }

  showNotify(RemoteMessage message){
    ShowNotify(
//            plugin: flutterLocalNotificationsPlugin,
      title:  message.data['title'],
      message: message.data['message'],
      link: message.data['link'] != null ? message.data['link']: '',
      id: message.data['id'] != null ? int.parse(message.data['id']) : 200 ,
      type : message.data['type'] != null ?  message.data['type'] : 0,
      drId: message.data['DrId'] != null ?  message.data['DrId'] : '',
      topicId:  message.data['TopicId'] != null ?  message.data['TopicId'] : '',
      experienceId: message.data['ExperienceId'] != null ?  message.data['ExperienceId'] : '',
      ticketId: message.data['TicketId'] != null ?  message.data['TicketId'] : '',
      categoryId: message.data['CategoryId'] != null ?  message.data['CategoryId'] : '',
      groupName: message.data['groupName'] != null ? message.data['groupName'] : 'channel_name_impo'
    ).show();
  }

  _initFirebaseMessaging() async{
    //all_IOS
    // await FirebaseMessaging.instance.subscribeToTopic('impoClinicTest');
    await FirebaseMessaging.instance.subscribeToTopic('all');
    await FirebaseMessaging.instance.subscribeToTopic('dir');
    //
    // print('vvvvvvvv');
    // print(await getVersionAndroid());
    // bool isBatteryOptimizationDisabled = await DisableBatteryOptimization.isBatteryOptimizationDisabled;
    // print(isBatteryOptimizationDisabled);
    // if(!isBatteryOptimizationDisabled){
    //   await DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
    // }

    if(await getVersionAndroid() >= 33 ){
      final status = await Permission.notification.status;
      if (status != PermissionStatus.granted) {
        await Permission.notification.request();
      }
    }else{
      // FirebaseMessaging.instance.requestPermission(
      //   alert: true,
      //   badge: true,
      //   sound: true,);

    }

    await FirebaseMessaging.instance.getToken().then((String? token) async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // assert(token != null);
      prefs.setString('deviceToken', token != null ? token : '');
      print("deviceToken$token");
//      debugPrint(token);
    });

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );



    FirebaseMessaging.onMessage.listen((event) {
      debugPrint("onMessage: ${event.data}");
      if(event.data['type'] != null){
        if(event.data['type'] == '30'){
          if(!notReadMessage.isClosed){
            notReadMessage.sink.add(int.parse(event.data['count']));
          }
        }
      }

      if(event.data['type'] != null){
        if(event.data['type'] == '121'){
          try{
            if(MessengerController.to.chatId == event.data['TicketId']){
              MessengerController.to.refreshChat();
            }else{
              showNotify(event);
            }
          }catch(e){
            showNotify(event);
          }
        }else{
          showNotify(event);
        }
      }
      return;
    });


    if(Platform.isAndroid){
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      debugPrint("onLaunch: ${event.data}");
      return;
    });

//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
//         ShowNotify(
// //            plugin: flutterLocalNotificationsPlugin,
//             title:  message['data']['title'],
//             message: message['data']['message'],
//             link: message['data']['link'] != null ? message['data']['link']: '',
//             id: message['data']['id'],
//             type : message['data']['type'] != null ?  message['data']['type'] : 0,
//         ).show();
//         return;
//       },
//         onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//         return;
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
//         return;
//       },
//     );

//    if(Platform.isIOS){
//    }


  }

  @pragma('vm:entry-point')
  static Future<void> myBackgroundMessageHandler(RemoteMessage message) async{
    await Firebase.initializeApp();
   print(message.data);
   ShowNotify(
//      plugin: flutterLocalNotificationsPlugin,
        title:  message.data['title'],
        message: message.data['message'],
        link: message.data['link'] != null ? message.data['link']: '',
        id: message.data['id'] != null ? int.parse(message.data['id']) : 200 ,
        type : message.data['type'] != null ?  message.data['type'] : 0,
        drId: message.data['DrId'] != null ?  message.data['DrId'] : '',
        topicId:  message.data['TopicId'] != null ?  message.data['TopicId'] : '',
        experienceId: message.data['ExperienceId'] != null ?  message.data['ExperienceId'] : '',
        ticketId: message.data['TicketId'] != null ?  message.data['TicketId'] : '',
        categoryId: message.data['CategoryId'] != null ?  message.data['CategoryId'] : '',
        groupName: message.data['groupName'] != null ? message.data['groupName'] : 'channel_name_impo'
    ).show();
    // return Future<void>.value();
  }

}


void main()async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  NotificationInit.getGlobal().initLocalNotifications();
  if(Platform.isAndroid) AlarmManagerInit.getGlobal().initAlarm();
  // FirebaseCrashlytics.instance.enableInDevMode = true;
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // timeDilation = .5;
  // await FlutterDownloader.initialize(
  //     debug: true // optional: set false to disable printing logs to console
  // );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp(_App());

  });

}


// import 'dart:async';
// import 'dart:io';
//
// import 'package:audioplayers/audio_cache.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
//
// import 'player_widget.dart';
//
// typedef void OnError(Exception exception);
//
// const kUrl1 = 'https://luan.xyz/files/audio/ambient_c_motion.mp3';
// const kUrl2 = 'https://luan.xyz/files/audio/nasa_on_a_mission.mp3';
// const kUrl3 = 'http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio1xtra_mf_p';
//
// void main() {
//   runApp(GetMaterialApp(home: ExampleApp()));
// }
//
// class ExampleApp extends StatefulWidget {
//   @override
//   _ExampleAppState createState() => _ExampleAppState();
// }
//
// class _ExampleAppState extends State<ExampleApp> {
//   AudioCache audioCache = AudioCache();
//   AudioPlayer advancedPlayer = AudioPlayer();
//   String localFilePath;
//
//   @override
//   void initState() {
//     super.initState();
//
//     if (kIsWeb) {
//       // Calls to Platform.isIOS fails on web
//       return;
//     }
//     if (Platform.isIOS) {
//       if (audioCache.fixedPlayer != null) {
//         audioCache.fixedPlayer.startHeadlessService();
//       }
//       advancedPlayer.startHeadlessService();
//     }
//   }
//
//   Future _loadFile() async {
//     final bytes = await readBytes(kUrl1);
//     final dir = await getApplicationDocumentsDirectory();
//     final file = File('${dir.path}/audio.mp3');
//
//     await file.writeAsBytes(bytes);
//     if (await file.exists()) {
//       setState(() {
//         localFilePath = file.path;
//       });
//     }
//   }
//
//   Widget remoteUrl() {
//     return SingleChildScrollView(
//       child: _Tab(children: [
//         Text(
//           'Sample 1 ($kUrl1)',
//           key: Key('url1'),
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         PlayerWidget(url: kUrl1),
//         Text(
//           'Sample 2 ($kUrl2)',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         PlayerWidget(url: kUrl2),
//         Text(
//           'Sample 3 ($kUrl3)',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         PlayerWidget(url: kUrl3),
//         Text(
//           'Sample 4 (Low Latency mode) ($kUrl1)',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         PlayerWidget(url: kUrl1, mode: PlayerMode.LOW_LATENCY),
//       ]),
//     );
//   }
//
//   Widget localFile() {
//     return _Tab(children: [
//       Text('File: $kUrl1'),
//       _Btn(txt: 'Download File to your Device', onPressed: () => _loadFile()),
//       Text('Current local file path: $localFilePath'),
//       localFilePath == null
//           ? Container()
//           : PlayerWidget(
//         url: localFilePath,
//       ),
//     ]);
//   }
//
//   Widget localAsset() {
//     return SingleChildScrollView(
//       child: _Tab(children: [
//         Text('Play Local Asset \'audio.mp3\':'),
//         _Btn(txt: 'Play', onPressed: () => audioCache.play('audio.mp3')),
//         Text('Play Local Asset (via byte source) \'audio.mp3\':'),
//         _Btn(
//           txt: 'Play',
//           onPressed: () async {
//             var bytes =
//             await (await audioCache.load('audio.mp3')).readAsBytes();
//             audioCache.playBytes(bytes);
//           },
//         ),
//         Text('Loop Local Asset \'audio.mp3\':'),
//         _Btn(txt: 'Loop', onPressed: () => audioCache.loop('audio.mp3')),
//         Text('Loop Local Asset (via byte source) \'audio.mp3\':'),
//         _Btn(
//           txt: 'Loop',
//           onPressed: () async {
//             var bytes =
//             await (await audioCache.load('audio.mp3')).readAsBytes();
//             audioCache.playBytes(bytes, loop: true);
//           },
//         ),
//         Text('Play Local Asset \'audio2.mp3\':'),
//         _Btn(txt: 'Play', onPressed: () => audioCache.play('audio2.mp3')),
//         Text('Play Local Asset In Low Latency \'audio.mp3\':'),
//         _Btn(
//           txt: 'Play',
//           onPressed: () =>
//               audioCache.play('audio.mp3', mode: PlayerMode.LOW_LATENCY),
//         ),
//         Text('Play Local Asset Concurrently In Low Latency \'audio.mp3\':'),
//         _Btn(
//             txt: 'Play',
//             onPressed: () async {
//               await audioCache.play('audio.mp3', mode: PlayerMode.LOW_LATENCY);
//               await audioCache.play('audio2.mp3', mode: PlayerMode.LOW_LATENCY);
//             }),
//         Text('Play Local Asset In Low Latency \'audio2.mp3\':'),
//         _Btn(
//           txt: 'Play',
//           onPressed: () =>
//               audioCache.play('audio2.mp3', mode: PlayerMode.LOW_LATENCY),
//         ),
//         getLocalFileDuration(),
//       ]),
//     );
//   }
//
//   Future<int> _getDuration() async {
//     File audiofile = await audioCache.load('audio2.mp3');
//     await advancedPlayer.setUrl(
//       audiofile.path,
//     );
//     int duration = await Future.delayed(
//       Duration(seconds: 2),
//           () => advancedPlayer.getDuration(),
//     );
//     return duration;
//   }
//
//   getLocalFileDuration() {
//     return FutureBuilder<int>(
//       future: _getDuration(),
//       builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.none:
//             return Text('No Connection...');
//           case ConnectionState.active:
//           case ConnectionState.waiting:
//             return Text('Awaiting result...');
//           case ConnectionState.done:
//             if (snapshot.hasError) return Text('Error: ${snapshot.error}');
//             return Text(
//               'audio2.mp3 duration is: ${Duration(milliseconds: snapshot.data)}',
//             );
//         }
//         return null; // unreachable
//       },
//     );
//   }
//
//   Widget notification() {
//     return _Tab(children: [
//       Text('Play notification sound: \'messenger.mp3\':'),
//       _Btn(
//         txt: 'Play',
//         onPressed: () => audioCache.play('messenger.mp3', isNotification: true),
//       ),
//     ]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         StreamProvider<Duration>.value(
//             initialData: Duration(),
//             value: advancedPlayer.onAudioPositionChanged),
//       ],
//       child: DefaultTabController(
//         length: 5,
//         child: Scaffold(
//           appBar: AppBar(
//             bottom: TabBar(
//               tabs: [
//                 Tab(text: 'Remote Url'),
//                 Tab(text: 'Local File'),
//                 Tab(text: 'Local Asset'),
//                 Tab(text: 'Notification'),
//                 Tab(text: 'Advanced'),
//               ],
//             ),
//             title: Text('audioplayers Example'),
//           ),
//           body: TabBarView(
//             children: [
//               remoteUrl(),
//               localFile(),
//               localAsset(),
//               notification(),
//               Advanced(
//                 advancedPlayer: advancedPlayer,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Advanced extends StatefulWidget {
//   final AudioPlayer advancedPlayer;
//
//   const Advanced({Key key, this.advancedPlayer}) : super(key: key);
//
//   @override
//   _AdvancedState createState() => _AdvancedState();
// }
//
// class _AdvancedState extends State<Advanced> {
//   bool seekDone;
//
//   @override
//   void initState() {
//     widget.advancedPlayer.seekCompleteHandler =
//         (finished) => setState(() => seekDone = finished);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final audioPosition = Provider.of<Duration>(context);
//     return SingleChildScrollView(
//       child: _Tab(
//         children: [
//           Column(
//             children: [
//               Text('Source Url'),
//               Row(children: [
//                 _Btn(
//                   txt: 'Audio 1',
//                   onPressed: () => widget.advancedPlayer.setUrl(kUrl1),
//                 ),
//                 _Btn(
//                   txt: 'Audio 2',
//                   onPressed: () => widget.advancedPlayer.setUrl(kUrl2),
//                 ),
//                 _Btn(
//                   txt: 'Stream',
//                   onPressed: () => widget.advancedPlayer.setUrl(kUrl3),
//                 ),
//               ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
//             ],
//           ),
//           Column(
//             children: [
//               Text('Release Mode'),
//               Row(children: [
//                 _Btn(
//                   txt: 'STOP',
//                   onPressed: () =>
//                       widget.advancedPlayer.setReleaseMode(ReleaseMode.STOP),
//                 ),
//                 _Btn(
//                   txt: 'LOOP',
//                   onPressed: () =>
//                       widget.advancedPlayer.setReleaseMode(ReleaseMode.LOOP),
//                 ),
//                 _Btn(
//                   txt: 'RELEASE',
//                   onPressed: () =>
//                       widget.advancedPlayer.setReleaseMode(ReleaseMode.RELEASE),
//                 ),
//               ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
//             ],
//           ),
//           Column(
//             children: [
//               Text('Volume'),
//               Row(
//                 children: [0.0, 0.5, 1.0, 2.0].map((e) {
//                   return _Btn(
//                     txt: e.toString(),
//                     onPressed: () => widget.advancedPlayer.setVolume(e),
//                   );
//                 }).toList(),
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               ),
//             ],
//           ),
//           Column(
//             children: [
//               Text('Control'),
//               Row(
//                 children: [
//                   _Btn(
//                     txt: 'resume',
//                     onPressed: () => widget.advancedPlayer.resume(),
//                   ),
//                   _Btn(
//                     txt: 'pause',
//                     onPressed: () => widget.advancedPlayer.pause(),
//                   ),
//                   _Btn(
//                     txt: 'stop',
//                     onPressed: () => widget.advancedPlayer.stop(),
//                   ),
//                   _Btn(
//                     txt: 'release',
//                     onPressed: () => widget.advancedPlayer.release(),
//                   ),
//                 ],
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               ),
//             ],
//           ),
//           Column(
//             children: [
//               Text('Seek in milliseconds'),
//               Row(
//                 children: [
//                   _Btn(
//                       txt: '100ms',
//                       onPressed: () {
//                         widget.advancedPlayer.seek(
//                           Duration(
//                             milliseconds: audioPosition.inMilliseconds + 100,
//                           ),
//                         );
//                         setState(() => seekDone = false);
//                       }),
//                   _Btn(
//                       txt: '500ms',
//                       onPressed: () {
//                         widget.advancedPlayer.seek(
//                           Duration(
//                             milliseconds: audioPosition.inMilliseconds + 500,
//                           ),
//                         );
//                         setState(() => seekDone = false);
//                       }),
//                   _Btn(
//                       txt: '1s',
//                       onPressed: () {
//                         widget.advancedPlayer.seek(
//                           Duration(seconds: audioPosition.inSeconds + 1),
//                         );
//                         setState(() => seekDone = false);
//                       }),
//                   _Btn(
//                       txt: '1.5s',
//                       onPressed: () {
//                         widget.advancedPlayer.seek(
//                           Duration(
//                             milliseconds: audioPosition.inMilliseconds + 1500,
//                           ),
//                         );
//                         setState(() => seekDone = false);
//                       }),
//                 ],
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               ),
//             ],
//           ),
//           Column(
//             children: [
//               Text('Rate'),
//               Row(
//                 children: [0.5, 1.0, 1.5, 2.0].map((e) {
//                   return _Btn(
//                     txt: e.toString(),
//                     onPressed: () {
//                       widget.advancedPlayer.setPlaybackRate(playbackRate: e);
//                     },
//                   );
//                 }).toList(),
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               ),
//             ],
//           ),
//           Text('Audio Position: ${audioPosition}'),
//           if (seekDone != null) Text(seekDone ? 'Seek Done' : 'Seeking...'),
//         ],
//       ),
//     );
//   }
// }
//
// class _Tab extends StatelessWidget {
//   final List<Widget> children;
//
//   const _Tab({Key key, this.children}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         alignment: Alignment.topCenter,
//         padding: EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: children
//                 .map((w) => Container(child: w, padding: EdgeInsets.all(6.0)))
//                 .toList(),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _Btn extends StatelessWidget {
//   final String txt;
//   final VoidCallback onPressed;
//
//   const _Btn({Key key, this.txt, this.onPressed}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ButtonTheme(
//       minWidth: 48.0,
//       child: RaisedButton(child: Text(txt), onPressed: onPressed),
//     );
//   }
// }