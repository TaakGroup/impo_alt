import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/unicorn_outline_button.dart';
import 'package:get/get.dart';

import '../animations.dart';

class AborationDialog extends StatefulWidget {
  final onPressCancel;
  final scaleAnim;
  final onPressYes;
  final isIcon;
  final isOneBtn;
  final colors;
  final title;
  final Color? textColor;

  AborationDialog(
      {Key? key,
      this.onPressCancel,
      this.scaleAnim,
      this.onPressYes,
      this.textColor,
      this.title,
      this.isIcon,
      this.isOneBtn,
      this.colors,
      })
      : super(key: key);

  @override
  State<StatefulWidget> createState() => AborationDialogState();
}

class AborationDialogState extends State<AborationDialog> with TickerProviderStateMixin {
  AnimationController? animationControllerScaleButtons;
  Animations _animations = Animations();

  int? modePress;

  @override
  void initState() {
    animationControllerScaleButtons = _animations.pressButton(this);
    super.initState();
  }

  @override
  void dispose() {
    animationControllerScaleButtons!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = 0.5;
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: widget.onPressCancel,
          child: Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(.8)),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
//            padding: EdgeInsets.zero,
//            shrinkWrap: true,
          children: <Widget>[
            StreamBuilder(
              stream: widget.scaleAnim,
              builder: (context, AsyncSnapshot<double>? snapshotScaleDialog) {
                if (snapshotScaleDialog!.data != null) {
                  return Transform.scale(
                      scale: snapshotScaleDialog.data,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          Container(

//                              width: 280,
//                              height: 400,
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(120), right: ScreenUtil().setWidth(100), left: ScreenUtil().setWidth(100)),
                              padding: widget.isIcon
                                  ? EdgeInsets.only(top: ScreenUtil().setWidth(130))
                                  : EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(50)),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: LinearGradient(colors: widget.colors, begin: Alignment.bottomLeft, end: Alignment.topRight)),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: ScreenUtil().setWidth(50),
                                  left: ScreenUtil().setWidth(50),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: ScreenUtil().setWidth(50),
                                    ),
                                    widget.title ?? Container(),
                                    Text(
                                      'برای سبز نشدن جوانه کوچکی که در دل داشتی، متاسفیم.\nایمپو مثل همیشه در کنارته.',
                                      textAlign: TextAlign.justify,
                                      style: context.textTheme.bodyMedium!.copyWith(
                                        color: widget.textColor ?? ColorPallet().black,
                                      ),
                                    ),
                                    SizedBox(height: ScreenUtil().setHeight(50)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Flexible(
                                          flex: 2,
                                          child: StreamBuilder(
                                            stream: _animations.squareScaleBackButtonObserve,
                                            builder: (context,AsyncSnapshot<double>snapshotScaleYes) {
                                              if (snapshotScaleYes.data != null) {
                                                return Transform.scale(
                                                  scale: modePress == 0 ? snapshotScaleYes.data : 1.0,
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      setState(() {
                                                        modePress = 0;
                                                      });
                                                      await animationControllerScaleButtons!.reverse();
                                                      widget.onPressYes();
                                                    },
                                                    child: Container(
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal: ScreenUtil().setWidth(10),
                                                            vertical: ScreenUtil().setWidth(10)),
                                                        decoration: BoxDecoration(
                                                          gradient:
                                                              LinearGradient(colors: [ColorPallet().mainColor, ColorPallet().lightMainColor]),
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        child: Center(
                                                            child:     Text(
                                                              'ورود به فاز قاعدگی',
                                                              style: context.textTheme.labelLarge!.copyWith(
                                                                color: Colors.white,
                                                              ),
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return Container();
                                              }
                                            },
                                          ),
                                        ),
                                        widget.isOneBtn == null ? SizedBox(width: ScreenUtil().setWidth(30)) : Container(),
                                        widget.isOneBtn == null
                                            ? Flexible(
                                                child: StreamBuilder(
                                                stream: _animations.squareScaleBackButtonObserve,
                                                builder: (context, AsyncSnapshot<double>snapshotScaleYes) {
                                                  if (snapshotScaleYes.data != null) {
                                                    return Transform.scale(
                                                      scale: modePress == 1 ? snapshotScaleYes.data : 1.0,
                                                      child: UnicornOutlineButton(
                                                        strokeWidth: 2,
                                                        radius: 12,
                                                        onPressed: ()async{
                                                          setState(() {
                                                            modePress = 1;
                                                          });
                                                          await animationControllerScaleButtons!.reverse();
                                                          widget.onPressCancel();
                                                        },
                                                        minHeight: ScreenUtil().setWidth(73),
                                                        gradient: LinearGradient(
                                                            colors:
                                                            [ColorPallet().mentalMain,
                                                              ColorPallet().mentalHigh
                                                            ]),
                                                        child:  Center(
                                                          child: Text(
                                                            'بازگشت',
                                                            style: context.textTheme.labelLarge!.copyWith(
                                                              color: ColorPallet().gray,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                },
                                              ))
                                            : Container()
                                      ],
                                    ),
                                    widget.isIcon ? SizedBox(height: ScreenUtil().setHeight(50)) : Container(),
                                  ],
                                ),
                              )),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(right: ScreenUtil().setWidth(210), top: ScreenUtil().setWidth(50)),
                            width: ScreenUtil().setWidth(280),
                            height: ScreenUtil().setWidth(280),
                            child: Container(
                              child: SvgPicture.asset("assets/images/dialog_aboration.svg", fit: BoxFit.cover, width: ScreenUtil().setWidth(280)
                                  // fit: BoxFit.fill,
                                  ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: EdgeInsets.only(right: ScreenUtil().setWidth(130), top: ScreenUtil().setWidth(260)),
                              width: ScreenUtil().setWidth(60),
                              height: ScreenUtil().setWidth(60),
                              child: Container(
                                child: SvgPicture.asset("assets/images/parvane.svg", fit: BoxFit.cover, width: ScreenUtil().setWidth(60)
                                    // fit: BoxFit.fill,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ));
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
