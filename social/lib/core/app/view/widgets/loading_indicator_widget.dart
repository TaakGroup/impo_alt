import 'package:flutter/material.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final double? height, width;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final bool isShow;

  const LoadingIndicatorWidget({
    Key? key,
    this.height = 25,
    this.width,
    this.color,
    this.padding,
    this.isShow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isShow) return SizedBox(height: height);

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: SizedBox(
        height: height,
        child: LoadingIndicator(
          indicatorType: Indicator.ballPulse,
          colors: [color ?? context.colorScheme.surfaceVariant],
          strokeWidth: 2,
        ),
      ),
    );
  }
}
