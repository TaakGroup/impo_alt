import 'package:flutter/material.dart';

class ImpoTextTheme extends TextTheme {
  ImpoTextTheme()
      : super(
          // DISPLAY
          displayLarge: const TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            //height: 0.05,
            letterSpacing: -1.12,
          ),
          displayMedium: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            //height: 0.07,
            letterSpacing: -0.88,
          ),
          displaySmall: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            //height: 0.07,
            letterSpacing: -0.80,
          ),
          // HEADLINE
          headlineLarge: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 20,
            letterSpacing: -0.80,
            //height: 29 / 20,
          ),
          headlineMedium: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            //height: 0.09,
            letterSpacing: -0.33,
          ),
          headlineSmall: const TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.w700,
            //height: 0.11,
            letterSpacing: -0.28,
          ),

          /// TITLE
          titleLarge: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            //height: 0.06,
            letterSpacing: -0.36,
          ),
          titleMedium: const TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.w600,
            //height: 0.07,
            letterSpacing: -0.28,
          ),
          titleSmall: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            //height: 0.09,
            letterSpacing: -0.24,
          ),

          /// BODY
          bodyLarge: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            //height: 0.13,
            letterSpacing: -0.23,
          ),
          bodyMedium: const TextStyle(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            //height: 0.12,
            letterSpacing: -0.33,
          ),
          bodySmall: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.5,
            letterSpacing: -0.30,
          ),

          /// LABEL
          labelLarge: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            //height: 0.09,
            letterSpacing: -0.38,
          ),
          labelMedium: const TextStyle(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            //height: 0.09,
            letterSpacing: -0.20,
          ),
          labelSmall: const TextStyle(
            color: Colors.black,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            //height: 0.12,
            letterSpacing: -0.17,
          ),
        );
}

extension ExtraTextTheme on TextTheme {
  TextStyle? get labelLargeProminent {
    return const TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.w700,
      //height: 0.09,
      letterSpacing: -0.15,
    );
  }

  TextStyle? get labelMediumProminent {
    return const TextStyle(
      color: Colors.black,
      fontSize: 13,
      fontWeight: FontWeight.w700,
      //height: 0.12,
      letterSpacing: -0.20,
    );
  }

  TextStyle? get labelSmallProminent {
    return const TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      //height: 0.11,
      letterSpacing: -0.18,
    );
  }
}
