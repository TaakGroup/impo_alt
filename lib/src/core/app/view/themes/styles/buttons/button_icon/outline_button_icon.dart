import 'package:flutter/material.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import '../button_styles_properties.dart';
import '../button_theme_style.dart';
import '../button_types.dart';

class OutlinedButtonIcon extends StatelessWidget {
  final ButtonColors color;
  final ButtonSizes size;
  final bool wide;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final MaterialStatesController? statesController;
  final Widget label;
  final Widget icon;

  const OutlinedButtonIcon({
    Key? key,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.statesController,
    required this.label,
    required this.icon,
    this.color = ButtonColors.primary,
    this.size = ButtonSizes.medium,
    this.wide = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonThemeStyle.of(context).outlineButtonStyle(size: size, color: color, wide: wide)?.copyWith(padding: MaterialStateProperty.all(buttonPadding(size, icon: true, isLtr: context.isLtr))),
      onFocusChange: onFocusChange,
      onHover: onHover,
      onLongPress: onLongPress,
      statesController: statesController,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: buttonIconGap(size)),
          label,
        ],
      ),
    );
  }
}