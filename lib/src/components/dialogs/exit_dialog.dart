

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:impo/src/architecture/presenter/calender_presenter.dart';
import 'package:impo/src/architecture/presenter/dashboard_presenter.dart';
import 'package:impo/src/data/local/database_provider.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/bioRhythm/biorhythm_view_model.dart';
import 'package:impo/src/models/partnerBioRhythm/partner_biorhythm_view_model.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/dashboard/dashboard_messages_and_notify_model.dart';
import 'package:impo/src/screens/splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pdf/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExitDialog{

  late AnimationController animationControllerDialog;

  final isShowExitDialog = BehaviorSubject<bool>.seeded(false);
  final dialogScale = BehaviorSubject<double>.seeded(0.0);


  Stream<bool> get isShowExitDialogObserve => isShowExitDialog.stream;
  Stream<double> get dialogScaleObserve => dialogScale.stream;

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

  onPressShowDialog(){
    Timer(Duration(milliseconds: 50),()async{
      animationControllerDialog.forward();
      if(!isShowExitDialog.isClosed){
        isShowExitDialog.sink.add(true);
      }
    });

  }

  Future<bool> acceptDialog({BuildContext? context , bool? isDialog})async{
    DataBaseProvider db  = new DataBaseProvider();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('pass');
    await prefs.remove('isAnim');
    await prefs.remove('fingerPrint');
    await prefs.remove('userName');
    await prefs.remove('date');
    await prefs.remove('password');
    await prefs.remove('typeValue');
    await prefs.remove('checkReporting');
    // await prefs.remove('deviceToken');
    await prefs.remove('showDialogBackup');
    await prefs.remove('userToken');
    await prefs.remove('ieExpert');
    await prefs.remove('showDialogBackupExpert');
    await prefs.remove('endTimeWomanSubscribe');
    await prefs.remove('womansubscribtion');
    await prefs.remove('showComment');
    await db.removeAllDataBase();
    var cycleInfo = locator<CycleModel>();
    var allDashboardMessageInfo =  locator<AllDashBoardMessageAndNotifyModel>();
    cycleInfo.removeAllCycles();
    allDashboardMessageInfo.removeAllMessageAndNotifies();
    bottomMessageDashboard.clear();
    topMessage = DashBoardMessageAndNotifyViewModel();
    allRandomMessages.clear();
    viewBioRhythms.clear();
    partnerAllRandomMessages.clear();
    viewPartnerBioRhythms.clear();
    if(isDialog!){
      await animationControllerDialog.reverse();
      if(!isShowExitDialog.isClosed){
        isShowExitDialog.sink.add(false);
      }
      Timer(Duration(milliseconds: 50),(){
        Navigator.pushReplacement(
            context!,
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
    }

    return true;
  }

  cancelDialog()async{
    await animationControllerDialog.reverse();
    if(!isShowExitDialog.isClosed){
      isShowExitDialog.sink.add(false);
    }
  }

  dispose(){
    isShowExitDialog.close();
    dialogScale.close();
  }


}