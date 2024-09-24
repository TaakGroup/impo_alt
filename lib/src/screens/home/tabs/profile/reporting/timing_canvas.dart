// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:impo/src/models/reporting/chart_timing_model.dart';
// import 'package:impo/src/components/colors.dart';
//
// class TimingCanvas extends CustomPainter{
//
//   final ChartTimingModel? chartTimingModel;
//
//   TimingCanvas({@required this.chartTimingModel});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final circleDayPaint = Paint()
//       ..color = ColorPallet().mainColor;
//
//     final dottedLinePaintCircleDay = Paint()
//       .. strokeWidth = ScreenUtil().setWidth(4)
//       ..color = ColorPallet().mainColor;
//
//     final dottedLinePaintPeriodDay = Paint()
//       .. strokeWidth = ScreenUtil().setWidth(4)
//       ..color = Color(0xffFFA3E0);
//
//     final periodDayPaint = Paint()
//       ..color = Color(0xffFFA3E0);
//
//     final lineMonthPaint = Paint()
//       ..color = Color(0xff707070).withOpacity(0.4);
//
//     final boxNameMonthPaint = Paint()
//     ..color = Color(0xffEBEBEB);
//
//     TextStyle whiteTextStyle = new TextStyle(
//         color: Colors.white,
//         fontSize: ScreenUtil().setSp(32),
//         fontFamily: 'IRANYekan',
//         fontWeight: FontWeight.bold
//     );
//
//     TextStyle dayMonthStartCircleStyle  = new TextStyle(
//         color: ColorPallet().mainColor,
//         fontSize: ScreenUtil().setSp(32),
//         fontFamily: 'IRANYekan',
//         fontWeight: FontWeight.bold
//     );
//
//     TextStyle dayMonthEndPeriodStyle = new TextStyle(
//         color:Color(0xffFFA3E0),
//         fontSize: ScreenUtil().setSp(32),
//         fontFamily: 'IRANYekan',
//         fontWeight: FontWeight.bold
//     );
//
//     TextStyle nameMonthStyle = new TextStyle(
//         color:Color(0xff707070),
//         fontSize: ScreenUtil().setSp(30),
//         fontFamily: 'IRANYekan',
//     );
//
//
//     double pToday = ScreenUtil().setWidth(15);
//     double heightDottedLine = ScreenUtil().setWidth(100);
//     double marginDayTextBottomDottedLine = heightDottedLine + ScreenUtil().setWidth(14);
//
//     //CircleDay
//     double marginTopCircleDay = ScreenUtil().setWidth(60);
//     double marginLeftCircleDay = ScreenUtil().setWidth(30);
//     double xCircleDayStart = marginLeftCircleDay;
//     double xCircleDayEnd = 0;
//     double lengthCircleDay = 0;
//
//
//     //PeriodDay
//     double marginTopPeriodDay = marginTopCircleDay - ScreenUtil().setWidth(8);
//     double marginLeftPeriodDay = marginLeftCircleDay + ScreenUtil().setWidth(10);
//     double xPeriodDayStart = marginLeftPeriodDay;
//     double xPeriodDayEnd = 0;
//     double lengthPeriodDay = 0;
//
//     double marginTopMonthLine = marginTopCircleDay - ScreenUtil().setWidth(180);
//     double heightMonthLine = marginTopCircleDay + ScreenUtil().setWidth(170);
//     double heightBoxMonthName = heightMonthLine - ScreenUtil().setWidth(40);
//
//     for(int i=0 ; i<chartTimingModel!.circles.length ; i++){
//       lengthCircleDay = chartTimingModel!.circles[i].circleDay!*(pToday);
//       xCircleDayEnd = lengthCircleDay + xCircleDayStart;
//       TextSpan circleDayText = new TextSpan(
//           style: whiteTextStyle,
//           text: chartTimingModel!.circles[i].circleDay.toString()
//       );
//       TextPainter tpCircleDay = new TextPainter(text: circleDayText,textAlign: TextAlign.right, textDirection: TextDirection.rtl);
//       tpCircleDay.layout();
//
//       lengthPeriodDay = chartTimingModel!.circles[i].periodDay!*(pToday);
//       xPeriodDayEnd = lengthPeriodDay + xPeriodDayStart;
//       TextSpan periodDayText = new TextSpan(
//           style: whiteTextStyle,
//          text: chartTimingModel!.circles[i].periodDay.toString()
//       );
//       TextPainter tpPeriodDay = new TextPainter(text: periodDayText,textAlign: TextAlign.left, textDirection: TextDirection.ltr);
//       tpPeriodDay.layout();
//
//       for(int j=0 ; j< chartTimingModel!.circles[i].daysStartMonths!.length ; j++){
//         TextSpan nameMonthText = new TextSpan(
//             style: nameMonthStyle,
//             text: chartTimingModel!.circles[i].monthsChartTiming![j]
//         );
//         TextPainter tpNameMonth = new TextPainter(text: nameMonthText,textAlign: TextAlign.center, textDirection: TextDirection.ltr);
//         tpNameMonth.layout();
//         double lineMonth = xCircleDayStart+(pToday*chartTimingModel!.circles[i].daysStartMonths![j]);
//         double startBoxNameMonth = lineMonth + ScreenUtil().setWidth(6);
//         double endBoxNameMonth = lineMonth + ScreenUtil().setWidth(160);
//         var p1 = Offset(lineMonth,marginTopMonthLine);
//         var p2 = Offset(lineMonth,heightMonthLine);
//         canvas.drawLine(p1, p2, lineMonthPaint);
//         canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(startBoxNameMonth,heightMonthLine,endBoxNameMonth,heightBoxMonthName),Radius.circular(20)),boxNameMonthPaint);
//         var p1MonthName = (startBoxNameMonth+(endBoxNameMonth-startBoxNameMonth)/2)-tpNameMonth.width/2;
//         var p2MonthName = (heightMonthLine +(heightBoxMonthName-heightMonthLine)/2)-tpNameMonth.height/2;
//         tpNameMonth.paint(canvas,Offset(p1MonthName,p2MonthName));
//
//       }
//
//       canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(xCircleDayStart,marginTopCircleDay, xCircleDayEnd,0), Radius.circular(20)),circleDayPaint);
//       canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(xPeriodDayStart,marginTopPeriodDay, xPeriodDayEnd,marginTopCircleDay-marginTopPeriodDay), Radius.circular(20)),periodDayPaint);
//
//       tpCircleDay.paint(canvas, Offset(xCircleDayEnd - (tpCircleDay.width * ScreenUtil().setWidth(3.2)),marginTopCircleDay/ScreenUtil().setWidth(9.5)));
//       tpPeriodDay.paint(canvas, Offset(xPeriodDayStart + tpPeriodDay.width/2 ,marginTopCircleDay/ScreenUtil().setWidth(9.5)));
//
//       _drawDashedLine(canvas,dottedLinePaintCircleDay,heightDottedLine,xCircleDayStart,marginTopPeriodDay - ScreenUtil().setWidth(10));
//       _drawDashedLine(canvas, dottedLinePaintPeriodDay,heightDottedLine,xPeriodDayEnd,marginTopPeriodDay -ScreenUtil().setWidth(10));
//
//       TextSpan dayMonthStartCircleDayText = new TextSpan(
//           style: dayMonthStartCircleStyle,
//           text: chartTimingModel!.circles[i].dayStartCircle
//       );
//       TextPainter tpDayMonthStartCircleDay = new TextPainter(text: dayMonthStartCircleDayText,textAlign: TextAlign.center, textDirection: TextDirection.rtl);
//       tpDayMonthStartCircleDay.layout();
//
//
//       TextSpan dayMonthEndPeriodDayText = new TextSpan(
//           style: dayMonthEndPeriodStyle,
//           text: chartTimingModel!.circles[i].dayEdnPeriod
//       );
//       TextPainter tpDayMonthEndPeriodDay = new TextPainter(text: dayMonthEndPeriodDayText,textAlign: TextAlign.center, textDirection: TextDirection.rtl);
//       tpDayMonthEndPeriodDay.layout();
//
//       tpDayMonthStartCircleDay.paint(canvas, Offset(xCircleDayStart-tpDayMonthStartCircleDay.width/2,marginDayTextBottomDottedLine));
//       tpDayMonthEndPeriodDay.paint(canvas,Offset(xPeriodDayEnd-tpDayMonthEndPeriodDay.width/2,marginDayTextBottomDottedLine));
//
//       xCircleDayStart = lengthCircleDay + xCircleDayStart + marginLeftCircleDay;
//       xPeriodDayStart = xCircleDayStart - marginLeftCircleDay + marginLeftPeriodDay;
//
//     }
//   }
//
//   void _drawDashedLine(Canvas canvas,Paint paint,double size,startX,startY) {
//     // Chage to your preferred size
//      double dashWidth = ScreenUtil().setWidth(16);
//      double dashSpace = ScreenUtil().setWidth(8);
//
//     // Start to draw from left size.
//     // Of course, you can change it to match your requirement.
//     // double startX = 0;
//     // double y = 10;
//
//     // Repeat drawing until we reach the right edge.
//     // In our example, size.with = 300 (from the SizedBox)
//     while (startY < size) {
//       // Draw a small line.
//       canvas.drawLine(Offset(startX, startY), Offset(startX,startY + dashWidth), paint);
//
//       // Update the starting X
//       startY += dashWidth + dashSpace;
//     }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
//
// }
