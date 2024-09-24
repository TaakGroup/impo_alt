import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/components/colors.dart';
import 'package:get/get.dart';


class BottomTextRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Row(
      textDirection: TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'I',
          style: context.textTheme.titleMedium,
        ),
        SizedBox(width: ScreenUtil().setWidth(7)),
        Text(
          ' am ',
          style: context.textTheme.titleMedium,
        ),
        SizedBox(width: ScreenUtil().setWidth(6)),
        Text(
          ' Important',
          style: context.textTheme.titleMedium!.copyWith(
            color: ColorPallet().mainColor
          )
        )
      ],
    );
  }
}
