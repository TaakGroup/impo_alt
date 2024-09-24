import 'package:flutter/material.dart';

PmsCycleColors lightPmsCycleColors =  PmsCycleColors(
  pmsGradient1: const Color(0xffBC8CF2).withOpacity(0.05),
  pmsGradient2: const Color(0xffBC8CF2),
  back: const Color(0xffF6EEFF),
  text: const Color(0xff7F47BF),
  daysGradient1: const Color(0xffE6D0FF),
  daysGradient2: const Color(0xffBC8DF2),
);

PmsCycleColors darkPmsCycleColors =  PmsCycleColors(
  pmsGradient1: const Color(0xffBC8CF2).withOpacity(0.06),
  pmsGradient2: const Color(0xff8965B1),
  back: const Color(0xff292231),
  text: const Color(0xffD4AEFF),
  daysGradient1: const Color(0xff9975C1),
  daysGradient2: const Color(0xff8841D9),
);

@immutable
class PmsCycleColors extends ThemeExtension<PmsCycleColors> {
  const PmsCycleColors({
    required this.pmsGradient1,
    required this.pmsGradient2,
    required this.back,
    required this.text,
    required this.daysGradient1,
    required this.daysGradient2,
  });

  static PmsCycleColors of(BuildContext context) => Theme.of(context).extension<PmsCycleColors>()!;

  final Color? pmsGradient1;
  final Color? pmsGradient2;
  final Color? back;
  final Color? text;
  final Color? daysGradient1;
  final Color? daysGradient2;

  @override
  PmsCycleColors copyWith({
    Color? pmsGradient1,
    Color? pmsGradient2,
    Color? back,
    Color? text,
    Color? daysGradient1,
    Color? daysGradient2,
  }) {
    return PmsCycleColors(
      pmsGradient1: pmsGradient1 ?? this.pmsGradient1,
      pmsGradient2: pmsGradient2 ?? this.pmsGradient2,
      back: back ?? this.back,
      text: text ?? this.text,
      daysGradient1: daysGradient1 ?? this.daysGradient1,
      daysGradient2: daysGradient2 ?? this.daysGradient2,
    );
  }

  @override
  PmsCycleColors lerp(ThemeExtension<PmsCycleColors>? other, double t) {
    if (other is! PmsCycleColors) {
      return this;
    }
    return PmsCycleColors(
      pmsGradient1: Color.lerp(pmsGradient1, other.pmsGradient1, t),
      pmsGradient2: Color.lerp(pmsGradient2, other.pmsGradient2, t),
      back: Color.lerp(back, other.back, t),
      text: Color.lerp(text, other.text, t),
      daysGradient1: Color.lerp(daysGradient1, other.daysGradient1, t),
      daysGradient2: Color.lerp(daysGradient2, other.daysGradient2, t),
    );
  }

  PmsCycleColors harmonized(ColorScheme dynamic) {
    return copyWith();
  }
}
