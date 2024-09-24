

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';

class ExpertButton extends StatelessWidget {
  final onPress;
  final title;
  final enableButton;
  final isLoading;
  ExpertButton({this.onPress,this.title,this.enableButton,this.isLoading});
  @override
  Widget build(BuildContext context) {
   /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return   Container(
      margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(150)
      ),
      decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
            colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],

        ),
      ),
      child:  Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child:  InkWell(
          splashColor: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
          onTap: (){
            onPress();
          },
          child:  Container(
            height: ScreenUtil().setHeight(80),
            padding: EdgeInsets.symmetric(
              vertical: isLoading ? ScreenUtil().setWidth(0) : ScreenUtil().setWidth(20),
            ),
            decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(20)
            ),
            child:  Center(
              child: isLoading ?
                   LoadingViewScreen(
                    color: Colors.white,
                  ) :
               Text(
                title,
                style:  context.textTheme.labelLarge!.copyWith(
                  color: Colors.white,
                )
              )
            )
          ),
        ),
      ),
    );
  }

}