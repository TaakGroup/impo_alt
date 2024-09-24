import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:get/get.dart';


class BaseBottomSheet extends StatefulWidget {
  final String? title;
  final Widget? content;
  final Function()? onPress;

  BaseBottomSheet({
    @required this.title,
    @required this.content,
    this.onPress,
  });

  @override
  State<BaseBottomSheet> createState() => BaseBottomSheetState();
}

class BaseBottomSheetState extends State<BaseBottomSheet> {

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().setWidth(10)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setWidth(15)),
              height: ScreenUtil().setWidth(5),
              width: ScreenUtil().setWidth(100),
              decoration: BoxDecoration(
                  color: Color(0xff707070).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15)),
            ),
            widget.title != '' ?
            Container(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(30),
                    vertical: ScreenUtil().setWidth(30)),
                child: Text(
                  widget.title!,
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: ColorPallet().gray,
                  ),
                )) : Container(width: 0,height: 0,),
            Container(child: widget.content),
            CustomButton(
              title: 'تایید',
              onPress: widget.onPress,
              margin: 240,
              colors: [
                ColorPallet().mentalHigh,
                ColorPallet().mentalMain
              ],
              borderRadius: 10.0,
              enableButton: true,
            ),
            SizedBox(
              height: ScreenUtil().setWidth(40),
            )
          ],
        ),
      ),
    );
  }
}
