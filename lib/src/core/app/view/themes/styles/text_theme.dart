import 'package:flutter/material.dart';

const double scale = 1.25;

class ImpoTextTheme extends TextTheme {
  ImpoTextTheme()
      : super(
    // DISPLAY
    // displayLarge: TextStyle(
    //   color: Colors.black,
    //   fontSize: 28,
    //   fontWeight: FontWeight.w700,
    //   //height: 0.05,
    //   letterSpacing: -1.12,
    // ),
    // displayMedium: TextStyle(
    //   color: Colors.black,
    //   fontSize: 22,
    //   fontWeight: FontWeight.w700,
    //   //height: 0.07,
    //   letterSpacing: -0.88,
    // ),
    // displaySmall: TextStyle(
    //   color: Colors.black,
    //   fontSize: 20,
    //   fontWeight: FontWeight.w600,
    //   //height: 0.07,
    //   letterSpacing: -0.80,
    // ),
    /// HEADLINE
    // headlineLarge: TextStyle(
    //   color: colorScheme.onBackground,
    //   fontWeight: FontWeight.w300,
    //   fontSize: 20,
    //   letterSpacing: -0.80,
    //   //height: 29 / 20,
    // ),
    headlineMedium: TextStyle(
      color: Colors.black,
      fontSize: 22*scale,
      fontWeight: FontWeight.w700,
      //height: 0.09,
      letterSpacing: -0.33,
    ),
    headlineSmall: TextStyle(
      color: Colors.black,
      fontSize: 19*scale,
      fontWeight: FontWeight.w700,
      //height: 0.11,
      letterSpacing: -0.28,
    ),

    /// TITLE
    titleLarge: TextStyle(
      color: Colors.black,
      fontSize: 24*scale,
      fontWeight: FontWeight.w600,
      //height: 0.06,
      letterSpacing: -0.36,
    ),
    titleMedium: TextStyle(
      color: Colors.black,
      fontSize: 19*scale,
      fontWeight: FontWeight.w600,
      //height: 0.07,
      letterSpacing: -0.28,
    ),
    titleSmall: TextStyle(
      color: Colors.black,
      fontSize: 16*scale,
      fontWeight: FontWeight.w600,
      //height: 0.09,
      letterSpacing: -0.24,
    ),

    /// BODY
    bodyLarge: TextStyle(
      color: Colors.black,
      fontSize: 15*scale,
      fontWeight: FontWeight.w400,
      //height: 0.13,
      letterSpacing: -0.23,
    ),
    bodyMedium: TextStyle(
      color: Colors.black,
      fontSize: 13*scale,
      fontWeight: FontWeight.w400,
      //height: 0.12,
      letterSpacing: -0.33,
    ),
    bodySmall: TextStyle(
      color: Colors.black,
      fontSize: 12*1.14,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: -0.30,
    ),

    /// LABEL
    labelLarge: TextStyle(
      color: Colors.black,
      fontSize: 15*1.125,
      fontWeight: FontWeight.w600,
      //height: 0.09,
      letterSpacing: -0.38,
    ),
    labelMedium: TextStyle(
      color: Colors.black,
      fontSize: 13*1.125,
      fontWeight: FontWeight.w600,
      //height: 0.09,
      letterSpacing: -0.20,
    ),
    labelSmall: TextStyle(
      color: Colors.black,
      fontSize: 11*1.125,
      fontWeight: FontWeight.w600,
      //height: 0.12,
      letterSpacing: -0.17,
    ),
  );
}

extension ExtraTextTheme on TextTheme{

  TextStyle? get labelLargeProminent{
    return TextStyle(
      color: Colors.black,
      fontSize: 15*scale,
      fontWeight: FontWeight.w700,
      //height: 0.09,
      letterSpacing: -0.15,
    );
  }

  TextStyle? get labelMediumProminent{
    return TextStyle(
      color: Colors.black,
      fontSize: 13*scale,
      fontWeight: FontWeight.w700,
      //height: 0.12,
      letterSpacing: -0.20,
    );
  }

  TextStyle? get labelSmallProminent{
    return TextStyle(
      color: Colors.black,
      fontSize: 12*scale,
      fontWeight: FontWeight.w600,
      //height: 0.11,
      letterSpacing: -0.18,
    );
  }

}
