import 'dart:async';
import 'dart:io';
import 'package:adtrace_sdk_flutter/adtrace.dart';
import 'package:adtrace_sdk_flutter/adtrace_config.dart';
import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter_poolakey/flutter_poolakey.dart';
import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/data/auto_backup.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/data/local/save_data_offline_mode.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/data/messages/generate_dashboard_notify_and_messages.dart';
import 'package:impo/src/models/advertise_model.dart';
import 'package:impo/src/models/dashboard/dashboard_messages_and_notify_model.dart';
import 'package:impo/src/models/partner/partner_model.dart';
import 'package:impo/src/models/profile/profile_all_data_model.dart';
import 'package:impo/src/models/register/circles_send_server_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/models/signsModel/breastfeeding_signs_model.dart';
import 'package:impo/src/models/signsModel/pregnancy_signs_model.dart';
import 'package:impo/src/models/story_model.dart';
import 'package:impo/src/screens/LoginAndRegister/identity/enter_number_screen.dart';
import 'package:impo/src/screens/home/home.dart';
import 'package:impo/src/screens/LoginAndRegister/enter_pass_screen.dart';
import 'package:impo/src/screens/offlineMode/offline_dashboard_screen.dart';
import 'package:impo/src/screens/subscribe/choose_subscription_page.dart';
import 'package:impo/src/singleton/payload.dart';
import 'package:impo/src/core/app/view/themes/theme.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:myket_iap/myket_iap.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:story_view/story_view.dart';
import 'package:uni_links/uni_links.dart';
import '../components/splash_text_stagger_animation.dart';
import '../core/app/Utiles/helper/version_to_int.dart';
import '../models/bioRhythm/bio_model.dart';
import '../models/bottom_banner_model.dart';
import 'LoginAndRegister/identity/forgot_password_screen.dart';


class SplashScreen extends  StatefulWidget{

    final localPass;
    final index;
//  final payload;
//
  SplashScreen({Key? key,this.localPass,this.index}):super(key:key);

  @override
  State<StatefulWidget> createState() => SplashScreenState();

}

class SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin,WidgetsBindingObserver{

  bool _visible = false;
  bool isNet = true;
  String errorMessage = '';
  var registerInfo = locator<RegisterParamModel>();
  bool isAddPregnancyCycle = false;
  /// DataBaseProvider db  = new DataBaseProvider();
  late AnimationController lottieController;
  late AnimationController splashTextController;
  @override
  void initState() {
    initUniLinks();
    setAnim();
    lottieController = AnimationController(vsync: this);
    splashTextController = AnimationController(duration: Duration(milliseconds: 2000),vsync: this);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initAdTrace();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  static initAdTrace(){
    AdTraceConfig config =  AdTraceConfig('fz46npxzwfu1', AdTraceEnvironment.sandbox);
    // config.logLevel = AdTraceLogLevel.verbose;
    print(config.defaultTracker);
    print(config.urlStrategy);
    print(config.preinstallFilePath);
    // config.launchDeferredDeeplink = true;
    // config.deferredDeeplinkCallback = (String? uri) {
    //   toast(message: '[AdTrace]: Received deferred deeplink: ' + uri!);
    //   print('[AdTrace]: Received deferred deeplink: ' + uri);
    //
    // };
    AdTrace.start(config);
    print('StartAdTrace');
  }
  // ignore: cancel_subscriptions
  late StreamSubscription _uniLinkSub;

  Future<Null> initUniLinks() async {

    await _getInitialUniLinks(null);

    _uniLinkSub = uriLinkStream.listen((Uri? uri)async{

      await _getInitialUniLinks(uri);

    }, onError: (err) {

    });

  }

  Future _getInitialUniLinks(Uri? uri) async {
    try {
      final Uri? targetUri = uri ?? await getInitialUri();
      if (targetUri != null) {
        try {
          Map res = targetUri.queryParameters;
          String type = res['type'] != null ? res['type'] : '';
          String drId = res['DrId'] != null ? res['DrId'] : '';

          if(type != ''){
            Payload.getGlobal().setPayload('type*$type*$drId*');
            runApp(
                MaterialApp(
                  title: 'Impo',
                  debugShowCheckedModeBanner: false,
                  builder: (context, Widget? child) =>
                      MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!),
                  theme: ImpoTheme.light,
                  home: SplashScreen(
                    localPass: true,
                    index: 2,
                  ),
                )
            );
          }

        } on FormatException {
          //do nothing
        }
      }
    } on FormatException {
      //do nothing
    }
  }

  setAnim()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isAnim',true);
    if(prefs.getBool('isLocalNotify') == null){
      prefs.setBool('isLocalNotify', true);
    }
    /// if(prefs.getBool('isChangeSignWoman') == null){
    ///   prefs.setBool('isChangeSignWoman',false);
    /// }
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        AdTrace.onResume();
        break;
      case AppLifecycleState.paused:
        AdTrace.onPause();
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return  Scaffold(
        backgroundColor: ColorPallet().mainColor,
        body:  Center(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Lottie.asset(
                    'assets/json/splash_logo.json',
                    fit: BoxFit.cover,
                    controller: lottieController,
                    onLoaded: (composition) {
                      // Configure the AnimationController with the duration of the
                      // Lottie file and start the animation.
                      lottieController..duration = composition.duration..forward();
                      Timer(Duration(seconds: 1),()async {
                        await splashTextController.forward();
                        checkTheLogin();
                      });
                    },
                    repeat: false,
                    width: MediaQuery.of(context).size.width/2.5,
                  ),
              SplashTextStaggerAnimation(
                animationController: splashTextController,
              ),
              !isNet ?
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.only(
                        bottom: ScreenUtil().setWidth(80)
                    ),
                    child:  CustomButton(
                      title: 'تلاش مجدد',
                      margin: 120,
                      borderRadius: 10.0,
                      colors: [Colors.white.withOpacity(0.2),Colors.white.withOpacity(0.2)],
                      onPress: (){
                        checkTheLogin();
                      },
                      enableButton: true,
                    ),
                ),
              )
                  :
              Container(),
            ],
          ),
        )
    );

  }



  checkTheLogin()async{

    Timer(Duration(milliseconds: 300),(){
      if(mounted){
        setState(() {
          _visible = !_visible;
        });
      }
    });

    // Timer(Duration(milliseconds: 2600),()async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.getString('pass') == null){
        if(prefs.getString('userName') != null){
          login(false);
        }else{
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  duration: Duration(seconds: 1),
                  child: EnterNumberScreen(
                  )
              )
          );
        }
      }else{
        login(true);
      }


    // });

  }



  login(bool isLocalPass)async{
    String phoneModel = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    if(Platform.isAndroid){
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      phoneModel = androidInfo.model;
    }else{
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      phoneModel = iosInfo.model;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceToken = prefs.getString('deviceToken') != null  ? prefs.getString('deviceToken')  : '' ;
    String userName = prefs.getString('userName')!;
    String password = prefs.getString('password')!;

    String channelVersion = '';

    try{
      AppInfo app = await InstalledApps.getAppInfo('com.farsitel.bazaar');
      channelVersion = app.versionName;
    }catch(e){
      print('Cafe Bazar not installed');
    }

    if(this.mounted){
      setState(() {
        isNet = true;
      });
    }
    // print(userName);
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        identityUrl,
        'customerAccount/loginv6',
        'POST',
        {
          "identity" : userName,
          "password" : password,
          "phoneModel"  : phoneModel,
          "deviceToken" : deviceToken,
          "version" : version,
          "ChannelVersion" : channelVersion
        },
        ''
    );
    print(responseBody);
    if(responseBody != null){
      if(responseBody.isNotEmpty){
        if(responseBody['result']){
           // await initCafeBazar();
           await initMyket();
            String infoController = getInfoAndSetStatus(responseBody['status'],prefs);
            prefs.setString('interfaceCode', responseBody['interfaceCode']);
            prefs.setString('interfaceText', responseBody['interfaceText']);
            prefs.setBool('interfaceVisibility',responseBody['interfaceVisibility']);
            prefs.setInt('endTimeWomanSubscribe',responseBody['endTimeWomanSubscribe']);
            prefs.setBool('womansubscribtion',responseBody['womansubscribtion']);
            prefs.setBool('showComment', responseBody['showComment']);
            prefs.setBool('showExperience',responseBody['showExperience']);
            if(!notReadMessage.isClosed){
              notReadMessage.sink.add(responseBody['messageNotRead']);
            }
            if(await AutoBackup().checkAlarmDaily(responseBody['token'])){
              await getAllData(responseBody['token'],isLocalPass,infoController,responseBody['status'],responseBody['womansubscribtion']);
            }else{
              showError('خطا در برقراری اتصال، اینترنت خود را بررسی کنید',isLocalPass);
            }
        }else{
          await isRegisterStatus(userName,context,isLocalPass);
        }

      }else{
        showError('خطا در برقراری اتصال، اینترنت خود را بررسی کنید',isLocalPass);
      }

    }else{
      showError('خطا در برقراری اتصال، اینترنت خود را بررسی کنید',isLocalPass);

    }

  }



  String getInfoAndSetStatus(int status,SharedPreferences prefs){
    registerInfo.setStatus(status);
    String infoController;
    if(status == 2){
      infoController = 'pregnancyInfo';
    }else if(status == 3){
      infoController = 'breastfeedingInfo';
    }else{
      infoController = 'info';
    }
    prefs.setString('infoController', infoController);
    return infoController;
  }

  isRegisterStatus(String? value,context,bool isLocalPass)async{

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        identityUrl,
        'customerAccount/status/$value',
        'GET',
        {

        },
        ''
    );

    // print(responseBody);

    if(responseBody != null){
      if(responseBody.isNotEmpty){
        if(responseBody['isRegister']){
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child:  ForgotPasswordScreen(
                    userName: value  != null ?  value : '',
                    isBack: false,
                  )
              )
          );
        }else{
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  duration: Duration(seconds: 1),
                  child: EnterNumberScreen(
                    value: value,
                  )
              )
          );
          // setIdentity(value,animations,context,typeValue,hasCircles);
          // verifyUser(value, context, animations, randomMessage);
        }
      }else{
        showError('خطا در برقراری اتصال، اینترنت خود را بررسی کنید',isLocalPass);
      }
    }else{
      showError('خطا در برقراری اتصال، اینترنت خود را بررسی کنید',isLocalPass);
    }

  }

  Future<bool> getAllData(String token,bool isLocalPass,String infoController,int status,bool womansubscribtion)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        '$infoController/allDatav6',
        'GET',
        {},
        token
    );
    // print(infoController);
    // print(responseBody);
    if(responseBody != null){

      //getRegister
      DateTime date = DateTime(
        DateTime.parse(responseBody['generalInfo']['birthDate']).year,
        DateTime.parse(responseBody['generalInfo']['birthDate']).month,
        DateTime.parse(responseBody['generalInfo']['birthDate']).day,
      );
      Jalali _jalaliDate = Jalali.fromDateTime(date);
      RegisterParamViewModel registerParamViewModel = RegisterParamViewModel(
        status: status,
        birthDay: _jalaliDate.toString().replaceAll('Jalali', '').replaceAll('(', '').replaceAll(')', ''),
        sex: responseBody['generalInfo']['sexualStatus'],
        nationality: responseBody['generalInfo']['nationality'] == 1 ? 'AF' : 'IR',
        name: responseBody['generalInfo']['name'],
        token: token,
        calendarType: responseBody['generalInfo']['calendarType'],
        signText: responseBody['signText'],
        periodStatus :  responseBody['generalInfo']['periodStatus'],

        // periodDay: status == 1 ? responseBody['cycleInfo']['periodLength'] : null,
        // circleDay: status == 1 ?  responseBody['cycleInfo']['totalLength'] : null ,
        // lastPeriod: status == 1 ? responseBody['cycleInfo']['startDate'] : null,

        periodDay: responseBody['cycleInfo']['periodLength'],
        circleDay: responseBody['cycleInfo']['totalLength']  ,
        lastPeriod: responseBody['cycleInfo']['startDate'],

        isDeliveryDate: status == 2 || status == 3  ? responseBody['pregnancyInfo']['isDeliveryDate'] : null ,
        pregnancyDate: status == 2 || status == 3 ? DateTime.parse(responseBody['pregnancyInfo']['pregnancyDate']) : null ,
        pregnancyNo: status == 2 || status == 3 ? responseBody['pregnancyInfo']['pregnancyNo'] : null ,
        hasAboration: status == 2 || status == 3 ? responseBody['pregnancyInfo']['hasAboration'] : null,

        childType: status == 3 ? responseBody['breastfeedingInfo']['childType'] : null,
        childBirthType: status == 3 ? responseBody['breastfeedingInfo']['childBirthType'] : null,
        childBirthDate: status == 3 ? DateTime.parse(responseBody['breastfeedingInfo']['childBirthDate']): null,
        childName: status == 3 ? responseBody['breastfeedingInfo']['childName'] : null,

      );
      // print(registerParamViewModel);
      // {
      //   'name' : responseBody['generalInfo']['name'],
      //   'periodDay' : responseBody['cycleInfo']['periodLength'],
      //   'circleDay' :  responseBody['cycleInfo']['totalLength'],
      //   'lastPeriod' : responseBody['cycleInfo']['startDate'],
      //   'birthDay' : _jalaliDate.toString().replaceAll('Jalali', '').replaceAll('(', '').replaceAll(')', ''),
      //   'typeSex' :  responseBody['generalInfo']['sexualStatus'],
      //   'nationality' : responseBody['generalInfo']['nationality'] == 1 ? 'AF' : 'IR',
      //   'token' :   token,
      //   'calendarType' : responseBody['generalInfo']['calendarType']
      // };
      var register = locator<RegisterParamModel>();
      register.setAllRegister(registerParamViewModel);

      //getIsPair
      prefs.setBool('pair', !responseBody['pairData']['validToken']);


      //getCycleCalendar
      var cycle = locator<CycleModel>();
      if(responseBody['cycleCalendars'] != null ){
        if(responseBody['cycleCalendars'].length != 0){
          if(cycle.cycle.isNotEmpty) cycle.removeAllCycles();
          for(int i = 0 ; i<responseBody['cycleCalendars'].length ; i++){
            if(i == responseBody['cycleCalendars'].length - 1){
              List<List<int>> womanSigns = decimalToSignWoman(responseBody['sign']);
              cycle.addCycle(
                  {
                    'periodStartDate' : responseBody['cycleCalendars'][i]['periodStartDate'],
                    'periodEndDate' :  responseBody['cycleCalendars'][i]['periodEndDate'],
                    'cycleEndDate' :  responseBody['cycleCalendars'][i]['cycleEndDate'],
                    'status' : responseBody['cycleCalendars'][i]['status'],
                    'before' : status == 1 ? womanSigns[0].toString() : '',
                    'after' :  status == 1 ? womanSigns[1].toString(): '',
                    'mental' :  status == 1 ? womanSigns[2].toString(): '',
                    'other' :  status == 1 ? womanSigns[3].toString(): '',
                    'ovu' :  status == 1 ? womanSigns[4].toString(): '',
                  }
              );
            }else{
              cycle.addCycle(
                  {
                    'periodStartDate' : responseBody['cycleCalendars'][i]['periodStartDate'],
                    'periodEndDate' :  responseBody['cycleCalendars'][i]['periodEndDate'],
                    'cycleEndDate' :  responseBody['cycleCalendars'][i]['cycleEndDate'],
                    'status' : responseBody['cycleCalendars'][i]['status'],
                    'before' : '',
                    'after' : '',
                    'mental' : '',
                    'other' : '',
                    'ovu' : ''
                  }
              );
            }
          }
        }
      }

      if(status == 2){
         List<List<int>> pregnancySigns = decimalToPregnancySigns(responseBody['sign']);
        // List<List<int>> pregnancySigns = decimalToPregnancySigns(22906492245);
        // print('pregnancySigns : $pregnancySigns');
        var pregnancySignsInfo = locator<PregnancySignsModel>();
         pregnancySignsInfo.setFetalSex(pregnancySigns[0]);
         pregnancySignsInfo.setPhysical(pregnancySigns[1]);
         pregnancySignsInfo.setPhysicalPregnancy(pregnancySigns[2]);
         pregnancySignsInfo.setGastrointestinalPregnancy(pregnancySigns[3]);
         pregnancySignsInfo.setPsychologyPregnancy(pregnancySigns[4]);

      }else if(status == 3){
        List<List<int>> breastfeedingSigns = decimalToBreastfeeding(responseBody['sign']);
        var breastfeedingInfo = locator<BreastfeedingSignsModel>();
        breastfeedingInfo.setBabySigns(breastfeedingSigns[0]);
        breastfeedingInfo.setPhysical(breastfeedingSigns[1]);
        breastfeedingInfo.setBreastfeedingMother(breastfeedingSigns[2]);
        breastfeedingInfo.setPsychology(breastfeedingSigns[3]);
      }

      //getWomanSings
      // List<List<int>> womanSigns = decimalToSignWoman(responseBody['sign']);
      // if(womanSigns.isNotEmpty){
      //   cycle.cycle[cycle.cycle.length-1].setBefore(womanSigns[0].toString());
      //   cycle.cycle[cycle.cycle.length-1].setAfter(womanSigns[1].toString());
      //   cycle.cycle[cycle.cycle.length-1].setMental(womanSigns[2].toString());
      //   cycle.cycle[cycle.cycle.length-1].setOther(womanSigns[3].toString());
      //   cycle.cycle[cycle.cycle.length-1].setOvu(womanSigns[4].toString());
      // }

      //getPartner
      var partnerInfo = locator<PartnerModel>();
      partnerInfo.addPartner(
          {
            'isPair'  : !responseBody['pairData']['validToken'],
            'token' : responseBody['pairData']['token'],
            'time' : responseBody['pairData']['time'],
            'manName' : responseBody['pairData']['manName'],
            'birtDate' : responseBody['pairData']['birtDate'],
            'createTime' : responseBody['pairData']['createTime'],
            'distanceType' : responseBody['pairData']['distanceType'],
            'text' : responseBody['pairData']['text'],
            'shareText' : responseBody['pairData']['shareText'],
            'downloadText' : responseBody['pairData']['downloadText'],
            'directDownloadLink' : responseBody['pairData']['directDownloadLink'],
            'googleDownloadLink' : responseBody['pairData']['googleDownloadLink'],
          }
      );

      var allDashboardMessageInfo =  locator<AllDashBoardMessageAndNotifyModel>();
      allDashboardMessageInfo.removeAllMessageAndNotifies();
      //getMotivalMessage
      if(responseBody['motival'] != []){
        for(int i=0 ; i<responseBody['motival'].length ; i++){
          allDashboardMessageInfo.addMotivalMessage(
              {
                'id' : responseBody['motival'][i]['id'],
                'text' : responseBody['motival'][i]['text'],
                'isPin' : responseBody['motival'][i]['isPin'],
                'link' : responseBody['motival'][i]['link'],
                'typeLink' : responseBody['motival'][i]['typeLink'],
              }
          );
        }
      }

      //getDashboardMessage
      if(responseBody['dashboardMessages'] != []){
        for(int i=0 ; i<responseBody['dashboardMessages'].length ; i++){
          allDashboardMessageInfo.addParentDashBoardMessage(
              {
                'id' : i,
                'timeId' : responseBody['dashboardMessages'][i]['timeId'],
                'timeSend' : responseBody['dashboardMessages'][i]['timeSend'],
                'condition' : responseBody['dashboardMessages'][i]['condition'],
                'womanSign' : responseBody['dashboardMessages'][i]['womanSign'],
                'sexual' : responseBody['dashboardMessages'][i]['sexual'],
                'age' : responseBody['dashboardMessages'][i]['age'],
                'distance' : responseBody['dashboardMessages'][i]['distance'],
                'birth' : responseBody['dashboardMessages'][i]['birth'],
                'single' : responseBody['dashboardMessages'][i]['single'],
                'abortionHistory' : responseBody['dashboardMessages'][i]['abortionHistory'],
                'pregnancyCount' : responseBody['dashboardMessages'][i]['pregnancyCount'],
                'childType': responseBody['dashboardMessages'][i]['childType'],
                'childBirthType': responseBody['dashboardMessages'][i]['childBirthType'],
                'dashboardMessages' : responseBody['dashboardMessages'][i]['dashboardMessages']
              },
            status
          );
        }
      }

      //getNotifies
      if(responseBody['notifies'] != []){
        for(int i=0 ; i<responseBody['notifies'].length ; i++){
          allDashboardMessageInfo.addParentNotify(
            {
              'id' : i,
              'timeId' : responseBody['notifies'][i]['timeId'],
              'timeSend' : responseBody['notifies'][i]['timeSend'],
              'condition' : responseBody['notifies'][i]['condition'],
              'womanSign' : responseBody['notifies'][i]['womanSign'],
              'sexual' : responseBody['notifies'][i]['sexual'],
              'age' : responseBody['notifies'][i]['age'],
              'day' : responseBody['notifies'][i]['day'],
              'distance' : responseBody['notifies'][i]['distance'],
              'birth' : responseBody['notifies'][i]['birth'],
              'single' : responseBody['notifies'][i]['single'],
              'abortionHistory' : responseBody['notifies'][i]['abortionHistory'],
              'pregnancyCount' : responseBody['notifies'][i]['pregnancyCount'],
              'monthName' : responseBody['notifies'][i]['monthName'],
              'childType': responseBody['notifies'][i]['childType'],
              'childBirthType': responseBody['notifies'][i]['childBirthType'],
              'notifies' : responseBody['notifies'][i]['notifies']
            },
              status
          );
        }
      }


      //getNotes
      // if(responseBody['notes'] != []){
      //   for(int i=0; i<responseBody['notes'].length ; i++){
      //     await db.insertDb(
      //         {
      //           'date' : responseBody['notes'][i]['time'],
      //           'hour' : DateTime.parse(responseBody['notes'][i]['time']).hour,
      //           'minute' : DateTime.parse(responseBody['notes'][i]['time']).minute,
      //           'text' : responseBody['notes'][i]['title'],
      //           'description' : responseBody['notes'][i]['text'],
      //           'isActive' : responseBody['notes'][i]['reminder'] ? 1 : 0,
      //           'serverId' : responseBody['notes'][i]['noteId'],
      //           'fileName' : responseBody['notes'][i]['fileName'].toString().replaceAll('[','').replaceAll(']','').replaceAll(',', ''),
      //           'isChange' : 0,
      //           'mode' : 0,
      //           'readFlag' : 1
      //         },
      //         'Alarms');
      //   }
      // }

      //getDailyAlarms

      // if(responseBody['alrams'] != []){
      //   for(int i=0; i<responseBody['alrams'].length ; i++){
      //     await db.insertDb(
      //         {
      //           'id' : int.parse(responseBody['alrams'][i]['clientId']),
      //           'title' : responseBody['alrams'][i]['title'],
      //           'mode' : responseBody['alrams'][i]['mode'],
      //           'isSound' : responseBody['alrams'][i]['sound'] ? 1 : 0,
      //           'time' : TimeOfDay(hour: DateTime.parse(responseBody['alrams'][i]['time']).hour, minute: DateTime.parse(responseBody['alrams'][i]['time']).minute).format(context),
      //           'dayWeek' : decimalToDayWeek(responseBody['alrams'][i]['days']),
      //           'serverId' : responseBody['alrams'][i]['alramId'],
      //           'isChange' : 0
      //         },
      //         'DailyReminders');
      //   }
      // }


      //getAdvertise
      var advertiseInfo = locator<AdvertiseModel>();
      if(responseBody['advertise']['advertise'].length != 0){
        responseBody['advertise']['advertise'].forEach((item){
          advertiseInfo.addAdvertise(item);
        });
      }

      var bioInfo = locator<BioModel>();
      //bioRhythm
      bioInfo.addAllBio(responseBody['bioRythm']);


      //profileModel
      var profileAllDataInfo =  locator<ProfileAllDataModel>();
      profileAllDataInfo.setAllProfile(
        ProfileAllDataViewModel(
          name: responseBody['profile']['name'],
          userName: responseBody['profile']['username'],
          subButtonText: responseBody['profile']['subButtonText'],
          subText: responseBody['profile']['subText'],
          hasSubscritbion: responseBody['profile']['hasSubscritbion'],
        )
      );

      //story
      var storyInfo = locator<StoryLocatorModel>();
       storyInfo.addStory(responseBody['story']);
       storyInfo.story.items.sort((a, b) => a.isViewed ? 1 : -1);
       StoryCacheManager.preload(storyInfo.story.items);

      var bottomBannerInfo = locator<BottomBannerModel>();
      bottomBannerInfo.addAllBottomBanner(responseBody['bottomBanner']);

      prefs.setBool('isAnim',false);

      if(status == 2){
        GenerateDashboardAndNotifyMessages().generateWeekPregnancy(false);
      }else if(status == 3){
        GenerateDashboardAndNotifyMessages().generateWeekPregnancy(false);
        GenerateDashboardAndNotifyMessages().generateWeekBreastfeeding(false);
      }

      checkForWeekPregnancy(status);

      if(!womansubscribtion){
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child:  ChooseSubscriptionPage(
                  isSub: false,
                )
            )
        );
        return true;
      }

      await SaveDataOfflineMode().saveAllDataOfflineMode(responseBody['offlineDashboardMessages']);
      if(isAddPregnancyCycle){
        if(await setCycleCalendar(context)){
          await GenerateDashboardAndNotifyMessages().checkForNotificationMessage();
          if(!isLocalPass){
            withOutLocalPass();
          }else{
            if(!widget.localPass){
              withOutLocalPass();
            }else{
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      duration: Duration(seconds: 1),
                      child: EnterPassScreen(
                        splash: true,
                        offlineModel: false,
                      )
                  )
              );
            }
          }
        }else{
          showError('خطا در برقراری اتصال، اینترنت خود را بررسی کنید',isLocalPass);
        }
      }else{
        await GenerateDashboardAndNotifyMessages().checkForNotificationMessage();
        if(!isLocalPass){
          withOutLocalPass();
        }else{
          if(!widget.localPass){
            withOutLocalPass();
          }else{
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    duration: Duration(seconds: 1),
                    child: EnterPassScreen(
                      splash: true,
                      offlineModel: false,
                    )
                )
            );
          }
        }
      }
    }else{
      showError('خطا در برقراری اتصال، اینترنت خود را بررسی کنید',isLocalPass);
    }
    return true;
  }

  withOutLocalPass()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   bool womansubscribtion =  prefs.getBool('womansubscribtion')!;
      Timer(Duration(milliseconds: 100),(){
        Navigator.pushReplacement(
            context,
            PageTransition(
                settings: RouteSettings(name: "/Page1"),
                type: PageTransitionType.fade,
                duration: Duration(seconds: 1),
                child:  FeatureDiscovery(
                    recordStepsInSharedPreferences: true,
                    child: Home(
                      indexTab: widget.index != null ? widget.index : 4,
                      isChangeStatus: false,
                      womansubscribtion: womansubscribtion,
                      // isLogin: false,
                      // checkMessageNotRead: true,
                    )
                )
            )
        );
      });
  }
  

   checkForWeekPregnancy(int status){
    if(status == 2){
      var cycleInfo = locator<CycleModel>();
      DateTime today = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
      CycleViewModel lastCycle = cycleInfo.cycle[cycleInfo.cycle.length-1];
      DateTime lastOfCycleEndCircle = DateTime.parse(lastCycle.circleEnd!);

      List<CycleViewModel> reverseCycles = cycleInfo.cycle.reversed.toList();
      List<CycleViewModel> reversePregnancyCycles = [];
      for(int i=0 ; i<reverseCycles.length ; i++){
        if(reverseCycles[i].status == 2){
          reversePregnancyCycles.add(reverseCycles[i]);
        }
      }
      List<CycleViewModel> pregnancyCycles = reversePregnancyCycles.reversed.toList();

      if(pregnancyCycles.length <= 41){
        if(today.isAfter(lastOfCycleEndCircle)){
          DateTime startPeriod = DateTime(lastOfCycleEndCircle.year,lastOfCycleEndCircle.month,lastOfCycleEndCircle.day+1);
          DateTime endCircle = DateTime(lastOfCycleEndCircle.year,lastOfCycleEndCircle.month,lastOfCycleEndCircle.day + 7);
          DateTime endPeriod = DateTime(startPeriod.year,startPeriod.month,startPeriod.day+ 3);

          Map<String,dynamic> circle ={};

          circle['isSavedToServer'] = 0;
          circle['periodStartDate'] = startPeriod.toString();
          circle['cycleEndDate'] = endCircle.toString();
          circle['periodEndDate'] = endPeriod.toString();
          circle['status'] = 2;
          circle['before'] = lastCycle.before;
          circle['after'] = lastCycle.after;
          circle['mental'] = lastCycle.mental;
          circle['other'] = lastCycle.other;
          circle['ovu'] = lastCycle.ovu != null ? lastCycle.ovu : '';

          isAddPregnancyCycle = true;
          cycleInfo.addCycle(circle);
          checkForWeekPregnancy(status);
        }
      }
    }
  }


  Future<bool> setCycleCalendar(context) async {
    var registerInfo = locator<RegisterParamModel>();
    var cycleInfo = locator<CycleModel>();
    CirclesSendServerMode circlesSendServerMode = CirclesSendServerMode();

    if (cycleInfo.cycle.length != 0) {
      circlesSendServerMode = CirclesSendServerMode.fromJson(cycleInfo.cycle);
    }

    if (circlesSendServerMode.cycleInfos != null) {
      if (circlesSendServerMode.cycleInfos!.length != 0) {
        Map<String,dynamic>? responseBody = await Http().sendRequest(
            womanUrl,
            'info/setcycleCalender',
            'POST',
            {"cycles": circlesSendServerMode.cycleInfos},
            registerInfo.register.token!);

        // print('setCycleCalender : $responseBody');
        if (responseBody != null) {
          if (responseBody['isValid']) {
            isAddPregnancyCycle = true;
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }

  }

  // withOutLocalPass(registerModel,circles)async{
  //   final _random = new Random();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if(prefs.getString('userName') != null){
  //     if(registerModel != null && circles != null){
  //       Navigator.pushReplacement(
  //           context,
  //           PageTransition(
  //               settings: RouteSettings(name: "/Page1"),
  //               type: PageTransitionType.fade,
  //               duration: Duration(seconds: 1),
  //               child: new FeatureDiscovery(
  //                   recordStepsInSharedPreferences: true,
  //                   child: Home(
  //                     randomMessage: Messages().randomMessages[_random.nextInt(Messages().randomMessages.length)] ,
  //                     indexTab: widget.index,
  //                     isLogin: false,
  //                     checkMessageNotRead: true,
  //                   )
  //               )
  //           )
  //       );
  //     }
  //   }else{
  //     if(registerModel != null && circles != null){
  //       Navigator.pushReplacement(
  //           context,
  //           PageTransition(
  //               type: PageTransitionType.fade,
  //               duration: Duration(seconds: 1),
  //               child: EnterNumberScreen(
  //                 hasCircles: true,
  //               )
  //           )
  //       );
  //     }else{
  //       Navigator.pushReplacement(
  //           context,
  //           PageTransition(
  //               type: PageTransitionType.fade,
  //               duration: Duration(seconds: 1),
  //               child: EnterNumberScreen(
  //                 hasCircles: false,
  //               )
  //           )
  //       );
  //     }
  //   }
  //
  // }

  String decimalToDayWeek(int a){
    List<int> days = [];
    for(int i=0 ; i<7 ; i++){
      if((a&(1 << i)) != 0){
        days.add(i);
      }
    }
    return days.isNotEmpty ? days.toString() : '';
  }

  List<List<int>> decimalToSignWoman(int a){
    List<List<int>> all =[];
    List<int> before = [];
    List<int> after = [];
    List<int> mental = [];
    List<int> other = [];
    List<int> ovu = [];
    for(int i=0 ; i<4 ; i++){
      if((a&(1 << i)) != 0){
        before.add(i);
      }
    }
    for(int i=4 ; i<11 ; i++){
      if((a&(1 << i)) != 0){
        if(i==4){
          after.add(0);
        }else if(i==5){
          after.add(1);
        }else if(i==6){
          after.add(2);
        }else if(i==7){
          after.add(3);
        }else if(i==8){
          after.add(4);
        }else if(i==9){
          after.add(5);
        }else if(i==10){
          after.add(6);
        }
      }
    }
    for(int i=11 ; i<18 ; i++){
      if((a&(1 << i)) != 0){
        if(i==11){
          mental.add(0);
        }else if(i==12){
          mental.add(1);
        }else if(i==13){
          mental.add(2);
        }else if(i==14){
          mental.add(3);
        }else if(i==15){
          mental.add(4);
        }else if(i==16){
          mental.add(5);
        }else if(i==17){
          mental.add(6);
        }
      }
    }
    for(int i=18 ; i<22 ; i++){
      if((a&(1 << i)) != 0){
        if(i==18){
          other.add(0);
        }else if(i==19){
          other.add(1);
        }else if(i==20){
          other.add(2);
        }else if(i==21){
          other.add(3);
        }
      }
    }
    for(int i=22 ; i<29 ; i++){
      if((a&(1 << i)) != 0){
        if(i==22){
          before.add(4);
        }else if(i==23){
          before.add(5);
        }else if(i==24){
          before.add(6);
        }else if(i==25){
          before.add(7);
        }else if(i==26){
          after.add(8);
        }else if(i==27){
          before.add(8);
        }else if(i==28){
          before.add(9);
        }
      }
    }
    for(int i=29 ; i<30 ; i++){
      if((a&(1 << i)) != 0){
        if(i==29){
          other.add(4);
        }
      }
    }
    for(int i=30 ; i<33 ; i++){
      if((a&(1 << i)) != 0){
        if(i==30){
          ovu.add(0);
        }else if(i==31){
          ovu.add(1);
        }else if(i==32){
          ovu.add(2);
        }
      }
    }
    for(int i=33 ; i<34 ; i++){
      if((a&(1 << i)) != 0){
        if(i==33){
          after.add(7);
        }
      }
    }

    all.add(before);
    all.add(after);
    all.add(mental);
    all.add(other);
    all.add(ovu);
    return all.isNotEmpty ? all : [];
  }

  List<List<int>> decimalToPregnancySigns(int a){
    List<List<int>> all =[];
    List<int> fetalSex = [];
    List<int> physical = [];
    List<int> physicalPregnancy = [];
    List<int> gastrointestinalPregnancy = [];
    List<int> psychologyPregnancy = [];

    for(int i=0 ; i<37 ; i++){
      if((a&(1 << i)) != 0){
        switch(i){
          case 0: fetalSex.add(0);
          continue;
          case 1: fetalSex.add(1);
          continue;
          case 2: fetalSex.add(2);
          continue;
          case 3: physical.add(0);
          continue;
          case 4: gastrointestinalPregnancy.add(6);
          continue;
          case 5: physical.add(1);
          continue;
          case 6: physical.add(2);
          continue;
          case 7: physical.add(3);
          continue;
        // case 8: fetalSex.add(2);
        // continue;
        // case 9: fetalSex.add(2);
        // continue;
          case 10: physicalPregnancy.add(0);
          continue;
          case 11: physicalPregnancy.add(1);
          continue;
          case 12: physicalPregnancy.add(2);
          continue;
          case 13: physical.add(4);
          continue;
          case 14: physical.add(5);
          continue;
        // case 15: fetalSex.add(2);
        // continue;
          case 16: gastrointestinalPregnancy.add(7);
          continue;
          case 17: gastrointestinalPregnancy.add(5);
          continue;
          case 18: physicalPregnancy.add(3);
          continue;
          case 19: physicalPregnancy.add(4);
          continue;
          case 20: gastrointestinalPregnancy.add(2);
          continue;
          case 21: gastrointestinalPregnancy.add(3);
          continue;
          case 22: gastrointestinalPregnancy.add(4);
          continue;
          case 23: physicalPregnancy.add(5);
          continue;
          case 24: physicalPregnancy.add(6);
          continue;
          case 25: gastrointestinalPregnancy.add(1);
          continue;
          case 26: physicalPregnancy.add(7);
          continue;
          case 27: physicalPregnancy.add(8);
          continue;
          case 28: physicalPregnancy.add(9);
          continue;
          case 29: gastrointestinalPregnancy.add(0);
          continue;
          case 30: psychologyPregnancy.add(0);
          continue;
          case 31: psychologyPregnancy.add(1);
          continue;
          case 32: psychologyPregnancy.add(2);
          continue;
          case 33: psychologyPregnancy.add(3);
          continue;
          case 34: psychologyPregnancy.add(4);
          continue;
          case 35: psychologyPregnancy.add(5);
          continue;
          case 36: physicalPregnancy.add(10);
          continue;
        }
      }
    }

    all.add(fetalSex);
    all.add(physical);
    all.add(physicalPregnancy);
    all.add(gastrointestinalPregnancy);
    all.add(psychologyPregnancy);
    return all.isNotEmpty ? all : [];

  }

  List<List<int>> decimalToBreastfeeding(int a){
    List<List<int>> all =[];
    List<int> babySigns = [];
    List<int> physical = [];
    List<int> breastfeedingMother = [];
    List<int> psychology = [];


    for(int i=0 ; i<30 ; i++){
      if((a&(1 << i)) != 0){
        switch(i){
        // case 0:
        //  continue;
        // case 1:
        //   continue;
        // case 2:
        //   continue;
          case 3: babySigns.add(0);
          continue;
          case 4: babySigns.add(1);
          continue;
          case 5: babySigns.add(2);
          continue;
          case 6: babySigns.add(3);
          continue;
          case 7: babySigns.add(4);
          continue;
          case 8: breastfeedingMother.add(0);
          continue;
          case 9: breastfeedingMother.add(1);
          continue;
          case 10: breastfeedingMother.add(4);
          continue;
          case 11: physical.add(0);
          continue;
          case 12: physical.add(1);
          continue;
          case 13: physical.add(2);
          continue;
        // case 14:
        //   continue;
        // case 15:
        //   continue;
          case 16: physical.add(3);
          continue;
          case 17: physical.add(4);
          continue;
          case 18: physical.add(5);
          continue;
          case 19: physical.add(6);
          continue;
          case 20: physical.add(7);
          continue;
          case 21: physical.add(8);
          continue;
          case 22: breastfeedingMother.add(3);
          continue;
          case 23: breastfeedingMother.add(2);
          continue;
          case 24: physical.add(9);
          continue;
          case 25: psychology.add(0);
          continue;
          case 26: psychology.add(1);
          continue;
          case 27: psychology.add(2);
          continue;
          case 28: psychology.add(3);
          continue;
          case 29: psychology.add(4);
          continue;
        }
      }
    }
    all.add(babySigns);
    all.add(physical);
    all.add(breastfeedingMother);
    all.add(psychology);
    return all.isNotEmpty ? all : [];
  }


  showError(String message,bool isLocalPass){
    goToOfflineDashboard(isLocalPass);
    // if(this.mounted){
    //   setState(() {
    //     isNet = false;
    //     errorMessage = message;
    //   });
    // }
  }

  goToOfflineDashboard(bool isLocalPass){
    if(!isLocalPass){
      Navigator.pushReplacement(
          context,
          PageTransition(
              settings: RouteSettings(name: "/Page1"),
              type: PageTransitionType.fade,
              duration: Duration(seconds: 1),
              child:  OfflineDashboardScreen()
          )
      );
    }else{
      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              duration: Duration(seconds: 1),
              child: EnterPassScreen(
                splash: true,
                offlineModel: true,
              )
          )
      );
    }
  }

  // initCafeBazar()async{
  //   try{
  //     AppInfo app = await InstalledApps.getAppInfo('com.farsitel.bazaar');
  //     if(getExtendedVersionNumber(app.versionName) >= getExtendedVersionNumber('19.0.0')){
  //       print('initCafeBazar');
  //       await FlutterPoolakey.connect(
  //           'MIHNMA0GCSqGSIb3DQEBAQUAA4G7ADCBtwKBrwC0t0MsJvRzZEOa46iZ8bMycGoeeq/pXeVONhsR4Z+TqUFMjicoqpzwROeCXiXXVNVISnrW3GM4n+HX5axbpnUv4qfh2agdiZE5mqyuKlNGB/OBbrKQ6BCMZvfeFwfrrg6t+ydNNCEL7Oeua9KqS8RXNvva6OHkiVegirWVh1GxLtWhWe8OcM5vZypq/45rCSHXZ48JFoJUElpWNXBN+9W6zXcerqQyy3niMbzC3vkCAwEAAQ==',
  //           onDisconnected: (){
  //             print('onDisconnected');
  //           });
  //     }
  //   }catch(e){
  //     print('Cafe Bazar not installed');
  //   }
  // }

  initMyket()async{
    try{
      await MyketIAP.init(rsaKey: 'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCM2mF113udNg5Ih+OL5kryRZw6kT+ibnxjCUMrSI336nwqmEsWh4V7DP4fJG1SdXuZYHGtaCS6VyUQXuFn9ryAiMOi4+Xmza4HTGMzzDXYuBzAHSj4mhZ8DSF+Jq+p0r19mxvkEogk8VQ1f1/C1pFNkhnfkUaFLm2TnlqAetywnwIDAQAB', enableDebugLogging: false);
    }catch(e){
      print(e);
    }
  }


}
