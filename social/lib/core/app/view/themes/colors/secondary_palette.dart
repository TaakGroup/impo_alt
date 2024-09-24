import 'package:flutter/material.dart';

SecondaryPalette secondaryPalette = SecondaryPalette(
  secondary0: const Color(0xff000000),
  secondary10: const Color(0xff261A00),
  secondary20: const Color(0xff3F2E00),
  secondary30: const Color(0xff5B4300),
  secondary40: const Color(0xff795900),
  secondary50: const Color(0xff977100),
  secondary60: const Color(0xffB78A00),
  secondary70: const Color(0xffD8A300),
  secondary80: const Color(0xffF9BD10),
  secondary90: const Color(0xffFFDF9E),
  secondary95: const Color(0xffFFEFD4),
  secondary99: const Color(0xffFFFBFF),
  secondary100: const Color(0xffFFFFFF),
);

class SecondaryPalette extends ThemeExtension<SecondaryPalette> {
  final Color? secondary0;
  final Color? secondary10;
  final Color? secondary20;
  final Color? secondary30;
  final Color? secondary40;
  final Color? secondary50;
  final Color? secondary60;
  final Color? secondary70;
  final Color? secondary80;
  final Color? secondary90;
  final Color? secondary95;
  final Color? secondary99;
  final Color? secondary100;

  SecondaryPalette({
    required this.secondary0,
    required this.secondary10,
    required this.secondary20,
    required this.secondary30,
    required this.secondary40,
    required this.secondary50,
    required this.secondary60,
    required this.secondary70,
    required this.secondary80,
    required this.secondary90,
    required this.secondary95,
    required this.secondary99,
    required this.secondary100,
  });

  static SecondaryPalette of(BuildContext context) => Theme.of(context).extension<SecondaryPalette>()!;

  @override
  ThemeExtension<SecondaryPalette> copyWith({
    Color? secondary0,
    Color? secondary10,
    Color? secondary20,
    Color? secondary30,
    Color? secondary40,
    Color? secondary50,
    Color? secondary60,
    Color? secondary70,
    Color? secondary80,
    Color? secondary90,
    Color? secondary95,
    Color? secondary99,
    Color? secondary100,
  }) {
    return SecondaryPalette(
      secondary0: secondary0 ?? this.secondary0,
      secondary10: secondary10 ?? this.secondary10,
      secondary20: secondary20 ?? this.secondary20,
      secondary30: secondary30 ?? this.secondary30,
      secondary40: secondary40 ?? this.secondary40,
      secondary50: secondary50 ?? this.secondary50,
      secondary60: secondary60 ?? this.secondary60,
      secondary70: secondary70 ?? this.secondary70,
      secondary80: secondary80 ?? this.secondary80,
      secondary90: secondary90 ?? this.secondary90,
      secondary95: secondary95 ?? this.secondary95,
      secondary99: secondary99 ?? this.secondary99,
      secondary100: secondary100 ?? this.secondary100,
    );
  }

  @override
  ThemeExtension<SecondaryPalette> lerp(covariant ThemeExtension<SecondaryPalette>? other, double t) {
    if (other is! SecondaryPalette) return this;

    return SecondaryPalette(
      secondary0: Color.lerp(secondary0, other.secondary0, t),
      secondary10: Color.lerp(secondary10, other.secondary10, t),
      secondary20: Color.lerp(secondary20, other.secondary20, t),
      secondary30: Color.lerp(secondary30, other.secondary30, t),
      secondary40: Color.lerp(secondary40, other.secondary40, t),
      secondary50: Color.lerp(secondary50, other.secondary50, t),
      secondary60: Color.lerp(secondary60, other.secondary60, t),
      secondary70: Color.lerp(secondary70, other.secondary70, t),
      secondary80: Color.lerp(secondary80, other.secondary80, t),
      secondary90: Color.lerp(secondary90, other.secondary90, t),
      secondary95: Color.lerp(secondary95, other.secondary95, t),
      secondary99: Color.lerp(secondary99, other.secondary99, t),
      secondary100: Color.lerp(secondary100, other.secondary100, t),
    );
  }
}
