import 'package:flutter/material.dart';

PrimaryPalette primaryPalette = PrimaryPalette(
  primary0: const Color(0xff000000),
  primary10: const Color(0xff3F0013),
  primary20: const Color(0xff66002B),
  primary30: const Color(0xff8F003F),
  primary40: const Color(0xffB80F55),
  primary50: const Color(0xffDB326E),
  primary60: const Color(0xffFD4E87),
  primary70: const Color(0xffFF85A4),
  primary80: const Color(0xffFFB1CD),
  primary90: const Color(0xffFFD9DF),
  primary95: const Color(0xffFFECEE),
  primary99: const Color(0xffFFFBFF),
  primary100: const Color(0xffFFFFFF),
);

class PrimaryPalette extends ThemeExtension<PrimaryPalette> {
  final Color? primary0;
  final Color? primary10;
  final Color? primary20;
  final Color? primary30;
  final Color? primary40;
  final Color? primary50;
  final Color? primary60;
  final Color? primary70;
  final Color? primary80;
  final Color? primary90;
  final Color? primary95;
  final Color? primary99;
  final Color? primary100;

  PrimaryPalette({
    required this.primary0,
    required this.primary10,
    required this.primary20,
    required this.primary30,
    required this.primary40,
    required this.primary50,
    required this.primary60,
    required this.primary70,
    required this.primary80,
    required this.primary90,
    required this.primary95,
    required this.primary99,
    required this.primary100,
  });

  static PrimaryPalette of(BuildContext context) => Theme.of(context).extension<PrimaryPalette>()!;

  @override
  ThemeExtension<PrimaryPalette> copyWith({
    Color? primary0,
    Color? primary10,
    Color? primary20,
    Color? primary30,
    Color? primary40,
    Color? primary50,
    Color? primary60,
    Color? primary70,
    Color? primary80,
    Color? primary90,
    Color? primary95,
    Color? primary99,
    Color? primary100,
  }) {
    return PrimaryPalette(
      primary0: primary0 ?? this.primary0,
      primary10: primary10 ?? this.primary10,
      primary20: primary20 ?? this.primary20,
      primary30: primary30 ?? this.primary30,
      primary40: primary40 ?? this.primary40,
      primary50: primary50 ?? this.primary50,
      primary60: primary60 ?? this.primary60,
      primary70: primary70 ?? this.primary70,
      primary80: primary80 ?? this.primary80,
      primary90: primary90 ?? this.primary90,
      primary95: primary95 ?? this.primary95,
      primary99: primary99 ?? this.primary99,
      primary100: primary100 ?? this.primary100,
    );
  }

  @override
  ThemeExtension<PrimaryPalette> lerp(covariant ThemeExtension<PrimaryPalette>? other, double t) {
    if (other is! PrimaryPalette) return this;

    return PrimaryPalette(
      primary0: Color.lerp(primary0, other.primary0, t),
      primary10: Color.lerp(primary10, other.primary10, t),
      primary20: Color.lerp(primary20, other.primary20, t),
      primary30: Color.lerp(primary30, other.primary30, t),
      primary40: Color.lerp(primary40, other.primary40, t),
      primary50: Color.lerp(primary50, other.primary50, t),
      primary60: Color.lerp(primary60, other.primary60, t),
      primary70: Color.lerp(primary70, other.primary70, t),
      primary80: Color.lerp(primary80, other.primary80, t),
      primary90: Color.lerp(primary90, other.primary90, t),
      primary95: Color.lerp(primary95, other.primary95, t),
      primary99: Color.lerp(primary99, other.primary99, t),
      primary100: Color.lerp(primary100, other.primary100, t),
    );
  }
}
