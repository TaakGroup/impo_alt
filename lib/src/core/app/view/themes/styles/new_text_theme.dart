import 'package:flutter/material.dart';
import 'package:impo/src/core/app/view/themes/theme.dart';

class NewImpoTextTheme extends TextTheme {
  NewImpoTextTheme()
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
          headlineLarge: TextStyle(
            color: Colors.black,
            fontSize: 48,
            fontWeight: FontWeight.w700,
            fontFamily: ImpoTheme.fontFamily,
            letterSpacing: -0.72,
            //height: 29 / 20,
          ),
          headlineMedium: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            fontFamily: ImpoTheme.fontFamily,
            //height: 0.09,
            letterSpacing: -0.33,
          ),
          headlineSmall: TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.w700,
            fontFamily: ImpoTheme.fontFamily,
            //height: 0.11,
            letterSpacing: -0.28,
          ),

          /// TITLE
          titleLarge: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: ImpoTheme.fontFamily,
            //height: 0.06,
            letterSpacing: -0.36,
          ),
          titleMedium: TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.w600,
            fontFamily: ImpoTheme.fontFamily,
            //height: 0.07,
            letterSpacing: -0.28,
          ),
          titleSmall: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: ImpoTheme.fontFamily,
            //height: 0.09,
            letterSpacing: -0.24,
          ),

    /// BODY
    bodyLarge: TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      fontFamily: ImpoTheme.fontFamily,
      //height: 0.13,
      letterSpacing: -0.23,
    ),
    bodyMedium: TextStyle(
      color: Colors.black,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      fontFamily: ImpoTheme.fontFamily,
      //height: 0.12,
      letterSpacing: -0.33,
    ),
    bodySmall: TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: ImpoTheme.fontFamily,
      height: 1.5,
      letterSpacing: -0.30,
    ),

    /// LABEL
    labelLarge: TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      fontFamily: ImpoTheme.fontFamily,
      //height: 0.09,
      letterSpacing: -0.38,
    ),
    labelMedium: TextStyle(
      color: Colors.black,
      fontSize: 13,
      fontWeight: FontWeight.w600,
      fontFamily: ImpoTheme.fontFamily,
      //height: 0.09,
      letterSpacing: -0.20,
    ),
    labelSmall: TextStyle(
      color: Colors.black,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      fontFamily: ImpoTheme.fontFamily,
      //height: 0.12,
      letterSpacing: -0.17,
    ),
  );
}

extension ExtraTextTheme on TextTheme {
  TextStyle? get labelLargeProminent {
    return TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.w700,
      fontFamily: ImpoTheme.fontFamily,
      //height: 0.09,
      letterSpacing: -0.15,
    );
  }

  TextStyle? get labelMediumProminent {
    return TextStyle(
      color: Colors.black,
      fontSize: 13,
      fontWeight: FontWeight.w700,
      fontFamily: ImpoTheme.fontFamily,
      //height: 0.12,
      letterSpacing: -0.20,
    );
  }

  TextStyle? get labelSmallProminent {
    return TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      fontFamily: ImpoTheme.fontFamily,
      //height: 0.11,
      letterSpacing: -0.18,
    );
  }
}
