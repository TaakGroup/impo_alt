import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import '../../constants/assets_paths.dart';

class PageStepProgress extends StatelessWidget {
  final double? spaceBetween;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? dividerColor;
  final double? height;
  final double progressAmount;
  final Radius? radius;
  final int totalSteps;

  const PageStepProgress({
    Key? key,
    this.spaceBetween,
    this.activeColor,
    this.inactiveColor,
    this.height,
    this.radius,
    required this.totalSteps,
    required this.progressAmount,
    this.dividerColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            for (int i = 0; i < totalSteps; i++)
              Expanded(
                child: PageStepWidget(
                  height: height,
                  radius: radius,
                  color: inactiveColor,
                ),
              ),
          ],
        ),
        Row(
          children: [
            Hero(
              tag: '_PROGRESS_',
              child: PageStepWidget(
                height: height,
                width: progressAmount,
                color: activeColor ?? context.colorScheme.outline,
                radius: radius,
              ),
            ),
          ],
        ),
        Hero(
          tag: "_DIVIDER_",
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (int i = 0; i < totalSteps - 1; i++)
                SvgPicture.asset(
                  AssetPaths.stepDivider,
                  height: height ?? 8,
                  colorFilter: ColorFilter.mode(
                    dividerColor ?? context.theme.scaffoldBackgroundColor,
                    BlendMode.srcIn,
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}

class PageStepWidget extends StatelessWidget {
  final Color? color;
  final double? height;
  final double? width;
  final Radius? radius;

  const PageStepWidget({
    Key? key,
    this.color,
    this.height,
    this.radius,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 8,
      decoration: BoxDecoration(
        color: color ?? context.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.all(radius ?? const Radius.circular(20)),
      ),
    );
  }
}
