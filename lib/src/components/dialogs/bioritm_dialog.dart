

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/components/colors.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../animations.dart';

class BioritmDialog extends StatefulWidget{

  final scaleAnim;
  final onPressOk;
  final onPressClose;
  final backgroundColor;

  BioritmDialog({Key? key,this.scaleAnim,this.onPressOk,this.backgroundColor,this.onPressClose}):super(key:key);

  @override
  State<StatefulWidget> createState() => BioritmDialogState();

}

class BioritmDialogState extends State<BioritmDialog> with TickerProviderStateMixin{

  AnimationController? animationControllerScaleButtons;
  Animations _animations =  Animations();

  int? modePress ;

  TapGestureRecognizer? _tapGestureRecognizer;

  @override
  void initState() {
    animationControllerScaleButtons = _animations.pressButton(this);
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = _handlePress;
    super.initState();
  }

  @override
  void dispose() {
    animationControllerScaleButtons!.dispose();
    _tapGestureRecognizer!.dispose();
    super.dispose();
  }

  void _handlePress() {
    _launchURL('https://impo.app/what-is-biorhythm-and-how-does-it-affect-peoples-behavior/');
  }

  Future<bool> _launchURL(String url) async {
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
    return true;
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = 0.5;
    return  Stack(
      children: <Widget>[
        GestureDetector(
          onTap: widget.onPressClose,
          child:  Container(
            decoration:  BoxDecoration(
                color: Colors.black.withOpacity(.8)
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
//            padding: EdgeInsets.zero,
//            shrinkWrap: true,
          children: <Widget>[
            Container(),
            StreamBuilder(
              stream: widget.scaleAnim,
              builder: (context,AsyncSnapshot<double>snapshotScaleDialog){
                if(snapshotScaleDialog.data != null){
                  return  Transform.scale(
                      scale: snapshotScaleDialog.data,
                      child: Container(
//                              width: 280,
//                              height: 400,
                        margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(120),
                            right: ScreenUtil().setWidth(50),
                            left: ScreenUtil().setWidth(50)
                        ),
                        // padding: EdgeInsets.only(
                        //     top: ScreenUtil().setWidth(130)
                        // ),
                        decoration:  BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: widget.backgroundColor
                        ),
                        child:  Padding(
                          padding: EdgeInsets.only(
                            right: ScreenUtil().setWidth(40),
                            left: ScreenUtil().setWidth(40),
                          ),
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: ScreenUtil().setWidth(50)),
                                child: Text(
                                  'بیوریتم عبارت است از:',
                                  textAlign: TextAlign.start,
                                  style:  context.textTheme.labelLargeProminent!.copyWith(
                                    color: ColorPallet().mainColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: ScreenUtil().setHeight(30)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    textAlign: TextAlign.justify,
                                    text: TextSpan(
                                       text : "بیوریتم به معنی الگوی تکرارشونده‌ای از فعالیت‌های جسمی، عاطفی و ذهنی ما آدمهاست که بر اون اساس در روزهای مختلف دچار افزایش و کاهش انرژی در حالات احساسی، توان جسمی و قدرت یادگیری میشیم.این کاهش و افزایش بر اساس تاریخ دقیق روز تولد و به صورت یک نمودار سینوسی با طول دوره متفاوت برای هر کدوم از این سه حالته.لازمه بدونی عوامل محیطی بشدت بر روی این حالت‌ها اثرگذاره و با یک مدیریت درست میشه این روزها رو به بهترین شکل گذروند. برای اطلاعات بیشتر در مورد بیوریتم،",
                                        style:  context.textTheme.bodyMedium,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: ' اینجا کلیک کن',
                                          recognizer: _tapGestureRecognizer,
                                          mouseCursor: SystemMouseCursors.precise,
                                          style:  context.textTheme.labelMedium!.copyWith(
                                            color: Color(0xff7C73E6),
                                          ),
                                        ),
                                      ]
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: ScreenUtil().setHeight(50)),
                              Align(
                                alignment: Alignment.center,
                                child:   StreamBuilder(
                                  stream: _animations.squareScaleBackButtonObserve,
                                  builder: (context,AsyncSnapshot<double> snapshotScaleYes){
                                    if(snapshotScaleYes.data != null){
                                      return  Transform.scale(
                                        scale: modePress == 0 ? snapshotScaleYes.data : 1.0,
                                        child:  GestureDetector(
                                          onTap: ()async{
                                            setState(() {
                                              modePress=0;
                                            });
                                            await animationControllerScaleButtons!.reverse();
                                            widget.onPressOk();
                                          },
                                          child:  Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: ScreenUtil().setWidth(100),
                                                vertical: ScreenUtil().setWidth(7)
                                            ),
                                            decoration:  BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain]
                                              ),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child:  Text(
                                              "چه خوبه",
                                              style:  context.textTheme.labelLarge!.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }else{
                                      return  Container();
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: ScreenUtil().setHeight(30)),
                            ],
                          ),
                        ),
                      ),
                  );
                }else{
                  return  Container();
                }
              },
            ),
          ],
        ),
      ],
    );
  }

}