

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/components/colors.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';

import '../animations.dart';
import '../loading_view_screen.dart';

class OkDialog extends StatefulWidget{

  final scaleAnim;
  final value;
  final okText;
  final onPressOk;
  final onPressClose;
  final List<Color>? colors;
  final topIcon;
  final isExpert;
  final title;
  final isLoadingButton;

  OkDialog({Key? key,this.scaleAnim,this.value,this.okText,this.onPressOk,this.colors,this.topIcon,this.isExpert,this.title,this.onPressClose,this.isLoadingButton}):super(key:key);

  @override
  State<StatefulWidget> createState() => OkDialogState();

}

class OkDialogState extends State<OkDialog> with TickerProviderStateMixin{

  late AnimationController animationControllerScaleButtons;
  Animations _animations =  Animations();

  int modePress = 0;

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
                            padding: EdgeInsets.only(
                                top: widget.isExpert ? ScreenUtil().setWidth(0) : ScreenUtil().setWidth(130)
                            ),
                            decoration:  BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                    colors: widget.colors!,
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  widget.isExpert ?
                                  Padding(
                                    padding: EdgeInsets.only(top: ScreenUtil().setWidth(120)),
                                    child: Text(
                                      widget.title,
                                      textAlign: TextAlign.center,
                                      style:  context.textTheme.headlineSmall!.copyWith(
                                        color: ColorPallet().mainColor,
                                      ),
                                    ),
                                  ):  Container(),
                                  SizedBox(height: ScreenUtil().setHeight(32)),
                                  Text(
                                    widget.value,
                                    textAlign: TextAlign.center,
                                    style:  context.textTheme.bodyMedium!.copyWith(
                                      height: 1.5
                                    ),
                                  ),
                                  SizedBox(height: ScreenUtil().setHeight(100)),
                                  StreamBuilder(
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
                                                child: new Center(
                                                    child: widget.isLoadingButton != null
                                                        ? !widget.isLoadingButton ?
                                                    new Text(
                                                      widget.okText,
                                                      style: context.textTheme.labelLarge!.copyWith(
                                                        color: Colors.white,
                                                      ),
                                                    ) : new LoadingViewScreen(
                                                      color: Colors.white,
                                                      width: ScreenUtil().setWidth(35),
                                                      lineWidth: ScreenUtil().setWidth(5),
                                                    ) : new Text(
                                                      widget.okText,
                                                      style: context.textTheme.labelLarge!.copyWith(
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
                                  SizedBox(height: ScreenUtil().setHeight(30)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(50)
                              ),
                              width: ScreenUtil().setWidth(160),
                              height: ScreenUtil().setWidth(160),
                              decoration:  BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white
                              ),
                              child: Center(
                                  child: SvgPicture.asset(
                                    widget.topIcon,
                                    width: ScreenUtil().setWidth(145),
                                    height: ScreenUtil().setHeight(145),
                                    // fit: BoxFit.fill,
                                  )
                              )
                          ),
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