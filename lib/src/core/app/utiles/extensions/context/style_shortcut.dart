import 'package:flutter/material.dart';
import 'package:impo/src/core/app/view/themes/styles/buttons/button_theme_style.dart';

extension StyleShortcut on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // TextTheme get textTheme => Theme.of(this).textTheme;

  ButtonThemeStyle get buttonThemes => ButtonThemeStyle.of(this);

  bool get isLtr => Directionality.of(this) == TextDirection.ltr;
}