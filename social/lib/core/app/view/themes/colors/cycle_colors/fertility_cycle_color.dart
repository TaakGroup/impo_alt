import 'package:flutter/material.dart';

import '../color_schemes.dart';

FertilityCycleColors lightFertilityCycleColors =  FertilityCycleColors(
  fertilityGradient1: const Color(0xff37E2D5).withOpacity(0.06),
  fertilityGradient2: const Color(0xff37E2D5),
  back: const Color(0xffEFFFFD),
  text: const Color(0xff00CCBD),
  daysGradient1: const Color(0xff74F8EE),
  daysGradient2: const Color(0xff43D9CE),
  daysGradient3: const Color(0xff7EE2DB),
);

FertilityCycleColors darkFertilityCycleColors =  FertilityCycleColors(
  fertilityGradient1: const Color(0xff258B83).withOpacity(0.06),
  fertilityGradient2: const Color(0xff31A59C),
  back: darkColorScheme.background,
  text: const Color(0xff77EDE5),
  daysGradient1: const Color(0xff74F8EE),
  daysGradient2: const Color(0xff43D9CE),
  daysGradient3: const Color(0xff7EE2DB),
);

@immutable
class FertilityCycleColors extends ThemeExtension<FertilityCycleColors> {
  const FertilityCycleColors({
    required this.fertilityGradient1,
    required this.fertilityGradient2,
    required this.back,
    required this.text,
    required this.daysGradient1,
    required this.daysGradient2,
    required this.daysGradient3,
  });

  final Color? fertilityGradient1;
  final Color? fertilityGradient2;
  final Color? back;
  final Color? text;
  final Color? daysGradient1;
  final Color? daysGradient2;
  final Color? daysGradient3;

  static FertilityCycleColors of(BuildContext context) => Theme.of(context).extension<FertilityCycleColors>()!;

  @override
  FertilityCycleColors copyWith({
    Color? fertilityGradient1,
    Color? fertilityGradient2,
    Color? back,
    Color? text,
    Color? daysGradient1,
    Color? daysGradient2,
    Color? daysGradient3,
  }) {
    return FertilityCycleColors(
      fertilityGradient1: fertilityGradient1 ?? this.fertilityGradient1,
      fertilityGradient2: fertilityGradient2 ?? this.fertilityGradient2,
      back: back ?? this.back,
      text: text ?? this.text,
      daysGradient1: daysGradient1 ?? this.daysGradient1,
      daysGradient2: daysGradient2 ?? this.daysGradient2,
      daysGradient3: daysGradient3 ?? this.daysGradient3,
    );
  }

  @override
  FertilityCycleColors lerp(ThemeExtension<FertilityCycleColors>? other, double t) {
    if (other is! FertilityCycleColors) {
      return this;
    }
    return FertilityCycleColors(
      fertilityGradient1: Color.lerp(fertilityGradient1, other.fertilityGradient1, t),
      fertilityGradient2: Color.lerp(fertilityGradient2, other.fertilityGradient2, t),
      back: Color.lerp(back, other.back, t),
      text: Color.lerp(text, other.text, t),
      daysGradient1: Color.lerp(daysGradient1, other.daysGradient1, t),
      daysGradient2: Color.lerp(daysGradient2, other.daysGradient2, t),
      daysGradient3: Color.lerp(daysGradient3, other.daysGradient3, t),
    );
  }

  FertilityCycleColors harmonized(ColorScheme dynamic) {
    return copyWith();
  }
}
