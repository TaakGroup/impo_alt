//
//
// import 'dart:ui' as UI;
//
// import 'package:angles/angles.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'dart:math' as math;
//
// import 'package:impo/src/components/colors.dart';
// import 'package:shamsi_date/shamsi_date.dart';
//
//
// class CircleItem extends CustomPainter{
//
//   final BuildContext context;
//   final width;
//   final height;
//   final Angle periodStart;
//   final Angle periodEnd;
//   final Angle fertStart;
//   final Angle fertEnd;
//   final Angle pmsStart;
//   final Angle pmsEnd;
//   final Angle current;
//   final Angle ovum;
//   final int maxDays;
//   final periodDay;
//   final modeDays;
//   final Angle ovumDayEnd;
//   final currentToday;
//   final dayMode;
//
//   CircleItem({this.context,this.width,this.height,this.pmsStart,this.periodEnd,this.fertEnd,this.fertStart,this.periodStart,this.pmsEnd,this.current,this.ovum,this.maxDays,this.periodDay,this.modeDays,this.ovumDayEnd,this.currentToday,this.dayMode});
//
//   double widthOfArc = ScreenUtil().setWidth(60);
//
//   double currentX = 0;
//   double currentY = 0;
//
//   double periodX = 0;
//   double periodY = 0;
//   double boxPeriodX = 0;
//   double boxPeriodY = 0;
//
//   double pmsX = 0;
//   double pmsY = 0;
//   double boxPmsX = 0;
//   double boxPmsY = 0;
//
//   double radius;
//
//   double ovumX = 0;
//   double ovumY = 0;
//   double boxOvumX = 0;
//   double boxOvumY= 0;
//
//
//   @override
//   void paint(Canvas canvas, Size size) {
//
// //    var myCanvas = TouchyCanvas(context,canvas);
//
//
//     generateNumber();
//
//     final mainPaint = Paint();
//
//     mainPaint.color = Colors.grey.withOpacity(.5);
//     mainPaint.strokeWidth = widthOfArc;
//     mainPaint.style = PaintingStyle.stroke;
//     mainPaint.strokeCap = StrokeCap.round;
//
//     final periodPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = ScreenUtil().setWidth(50)
//       ..strokeCap = StrokeCap.round
//       ..color = ColorPallet().periodDeep;
//
//     final boxPeriodPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2
//       ..strokeCap = StrokeCap.round
//       ..color = ColorPallet().periodDeep;
//
//
//     final withePaint =  Paint()
//       .. color = Colors.white
//       .. strokeCap = StrokeCap.round;
//
//     final pmsPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = ScreenUtil().setWidth(50)
//       ..strokeCap = StrokeCap.round
//       ..color = ColorPallet().pmsDeep;
//
//     final boxPmsPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2
//       ..strokeCap = StrokeCap.round
//       ..color = ColorPallet().pmsDeep;
//
//     final fertPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = ScreenUtil().setWidth(50)
//       ..strokeCap = StrokeCap.round
//       ..color = ColorPallet().fertDeep;
//
//     final currentPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = 13
//       ..color = Colors.grey[800]
//     ;
//
//     final ovumPaint = Paint()
//       ..style = PaintingStyle.fill
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = ScreenUtil().setWidth(50)
//       ..color = ColorPallet().ovum
//     ;
//
//     final boxOvumPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = 2
//       ..color = ColorPallet().ovum
//     ;
//
//     final periodCircle = Paint()
//       .. style = PaintingStyle.fill
//       .. color = ColorPallet().periodLight;
//
//     final outCirclePaint = Paint()
//       .. style = PaintingStyle.fill
//       .. color = Color(0xffEA079D).withOpacity(.03);
//
//     final inCirclePaint = Paint()
//       .. style = PaintingStyle.fill
//       .. color = modeDays == 0 ? Color(0xffEA079D).withOpacity(.12) : modeDays == 1 ? Color(0xff26dce2).withOpacity(.12) : modeDays == 2 ? Color(0xff8f49eb).withOpacity(.12) : Color(0xff1CC1F5).withOpacity(.12)
//     ;
//
//     final Gradient gradient = new LinearGradient(
//       colors: <Color>[
//         Color(0xffC33091),
//         Color(0xffFFA3E0)
//       ],
//     );
//
//     final gradientCircle = Paint()
//       .. style = PaintingStyle.fill
//       ..shader = gradient.createShader(Rect.fromCircle(center: Offset(0,0),radius: radius));
//
//
//
//
// //    myCanvas.drawCircle(Offset(0,0), radius, periodPaint,
// //      onTapDown: (t){
// //      print('cdsvdfvdf');
// //      }
// //    );
//
// //    final circlePaint = Paint()
// //    ..style = PaintingStyle.stroke
// //    ..strokeWidth = 3
// //    .. color = Colors.red;
//
//
//
//
// //  canvas.drawRRect(RRect.fromLTRBR(100, 100, 0, 0, Radius.circular(60)),
// //      paint);
// //
// //  canvas.drawRect(Rect.fromLTRB(100, 100, 0, 0), paint);
//
//
// //    canvas.drawArc(
// //        Rect.fromCircle(
// //          center: Offset(size.width/2,size.height/2),
// //          radius: radius,
// //        ),
// //        5.07,5.5 ,false , paint);
// //
// //
// //
// //    canvas.drawArc(
// //        Rect.fromCircle(
// //          center: Offset(size.width/2,size.height/2),
// //          radius: radius,
// //        ),
// //        5.07,.5 ,false , redPaint);
// //
// //    canvas.drawArc(
// //        Rect.fromCircle(
// //          center: Offset(size.width/2,size.height/2),
// //          radius: radius,
// //        ),
// //        3,1 ,false , bluePaint);
//
//
//
//     canvas.drawArc(
//         Rect.fromCircle(
//             center: Offset(0,0),
//             radius: radius
//         ),
//         -1.13446,5.41052,false,mainPaint
//     );
//
//
//
//     ///////////// /////////////////////
//
//
//
//
// //    canvas.drawCircle(Offset(0,0), radius  + 10, outCirclePaint);
// //    canvas.drawCircle(Offset(0,0), radius , inCirclePaint);
// //    canvas.drawCircle(Offset(0,0), radius - 15, gradientCircle);
//
//
//
//
//
//
//     //////////////////////////////////////
//
//
//
//
//
//
//     ///////////////////////////////////
//
//
//
//
//
//     canvas.drawArc(
//         Rect.fromCircle(
//             center: Offset(0,0),
//             radius: radius
//         ),  pmsStart.radians,pmsEnd.radians,false,pmsPaint
//     );
//
// //    Path pathPms = Path()
// //      ..addOval(Rect.fromCircle(center: Offset(pmsX - 1,pmsY - 3),radius:11));
// //
// //    canvas.drawShadow(pathPms, ColorPallet().pmsDeep, 2.0, true);
// //
// //    canvas.drawCircle(Offset(pmsX,pmsY), 8, withePaint);
// //
// //    canvas.drawCircle(Offset(pmsX,pmsY), 8, pmsPaint);
//
// //
// //    canvas.drawRRect(RRect.fromRectAndCorners(
// //      Rect.fromCircle(center: Offset(boxPmsX,boxPmsY),radius: 13),
// //      bottomLeft: Radius.circular(7),
// //      topRight: Radius.circular(7),
// //      topLeft: Radius.circular(7),
// //      bottomRight: Radius.circular(7)
// //    ), boxPmsPaint);
// //
// //    TextSpan pmsText = new TextSpan(
// //        style: new TextStyle(
// //            color: Colors.white,
// //            fontSize:  18,
// //            fontFamily: 'IRANYekan',
// //            fontWeight: FontWeight.bold
// //        ), text: maxDays.toString());
// //    TextPainter tpPms = new TextPainter(text: pmsText, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
// //    tpPms.layout();
// //    boxPmsX = (radius-tpPms.width/2) * math.cos(4.36332);
// //    boxPmsY = (radius+tpPms.height/2) * math.sin(4.36332);
// //    tpPms.paint(canvas, new Offset(boxPmsX -13,boxPmsY));
//
//
//
//     ///////////////////////////////
//
//
//
//     canvas.drawArc(
//         Rect.fromCircle(
//             center: Offset(0,0),
//             radius: radius
//         ),  fertStart.radians,fertEnd.radians,false,fertPaint
//     );
//
//
//     ///////////////////////////////
//
// //    canvas.drawArc(
// //        Rect.fromCircle(
// //            center: Offset(0,0),
// //            radius: radius
// //        ),
// //        ovum.radians,0.001,false,ovumPaint
// //    );
//
// //    Path ovumPms = Path()
// //      ..addOval(Rect.fromCircle(center: Offset(ovumX - 1,ovumY - 3),radius:20));
//
// //    canvas.drawShadow(ovumPms, ColorPallet().ovum, 2.0, true);
//
// //    canvas.drawCircle(Offset(ovumX,ovumY), 8, withePaint);
//
//
//
// //    if(ovum.degrees <= 0){
// //
// //      boxOvumX =   (radius + 35) * math.cos(ovum.radians);
// //      boxOvumY = (radius + 35) * math.sin(ovum.radians);
// //
// //    }else if(ovum.degrees > 0 && ovum.degrees <= 90){
// //
// //      if(ovum.degrees == 90){
// //
// //        boxOvumX = (radius + 40) * math.cos(ovum.radians);
// //        boxOvumY = 185;
// //
// //      }else{
// //
// //        if(ovum.degrees >= 45){
// //
// //          boxOvumX = (radius + 30) * math.cos(ovum.radians);
// //          boxOvumY = (radius + 32) * math.sin(ovum.radians);
// //
// //        }else if(ovum.degrees >= 20){
// //
// //          boxOvumX = (radius + 35) * math.cos(ovum.radians);
// //          boxOvumY = (radius + 20) * math.sin(ovum.radians);
// //
// //        }else{
// //
// //          boxOvumX = (radius + 30) * math.cos(ovum.radians);
// //          boxOvumY = (radius + 20) * math.sin(ovum.radians);
// //
// //        }
// //
// //      }
// //
// //    }else if(ovum.degrees > 90 && ovum.degrees <= 180){
// //
// //
// //      if(ovum.degrees >= 160){
// //
// //        boxOvumX = (radius + 30) * math.cos(ovum.radians);
// //        boxOvumY = (radius + 80) * math.sin(ovum.radians);
// //
// //      }else{
// //        boxOvumX = (radius + 35) * math.cos(ovum.radians);
// //        boxOvumY = (radius + 30) * math.sin(ovum.radians);
// //      }
// //
// //    }else if(ovum.degrees > 180 && ovum.degrees <= 270){
// //
// //      if(ovum.degrees <= 210){
// //
// //        boxOvumX = (radius + 30) * math.cos(ovum.radians);
// //        boxOvumY = (radius + 50) * math.sin(ovum.radians);
// //
// //      }else{
// //
// //        boxOvumX = (radius + 35) * math.cos(ovum.radians);
// //        boxOvumY = (radius + 35) * math.sin(ovum.radians);
// //
// //      }
// //
// //    }
// //
// //    canvas.drawRRect(RRect.fromRectAndCorners(
// //        Rect.fromCircle(center: Offset(boxOvumX,boxOvumY),radius: 13),
// //        bottomRight: Radius.circular(7),
// //        bottomLeft: Radius.circular(7),
// //        topLeft: Radius.circular(7),
// //        topRight: Radius.circular(7),
// ////      bottomLeft: ovum.degrees <= 0 ? Radius.circular(0) : Radius.circular(10),
// ////      topLeft: ovum.degrees > 0 && ovum.degrees <= 90 ? Radius.circular(0) : Radius.circular(10),
// ////      topRight: ovum.degrees > 90 && ovum.degrees <= 180 ? Radius.circular(0) : Radius.circular(10),
// ////      bottomRight:  ovum.degrees > 180.0 && ovum.degrees <= 270.0 ? Radius.circular(0) : Radius.circular(10),
// //    ), boxOvumPaint);
//
//
//
//
//
// //    TextSpan ovumText = new TextSpan(
// //        style: new TextStyle(
// //            color: Colors.white,
// //            fontSize:  ScreenUtil().setSp(30),
// //            fontFamily: 'IRANYekan',
// ////            fontWeight: FontWeight.bold
// //        ), text: (maxDays - 13).toString());
// //    TextPainter tpOvum = new TextPainter(text: ovumText, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
// //    tpOvum.layout();
//     boxOvumX =   (radius ) * math.cos(ovum.radians);
//     boxOvumY = (radius ) * math.sin(ovum.radians);
//
//
//     canvas.drawCircle(Offset(boxOvumX,boxOvumY), ScreenUtil().setWidth(30), ovumPaint);
//
// //    canvas.drawArc(
// //        Rect.fromCircle(
// //            center: Offset(0,0),
// //            radius: radius
// //        ),  ovum.radians,ovumDayEnd.radians,false,ovumPaint
// //    );
//
//
// //    tpOvum.paint(canvas, new Offset(boxOvumX-7,boxOvumY -7));
//
//
//
//     /////////////////////////////////////
//
//
//
//     TextSpan currentText = new TextSpan(
//         style: new TextStyle(
//           color: Colors.white,
//           fontSize:  ScreenUtil().setSp(30),
//           fontFamily: 'IRANYekan',
// //            fontWeight: FontWeight.bold
//         ), text:currentToday.toString());
//     TextPainter tpCurrent = new TextPainter(text: currentText, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
//     tpCurrent.layout();
//
//     currentX =   (radius - tpCurrent.width/2 ) * math.cos(current.radians);
//     currentY = (radius + tpCurrent.height/2 ) * math.sin(current.radians);
//
//
// //    Path pathCurrent = Path()
// //      ..addOval(Rect.fromCircle(center: Offset(currentX - 1,currentY - 3),radius:9));
//
// //    if(dayMode != 0 && currentToday != maxDays && currentToday != maxDays - 13){
// //      tpCurrent.paint(canvas, new Offset(currentX,currentY));
// //    }
//
// //    canvas.drawShadow(pathCurrent, Colors.black, 2.0, true);
// //
// //    canvas.drawArc(
// //      Rect.fromCircle(
// //        center: Offset(0,0),
// //        radius: radius
// //      ),
// //      current.radians,0.001,false,currentPaint
// //    );
//
//
//     ////////////////////////////////
//
//
//     canvas.drawArc(
//       Rect.fromCircle(
//           center: Offset(0,0),
//           radius: radius
//       ),
//       periodStart.radians,periodEnd.radians,false,periodPaint,
//     );
//
// //    Path pathPeriod = Path()
// //      ..addOval(Rect.fromCircle(center: Offset(periodX - 1,periodY - 3),radius:11));
//
// //    canvas.drawShadow(pathPeriod, ColorPallet().periodDeep, 2.0, true);
//
// //    canvas.drawCircle(Offset(periodX,periodY), 8, withePaint);
//
// //    canvas.drawCircle(Offset(periodX,periodY), 8, periodPaint);
//
//     for(int i=0 ; i < maxDays ; i++ ){
//
//       Angle angle = Angle.fromDegrees(periodStart.degrees + ((i)*(310.0/(maxDays-1))));
//
//
//       //      String tmp = String.valueOf(number+1);
// //      paint.getTextBounds(tmp, 0, tmp.length(), rect);
// //      double angle = START_ANGLE + (number *AngleOneDay);
// //      int x = (int) (width / 2 + Math.cos(Math.toRadians(angle - 90)) * radius - rect.width() / 2);
// //      int y = (int) (height / 2 + Math.sin(Math.toRadians(angle - 90)) * radius + rect.height() / 2);
//
//
//
//       TextSpan periodText = new TextSpan(
//           style: new TextStyle(
//               color: Colors.white,
//               fontSize: ScreenUtil().setSp(32),
//               fontFamily: 'IRANYekan',
//               fontWeight: FontWeight.bold
//           ), text: '${i+1}');
//       TextPainter tpPeriod = new TextPainter(text: periodText, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
//
//
//       tpPeriod.layout();
//
//       double x;
//       double y;
// //      if(angle.degrees < 65){
// //
// //         x = (radius - tpPeriod.width/2) * math.cos(angle.radians);
// //         y = (radius + tpPeriod.height/2) * math.sin(angle.radians);
// //
// //    }else{
// //
// //         x = (radius + tpPeriod.height/2) * math.cos(angle.radians);
// //         y = (radius - tpPeriod.width/2) * math.sin(angle.radians);
// //
// //      }
//
// //      print('${tpPeriod.text} ${tpPeriod.width} ${tpPeriod.height}');
//
//       x = math.cos(angle.radians) * radius - tpPeriod.width/2;
//       y = math.sin(angle.radians) * radius + tpPeriod.height/2;
// //      y = (radius + (tpPeriod.height/2)) * math.sin(angle.radians);
//
//
//
//       if(i+1 <= periodDay || i+1 == maxDays-13 || i+1 == maxDays || i+1 == currentToday){
//         tpPeriod.paint(canvas, new Offset(x,y-ScreenUtil().setWidth(30)));
//       }
//
//
// //      canvas.drawCircle(Offset(x ,y ), 3, periodCircle);
//
//     }
//
//     if(periodEnd.degrees >= 0 && periodEnd.degrees < 25){
//
//       boxPeriodX = (radius + 35) * math.cos(periodEnd.radians - 1.22173);
//       boxPeriodY = (radius + 32) * math.sin(periodEnd.radians - 1.22173);
//
//     }else if(periodEnd.degrees >= 25 && periodEnd.degrees < 70){
//
//       boxPeriodX = (radius + 32) * math.cos(periodEnd.radians - 1.22173);
//       boxPeriodY = (radius + 32) * math.sin(periodEnd.radians - 1.22173);
//
//     }else if(periodEnd.degrees >= 70 && periodEnd.degrees < 115){
//
//       boxPeriodX = (radius + 30) * math.cos(periodEnd.radians - 1.22173);
//       boxPeriodY = (radius + 32) * math.sin(periodEnd.radians - 1.22173);
//
//     }else {
//
//       boxPeriodX = (radius + 25) * math.cos(periodEnd.radians - 1.22173);
//       boxPeriodY = (radius + 35) * math.sin(periodEnd.radians - 1.22173);
//
//
//     }
//
//
//     Jalali  now = Jalali.now();
//
//     String format1(Date d) {
//       final f = d.formatter;
//
//       return '${f.d} ${f.mN}';
//     }
//
//
// //    TextSpan dateText = new TextSpan(
// //        style: new TextStyle(
// //            color: Colors.grey[600],
// //            fontSize: ScreenUtil().setSp(32),
// //            fontFamily: 'IRANYekan',
// //            fontWeight: FontWeight.bold
// //        ), text: format1(now));
// //    TextPainter tpDate = new TextPainter(text: dateText, textAlign: TextAlign.center, textDirection: TextDirection.rtl);
// //
// //    tpDate.layout();
// //
// //
// //    tpDate.paint(canvas, new Offset(0-(tpDate.width/2),-130));
//
//
//
// //    Paint paint = Paint()
// //      ..color = Colors.black
// //      .. style = PaintingStyle.fill
// //      ..strokeWidth =1;
// //
// //    canvas.drawPath(getTrianglePath(100, 100), paint);
//
// //    canvas.drawRRect(RRect.fromRectAndCorners(
// //      Rect.fromCircle(center: Offset(boxPeriodX,boxPeriodY),radius: 13),
// //       bottomLeft: Radius.circular(7),
// ////      bottomLeft: periodEnd.degrees <= 65.0 ? Radius.circular(0) : Radius.circular(10),
// //      topRight: Radius.circular(7),
// //      bottomRight: Radius.circular(7),
// //      topLeft: Radius.circular(7)
// ////      topLeft: periodEnd.degrees <= 65.0 ? Radius.circular(10) : Radius.circular(0),
// //    ), boxPeriodPaint);
// //
// //    TextSpan periodText = new TextSpan(
// //        style: new TextStyle(
// //            color: ColorPallet().periodDeep,
// //            fontSize: ScreenUtil().setSp(34),
// //            fontFamily: 'IRANYekan',
// //            fontWeight: FontWeight.bold
// //        ), text: periodDay.toString());
// //    TextPainter tpPeriod = new TextPainter(text: periodText, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
// //    tpPeriod.layout();
// //    tpPeriod.paint(canvas, new Offset(boxPeriodX - 5,boxPeriodY - 7));
//
//
//
//
//     /////////////////////////////
//
//
//
//   }
//
//   Path getTrianglePath(double x, double y) {
//     return Path()
//       ..moveTo(0, y)
//       ..lineTo(x / 2, 0)
//       ..lineTo(x, y)
//       ..lineTo(0, y);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
//
//
//   generateNumber(){
//
//     radius = ((width - widthOfArc) / 2) - ScreenUtil().setWidth(50);
//     currentX = radius * math.cos(current.radians);
//     currentY = radius * math.sin(current.radians);
//
//     periodX = radius * math.cos(periodEnd.radians - 1.22173);
//     periodY = radius * math.sin(periodEnd.radians - 1.22173);
//
//
//     pmsX = radius * math.cos(4.36332);
//     pmsY = radius * math.sin(4.36332);
//
//     ovumX = radius * math.cos(ovum.radians);
//     ovumY = radius * math.sin(ovum.radians);
//
//
//   }
//
// }
//
//
//
//
// //
// //
// //public class NumberView extends View {
// //
// //
// //  private static final float START_ANGLE = 24.287681f;
// //  private static final float END_ANGLE = 360f - START_ANGLE;
// //
// //  Paint paint = new Paint();
// //
// //  public NumberView(Context context) {
// //    super(context);
// //    init();
// //  }
// //
// //  public NumberView(Context context, AttributeSet attrs) {
// //    super(context, attrs);
// //    init();
// //  }
// //
// //  public NumberView(Context context, AttributeSet attrs, int defStyle) {
// //    super(context, attrs, defStyle);
// //    init();
// //  }
// //
// //  private void init(){
// //    paint = new Paint();
// //
// //  }
// //
// //  @Override
// //  protected void onDraw(Canvas canvas) {
// //    super.onDraw(canvas);
// //
// //    float width = getWidth();
// //    float height = getHeight();
// //
// //    float radius;
// //
// //
// //    radius = height / 2f - padding;
// //
// //    paint.setTextSize(getResources().getDimension(R.dimen._11sdp));
// //    paint.setTypeface(Setting.IranSensTypeBold(getContext()));
// //    paint.setColor(color);
// //    Rect rect = new Rect();
// //
// //    for (int number = 0; number < maxDays;number++) {
// //      String tmp = String.valueOf(number+1);
// //      paint.getTextBounds(tmp, 0, tmp.length(), rect);
// //      double angle = START_ANGLE + (number *AngleOneDay);
// //      int x = (int) (width / 2 + Math.cos(Math.toRadians(angle - 90)) * radius - rect.width() / 2);
// //      int y = (int) (height / 2 + Math.sin(Math.toRadians(angle - 90)) * radius + rect.height() / 2);
// //
// //      if (lastPeriod >= (number+1) || ovumDay == (number+1) || maxDays == (number+1) || currentDay == (number+1))
// //        canvas.drawText(tmp, x, y, paint);
// //    }
// //
// //
// //  }
// //
// //  int maxDays = 31;
// //  double AngleOneDay;
// //  public void setMaxDays(int days)
// //  {
// //    maxDays = days;
// //    AngleOneDay = (END_ANGLE - START_ANGLE) / (days-1);
// //  }
// //
// //  int color = Color.WHITE;
// //  public void setColor(int color)
// //  {
// //    this.color = color;
// //  }
// //
// //  int padding = 0;
// //  public void setPadding(float padding)
// //  {
// //    this.padding = (int)padding;
// //  }
// //
// //  private int lastPeriod;
// //  public void setLastPeriod(int lastPeriod) {
// //    this.lastPeriod = lastPeriod;
// //  }
// //
// //  private int ovumDay;
// //  public void setOvumDay(int ovumDay) {
// //    this.ovumDay = ovumDay;
// //  }
// //
// //  private int currentDay;
// //  public void setCurrentDay(int currentDay) {
// //    this.currentDay = currentDay;
// //  }
// //
// //  @Override
// //  protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
// //    super.onMeasure(widthMeasureSpec - (int)getResources().getDimension(R.dimen._10sdp) , heightMeasureSpec - (int) getResources().getDimension(R.dimen._10sdp));
// //    }
// //
// //
// //
// //}
//
//
// //import 'dart:ui' as UI;
// //
// //import 'package:angles/angles.dart';
// //import 'package:flutter/cupertino.dart';
// //import 'package:flutter/material.dart';
// //import 'package:flutter_screenutil/flutter_screenutil.dart';
// //import 'dart:math' as math;
// //
// //import 'package:impo/src/components/colors.dart';
// //import 'package:touchable/touchable.dart';
// //
// //
// //class CircleItem extends CustomPainter{
// //
// //  final BuildContext context;
// //  final width;
// //  final height;
// //  final Angle periodStart;
// //  final Angle periodEnd;
// //  final Angle fertStart;
// //  final Angle fertEnd;
// //  final Angle pmsStart;
// //  final Angle pmsEnd;
// //  final Angle current;
// //  final Angle ovum;
// //  final int maxDays;
// //  final periodDay;
// //  final modeDays;
// //
// //  CircleItem({this.context,this.width,this.height,this.pmsStart,this.periodEnd,this.fertEnd,this.fertStart,this.periodStart,this.pmsEnd,this.current,this.ovum,this.maxDays,this.periodDay,this.modeDays});
// //
// //  double widthOfArc = 2;
// //
// //  double currentX = 0;
// //  double currentY = 0;
// //
// //  double periodX = 0;
// //  double periodY = 0;
// //  double boxPeriodX = 0;
// //  double boxPeriodY = 0;
// //
// //  double pmsX = 0;
// //  double pmsY = 0;
// //  double boxPmsX = 0;
// //  double boxPmsY = 0;
// //
// //  double radius;
// //
// //  double ovumX = 0;
// //  double ovumY = 0;
// //  double boxOvumX = 0;
// //  double boxOvumY= 0;
// //
// //
// //  @override
// //  void paint(Canvas canvas, Size size) {
// //
// //    var myCanvas = TouchyCanvas(context,canvas);
// //
// //
// //    generateNumber();
// //
// //    final mainPaint = Paint();
// //
// //    mainPaint.color = Colors.grey.withOpacity(.4);
// //    mainPaint.strokeWidth = widthOfArc;
// //    mainPaint.style = PaintingStyle.stroke;
// //    mainPaint.strokeCap = StrokeCap.round;
// //
// //    final periodPaint = Paint()
// //      ..style = PaintingStyle.stroke
// //      ..strokeWidth = 3
// //      ..strokeCap = StrokeCap.round
// //      ..color = ColorPallet().periodLight;
// //
// //    final boxPeriodPaint = Paint()
// //      ..style = PaintingStyle.stroke
// //      ..strokeWidth = 2
// //      ..strokeCap = StrokeCap.round
// //      ..color = ColorPallet().periodDeep;
// //
// //
// //    final withePaint =  Paint()
// //      .. color = Colors.white
// //      .. strokeCap = StrokeCap.round;
// //
// //    final pmsPaint = Paint()
// //      ..style = PaintingStyle.stroke
// //      ..strokeWidth = 3
// //      ..strokeCap = StrokeCap.round
// //      ..color = ColorPallet().pmsLight;
// //
// //    final boxPmsPaint = Paint()
// //      ..style = PaintingStyle.stroke
// //      ..strokeWidth = 2
// //      ..strokeCap = StrokeCap.round
// //      ..color = ColorPallet().pmsDeep;
// //
// //    final fertPaint = Paint()
// //      ..style = PaintingStyle.stroke
// //      ..strokeWidth = 3
// //      ..strokeCap = StrokeCap.round
// //      ..color = ColorPallet().fertLight;
// //
// //    final currentPaint = Paint()
// //      ..style = PaintingStyle.stroke
// //      ..strokeCap = StrokeCap.round
// //      ..strokeWidth = 13
// //      ..color = Colors.grey[800]
// //    ;
// //
// //    final ovumPaint = Paint()
// //      ..style = PaintingStyle.stroke
// //      ..strokeCap = StrokeCap.round
// //      ..strokeWidth = 3
// //      ..color = ColorPallet().ovum
// //    ;
// //
// //    final boxOvumPaint = Paint()
// //      ..style = PaintingStyle.stroke
// //      ..strokeCap = StrokeCap.round
// //      ..strokeWidth = 2
// //      ..color = ColorPallet().ovum
// //    ;
// //
// //    final periodCircle = Paint()
// //      .. style = PaintingStyle.fill
// //      .. color = ColorPallet().periodLight;
// //
// //    final outCirclePaint = Paint()
// //      .. style = PaintingStyle.fill
// //      .. color = Color(0xffEA079D).withOpacity(.03);
// //
// //    final inCirclePaint = Paint()
// //      .. style = PaintingStyle.fill
// //      .. color = modeDays == 0 ? Color(0xffEA079D).withOpacity(.12) : modeDays == 1 ? Color(0xff26dce2).withOpacity(.12) : modeDays == 2 ? Color(0xff8f49eb).withOpacity(.12) : Color(0xff1CC1F5).withOpacity(.12)
// //    ;
// //
// //    final Gradient gradient = new LinearGradient(
// //      colors: <Color>[
// //        Color(0xffC33091),
// //        Color(0xffFFA3E0)
// //      ],
// //    );
// //
// //    final gradientCircle = Paint()
// //      .. style = PaintingStyle.fill
// //      ..shader = gradient.createShader(Rect.fromCircle(center: Offset(0,0),radius: radius));
// //
// //
// //
// //
// ////    myCanvas.drawCircle(Offset(0,0), radius, periodPaint,
// ////      onTapDown: (t){
// ////      print('cdsvdfvdf');
// ////      }
// ////    );
// //
// ////    final circlePaint = Paint()
// ////    ..style = PaintingStyle.stroke
// ////    ..strokeWidth = 3
// ////    .. color = Colors.red;
// //
// //
// //
// //
// ////  canvas.drawRRect(RRect.fromLTRBR(100, 100, 0, 0, Radius.circular(60)),
// ////      paint);
// ////
// ////  canvas.drawRect(Rect.fromLTRB(100, 100, 0, 0), paint);
// //
// //
// ////    canvas.drawArc(
// ////        Rect.fromCircle(
// ////          center: Offset(size.width/2,size.height/2),
// ////          radius: radius,
// ////        ),
// ////        5.07,5.5 ,false , paint);
// ////
// ////
// ////
// ////    canvas.drawArc(
// ////        Rect.fromCircle(
// ////          center: Offset(size.width/2,size.height/2),
// ////          radius: radius,
// ////        ),
// ////        5.07,.5 ,false , redPaint);
// ////
// ////    canvas.drawArc(
// ////        Rect.fromCircle(
// ////          center: Offset(size.width/2,size.height/2),
// ////          radius: radius,
// ////        ),
// ////        3,1 ,false , bluePaint);
// //
// //
// //
// //    canvas.drawArc(
// //        Rect.fromCircle(
// //            center: Offset(0,0),
// //            radius: radius
// //        ),
// //        -1.22173,5.58505,false,mainPaint
// //    );
// //
// //
// //
// //    ///////////// /////////////////////
// //
// //
// //
// //
// //    canvas.drawCircle(Offset(0,0), radius  + 10, outCirclePaint);
// //    canvas.drawCircle(Offset(0,0), radius , inCirclePaint);
// ////    canvas.drawCircle(Offset(0,0), radius - 15, gradientCircle);
// //
// //
// //
// //
// //
// //
// //    //////////////////////////////////////
// //
// //
// //    myCanvas.drawArc(
// //        Rect.fromCircle(
// //            center: Offset(0,0),
// //            radius: radius
// //        ),
// //        periodStart.radians,periodEnd.radians,false,periodPaint,
// //        onTapDown: (t){
// //        },
// //        onPanDown: (t){
// //        },
// //        onPanUpdate: (v){
// //        }
// //    );
// //
// //    Path pathPeriod = Path()
// //      ..addOval(Rect.fromCircle(center: Offset(periodX - 1,periodY - 3),radius:11));
// //
// //    canvas.drawShadow(pathPeriod, ColorPallet().periodDeep, 2.0, true);
// //
// //    canvas.drawCircle(Offset(periodX,periodY), 8, withePaint);
// //
// //    canvas.drawCircle(Offset(periodX,periodY), 8, periodPaint);
// //
// //    for(int i=0 ; i < periodDay - 1 ; i++ ){
// //
// //      Angle angle = Angle.fromDegrees(periodStart.degrees + (i*(320.0/(maxDays-1))));
// //
// //      double x = (radius + 10) * math.cos(angle.radians);
// //      double y = (radius + 10) * math.sin(angle.radians);
// //
// //      canvas.drawCircle(Offset(x ,y ), 3, periodCircle);
// //
// //    }
// //
// //    if(periodEnd.degrees >= 0 && periodEnd.degrees < 25){
// //
// //      boxPeriodX = (radius + 35) * math.cos(periodEnd.radians - 1.22173);
// //      boxPeriodY = (radius + 32) * math.sin(periodEnd.radians - 1.22173);
// //
// //    }else if(periodEnd.degrees >= 25 && periodEnd.degrees < 70){
// //
// //      boxPeriodX = (radius + 32) * math.cos(periodEnd.radians - 1.22173);
// //      boxPeriodY = (radius + 32) * math.sin(periodEnd.radians - 1.22173);
// //
// //    }else if(periodEnd.degrees >= 70 && periodEnd.degrees < 115){
// //
// //      boxPeriodX = (radius + 30) * math.cos(periodEnd.radians - 1.22173);
// //      boxPeriodY = (radius + 32) * math.sin(periodEnd.radians - 1.22173);
// //
// //    }else {
// //
// //      boxPeriodX = (radius + 25) * math.cos(periodEnd.radians - 1.22173);
// //      boxPeriodY = (radius + 35) * math.sin(periodEnd.radians - 1.22173);
// //
// //
// //    }
// //
// //    canvas.drawRRect(RRect.fromRectAndCorners(
// //        Rect.fromCircle(center: Offset(boxPeriodX,boxPeriodY),radius: 13),
// //        bottomLeft: Radius.circular(7),
// ////      bottomLeft: periodEnd.degrees <= 65.0 ? Radius.circular(0) : Radius.circular(10),
// //        topRight: Radius.circular(7),
// //        bottomRight: Radius.circular(7),
// //        topLeft: Radius.circular(7)
// ////      topLeft: periodEnd.degrees <= 65.0 ? Radius.circular(10) : Radius.circular(0),
// //    ), boxPeriodPaint);
// //
// //    TextSpan periodText = new TextSpan(
// //        style: new TextStyle(
// //            color: ColorPallet().periodDeep,
// //            fontSize: ScreenUtil().setSp(34),
// //            fontFamily: 'IRANYekan',
// //            fontWeight: FontWeight.bold
// //        ), text: periodDay.toString());
// //    TextPainter tpPeriod = new TextPainter(text: periodText, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
// //    tpPeriod.layout();
// //    tpPeriod.paint(canvas, new Offset(boxPeriodX - 5,boxPeriodY - 7));
// //
// //
// //
// //    ///////////////////////////////////
// //
// //
// //
// //
// //
// //    canvas.drawArc(
// //        Rect.fromCircle(
// //            center: Offset(0,0),
// //            radius: radius
// //        ),  pmsStart.radians,pmsEnd.radians,false,pmsPaint
// //    );
// //
// //    Path pathPms = Path()
// //      ..addOval(Rect.fromCircle(center: Offset(pmsX - 1,pmsY - 3),radius:11));
// //
// //    canvas.drawShadow(pathPms, ColorPallet().pmsDeep, 2.0, true);
// //
// //    canvas.drawCircle(Offset(pmsX,pmsY), 8, withePaint);
// //
// //    canvas.drawCircle(Offset(pmsX,pmsY), 8, pmsPaint);
// //
// //    boxPmsX = (radius + 70) * math.cos(4.36332);
// //    boxPmsY = (radius + 25) * math.sin(4.36332);
// //
// //    canvas.drawRRect(RRect.fromRectAndCorners(
// //        Rect.fromCircle(center: Offset(boxPmsX,boxPmsY),radius: 13),
// //        bottomLeft: Radius.circular(7),
// //        topRight: Radius.circular(7),
// //        topLeft: Radius.circular(7),
// //        bottomRight: Radius.circular(7)
// //    ), boxPmsPaint);
// //
// //    TextSpan pmsText = new TextSpan(
// //        style: new TextStyle(
// //            color: ColorPallet().pmsDeep,
// //            fontSize:  ScreenUtil().setSp(30),
// //            fontFamily: 'IRANYekan',
// //            fontWeight: FontWeight.bold
// //        ), text: maxDays.toString());
// //    TextPainter tpPms = new TextPainter(text: pmsText, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
// //    tpPms.layout();
// //    tpPms.paint(canvas, new Offset(boxPmsX - 8,boxPmsY - 7));
// //
// //
// //
// //    ///////////////////////////////
// //
// //
// //
// //    canvas.drawArc(
// //        Rect.fromCircle(
// //            center: Offset(0,0),
// //            radius: radius
// //        ),  fertStart.radians,fertEnd.radians,false,fertPaint
// //    );
// //
// //
// //    ///////////////////////////////
// //
// ////    canvas.drawArc(
// ////        Rect.fromCircle(
// ////            center: Offset(0,0),
// ////            radius: radius
// ////        ),
// ////        ovum.radians,0.001,false,ovumPaint
// ////    );
// //
// //    Path ovumPms = Path()
// //      ..addOval(Rect.fromCircle(center: Offset(ovumX - 1,ovumY - 3),radius:11));
// //
// //    canvas.drawShadow(ovumPms, ColorPallet().ovum, 2.0, true);
// //
// //    canvas.drawCircle(Offset(ovumX,ovumY), 8, withePaint);
// //
// //    canvas.drawCircle(Offset(ovumX,ovumY), 8, ovumPaint);
// //
// //    if(ovum.degrees <= 0){
// //
// //      boxOvumX =   (radius + 35) * math.cos(ovum.radians);
// //      boxOvumY = (radius + 35) * math.sin(ovum.radians);
// //
// //    }else if(ovum.degrees > 0 && ovum.degrees <= 90){
// //
// //      if(ovum.degrees == 90){
// //
// //        boxOvumX = (radius + 40) * math.cos(ovum.radians);
// //        boxOvumY = 185;
// //
// //      }else{
// //
// //        if(ovum.degrees >= 45){
// //
// //          boxOvumX = (radius + 30) * math.cos(ovum.radians);
// //          boxOvumY = (radius + 32) * math.sin(ovum.radians);
// //
// //        }else if(ovum.degrees >= 20){
// //
// //          boxOvumX = (radius + 35) * math.cos(ovum.radians);
// //          boxOvumY = (radius + 20) * math.sin(ovum.radians);
// //
// //        }else{
// //
// //          boxOvumX = (radius + 30) * math.cos(ovum.radians);
// //          boxOvumY = (radius + 20) * math.sin(ovum.radians);
// //
// //        }
// //
// //      }
// //
// //    }else if(ovum.degrees > 90 && ovum.degrees <= 180){
// //
// //
// //      if(ovum.degrees >= 160){
// //
// //        boxOvumX = (radius + 30) * math.cos(ovum.radians);
// //        boxOvumY = (radius + 80) * math.sin(ovum.radians);
// //
// //      }else{
// //        boxOvumX = (radius + 35) * math.cos(ovum.radians);
// //        boxOvumY = (radius + 30) * math.sin(ovum.radians);
// //      }
// //
// //    }else if(ovum.degrees > 180 && ovum.degrees <= 270){
// //
// //      if(ovum.degrees <= 210){
// //
// //        boxOvumX = (radius + 30) * math.cos(ovum.radians);
// //        boxOvumY = (radius + 50) * math.sin(ovum.radians);
// //
// //      }else{
// //
// //        boxOvumX = (radius + 35) * math.cos(ovum.radians);
// //        boxOvumY = (radius + 35) * math.sin(ovum.radians);
// //
// //      }
// //
// //    }
// //
// //    canvas.drawRRect(RRect.fromRectAndCorners(
// //      Rect.fromCircle(center: Offset(boxOvumX,boxOvumY),radius: 13),
// //      bottomRight: Radius.circular(7),
// //      bottomLeft: Radius.circular(7),
// //      topLeft: Radius.circular(7),
// //      topRight: Radius.circular(7),
// ////      bottomLeft: ovum.degrees <= 0 ? Radius.circular(0) : Radius.circular(10),
// ////      topLeft: ovum.degrees > 0 && ovum.degrees <= 90 ? Radius.circular(0) : Radius.circular(10),
// ////      topRight: ovum.degrees > 90 && ovum.degrees <= 180 ? Radius.circular(0) : Radius.circular(10),
// ////      bottomRight:  ovum.degrees > 180.0 && ovum.degrees <= 270.0 ? Radius.circular(0) : Radius.circular(10),
// //    ), boxOvumPaint);
// //
// //    TextSpan ovumText = new TextSpan(
// //        style: new TextStyle(
// //          color: ColorPallet().ovum,
// //          fontSize:  ScreenUtil().setSp(34),
// //          fontFamily: 'IRANYekan',
// ////            fontWeight: FontWeight.bold
// //        ), text: (maxDays - 13).toString());
// //    TextPainter tpOvum = new TextPainter(text: ovumText, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
// //    tpOvum.layout();
// //    tpOvum.paint(canvas, new Offset(boxOvumX - 7,boxOvumY - 7));
// //
// //
// //    /////////////////////////////////////
// //
// //
// ////    Path pathCurrent = Path()
// ////      ..addOval(Rect.fromCircle(center: Offset(currentX - 1,currentY - 3),radius:9));
// ////
// ////    canvas.drawShadow(pathCurrent, Colors.black, 2.0, true);
// //
// //    canvas.drawArc(
// //        Rect.fromCircle(
// //            center: Offset(0,0),
// //            radius: radius
// //        ),
// //        current.radians,0.001,false,currentPaint
// //    );
// //
// //
// //    ////////////////////////////////
// //
// //
// //
// //  }
// //
// //  @override
// //  bool shouldRepaint(CustomPainter oldDelegate) => false;
// //
// //
// //  generateNumber(){
// //
// //    radius = ((width - widthOfArc) / 2) - ScreenUtil().setWidth(100);
// //    currentX = radius * math.cos(current.radians);
// //    currentY = radius * math.sin(current.radians);
// //
// //    periodX = radius * math.cos(periodEnd.radians - 1.22173);
// //    periodY = radius * math.sin(periodEnd.radians - 1.22173);
// //
// //
// //    pmsX = radius * math.cos(4.36332);
// //    pmsY = radius * math.sin(4.36332);
// //
// //    ovumX = radius * math.cos(ovum.radians);
// //    ovumY = radius * math.sin(ovum.radians);
// //
// //
// //  }
// //
// //}
// //
// //
// //
