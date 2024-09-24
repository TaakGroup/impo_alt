
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBackButton extends StatefulWidget{

  final onPressBack;
  final angleIcon;

  CustomBackButton({Key? key,this.onPressBack,this.angleIcon}):super(key:key);

  @override
  State<StatefulWidget> createState() => CustomBackButtonState();
}

class CustomBackButtonState extends State<CustomBackButton>with TickerProviderStateMixin{

  late AnimationController animationControllerScaleBackButton;
  double squareScaleBackButton = 0.7;

  @override
  void initState() {
    animationControllerScaleBackButton = AnimationController(
        vsync: this,
        lowerBound: 0.7,
        upperBound: 1,
        duration: Duration(milliseconds: 200));
    animationControllerScaleBackButton.forward();
    animationControllerScaleBackButton.addListener(() {
      setState(() {
        squareScaleBackButton = animationControllerScaleBackButton.value;
      });

    });
    super.initState();
  }

  @override
  void dispose() {
    animationControllerScaleBackButton.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.5;
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return  Transform.scale(
      scale: squareScaleBackButton,
      child:  GestureDetector(
        onTap: pressBack,
        child:  Container(
          margin: EdgeInsets.only(
            top:  ScreenUtil().setWidth(90),
            left: ScreenUtil().setWidth(45)
          ),
          padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(15),
            bottom: ScreenUtil().setWidth(12),
            right: ScreenUtil().setWidth(12),
            left: ScreenUtil().setWidth(14)
          ),
          decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.2),
                    blurRadius: 5,
                   offset: Offset(0,1)
                )
              ]
          ),
          child:  Transform.rotate(
            angle: widget.angleIcon.toDouble(),
            child:  Container(
              height: ScreenUtil().setWidth(45),
              width: ScreenUtil().setWidth(45),
              child:  SvgPicture.asset(
                'assets/images/ic_arrow_back.svg',
                width: ScreenUtil().setWidth(40),
                height: ScreenUtil().setWidth(40),
              )
            )
          )
        )
      ),
    );
  }

  pressBack(){
    animationControllerScaleBackButton.reverse();
    animationControllerScaleBackButton.addListener(() async {
      if(animationControllerScaleBackButton.isDismissed){
        animationControllerScaleBackButton.forward();
        widget.onPressBack();
      }
    });
  }

}




