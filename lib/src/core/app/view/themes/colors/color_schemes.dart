import 'package:flutter/material.dart';

final ThemeData _baseLightTheme = ThemeData.light();


final ColorScheme lightColorScheme = _baseLightTheme.colorScheme.copyWith(
  brightness: Brightness.light,
  primary: const Color(0xFFEC407A),
  onPrimary: const Color(0xFFFFFFFF),
  primaryContainer: const Color(0xFFEC407A),
  onPrimaryContainer: const Color(0xFFFFFFFF),
  // inversePrimary: const Color(0xFFDFEBFA),
  secondary: const Color(0xFF5389DE),
  // onSecondary: const Color(0xFFFFFFFF),
  // secondaryContainer: const Color(0xFFF9BD10),
  // onSecondaryContainer: const Color(0xFFFFFBFF),
  error: const Color(0xFFE11900),
  errorContainer: const Color(0xFFFFFFFF),
  onError: const Color(0xFFFFEFED),
  onErrorContainer: const Color(0xFF410002),
  background: const Color(0xFFFFFFFF),
  onBackground: const Color(0xFF1C1B1E),
  surface: const Color(0xFFEFEFEF),
  onSurface: const Color(0xFF1D1A22),
  surfaceContainerHighest: const Color(0xFFF9F9F9),
  surfaceVariant: const Color(0xFFF9F9F9),
  onSurfaceVariant: const Color(0xFF48464A),
  outline: const Color(0xFF938F94),
  onInverseSurface: const Color(0xff5B595C),
  outlineVariant: const Color(0xffD9D9D9),
  inverseSurface: const Color(0xff313033),
);

