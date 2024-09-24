

import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:impo/src/components/dialogs/finish_task.dart';
import 'package:impo/src/data/local/database_provider.dart';
import 'package:impo/src/screens/splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExitAppDialog{

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

  acceptDialog(context)async{
    await animationControllerDialog.reverse();
    if(!isShowExitDialog.isClosed){
      isShowExitDialog.sink.add(false);
    }
    FinishTask.finishTask();
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