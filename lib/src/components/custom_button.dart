

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';

class CustomButton extends StatefulWidget{

  final onPress;
  final title;
  final center;
  final List<Color>? colors;
  final borderRadius;
  final enableButton;
  final isLoadingButton;
  final margin;
  final padding;
  final height;
  final icon;
  final borderColor;
  final textColor;
  final child;
  final TextStyle? textStyle;

  CustomButton({Key? key,this.onPress,this.title,this.center
    ,this.colors,this.borderRadius,
    this.enableButton,this.isLoadingButton,
    this.margin,this.padding,this.height,this.icon,this.borderColor,
    this.textColor,this.child,this.textStyle}):super(key:key);

  @override
  State<StatefulWidget> createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> with TickerProviderStateMixin{

  late AnimationController animationControllerScaleButton;

  Animations _animations =  Animations();


  @override
  void initState() {
    animationControllerScaleButton = _animations.pressButton(this);
    super.initState();
  }

  @override
  void dispose() {
    _animations.animationControllerScaleBackButton.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
      stream: _animations.squareScaleBackButtonObserve,
      builder: (context,AsyncSnapshot<double> snapshotScale){
        if(snapshotScale.data != null){
          return  Transform.scale(
            scale: snapshotScale.data,
            child:  GestureDetector(
              onTap: ()async{
                await animationControllerScaleButton.reverse();
                widget.onPress();
              },
              child:  Container(
                  height: widget.height != null ? widget.height : ScreenUtil().setWidth(85),
                  margin: EdgeInsets.symmetric(
                    horizontal:  ScreenUtil().setWidth(widget.margin != null ?  widget.margin :  240),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: widget.padding != null ?
                      widget.padding:   ScreenUtil().setWidth(40)
                  ),
                decoration:  BoxDecoration(
                    gradient: LinearGradient(
                        colors: widget.colors != null ?
                        widget.enableButton ? widget.colors! : [ColorPallet().gray.withOpacity(0.5),ColorPallet().gray.withOpacity(0.5)]:
                        [
                          widget.enableButton ? ColorPallet().mainColor : ColorPallet().gray.withOpacity(0.5),
                          widget.enableButton ? ColorPallet().mainColor : ColorPallet().gray.withOpacity(0.5),
                        ]
                    ),
                    border: widget.borderColor != null ?
                    Border.all(
                      color: widget.borderColor
                    ) : null,
                    borderRadius: BorderRadius.circular(widget.borderRadius != null ? widget.borderRadius : 20.0 )
                ),
                child: Center(
                    child:widget.isLoadingButton != null ?
                    widget.isLoadingButton ?
                    LoadingViewScreen(
                      color: Colors.white,
                    ) :
                        _value() :
                    _value()

                )
              ),
            ),
          );
        }else{
          return  Container();
        }
      },

    );
  }

  Widget _value(){
    return widget.child == null ?
    widget.icon != null ?
    Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            widget.icon,
            width: ScreenUtil().setWidth(45),
            height: ScreenUtil().setWidth(45),
            fit: BoxFit.cover,
          ),
          Text(
            widget.title,
            textAlign: TextAlign.center,
              style: widget.textStyle != null ?
              widget.textStyle
                  : context.textTheme.labelLarge!.copyWith(
                color: widget.textColor != null ? widget.textColor : Colors.white,
              )
          ),
        ]
    ):
    Text(
      widget.title,
      textAlign: TextAlign.center,
        style: widget.textStyle != null ?
        widget.textStyle
            : context.textTheme.labelLarge!.copyWith(
          color: widget.textColor != null ? widget.textColor : Colors.white,
        )
    ) : widget.child;
  }

}