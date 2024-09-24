
import 'dart:ui' as UI;

import 'package:angles/angles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

import 'package:impo/src/components/colors.dart';
import 'package:get/get.dart';


class CircleItem extends CustomPainter{

  BuildContext? context;
  double? width;
  double? height;
  Angle? periodStart;
  Angle? periodEnd;
  Angle? fertStart;
  Angle? fertEnd;
  Angle? pmsStart;
  Angle? pmsEnd;
  Angle? current;
  Angle? ovum;
  int? maxDays;
  int? periodDay;
  int? modeDays;
  int? currentToday;
  int? dayMode;
  int? fertStartDays;
  int? fertEndDays;

  CircleItem({this.context,this.width,this.height,this.pmsStart,
  this.periodEnd,this.fertEnd,this.fertStart,this.periodStart,
  this.pmsEnd,this.current,this.ovum,this.maxDays,this.periodDay,
  this.modeDays,this.currentToday,this.dayMode,this.fertStartDays,this.fertEndDays});

  double widthOfArc = 2;

  double currentX = 0;
  double currentY = 0;

  double periodX = 0;
  double periodY = 0;
  double boxPeriodX = 0;
  double boxPeriodY = 0;

  double pmsX = 0;
  double pmsY = 0;
  double boxPmsX = 0;
  double boxPmsY = 0;

  late double radius;

  double ovumX = 0;
  double ovumY = 0;
  double boxOvumX = 0;
  double boxOvumY= 0;


  @override
  void paint(Canvas canvas, Size size) {
//    var myCanvas = TouchyCanvas(context,canvas);


    generateNumber();

    final mainPaint = Paint();

    mainPaint.color = Colors.grey.withOpacity(.4);
    mainPaint.strokeWidth = widthOfArc;
    mainPaint.style = PaintingStyle.stroke;
    mainPaint.strokeCap = StrokeCap.round;

    final periodPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ScreenUtil().setWidth(8)
      ..strokeCap = StrokeCap.round
      ..color = ColorPallet().mainColor;

//    final boxPeriodPaint = Paint()
//      ..style = PaintingStyle.stroke
//      ..strokeWidth = 2
//      ..strokeCap = StrokeCap.round
//      ..color = ColorPallet().periodDeep;


    final withePaint =  Paint()
      .. color = Colors.white
      .. strokeCap = StrokeCap.round;

    final pmsPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ScreenUtil().setWidth(8)
      ..strokeCap = StrokeCap.round
      ..color = ColorPallet().pmsDeep;

    final boxPmsPaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;

    final fertPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ScreenUtil().setWidth(8)
      ..strokeCap = StrokeCap.round
      ..color = ColorPallet().fertDeep;

//    final currentPaint = Paint()
//      ..style = PaintingStyle.stroke
//      ..strokeCap = StrokeCap.round
//      ..strokeWidth = 13
//      ..color = Colors.grey[800]
//    ;

//    final Gradient ovumFradient =  LinearGradient(
//        colors:       <Color>[
//          ColorPallet().fertDeep,
//          ColorPallet().fertLight,
//        ]
//    );

    final borderOvum = Paint()
      ..style = PaintingStyle.stroke
      .. color = Color(0xff1FDFE4)
     .. strokeWidth = ScreenUtil().setWidth(5);

    final ovumPaint = Paint()
      ..style = PaintingStyle.fill
      .. color = Color(0xff0a7b7f);




//    final boxOvumPaint = Paint()
//      ..style = PaintingStyle.stroke
//      ..strokeCap = StrokeCap.round
//      ..strokeWidth = 2
//      ..color = ColorPallet().ovum
//    ;
//
//    final periodCircle = Paint()
//      .. style = PaintingStyle.fill
//      .. color = ColorPallet().periodLight;

//    final outCirclePaint = Paint()
//      .. style = PaintingStyle.stroke
//      .. strokeWidth = 20
//      .. color = Color(0xffF7E2F0).withOpacity(.5);


    final Gradient gradient =  LinearGradient(
      colors: dayMode == 0 ?
      <Color>[
        ColorPallet().periodDeep,
        ColorPallet().periodLight
      ] :
          dayMode == 1 ?
          <Color>[
            ColorPallet().fertDeep,
            ColorPallet().fertLight
          ] :
           dayMode == 2 ?
           <Color>[
             ColorPallet().pmsDeep,
             ColorPallet().pmsLight
           ] :
           <Color>[
             ColorPallet().normalDeep,
             ColorPallet().normalLight
           ],
    );

    final gradientCircle = Paint()
      .. style = PaintingStyle.fill
      ..shader = gradient.createShader(Rect.fromCircle(center: Offset(currentX,currentY),radius: ScreenUtil().setWidth(32)));

//    myCanvas.drawCircle(Offset(0,0), radius, periodPaint,
//      onTapDown: (t){
//      print('cdsvdfvdf');
//      }
//    );

//    final circlePaint = Paint()
//    ..style = PaintingStyle.stroke
//    ..strokeWidth = 3
//    .. color = Colors.red;




//  canvas.drawRRect(RRect.fromLTRBR(100, 100, 0, 0, Radius.circular(60)),
//      paint);
//
//  canvas.drawRect(Rect.fromLTRB(100, 100, 0, 0), paint);


//    canvas.drawArc(
//        Rect.fromCircle(
//          center: Offset(size.width/2,size.height/2),
//          radius: radius,
//        ),
//        5.07,5.5 ,false , paint);
//
//
//
//    canvas.drawArc(
//        Rect.fromCircle(
//          center: Offset(size.width/2,size.height/2),
//          radius: radius,
//        ),
//        5.07,.5 ,false , redPaint);
//
//    canvas.drawArc(
//        Rect.fromCircle(
//          center: Offset(size.width/2,size.height/2),
//          radius: radius,
//        ),
//        3,1 ,false , bluePaint);



//    canvas.drawArc(
//        Rect.fromCircle(
//            center: Offset(0,0),
//            radius: radius
//        ),
//        -1.13446,5.41052,false,mainPaint
//    );



    ///////////// /////////////////////


//    canvas.drawCircle(Offset(0,0), radius - ScreenUtil().setWidth(16), outCirclePaint);


    //////////////////////////////////////


    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(0,0),
            radius: radius,
        ),
        periodStart!.radians,periodEnd!.radians,false,periodPaint,
    );

//    Path pathPeriod = Path()
//      ..addOval(Rect.fromCircle(center: Offset(periodX - 1,periodY - 3),radius:11));
//
//    canvas.drawShadow(pathPeriod, ColorPallet().periodDeep, 2.0, true);
//
//    canvas.drawCircle(Offset(periodX,periodY), 8, withePaint);
//
//    canvas.drawCircle(Offset(periodX,periodY), 8, periodPaint);

//    for(int i=0 ; i < periodDay - 1 ; i++ ){
//
//      Angle angle = Angle.fromDegrees(periodStart.degrees + (i*(320.0/(maxDays-1))));
//
//      double x = (radius + 10) * math.cos(angle.radians);
//      double y = (radius + 10) * math.sin(angle.radians);
//
//      canvas.drawCircle(Offset(x ,y ), 3, periodCircle);
//
//    }

    for(int i=0 ; i < maxDays! ; i++ ){

      Angle angle = Angle.degrees(periodStart!.degrees + ((i)*(310.0/(maxDays!-1))));


      //      String tmp = String.valueOf(number+1);
//      paint.getTextBounds(tmp, 0, tmp.length(), rect);
//      double angle = START_ANGLE + (number *AngleOneDay);
//      int x = (int) (width / 2 + Math.cos(Math.toRadians(angle - 90)) * radius - rect.width() / 2);
//      int y = (int) (height / 2 + Math.sin(Math.toRadians(angle - 90)) * radius + rect.height() / 2);



      TextSpan periodText =  TextSpan(
          style: context!.textTheme.bodyMedium!.copyWith(
            color: i+1 == maxDays!-13 ? Color(0xff004F51) :
            i+1 == fertStartDays || i+1 == fertEndDays ? ColorPallet().fertDeep:
            i+1 == maxDays ? ColorPallet().pmsDeep : ColorPallet().mainColor,
          )
          , text: '${i+1}');
      TextPainter tpPeriod =  TextPainter(text: periodText, textAlign: TextAlign.left, textDirection: TextDirection.ltr);


      tpPeriod.layout();

      double x;
      double y;
//      if(angle.degrees < 65){
//
//         x = (radius - tpPeriod.width/2) * math.cos(angle.radians);
//         y = (radius + tpPeriod.height/2) * math.sin(angle.radians);
//
//    }else{
//
//         x = (radius + tpPeriod.height/2) * math.cos(angle.radians);
//         y = (radius - tpPeriod.width/2) * math.sin(angle.radians);
//
//      }

//      print('${tpPeriod.text} ${tpPeriod.width} ${tpPeriod.height}');


//      y = (radius + (tpPeriod.height/2)) * math.sin(angle.radians);


//

      if(i+1 == maxDays! -13){
        x = math.cos(angle.radians) * (radius + ScreenUtil().setWidth(55)) - tpPeriod.width/2;
        y = math.sin(angle.radians) * (radius + ScreenUtil().setWidth(65)) + tpPeriod.height/2;
      }else if(i+1 == maxDays){
        x = math.cos(angle.radians) * (radius + ScreenUtil().setWidth(100)) - tpPeriod.width/2;
        y = math.sin(angle.radians) * (radius + ScreenUtil().setWidth(40)) + tpPeriod.height/2;
      }else{
        x = math.cos(angle.radians) * (radius + ScreenUtil().setWidth(35)) - tpPeriod.width/2;
        y = math.sin(angle.radians) * (radius + ScreenUtil().setWidth(35)) + tpPeriod.height/2;
      }

      /// if(i+1 == maxDays && currentToday != maxDays){
      ///
      ///   Path pmsPath = Path()
      ///     ..addRRect(RRect.fromRectAndCorners(
      ///         Rect.fromCircle(center: Offset(x + tpPeriod.width/2 - ScreenUtil().setWidth(5),y-ScreenUtil().setWidth(22)),radius: ScreenUtil().setWidth(25)),
      ///         bottomLeft: Radius.circular(7),
      ///         topRight: Radius.circular(7),
      ///         topLeft: Radius.circular(7),
      ///         bottomRight: Radius.circular(7)
      ///     ));
      ///
      ///   canvas.drawShadow(pmsPath,
      ///         Color(0xffA684EB).withOpacity(.5),
      ///       7, true);
      ///
      ///   canvas.drawRRect(RRect.fromRectAndCorners(
      ///       Rect.fromCircle(center: Offset(x + tpPeriod.width/2,y-ScreenUtil().setWidth(18)),radius: ScreenUtil().setWidth(27)),
      ///       bottomLeft: Radius.circular(7),
      ///       topRight: Radius.circular(7),
      ///       topLeft: Radius.circular(7),
      ///       bottomRight: Radius.circular(7)
      ///   ), boxPmsPaint);
      /// }

      /// if(i+1 == maxDays-13 && currentToday != maxDays-13){
      ///
      ///   Path pmsPath = Path()
      ///     ..addRRect(RRect.fromRectAndCorners(
      ///         Rect.fromCircle(center: Offset(boxOvumX,boxOvumY - ScreenUtil().setWidth(8)),radius: ScreenUtil().setWidth(27)),
      ///         bottomLeft: Radius.circular(7),
      ///         topRight: Radius.circular(7),
      ///         topLeft: Radius.circular(7),
      ///         bottomRight: Radius.circular(7)
      ///     ));
      ///
      ///   canvas.drawShadow(pmsPath,
      ///       Color(0xff20DFE4).withOpacity(.3),
      ///       7, true);
      ///
      ///   canvas.drawRRect(RRect.fromRectAndCorners(
      ///       Rect.fromCircle(center: Offset(boxOvumX,boxOvumY),radius: ScreenUtil().setWidth(27)),
      ///       bottomLeft: Radius.circular(7),
      ///       topRight: Radius.circular(7),
      ///       topLeft: Radius.circular(7),
      ///       bottomRight: Radius.circular(7)
      ///   ), boxPmsPaint);
      /// }

      /// if(i+1 == periodDay && currentToday != periodDay){
      ///
      ///   Path pmsPath = Path()
      ///     ..addRRect(RRect.fromRectAndCorners(
      ///         Rect.fromCircle(center: Offset(x + tpPeriod.width/2 + ScreenUtil().setWidth(8),y-ScreenUtil().setWidth(18)),radius: ScreenUtil().setWidth(25)),
      ///         bottomLeft: Radius.circular(7),
      ///         topRight: Radius.circular(7),
      ///         topLeft: Radius.circular(7),
      ///         bottomRight: Radius.circular(7)
      ///     ));
      ///
      ///   canvas.drawShadow(pmsPath,
      ///       Color(0xffFF00A9).withOpacity(.3),
      ///       7, true);
      ///
      ///   canvas.drawRRect(RRect.fromRectAndCorners(
      ///       Rect.fromCircle(center: Offset(x + tpPeriod.width/2 + ScreenUtil().setWidth(16),y-ScreenUtil().setWidth(8)),radius: ScreenUtil().setWidth(27)),
      ///       bottomLeft: Radius.circular(7),
      ///       topRight: Radius.circular(7),
      ///       topLeft: Radius.circular(7),
      ///       bottomRight: Radius.circular(7)
      ///   ), boxPmsPaint);
      ///
      /// }

      if(i+1 == 1 || i+1 == periodDay ||  i+1 == maxDays!-13 || i+1 == maxDays || i+1 == fertStartDays || i+1 == fertEndDays){
        if(i+1 != currentToday && i+1 != 1 && i+1 != maxDays && i+1 != maxDays!-13){
          tpPeriod.paint(canvas,  Offset(x,y-ScreenUtil().setWidth(50)));
        }
        if(i+1 == 1 && i+1 != currentToday){
          tpPeriod.paint(canvas,  Offset(x + ScreenUtil().setWidth(1),y-ScreenUtil().setWidth(40)));
        }

        if(i+1 == maxDays && i+1 != currentToday){
          tpPeriod.paint(canvas,  Offset(x+ScreenUtil().setWidth(30),y-ScreenUtil().setWidth(40)));
        }

        if(i+1 == maxDays!-13 && i+1 != currentToday){
          tpPeriod.paint(canvas,  Offset(boxOvumX - tpPeriod.width/2,(boxOvumY - tpPeriod.height/2) - ScreenUtil().setWidth(20)));
        }

      }



//      canvas.drawCircle(Offset(x ,y ), 3, periodCircle);

    }



    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(0,0),
            radius: radius
        ),  pmsStart!.radians,pmsEnd!.radians,false,pmsPaint
    );




    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(0,0),
            radius: radius
        ),  fertStart!.radians,fertEnd!.radians,false,fertPaint
    );


    ///////////////////////////////




    //    Path ovumPms = Path()
//      ..addOval(Rect.fromCircle(center: Offset(ovumX - ScreenUtil().setWidth(4),ovumY - ScreenUtil().setWidth(10)),radius:11));

    if(currentToday != maxDays! -13){
//      canvas.drawShadow(ovumPms,ColorPallet().ovum, 5, true);

//      canvas.drawCircle(Offset(ovumX,ovumY), 8, withePaint);


      canvas.drawCircle(Offset(ovumX,ovumY), ScreenUtil().setWidth(10), ovumPaint);

      canvas.drawCircle(Offset(ovumX,ovumY), ScreenUtil().setWidth(12), borderOvum);


    }


    Path todayPath = Path()
      ..addOval(Rect.fromCircle(center: Offset(currentX - ScreenUtil().setWidth(2),currentY - ScreenUtil().setWidth(4)),radius:ScreenUtil().setWidth(35)));

    canvas.drawShadow(todayPath,
        dayMode == 0 ? ColorPallet().periodDeep : dayMode == 1 ? ColorPallet().fertDeep : dayMode == 2 ? ColorPallet().pmsDeep : ColorPallet().normalDeep,
        4, true);

    canvas.drawCircle(
        Offset(currentX,currentY),
        ScreenUtil().setWidth(32),
        gradientCircle
    );



        TextSpan pmsText =  TextSpan(
        style:  context!.textTheme.bodySmall!.copyWith(
          color: Colors.white,
        )
            , text: currentToday.toString());
    TextPainter tpCurrent =  TextPainter(text: pmsText, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tpCurrent.layout();

    TextSpan todayText =  TextSpan(
        style:  context!.textTheme.labelSmall!.copyWith(
          color: Colors.white,
          fontSize: 10
        )
        , text: 'امروز');
    TextPainter todayCurrent =  TextPainter(text: todayText, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    todayCurrent.layout();

//    y = math.sin(angle.radians) * (radius + 20) + tpPeriod.height/2;

     double currentXNumber = radius * math.cos(current!.radians) - tpCurrent.width/2;
    double currentYNumber = radius * math.sin(current!.radians) + tpCurrent.height/2;

    double currentXToday = radius * math.cos(current!.radians) - todayCurrent.width/2;
    double currentYToday = radius * math.sin(current!.radians) + todayCurrent.height/2;

    todayCurrent.paint(canvas,  Offset(currentXToday ,currentYToday - ScreenUtil().setWidth(20) - ScreenUtil().setWidth(20)));

    tpCurrent.paint(canvas,  Offset(currentXNumber ,currentYNumber - ScreenUtil().setWidth(24)));

//    canvas.drawCircle(Offset(currentX,currentY), 8, ovumPaint);



//    canvas.drawCircle(
//        Rect.fromCircle(
//            center: Offset(0,0),
//            radius: radius
//        ),
//        current.radians,2,false,gradientCircle
//    );


    ////////////////////////////////



  }



  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

//  @override
//  bool shouldRebuildSemantics(CustomPainter oldDelegate) => true;



  generateNumber(){

    radius = ((width! - widthOfArc) / 2) - ScreenUtil().setWidth(80);
    currentX = radius * math.cos(current!.radians);
    currentY = radius * math.sin(current!.radians);

    periodX = radius * math.cos(periodEnd!.radians - 1.22173);
    periodY = radius * math.sin(periodEnd!.radians - 1.22173);


    pmsX = radius * math.cos(4.36332);
    pmsY = radius * math.sin(4.36332);

    ovumX = radius * math.cos(ovum!.radians);
    ovumY = radius * math.sin(ovum!.radians);


    if(ovum!.degrees <= 0){

      boxOvumX =   (radius + ScreenUtil().setWidth(55)) * math.cos(ovum!.radians);
      boxOvumY = (radius + ScreenUtil().setWidth(55)) * math.sin(ovum!.radians);

//      ovumX =   (radius + 35) * math.cos(ovum.radians);
//      ovumY = (radius + 35) * math.sin(ovum.radians);

    }else if(ovum!.degrees > 0 && ovum!.degrees <= 90){

      if(ovum!.degrees == 90){

        boxOvumX = (radius + ScreenUtil().setWidth(55)) * math.cos(ovum!.radians);
        boxOvumY = ScreenUtil().setWidth(350);


      }else{

        if(ovum!.degrees >= 45){

          boxOvumX = (radius + ScreenUtil().setWidth(55)) * math.cos(ovum!.radians);
          boxOvumY = (radius + ScreenUtil().setWidth(55)) * math.sin(ovum!.radians);


        }else if(ovum!.degrees >= 20){

          boxOvumX = (radius + ScreenUtil().setWidth(55)) * math.cos(ovum!.radians);
          boxOvumY = (radius + ScreenUtil().setWidth(55)) * math.sin(ovum!.radians);


        }else{

          boxOvumX = (radius + ScreenUtil().setWidth(55)) * math.cos(ovum!.radians);
          boxOvumY = (radius + ScreenUtil().setWidth(55)) * math.sin(ovum!.radians);


        }

      }

    }else if(ovum!.degrees > 90 && ovum!.degrees <= 180){


      if(ovum!.degrees >= 160){

        boxOvumX = (radius + ScreenUtil().setWidth(47)) * math.cos(ovum!.radians);
        boxOvumY = (radius + ScreenUtil().setWidth(50)) * math.sin(ovum!.radians);


      }else{
        boxOvumX = (radius + ScreenUtil().setWidth(55)) * math.cos(ovum!.radians);
        boxOvumY = (radius + ScreenUtil().setWidth(55)) * math.sin(ovum!.radians);

      }

    }else if(ovum!.degrees > 180 && ovum!.degrees <= 270){

      if(ovum!.degrees <= 210){

        boxOvumX = (radius + ScreenUtil().setWidth(55)) * math.cos(ovum!.radians);
        boxOvumY = (radius + ScreenUtil().setWidth(55)) * math.sin(ovum!.radians);


      }else{

        boxOvumX = (radius + ScreenUtil().setWidth(55)) * math.cos(ovum!.radians);
        boxOvumY = (radius + ScreenUtil().setWidth(55)) * math.sin(ovum!.radians);


      }

    }


  }

}




//
//
//public class NumberView extends View {
//
//
//  private static final float START_ANGLE = 24.287681f;
//  private static final float END_ANGLE = 360f - START_ANGLE;
//
//  Paint paint =  Paint();
//
//  public NumberView(Context context) {
//    super(context);
//    init();
//  }
//
//  public NumberView(Context context, AttributeSet attrs) {
//    super(context, attrs);
//    init();
//  }
//
//  public NumberView(Context context, AttributeSet attrs, int defStyle) {
//    super(context, attrs, defStyle);
//    init();
//  }
//
//  private void init(){
//    paint =  Paint();
//
//  }
//
//  @Override
//  protected void onDraw(Canvas canvas) {
//    super.onDraw(canvas);
//
//    float width = getWidth();
//    float height = getHeight();
//
//    float radius;
//
//
//    radius = height / 2f - padding;
//
//    paint.setTextSize(getResources().getDimension(R.dimen._11sdp));
//    paint.setTypeface(Setting.IranSensTypeBold(getContext()));
//    paint.setColor(color);
//    Rect rect =  Rect();
//
//    for (int number = 0; number < maxDays;number++) {
//      String tmp = String.valueOf(number+1);
//      paint.getTextBounds(tmp, 0, tmp.length(), rect);
//      double angle = START_ANGLE + (number *AngleOneDay);
//      int x = (int) (width / 2 + Math.cos(Math.toRadians(angle - 90)) * radius - rect.width() / 2);
//      int y = (int) (height / 2 + Math.sin(Math.toRadians(angle - 90)) * radius + rect.height() / 2);
//
//      if (lastPeriod >= (number+1) || ovumDay == (number+1) || maxDays == (number+1) || currentDay == (number+1))
//        canvas.drawText(tmp, x, y, paint);
//    }
//
//
//  }
//
//  int maxDays = 31;
//  double AngleOneDay;
//  public void setMaxDays(int days)
//  {
//    maxDays = days;
//    AngleOneDay = (END_ANGLE - START_ANGLE) / (days-1);
//  }
//
//  int color = Color.WHITE;
//  public void setColor(int color)
//  {
//    this.color = color;
//  }
//
//  int padding = 0;
//  public void setPadding(float padding)
//  {
//    this.padding = (int)padding;
//  }
//
//  private int lastPeriod;
//  public void setLastPeriod(int lastPeriod) {
//    this.lastPeriod = lastPeriod;
//  }
//
//  private int ovumDay;
//  public void setOvumDay(int ovumDay) {
//    this.ovumDay = ovumDay;
//  }
//
//  private int currentDay;
//  public void setCurrentDay(int currentDay) {
//    this.currentDay = currentDay;
//  }
//
//  @Override
//  protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
//    super.onMeasure(widthMeasureSpec - (int)getResources().getDimension(R.dimen._10sdp) , heightMeasureSpec - (int) getResources().getDimension(R.dimen._10sdp));
//    }
//
//
//
//}

