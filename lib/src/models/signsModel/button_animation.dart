


import 'package:flutter/animation.dart';
import 'package:impo/src/components/animations.dart';
import 'package:rxdart/rxdart.dart';

class ButtonAnimation {

  static ButtonAnimation? buttonAnimation;
  static ButtonAnimation? getGlobal(){
    if(buttonAnimation == null) {
      // print('create');
      buttonAnimation = new ButtonAnimation();
    }
    return buttonAnimation;
  }

  late AnimationController animationControllerScaleButtons;

  final isShowBoxDateTime = BehaviorSubject<bool>.seeded(true);

  Stream<bool> get isShowBoxDateTimeObserve => isShowBoxDateTime.stream;


  setAnim(init){
    animationControllerScaleButtons = init;
  }

  AnimationController getAnim(){
    return animationControllerScaleButtons;
  }

  setIsShowBoxDateTime(bool value){
    if(!isShowBoxDateTime.isClosed){
      isShowBoxDateTime.sink.add(value);
    }
  }

//  Observable<bool> getIsShowBoxDateTime(){
//    return isShowBoxDateTimeObserve;
//  }

  dispose(){
    isShowBoxDateTime.close();
  }







}