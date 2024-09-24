import 'package:flutter/material.dart';

final ThemeData _baseLightTheme = ThemeData.light();

final ThemeData _baseDarkTheme = ThemeData.dark();


ColorScheme lightColorScheme = _baseLightTheme.colorScheme.copyWith(
  brightness: Brightness.light,
  primary: const Color(0xFFD32398),
  onPrimary: const Color(0xFFFFFFFF),
  primaryContainer: const Color(0xFFF2DAFF),
  onPrimaryContainer: const Color(0xFF6307A5),
  secondary: const Color(0xFFF1C100),
  onSecondary: const Color(0xFF151102),
  secondaryContainer: const Color(0xFFFFE9AE),
  onSecondaryContainer: const Color(0xFF584400),
  error: const Color(0xFFBA1A1A),
  errorContainer: const Color(0xFFFFDAD6),
  onError: const Color(0xFFFFFFFF),
  onErrorContainer: const Color(0xFF410002),
  background: const Color(0xFFFFFBFF),
  onBackground: const Color(0xFF1D1B1E),
    surface: const Color(0xFFEFEFEF),
    onSurface: const Color(0xFF1D1A22),
    surfaceVariant: const Color(0xFFF9F9F9),
    onSurfaceVariant: const Color(0xFF48464A),
    outline: const Color(0xFF938F94),
    onInverseSurface: const Color(0xff5B595C),
    outlineVariant: const Color(0xffD9D9D9),
    inverseSurface: const Color(0xff313033)
);

ColorScheme darkColorScheme = _baseDarkTheme.colorScheme.copyWith(
  brightness: Brightness.dark,
  primary: const Color(0xFFFFB1C2),
  onPrimary: const Color(0xFF880E4F),
  primaryContainer: const Color(0xFFFF63A7),
  onPrimaryContainer: const Color(0xFFFFECEE),
  inversePrimary: const Color(0xffB80F55),
  secondary: const Color(0xFFFFDF9E),
  onSecondary: const Color(0xFF261A00),
  secondaryContainer: const Color(0xFFF9BD10),
  onSecondaryContainer: const Color(0xFFFFEFD4),
  error: const Color(0xFFFFB4AB),
  errorContainer: const Color(0xFF93000A),
  onError: const Color(0xFF690005),
  onErrorContainer: const Color(0xFFFFDAD6),
  background: const Color(0xFF1C1B1E),
  onBackground: const Color(0xFFFFFBFF),
  surface: const Color(0xFF252329),
  onSurface: const Color(0xFFF4EFF4),
  surfaceVariant: const Color(0xFF313033),
  onSurfaceVariant: const Color(0xFFF4EFF4),
  outline: const Color(0xFF938F94),
  onInverseSurface: const Color(0xff1C1B1E),
  outlineVariant: const Color(0xff3C3A3A),
);
