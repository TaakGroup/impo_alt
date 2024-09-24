
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:impo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:impo/src/architecture/model/profile_model.dart';
import 'package:impo/src/architecture/presenter/dashboard_presenter.dart';
import 'package:impo/src/architecture/view/profile_view.dart';
import 'package:impo/src/components/DateTime/my_datetime.dart';
import 'package:impo/src/core/app/view/widgets/snackbar/custom_snack_bar.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/data/local/save_data_offline_mode.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/data/messages/generate_dashboard_notify_and_messages.dart';
import 'package:impo/src/models/profile/profile_all_data_model.dart';
import 'package:impo/src/models/profile/support_get_model.dart';
import 'package:impo/src/models/profile/update_model.dart';
import 'package:impo/src/models/register/circles_send_server_model.dart';
import 'package:impo/src/models/advertise_model.dart';
import 'package:impo/src/models/calender/alarm_model.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/home/tabs/profile/alarms/list_alarms_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/edit_profile.dart';
import 'package:impo/src/screens/home/tabs/profile/my_impo_screen.dart';
import 'package:impo/src/singleton/alarm_manager_init.dart';
import 'package:impo/src/singleton/notification_init.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:intl/intl.dart';
import 'package:impo/src/screens/home/tabs/profile/alarms/add_alarm_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../firebase_analytics_helper.dart';
import '../../models/bioRhythm/bio_model.dart';
import '../../models/bioRhythm/biorhythm_view_model.dart';

class ProfilePresenter{

  late ProfileView _profileView;

  ProfileModel profileModel =  ProfileModel();

  Map<String,dynamic> circle = {};
  List<CycleViewModel> defaultCycles = [];
  // RegisterParamViewModel defaultRegister;
  DateTime today = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  late TextEditingController titleController;

  ProfilePresenter(ProfileView view){

    this._profileView = view;

  }

  late AnimationController animationControllerDialog;

  final listReminders = BehaviorSubject<List<DailyRemindersViewModel>>.seeded([]);
  final dialogScale = BehaviorSubject<double>.seeded(0.0);
  final isShowCanDrawOverlaysDialog = BehaviorSubject<bool>.seeded(false);
  final selectedReminder = BehaviorSubject<DailyRemindersViewModel>();
  final isShowDeleteReminderDialog = BehaviorSubject<bool>.seeded(false);
  final lengthActiveReminders = BehaviorSubject<List<int>>.seeded([]);
  final isLoading = BehaviorSubject<bool>.seeded(false);
  final isShowNotifyDialog = BehaviorSubject<bool>.seeded(false);
  final advertis = BehaviorSubject<AdvertiseViewModel>();
  final supports = BehaviorSubject<SupportGetModel>();
  final isLoadingButton = BehaviorSubject<bool>.seeded(false);
  final tryButtonError = BehaviorSubject<bool>.seeded(false);
  final valueError = BehaviorSubject<String>.seeded('');
  final isShowSupportDialog = BehaviorSubject<bool>.seeded(false);
  final textDialog = BehaviorSubject<String>.seeded('');
  final updateProp = BehaviorSubject<UpdateModel>();
  final isShowPregnancyDialog= BehaviorSubject<bool>.seeded(false);


  Stream<List<DailyRemindersViewModel>> get listRemindersObserve => listReminders.stream;
  Stream<double> get dialogScaleObserve => dialogScale.stream;
  Stream<bool> get isShowCanDrawOverlaysDialogObserve => isShowCanDrawOverlaysDialog.stream;
  Stream<DailyRemindersViewModel> get selectedReminderObserve => selectedReminder.stream;
  Stream<bool> get isShowDeleteReminderDialogObserve => isShowDeleteReminderDialog.stream;
  Stream<List<int>> get lengthActiveRemindersObserve => lengthActiveReminders.stream;
  Stream<bool> get isLoadingObserve => isLoading.stream;
  Stream<bool> get isShowNotifyDialogObserve => isShowNotifyDialog.stream;
  Stream<AdvertiseViewModel> get advertisObserve => advertis.stream;
  Stream<SupportGetModel> get supportsObserve => supports.stream;
  Stream<bool> get isLoadingButtonObserve => isLoadingButton.stream;
  Stream<bool> get tryButtonErrorObserve => tryButtonError.stream;
  Stream<String> get valueErrorObserve => valueError.stream;
  Stream<bool> get isShowSupportDialogObserve => isShowSupportDialog.stream;
  Stream<String> get textDialogObserve => textDialog.stream;
  Stream<UpdateModel> get updatePropObserve => updateProp.stream;
  Stream<bool> get isShowPregnancyDialogObserve => isShowPregnancyDialog.stream;


  late SupportGetModel _supports;
  late String packageName;
  late String version;
  late String modelPhone;
  late UpdateModel _updateProp;


  RegisterParamViewModel getRegister(){
    RegisterParamViewModel register =  profileModel.getRegisters();
    return register;
  }

  List<int> _lengthActiveReminders = [];
  List<DailyRemindersViewModel> _listReminders = [];
  List<DayWeek> daysWeek = [
    DayWeek(
        title: 'شنبه',
        index: '0',
        selected: true,
        onPress: false
    ),
    DayWeek(
        title: 'یک',
        index: '1',
        selected: true,
        onPress: false
    ),
    DayWeek(
        title: 'دو',
        index: '2',
        selected: true,
        onPress: false
    ),
    DayWeek(
        title: 'سه',
        index: '3',
        selected: true,
        onPress: false
    ),
    DayWeek(
        title: 'چهار',
        index: '4',
        selected: true,
        onPress: false
    ),
    DayWeek(
        title: 'پنج',
        index: '5',
        selected: true,
        onPress: false
    ),
    DayWeek(
        title: 'جمعه',
        index: '6',
        selected: true,
        onPress: false
    ),
  ];

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

  ProfileAllDataViewModel getProfileAllData(){
    return profileModel.getProfileAllData();
  }

  getAdvertise(){
    var advertiseInfo = locator<AdvertiseModel>();
    List<AdvertiseViewModel> allAds = advertiseInfo.advertises;
    List<AdvertiseViewModel> profileDown = [];
    AdvertiseViewModel? showAds;
    if(allAds.length != 0){
      for(int i=0 ; i<allAds.length ; i++){
        if(allAds[i].place == 2){
          profileDown.add(allAds[i]);
        }
      }
      if(profileDown.isNotEmpty){
        if(profileDown.length > 1){
          final _random =  Random();
          showAds = profileDown[_random.nextInt(profileDown.length)];

        }else{
          showAds = profileDown[0];
        }
      }

    }
    if(!advertis.isClosed && showAds != null){
      advertis.sink.add(showAds);
    }
  }

  onPressCancelNotifyDialog()async{
    await animationControllerDialog.reverse();
    if(!isShowNotifyDialog.isClosed) {
      isShowNotifyDialog.sink.add(false);
    }
  }

  Future<bool> onPressYesLocalNotifyDialog()async{
    await animationControllerDialog.reverse();
    if(!isShowNotifyDialog.isClosed) {
      isShowNotifyDialog.sink.add(false);
    }
    return true;
  }

  showLocalNotifyDialog()async{
    Timer(Duration(milliseconds: 50),()async{
      animationControllerDialog.forward();
      isShowNotifyDialog.sink.add(true);
    });
  }



//   Future<bool> onPressChangeCircleDays(context,randomMessage,RegisterParamViewModel RegisterParamViewModel,circlesDays)async{
//     // DataBaseProvider db  =  DataBaseProvider();
//     CircleModel circles = await profileModel.getLastCircle();
//     int days = int.parse(circlesDays.toString().replaceAll('روز', ''));
//
//     if(days >= RegisterParamViewModel.circleDay){
//
//       await profileModel.updateCirclesDay(days);
//       await profileModel.insertToLocal(EditProfileModel().setJson(0,days.toString()), 'EditProfile');
//       Navigator.pushReplacement(
//           context,
//           PageTransition(
//               type: PageTransitionType.fade,
//               duration: Duration(milliseconds: 500),
//               child:  FeatureDiscovery(
//                 recordStepsInSharedPreferences: true,
//                 child: ProfileScreen(
//                   randomMessage: randomMessage,
//                 )
//               )
//           )
//       );
//
//     }else{
//
//         DateTime today = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
//
//         int  currentToday = MyDateTime().myDifferenceDays(DateTime.parse(circles.periodStart),today) + 1;
// //        print(currentToday);
//
//         if(currentToday > days){
//
//           await profileModel.updateCirclesDay(days);
//           await profileModel.insertToLocal(EditProfileModel().setJson(0,days.toString()), 'EditProfile');
//           await insertRowToTableCircles(days,context,randomMessage,RegisterParamViewModel);
//
//         }else{
//
//           await profileModel.updateCirclesDay(days);
//           await profileModel.insertToLocal(EditProfileModel().setJson(0,days.toString()), 'EditProfile');
//
//           Navigator.pushReplacement(
//               context,
//               PageTransition(
//                   type: PageTransitionType.fade,
//                   duration: Duration(milliseconds: 500),
//                   child:  FeatureDiscovery(
//                     recordStepsInSharedPreferences: true,
//                     child:  ProfileScreen(
//                       randomMessage: randomMessage,
//                     )
//                   )
//               )
//           );
//
//         }
//
//
//     }
//
//     return true;
//
//   }
//
//   Future<bool> insertRowToTableCircles(days,context,randomMessage,RegisterParamViewModel)async{
//     // DataBaseProvider db  =  DataBaseProvider();
//     CircleModel lastCircle = await profileModel.getLastCircle();
//     RegisterParamViewModel registerModel = await profileModel.getRegisters();
//
//
//
//       DateTime periodStart = DateTime.parse(lastCircle.periodStart);
//       DateTime endCircle = DateTime(periodStart.year,periodStart.month,periodStart.day + (days-1));
//
//
//       if(today.isAfter(endCircle)){
//         DateTime StartPeriod = DateTime(endCircle.year,endCircle.month,endCircle.day+1);
//         DateTime EndCircle = DateTime(endCircle.year,endCircle.month,endCircle.day + days);
//         DateTime EndPeriod = DateTime(endCircle.year,endCircle.month,endCircle.day+(registerModel.periodDay));
//
//
//         Circle['isSavedToServer'] = 0;
//         Circle['periodStart'] = StartPeriod.toString();
//         Circle['circleEnd'] = EndCircle.toString();
//         Circle['periodEnd'] = EndPeriod.toString();
//         Circle['before'] = lastCircle.before;
//         Circle['after'] = lastCircle.after;
//         Circle['mental'] = lastCircle.mental;
//         Circle['other'] = lastCircle.other;
//         Circle['ovu'] = lastCircle.ovu;
//
//
//         await profileModel.insertCircleToLocal(Circle);
//
//         await insertRowToTableCircles(days,context,randomMessage,RegisterParamViewModel);
//
//
//       }else{
//
// //       await profileModel.updateCircleDaysRegister(days);
//
//        Navigator.pushReplacement(
//            context,
//            PageTransition(
//                type: PageTransitionType.fade,
//                duration: Duration(milliseconds: 500),
//                child:  FeatureDiscovery(
//                  recordStepsInSharedPreferences: true,
//                  child:  ProfileScreen(
//                    randomMessage: randomMessage,
//                  )
//                )
//            )
//        );
//
//
//       }
//
//       return true;
//
//   }
//
//   Future<bool> onPressChangePeriodDays(context,periodDays,randomMessage,RegisterParamViewModel)async{
//     // DataBaseProvider db  =  DataBaseProvider();
//
//    await profileModel.updatePeriodDays(int.parse(periodDays.toString().replaceAll('روز', '')));
//
//    await profileModel.insertToLocal(EditProfileModel().setJson(1,periodDays.toString().replaceAll('روز', '')), 'EditProfile');
//
//     Navigator.pushReplacement(
//       context,
//         PageTransition(
//             type: PageTransitionType.fade,
//             duration: Duration(milliseconds: 500),
//             child:  FeatureDiscovery(
//               recordStepsInSharedPreferences: true,
//               child: ProfileScreen(
//                 randomMessage: randomMessage,
//               )
//             )
//         )
//     );
//     return true;
// }

   onPressChangeCircleDays(context,circlesDays){
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
    var cycleInfo =  locator<CycleModel>();
    var registerInfo = locator<RegisterParamModel>();
    CycleViewModel circles =  cycleInfo.cycle[cycleInfo.cycle.length-1];
    RegisterParamViewModel registerParametersModel = registerInfo.register;
    int days = int.parse(circlesDays.toString().replaceAll('روز', ''));

    if(days >= registerParametersModel.circleDay!){

      updateCirclesAdnPeriodDay(days,context,false);

      // Navigator.pushReplacement(
      //     context,
      //     PageTransition(
      //         type: PageTransitionType.fade,
      //         duration: Duration(milliseconds: 500),
      //         child:  FeatureDiscovery(
      //             recordStepsInSharedPreferences: true,
      //             child: ProfileScreen(
      //             )
      //         )
      //     )
      // );

    }else{

      DateTime today = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);

      int  currentToday = MyDateTime().myDifferenceDays(DateTime.parse(circles.periodStart!),today) + 1;
//        print(currentToday);

      if(currentToday > days){

        // await profileModel.updateCirclesDay(days);
         insertRowToTableCircles(days,context,registerParametersModel);

      }else{

        updateCirclesAdnPeriodDay(days,context,false);

      }


    }

    return true;

  }

  insertRowToTableCircles(int days,context,randomMessage){
    var cycleInfo =  locator<CycleModel>();
    var registerInfo = locator<RegisterParamModel>();
    CycleViewModel lastCircle =  cycleInfo.cycle[cycleInfo.cycle.length-1];
    RegisterParamViewModel registerModel = registerInfo.register;



    DateTime periodStart = DateTime.parse(lastCircle.periodStart!);
    DateTime endCircle = DateTime(periodStart.year,periodStart.month,periodStart.day + (days-1));


    if(today.isAfter(endCircle)){
      DateTime _startPeriod = DateTime(endCircle.year,endCircle.month,endCircle.day+1);
      DateTime _endCircle = DateTime(endCircle.year,endCircle.month,endCircle.day + days);
      DateTime _endPeriod = DateTime(endCircle.year,endCircle.month,endCircle.day+(registerModel.periodDay!));


      circle['periodStartDate'] = _startPeriod.toString();
      circle['cycleEndDate'] = _endCircle.toString();
      circle['periodEndDate'] = _endPeriod.toString();
      circle['status'] = 0;
      circle['before'] = lastCircle.before;
      circle['after'] = lastCircle.after;
      circle['mental'] = lastCircle.mental;
      circle['other'] = lastCircle.other;
      circle['ovu'] = lastCircle.ovu;


      cycleInfo.addCycle(circle);
      // await profileModel.insertCircleToLocal(Circle);

      insertRowToTableCircles(days,context,randomMessage);


    }else{

      updateCirclesAdnPeriodDay(days,context,false);
//       await profileModel.updateCircleDaysRegister(days);

      // Navigator.pushReplacement(
      //     context,
      //     PageTransition(
      //         type: PageTransitionType.fade,
      //         duration: Duration(milliseconds: 500),
      //         child:  FeatureDiscovery(
      //             recordStepsInSharedPreferences: true,
      //             child:  ProfileScreen(
      //             )
      //         )
      //     )
      // );


    }


  }

  onPressChangePeriodDays(context,periodDays){
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
    updateCirclesAdnPeriodDay(int.parse(periodDays.toString().replaceAll('روز', '')),context,true);


  }

  updateCirclesAdnPeriodDay(int newDays,context,isPeriod)async {
    var cycleInfo =  locator<CycleModel>();
    CycleViewModel lastCycle = cycleInfo.cycle[cycleInfo.cycle.length-1];
    // var registerInfo = locator<RegisterParamModel>();
    for(int i=0 ; i<cycleInfo.cycle.length ; i++){
      defaultCycles.add(
          CycleViewModel.fromJson({
            'periodStartDate' : cycleInfo.cycle[i].periodStart,
            'periodEndDate' :  cycleInfo.cycle[i].periodEnd,
            'cycleEndDate' :  cycleInfo.cycle[i].circleEnd,
            'status' : cycleInfo.cycle[i].status,
            'before' : cycleInfo.cycle[i].before,
            'after' : cycleInfo.cycle[i].after,
            'mental' : cycleInfo.cycle[i].mental,
            'other' : cycleInfo.cycle[i].other,
            'ovu' : cycleInfo.cycle[i].ovu
          })
      );
    }
    // defaultRegister  = RegisterParamViewModel.fromJson(
    //     {
    //       'name' : registerInfo.register.name,
    //       'periodDay' : registerInfo.register.periodDay,
    //       'circleDay' :  registerInfo.register.circleDay,
    //       'lastPeriod' : registerInfo.register.lastPeriod,
    //       'birthDay' : registerInfo.register.birthDay,
    //       'typeSex' : registerInfo.register.sex,
    //       'nationality' : registerInfo.register.nationality,
    //       'token' :   registerInfo.register.token,
    //       'calendarType' : registerInfo.register.calendarType
    //     }
    // );
    //
    // print('newDays : $newDays');
    // registerInfo.addRegister(
    //     {
    //       'name' : registerInfo.register.name,
    //       'periodDay' : isPeriod ? newDays : registerInfo.register.periodDay,
    //       'circleDay' :  isPeriod ? registerInfo.register.circleDay : newDays,
    //       'lastPeriod' : registerInfo.register.lastPeriod,
    //       'birthDay' : registerInfo.register.birthDay,
    //       'typeSex' : registerInfo.register.sex,
    //       'nationality' : registerInfo.register.nationality,
    //       'token' :   registerInfo.register.token,
    //       'calendarType' : registerInfo.register.calendarType
    //     }
    // );

    DateTime periodStart = DateTime.parse(lastCycle.periodStart!);
    DateTime circleOrPeriodEnd = DateTime(periodStart.year,periodStart.month,periodStart.day + (newDays -1));
    cycleInfo.updateCycle(
        cycleInfo.cycle.length-1,
        CycleViewModel.fromJson(
            {
              'periodStartDate' : lastCycle.periodStart,
              'periodEndDate' :  isPeriod ? circleOrPeriodEnd.toString() :lastCycle.periodEnd,
              'cycleEndDate' : isPeriod ? lastCycle.circleEnd : circleOrPeriodEnd.toString(),
              'status' : 0,
              'before' : lastCycle.before,
              'after' : lastCycle.after,
              'mental' : lastCycle.mental,
              'other' : lastCycle.other,
              'ovu' : lastCycle.ovu
            }
        )
    );
    await GenerateDashboardAndNotifyMessages().checkForNotificationMessage();
    setCycleInfo(context,newDays,isPeriod,false);
  }

  Future<bool> setCycleInfo(context,int newDays,bool isPeriod,bool isErrorCycleCalendar)async{
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
    var registerInfo = locator<RegisterParamModel>();
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'info/cycleInfo',
        'POST',
        {
          "startPeriodDate" : DateFormat('yyyy/MM/dd').format(DateTime.parse(registerInfo.register.lastPeriod!)),
          "totalCycleLength" : isPeriod ? registerInfo.register.circleDay : newDays,
          "periodLength" : isPeriod ? newDays : registerInfo.register.periodDay
        },
        registerInfo.register.token!
    );
    print('setCycleInfo : $responseBody');
    if(responseBody != null){
      if(responseBody.isNotEmpty){
        if(responseBody['isValid']){
          if(!isErrorCycleCalendar){
            setCycleCalendar(context,newDays,isPeriod);
          }else{
            if(!isLoading.isClosed){
              isLoading.sink.add(false);
            }
            showToast(context, 'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
          }
        }else{
          returnToDefaultCycleAndRegister(context,newDays,isPeriod,false);
          if(!isLoading.isClosed){
            isLoading.sink.add(false);
          }
          showToast(context,'امکان تغییر دوره وجود ندارد');
        }
      }else{
        returnToDefaultCycleAndRegister(context,newDays,isPeriod,false);
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }
        showToast(context, 'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
      }
    }else{
      returnToDefaultCycleAndRegister(context,newDays,isPeriod,false);
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
      showToast(context, 'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }

    return true;
  }

  Future<bool> setCycleCalendar(context,int newDays,bool isPeriod)async{
    var registerInfo = locator<RegisterParamModel>();
    var cycleInfo = locator<CycleModel>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CirclesSendServerMode circlesSendServerMode =  CirclesSendServerMode();

    if(cycleInfo.cycle.length != 0){

      circlesSendServerMode = CirclesSendServerMode.fromJson(cycleInfo.cycle);

    }

    if(circlesSendServerMode.cycleInfos != null){
      if(circlesSendServerMode.cycleInfos!.length != 0){
        Map<String,dynamic>? responseBody = await Http().sendRequest(
            womanUrl,
            'info/setcycleCalender',
            'POST',
            {
              "cycles" : circlesSendServerMode.cycleInfos
            },
            registerInfo.register.token!
        );

        // print('setCycleCalender : $responseBody');
        if(responseBody != null){
          if(responseBody['isValid']){
            if(isPeriod){
              registerInfo.setPeriodDay(newDays);
              prefs.setInt('periodDay',newDays);
            }else{
              registerInfo.setCircleDay(newDays);
              prefs.setInt('circleDay',newDays);
            }
            if(!isLoading.isClosed){
              isLoading.sink.add(false);
            }
            bottomMessageDashboard.clear();
            await updateBioRhythm(responseBody);
            await updateAdvertise(responseBody);
            Navigator.pop(context);
            // Navigator.pushReplacement(
            //     context,
            //     PageTransition(
            //         type: PageTransitionType.fade,
            //         duration: Duration(milliseconds: 500),
            //         child:  FeatureDiscovery(
            //             recordStepsInSharedPreferences: true,
            //             child: ProfileScreen()
            //         )
            //     )
            // );

          }else{
            returnToDefaultCycleAndRegister(context,newDays,isPeriod,true);
            if(!isLoading.isClosed){
              isLoading.sink.add(false);
            }
            showToast(context,'امکان تغییر دوره وجود ندارد');
          }
        }else{
          returnToDefaultCycleAndRegister(context,newDays,isPeriod,true);
          if(!isLoading.isClosed){
            isLoading.sink.add(false);
          }
          showToast(context, 'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
        }


      }else{
        returnToDefaultCycleAndRegister(context,newDays,isPeriod,true);
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }
        showToast(context,'امکان تغییر دوره وجود ندارد');
      }
    }else{
      returnToDefaultCycleAndRegister(context,newDays,isPeriod,true);
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
      showToast(context,'امکان تغییر دوره وجود ندارد');
    }

    return true;

  }

  showToast(context,message){
    //Fluttertoast.showToast(msg:message,toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM);
    CustomSnackBar.show(context, message);
  }

  returnToDefaultCycleAndRegister(context,int newDays,bool isPeriod,bool isErrorCycleCalendar){
    var cycleInfo = locator<CycleModel>();
    // var registerInfo = locator<RegisterParamModel>();
    // print(cycleInfo.cycle.length);
    cycleInfo.removeAllCycles();
    for(int i=0 ; i<defaultCycles.length ; i++){
      cycleInfo.addCycle(
          {
            'periodStartDate' : defaultCycles[i].periodStart,
            'periodEndDate' :  defaultCycles[i].periodEnd,
            'cycleEndDate' :  defaultCycles[i].circleEnd,
            'status' : defaultCycles[i].status,
            'before' : defaultCycles[i].before,
            'after' : defaultCycles[i].after,
            'mental' : defaultCycles[i].mental,
            'other' : defaultCycles[i].other,
            'ovu' : defaultCycles[i].ovu
          }
      );
    }
    // registerInfo.addRegister(
    //     {
    //       'name' : defaultRegister.name,
    //       'periodDay' : defaultRegister.periodDay,
    //       'circleDay' :  defaultRegister.circleDay,
    //       'lastPeriod' : defaultRegister.lastPeriod,
    //       'birthDay' : defaultRegister.birthDay,
    //       'typeSex' : defaultRegister.sex,
    //       'nationality' : defaultRegister.nationality,
    //       'token' :   defaultRegister.token,
    //       'calendarType' : defaultRegister.calendarType
    //     }
    // );
    if(isErrorCycleCalendar) setCycleInfo(context,newDays,isPeriod,isErrorCycleCalendar);
  }


//  Future<bool> editProfile(name, value,int editType)async{
//    // DataBaseProvider db  =  DataBaseProvider();
//     await profileModel.updateProfile(name, value);
//     // if(editType != 6){
//       if(editType == 3){
//         List birthDay = value.split('/');
//         Jalali _dateTime = Jalali(
//             int.parse(birthDay[0]),
//             int.parse(birthDay[1]),
//             int.parse(birthDay[2])
//         );
//
// //      print(DateFormat('yyyy/MM/dd').format(_dateTime.toDateTime()));
//         await profileModel.insertToLocal(EditProfileModel().setJson(editType,DateFormat('yyyy/MM/dd').format(_dateTime.toDateTime())), 'EditProfile');
//       }else{
//         await profileModel.insertToLocal(EditProfileModel().setJson(editType,value), 'EditProfile');
//       }
//       AutoBackup().setGeneralInfo();
//       return true;
//  }

  Future<bool>  setGeneralInfo(Map<String,dynamic> generalInfo,context,ProfilePresenter presenter,bool gotoMyImpoScreen,{bool updateBio = false})async{
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
    RegisterParamViewModel register = RegisterParamViewModel.fromJson(generalInfo);

    List listBirthDay;
    if(register.birthDay!.contains(',')){
      listBirthDay = register.birthDay!.split(',');
    }else{
      listBirthDay = register.birthDay!.split('/');
    }

    Jalali _dateTime = Jalali(
        int.parse(listBirthDay[0]),
        int.parse(listBirthDay[1]),
        int.parse(listBirthDay[2])
    );
    // print(DateFormat('yyyy/MM/dd').format(_dateTime.toDateTime()));
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'info/generalInfov2',
        'POST',
        {
          "name" : register.name,
          "birthDate" : DateFormat('yyyy/MM/dd').format(_dateTime.toDateTime()),
          "sexualStatus" : register.sex,
          "nationality" : register.nationality == 'AF' ? 1 : 0,
          "calendarType" : register.calendarType != null ? register.calendarType : 0,
          "periodStatus" : register.periodStatus != null ? register.periodStatus : 0
        },
        register.token!
    );
    // print('generalInfo :$responseBody');
    if(responseBody != null){
      if(responseBody.isNotEmpty){
        if(responseBody['isValid']){
          var registerInfo = locator<RegisterParamModel>();
          registerInfo.setName(register.name!);
          registerInfo.setBirthDay(register.birthDay!);
          registerInfo.setSex(register.sex!);
          registerInfo.setNationality(register.nationality!);
          registerInfo.setCalendarType(register.calendarType!);
          registerInfo.setPeriodStatus(register.periodStatus);
          bottomMessageDashboard.clear();
          SaveDataOfflineMode().saveTypeCalendar();
          SaveDataOfflineMode().saveNationality();
          if(updateBio){
            await updateBioRhythm(responseBody);
          }
          if(!gotoMyImpoScreen){
            await GenerateDashboardAndNotifyMessages().checkForNotificationMessage();
            if(!isLoading.isClosed){
              isLoading.sink.add(false);
            }
            Timer(Duration(milliseconds: 30),(){
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 500),
                      child:   EditProfile(
                        presenter: presenter,
                      )
                  )
              );
            });
          }else{
            Timer(Duration(milliseconds: 30),(){
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 500),
                      child:  MyImpoScreen(
                        presenter: presenter,
                      )
                  )
              );
            });
          }

        }else{
          if(!isLoading.isClosed){
            isLoading.sink.add(false);
          }
          showToast(context, 'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
        }
      }else{
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }
        showToast(context, 'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
      }
    }else{
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
      showToast(context, 'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }
    return true;
  }

  Future<bool> updateBioRhythm(bioRythm)async{
    BioViewModel? bioRhythmModel;
    // List<BioRhythmMessagesModel> biorhythmMessages = [];

    //bioRhythm
    bioRhythmModel =  BioViewModel.fromJson(bioRythm['bioRythm']);


    if(bioRhythmModel != null){
      profileModel.addAllBio(bioRythm['bioRythm']);
    }



    allRandomMessages.clear();
    viewBioRhythms.clear();
    return true;
  }

  Future<bool> updateAdvertise(advertise)async{
    var advertiseInfo = locator<AdvertiseModel>();
    advertiseInfo.advertises.clear();
    if(advertise['advertise']['advertise'].length != 0){
      advertise['advertise']['advertise'].forEach((item){
        advertiseInfo.addAdvertise(item);
      });
    }
    return true;
  }


  onPressSetPass(String pass,String repeatPass)async{


    if(pass.length == 4 && repeatPass.length == 4){

      if(pass == repeatPass){

        _profileView.onSuccess(pass);

      }else{

        _profileView.onError(
            'رمز و تکرار رمز باهم یکسان نیستند'
        );

      }

    }else{

      _profileView.onError(
          'رمز ورود نباید کمتر از ۴ رقم باشد'
      );

    }

  }



  initSetLengthActiveReminders()async{
    // print('set');
    _lengthActiveReminders.clear();
    List<DailyRemindersViewModel>? dailyReminders = await profileModel.getDailyReminders();

    // print(dailyReminders[0].mode);
    // print(dailyReminders[0].title);

    List<int> list1 = [];
    List<int> list2 = [];
    List<int> list3 = [];
    List<int> list4 = [];
    List<int> list5 = [];
    List<int> list6 = [];
    List<int> list7 = [];
    List<int> list8 = [];

    for(int i=0 ; i<dailyReminders!.length ; i++){
      if(dailyReminders[i].id! < 25){
        if(dailyReminders[i].mode == 2){
          list1.add(dailyReminders[i].id!);
        }
      }else if(dailyReminders[i].id! < 125){
        if(dailyReminders[i].mode == 2){
          list2.add(dailyReminders[i].id!);
        }
      }else if(dailyReminders[i].id! < 225){
        if(dailyReminders[i].mode == 2){
          list3.add(dailyReminders[i].id!);
        }
      }else if(dailyReminders[i].id! < 325){
        if(dailyReminders[i].mode == 2){
          list4.add(dailyReminders[i].id!);
        }
      }else if(dailyReminders[i].id! < 425){
        if(dailyReminders[i].mode == 2){
          list5.add(dailyReminders[i].id!);
        }
      }else if(dailyReminders[i].id! < 525){
        if(dailyReminders[i].mode == 2){
          list6.add(dailyReminders[i].id!);
        }
      }else if(dailyReminders[i].id! < 625){
        if(dailyReminders[i].mode == 2){
          list7.add(dailyReminders[i].id!);
        }
      }else if(dailyReminders[i].id! < 725){
        if(dailyReminders[i].mode == 2){
          list8.add(dailyReminders[i].id!);
        }
      }
    }

    _lengthActiveReminders.add(list1.length);
    _lengthActiveReminders.add(list2.length);
    _lengthActiveReminders.add(list3.length);
    _lengthActiveReminders.add(list4.length);
    _lengthActiveReminders.add(list5.length);
    _lengthActiveReminders.add(list6.length);
    _lengthActiveReminders.add(list7.length);
    _lengthActiveReminders.add(list8.length);



    if(!lengthActiveReminders.isClosed){
      lengthActiveReminders.sink.add(_lengthActiveReminders);
    }

    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }

  }

  initListReminders(int indexAlarm)async{

    _listReminders.clear();

    if(!listReminders.isClosed){
      listReminders.sink.add(_listReminders);
    }

      List<DailyRemindersViewModel>? dailyReminders = await profileModel.getDailyReminders();
       // print(dailyReminders);
      for(int i=indexAlarm*24 ; i<(indexAlarm*24)+24; i++){

          if(dailyReminders![i].mode != 0){
            // print('server Id : ${dailyReminders[i].serverId}');
            _listReminders.add(dailyReminders[i]);

            if(!listReminders.isClosed){
              listReminders.sink.add(_listReminders);
            }


        }


      }

  }

  initDefaultValueForAddReminder(int mode,int indexAlarm,DailyRemindersViewModel? _dailyReminders)async{

    /// mode == 0 AddAlarm
    /// mode == 1 EditAlarm


    for(int i=0 ; i<daysWeek.length ; i++){
      daysWeek[i].selected = true;
    }

    if(mode == 1){

      selectedReminder.sink.add(_dailyReminders!);

      List days = _dailyReminders.dayWeek != '' ? json.decode(_dailyReminders.dayWeek!) : [];

//      List days = json.decode('[2,3]');

      if(days.length != 0){

        for(int i=0 ; i<daysWeek.length ; i++){
          if(days.contains(int.parse(daysWeek[i].index!))){
            // print('sss');
            daysWeek[i].selected = false;
          }

        }

      }

      titleController =  TextEditingController(text: selectedReminder.stream.value.title);


    }else{

      List<DailyRemindersViewModel>? dailyReminders = await profileModel.getDailyReminders();

      for(int i=indexAlarm*24 ; i<(indexAlarm*24)+24; i++){

        if(dailyReminders![i].mode == 0){

          selectedReminder.sink.add(dailyReminders[i]);
          titleController =  TextEditingController(text: selectedReminder.stream.value.title);
          break;

        }


      }


    }

  }


  Future<Null> selectDate(BuildContext context) async {
    // DatePicker.showDateTimePicker(
    //     context,
    //     showTitleActions: true,
    //     minTime: DateTime(2018, 3, 5),
    //     maxTime: DateTime(2022, 6, 7), onChanged: (date) {
    //       print('change $date');
    //     }, onConfirm: (date) {
    //       print('confirm $date');
    //     },
    //     currentTime: DateTime.now(),
    //     locale: LocaleType.fa,
    //     theme: DatePickerTheme(
    //       itemStyle: TextStyle(
    //         fontFamily: 'IRANYekan'
    //       )
    //     )
    // );
    TimeOfDay? time = await showTimePicker(
        context: context,
      builder: (context, child) {
        return Localizations.override(
          context: context,
          locale: Locale('fa', 'IR'),
          child: child,
        );
      },
        initialTime: TimeOfDay(hour:int.parse(selectedReminder.stream.value.time!.split(":")[0]),minute: int.parse(selectedReminder.stream.value.time!.split(":")[1])),
    );

    if(time != null){

      selectedReminder.stream.value.setTime(time.format(context));
      selectedReminder.sink.add(selectedReminder.stream.value);

    }

  }

  onChangedTile(value){
    selectedReminder.stream.value.setTitle(value);
    selectedReminder.sink.add(selectedReminder.stream.value);

  }

  changeDayWeek(index){

    List<String> dayForSaves = [];
    List<String> daySelected = [];

    for(int j=0;j<daysWeek.length ; j++){
      if(!daysWeek[j].selected!){
        daySelected.add(daysWeek[j].index!);
      }
    }

    // print(daySelected.length);

    for(int i=0 ; i<daysWeek.length;i++){
      daysWeek[i].onPress = false;
    }

    daysWeek[index].onPress = ! daysWeek[index].onPress!;


    if(!daysWeek[index].selected!){

      daysWeek[index].selected = !daysWeek[index].selected!;

      for(int i=0 ; i<daysWeek.length;i++){
        if(!daysWeek[i].selected!){
          dayForSaves.add(daysWeek[i].index!);
        }
      }

      print(dayForSaves);

      selectedReminder.stream.value.setDayWeek(dayForSaves.toString());
      selectedReminder.sink.add(selectedReminder.stream.value);

    }else{

      if(daySelected.length < 6){


        daysWeek[index].selected = !daysWeek[index].selected!;

        for(int i=0 ; i<daysWeek.length;i++){
          if(!daysWeek[i].selected!){
            dayForSaves.add(daysWeek[i].index!);
          }
        }

        print(dayForSaves);

        selectedReminder.stream.value.setDayWeek(dayForSaves.toString());
        selectedReminder.sink.add(selectedReminder.stream.value);

      }

    }



  }


  onPressSaveReminder(context,index,mode,profilePresenter,isOfflineMode)async{

    ///    mode == 0 deleteAlarm
    ///    mode == 1 deActiveAlarm
    ///    mode == 2 activeAlarm


    if(mode == 0){
      _listReminders.add(
          DailyRemindersViewModel.fromJson(
            {
              'id' : selectedReminder.stream.value.id,
              'title' : selectedReminder.stream.value.title,
              'mode' : 2,
              'isSound' : 1,
              'time' : selectedReminder.stream.value.time,
              'dayWeek' : selectedReminder.stream.value.dayWeek,
              'isChange' : 0
            },
          )
      );

      if(!listReminders.isClosed){
        listReminders.sink.add(_listReminders);
      }
     // AutoBackup().createAlarmDaily(selectedReminder.stream.value.id, selectedReminder.stream.value.title, selectedReminder.stream.value.time, selectedReminder.stream.value.dayWeek, 2,true);
      await setAlarm(index,mode);
    }else if(mode == 1){
      updateDb(mode);
    }else{
      await setAlarm(index,mode);
    }


    Timer(Duration(milliseconds: 100),(){
      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child:  ListAlarmsScreen(
                indexAlarm: index,
                presenter: profilePresenter,
                isShowCanDrawOverLayerDialog: mode == 1 ? false : true,
                isTwoBack: true,
                isOfflineMode: isOfflineMode ,
              )
          )
      );
    });

  }

  setAlarm(index,mode)async{
//
//  SharedPreferences prefs = await SharedPreferences.getInstance();

//    print(int.parse(dialy[index].time.substring(0,2)));
//    print(int.parse(dialy[index].time.substring(3,5)));


  // print('cdscdsc');
    print('setAlarm');
    if(Platform.isIOS){
      // await NotificationInit.getGlobal().getNotify().cancel(selectedReminder.stream.value.id!);
      // // print(int.parse(selectedReminder.stream.value.time.substring(0,2)));
      // // print(int.parse(selectedReminder.stream.value.time.substring(3,5)),);
      // var androidChannel = AndroidNotificationDetails(
      //   'reminders${selectedReminder.stream.value.id}' , 'channel_name',
      //   channelDescription: 'channel_description',
      //   importance: Importance.max,
      //   priority: Priority.max,
      //   vibrationPattern: Int64List(1000),
      //   largeIcon: DrawableResourceAndroidBitmap('impo_icon'),
      //   icon: "not_icon",
      //   playSound:  selectedReminder.stream.value.isSound == 1 ? true : false,
      //   sound:  index == 0 ? RawResourceAndroidNotificationSound('sound_water') : index == 1 ? RawResourceAndroidNotificationSound('sound_study') : index == 2 ?
      //   RawResourceAndroidNotificationSound('sound_drug') : index == 3 ? RawResourceAndroidNotificationSound('sound_fruit')
      //       : index == 4 ? RawResourceAndroidNotificationSound('sound_sport') : index == 5 ? RawResourceAndroidNotificationSound('sound_sleep') : RawResourceAndroidNotificationSound('sound_other') ,
      //   styleInformation: BigTextStyleInformation(''),
      // );
      //
      // var iosChannel = DarwinNotificationDetails(
      //   presentSound: selectedReminder.stream.value.isSound  == 1 ? true : false,
      //   sound: index == 0 ? 'sound_water.aiff' : index == 1 ? 'sound_study.aiff' : index == 2 ?
      //   'sound_drug.aiff' : index == 3 ? 'sound_fruit.aiff' : index == 4 ? 'sound_sport.aiff' : index == 5 ? 'sound_sleep.aiff' : 'sound_other.aiff' ,
      // );
      //
      // NotificationDetails platformChannel = NotificationDetails(android: androidChannel,iOS: iosChannel);
      //
      // await NotificationInit.getGlobal().getNotify().showDailyAtTime(
      //   selectedReminder.stream.value.id!,
      //   selectedReminder.stream.value.title ,
      //   index == 0 ? 'ایمپویی عزیز نوشیدن آب کافی، مهم تر از چیزیه که فکرشو کنی!' :
      //   index == 1 ? "دوست خوبم امروز قراره چه کتابی بخونی؟" :
      //   index == 2 ? "ایمپویی عزیز وقتشه که داروهاتو بخوری" :
      //   index == 3 ? "دوست خوبم امروز میوه خوردی؟" :
      //   index == 4 ?  "وقت ورزشه!" :
      //   index == 5 ? "ایمپویی عزیز خواب به موقع و کافی رو دست کم نگیر" :
      //   "ایمپویی جان امروز چند ساعت با گوشیت وقت گذروندی؟ " ,
      //   Time(
      //       int.parse(selectedReminder.stream.value.time!.substring(0,2)),
      //       int.parse(selectedReminder.stream.value.time!.substring(3,5)),
      //       0
      //   ),
      //   platformChannel,
      //   payload: index == 0 ? '${selectedReminder.stream.value.title }*ایمپویی عزیز نوشیدن آب کافی، مهم تر از چیزیه که فکرشو کنی!*ممنون از یادآوریت' :
      //   index == 1 ? "${selectedReminder.stream.value.title }*دوست خوبم امروز قراره چه کتابی بخونی؟*این کتاب من کجاس؟" :
      //   index == 2 ? "${selectedReminder.stream.value.title }*ایمپویی عزیز وقتشه که داروهاتو بخوری*ممنون از یادآوریت" :
      //   index == 3 ? "${selectedReminder.stream.value.title }*دوست خوبم امروز میوه خوردی؟*ممنون از یادآوریت" :
      //   index == 4 ?  "${selectedReminder.stream.value.title }*وقت ورزشه!*لباس ورزشی منو ندیدی؟" :
      //   index == 5 ? "${selectedReminder.stream.value.title }*ایمپویی عزیز خواب به موقع و کافی رو دست کم نگیر*رفتم بخوابم!" :
      //   "${selectedReminder.stream.value.title }*ایمپویی جان امروز چند ساعت با گوشیت وقت گذروندی؟*حواسم هست" ,
      // );

    }else{
      await AndroidAlarmManager.cancel(selectedReminder.stream.value.id!);
      print(selectedReminder.stream.value.id);
      DateTime dateTimeForAlarmAndroid;
      DateTime now = DateTime.now();
      DateTime timeSelected = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          int.parse(selectedReminder.stream.value.time!.substring(0,2)),
          int.parse(selectedReminder.stream.value.time!.substring(3,5)),
          0
      );

      if(timeSelected.isAfter(now)){
        dateTimeForAlarmAndroid =  DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            int.parse(selectedReminder.stream.value.time!.substring(0,2)),
            int.parse(selectedReminder.stream.value.time!.substring(3,5)),
            0
        );
      }else{
        dateTimeForAlarmAndroid =  DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day + 1,
            int.parse(selectedReminder.stream.value.time!.substring(0,2)),
            int.parse(selectedReminder.stream.value.time!.substring(3,5)),
            0
        );

      }

//      prefs.setInt('index', index);
//      prefs.setInt('isSound', dialy[index].isSound);

      // print(selectedReminder.stream.value.id);
      // print(dateTimeForAlarmAndroid);
      // print(selectedReminder.stream.value.id);
      // print(selectedReminder.stream.value.isSound);
      // print(selectedReminder.stream.value.dayWeek);
      // print(selectedReminder.stream.value.title);
      await AndroidAlarmManager.oneShotAt(
        dateTimeForAlarmAndroid,
        selectedReminder.stream.value.id!,
        callbackAlarmReminders,
        wakeup: true,
        exact: true,
        rescheduleOnReboot: true,
        allowWhileIdle: true,
        sound: selectedReminder.stream.value.isSound!,
        dayweek: selectedReminder.stream.value.dayWeek!,
        title: selectedReminder.stream.value.title!
      );

      print(selectedReminder.stream.value.id);

    }


    updateDb(mode);

  }

  updateDb(mode)async{
    print('updateDb');
    print(selectedReminder.stream.value.serverId);
    await profileModel.updateTable(
        'DailyReminders',
        {
          'id' : selectedReminder.stream.value.id,
          'title' : selectedReminder.stream.value.title,
          'mode' : mode == 0 ? 2 : mode,
          'isSound' : mode == 0 ? 1 : selectedReminder.stream.value.isSound,
          'time' : selectedReminder.stream.value.time,
          'dayWeek' : selectedReminder.stream.value.dayWeek,
          'serverId' : selectedReminder.stream.value.serverId,
          // 'isChange' : mode == 0 ? 0 : 1
          'isChange' : 1
        },
      selectedReminder.stream.value.id,
    );

      initSetLengthActiveReminders();

  }


  showCanDrawOverlaysDialog(){
    Timer(Duration(milliseconds: 50),()async{
      animationControllerDialog.forward();
      if(!isShowCanDrawOverlaysDialog.isClosed){
        isShowCanDrawOverlaysDialog.sink.add(true);
      }
    });
    AnalyticsHelper().log(AnalyticsEvents.ListAlarmsPg_PermAlarm_Dlg_Load);
  }

  showDeleteReminderDialog()async{
    Timer(Duration(milliseconds: 150),()async{
      animationControllerDialog.forward();
      isShowDeleteReminderDialog.sink.add(true);
    });
  }

  onPressCancelDeleteReminderDialog()async{
    await animationControllerDialog.reverse();
    isShowDeleteReminderDialog.sink.add(false);
  }


  setSelectedReminderInList(DailyRemindersViewModel _dailyReminders){
    selectedReminder.sink.add(_dailyReminders);
  }

  deleteReminder(bool back,context)async{
    
    if(selectedReminder.stream.value.mode == 2){
      // print('dsddssdsd');
      if(Platform.isIOS){
        await NotificationInit.getGlobal().getNotify().cancel(selectedReminder.stream.value.id!);
      }else{
        await AndroidAlarmManager.cancel(selectedReminder.stream.value.id!);
      }
    }

    await profileModel.updateTable(
      'DailyReminders',
      {
        'id' : selectedReminder.stream.value.id,
        'title' : selectedReminder.stream.value.title,
        'mode' : 0,
        'isSound' : selectedReminder.stream.value.isSound,
        'time' : selectedReminder.stream.value.time,
        'dayWeek' : '',
        'isChange' : 0,
        'serverId' : ''
      },
      selectedReminder.stream.value.id,
    );

    if(selectedReminder.stream.value.serverId != ''){
      await profileModel.insertToRemoveTable(
          {
            "mode" : 1,
            "serverId" : selectedReminder.stream.value.serverId
          }
      );
      //  AutoBackup().deleteAlarmDaily(selectedReminder.stream.value.id,selectedReminder.stream.value.serverId);
      // print('save To Remove Tables');
    }

      initSetLengthActiveReminders();
    
    _listReminders.removeWhere((item) => item.id == selectedReminder.stream.value.id);

    if(!listReminders.isClosed){
      listReminders.sink.add(_listReminders);
    }

    onPressCancelDeleteReminderDialog();

    if(back){
      Timer(Duration(milliseconds: 100),(){
        Navigator.pop(context);
      });
    }

  }

  Future<bool> getSupport(context)async{
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }
    var registerInfo = locator<RegisterParamModel>();
    await getDeviceAndPackageInfo();
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'info/support',
        'Get',
        {
        },
        registerInfo.register.token!
    );
    print('support : $responseBody');
    if(responseBody != null){
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
      _supports = SupportGetModel.fromJson(responseBody);

      if(!supports.isClosed){
        supports.sink.add(_supports);
      }

    }else{
      if(!tryButtonError.isClosed){
        tryButtonError.sink.add(true);
      }
      valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }

    return true;
  }

  getDeviceAndPackageInfo()async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    modelPhone = '${androidInfo.model} ${androidInfo.version.release}';
    packageName = packageInfo.packageName;
  }

  Future<bool> postSupport(context,String text)async{
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(true);
    }
    var registerInfo = locator<RegisterParamModel>();
    // print(packageName);
    // print(version);
    // print(modelPhone);
    // print(text);
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'info/support',
        'POST',
        {
          'PackageName' : packageName,
          'Version' : version,
          'Type' : typeStore,  // ==> 0=direct / 1=cafe  / 2=myket
          'ModelPhone' : modelPhone,
          'Text' : text,
        },
        registerInfo.register.token!
    );
    print('support : $responseBody');
    if(responseBody != null){
      if(!isLoadingButton.isClosed){
        isLoadingButton.sink.add(false);
      }
      if(responseBody['valid']){
        if(!textDialog.isClosed){
          textDialog.sink.add(responseBody['result']);
        }
       showSupportDialog();
      }else{

        showToast(context,responseBody['result']);
      }
    }else{
      if(!isLoadingButton.isClosed){
        isLoadingButton.sink.add(false);
      }
      showToast(context, 'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }

    return true;
  }

   okSupportDialog()async{
    await animationControllerDialog.reverse();
    if(!isShowSupportDialog.isClosed) {
      isShowSupportDialog.sink.add(false);
    }
  }

  showSupportDialog()async{
    Timer(Duration(milliseconds: 50),()async{
      animationControllerDialog.forward();
      isShowSupportDialog.sink.add(true);
    });
  }

  Future<bool> postUpdate(context)async{
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }

    var registerInfo = locator<RegisterParamModel>();
    await getDeviceAndPackageInfo();
    print(packageName);
    print(version);
    print(modelPhone);
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'info/updateInfo',
        'POST',
        {
          'PackageName' : packageName,
          'Version' : version,
          'Type' : typeStore,  // ==> 0=direct / 1=cafe  / 2=myket
          'ModelPhone' : modelPhone,

        },
        registerInfo.register.token!
    );
    print('updateInfo : $responseBody');
    if(responseBody != null){
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
      _updateProp = UpdateModel.fromJson(responseBody);

      if(!updateProp.isClosed){
        updateProp.sink.add(_updateProp);
      }

    }else{
      if(!tryButtonError.isClosed){
        tryButtonError.sink.add(true);
      }
      valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }

    return true;
  }

  showPregnancyDialog()async{
    Timer(Duration(milliseconds: 50),()async{
      animationControllerDialog.forward();
      isShowPregnancyDialog.sink.add(true);
    });
  }

  cancelPregnancyDialog()async{
    await animationControllerDialog.reverse();
    if(!isShowPregnancyDialog.isClosed) {
      isShowPregnancyDialog.sink.add(false);
    }
  }


  dispose(){

    listReminders.close();
    dialogScale.close();
    isShowCanDrawOverlaysDialog.close();
    selectedReminder.close();
    isShowDeleteReminderDialog.close();
    lengthActiveReminders.close();
    isLoading.close();
    isShowNotifyDialog.close();
    advertis.close();
    supports.close();
    isLoadingButton.close();
    tryButtonError.close();
    valueError.close();
    isShowSupportDialog.close();
    textDialog.close();
    updateProp.close();
    isShowPregnancyDialog.close();
  }


}