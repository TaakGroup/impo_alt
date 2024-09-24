import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';

class CircleCheckRadioWidget extends StatelessWidget {
  final bool? isSelected;
  final void Function()? onTap;

  const CircleCheckRadioWidget({Key? key,this.isSelected, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
        height: ScreenUtil().setWidth(30),
        width: ScreenUtil().setWidth(30),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected! ?
            context.colorScheme.primary:
            context.colorScheme.outlineVariant,
            width: ScreenUtil().setWidth(2)
          ),
        ),
        child: isSelected!
            ? Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colorScheme.primary
          ),
        )
            : const SizedBox.shrink(),
      ),
    );
  }
}
