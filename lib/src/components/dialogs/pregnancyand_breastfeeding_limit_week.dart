


import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/dashboard/pregnancy_numbers_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../firebase_analytics_helper.dart';

class PregnancyAndBreastfeedingLimitWeek {

  late AnimationController animationControllerDialog;
  var pregnancyNumberInfo = locator<PregnancyNumberModel>();
  var registerInfo = locator<RegisterParamModel>();

  final isShowCheckPregnancyWeekDialog = BehaviorSubject<bool>.seeded(false);
  final dialogScale = BehaviorSubject<double>.seeded(0.0);
  final isPregnancyDialog = BehaviorSubject<bool>.seeded(false);



  Stream<bool> get isShowCheckPregnancyWeekDialogObserve => isShowCheckPregnancyWeekDialog.stream;
  Stream<double> get dialogScaleObserve => dialogScale.stream;
  Stream<bool> get isPregnancyDialogObserve => isPregnancyDialog.stream;


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

  checkPregnancyWeek(){
    int currentWeek = pregnancyNumberInfo.pregnancyNumbers.weekNoPregnancy!;
    if(currentWeek >= 43){
      if(!isPregnancyDialog.isClosed){
        isPregnancyDialog.sink.add(true);
      }
      AnalyticsHelper().log(AnalyticsEvents.DashPgPregnancy_PregnancyLimitWeek_Dlg_Load);
      showDialog();
    }
  }


  checkBreastfeeding(){
    int currentWeek = registerInfo.register.breastfeedingNumberModel!.breastfeedingCurrentWeek;
    if(currentWeek >= 26){
      if(!isPregnancyDialog.isClosed){
        isPregnancyDialog.sink.add(false);
      }
      AnalyticsHelper().log(AnalyticsEvents.DashPgBrstfeed_BrstfeedLimitWeek_Dlg_Load);
      showDialog();
    }
  }

  showDialog(){
    Timer(Duration(milliseconds: 50),()async{
      animationControllerDialog.forward();
      if(!isShowCheckPregnancyWeekDialog.isClosed){
        isShowCheckPregnancyWeekDialog.sink.add(true);
      }
    });
  }

  cancelDialog(){
     animationControllerDialog.reverse();
    if(!isShowCheckPregnancyWeekDialog.isClosed){
      isShowCheckPregnancyWeekDialog.sink.add(false);
    }
  }

  dispose(){
    isShowCheckPregnancyWeekDialog.close();
    dialogScale.close();
    isPregnancyDialog.close();
  }

}

