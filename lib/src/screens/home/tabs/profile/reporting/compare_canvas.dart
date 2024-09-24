import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/reporting/chart_comparison_model.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:impo/src/core/app/view/themes/theme.dart';

class CompareCanvas extends CustomPainter{

  final ChartComparisonModel chartComparison;
  final BuildContext context;

  CompareCanvas({required this.chartComparison,required this.context});
  double marginTopCircleDay = ScreenUtil().setWidth(180);
  double margin = ScreenUtil().setWidth(80);

  @override
  void paint(Canvas canvas, Size size) {
    final circleDayPaint = Paint()
      .. strokeWidth = ScreenUtil().setWidth(10)
      ..color = ColorPallet().mainColor;

    final dottedLinePaintCircleDay = Paint()
      .. strokeWidth = ScreenUtil().setWidth(4)
      ..color = ColorPallet().mainColor;

    final dottedLinePaintPeriodDay = Paint()
      .. strokeWidth = ScreenUtil().setWidth(4)
      ..color = Color(0xffFFA3E0);

    final periodDayPaint = Paint()
      ..color = Color(0xffFFA3E0);

    // final lineMonthPaint = Paint()
    //   ..color = Color(0xff707070).withOpacity(0.4);
    //
    // final boxNameMonthPaint = Paint()
    //   ..color = Color(0xffEBEBEB);

    TextStyle whiteTextStyle =  context.textTheme.labelSmallProminent!.copyWith(
      color: Colors.white,
      fontFamily: ImpoTheme.fontFamily
    );

    TextStyle registerCircleStyle  = context.textTheme.labelMedium!.copyWith(
      color: ColorPallet().mainColor,
        fontFamily: ImpoTheme.fontFamily
    );

    TextStyle registerPeriodStyle = context.textTheme.labelMedium!.copyWith(
        color:Color(0xffFFA3E0),
        fontFamily: ImpoTheme.fontFamily
    );

    TextStyle normalCycleStyle =  context.textTheme.labelSmallProminent!.copyWith(
      color: ColorPallet().mainColor,
      fontFamily: ImpoTheme.fontFamily
    );

    TextStyle unNormalCycleStyle = context.textTheme.labelSmallProminent!.copyWith(
        color: Color(0xff20DFE4),
        fontFamily: ImpoTheme.fontFamily
    );

    TextStyle nameMonthStyle =  context.textTheme.bodySmall!.copyWith(
        color: Color(0xff707070),
        fontFamily: ImpoTheme.fontFamily
    );


    double marginDottedLeft = ScreenUtil().setWidth(40);
    double marginTextRegisterDay = ScreenUtil().setWidth(100);
    double margiBetWeen = ScreenUtil().setWidth(180);

    //CircleDay
    double marginLeftCircleDay = ScreenUtil().setWidth(300);
    double yCircleDayStart = marginLeftCircleDay;
    double marginBottomCircleDay = ScreenUtil().setWidth(40);
    double circleDayRightRect = ScreenUtil().setWidth(60);
    double yCircleDayEnd = 0;
    double lengthCircleDay = 0;
    TextSpan registerCircleDayText =  TextSpan(
        style: registerCircleStyle,
        text: '${chartComparison.circleDayRegister}\nدوره نرمال'
    );
    TextPainter tpRegisterCircleDay =  TextPainter(text: registerCircleDayText,textAlign: TextAlign.right, textDirection: TextDirection.rtl);
    tpRegisterCircleDay.layout();


    //PeriodDay
    double marginLeftPeriodDay = marginLeftCircleDay + ScreenUtil().setWidth(10) ;
    double marginBottomPeriodDay = ScreenUtil().setWidth(10);
    double yPeriodDayStart = marginLeftPeriodDay;
    double periodDayRightRect = ScreenUtil().setWidth(40);
    double yPeriodDayEnd = 0;
    double lengthPeriodDay = 0;
    // double marginTopMonthLine = marginTopCircleDay - ScreenUtil().setWidth(180);
    // double heightMonthLine = marginTopCircleDay + ScreenUtil().setWidth(170);
    // double heightBoxMonthName = heightMonthLine - ScreenUtil().setWidth(40);
    TextSpan registerPeriodDayText =  TextSpan(
        style: registerPeriodStyle,
        text: '${chartComparison.periodDayRegister}\nپریود نرمال'
    );
    TextPainter tpRegisterPeriodDay =  TextPainter(text: registerPeriodDayText,textAlign: TextAlign.right, textDirection: TextDirection.rtl);
    tpRegisterPeriodDay.layout();

    _drawDashedLine(canvas, size, dottedLinePaintCircleDay,marginDottedLeft,_setDottedCircleDay(size));
    _drawDashedLine(canvas, size, dottedLinePaintPeriodDay,marginDottedLeft,_setDottedPeriodDay(size));

    for(int i=0 ; i<chartComparison.circles.length; i++){
      lengthCircleDay = _setHeightCircleDayChart( i, size);
      lengthPeriodDay = _setHeightPeriodDayChart( i, size);
      yCircleDayEnd = size.height - lengthCircleDay ;
      yPeriodDayEnd = size.height - lengthPeriodDay ;

      //statusText
      TextSpan statusText =  TextSpan(
          style: chartComparison.circles[i].status ? normalCycleStyle : unNormalCycleStyle,
          text: chartComparison.circles[i].status ? 'منظم' : 'نامنظم'
      );
      TextPainter tpStatusText =  TextPainter(text: statusText,textAlign: TextAlign.right, textDirection: TextDirection.rtl);
      tpStatusText.layout();
      tpStatusText.paint(canvas, Offset(yCircleDayStart,ScreenUtil().setWidth(5)));


      //nameMonth
      TextSpan nameMonthText =  TextSpan(
          style: nameMonthStyle,
          text: chartComparison.circles[i].months
      );
      TextPainter tpNameMonthText =  TextPainter(text: nameMonthText,textAlign: TextAlign.right, textDirection: TextDirection.rtl);
      tpNameMonthText.layout();
      tpNameMonthText.paint(canvas, Offset(yCircleDayStart+ (circleDayRightRect/2)-(tpNameMonthText.width/2),size.height - marginBottomCircleDay - ScreenUtil().setWidth(25)));


      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(yCircleDayStart,yCircleDayEnd - margin,yCircleDayStart + circleDayRightRect,size.height - margin ), Radius.circular(20)), circleDayPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(yPeriodDayStart,yPeriodDayEnd - margin,yPeriodDayStart +periodDayRightRect,size.height - marginBottomPeriodDay - margin), Radius.circular(20)), periodDayPaint);
      // canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(yCircleDayStart,yCircleDayEnd,yCircleDayStart + circleDayRightRect,size.height), Radius.circular(0)), circleDayPaint);
      // canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(yCircleDayStart,yPeriodDayEnd,yCircleDayStart + circleDayRightRect,size.height -marginBottomCircleDay), Radius.circular(0)), periodDayPaint);

      //circleDayText
      TextSpan circleDayText =  TextSpan(
          style: whiteTextStyle,
          text: chartComparison.circles[i].circleDay.toString()
      );
      TextPainter tpCircleDayText =  TextPainter(text: circleDayText,textAlign: TextAlign.right, textDirection: TextDirection.rtl);
      tpCircleDayText.layout();
      tpCircleDayText.paint(canvas, Offset(yCircleDayStart + (circleDayRightRect/2)-(tpCircleDayText.width/2) ,yCircleDayEnd - margin + ScreenUtil().setWidth(10)));


      //periodDayText
      TextSpan periodDayText =  TextSpan(
          style: whiteTextStyle,
          text: chartComparison.circles[i].periodDay.toString()
      );
      TextPainter tpPeriodDayText =  TextPainter(text: periodDayText,textAlign: TextAlign.right, textDirection: TextDirection.rtl);
      tpPeriodDayText.layout();
      tpPeriodDayText.paint(canvas, Offset(yPeriodDayStart + (periodDayRightRect/2)-(tpPeriodDayText.width/2),yPeriodDayEnd - margin + ScreenUtil().setWidth(5)));


      yCircleDayStart =  yCircleDayStart + margiBetWeen;
      yPeriodDayStart =  yPeriodDayStart + margiBetWeen;
    }

    tpRegisterCircleDay.paint(canvas, Offset(marginDottedLeft,_setDottedCircleDay(size)- marginTextRegisterDay));
    tpRegisterPeriodDay.paint(canvas, Offset(marginDottedLeft,_setDottedPeriodDay(size)-marginTextRegisterDay));

  }


   _setHeightCircleDayChart(index,Size size){

    if(chartComparison.circles[index].circleDay == chartComparison.largestCircleDay){
      return size.height - marginTopCircleDay;
    }else{
      return ((size.height - marginTopCircleDay)*chartComparison.circles[index].circleDay) / chartComparison.largestCircleDay;
    }
  }

  _setHeightPeriodDayChart(index,Size size){
    return ((size.height - marginTopCircleDay)*chartComparison.circles[index].periodDay) / chartComparison.largestCircleDay;
  }

  _setDottedCircleDay(Size size){
    return ((size.height - margin) - (chartComparison.circleDayRegister * (size.height - marginTopCircleDay)) / chartComparison.largestCircleDay);
  }

  _setDottedPeriodDay(Size size){
    return ((size.height - margin) - (chartComparison.periodDayRegister * (size.height - marginTopCircleDay)) / chartComparison.largestCircleDay);
  }

  void _drawDashedLine(Canvas canvas, Size size, Paint paint,double startX,double y) {
    // Chage to your preferred size
    double dashWidth = ScreenUtil().setWidth(16);
    double dashSpace = ScreenUtil().setWidth(8);

    // Start to draw from left size.
    // Of course, you can change it to match your requirement.

    // Repeat drawing until we reach the right edge.
    // In our example, size.with = 300 (from the SizedBox)
    while (startX < size.width) {
      // Draw a small line.
      canvas.drawLine(Offset(startX, y), Offset(startX + dashWidth, y), paint);

      // Update the starting X
      startX += dashWidth + dashSpace;
    }
  }

  // void _drawDashedLine(Canvas canvas,Paint paint,double size,startX,startY) {
  //   // Chage to your preferred size
  //   double dashWidth = ScreenUtil().setWidth(16);
  //   double dashSpace = ScreenUtil().setWidth(8);
  //
  //   // Start to draw from left size.
  //   // Of course, you can change it to match your requirement.
  //   // double startX = 0;
  //   // double y = 10;
  //
  //   // Repeat drawing until we reach the right edge.
  //   // In our example, size.with = 300 (from the SizedBox)
  //   while (startY < size) {
  //     // Draw a small line.
  //     canvas.drawLine(Offset(startX, startY), Offset(startX,startY + dashWidth), paint);
  //
  //     // Update the starting X
  //     startY += dashWidth + dashSpace;
  //   }
  // }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

}
