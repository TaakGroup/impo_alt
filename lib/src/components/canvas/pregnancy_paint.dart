
import 'dart:math';

import 'package:angles/angles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/components/colors.dart';
import 'package:get/get.dart';

class PregnancyPaint extends CustomPainter{
  double? width;
  int? currentWeek;
  int? maxWeeks;
  BuildContext? context;

  PregnancyPaint({this.width,this.currentWeek,this.maxWeeks,this.context});

  late double radius;

  double widthOfArc = 2;

  double currentX = 0;
  double currentY = 0;
  late Angle current;
  double boxCurrentX = 0;
  double boxCurrentY= 0;

  @override
  void paint(Canvas canvas, Size size) {
    generateNumber();

    double currentCircleRadius = ScreenUtil().setWidth(12);



    currentX = radius * cos(degToRed(current));
    currentY = radius * sin(degToRed(current));



    Rect arcRect =  Rect.fromCircle(
      center: Offset(0,0),
      radius: radius,
    );

    Rect currentCircleRect =  Rect.fromCircle(
      center: Offset(currentX,currentY),
      radius: currentCircleRadius
    );


    final bigCirclePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ScreenUtil().setWidth(4)
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
          colors: [
            Color(0xff9BF8FB).withOpacity(0.15),
            Color(0xffAFB3FC).withOpacity(0.15),
          ],
          // center: Alignment.center,
          // endAngle: degToRed(current)
      )
          .createShader(arcRect)
      ..color = ColorPallet().mainColor;


    final underArcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ScreenUtil().setWidth(8)
      ..strokeCap = StrokeCap.round
      ..color = Color(0xffF4F3FD).withOpacity(0.3);


    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ScreenUtil().setWidth(8)
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
          colors: [
            ColorPallet().mentalMain.withOpacity(0.0),
            ColorPallet().mentalMain,
          ],
          center: Alignment.center,
          endAngle: degToRed(current)
      )
          .createShader(arcRect)
      ..color = ColorPallet().mainColor;

    final currentCirclePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = ColorPallet().mentalMain
      ..shader = LinearGradient(
          colors: [
            ColorPallet().mentalHigh,
            ColorPallet().mentalMain,
          ],
      ).createShader(currentCircleRect);

    final boxCurrentPaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;



    canvas.drawCircle(
      Offset(0,0),
      radius + ScreenUtil().setWidth(50),
      bigCirclePaint
    );

    canvas.drawCircle(
        Offset(0,0),
        radius,
        underArcPaint
    );

    Path boxCurrentPath = Path()
      ..addRRect(RRect.fromRectAndCorners(
          Rect.fromCircle(center: Offset(boxCurrentX,boxCurrentY - ScreenUtil().setWidth(8)),radius: ScreenUtil().setWidth(27)),
          bottomLeft: Radius.circular(7),
          topRight: Radius.circular(7),
          topLeft: Radius.circular(7),
          bottomRight: Radius.circular(7)
      ));

    canvas.drawShadow(boxCurrentPath,
        Color(0xff20DFE4).withOpacity(.3),
        7, true);

    canvas.drawRRect(RRect.fromRectAndCorners(
        Rect.fromCircle(center: Offset(boxCurrentX,boxCurrentY),radius: ScreenUtil().setWidth(27)),
        bottomLeft: Radius.circular(7),
        topRight: Radius.circular(7),
        topLeft: Radius.circular(7),
        bottomRight: Radius.circular(7)
    ), boxCurrentPaint);


    TextSpan periodText =  TextSpan(
        style:  context!.textTheme.bodyMedium!.copyWith(
          color: ColorPallet().mentalMain,
        )
        , text: currentWeek.toString());
    TextPainter tpPeriod =  TextPainter(text: periodText, textAlign: TextAlign.left, textDirection: TextDirection.ltr);


    tpPeriod.layout();

    tpPeriod.paint(canvas,  Offset(boxCurrentX - tpPeriod.width/2,boxCurrentY - tpPeriod.height/2));


    canvas.rotate(degToRed(Angle.degrees(-90)));
    canvas.drawArc(
      arcRect,
      degToRed(Angle.degrees(1)),degToRed(current),false,arcPaint,
    );


    canvas.drawCircle(
        Offset(currentX,currentY),
        currentCircleRadius,
        currentCirclePaint
    );


  }


 double degToRed(Angle d){
    return d.radians;
  }

  generateNumber(){

    radius = ((width! - widthOfArc) / 2) - ScreenUtil().setWidth(80);

    current = Angle.degrees(((360*currentWeek!)/maxWeeks!));

    // print(current.degrees);

    if(current.degrees <= 0){

      boxCurrentX =   (radius + ScreenUtil().setWidth(55)) * cos(current.radians + Angle.gradians(-90).radians);
      boxCurrentY = (radius + ScreenUtil().setWidth(55)) * sin(current.radians + Angle.gradians(-90).radians);

//      ovumX =   (radius + 35) * math.cos(ovum.radians);
//      ovumY = (radius + 35) * math.sin(ovum.radians);

    }else if(current.degrees > 0 && current.degrees <= 90){

      if(current.degrees == 90){

        boxCurrentX = (radius + ScreenUtil().setWidth(40)) * cos(current.radians + Angle.gradians(-90).radians);
        boxCurrentY = (radius + ScreenUtil().setWidth(35)) * sin(current.radians + Angle.gradians(-90).radians);


      }else{

        if(current.degrees >= 45){

          boxCurrentX = (radius + ScreenUtil().setWidth(40)) * cos(current.radians + Angle.gradians(-90).radians);
          boxCurrentY = (radius + ScreenUtil().setWidth(80)) * sin(current.radians + Angle.gradians(-90).radians);


        }else if(current.degrees >= 20){

          boxCurrentX = (radius + ScreenUtil().setWidth(35)) * cos(current.radians + Angle.gradians(-90).radians);
          boxCurrentY = (radius + ScreenUtil().setWidth(55)) * sin(current.radians + Angle.gradians(-90).radians);


        }else{

          boxCurrentX = (radius + ScreenUtil().setWidth(30)) * cos(current.radians + Angle.gradians(-90).radians);
          boxCurrentY = (radius + ScreenUtil().setWidth(50)) * sin(current.radians + Angle.gradians(-90).radians);


        }

      }

    }else if(current.degrees > 90 && current.degrees <= 180){


      if(current.degrees >= 160){

        boxCurrentX = (radius + ScreenUtil().setWidth(40)) * cos(current.radians + Angle.gradians(-90).radians);
        boxCurrentY = (radius + ScreenUtil().setWidth(40)) * sin(current.radians + Angle.gradians(-90).radians);


      }else{
        boxCurrentX = (radius + ScreenUtil().setWidth(45)) * cos(current.radians + Angle.gradians(-90).radians);
        boxCurrentY = (radius + ScreenUtil().setWidth(30)) * sin(current.radians + Angle.gradians(-90).radians);

      }

    }else if(current.degrees > 180 && current.degrees <= 270){

      if(current.degrees <= 210){

        boxCurrentX = (radius + ScreenUtil().setWidth(35)) * cos(current.radians + Angle.gradians(-90).radians);
        boxCurrentY = (radius + ScreenUtil().setWidth(55)) * sin(current.radians + Angle.gradians(-90).radians);


      }else{

        boxCurrentX = (radius + ScreenUtil().setWidth(40)) * cos(current.radians + Angle.gradians(-90).radians);
        boxCurrentY = (radius + ScreenUtil().setWidth(55)) * sin(current.radians + Angle.gradians(-90).radians);


      }

    }else if(current.degrees > 270 && current.degrees <= 360){


      if(current.degrees == 360){

        boxCurrentX = (radius + ScreenUtil().setWidth(-150)) * cos(current.radians + Angle.gradians(-90).radians);
        boxCurrentY = (radius + ScreenUtil().setWidth(55)) * sin(current.radians + Angle.gradians(-90).radians);

      }else{
        boxCurrentX = (radius + ScreenUtil().setWidth(45)) * cos(current.radians + Angle.gradians(-90).radians);
        boxCurrentY = (radius + ScreenUtil().setWidth(40)) * sin(current.radians + Angle.gradians(-90).radians);
      }

    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

}