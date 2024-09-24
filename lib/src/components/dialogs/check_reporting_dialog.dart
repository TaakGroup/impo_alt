


import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:impo/src/architecture/presenter/dashboard_presenter.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:impo/src/screens/home/tabs/profile/reporting/reporting_screen.dart';

import '../../firebase_analytics_helper.dart';


class CheckReportingDialog{

  late AnimationController animationControllerDialog;

  final isShowCheckReportingDialog = BehaviorSubject<bool>.seeded(false);
  final dialogScale = BehaviorSubject<double>.seeded(0.0);
  final valueCheckUpdateDialog = BehaviorSubject<String>.seeded('');


  Stream<bool> get isShowCheckReportingDialogObserve => isShowCheckReportingDialog.stream;
  Stream<double> get dialogScaleObserve => dialogScale.stream;
  Stream<String> get valueCheckUpdateDialogObserve => valueCheckUpdateDialog.stream;

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


  showDialog()async{
    AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_CheckReportingDlg_Dlg_Load);
    animationControllerDialog.forward();
    if(!isShowCheckReportingDialog.isClosed){
      isShowCheckReportingDialog.sink.add(true);
    }
    if(!valueCheckUpdateDialog.isClosed){
      valueCheckUpdateDialog.sink.add('ایمپویی عزیز با توجه به اینکه سه دوره از پریودت رو با ایمپو پشت سر گذاشتی، از این به بعد می‌تونی از قابلیت گزارش‌گیری ایمپو استفاده کنی');
    }
  }


  checkReporting(DashboardPresenter presenter)async{
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    List<CycleViewModel> circles =  presenter.getAllCirlse();
    List<CycleViewModel> reverseCircles =  circles.reversed.toList();
    List<CycleViewModel> periodCycles = [];
    for(int i=0; i<reverseCircles.length ; i++){
      if(reverseCircles[i].status == 0){
        periodCycles.add(reverseCircles[i]);
      }else{
        break;
      }
    }
    if(periodCycles.length >= 3){
      if(prefs.getBool('checkReporting') != null){
        if(!prefs.getBool('checkReporting')!){
          showDialog();
          prefs.setBool('checkReporting', true);
        }
      }else{
        showDialog();
        prefs.setBool('checkReporting', true);
      }
    }
  }

  cancel()async{
    await animationControllerDialog.reverse();
    if(!isShowCheckReportingDialog.isClosed){
      isShowCheckReportingDialog.sink.add(false);
    }
  }

  accept(context,expertPresenter,name) async {
    cancel();
    Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: ReportingScreen(
              name: name,
              expertPresenter: expertPresenter,
            )
        )
    );
  }


  dispose(){
    isShowCheckReportingDialog.close();
    dialogScale.close();
    valueCheckUpdateDialog.close();
  }

}