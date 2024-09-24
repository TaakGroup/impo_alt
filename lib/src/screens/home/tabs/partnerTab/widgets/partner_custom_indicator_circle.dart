import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PartnerCustomIndicatorCircle extends StatelessWidget {
  final void Function()? onPressed;
  final double? size;
  final Color? color;
  final bool? isSelected;

  const PartnerCustomIndicatorCircle({Key? key, this.onPressed, this.size, this.color,this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin:  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(3)),
        height: size ?? ScreenUtil().setWidth(10),
        width: size ?? ScreenUtil().setWidth(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected!
              ? (color ?? Color(0xff323232))
              : (color ?? Color(0xffD9D9D9)),
        ),
      ),
    );
  }
}
