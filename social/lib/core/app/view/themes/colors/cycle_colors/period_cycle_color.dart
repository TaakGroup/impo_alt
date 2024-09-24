import 'package:flutter/material.dart';
import '../color_schemes.dart';

PeriodCycleColors lightPeriodCycleColors =  PeriodCycleColors(
  periodGradient1: const Color(0xffFF6FB5).withOpacity(0.05),
  periodGradient2: const Color(0xffFF6FB5),
  back: lightColorScheme.background,
  text: const Color(0xffEF137E),
  daysGradient1: const Color(0xffFF6FB5).withOpacity(0.06),
  daysGradient2: const Color(0xffFF6FB5),
);

PeriodCycleColors darkPeriodCycleColors =  PeriodCycleColors(
  periodGradient1: const Color(0xffA43E6F),
  periodGradient2: const Color(0xffD33180).withOpacity(0.06),
  back: darkColorScheme.background,
  text: const Color(0xffFF7ABB),
  daysGradient1: const Color(0xffFF6FB5).withOpacity(0.06),
  daysGradient2: const Color(0xffFF6FB5),
);

@immutable
class PeriodCycleColors extends ThemeExtension<PeriodCycleColors> {
  const PeriodCycleColors({
    required this.periodGradient1,
    required this.periodGradient2,
    required this.back,
    required this.text,
    required this.daysGradient1,
    required this.daysGradient2,
  });

  final Color? periodGradient1;
  final Color? periodGradient2;
  final Color? back;
  final Color? text;
  final Color? daysGradient1;
  final Color? daysGradient2;

  static PeriodCycleColors of(BuildContext context) => Theme.of(context).extension<PeriodCycleColors>()!;

  @override
  PeriodCycleColors copyWith({
    Color? periodGradient1,
    Color? periodGradient2,
    Color? back,
    Color? text,
    Color? daysGradient1,
    Color? daysGradient2,
  }) {
    return PeriodCycleColors(
      periodGradient1: periodGradient1 ?? this.periodGradient1,
      periodGradient2: periodGradient2 ?? this.periodGradient2,
      back: back ?? this.back,
      text: text ?? this.text,
      daysGradient1: daysGradient1 ?? this.daysGradient1,
      daysGradient2: daysGradient2 ?? this.daysGradient2,
    );
  }

  @override
  PeriodCycleColors lerp(ThemeExtension<PeriodCycleColors>? other, double t) {
    if (other is! PeriodCycleColors) {
      return this;
    }
    return PeriodCycleColors(
      periodGradient1: Color.lerp(periodGradient1, other.periodGradient1, t),
      periodGradient2: Color.lerp(periodGradient2, other.periodGradient2, t),
      back: Color.lerp(back, other.back, t),
      text: Color.lerp(text, other.text, t),
      daysGradient1: Color.lerp(daysGradient1, other.daysGradient1, t),
      daysGradient2: Color.lerp(daysGradient2, other.daysGradient2, t),
    );
  }

  PeriodCycleColors harmonized(ColorScheme dynamic) {
    return copyWith();
  }
}
