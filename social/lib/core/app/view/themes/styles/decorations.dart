import 'package:flutter/material.dart';

class Decorations {
  static const inputBorderRadius = BorderRadius.all(Radius.circular(24));
  static const double inputStrokeWidth = 1.0;

  static const cartRadius = BorderRadius.all(Radius.circular(16));

  static const buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(90)));
  static const pagePaddingHorizontal = EdgeInsets.symmetric(horizontal: 16);

  static const double mainAppbarHeight = 55.0;
  static const double paddingHorizontal = 16.0;

  static TextStyle subtitle = const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.40,
  );
}
