
import 'package:flutter/animation.dart';
import 'package:rxdart/rxdart.dart';

import '../../firebase_analytics_helper.dart';

class BreastfeedingDialog {

  AnimationController? animationControllerDialog;

  final isShowBreastfeedingDialog = BehaviorSubject<bool>.seeded(false);
  final dialogScale = BehaviorSubject<double>.seeded(0.0);



  Stream<bool> get isShowBreastfeedingDialogObserve => isShowBreastfeedingDialog.stream;
  Stream<double> get dialogScaleObserve => dialogScale.stream;

  initialDialogScale(_this){
    animationControllerDialog = AnimationController(
        vsync: _this,
        lowerBound: 0.0,
        upperBound: 1,
        duration: Duration(milliseconds: 250));
    animationControllerDialog!.addListener(() {
      dialogScale.sink.add(animationControllerDialog!.value);
    });
  }

  showBreastfeedingDialog(){
    AnalyticsHelper().log(AnalyticsEvents.DashPgBrstfeed_BrstfeedDlg_Dlg_Load);
    animationControllerDialog!.forward();
    if(!isShowBreastfeedingDialog.isClosed){
      isShowBreastfeedingDialog.sink.add(true);
    }
  }

  cancel()async{
    await animationControllerDialog!.reverse();
    if(!isShowBreastfeedingDialog.isClosed){
      isShowBreastfeedingDialog.sink.add(false);
    }
  }

  dispose(){
    isShowBreastfeedingDialog.close();
    dialogScale.close();
  }

}