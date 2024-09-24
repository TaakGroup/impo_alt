
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter_poolakey/flutter_poolakey.dart';
import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:impo/src/architecture/model/register_model.dart';
import 'package:impo/src/architecture/presenter/dashboard_presenter.dart';
import 'package:impo/src/architecture/view/register_view.dart';
import 'package:impo/src/components/DateTime/my_datetime.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/core/app/view/widgets/snackbar/custom_snack_bar.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/data/local/save_data_offline_mode.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/data/messages/generate_dashboard_notify_and_messages.dart';
import 'package:impo/src/models/bioRhythm/biorhythm_view_model.dart';
import 'package:impo/src/models/calender/alarm_model.dart';
import 'package:impo/src/models/dashboard/dashboard_messages_and_notify_model.dart';
import 'package:impo/src/models/advertise_model.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/dashboard/pregnancy_numbers_model.dart';
import 'package:impo/src/models/getMenstrualCalendar/get_menstrual_calendar_model.dart';
import 'package:impo/src/models/partner/partner_model.dart';
import 'package:impo/src/models/profile/profile_all_data_model.dart';
import 'package:impo/src/models/register/circles_send_server_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/models/register/register_send_server_model.dart';
import 'package:impo/src/models/register/set_menstrual_calendar_model.dart';
import 'package:impo/src/models/signsModel/breastfeeding_signs_model.dart';
import 'package:impo/src/models/signsModel/pregnancy_signs_model.dart';
import 'package:impo/src/models/story_model.dart';
import 'package:impo/src/screens/LoginAndRegister/identity/login_screen.dart';
import 'package:impo/src/screens/LoginAndRegister/identity/set_password_screen.dart';
import 'package:impo/src/screens/LoginAndRegister/identity/verify_code_screen.dart';
import 'package:impo/src/screens/LoginAndRegister/globalRegister/name_register_screen.dart';
import 'package:impo/src/screens/home/home.dart';
import 'package:impo/src/screens/splash_screen.dart';
import 'package:impo/src/singleton/alarm_manager_init.dart';
import 'package:impo/src/singleton/notification_init.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:myket_iap/myket_iap.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_view/story_view.dart';
import 'package:string_validator/string_validator.dart';
import 'package:impo/src/screens/LoginAndRegister/identity/enter_number_screen.dart';
import '../../core/app/Utiles/helper/version_to_int.dart';
import '../../firebase_analytics_helper.dart';
import '../../models/bioRhythm/bio_model.dart';
import '../../models/bottom_banner_model.dart';
import '../../screens/subscribe/choose_subscription_page.dart';


class RegisterPresenter{

  late RegisterView _registerView;

  RegisterModel _registerModel =  RegisterModel();

  late AnimationController animationControllerDialog;


  RegisterPresenter(RegisterView view){

    this._registerView = view;

  }

  final dialogScale = BehaviorSubject<double>.seeded(0.0);
  final isShowDialog = BehaviorSubject<bool>.seeded(false);
  final isLoading = BehaviorSubject<bool>.seeded(false);
  final valueDialogText = BehaviorSubject<String>.seeded('');


  Stream<double> get dialogScaleObserve => dialogScale.stream;
  Stream<bool> get isShowDialogObserve => isShowDialog.stream;
  Stream<bool> get isLoadingObserve => isLoading.stream;
  Stream<String> get valueDialogTextObserve => valueDialogText.stream;

  int indexAlarmsLessServerId = 0;
  int indexAlarmsWithServerId = 0;
  int indexRemoveAlarmCalender = 0;

  int indexReminderLessServerId = 0;
  int indexReminderWithServerId = 0;
  int indexRemoveReminder = 0;
  bool isAddPregnancyCycle = false;

  GetMenstrualCalendarModel _getMenstrualCalendarModel =  GetMenstrualCalendarModel();

//  AnimationController animationControllerDialog;
//
//  final isLoading  = BehaviorSubject<bool>.seeded(false);
//  final isShowDialog = BehaviorSubject<bool>.seeded(false);
//  final dialogScale = BehaviorSubject<double>.seeded(0.0);
//  final valueDialogError = BehaviorSubject<String>.seeded('');
//
//
//
//  Stream<bool> get isLoadingObserve => isLoading.stream;
//  Stream<bool> get isShowDialogObserve => isShowDialog.stream;
//  Stream<double> get dialogScaleObserve => dialogScale.stream;
//  Stream<String> get valueDialogErrorObserve => valueDialogError.stream;



//  initialDialogScale(_this){
//    animationControllerDialog = AnimationController(
//        vsync: _this,
//        lowerBound: 0.0,
//        upperBound: 1,
//        duration: Duration(milliseconds: 250));
//    animationControllerDialog.addListener(() {
//      dialogScale.sink.add(animationControllerDialog.value);
//    });
//  }

  String get getName => _registerModel.getRegisterInfo().name!;

  initialDialogScale(_this){
    animationControllerDialog = AnimationController(
        vsync: _this,
        lowerBound: 0.0,
        upperBound: 1,
        duration: Duration(milliseconds: 250));
    animationControllerDialog.addListener(() {
      dialogScale.sink.add(animationControllerDialog.value);
    });
  }



  enterName(String name){

    if(name.length >= 2){
      _registerView.onSuccess(name);


    }else{

      _registerView.onError(
        'لطفا نام را به صورت کامل وارد کنید'
      );

    }

  }

  enterPeriodDay(int days){

    _registerView.onSuccess(days);

  }

  enterCircleDay(circles){
    _registerView.onSuccess(circles);
  }

  enterLastPeriodDay(value){

    _registerView.onSuccess(value);

  }

  enterBirthDay(value){

    _registerView.onSuccess(value);

  }

  enterTypeSex(value){

    _registerView.onSuccess(value);

  }

  enterSelectCountry(value){
    _registerView.onSuccess(value);
  }


  onPressShowDialog()async{
    Timer(Duration(milliseconds: 50),()async{
      animationControllerDialog.forward();
      isShowDialog.sink.add(true);
    });
  }

  onPressCancelDialog()async{
    await animationControllerDialog.reverse();
    if(!isShowDialog.isClosed){
      isShowDialog.sink.add(false);
    }
  }

  onPressOkDialog(context,value)async{
    await animationControllerDialog.reverse();
    if(!isShowDialog.isClosed){
      isShowDialog.sink.add(false);
    }
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: new LoginScreen(
          phoneOrEmail: value,
        )
      )
    );
  }

  // checkIsRegisterToken(String value,context,Animations animations,randomMessage)async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String userToken = '';
  //   if(prefs.getString('userToken') != null){
  //     userToken = prefs.getString('userToken');
  //   }else{
  //     userToken = '';
  //   }
  //   RegisterParamViewModel RegisterParamViewModel = await _dashboardModel.getRegisters();
  //
  //   if(userToken == '' && RegisterParamViewModel.token == ''){
  //     registerTokenSaveToServer(1, context, randomMessage,value: value , animations: animations);
  //   }else if(userToken != '' && RegisterParamViewModel.token == ''){
  //     loginToken(1, value, context, animations, randomMessage,userToken);
  //   }else{
  //     isRegisterStatus(value, context, animations, randomMessage);
  //   }
  //
  // }

  isRegisterStatus(String value,context,Animations animations,typeValue)async{
    String phoneOrEmail = '';
    if(typeValue == 0){
      phoneOrEmail  = 'شماره تلفن';
    }else{
      phoneOrEmail  = 'ایمیل';
    }
    AnalyticsHelper().log(AnalyticsEvents.EnterNumberPg_Cont_Btn_Clk,parameters: {'phoneOrEmail' : value});
    animations.isErrorShow.sink.add(false);
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
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
      if(responseBody['isRegister']){
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }
        if(!valueDialogText.isClosed){
          /// if(hasCircles){
          ///   valueDialogText.sink.add("دوست عزیز، قبلا با این $phoneOrEmail حساب کاربری ایجاد شده است. لطفا $phoneOrEmail دیگری وارد کنید ");
          /// }else{
            valueDialogText.sink.add("دوست عزیز، قبلا با این $phoneOrEmail حساب کاربری ایجاد شده است. لطفا پس از تایید، رمز عبور خود را وارد کنید");
          /// }
        }
        onPressShowDialog();
      }else{
        setIdentity(value,animations,context,typeValue);
        // verifyUser(value, context, animations, randomMessage);
      }
    }else{
      animations.showShakeError('خطا در برقراری اتصال، اینترنت خود را بررسی کنید');
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
    }

  }

  ///SetIdentity
  setIdentity(value,animations,context,typeValue)async{
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
    String phoneModel = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(Platform.isAndroid){
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      phoneModel = androidInfo.model;
    }else{
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      phoneModel = iosInfo.model;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceToken = prefs.getString('deviceToken');
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        identityUrl,
        'customerAccount/setIdentity',
        'PUT',
        {
          "identity" : value,
          "phoneModel"  : phoneModel,
          "deviceToken" : deviceToken
        },
        ''
    );
    // print(responseBody);
    if(responseBody != null){
      if(responseBody['result']){
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child:  VerifyCodeScreen(
                  phoneOrEmail: value,
                  typeValue: typeValue,
                  isRegister: true,
                  onlyLogin: false,
                )
            )
        );
      }else{
        animations.showShakeError('ارتباط با سرور برقرار نشد، لطفا مجددا تلاش کنید');
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }
      }
    }else{
      animations.showShakeError('خطا در برقراری اتصال، اینترنت خود را بررسی کنید');
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
    }

  }
  validateIdentity(identity,context,Animations animations,String code)async{
    String phoneModel = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(Platform.isAndroid){
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      phoneModel = androidInfo.model;
    }else{
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      phoneModel = iosInfo.model;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceToken = prefs.getString('deviceToken');

    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        identityUrl,
        'customerAccount/validateIdentity',
        'POST',
        {
          "identity" : identity,
          "code" : code,
          "phoneModel"  : phoneModel,
          "deviceToken" : deviceToken
        },
        ''
    );

    // print(responseBody);
    if(responseBody != null){
      if(responseBody['result']){
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }
        /// if(hasCircles){
        ///   RegisterParamViewModel registerParamViewModel = await _registerModel.getRegisters();
        ///   Navigator.push(
        ///       context,
        ///       PageTransition(
        ///           type: PageTransitionType.fade,
        ///           child:  SetPasswordScreen(
        ///             phoneOrEmail: identity,
        ///             interfaceCode: '',
        ///             isRegister: true,
        ///             registerParamViewModel: registerParamViewModel,
        ///             hasCircle: true,
        ///             onlyLogin: false,
        ///           )
        ///       )
        ///   );
        /// }else{
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child:  NameRegisterScreen(
                    phoneOrEmail: identity,
                  )
              )
          );
        /// }
      }else{
        animations.showShakeError('کد وارد شده اشتباه است');
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }
      }
    }else{
      animations.showShakeError('خطا در برقراری اتصال، اینترنت خود را بررسی کنید');
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
    }

  }
    Future<bool> checkDailyReminders()async{
    // DataBaseProvider db = new DataBaseProvider();
    List<DailyRemindersViewModel>? dailyReminders = await _registerModel.getDailyReminders();
    // print('serverID${dailyReminders[24].serverId}');
    if(dailyReminders == null){

      for(int i=1 ; i<25 ; i++){
        await _registerModel.insertDailyRemindersToLocal(
            {
              'id' : i ,
              'title' : 'لیوان $i',
              'time' : "08:00",
              'isSound' : 1,
              'mode' : i == 1 ? 1 : 0,
              'dayWeek' : '',
              'isChange' : 0
            },
            // 'DailyReminders'
        );
      }

      for(int i=101 ; i<125 ; i++){
        await _registerModel.insertDailyRemindersToLocal(
            {
              'id' : i,
              'title' : 'وقت یادگیری ${i-100}',
              'time' : "18:00",
              'isSound' : 1,
              'mode' : i == 101 ? 1 : 0,
              'dayWeek' : '',
              'isChange' : 0
            },
            // 'DailyReminders'
        );
      }

      for(int i=201 ; i<225 ; i++){
        await _registerModel.insertDailyRemindersToLocal(
            {
              'id' : i,
              'title' : 'قرص ${i-200}',
              'time' : "08:00",
              'isSound' : 1,
              'mode' : i == 201 ? 1 : 0,
              'dayWeek' : '',
              'isChange' : 0
            },
            // 'DailyReminders'
        );
      }

      for(int i=301 ; i<325 ; i++){
        await _registerModel.insertDailyRemindersToLocal(
            {
              'id' : i,
              'title' : 'میوه ${i-300}',
              'time' : "11:00",
              'isSound' : 1,
              'mode' : i == 301 ? 1 : 0,
              'dayWeek' : '',
              'isChange' : 0
            },
            // 'DailyReminders'
        );
      }

      for(int i=401 ; i<425 ; i++){
        await _registerModel.insertDailyRemindersToLocal(
            {
              'id' : i,
              'title' : 'زنگ ورزش ${i-400}',
              'time' : "06:00",
              'isSound' : 1,
              'mode' : i == 401 ? 1 : 0,
              'dayWeek' : '',
              'isChange' : 0
            },
            // 'DailyReminders'
        );
      }

      for(int i=501 ; i<525 ; i++){
        await _registerModel.insertDailyRemindersToLocal(
            {
              'id' : i,
              'title' : 'خوب بخوابی ${i-500}',
              'time' : "23:00",
              'isSound' : 1,
              'mode' : i == 501 ? 1 : 0,
              'dayWeek' : '',
              'isChange' : 0
            },
            // 'DailyReminders'
        );
      }

      for(int i=601 ; i<625 ; i++){
        await _registerModel.insertDailyRemindersToLocal(
            {
              'id' : i,
              'title' : 'بدون گوشی ${i-600}',
              'time' : "12:00",
              'isSound' : 1,
              'mode' : i == 601 ? 1 : 0,
              'dayWeek' : '',
              'isChange' : 0
            },
            // 'DailyReminders'
        );
      }

      for(int i=701 ; i<725 ; i++){
        await _registerModel.insertDailyRemindersToLocal(
            {
              'id' : i,
              'title' : 'تعویض ${i-700}',
              'time' : "21:00",
              'isSound' : 1,
              'mode' : i == 701 ? 1 : 0,
              'dayWeek' : '',
              'isChange' : 0
            },
            // 'DailyReminders'
        );
      }
//     for(int i = 0 ; i < 7 ; i++){
//       _dashboardModel.insertDailyRemindersToLocal(
//         {
//           'title' : i == 0 ? 'نوشیدن آب' : i == 1 ? 'یادآور مطالعه' : i == 2 ? 'یادآور دارو' : i == 3 ? 'یادآور میوه' : i == 4 ? 'یادآور ورزش' : i == 5 ? 'یادآور خواب' : 'استفاده از موبایل',
//           'time' : TimeOfDay.fromDateTime(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,12,00)).format(context).replaceAll('TimeOfDay', '').replaceAll('(', '').replaceAll(')', ''),
//           'isSound' : 0,
//           'isActive' : 0,
//         }
//       );
//     }
    }else{
      if(dailyReminders.length == 168){
        for(int i=701 ; i<725 ; i++){
          await _registerModel.insertDailyRemindersToLocal(
              {
                'id' : i,
                'title' : 'تعویض ${i-700}',
                'time' : "21:00",
                'isSound' : 1,
                'mode' : i == 701 ? 1 : 0,
                'dayWeek' : '',
                'isChange' : 0
              },
              // 'DailyReminders'
          );
        }
      }
    }
    return true;
  }
    sendRegister(Animations animations,identity,password,context)async{
    // print('register');
    // print(identity);

      var registerInfo = locator<RegisterParamModel>();

      RegisterParamViewModel registerParamViewModel= registerInfo.register;

      // if(registerParamViewModel.status == 1){
      //   DateTime lastPeroid = DateTime.parse(registerParamViewModel.lastPeriod);
      //   DateTime now = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
      //
      //
      //   if((MyDateTime().myDifferenceDays(lastPeroid,now) + 1 )> registerParamViewModel.circleDay){
      //
      //     registerParamViewModel.circleDay = (MyDateTime().myDifferenceDays(lastPeroid,now) + 1);
      //   }
      // }

    animations.isErrorShow.sink.add(false);
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
    await checkDailyReminders();
    String phoneModel = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(Platform.isAndroid){
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      phoneModel = androidInfo.model;
    }else{
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      phoneModel = iosInfo.model;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceToken = prefs.getString('deviceToken');



    Map<String,dynamic> json = RegisterSendServerModel().generateJson(
        registerParamViewModel.status!,registerParamViewModel.name!,
        identity, password, registerParamViewModel.interFaceCode!, deviceToken, registerParamViewModel.birthDay!,
        registerParamViewModel.periodDay, registerParamViewModel.lastPeriod, registerParamViewModel.circleDay,
        registerParamViewModel.isDeliveryDate,registerParamViewModel.pregnancyDate,registerParamViewModel.hasAboration,
        registerParamViewModel.pregnancyNo,
        registerParamViewModel.sex!, phoneModel, registerParamViewModel.nationality!,
       registerParamViewModel.periodStatus);

     print(json);
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        identityUrl,
        'customerAccount/registerv2',
        'POST',
        json,
        ''
    );


    // print(responseBody);

    if(responseBody != null){
      if(responseBody.isNotEmpty){
        if(responseBody['result']){
          login(registerParamViewModel,identity, password,animations,context,
           isRegister: true , onlyLogin: false,isChangeStatus: false,hasAbortion: false);
        }else{
          animations.showShakeError('رمز وارد شده اشتباه است');
          if(!isLoading.isClosed){
            isLoading.sink.add(false);
          }


        }

      }else{

        animations.showShakeError('رمز وارد شده اشتباه است');
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }

      }

    }else{

      animations.showShakeError('خطا در برقراری اتصال، اینترنت خود را بررسی کنید');
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }

    }

  }
  ///SetIdentity



  ///GetIdentity
  onPressForgotPassword(String identity,Animations animations,context,bool onlyLogin){

    animations.isErrorShow.sink.add(false);

    if(identity != ''){

      if(isNumeric(identity)){
        if(identity.startsWith('09') && identity.length == 11){

          isRegisterStatusForForgotScreen(identity, animations, context,0, onlyLogin);

        }else{
          animations.showShakeError('شماره تلفن باید ۱۱ رقم باشه و با ۰۹ شروع بشه');
        }
      }else{

        if(isEmail(identity)){

          isRegisterStatusForForgotScreen(identity, animations, context,1, onlyLogin);


        }else{

          animations.showShakeError('فرمت ایمیل و یا شماره وارد شده صحیح نیست');

        }

      }

    }else{

      animations.showShakeError('شماره تلفن باید ۱۱ رقم باشه و با ۰۹ شروع بشه');

    }

  }
  isRegisterStatusForForgotScreen(identity,animations,context,typeValue,bool onlyLogin)async{

    animations.isErrorShow.sink.add(false);
    AnalyticsHelper().log(AnalyticsEvents.ForgotPasswordPg_continue_Btn_Clk,parameters: {'phoneOrEmail' : identity});
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        identityUrl,
        'customerAccount/status/$identity',
        'GET',
        {

        },
        ''
    );

    // print(responseBody);

    if(responseBody != null){
      if(responseBody['isRegister']){
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }
        getIdentityForForgot(identity, animations, context,typeValue,onlyLogin);
      }else{

        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                duration: Duration(seconds: 1),
                child: EnterNumberScreen(
                  value: identity,
                )
            )
        );

      }
    }else{
      animations.showShakeError('خطا در برقراری اتصال، اینترنت خود را بررسی کنید');
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
    }

  }
  getIdentityForForgot(identity,animations,context,typeValue,bool onlyLogin)async{

    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        identityUrl,
        'customerAccount/getIdentity',
        'POST',
        {
          "identity" : identity,
        },
        ''
    );
    // print('getIdentityForForgot$responseBody');
    if(responseBody != null){
      if(responseBody['result']){
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child:  VerifyCodeScreen(
                  phoneOrEmail: identity,
                  typeValue: typeValue,
                  isRegister: false,
                  onlyLogin: onlyLogin,
                )
            )
        );
      }else{
        animations.showShakeError('این شماره تلفن ویا ایمیل در سیستم ثبت نشده است');
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }
      }
    }else{
      animations.showShakeError('خطا در برقراری اتصال، اینترنت خود را بررسی کنید');
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
    }

  }
  validateForForgot(String identity,context,Animations animations,String code,bool onlyLogin)async{

    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        identityUrl,
        'customerAccount/validate',
        'POST',
        {
          "identity" : identity,
          "code" : code,
        },
        ''
    );

    // print('validateForForgot$responseBody');
    if(responseBody != null){
      if(responseBody['result']){
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child:  SetPasswordScreen(
                  phoneOrEmail: identity,
                  isRegister: false,
                  onlyLogin: onlyLogin,
                )
            )
        );
      }else{
        animations.showShakeError('کد وارد شده اشتباه است');
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }
      }
    }else{
      animations.showShakeError('خطا در برقراری اتصال، اینترنت خود را بررسی کنید');
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
    }

  }
  forgot(identity,password,context,Animations animations,bool onlyLogin)async{
    // print('forgot');
    // print(identity);
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        identityUrl,
        'customerAccount/forgot',
        'POST',
        {
          'identity' : identity,
          "password" : password
        },
        ''
    );

   // print('forgot$responseBody');

    if(responseBody != null){
      if(responseBody.isNotEmpty){
        if(responseBody['result']){
          if(!isLoading.isClosed){
            isLoading.sink.add(false);
          }
          login(null,identity, password, animations, context,
         isRegister: false,onlyLogin: onlyLogin,isChangeStatus: false,hasAbortion: false);
        }else{

          animations.showShakeError('رمز وارد شده اشتباه است');
          if(!isLoading.isClosed){
            isLoading.sink.add(false);
          }

        }

      }else{
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }
        animations.showShakeError('خطا در اتصال به سرور، لطفا مجددا تلاش کنید');
      }


    }else{

      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
      animations.showShakeError('خطا در برقراری اتصال، اینترنت خود را بررسی کنید');

    }

  }
  ///GetIdentity


  ///Login
  onPressEnterAccount(String identity,String password,context,animations)async{

    if(identity.length >=5 && password.length >= 5){

      AnalyticsHelper().log(AnalyticsEvents.LoginPg_LoginToImpo_Btn_Clk,parameters: {'phoneOrEmail' : identity});
      login(null,identity, password,animations,context,
      isRegister: false,onlyLogin: false,isChangeStatus: false,hasAbortion: false);

    }else{

      animations.showShakeError('لطفا نام کاربری و یا رمز عبور خود را وارد کنید');
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }

    }

  }
  login(RegisterParamViewModel? registerParamViewModel,identity,
      password,animations,context,{bool? isRegister,bool? onlyLogin,bool? isChangeStatus, bool? hasAbortion})async{
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
    String? deviceToken = prefs.getString('deviceToken');
    String channelVersion = '';

    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }

    try{
      AppInfo app = await InstalledApps.getAppInfo('com.farsitel.bazaar');
      channelVersion = app.versionName;
    }catch(e){
      print('Cafe Bazar not installed');
    }

    // print(identity);
    // print(password);
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        identityUrl,
        'customerAccount/loginv6',
        'POST',
        {
          "identity" : identity,
          "password" : password,
          "phoneModel"  : phoneModel,
          "deviceToken" : deviceToken,
          "version" : version,
          "ChannelVersion" : channelVersion
        },
        ''
    );
    // print(responseBody);
    if(responseBody != null){
      if(responseBody.isNotEmpty){
        if(responseBody['result']){
            // await initCafeBazar();
            await initMyket();
            prefs.setString('interfaceCode', responseBody['interfaceCode']);
            prefs.setString('interfaceText', responseBody['interfaceText']);
            prefs.setBool('interfaceVisibility',responseBody['interfaceVisibility']);
            prefs.setInt('endTimeWomanSubscribe',responseBody['endTimeWomanSubscribe']);
            prefs.setBool('womansubscribtion',responseBody['womansubscribtion']);
            prefs.setBool('showComment', responseBody['showComment']);
            prefs.setBool('showExperience',responseBody['showExperience']);

            getInfoAndSetStatus(responseBody['status'],prefs);
            // getAdvertise(responseBody['advertise']);
            if(!notReadMessage.isClosed){
              notReadMessage.sink.add(responseBody['messageNotRead']);
            }
            // prefs.setString('', value)
            // print('onlyLogin : $onlyLogin');
            if(isRegister!){
              if(responseBody['status'] == 2){
                GenerateDashboardAndNotifyMessages().generateWeekPregnancy(false,registerParamViewModel: registerParamViewModel!);
              }else if(responseBody['status'] == 3){
                GenerateDashboardAndNotifyMessages().generateWeekPregnancy(false,registerParamViewModel: registerParamViewModel!);
                GenerateDashboardAndNotifyMessages().generateWeekBreastfeeding(false);
              }
              // await _registerModel.updateRegister('token', responseBody['token']);
              setMenstrualCalendar(registerParamViewModel!,identity,password,animations,context,
                  responseBody['token'],responseBody['status'],isChangeStatus!,hasAbortion!,responseBody['womansubscribtion']);
            }else{
              // if(!onlyLogin!){
                getMenstrualCalendar(identity, password, context,responseBody['token'],animations,responseBody['status'],responseBody['womansubscribtion']);
              // }else{
              //   saveUserNameEnterAccount(identity, password, isEmail(identity) ? 1 : 0);
              //
              //   if(responseBody['womansubscribtion']){
              //     Timer(Duration(milliseconds: 100),(){
              //       Navigator.pushReplacement(
              //           context,
              //           PageTransition(
              //               settings: RouteSettings(name: "/Page1"),
              //               type: PageTransitionType.fade,
              //               duration: Duration(milliseconds: 500),
              //               child:  FeatureDiscovery(
              //                 recordStepsInSharedPreferences: true,
              //                 child: Home(
              //                   indexTab:  4,
              //                   register: true,
              //                   isChangeStatus: false,
              //                   womansubscribtion: responseBody['womansubscribtion'],
              //                   // isLogin: true,
              //                   // checkMessageNotRead: true,
              //                 ),
              //               )
              //           )
              //       );
              //     });
              //   }else{
              //     Navigator.push(
              //         context,
              //         PageTransition(
              //             type: PageTransitionType.fade,
              //             child:  ChooseSubscriptionPage(
              //               isSub: false,
              //             )
              //         )
              //     );
              //   }
              //
              // }
            }
        }else{

          animations.showShakeError('رمز وارد شده اشتباه است');
          if(!isLoading.isClosed){
            isLoading.sink.add(false);
          }


        }

      }else{

        animations.showShakeError('رمز وارد شده اشتباه است');
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }

      }

    }else{

      animations.showShakeError('خطا در برقراری اتصال، اینترنت خود را بررسی کنید');
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }

    }

  }



  String getInfoAndSetStatus(int status,SharedPreferences prefs){
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

  getAdvertise(List ads){
    var advertiseInfo = locator<AdvertiseModel>();
    if(ads.length != 0){
      ads.forEach((item){
        advertiseInfo.addAdvertise(item);
      });
    }
  }

  ///Login



  ///Ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssset
   setMenstrualCalendar(RegisterParamViewModel registerParamViewModel,
       value,password,Animations animations,context,String token,int status,bool isChangeStatus,bool hasAbortion,bool womansubscribtion)async{
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
    var cycleInfo = locator<CycleModel>();


    if(cycleInfo.cycle.isNotEmpty){
      // if(status == 1){
      //   saveCirclesToLocal(registerParamViewModel);
      // }else{
        generatePregnancyCycles(registerParamViewModel,hasAbortion);
      // }
    }else{
      if(status == 1){
        saveCirclesToLocal(registerParamViewModel);
      }else if(status == 2){
        generatePregnancyCycles(registerParamViewModel,hasAbortion);
      }
    }



    SharedPreferences prefs = await SharedPreferences.getInstance();


    // print(prefs.getString('deviceToken'));
    // print('tttt');
    SetMenstrualCalendarModel menstrualCalendarModel = SetMenstrualCalendarModel.fromJson(
        registerParamViewModel.name, registerParamViewModel.birthDay, registerParamViewModel.lastPeriod, registerParamViewModel.sex,
        registerParamViewModel.circleDay, registerParamViewModel.periodDay,
        prefs.getString('deviceToken'), value,value, password,
        cycleInfo.cycle,registerParamViewModel.nationality == 'AF' ? 1 : 0,
        registerParamViewModel.calendarType,status
    );

     // if(status == 1){
       await setCycleCalender(menstrualCalendarModel,token,animations,value,password,context,status,isChangeStatus,womansubscribtion);
     // }
     // else{
     //   createAlarmDaily(menstrualCalendarModel, token, animations, value, password, context,status,isChangeStatus);
     // }

  }

  generatePregnancyCycles(RegisterParamViewModel register,bool hasAbortion){
    var pregnancyNumberInfo = locator<PregnancyNumberModel>();
    var cycleInfo = locator<CycleModel>();
    List<CycleViewModel> cycles = cycleInfo.cycle;

    List<int> counterRemoves = [];
    if(register.status == 1){
      DateTime lastPeriod = DateTime.parse(register.lastPeriod!);
      // if(pregnancyNumberInfo.pregnancyNumbers.weekNoPregnancy < 5){
      //   DateTime givingBirth;
      //   if(register.isDeliveryDate){
      //     givingBirth = register.pregnancyDate;
      //     lastPeriod = DateTime(givingBirth.year,givingBirth.month,givingBirth.day - 280);
      //   }else{
      //     lastPeriod = register.pregnancyDate;
      //   }
      //   _registerModel.registerInfo.setLastPeriod(lastPeriod.toString());
      // }
      for(int i=0 ; i<cycles.length ; i++){
        if(cycles[i].status == 2 || cycles[i].status == 3){
          DateTime periodStart = DateTime.parse(cycles[i].periodStart!);
          DateTime circleEnd = DateTime.parse(cycles[i].circleEnd!);
          DateTime tomorrowCircleEnd = DateTime(circleEnd.year,circleEnd.month,circleEnd.day+1);
          if(periodStart.isAfter(lastPeriod) ||
              (periodStart.year == lastPeriod.year && periodStart.month == lastPeriod.month && periodStart.day == lastPeriod.day )){
            counterRemoves.add(i);
          }else if(lastPeriod.isAfter(periodStart)
              && lastPeriod.isBefore(tomorrowCircleEnd)){
            cycleInfo.updateCycle(i,
                CycleViewModel.fromJson(
                    {
                      'periodStartDate' : cycles[i].periodStart,
                      'periodEndDate' : cycles[i].periodEnd,/// ==> اگر ختم بارداری باشد peiodEnd را خارج از دوره فعلی میزاریم تا بتوان در تقویم روز پایان بارداری را به دست آورد
                      'cycleEndDate' : DateTime(lastPeriod.year,lastPeriod.month,lastPeriod.day-1).toString(),
                      'status' : cycles[i].status,
                      'before' : cycles[i].before,
                      'after' : cycles[i].after,
                      'mental' : cycles[i].mental,
                      'other' : cycles[i].other,
                      'ovu' : cycles[i].ovu,
                    }
                )
            );
          }
        }
      }
      if (counterRemoves.length != 0) {
        cycleInfo.removeRangeCycle(counterRemoves[0], counterRemoves[counterRemoves.length - 1] + 1);
      }

      List<CycleViewModel> newCycles = cycleInfo.cycle;
      if(hasAbortion && newCycles.isNotEmpty){
        if(newCycles[newCycles.length - 1].status == 2){
          cycleInfo.updateCycle(newCycles.length - 1,
              CycleViewModel.fromJson(
                  {
                    'periodStartDate' : newCycles[newCycles.length - 1].periodStart,
                    'periodEndDate' : DateTime(3000,1,1).toString(),/// ==> اگر ختم بارداری باشد peiodEnd را خارج از دوره فعلی میزاریم تا بتوان در تقویم روز پایان بارداری را به دست آورد
                    'cycleEndDate' : newCycles[newCycles.length - 1].circleEnd,
                    'status' : newCycles[newCycles.length - 1].status,
                    'before' : newCycles[newCycles.length - 1].before,
                    'after' : newCycles[newCycles.length - 1].after,
                    'mental' : newCycles[newCycles.length - 1].mental,
                    'other' : newCycles[newCycles.length - 1].other,
                    'ovu' : newCycles[newCycles.length - 1].ovu,
                  }
              )
          );
        }
      }

      saveCirclesToLocal(register);
    }else {
      DateTime lastPeriod = pregnancyNumberInfo.pregnancyNumbers.lastPeriod!;
      DateTime? childBirthDate = register.childBirthDate;

      List<int> counterRemoves = [];

      if (cycleInfo.cycle.isNotEmpty) {
        for (int i = 0; i < cycleInfo.cycle.length; i++) {
          // print(circlesItem[i].circleEnd);
          if (
          lastPeriod.isBefore(DateTime.parse(cycleInfo.cycle [i].circleEnd!))) {
            // print('11111111');
            counterRemoves.add(i);
          }
        }
      }
      // print(circlesItem.length);
      if (counterRemoves.length != 0) {
        // circlesItem.removeRange(counterRemoves[0], counterRemoves[counterRemoves.length-1]+1);
        cycleInfo.removeRangeCycle(counterRemoves[0], counterRemoves[counterRemoves.length - 1] + 1);
      }


      if(register.status == 2){
        List<CycleViewModel> reverseCycles = cycleInfo.cycle.reversed.toList();
        for(int i=0 ; i<reverseCycles.length ; i++){
          if(reverseCycles[i].status == 2){
            cycleInfo.removeCycle(cycleInfo.cycle.length - 1);
          }else{
            break;
          }
        }
      }


      for (int i = 0; i < 40; i++) {
        DateTime circleEnd = DateTime(lastPeriod.year, lastPeriod.month, lastPeriod.day + (i * 7) + 6);
        if(childBirthDate != null){
          if (register.status == 3 && circleEnd.isAfter(childBirthDate)) {
            circleEnd = childBirthDate;
          }
        }
        // circlesItem.add(
        //     CycleViewModel(
        //       periodStart: DateTime(lastPeriod.year,lastPeriod.month,lastPeriod.day+(i*7)).toString(),
        //       circleEnd: circleEnd.toString(),
        //     )
        // );
        cycleInfo.addCycle(
            {
              'periodStartDate': DateTime(lastPeriod.year, lastPeriod.month, lastPeriod.day + (i * 7)).toString(),
              'cycleEndDate': circleEnd.toString(),
              'status': 2
            }
        );
        if (circleEnd == childBirthDate) {
          break;
        }
      }

      if (register.status == 3) {
        DateTime startDate = DateTime(childBirthDate!.year, childBirthDate.month, childBirthDate.day + 1);
        for (int i = 0; i < 25; i++) {
          cycleInfo.addCycle(
              {
                'periodStartDate': DateTime(startDate.year, startDate.month, startDate.day + (i * 7)).toString(),
                'cycleEndDate': DateTime(startDate.year, startDate.month, startDate.day + (i * 7) + 6).toString(),
                'status': 3
              }
          );
        }
      }
    }
  }


  Future<bool> setCycleCalender(SetMenstrualCalendarModel menstrualCalendarModel ,
      String token, Animations animations,value,password,context,status,bool isChangeStatus,bool womansubscribtion)async{
    // print(cycles);
    // print(menstrualCalendarModel.setMenstrualCalendar);
    print('aaaaa');
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'info/setcycleCalender',
        'POST',
        {
          "cycles" : menstrualCalendarModel.setMenstrualCalendar
        },
        token
    );
    //print('bbbbb');
    // print("setCycleCalender$responseBody");
    if(responseBody != null){
      if(responseBody.isNotEmpty){
        if(responseBody['isValid']){
          createAlarmDaily(menstrualCalendarModel, token, animations, value, password, context,status,isChangeStatus,womansubscribtion);
          // await setAlarmsCalenderToServer(token,animations,value,password,context);
        }else{
          showErrorForRequest(animations);
        }
      }else{
        showErrorForRequest(animations);
      }
    }else{
      showErrorForRequest(animations);
    }
    return true;
  }
  Future<bool> createAlarmDaily(SetMenstrualCalendarModel menstrualCalendarModel ,
      String token, Animations animations,value,password,context,status,bool isChangeStatus,bool womansubscribtion)async{
    if(isChangeStatus){
      succeedSaveData(token, value, password, context,animations,status,isChangeStatus,womansubscribtion);
    }else{
      List<DailyRemindersViewModel>? dailyAlarms = await _registerModel.getDailyReminders();
      List<Map<String,dynamic>> list = [];
      for(int i=0 ; i<dailyAlarms!.length ; i++) {
        list.add(
            {
              "category": dailyAlarms[i].id! < 26 ? 0 : dailyAlarms[i].id! ~/ 100,
              "title": dailyAlarms[i].title,
              "time": dailyAlarms[i].time,
              "day": dayWeekToDecimal(dailyAlarms[i].dayWeek),
              "mode": dailyAlarms[i].mode,
              "sound": dailyAlarms[i].isSound == 0 ? false : true,
              "clientId": dailyAlarms[i].id.toString()
            }
        );
      }

      Map<String,dynamic>? responseBody = await Http().sendRequest(
          womanUrl,
          'date/alrams',
          'PUT',
          {
            'list' : list
          },
          token
      );
      // print(responseBody);
      if(responseBody != null){
        if(responseBody.isNotEmpty){
          if(responseBody['isValid']){
            succeedSaveData(token, value, password, context,animations,status,isChangeStatus,womansubscribtion);
          }else{
            showErrorForRequest(animations);
          }
        }else{
          showErrorForRequest(animations);
        }
      }else{
        showErrorForRequest(animations);
      }
    }
    return true;
  }
  // setAlarmsCalenderToServer(token,typeReq , Animations animations,value,password,context)async{
  //   List<AlarmViewModel> alarms = await _registerModel.getAlarms();
  //   List<AlarmViewModel> alarmsWithServerId = [];
  //   List<AlarmViewModel> alarmsLessServerId = [];
  //   if(alarms != null){
  //     if(alarms.length != 0){
  //       for(int i=0 ; i<alarms.length ; i++){
  //         if(alarms[i].serverId == ''){
  //           alarmsLessServerId.add(alarms[i]);
  //           // await createAlarmCalender(token,alarms[i].id,alarms[i].text,alarms[i].description,DateTime.parse("${alarms[i].date} ${alarms[i].hour}:${alarms[i].minute}").toString(), alarms[i].isActive,typeReq,animations);
  //         }
  //         else if(alarms[i].serverId != ''){
  //           alarmsWithServerId.add(alarms[i]);
  //           // await changeAlarmCalender(alarms[i].serverId,token,alarms[i].text,alarms[i].description,DateTime.parse("${alarms[i].date} ${alarms[i].hour}:${alarms[i].minute}").toString(), alarms[i].isActive,typeReq,animations);
  //         }
  //       }
  //     }
  //   }
  //   if(alarmsLessServerId.isNotEmpty){
  //     await createAlarmCalender(token,alarmsLessServerId,alarmsWithServerId,typeReq, animations,value,password,context);
  //   }else if(alarmsWithServerId.isNotEmpty){
  //     await changeAlarmCalender(token, alarmsWithServerId, typeReq, animations,value,password,context);
  //   }else{
  //     setRemoverAlarmCalender(token, typeReq, animations,value,password,context);
  //   }
  // }
  // setRemoverAlarmCalender(token,typeReq , Animations animations,value,password,context)async{
  //   List<RemoveAlarmsModel> removes = await _registerModel.getRemoveAlarms();
  //   List<RemoveAlarmsModel> alarmCalenderRemoves = [];
  //   if(removes != null){
  //     if(removes.length !=0 ){
  //       for(int i=0 ; i<removes.length ; i++){
  //         if(removes[i].mode == 0){
  //           alarmCalenderRemoves.add(removes[i]);
  //           // await deleteAlarmCalender(token, removes[i].serverId,typeReq,animations);
  //         }
  //       }
  //     }
  //   }
  //   if(alarmCalenderRemoves.isNotEmpty){
  //     await deleteAlarmCalender(token,alarmCalenderRemoves,typeReq,animations,value,password,context);
  //   }else{
  //     setAlarmsDailyToServer(token, typeReq, animations,value,password,context);
  //   }
  // }
  // Future<bool> createAlarmCalender(String token ,List<AlarmViewModel> alarmsLessServerId,List<AlarmViewModel> alarmsWithServerId,typeReq , Animations animations,value,password,context)async{
  //   // print("createAlarmCalender");
  //   // await createAlarmCalender(token,alarms[i].id,alarms[i].text,alarms[i].description,DateTime.parse("${alarms[i].date} ${alarms[i].hour}:${alarms[i].minute}").toString(), alarms[i].isActive,typeReq,animations);
  //   Map<String,dynamic> responseBody = await Http().sendRequest(
  //       womanUrl,
  //       'date/note',
  //       'PUT',
  //       {
  //         "title" : alarmsLessServerId[indexAlarmsLessServerId].text,
  //         "text" :  alarmsLessServerId[indexAlarmsLessServerId].description,
  //         // "dateTime" : "${alarmsLessServerId[indexAlarmsLessServerId].date} ${alarmsLessServerId[indexAlarmsLessServerId].hour}:${alarmsLessServerId[indexAlarmsLessServerId].minute}",
  //         "dateTime" : DateTime(DateTime.parse(alarmsLessServerId[indexAlarmsLessServerId].date).year,DateTime.parse(alarmsLessServerId[indexAlarmsLessServerId].date).month,DateTime.parse(alarmsLessServerId[indexAlarmsLessServerId].date).day,alarmsLessServerId[indexAlarmsLessServerId].hour,alarmsLessServerId[indexAlarmsLessServerId].minute).toString(),
  //         "reminder" : alarmsLessServerId[indexAlarmsLessServerId].isActive == 0 ? false : true
  //       },
  //       token
  //   );
  //   if(responseBody != null){
  //     if(responseBody.isNotEmpty){
  //       if(responseBody['isValid']){
  //         await updateAlarmCalender(alarmsLessServerId[indexAlarmsLessServerId].id, responseBody['id']);
  //         if(indexAlarmsLessServerId < alarmsLessServerId.length-1){
  //           indexAlarmsLessServerId++;
  //           await createAlarmCalender(token, alarmsLessServerId, alarmsWithServerId, typeReq, animations,value,password,context);
  //         }else if(alarmsWithServerId.isNotEmpty){
  //           indexAlarmsLessServerId = 0;
  //           await changeAlarmCalender(token, alarmsWithServerId, typeReq, animations,value,password,context);
  //         }else{
  //           setRemoverAlarmCalender(token, typeReq, animations, value, password, context);
  //         }
  //       }else{
  //         showErrorForRequest(typeReq, animations);
  //       }
  //     }else{
  //       showErrorForRequest(typeReq, animations);
  //     }
  //   }else{
  //     showErrorForRequest(typeReq, animations);
  //   }
  //   return true;
  // }
  // Future<bool> changeAlarmCalender(String token,List<AlarmViewModel> alarmsWithServerId,typeReq , Animations animations,value,password,context)async{
  //   Map<String,dynamic> responseBody = await Http().sendRequest(
  //       womanUrl,
  //       'date/note',
  //       'POST',
  //       {
  //         "noteId" : alarmsWithServerId[indexAlarmsWithServerId].serverId,
  //         "title" : alarmsWithServerId[indexAlarmsWithServerId].text,
  //         "text" :  alarmsWithServerId[indexAlarmsWithServerId].description,
  //         "dateTime" : DateTime(DateTime.parse(alarmsWithServerId[indexAlarmsWithServerId].date).year,DateTime.parse(alarmsWithServerId[indexAlarmsWithServerId].date).month,DateTime.parse(alarmsWithServerId[indexAlarmsWithServerId].date).day,alarmsWithServerId[indexAlarmsWithServerId].hour,alarmsWithServerId[indexAlarmsWithServerId].minute).toString(),
  //         "reminder" : alarmsWithServerId[indexAlarmsWithServerId].isActive == 0 ? false : true
  //       },
  //       token
  //   );
  //   if(responseBody != null){
  //     if(responseBody.isNotEmpty){
  //       if(responseBody['isValid']){
  //         if(indexAlarmsWithServerId < alarmsWithServerId.length-1){
  //           indexAlarmsWithServerId++;
  //           await changeAlarmCalender(token, alarmsWithServerId, typeReq, animations,value,password,context);
  //         }else{
  //           indexAlarmsWithServerId = 0;
  //           setRemoverAlarmCalender(token, typeReq, animations,value,password,context);
  //         }
  //       }else{
  //         showErrorForRequest(typeReq, animations);
  //       }
  //     }else{
  //       showErrorForRequest(typeReq, animations);
  //     }
  //   }else{
  //     showErrorForRequest(typeReq, animations);
  //   }
  //   return true;
  // }
  // Future<bool> deleteAlarmCalender(String token ,List<RemoveAlarmsModel> alarmRemoves,typeReq , Animations animations,value,password,context)async{
  //   Map<String,dynamic> responseBody = await Http().sendRequest(
  //       womanUrl,
  //       'date/note',
  //       'DELETE',
  //       {
  //         "noteId" : alarmRemoves[indexRemoveAlarmCalender].serverId,
  //       },
  //       token
  //   );
  //   if(responseBody != null){
  //     if(responseBody.isNotEmpty){
  //       if(responseBody['isValid']){
  //         await deleteRemoveTable(alarmRemoves[indexRemoveAlarmCalender].id);
  //         if(indexRemoveAlarmCalender < alarmRemoves.length-1){
  //           indexRemoveAlarmCalender++;
  //           await deleteAlarmCalender(token, alarmRemoves, typeReq, animations,value,password,context);
  //         }else{
  //           indexRemoveAlarmCalender =0;
  //           setAlarmsDailyToServer(token, typeReq, animations,value,password,context);
  //         }
  //       }else{
  //         showErrorForRequest(typeReq, animations);
  //       }
  //     }else{
  //       showErrorForRequest(typeReq, animations);
  //     }
  //   }else{
  //     showErrorForRequest(typeReq, animations);
  //   }
  //   return true;
  // }
  // setAlarmsDailyToServer(token,typeReq , Animations animations,value,password,context)async{
  //   List<DailyRemindersViewModel> reminders = await _registerModel.getDailyReminders();
  //   List<Map<String,dynamic>> remindersWithServerId = [];
  //   List<Map<String,dynamic>> remindersLessServerId = [];
  //   List<int> idsLessServerIds = [];
  //   if(reminders != null){
  //     if(reminders.length != 0){
  //       for(int i=0 ; i<reminders.length ; i++){
  //         if(reminders[i].serverId == '' && reminders[i].mode != 0){
  //           remindersLessServerId.add(
  //               {
  //                 "category" : reminders[i].id < 26 ? 0 : reminders[i].id ~/100,
  //                 "title" : reminders[i].title,
  //                 "time" : reminders[i].time,
  //                 "day" : dayWeekToDecimal(reminders[i].dayWeek),
  //                 "mode" : reminders[i].mode,
  //                 "sound" : reminders[i].isSound == 0 ? false : true,
  //                 "clientId" : reminders[i].id.toString()
  //               }
  //           );
  //           idsLessServerIds.add(reminders[i].id);
  //           // await createAlarmDaily(token,reminders[i].id,reminders[i].id < 26 ? 0 : reminders[i].id, reminders[i].title, reminders[i].time,reminders[i].dayWeek, reminders[i].mode, reminders[i].isSound, typeReq, animations);
  //         }else if(reminders[i].serverId != '' && reminders[i].mode != 0){
  //           remindersWithServerId.add(
  //               {
  //                 "alramId" :  reminders[i].serverId,
  //                 "category" : reminders[i].id < 26 ? 0 : reminders[i].id ~/100,
  //                 "title" : reminders[i].title,
  //                 "time" : reminders[i].time,
  //                 "day" : dayWeekToDecimal(reminders[i].dayWeek),
  //                 "mode" : reminders[i].mode,
  //                 "sound" : reminders[i].isSound == 0 ? false : true,
  //                 "clientId" : reminders[i].id.toString()
  //               }
  //           );
  //           // await changeAlarmDaily(token,reminders[i].serverId,reminders[i].id < 26 ? 0 : reminders[i].id, reminders[i].title, reminders[i].time, reminders[i].dayWeek, reminders[i].mode, reminders[i].isSound, typeReq, animations);
  //         }
  //       }
  //     }
  //   }
  //   // print(remindersLessServerId.length);
  //   if(remindersLessServerId.isNotEmpty){
  //     await createAlarmDaily(token, remindersLessServerId, remindersWithServerId,idsLessServerIds,typeReq, animations,value,password,context);
  //   }else if(remindersWithServerId.isNotEmpty){
  //     await changeAlarmDaily(token, remindersWithServerId,typeReq, animations,value,password,context);
  //   }
  //   else{
  //     // succeedSaveData(typeReq, value, password, context);
  //     setRemoveReminder(token, typeReq, animations,value,password,context);
  //   }
  //   // List<RemoveAlarmsModel> removes = await _dashboardModel.getRemoveAlarms();
  //   // if(removes != null){
  //   //   if(removes.length !=0 ){
  //   //     for(int i=0 ; i<removes.length ; i++){
  //   //       if(removes[i].mode == 1){
  //   //         await deleteAlarmDaily(token, removes[i].serverId,typeReq,animations);
  //   //       }
  //   //     }
  //   //   }
  //   // }
  // }
  // setRemoveReminder(token,typeReq , Animations animations,value,password,context)async{
  //   List<RemoveAlarmsModel> removes = await _registerModel.getRemoveAlarms();
  //   List<RemoveAlarmsModel> reminderRemoves = [];
  //   if(removes != null){
  //     if(removes.length !=0 ){
  //       for(int i=0 ; i<removes.length ; i++){
  //         if(removes[i].mode == 1){
  //           reminderRemoves.add(removes[i]);
  //           // await deleteAlarmCalender(token, removes[i].serverId,typeReq,animations);
  //         }
  //       }
  //     }
  //   }
  //   if(reminderRemoves.isNotEmpty){
  //     await deleteAlarmDaily(token,reminderRemoves, typeReq, animations,value,password,context);
  //     // await deleteAlarmCalender(token,alarmCalenderRemoves,typeReq,animations);
  //   }else{
  //     succeedSaveData(typeReq,token,value, password, context);
  //     // setAlarmsDailyToServer(token, typeReq, animations);
  //   }
  // }
  // Future<bool> createAlarmDaily(String token ,List<Map<String,dynamic>> remindersLessServerId,List<Map<String,dynamic>> remindersWithServerId,List<int> idsLessServerId,typeReq , Animations animations,value,password,context)async{
  //   // print("createAlarmDaily");
  //   // print(remindersLessServerId.length);
  //   // print(remindersLessServerId[indexReminderLessServerId].id~/100);
  //   // print(remindersLessServerId[indexReminderLessServerId].title);
  //   // print(remindersLessServerId[indexReminderLessServerId].time);
  //   // print(dayWeekToDecimal(remindersLessServerId[indexReminderLessServerId].dayWeek));
  //   // print(remindersLessServerId[indexReminderLessServerId].mode);
  //   // print(remindersLessServerId[indexReminderLessServerId].isSound);
  //   Map<String,dynamic> responseBody = await Http().sendRequest(
  //       womanUrl,
  //       'date/alrams',
  //       'PUT',
  //       {
  //         'list' : remindersLessServerId
  //       },
  //       // {
  //       //   "category" : remindersLessServerId[indexReminderLessServerId].id < 26 ? 0 : remindersLessServerId[indexReminderLessServerId].id~/100,
  //       //   "title" : remindersLessServerId[indexReminderLessServerId].title,
  //       //   "time" : remindersLessServerId[indexReminderLessServerId].time,
  //       //   "day" : dayWeekToDecimal(remindersLessServerId[indexReminderLessServerId].dayWeek),
  //       //   "mode" : remindersLessServerId[indexReminderLessServerId].mode,
  //       //   "sound" : remindersLessServerId[indexReminderLessServerId].isSound == 0 ? false : true
  //       // },
  //       token
  //   );
  //   // print(responseBody);
  //   if(responseBody != null){
  //     if(responseBody.isNotEmpty){
  //       if(responseBody['isValid']){
  //         await updateAlarmDaily(idsLessServerId, responseBody['ids']);
  //         // if(indexReminderLessServerId < remindersLessServerId.length-1){
  //         //   indexReminderLessServerId++;
  //         // await createAlarmDaily(token, remindersLessServerId, remindersWithServerId, typeReq, animations,value,password,context,randomMessage);
  //         if(remindersWithServerId.isNotEmpty){
  //           // indexReminderLessServerId = 0;
  //           await changeAlarmDaily(token, remindersWithServerId, typeReq, animations,value,password,context);
  //         }else{
  //           // succeedSaveData(typeReq, value, password, context);
  //           setRemoveReminder(token, typeReq, animations, value, password, context);
  //         }
  //       }else{
  //         showErrorForRequest(typeReq, animations);
  //       }
  //     }else{
  //       showErrorForRequest(typeReq, animations);
  //     }
  //   }else{
  //     showErrorForRequest(typeReq, animations);
  //   }
  //   return true;
  // }
  // Future<bool> changeAlarmDaily(String token ,List<Map<String,dynamic>> remindersWithServerId,typeReq , Animations animations,value,password,context)async{
  //   // print('changeAlarmDaily');
  //   Map<String,dynamic> responseBody = await Http().sendRequest(
  //       womanUrl,
  //       'date/alrams',
  //       'POST',
  //       {
  //         'list' : remindersWithServerId
  //       },
  //       // {
  //       //   "alramId" :  remindersWithServerId[indexReminderWithServerId].serverId,
  //       //   "category" : remindersWithServerId[indexReminderWithServerId].id < 26 ? 0 : remindersWithServerId[indexReminderWithServerId].id~/100,
  //       //   "title" : remindersWithServerId[indexReminderWithServerId].title,
  //       //   "time" : remindersWithServerId[indexReminderWithServerId].time,
  //       //   "day" : dayWeekToDecimal(remindersWithServerId[indexReminderWithServerId].dayWeek),
  //       //   "mode" : remindersWithServerId[indexReminderWithServerId].mode,
  //       //   "sound" : remindersWithServerId[indexReminderWithServerId].isSound == 0 ? false : true
  //       // },
  //       token
  //   );
  //   if(responseBody != null){
  //     if(responseBody.isNotEmpty){
  //       if(responseBody['isValid']){
  //         // if(indexReminderWithServerId < remindersWithServerId.length-1){
  //         //   indexReminderWithServerId++;
  //         //   await changeAlarmDaily(token, remindersWithServerId, typeReq, animations,value,password,context,randomMessage);
  //         // }else{
  //         //   indexReminderWithServerId = 0;
  //           setRemoveReminder(token, typeReq, animations,value,password,context);
  //         // succeedSaveData(typeReq, value, password, context);
  //         // }
  //       }else{
  //         showErrorForRequest(typeReq, animations);
  //       }
  //     }else{
  //       showErrorForRequest(typeReq, animations);
  //     }
  //   }else{
  //     showErrorForRequest(typeReq, animations);
  //   }
  //   return true;
  // }
  // Future<bool> deleteAlarmDaily(String token ,List<RemoveAlarmsModel> remindersRemoves,typeReq , Animations animations,value,password,context)async{
  //   Map<String,dynamic> responseBody = await Http().sendRequest(
  //       womanUrl,
  //       'date/alram',
  //       'DELETE',
  //       {
  //         "alramId" : remindersRemoves[indexRemoveReminder].serverId,
  //       },
  //       token
  //   );
  //   if(responseBody != null){
  //     if(responseBody.isNotEmpty){
  //       if(responseBody['isValid']){
  //         await deleteRemoveTable(remindersRemoves[indexRemoveReminder].id);
  //         if(indexRemoveReminder < remindersRemoves.length-1){
  //           indexRemoveReminder++;
  //           await deleteAlarmCalender(token, remindersRemoves, typeReq, animations,value,password,context);
  //         }else{
  //           indexRemoveReminder =0;
  //           succeedSaveData(typeReq,token,value, password, context);
  //           // setAlarmsDailyToServer(token, typeReq, animations);
  //         }
  //       }else{
  //         showErrorForRequest(typeReq, animations);
  //       }
  //     }else{
  //       showErrorForRequest(typeReq, animations);
  //     }
  //   }else{
  //     showErrorForRequest(typeReq, animations);
  //   }
  //   return true;
  // }
  showErrorForRequest( Animations animations){
    if(!isLoading.isClosed){
      isLoading.sink.add(false);
    }
      animations.showShakeError('خطا در برقراری اتصال، اینترنت خود را بررسی کنید');
  }
  int dayWeekToDecimal(days){
    // print(days);
    // List dayWeek = json.decode(days);
    List dayWeek = days != '' ? json.decode(days) : [];
    int a =0;
    if(dayWeek.isNotEmpty){
      for(int i=0 ; i<dayWeek.length ; i++){
        if(dayWeek[i] == 0){
          a= a+1;
        }else if(dayWeek[i] == 1){
          a=a+2;
        }else if(dayWeek[i] == 2){
          a=a+4;
        }else if(dayWeek[i] == 3){
          a=a+8;
        }else if(dayWeek[i] == 4){
          a=a+16;
        }else if(dayWeek[i] == 5){
          a=a+32;
        }else if(dayWeek[i] == 6){
          a=a+64;
        }
      }
    }
    return a;
  }
  // Future<bool> updateAlarmCalender(int id , String serverId)async{
  //   _registerModel.updateServerIdAlarmCalender(id,{"serverId" : serverId});
  //   return true;
  // }
  // Future<bool> deleteRemoveTable(int id)async{
  //   _registerModel.deleteRemoveTable(id);
  //   return true;
  // }
  // Future<bool> updateAlarmDaily(List<int> ids , List<dynamic> serverIds)async{
  //   for(int i=0 ; i<ids.length ; i++){
  //     _registerModel.updateServerIdAlarmDaily(ids[i],{"serverId" : serverIds[i]});
  //   }
  //   return true;
  // }
  succeedSaveData(String token, value , password,context,animations,status,bool isChangeStatus,bool womansubscribtion)async{
    await getAllData(token, context, value, password,animations,status,isChangeStatus,womansubscribtion);
    // if(!isLoading.isClosed){
    //   isLoading.sink.add(false);
    // }
    //
    // saveUserName(value,password);
    //
    //   Navigator.push(
    //       context,
    //       PageTransition(
    //           settings: RouteSettings(name: "/Page1"),
    //           type: PageTransitionType.fade,
    //           duration: Duration(milliseconds: 500),
    //           child:  FeatureDiscovery(
    //             recordStepsInSharedPreferences: true,
    //             child:  Home(
    //               indexTab: 2,
    //               // indexTab: prefs.getBool('ieExpert') ? 1 : 4,
    //             ),
    //           )
    //       )
    //   );
  }
  // saveUserName(phoneOrEmail,password)async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('userName', phoneOrEmail);
  //   prefs.setString('password', password);
  //   // prefs.setInt('typeValue', typeValue);
  // }
  ///Ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssset


  ///Gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggget
  getMenstrualCalendar(userName,password,context,String token,animations,int status,bool womansubscribtion)async{
    await getAllData(token, context, userName, password, animations,status,false,womansubscribtion);
  }

  getAllData(String token,context , identity , password,animations,status,bool isChangeStatus,bool womansubscribtion)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String infoController;
    if(status == 2){
      infoController = 'pregnancyInfo';
    }else if(status == 3){
      infoController = 'breastfeedingInfo';
    }else{
      infoController = 'info';
    }
    prefs.setString(infoController,'infoController');
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        '$infoController/allDatav6',
        'GET',
        {},
        token
    );
    // print('getAllData');
    // print(responseBody);
    List<AlarmViewModel> alarms = [];
    List<DailyRemindersViewModel> reminders = [];
    if(responseBody != null){
      if(responseBody.isNotEmpty){
        
        if(status == 2){
          //pregnancyInfo
          _getMenstrualCalendarModel.setIsDeliveryDate(responseBody['pregnancyInfo']['isDeliveryDate']);
          _getMenstrualCalendarModel.setPregnancyDate(DateTime.parse(responseBody['pregnancyInfo']['pregnancyDate']));
          _getMenstrualCalendarModel.setPregnancyNo(responseBody['pregnancyInfo']['pregnancyNo']);
          _getMenstrualCalendarModel.setHasAboration(responseBody['pregnancyInfo']['hasAboration']);
          
        }else if(status == 3){
          //breastfeedingInfo
          _getMenstrualCalendarModel.setChildName(responseBody['breastfeedingInfo']['childName']);
          _getMenstrualCalendarModel.setChildBirthDate(DateTime.parse(responseBody['breastfeedingInfo']['childBirthDate']));
          _getMenstrualCalendarModel.setChildType(responseBody['breastfeedingInfo']['childType']);
          _getMenstrualCalendarModel.setChildBirthType(responseBody['breastfeedingInfo']['childBirthType']);


          _getMenstrualCalendarModel.setIsDeliveryDate(responseBody['pregnancyInfo']['isDeliveryDate']);
          _getMenstrualCalendarModel.setPregnancyDate(DateTime.parse(responseBody['pregnancyInfo']['pregnancyDate']));
          _getMenstrualCalendarModel.setPregnancyNo(responseBody['pregnancyInfo']['pregnancyNo']);
          _getMenstrualCalendarModel.setHasAboration(responseBody['pregnancyInfo']['hasAboration']);

        }else{
          //cycleInfo
          // _getMenstrualCalendarModel.setStartDatePeriod(responseBody['cycleInfo']['startDate']);
          // _getMenstrualCalendarModel.stCycleLng(responseBody['cycleInfo']['totalLength']);
          // _getMenstrualCalendarModel.setPeriodLng(responseBody['cycleInfo']['periodLength']);
        }

        _getMenstrualCalendarModel.setStartDatePeriod(responseBody['cycleInfo']['startDate']);
        _getMenstrualCalendarModel.stCycleLng(responseBody['cycleInfo']['totalLength']);
        _getMenstrualCalendarModel.setPeriodLng(responseBody['cycleInfo']['periodLength']);

        //generalInfo
        _getMenstrualCalendarModel.setMaritalStatus(responseBody['generalInfo']['sexualStatus']);
        _getMenstrualCalendarModel.setName(responseBody['generalInfo']['name']);
        _getMenstrualCalendarModel.setNationality(responseBody['generalInfo']['nationality']);
        _getMenstrualCalendarModel.setCalendarType(responseBody['generalInfo']['calendarType']);
        _getMenstrualCalendarModel.setSignText(responseBody['signText']);
        _getMenstrualCalendarModel.setPeriodStatus(responseBody['generalInfo']['periodStatus']);

        DateTime date = DateTime(
          DateTime.parse(responseBody['generalInfo']['birthDate']).year,
          DateTime.parse(responseBody['generalInfo']['birthDate']).month,
          DateTime.parse(responseBody['generalInfo']['birthDate']).day,
        );
        Jalali _jalaliDate = Jalali.fromDateTime(date);
        _getMenstrualCalendarModel.setBirthDate(_jalaliDate.toString().replaceAll('Jalali', '').replaceAll('(', '').replaceAll(')', ''));


        //getIsPair
        prefs.setBool('pair', !responseBody['pairData']['validToken']);

        //cycleCalendars
        _getMenstrualCalendarModel.setCalander(responseBody['cycleCalendars']);

        //getAlarmCalender
        if(responseBody['notes'] != []){
          responseBody['notes'].forEach((item){
            alarms.add(AlarmViewModel.fromJson(
                {
                  'date' : item['time'],
                  'hour' : DateTime.parse(item['time']).hour,
                  'minute' : DateTime.parse(item['time']).minute,
                  'text' : item['title'],
                  'description' : item['text'],
                  'isActive' : item['reminder'] ? 1 : 0,
                  'serverId' : item['noteId'],
                  'fileName' : item['fileName'].toString().replaceAll('[','').replaceAll(']','').replaceAll(',', ''),
                  'isChange' : 0,
                  'mode' : 0,
                  'readFlag' : 1
                }
            ));
          });
        }

        //shareNotes
        // if(responseBody['shareNotes']['rcvNotes'] != []){
        //   responseBody['shareNotes']['rcvNotes'].forEach((item){
        //     alarms.add(AlarmViewModel.fromJson(
        //         {
        //           'date' : item['time'],
        //           'hour' : DateTime.parse(item['time']).hour,
        //           'minute' : DateTime.parse(item['time']).minute,
        //           'text' : item['title'],
        //           'description' : item['text'],
        //           'isActive' : item['reminder'] ? 1 : 0,
        //           'serverId' : item['noteId'],
        //           'fileName' : item['fileName'].toString().replaceAll('[','').replaceAll(']','').replaceAll(',', ''),
        //           'isChange' : 0,
        //           'mode' : 2,
        //           'readFlag' : item['readFlag'] ? 1 : 0
        //         }
        //     ));
        //   });
        // }
        //
        // if(responseBody['shareNotes']['sendNotes'] != []){
        //   responseBody['shareNotes']['sendNotes'].forEach((item){
        //     alarms.add(AlarmViewModel.fromJson(
        //         {
        //           'date' : item['time'],
        //           'hour' : DateTime.parse(item['time']).hour,
        //           'minute' : DateTime.parse(item['time']).minute,
        //           'text' : item['title'],
        //           'description' : item['text'],
        //           'isActive' : item['reminder'] ? 1 : 0,
        //           'serverId' : item['noteId'],
        //           'fileName' :  item['fileName'].toString().replaceAll('[','').replaceAll(']','').replaceAll(',', ''),
        //           'isChange' : 0,
        //           'mode' : 1,
        //           'readFlag':  1
        //         }
        //     ));
        //   });
        // }
        _getMenstrualCalendarModel.setAlarms(alarms);


        //alrams
        if(responseBody['alrams'] != []){
          for(int i=0 ; i<responseBody['alrams'].length ; i++){
            reminders.add(
                DailyRemindersViewModel.fromJson(
                    {
                      'id' : int.parse(responseBody['alrams'][i]['clientId']),
                      'title' : responseBody['alrams'][i]['title'],
                      'mode' : responseBody['alrams'][i]['mode'],
                      'isSound' : responseBody['alrams'][i]['sound'] ? 1 : 0,
                      'time' : TimeOfDay(hour: DateTime.parse(responseBody['alrams'][i]['time']).hour, minute: DateTime.parse(responseBody['alrams'][i]['time']).minute).format(context),
                      'dayWeek' : decimalToDayWeek(responseBody['alrams'][i]['days']),
                      'serverId' : responseBody['alrams'][i]['alramId'],
                      'isChange' : 0
                    }
                ));
          }
          _getMenstrualCalendarModel.setReminders(reminders);
        }else{
          _getMenstrualCalendarModel.setReminders([]);
        }


        var registerInfo = locator<RegisterParamModel>();
        var partnerInfo = locator<PartnerModel>();
        registerInfo.setNationality(
            responseBody['generalInfo']['nationality'] == 0 ? 'IR' : 'AF'
        );
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
              'googleDownloadLink' : responseBody['pairData']['googleDownloadLink']
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



        //sign
        _getMenstrualCalendarModel.setSign(responseBody['sign']);


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

          if(womansubscribtion) {
            SaveDataOfflineMode().saveAllDataOfflineMode(responseBody['offlineDashboardMessages']);
          }

          var bottomBannerInfo = locator<BottomBannerModel>();
          bottomBannerInfo.addAllBottomBanner(responseBody['bottomBanner']);

        //final
        if(status == 1){
          if(_getMenstrualCalendarModel.getCycleLng <= 0 && _getMenstrualCalendarModel.getPeriodLng <= 0 && _getMenstrualCalendarModel.getCalander.isEmpty){

            showErrorLogin('خظایی رخ داده لطفا مجددا ثبت نام کنید',animations);

          }else{
            succeedAndSaveData(identity, password, token, context, status,animations,isChangeStatus,womansubscribtion);
          }

        }else{
          succeedAndSaveData(identity, password, token, context, status,animations,isChangeStatus,womansubscribtion);
        }

      }else{
        showErrorLogin('خطا در برقراری اتصال، اینترنت خود را بررسی کنید',animations);
      }
    }else{
      showErrorLogin('خطا در برقراری اتصال، اینترنت خود را بررسی کنید',animations);
    }
  }

  succeedAndSaveData(identity,password,token,context,status,animations,bool isChangeStatus,bool womansubscribtion){
    _getMenstrualCalendarModel.setToken(token);
    saveUserNameEnterAccount(identity, password, isEmail(identity) ? 1 : 0);
    saveDateToDb(_getMenstrualCalendarModel,context,status,animations,isChangeStatus,womansubscribtion);
  }

  String decimalToDayWeek(int a){
    List<int> days = [];
    for(int i=0 ; i<7 ; i++){
      if((a&(1 << i)) != 0){
        days.add(i);
      }
    }
    return days.isNotEmpty ? days.toString() : '';
  }
  showErrorLogin(String textError,animations){

    if(!isLoading.isClosed){
      isLoading.sink.add(false);
    }

    animations.showShakeError(textError);


  }
  saveUserNameEnterAccount(phoneOrEmail,password,typeValue)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', phoneOrEmail);
    prefs.setString('password', password);
    prefs.setInt('typeValue', typeValue);
  }
  saveDateToDb(GetMenstrualCalendarModel item,context,status,animations,bool isChangeStatus,bool womansubscribtion)async{

    DateTime? startPeriod;
    DateTime? endPeriod;
    DateTime? cycleEndDate;

    if(item.getCalander.isNotEmpty){
      startPeriod = DateTime.parse(item.getCalander[item.getCalander.length-1].periodStartDate);
      endPeriod = DateTime.parse(item.getCalander[item.getCalander.length-1].periodEndDate);
      cycleEndDate = DateTime.parse(item.getCalander[item.getCalander.length-1].cycleEndDate);
    }

    // Map<String,dynamic> map = {
    //   'name' : item.getName,
    //   'periodDay' : item.getPeriodLng <= 0 ? MyDateTime().myDifferenceDays(startPeriod, endPeriod) + 1 : item.getPeriodLng,
    //   'circleDay' : item.getCycleLng <= 0 ? MyDateTime().myDifferenceDays(startPeriod, cycleEndDate) + 1 : item.getCycleLng,
    //   'lastPeriod' : item.getStartDatePeriod,
    //   'birthDay' : item.getBirthDate,
    //   'typeSex' : item.getMaritalStatus,
    //   'nationality' : item.getNationality == 1 ? 'AF' : 'IR',
    //   'token' : item.getToken,
    //   'calendarType' : item.getCalendarType
    // };
    //
    //
    // RegisterParamViewModel registerParamViewModel;
    //
    // registerParamViewModel =   RegisterParamViewModel.fromJson(map);

    RegisterParamViewModel registerParamViewModel = RegisterParamViewModel(
        status: status,
        birthDay: item.getBirthDate,
        sex: item.getMaritalStatus,
        nationality: item.getNationality == 1 ? 'AF' : 'IR',
        name:  item.getName,
        token:  item.getToken,
        calendarType: item.getCalendarType,
        signText: item.getSignText,
        periodStatus: item.getPeriodStatus,

        // periodDay: status == 1 ? item.getPeriodLng <= 0 ? MyDateTime().myDifferenceDays(startPeriod, endPeriod) + 1 : item.getPeriodLng : null,
        // circleDay: status == 1 ? item.getCycleLng <= 0 ? MyDateTime().myDifferenceDays(startPeriod, cycleEndDate) + 1 : item.getCycleLng : null ,
        // lastPeriod: status == 1 ?item.getStartDatePeriod : null,

      periodDay:  item.getPeriodLng <= 0 ? MyDateTime().myDifferenceDays(startPeriod!, endPeriod!) + 1 : item.getPeriodLng ,
      circleDay:  item.getCycleLng <= 0 ? MyDateTime().myDifferenceDays(startPeriod!, cycleEndDate!) + 1 : item.getCycleLng  ,
      lastPeriod:  item.getStartDatePeriod,

        isDeliveryDate: status == 2 || status == 3  ? item.getIsDeliveryDate : null ,
        pregnancyDate: status == 2 || status == 3  ? item.getPregnancyDate : null ,
        pregnancyNo: status == 2 || status == 3 ? item.getPregnancyNo: null ,
        hasAboration: status == 2 || status == 3  ? item.getHasAboration : null,

        childType: status == 3 ? item.getChildType : null,
        childBirthType: status == 3 ? item.getChildBirthType : null,
        childBirthDate: status == 3 ? item.getChildBirthDate : null,
        childName: status == 3 ? item.getChildName : null,
    );
    // print(registerParamViewModel);

     _registerModel.insertDataRegister(registerParamViewModel);


    if(item.getCalander.isNotEmpty){
      _registerModel.cycleInfo.removeAllCycles();
      for(int i=0 ; i<item.getCalander.length ; i++){
        _registerModel.insertDataCycles(
            {
              'periodStartDate' : item.getCalander[i].periodStartDate,
              'periodEndDate' : item.getCalander[i].periodEndDate,
              'cycleEndDate' : item.getCalander[i].cycleEndDate,
              'status' : item.getCalander[i].status,
              'before' : '',
              'after' : '',
              'mental' : '',
              'other' : '',
              'ovu' : ''
            }
        );
      }
    }else{
       if(status == 1) saveCirclesToLocal(registerParamViewModel);
    }

    // var cycleInfo = locator<CycleModel>();
    // print('aaaaaaa : ${cycleInfo.cycle[cycleInfo.cycle.length-1].circleEnd}');

    if(item.getAlarms.isNotEmpty){
      _registerModel.removeTable('Alarms');
      for(int i=0 ; i<item.getAlarms.length ;i++){
       await _registerModel.insertAlarmsToLocal(
            {
              'date' : item.getAlarms[i].date,
              'hour' : item.getAlarms[i].hour,
              'minute' : item.getAlarms[i].minute,
              'text' : item.getAlarms[i].text,
              'description' : item.getAlarms[i].description,
              'IsActive' : item.getAlarms[i].isActive,
              'serverId' : item.getAlarms[i].serverId,
              'fileName' : item.getAlarms[i].fileName,
              'isChange' : 0,
              'mode' : item.getAlarms[i].mode,
              'readFlag' : item.getAlarms[i].readFlag
            }
        );
      }
    }

    if(!isChangeStatus){
      List<AlarmViewModel>? alarms = await _registerModel.getAlarms();
      if(alarms != null){
        for(int i=0 ; i<alarms.length ; i++){
          if(alarms[i].isActive == 1){
            setAlarmCalender(alarms[i].id, alarms[i].text, alarms[i].description, DateTime.parse(alarms[i].date), TimeOfDay(hour : alarms[i].hour,minute: alarms[i].minute));
          }
        }
      }
    }
    await checkDailyReminders();
    // List<DailyRemindersViewModel> dailyReminders = await _registerModel.getDailyReminders();
    // print(dailyReminders.length);
    if(item.getReminders.isNotEmpty){
      for(int i=0 ; i<item.getReminders.length ;i++){
        await  _registerModel.updateDailyRemindersToLocal(
             item.getReminders[i].id,
            {
              'title' : item.getReminders[i].title,
              'time' : item.getReminders[i].time,
              'isSound' : item.getReminders[i].isSound,
              'mode' : item.getReminders[i].mode,
              'dayWeek' : item.getReminders[i].dayWeek,
              'serverId' : item.getReminders[i].serverId,
              'isChange' : 0
            }
        );

      }
    }

    if(!isChangeStatus){
      List<DailyRemindersViewModel>? reminders = await _registerModel.getDailyReminders();
      if(reminders != null){
        for(int i=0 ; i<reminders.length ; i++){
          if(reminders[i].mode == 2){
            setAlarmDailyReminder(reminders[i].id!, reminders[i].title!, reminders[i].time!,reminders[i].isSound!,reminders[i].id! < 26 ? 0 : reminders[i].id! ~/100, reminders[i].dayWeek!);
          }
        }
      }

    }
    if(status == 1){
      List<List<int>> womanSigns = decimalToSignWoman(item.getSign);
      CycleViewModel lastCycle = _registerModel.getLastCircle();
      if(womanSigns.isNotEmpty){

        await _registerModel.updateSings(
            CycleViewModel.fromJson(
                {
                  'periodStartDate' : lastCycle.periodStart,
                  'periodEndDate' : lastCycle.periodEnd,
                  'cycleEndDate' : lastCycle.circleEnd,
                  'status' : 0,
                  'before' : womanSigns[0].toString(),
                  'after' : womanSigns[1].toString(),
                  'mental' : womanSigns[2].toString(),
                  'other' : womanSigns[3].toString(),
                  'ovu' : womanSigns[4].toString()
                }
            )
        );
      }
    }else if(status == 2){
      List<List<int>> pregnancySigns = decimalToPregnancySigns(item.getSign);
      // List<List<int>> pregnancySigns = decimalToPregnancySigns(4096);
      // print('pregnancySigns : $pregnancySigns');
      var pregnancySignInfo = locator<PregnancySignsModel>();
      pregnancySignInfo.setFetalSex(pregnancySigns[0]);
      pregnancySignInfo.setPhysical(pregnancySigns[1]);
      pregnancySignInfo.setPhysicalPregnancy(pregnancySigns[2]);
      pregnancySignInfo.setGastrointestinalPregnancy(pregnancySigns[3]);
      pregnancySignInfo.setPsychologyPregnancy(pregnancySigns[4]);

    }else if(status == 3){
      List<List<int>> breastfeedingSigns = decimalToBreastfeeding(item.getSign);
      var breastfeedingInfo = locator<BreastfeedingSignsModel>();
      breastfeedingInfo.setBabySigns(breastfeedingSigns[0]);
      breastfeedingInfo.setPhysical(breastfeedingSigns[1]);
      breastfeedingInfo.setBreastfeedingMother(breastfeedingSigns[2]);
      breastfeedingInfo.setPsychology(breastfeedingSigns[3]);
    }

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setBool('isAnim',false);

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
      return;
    }

    if(isAddPregnancyCycle){
      if(await setCycleCalendar(context)){
        await GenerateDashboardAndNotifyMessages().checkForNotificationMessage();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool? womansubscribtion =  prefs.getBool('womansubscribtion');
        Timer(Duration(milliseconds: 100),(){
          Navigator.pushReplacement(
              context,
              PageTransition(
                  settings: RouteSettings(name: "/Page1"),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                  child:  FeatureDiscovery(
                    recordStepsInSharedPreferences: true,
                    child: Home(
                      indexTab:  4,
                      register: true,
                      isChangeStatus: isChangeStatus,
                      showBreastfeedingDialog: status == 3 && isChangeStatus ? true : null,
                      womansubscribtion: womansubscribtion,
                    ),
                  )
              )
          );
        });
      }else{
        showErrorLogin('خطا در برقراری اتصال، اینترنت خود را بررسی کنید',animations);
      }
    }else{
      await GenerateDashboardAndNotifyMessages().checkForNotificationMessage();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? womansubscribtion =  prefs.getBool('womansubscribtion');
      Timer(Duration(milliseconds: 100),(){
        Navigator.pushReplacement(
            context,
            PageTransition(
                settings: RouteSettings(name: "/Page1"),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 500),
                child:  FeatureDiscovery(
                  recordStepsInSharedPreferences: true,
                  child: Home(
                    indexTab:  4,
                    register: true,
                    isChangeStatus: isChangeStatus,
                    showBreastfeedingDialog: status == 3 && isChangeStatus ? true : null,
                    womansubscribtion: womansubscribtion,
                  ),
                )
            )
        );
      });
    }

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

  saveCirclesToLocal(RegisterParamViewModel registerParamViewModel){

    Map<String,dynamic> circles = {};

    DateTime lastPeriod = DateTime.parse(registerParamViewModel.lastPeriod!);

    // if(registerParamViewModel.status == 1){
    //   DateTime lastPeroid = DateTime.parse(registerParamViewModel.lastPeriod);
      DateTime now = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
      int circleDay;

      if((MyDateTime().myDifferenceDays(lastPeriod,now) + 1 )> registerParamViewModel.circleDay!){

        circleDay = (MyDateTime().myDifferenceDays(lastPeriod,now) + 1);

      }else{

        circleDay = registerParamViewModel.circleDay!;

      }
    // }

    DateTime circleEnd = new DateTime(lastPeriod.year,lastPeriod.month,lastPeriod.day + (circleDay - 1));

    DateTime periodEnd = new DateTime(lastPeriod.year,lastPeriod.month,lastPeriod.day + (registerParamViewModel.periodDay! - 1));


    circles['periodStartDate'] = registerParamViewModel.lastPeriod;
    circles['periodEndDate'] = periodEnd.toString();
    circles['cycleEndDate'] = circleEnd.toString();
    circles['status'] = 0;
    circles['before'] = '';
    circles['after'] = '';
    circles['mental'] = '';
    circles['other'] = '';
    circles['ovu'] = '';

     _registerModel.insertDataCycles(circles);

  }
  setAlarmCalender(int id,String title,String subTitle,DateTime dateTime,TimeOfDay time)async{

    if(Platform.isIOS){


      // var androidChannel = AndroidNotificationDetails(
      //   'alarms$id' , 'channel_name',
      //   channelDescription: 'channel_description',
      //   importance: Importance.max,
      //   priority: Priority.max,
      //   vibrationPattern: Int64List(1000),
      //   largeIcon: DrawableResourceAndroidBitmap('impo_icon'),
      //   icon: "not_icon",
      //   sound: RawResourceAndroidNotificationSound('sound_other'),
      //   styleInformation: BigTextStyleInformation(''),
      // );
      //
      // var iosChannel = DarwinNotificationDetails(
      //   presentSound: true ,
      //   sound: 'sound_other.aiff',
      // );
      //
      // NotificationDetails platformChannel = NotificationDetails(android: androidChannel,iOS: iosChannel);
      // await NotificationInit.getGlobal().getNotify().schedule(
      //   int.parse('100$id'),
      //   title,
      //   subTitle,
      //   DateTime(dateTime.year,dateTime.month,dateTime.day,time.hour,time.minute),
      //   platformChannel,
      //   payload: '$title*$subTitle*یادم نمیره',
      // );

    }else{

      if((DateTime(dateTime.year,dateTime.month,dateTime.day,time.hour,time.minute)).isAfter(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute))){
        // print('set');
        await AndroidAlarmManager.oneShotAt(
            DateTime(dateTime.year,dateTime.month,dateTime.day,time.hour,time.minute),
            int.parse('100$id'),
            callBackAlarms,
            wakeup: true,
            exact: true,
            rescheduleOnReboot: true,
            allowWhileIdle: true,
            sound: 1,
            title: title,
            msg: subTitle,
            dayweek: ""
        );
      }

    }


  }
  setAlarmDailyReminder(int id,String title,String time,int isSound,int category,String dayWeek)async{

    // print('cdscdsc');
    if(Platform.isIOS){
      // await NotificationInit.getGlobal().getNotify().cancel(id);
      // print(int.parse(selectedReminder.stream.value.time.substring(0,2)));
      // print(int.parse(selectedReminder.stream.value.time.substring(3,5)),);
      // var androidChannel = AndroidNotificationDetails(
      //   'reminders$id' , 'channel_name' ,
      //   channelDescription: 'channel_description',
      //   importance: Importance.max,
      //   priority: Priority.max,
      //   vibrationPattern: Int64List(1000),
      //   largeIcon: DrawableResourceAndroidBitmap('impo_icon'),
      //   icon: "not_icon",
      //   playSound:  isSound == 1 ? true : false,
      //   sound:  category == 0 ? RawResourceAndroidNotificationSound('sound_water') : category == 1 ? RawResourceAndroidNotificationSound('sound_study') : category == 2 ?
      //   RawResourceAndroidNotificationSound('sound_drug') : category == 3 ? RawResourceAndroidNotificationSound('sound_fruit')
      //       : category == 4 ? RawResourceAndroidNotificationSound('sound_sport') : category == 5 ? RawResourceAndroidNotificationSound('sound_sleep') : RawResourceAndroidNotificationSound('sound_other') ,
      //   styleInformation: BigTextStyleInformation(''),
      // );
      //
      // var iosChannel = DarwinNotificationDetails(
      //   presentSound: isSound  == 1 ? true : false,
      //   sound: category == 0 ? 'sound_water.aiff' : category == 1 ? 'sound_study.aiff' : category == 2 ?
      //   'sound_drug.aiff' : category == 3 ? 'sound_fruit.aiff' : category == 4 ? 'sound_sport.aiff' : category == 5 ? 'sound_sleep.aiff' : 'sound_other.aiff' ,
      // );
      //
      // NotificationDetails platformChannel = NotificationDetails(android: androidChannel,iOS: iosChannel);
      //
      // await NotificationInit.getGlobal().getNotify().showDailyAtTime(
      //   id,
      //   title ,
      //   category == 0 ? 'ایمپویی عزیز نوشیدن آب کافی، مهم تر از چیزیه که فکرشو کنی!' :
      //   category == 1 ? "دوست خوبم امروز قراره چه کتابی بخونی؟" :
      //   category == 2 ? "ایمپویی عزیز وقتشه که داروهاتو بخوری" :
      //   category == 3 ? "دوست خوبم امروز میوه خوردی؟" :
      //   category == 4 ?  "وقت ورزشه!" :
      //   category == 5 ? "ایمپویی عزیز خواب به موقع و کافی رو دست کم نگیر" :
      //   "ایمپویی جان امروز چند ساعت با گوشیت وقت گذروندی؟ " ,
      //   Time(
      //       int.parse(time.substring(0,2)),
      //       int.parse(time.substring(3,5)),
      //       0
      //   ),
      //   platformChannel,
      //   payload: category == 0 ? '$title*ایمپویی عزیز نوشیدن آب کافی، مهم تر از چیزیه که فکرشو کنی!*ممنون از یادآوریت' :
      //   category == 1 ? "$title*دوست خوبم امروز قراره چه کتابی بخونی؟*این کتاب من کجاس؟" :
      //   category == 2 ? "$title*ایمپویی عزیز وقتشه که داروهاتو بخوری*ممنون از یادآوریت" :
      //   category == 3 ? "$title*دوست خوبم امروز میوه خوردی؟*ممنون از یادآوریت" :
      //   category == 4 ?  "$title*وقت ورزشه!*لباس ورزشی منو ندیدی؟" :
      //   category == 5 ? "$title*ایمپویی عزیز خواب به موقع و کافی رو دست کم نگیر*رفتم بخوابم!" :
      //   "$title*ایمپویی جان امروز چند ساعت با گوشیت وقت گذروندی؟*حواسم هست" ,
      // );

    }else{
      // await AndroidAlarmManager.cancel(id);
      DateTime dateTimeForAlarmAndroid;
      DateTime now = DateTime.now();
      DateTime timeSelected = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          int.parse(time.substring(0,2)),
          int.parse(time.substring(3,5)),
          0
      );

      if(timeSelected.isAfter(now)){
        dateTimeForAlarmAndroid =  DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            int.parse(time.substring(0,2)),
            int.parse(time.substring(3,5)),
            0
        );
      }else{
        dateTimeForAlarmAndroid =  DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day + 1,
            int.parse(time.substring(0,2)),
            int.parse(time.substring(3,5)),
            0
        );

      }

//      prefs.setInt('index', index);
//      prefs.setInt('isSound', dialy[index].isSound);

      // print(id);
      // print('alarmDaily');
      // print(id);
      // print(dateTimeForAlarmAndroid);
      // print(title);
      await AndroidAlarmManager.oneShotAt(
          dateTimeForAlarmAndroid,
          id,
          callbackAlarmReminders,
          wakeup: true,
          exact: true,
          rescheduleOnReboot: true,
          allowWhileIdle: true,
          sound: isSound,
          dayweek: dayWeek,
          title: title
      );

    }


    // updateDb(mode);

  }
  ///Gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggget



  requestChangeStatus(int status,Animations? animations,context,bool hasAbortion)async{
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
    RegisterParamViewModel register = _registerModel.getRegisterInfo();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('userName');
    String? password = prefs.getString('password');
    Map<String,dynamic>? _body;
    if(status == 1){
      _body = {
        'status' : status,
        'periodLength' : register.periodDay != null ? register.periodDay : 0,
        'totalCycleLength' : register.circleDay != null ? register.circleDay : 0,
        'startPeriodDate' : register.lastPeriod != null ? register.lastPeriod : DateTime.now().toString()
      };
    }else if(status == 2){
      _body = {
        'status' : status,
        "isDeliveryDate": register.isDeliveryDate,
        "pregnancyDate": register.pregnancyDate.toString(),
        "hasAboration": register.hasAboration,
        "pregnancyNo": register.pregnancyNo
      };

    }else if(status == 3){
      _body = {
        'status' : status,
        'childBirthType' : register.childBirthType,
        'childType' : register.childType,
        'childBirthDate' : register.childBirthDate.toString(),
        'childName' : register.childName
      };
    }
    print(_body);
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'status', 'POST',
        _body,
        register.token!
    );
    if (responseBody != null) {
      if (responseBody["valid"]) {
        if(status == 2){
          allRandomMessages.clear();
          viewBioRhythms.clear();
        }
        bottomMessageDashboard.clear();
        _registerModel.registerInfo.setStatus(status);
        if(animations != null){
          login(register,userName,password,animations, context,
          isRegister: true,onlyLogin: false,isChangeStatus: true,hasAbortion: hasAbortion);
        }else{
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child:  SplashScreen(
                    localPass: false,
                    // index: 2,
                  )
              )
          );
        }

      } else {
        if (!isLoading.isClosed) {
          isLoading.sink.add(false);
        }
        if(animations != null){
          animations.showShakeError('ارتباط با سرور برقرار نشد, لطفا مجددا تلاش کنید');
        }else{
          showToast(context,'ارتباط با سرور برقرار نشد, لطفا مجددا تلاش کنید');
        }
      }
    } else {
      if (!isLoading.isClosed) {
        isLoading.sink.add(false);
      }
      if(animations != null){
        animations.showShakeError('ارتباط با سرور برقرار نشد, لطفا مجددا تلاش کنید');
      }else{
        showToast(context,'ارتباط با سرور برقرار نشد, لطفا مجددا تلاش کنید');
      }
    }

  }

  generateCycleCalendar(){

  }

  showToast(context, message) {
    // Fluttertoast.showToast(msg:message,
    //     toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM);
    CustomSnackBar.show(context, message);
  }

 // initCafeBazar()async{
 //    try{
 //      AppInfo app = await InstalledApps.getAppInfo('com.farsitel.bazaar');
 //      if(getExtendedVersionNumber(app.versionName) >= getExtendedVersionNumber('19.0.0')){
 //        print('initCafeBazar');
 //        await FlutterPoolakey.connect(
 //            'MIHNMA0GCSqGSIb3DQEBAQUAA4G7ADCBtwKBrwC0t0MsJvRzZEOa46iZ8bMycGoeeq/pXeVONhsR4Z+TqUFMjicoqpzwROeCXiXXVNVISnrW3GM4n+HX5axbpnUv4qfh2agdiZE5mqyuKlNGB/OBbrKQ6BCMZvfeFwfrrg6t+ydNNCEL7Oeua9KqS8RXNvva6OHkiVegirWVh1GxLtWhWe8OcM5vZypq/45rCSHXZ48JFoJUElpWNXBN+9W6zXcerqQyy3niMbzC3vkCAwEAAQ==',
 //            onDisconnected: (){
 //              print('onDisconnected');
 //            });
 //      }
 //    }catch(e){
 //      print('Cafe Bazar not installed');
 //    }
 //  }


  initMyket()async{
    try{
      await MyketIAP.init(rsaKey: 'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCM2mF113udNg5Ih+OL5kryRZw6kT+ibnxjCUMrSI336nwqmEsWh4V7DP4fJG1SdXuZYHGtaCS6VyUQXuFn9ryAiMOi4+Xmza4HTGMzzDXYuBzAHSj4mhZ8DSF+Jq+p0r19mxvkEogk8VQ1f1/C1pFNkhnfkUaFLm2TnlqAetywnwIDAQAB', enableDebugLogging: false);
    }catch(e){
      print(e);
    }
  }


  dispose(){
    dialogScale.close();
    isShowDialog.close();
    isLoading.close();
    valueDialogText.close();
 }



}