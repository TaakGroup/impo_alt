import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';

class BottomSheetBackground extends StatelessWidget {
  final double height;
  final String title;
  final Widget widget;
  final bool? isWarning;
  final bool? enableBackButton;
  final Color? backgroundColor;
  final Color? upperLineColor;
  final Color? titleColor;

  const BottomSheetBackground({
    Key? key,
    required this.widget,
    required this.title,
    required this.height,
    this.isWarning,
    this.enableBackButton,
    this.backgroundColor,
    this.upperLineColor,
    this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => enableBackButton ?? true,
      child: Container(
        height: height,
        color: backgroundColor ?? context.theme.colorScheme.surfaceVariant,
        child: Column(
          children: [
            SizedBox(
              width: 54,
              child: Divider(
                thickness: 3.5,
                color: upperLineColor ?? context.colorScheme.surface,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              title,
              style: context.theme.textTheme.titleSmall!.copyWith(
                color: titleColor ?? ((isWarning ?? false) ? context.colorScheme.error : context.colorScheme.onBackground),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(child: widget),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
