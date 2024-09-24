import 'package:flutter/material.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'button_styles_properties.dart';
import 'button_types.dart';

class ButtonThemeStyle {
  final BuildContext context;

  ButtonThemeStyle.of(this.context);

  ButtonStyle? elevatedButtonStyle({
    ButtonColors color = ButtonColors.primary,
    ButtonSizes size = ButtonSizes.medium,
    bool wide = false,
  }) {
    return Theme.of(context).elevatedButtonTheme.style?.copyWith(
          iconSize: MaterialStateProperty.all(buttonIconSize(size)),
          padding: MaterialStateProperty.all(buttonPadding(size, isLtr: context.isLtr)),
          textStyle: MaterialStateProperty.all(buttonTextStyle(context, size)),
          foregroundColor: MaterialStateProperty.resolveWith((states) => elevatedForegroundColor(context, color, states)),
          backgroundColor: MaterialStateProperty.resolveWith((states) => elevatedBackgroundColor(context, color, states)),
          overlayColor: MaterialStateProperty.resolveWith((states) => elevatedOverlayColor(context, color, states)),
          minimumSize: MaterialStateProperty.all((wide ? wideSize(size) : Size.zero)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(buttonBorderRadius(size, wide))))),
        );
  }

  ButtonStyle? outlineButtonStyle({
    ButtonColors color = ButtonColors.primary,
    ButtonSizes size = ButtonSizes.medium,
    bool wide = false,
  }) {
    return Theme.of(context).outlinedButtonTheme.style?.copyWith(
          padding: MaterialStateProperty.all(buttonPadding(size, isLtr: context.isLtr)),
          textStyle: MaterialStateProperty.all(buttonTextStyle(context, size)),
          foregroundColor: MaterialStateProperty.resolveWith((states) => outlineForegroundColor(context, color, states)),
          minimumSize: MaterialStateProperty.all(wide ? wideSize(size) : Size.zero),
          overlayColor: MaterialStateProperty.resolveWith((states) => overlayColor(context, color, states)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(buttonBorderRadius(size, wide))))),
          side: MaterialStateProperty.resolveWith(
            (states) => BorderSide(
              color: buttonBorderSideColor(context, color, states),
              width: buttonBorderSideWidth(size),
            ),
          ),
        );
  }

  ButtonStyle? textButtonStyle({
    ButtonColors color = ButtonColors.primary,
    ButtonSizes size = ButtonSizes.medium,
    bool wide = false,
  }) {
    return Theme.of(context).textButtonTheme.style?.copyWith(
          padding: MaterialStateProperty.all(buttonPadding(size, isLtr: context.isLtr)),
          textStyle: MaterialStateProperty.all(buttonTextStyle(context, size)),
          foregroundColor: MaterialStateProperty.resolveWith((states) => textButtonForegroundColor(context, color, states)),
          minimumSize: MaterialStateProperty.all(wide ? wideSize(size) : Size.zero),
          overlayColor: MaterialStateProperty.resolveWith((states) => overlayColor(context, color, states)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(buttonBorderRadius(size, wide))))),
        );
  }
}