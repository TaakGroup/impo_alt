

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:impo/src/architecture/model/offlinemode_dashboard_model.dart';
import 'package:impo/src/architecture/presenter/calender_presenter.dart';
import 'package:impo/src/architecture/view/offlinemode_dashboard_view.dart';
import 'package:impo/src/components/dialogs/pregnancyand_breastfeeding_limit_week.dart';
import 'package:impo/src/data/helper.dart';
import 'package:impo/src/data/messages/generate_dashboard_notify_and_messages.dart';
import 'package:impo/src/models/breastfeeding/breastfeeding_number_model.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/dashboard/dashboard_messages_and_notify_model.dart';
import 'package:impo/src/models/dashboard/dashboard_msg_offline_mode.dart';
import 'package:impo/src/models/dashboard/pregnancy_numbers_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/home/tabs/calender/calender.dart';
import 'package:impo/src/screens/home/tabs/calender/calender_en.dart';
import 'package:impo/src/screens/splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../packages/featureDiscovery/src/foundation/feature_discovery.dart';


List<DashBoardMsgOfflineMode> offLineBottomMessageDashboard = [];

class OfflineModeDashboardPresenter {

  late OfflineModeDashboardView _offlineModeDashboardView;

  OfflineModeDashboardModel _offlineModeDashboardModel = new OfflineModeDashboardModel();

  OfflineModeDashboardPresenter(OfflineModeDashboardView view) {
    this._offlineModeDashboardView = view;
  }

  final status = BehaviorSubject<int>.seeded(0);
  final breastfeedingNumbers = BehaviorSubject<BreastfeedingNumberModel>();
  final pregnancyNumber = BehaviorSubject<PregnancyNumberViewModel>();
  final bottomMessageOfflineMode = BehaviorSubject<List<DashBoardMsgOfflineMode>>();


  Stream<int> get statusObserve => status.stream;
  Stream<BreastfeedingNumberModel> get breastfeedingNumbersObserve => breastfeedingNumbers.stream;
  Stream<PregnancyNumberViewModel> get pregnancyNumberObserve => pregnancyNumber.stream;
  Stream<List<DashBoardMsgOfflineMode>> get bottomMessageOfflineModeObserve => bottomMessageOfflineMode.stream;




  Future<List<CycleViewModel>?> getAllCirclesOfflineMode()async{
    List<CycleViewModel>? circles = await _offlineModeDashboardModel.getAllCirclesOfflineMode();
    return circles;
  }

  Future<bool> insertCycleOfflineMode(map)async{
    await _offlineModeDashboardModel.insertToLocal(
        map, 'Cycles');
    return true;
  }

  setStatus(int st){
    if(!status.isClosed){
      status.sink.add(st);
    }
  }

  checkForWeekPregnancy(int status)async{
    if(status == 2){
      DateTime today = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
      List<CycleViewModel>? cycles = await _offlineModeDashboardModel.getAllCirclesOfflineMode();
      CycleViewModel lastCycle = cycles![cycles.length-1];
      DateTime lastOfCycleEndCircle = DateTime.parse(lastCycle.circleEnd!);

      List<CycleViewModel> reverseCycles = cycles.reversed.toList();
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

          circle['periodStartDate'] = startPeriod.toString();
          circle['cycleEndDate'] = endCircle.toString();
          circle['periodEndDate'] = endPeriod.toString();
          circle['status'] = 2;

          _offlineModeDashboardModel.addCycleToLocator(circle);
          _offlineModeDashboardModel.insertToLocal(circle, 'Cycles');
          checkForWeekPregnancy(status);
        }
      }
    }

  }

  savePregnancyForOfflineMode(List<CycleViewModel> cycles){
    DateTime? lastPeriod;
    List<CycleViewModel> reverseCycles = cycles.reversed.toList();
    for(int i=0 ; i<reverseCycles.length ; i++){
      if(reverseCycles[i].status == 2){
        lastPeriod = DateTime.parse(reverseCycles[i].periodStart!);
      }else{
        break;
      }
    }
    print(lastPeriod);
    GenerateDashboardAndNotifyMessages().generateWeekPregnancy(true,pregnancyDate: lastPeriod!);
  }

  generateWeekPregnancyOfflineMode(List<CycleViewModel> cycles,PregnancyAndBreastfeedingLimitWeek pregnancyAndBreastfeedingLimitWeek){
    checkForWeekPregnancy(cycles[cycles.length-1].status!);
    savePregnancyForOfflineMode(cycles);
    PregnancyNumberViewModel pregnancyNumberViewModel = _offlineModeDashboardModel.getPregnancyNumber();
    pregnancyAndBreastfeedingLimitWeek.checkPregnancyWeek();
    /// generateBottomMessage(currentWeekPregnancy: pregnancyNumberViewModel.weekNoPregnancy);
    // print(pregnancyNumberViewModel.dayToDelivery);
    generatePregnancyBottomMessages(pregnancyNumberViewModel.weekNoPregnancy!);
    if(!pregnancyNumber.isClosed){
      pregnancyNumber.sink.add(pregnancyNumberViewModel);
    }
  }

  saveBreastfeedingOfflineMode(List<CycleViewModel> cycles){
    List<CycleViewModel>  reverseCycles = cycles.reversed.toList();
    DateTime? childBirthDate;
    for(int i=0 ; i<reverseCycles.length ; i++){
      if(reverseCycles[i].status == 3){
        childBirthDate =  DateTime.parse(reverseCycles[i].periodStart!);
      }else{
        break;
      }
    }
    GenerateDashboardAndNotifyMessages().generateWeekBreastfeeding(true,childBirthDate:childBirthDate!);
  }

  generateWeekBreastfeedingOfflineMode(List<CycleViewModel> cycles,PregnancyAndBreastfeedingLimitWeek pregnancyAndBreastfeedingLimitWeek){
    saveBreastfeedingOfflineMode(cycles);
    RegisterParamViewModel register = _offlineModeDashboardModel.getRegisters();
    pregnancyAndBreastfeedingLimitWeek.checkBreastfeeding();
    if(!breastfeedingNumbers.isClosed){
      breastfeedingNumbers.sink.add(
          BreastfeedingNumberModel(
              breastfeedingCurrentWeek: register.breastfeedingNumberModel!.breastfeedingCurrentWeek,
              breastfeedingCurrentMonth: register.breastfeedingNumberModel!.breastfeedingCurrentMonth
          )
      );
    }
    generateBreastfeedingBottomMessages(register.breastfeedingNumberModel!.breastfeedingCurrentWeek);
    /// generateBottomMessage();
  }

  Future<List<DashBoardMsgOfflineMode>> generateBottomMessages()async{
    List<DashBoardMsgOfflineMode>? allOfflineMessages = await _offlineModeDashboardModel.getAllOfflineMessages();
    List<DashBoardMsgOfflineMode> menstruationMessages = [];
    List<DashBoardMsgOfflineMode> pregnancyMessages = [];
    List<DashBoardMsgOfflineMode> breastfeedingMessages = [];

    for(int i=0 ; i<allOfflineMessages!.length ; i++){
      if(allOfflineMessages[i].status == 1 ){
        menstruationMessages.add(allOfflineMessages[i]);
      }else if(allOfflineMessages[i].status == 2){
        pregnancyMessages.add(allOfflineMessages[i]);
      }else if(allOfflineMessages[i].status == 3){
        breastfeedingMessages.add(allOfflineMessages[i]);
      }
    }
    switch(status.stream.value){
      case 1:{
        return menstruationMessages;
      }
      case 2:{
        return pregnancyMessages;
      }
      case 3:{
        return breastfeedingMessages;
      }
    }
    //
    // offLineBottomMessageDashboard.add(
    //   DashBoardMsgOfflineMode.fromJson(
    //     {
    //       "serverId": "1",
    //       "status": 1,
    //       "condition": 0,
    //       "text": "Period State Never 1"
    //     },
    //   )
    // );
    // offLineBottomMessageDashboard.add(
    //     DashBoardMsgOfflineMode.fromJson(
    //       {
    //         "serverId": "2",
    //         "status": 1,
    //         "condition": 0,
    //         "text": "Period State Never 2"
    //       },
    //     )
    // );
    // if(!bottomMessageOfflineMode.isClosed){
    //   bottomMessageOfflineMode.sink.add(offLineBottomMessageDashboard);
    // }
    return [];
  }

  generateMenstruationBottomMessages(currentToday, periodDay, maxDays, fertStartDays, fertEndDays)async{
    List<DashBoardMsgOfflineMode> menstruationMessages = await generateBottomMessages();
    int userCondition = GenerateDashboardAndNotifyMessages().getTimeConditionUser(currentToday, periodDay, maxDays, fertStartDays, fertEndDays);
    int condition = 0;
    List<DashBoardMsgOfflineMode> randomMessages = [];
    for(int i=0 ; i<menstruationMessages.length ; i++){
      condition = userCondition & menstruationMessages[i].condition;
      if(condition>0){
        randomMessages.add(menstruationMessages[i]);
      }
    }
    if(randomMessages.length <= 2){
      offLineBottomMessageDashboard = randomMessages;
    }else{
      offLineBottomMessageDashboard = getTwoRandom(randomMessages);
    }
    for(int i=0 ; i<offLineBottomMessageDashboard.length ; i++){
      offLineBottomMessageDashboard[i].text = '${randomNameGET()} ${offLineBottomMessageDashboard[i].text}';
    }
    if(!bottomMessageOfflineMode.isClosed){
      bottomMessageOfflineMode.sink.add(offLineBottomMessageDashboard);
    }
  }

  generatePregnancyBottomMessages(int currentWeek)async{
    List<DashBoardMsgOfflineMode> pregnancyMessages = await generateBottomMessages();
    int userCondition = GenerateDashboardAndNotifyMessages().getWeekPregnancyConditionUser(currentWeek);
    int condition = 0;
    List<DashBoardMsgOfflineMode> randomMessages = [];
    for(int i=0 ; i<pregnancyMessages.length ; i++){
      condition = userCondition & pregnancyMessages[i].condition;
      if(condition>0){
        randomMessages.add(pregnancyMessages[i]);
      }
    }
    if(randomMessages.length <= 2){
      offLineBottomMessageDashboard = randomMessages;
    }else{
      offLineBottomMessageDashboard = getTwoRandom(randomMessages);
    }
    for(int i=0 ; i<offLineBottomMessageDashboard.length ; i++){
      offLineBottomMessageDashboard[i].text = '${randomNameGET()} ${offLineBottomMessageDashboard[i].text}';
    }
    if(!bottomMessageOfflineMode.isClosed){
      bottomMessageOfflineMode.sink.add(offLineBottomMessageDashboard);
    }
  }

  generateBreastfeedingBottomMessages(int currentWeek)async{
    List<DashBoardMsgOfflineMode> breastfeedingMessages = await generateBottomMessages();
    int userCondition = GenerateDashboardAndNotifyMessages().getWeekBreastfeedingConditionUser(currentWeek);
    int condition = 0;
    List<DashBoardMsgOfflineMode> randomMessages = [];
    for(int i=0 ; i<breastfeedingMessages.length ; i++){
      condition = userCondition & breastfeedingMessages[i].condition;
      if(condition>0){
        randomMessages.add(breastfeedingMessages[i]);
      }
    }
    if(randomMessages.length <= 2){
      offLineBottomMessageDashboard = randomMessages;
    }else{
      offLineBottomMessageDashboard = getTwoRandom(randomMessages);
    }
    for(int i=0 ; i<offLineBottomMessageDashboard.length ; i++){
      offLineBottomMessageDashboard[i].text = '${randomNameGET()} ${offLineBottomMessageDashboard[i].text}';
    }
    if(!bottomMessageOfflineMode.isClosed){
      bottomMessageOfflineMode.sink.add(offLineBottomMessageDashboard);
    }
  }

  List<DashBoardMsgOfflineMode> getTwoRandom(List<DashBoardMsgOfflineMode> bankStr) {
    int random1 =  Random().nextInt(bankStr.length);
    int random2 =  Random().nextInt(bankStr.length);

    if (random1 == random2)
      return getTwoRandom(bankStr);
    else {
      List<DashBoardMsgOfflineMode> twoStr = [];
        twoStr.add(bankStr[random1]);
        twoStr.add(bankStr[random2]);
      return twoStr;
    }
  }

  String randomNameGET(){
    List<String> names = [];
    names.add("ایمپویی عزیز");
    names.add("دوست خوبم");
    names.add("ایمپویی جان")   ;
    return names[new Random().nextInt(3)];
  }

  checkNet(context)async{
    if(await checkConnectionInternet()){
      topMessage = DashBoardMessageAndNotifyViewModel();
      Navigator.pushReplacement(
          context,
          PageTransition(
              settings: RouteSettings(name: "/Page1"),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
              child:  SplashScreen(
                localPass: false,
                index: 4,
              )
          )
      );
    }
  }

  setRegister()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? periodDay =  prefs.getInt('periodDay');
    int? circleDay = prefs.getInt('circleDay');
    _offlineModeDashboardModel.registerInfo.setStatus(status.stream.value);
    _offlineModeDashboardModel.registerInfo.setPeriodDay(periodDay!);
    _offlineModeDashboardModel.registerInfo.setCircleDay(circleDay!);
  }

  setAllCycles()async{
    List<CycleViewModel>? cycles = await _offlineModeDashboardModel.getAllCirclesOfflineMode();
    _offlineModeDashboardModel.removeAllCycles();
    if(cycles != null){
      for(int i=0 ; i<cycles.length ; i++){
        _offlineModeDashboardModel.addCycleToLocator(
          {
            'id' : cycles[i].id,
            'periodStartDate' :cycles[i].periodStart,
            'periodEndDate' :  cycles[i].periodEnd,
            'cycleEndDate' :  cycles[i].circleEnd,
            'status' : cycles[i].status,
          }
        );
      }
    }

  }

  setAllMotivalMessages()async{
    List<DashBoardMessageAndNotifyViewModel>? motivalMessages = await _offlineModeDashboardModel.getAllMotivalMessages();
    _offlineModeDashboardModel.removeAllMotivalMessages();
    //getMotivalMessage
    if(motivalMessages != null){
      for(int i=0 ; i<motivalMessages.length ; i++){
        _offlineModeDashboardModel.addMotivalMessage(
            {
              'id' : motivalMessages[i].offlineId,
              'text' : motivalMessages[i].text,
            }
        );
      }
    }
  }

  setTypeCalendarAndNationality()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? _calendarType =  prefs.getInt('calendarType');
    String? _nationality =  prefs.getString('nationality');
    _offlineModeDashboardModel.registerInfo.setCalendarType(_calendarType!);
    _offlineModeDashboardModel.registerInfo.setNationality(_nationality!);
  }

  gotoCalendar(context,calenderPresenter){
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: 500),
        child:  FeatureDiscovery(
          recordStepsInSharedPreferences: true,
          child: _offlineModeDashboardModel.getRegisters().calendarType ==
              1
              ? CalenderEn(
            calenderPresenter: calenderPresenter,
            isOfflineMode: true,
          )
              : Calender(
            calenderPresenter : calenderPresenter,
            isOfflineMode: true,
          ),
        ),
      )
    );
  }

  dispose(){
    status.close();
    pregnancyNumber.close();
    breastfeedingNumbers.close();
    bottomMessageOfflineMode.close();
  }

}