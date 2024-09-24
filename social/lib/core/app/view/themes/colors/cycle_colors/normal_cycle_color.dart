import 'package:flutter/material.dart';

import '../color_schemes.dart';

NormalCycleColors lightNormalCycleColors =  NormalCycleColors(
  text: const Color(0xff087AC3),
  back: const Color(0xffF1FAFF),
  gradient1: const Color(0xff1C92D2).withOpacity(0.05),
  gradient2: const Color(0xffA7E0FF),
);

NormalCycleColors darkNormalCycleColors =  NormalCycleColors(
  text: const Color(0xffDAF0FF),
  back: darkColorScheme.background,
  gradient1: const Color(0xff85D4FF),
  gradient2: const Color(0xff1C92D2).withOpacity(0.01),
);

@immutable
class NormalCycleColors extends ThemeExtension<NormalCycleColors> {
  const NormalCycleColors({
    required this.text,
    required this.back,
    required this.gradient1,
    required this.gradient2,
  });

  final Color? text;
  final Color? back;
  final Color? gradient1;
  final Color? gradient2;

  static NormalCycleColors of(BuildContext context) => Theme.of(context).extension<NormalCycleColors>()!;

  @override
  NormalCycleColors copyWith({
    Color? text,
    Color? back,
    Color? gradient1,
    Color? gradient2,
  }) {
    return NormalCycleColors(
      text: text ?? this.text,
      back: back ?? this.back,
      gradient1: gradient1 ?? this.gradient1,
      gradient2: gradient2 ?? this.gradient2,
    );
  }

  @override
  NormalCycleColors lerp(ThemeExtension<NormalCycleColors>? other, double t) {
    if (other is! NormalCycleColors) {
      return this;
    }
    return NormalCycleColors(
      text: Color.lerp(text, other.text, t),
      back: Color.lerp(back, other.back, t),
      gradient1: Color.lerp(gradient1, other.gradient1, t),
      gradient2: Color.lerp(gradient2, other.gradient2, t),
    );
  }

  NormalCycleColors harmonized(ColorScheme dynamic) {
    return copyWith();
  }
}
