import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final BoxBorder? border;
  final void Function()? onTap;
  final Widget? child;
  final Color? color;
  final EdgeInsets? margin;
  final double? paddingValue;

  const CircleButton({
    Key? key,
    this.border,
    this.onTap,
    this.child,
    this.color,
    this.margin,
    this.paddingValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(paddingValue ?? 8),
          constraints: const BoxConstraints(maxWidth: 40, minWidth: 40),
          decoration: BoxDecoration(shape: BoxShape.circle, color: color, border: border),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
