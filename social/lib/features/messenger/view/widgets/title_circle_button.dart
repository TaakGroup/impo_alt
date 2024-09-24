import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../core/app/view/widgets/circle_button_widget.dart';

class TitleCircleButton extends StatelessWidget {
  final String title;
  final String iconPath;
  final Color backgroundColor;
  final Color titleColor;
  final Color? iconColor;
  final void Function() onPressed;
  final double? height;
  final double? width;

  const TitleCircleButton(
      {Key? key,
      required this.title,
      required this.iconPath,
      required this.backgroundColor,
      required this.titleColor,
      this.iconColor,
      required this.onPressed,
      this.height,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleButton(
            paddingValue: 10,
            color: backgroundColor,
            onTap: onPressed,
            child: SvgPicture.asset(
              iconPath,
              width: 28,
              height: 28,
              color: titleColor,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            title,
            style: context.textTheme.labelSmall!.copyWith(color: iconColor ?? titleColor),
          ),
        ],
      ),
    );
  }
}

class TitleButtonData {
  final void Function() onPressed;
  final String iconPath;
  final String title;

  const TitleButtonData({Key? key, required this.onPressed, required this.iconPath, required this.title});
}
