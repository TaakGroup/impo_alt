

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:impo/src/components/unicorn_outline_button.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';

import '../animations.dart';

class QusDialog extends StatefulWidget{

  final onPressCancel;
  final scaleAnim;
  final value;
  final yesText;
  final noText;
  final onPressYes;
  final isIcon;
  final isOneBtn;
  final colors;
  final topIcon;
  final isLoadingButton;
  final size;
  final alignIcon;
  final title;
  final notCancel;/// => pregnancy43Week

  QusDialog({Key? key,this.onPressCancel,this.scaleAnim,this.value,this.yesText,this.noText,this.onPressYes,
    this.isIcon,this.isOneBtn,this.colors,this.topIcon,this.isLoadingButton,this.alignIcon,this.size,this.title,this.notCancel}):super(key:key);

  @override
  State<StatefulWidget> createState() => QusDialogState();

}

class QusDialogState extends State<QusDialog> with TickerProviderStateMixin{

  late AnimationController animationControllerScaleButtons;
  Animations _animations =  Animations();

  int modePress = 0 ;

  @override
  void initState() {
    animationControllerScaleButtons = _animations.pressButton(this);
    super.initState();
  }

  @override
  void dispose() {
    animationControllerScaleButtons.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = 0.5;
    return  Stack(
      children: <Widget>[
        GestureDetector(
          onTap: (){
            if(widget.notCancel == null){
              widget.onPressCancel();
            }
          },
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
              builder: (context,AsyncSnapshot<double> snapshotScaleDialog){
                if(snapshotScaleDialog.data != null){
                  return  Transform.scale(
                      scale: snapshotScaleDialog.data,
                      child:  Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          Container(
//                              width: 280,
//                              height: 400,
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(120),
                                  right: ScreenUtil().setWidth(100),
                                  left: ScreenUtil().setWidth(100)
                              ),
                              padding: widget.isIcon ?
                              EdgeInsets.only(
                                  top: ScreenUtil().setWidth(100)
                              ) : EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setWidth(50)
                              ),
                              decoration:  BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: LinearGradient(
                                      colors: widget.colors,
                                      begin: Alignment.bottomLeft,
                                      end:Alignment.topRight
                                  )
                              ),
                              child:  Padding(
                                padding: EdgeInsets.only(
                                  right: ScreenUtil().setWidth(50),
                                  left: ScreenUtil().setWidth(50),
                                ),
                                child:  Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                   widget.title != null ? Padding(
                                     padding: EdgeInsets.only(
                                       bottom: ScreenUtil().setWidth(20)
                                     ),
                                     child: Text(
                                       widget.title,
                                        style: context.textTheme.titleMedium!.copyWith(
                                          color: ColorPallet().mainColor,
                                        ),
                                      ),
                                   ) :  Container(),
                                    Text(
                                      widget.value,
                                      textAlign: TextAlign.center,
                                      style:  context.textTheme.bodyLarge,
                                    ),
                                    SizedBox(height: ScreenUtil().setHeight(30)),
                                    widget.notCancel == null ?
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Flexible(
                                          flex: 2,
                                          child:  StreamBuilder(
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
                                                      await animationControllerScaleButtons.reverse();
                                                      widget.onPressYes();
                                                    },
                                                    child:  Container(
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal: ScreenUtil().setWidth(20),
                                                            vertical: ScreenUtil().setWidth(10)
                                                        ),
                                                        decoration:  BoxDecoration(
                                                          gradient: LinearGradient(
                                                              colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain]
                                                          ),
                                                          borderRadius: BorderRadius.circular(15),
                                                        ),
                                                        child:  Center(
                                                            child: widget.isLoadingButton != null
                                                                ? !widget.isLoadingButton ?
                                                            Text(
                                                              widget.yesText,
                                                              style:  context.textTheme.labelLarge!.copyWith(
                                                                color: Colors.white,
                                                              ),
                                                            ) :  LoadingViewScreen(
                                                              color: Colors.white,
                                                              width: ScreenUtil().setWidth(35),
                                                              lineWidth: ScreenUtil().setWidth(5),
                                                            ) :  Text(
                                                              widget.yesText,
                                                              style:  context.textTheme.labelLarge!.copyWith(
                                                                color: Colors.white,
                                                              ),
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                );
                                              }else{
                                                return  Container();
                                              }
                                            },
                                          ),
                                        ),
                                        widget.isOneBtn == null ?
                                        SizedBox(width: ScreenUtil().setWidth(30))
                                            :  Container(),
                                        widget.isOneBtn == null ?
                                        Flexible(
                                          flex: 1,
                                            child:  StreamBuilder(
                                              stream: _animations.squareScaleBackButtonObserve,
                                              builder: (context,AsyncSnapshot<double> snapshotScaleYes){
                                                if(snapshotScaleYes.data != null){
                                                  return  Transform.scale(
                                                    scale: modePress == 1 ? snapshotScaleYes.data : 1.0,
                                                    child:  GestureDetector(
                                                      onTap: ()async{
                                                        setState(() {
                                                          modePress=1;
                                                        });
                                                        await animationControllerScaleButtons.reverse();
                                                        widget.onPressCancel();
                                                      },
                                                      child:  Container(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal: ScreenUtil().setWidth(20),
                                                              vertical: ScreenUtil().setWidth(10)
                                                          ),
                                                          decoration:  BoxDecoration(
                                                              color: Colors.transparent,
                                                              borderRadius: BorderRadius.circular(15),
                                                              border: Border.all(
                                                                  color: ColorPallet().mentalMain,
                                                                  width: 2
                                                              )
                                                          ),
                                                          child:  Center(
                                                            child:  Text(
                                                              widget.noText,
                                                              style:  context.textTheme.labelLarge!.copyWith(
                                                                color: ColorPallet().gray,
                                                              ),
                                                            ),
                                                          )
                                                      ),
                                                    ),
                                                  );
                                                }else{
                                                  return  Container();
                                                }
                                              },
                                            )
                                        )
                                            : Container()
                                      ],
                                    ) :
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Flexible(
                                          child:  StreamBuilder(
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
                                                      await animationControllerScaleButtons.reverse();
                                                      widget.onPressYes();
                                                    },
                                                    child:  Container(
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal: ScreenUtil().setWidth(20),
                                                            vertical: ScreenUtil().setWidth(10)
                                                        ),
                                                        decoration:  BoxDecoration(
                                                          gradient: LinearGradient(
                                                              colors: [ColorPallet().mainColor,ColorPallet().lightMainColor]
                                                          ),
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        child:  Center(
                                                            child: widget.isLoadingButton != null
                                                                ? !widget.isLoadingButton ?
                                                            Text(
                                                              widget.yesText,
                                                              style:  context.textTheme.labelLarge!.copyWith(
                                                                color: Colors.white,
                                                              ),
                                                            ) :  LoadingViewScreen(
                                                              color: Colors.white,
                                                              width: ScreenUtil().setWidth(35),
                                                              lineWidth: ScreenUtil().setWidth(5),
                                                            ) :  Text(
                                                              widget.yesText,
                                                              style:  context.textTheme.labelLarge!.copyWith(
                                                                color: Colors.white,
                                                              ),
                                                            )
                                                        )
                                                    ),
                                                  ),
                                                );
                                              }else{
                                                return  Container();
                                              }
                                            },
                                          ),
                                        ),
                                        widget.isOneBtn == null ?
                                        SizedBox(width: ScreenUtil().setWidth(30))
                                            :  Container(),
                                        widget.isOneBtn == null ?
                                        Flexible(
                                            child:  StreamBuilder(
                                              stream: _animations.squareScaleBackButtonObserve,
                                              builder: (context,AsyncSnapshot<double> snapshotScaleYes){
                                                if(snapshotScaleYes.data != null){
                                                  return  Transform.scale(
                                                    scale: modePress == 1 ? snapshotScaleYes.data : 1.0,
                                                    child:   UnicornOutlineButton(
                                                      strokeWidth: 2,
                                                      radius: 12,
                                                      onPressed: ()async{
                                                        setState(() {
                                                          modePress=1;
                                                        });
                                                        await animationControllerScaleButtons.reverse();
                                                        widget.onPressCancel();
                                                      },
                                                      minHeight: ScreenUtil().setWidth(73),
                                                      minWidth: ScreenUtil().setWidth(200),
                                                      gradient: LinearGradient(
                                                          colors:
                                                          [ColorPallet().mainColor,
                                                            ColorPallet().lightMainColor
                                                          ]),
                                                      child:  Center(
                                                        child: Text(
                                                          widget.noText,
                                                          style:  context.textTheme.labelLarge!.copyWith(
                                                            color: ColorPallet().mainColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }else{
                                                  return  Container();
                                                }
                                              },
                                            )
                                        ) :
                                            Container()
                                      ],
                                    ),
                                    widget.isIcon ?  SizedBox(height: ScreenUtil().setHeight(50)) :  Container()
                                  ],
                                ),
                              )
                          ),
                          widget.isIcon ?
                          Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(50)
                              ),
                              padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                              width: ScreenUtil().setWidth(160),
                              height: ScreenUtil().setWidth(160),
                              decoration:  BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white
                              ),
                              child: Center(
                                  child: SvgPicture.asset(
                                    widget.topIcon,
                                    fit: BoxFit.cover,
                                    // fit: BoxFit.fill,
                                  )
                              )
                          )
                              :  Container()
                        ],
                      )
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