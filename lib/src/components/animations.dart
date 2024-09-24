

import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:rxdart/rxdart.dart';

class Animations {

  late AnimationController animationControllerScaleBackButton;
  late AnimationController animationControllerShakeError;
  late AnimationController animationControllerBoxHelp;
  late Animation<double> animationShakeError;
  late Animation<Offset> buttonAnimationBottom;
  late AnimationController buttonAnimationControllerBottom;
  int counter = 0;

  final squareScaleBackButton = BehaviorSubject<double>.seeded(0.7);
  final squareScaleBoxHelp = BehaviorSubject<double>.seeded(0);
  final isErrorShow = BehaviorSubject<bool>.seeded(false);
  final errorText = BehaviorSubject<String>.seeded('');

  Stream<double> get squareScaleBackButtonObserve => squareScaleBackButton.stream;
  Stream<double> get squareScaleBoxHelpObserve => squareScaleBoxHelp.stream;
  Stream<bool> get isShowErrorObserve => isErrorShow.stream;
  Stream<String> get errorTextObserve => errorText.stream;


  AnimationController pressButton(_this){


    animationControllerScaleBackButton = AnimationController(
        vsync: _this,
        lowerBound: 0.85,
        upperBound: 1,
        duration: Duration(milliseconds: 250));
    animationControllerScaleBackButton.forward();
    animationControllerScaleBackButton.addListener(() {

        squareScaleBackButton.sink.add(animationControllerScaleBackButton.value);

      if(animationControllerScaleBackButton.isDismissed){
        animationControllerScaleBackButton.forward();
      }

    });

    return animationControllerScaleBackButton;

  }

  AnimationController initialBoxHelp(_this){


    animationControllerBoxHelp = AnimationController(
        vsync: _this,
        lowerBound: 0,
        upperBound: 1,
        animationBehavior: AnimationBehavior.preserve,
        duration: Duration(milliseconds: 350));
//    animationControllerBoxHelp.forward();
    animationControllerBoxHelp.addListener(() {

      squareScaleBoxHelp.sink.add(animationControllerBoxHelp.value);

//      if(animationControllerBoxHelp.isDismissed){
//        animationControllerBoxHelp.forward();
//      }

    });

    return animationControllerBoxHelp;

  }



  AnimationController shakeError(_this){

    animationControllerShakeError = AnimationController(vsync: _this,duration: Duration(milliseconds: 100));
    animationShakeError= Tween<double>(
        begin: 0.0,
        end: 4.0
    ).animate(new CurvedAnimation(parent: animationControllerShakeError,curve: new Interval(0.0, 1.0,curve: Curves.ease)));
    animationControllerShakeError.forward();

    return animationControllerShakeError;

  }

  showShakeError(String error){
    counter =0;
    animationControllerShakeError.reverse();
    isErrorShow.sink.add(true);
    errorText.sink.add(error);
    animationControllerShakeError.addListener((){
      if(counter < 4){
        if (animationControllerShakeError.isCompleted) {
          animationControllerShakeError.reverse();
        }
        if(animationControllerShakeError.isDismissed){
          animationControllerShakeError.forward();
          counter++;
        }
      }
    }
    );
  }

  AnimationController  initialBottomButton(_this){
    buttonAnimationControllerBottom = AnimationController(vsync: _this, duration: Duration(milliseconds: 800));
    buttonAnimationBottom = Tween<Offset>(
        begin: Offset(0,2),
        end: Offset(0, 0)
    ).animate(new CurvedAnimation(parent:buttonAnimationControllerBottom,curve: new Interval(0.0, 1.0 , curve: Curves.ease)));

    return buttonAnimationControllerBottom;
  }

  disposeAnimBottom(){
    buttonAnimationControllerBottom?.dispose();
  }

  dispose(){
    squareScaleBackButton.close();
    errorText.close();
    isErrorShow.close();
    squareScaleBoxHelp.close();
  }

}