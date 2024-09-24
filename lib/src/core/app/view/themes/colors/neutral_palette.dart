import 'package:flutter/material.dart';

NeutralPalette neutralPalette = NeutralPalette(
  neutral0: const Color(0xff000000),
  neutral10: const Color(0xff1C1B1E),
  neutral20: const Color(0xff313033),
  neutral30: const Color(0xff48464A),
  neutral40: const Color(0xff605D62),
  neutral50: const Color(0xff79767A),
  neutral60: const Color(0xff938F94),
  neutral70: const Color(0xffAEAAAE),
  neutral80: const Color(0xffCAC5CA),
  neutral90: const Color(0xffE6E1E6),
  neutral95: const Color(0xffF4EFF4),
  neutral99: const Color(0xffFFFBFF),
  neutral100: const Color(0xffFFFFFF),
);

class NeutralPalette extends ThemeExtension<NeutralPalette> {
  final Color? neutral0;
  final Color? neutral10;
  final Color? neutral20;
  final Color? neutral30;
  final Color? neutral40;
  final Color? neutral50;
  final Color? neutral60;
  final Color? neutral70;
  final Color? neutral80;
  final Color? neutral90;
  final Color? neutral95;
  final Color? neutral99;
  final Color? neutral100;

  NeutralPalette({
    required this.neutral0,
    required this.neutral10,
    required this.neutral20,
    required this.neutral30,
    required this.neutral40,
    required this.neutral50,
    required this.neutral60,
    required this.neutral70,
    required this.neutral80,
    required this.neutral90,
    required this.neutral95,
    required this.neutral99,
    required this.neutral100,
  });

  static NeutralPalette of(BuildContext context) => Theme.of(context).extension<NeutralPalette>()!;

  @override
  ThemeExtension<NeutralPalette> copyWith({
    Color? neutral0,
    Color? neutral10,
    Color? neutral20,
    Color? neutral30,
    Color? neutral40,
    Color? neutral50,
    Color? neutral60,
    Color? neutral70,
    Color? neutral80,
    Color? neutral90,
    Color? neutral95,
    Color? neutral99,
    Color? neutral100,
  }) {
    return NeutralPalette(
      neutral0: neutral0 ?? this.neutral0,
      neutral10: neutral10 ?? this.neutral10,
      neutral20: neutral20 ?? this.neutral20,
      neutral30: neutral30 ?? this.neutral30,
      neutral40: neutral40 ?? this.neutral40,
      neutral50: neutral50 ?? this.neutral50,
      neutral60: neutral60 ?? this.neutral60,
      neutral70: neutral70 ?? this.neutral70,
      neutral80: neutral80 ?? this.neutral80,
      neutral90: neutral90 ?? this.neutral90,
      neutral95: neutral95 ?? this.neutral95,
      neutral99: neutral99 ?? this.neutral99,
      neutral100: neutral100 ?? this.neutral100,
    );
  }

  @override
  ThemeExtension<NeutralPalette> lerp(covariant ThemeExtension<NeutralPalette>? other, double t) {
    if (other is! NeutralPalette) return this;

    return NeutralPalette(
      neutral0: Color.lerp(neutral0, other.neutral0, t),
      neutral10: Color.lerp(neutral10, other.neutral10, t),
      neutral20: Color.lerp(neutral20, other.neutral20, t),
      neutral30: Color.lerp(neutral30, other.neutral30, t),
      neutral40: Color.lerp(neutral40, other.neutral40, t),
      neutral50: Color.lerp(neutral50, other.neutral50, t),
      neutral60: Color.lerp(neutral60, other.neutral60, t),
      neutral70: Color.lerp(neutral70, other.neutral70, t),
      neutral80: Color.lerp(neutral80, other.neutral80, t),
      neutral90: Color.lerp(neutral90, other.neutral90, t),
      neutral95: Color.lerp(neutral95, other.neutral95, t),
      neutral99: Color.lerp(neutral99, other.neutral99, t),
      neutral100: Color.lerp(neutral100, other.neutral100, t),
    );
  }
}
