import 'package:flutter/material.dart';

GeneralCycleColors lightGeneralCycleColors = const GeneralCycleColors(
  back: Color(0xffFCF5FF),
  backStroke: Color(0xffF2DAFF),
  circleBack: Color(0xffFFFBFF),
  daysBack:   Color(0xffFFFFFF),
  daysStroke: Color(0xffF4F4F4),
);

GeneralCycleColors darkGeneralCycleColors =  GeneralCycleColors(
  back: const Color(0xff1D1B1E),
  backStroke: const Color(0xff1D1B1E),
  circleBack: const Color(0xff211F22),
  daysBack:   const Color(0xff4B454D),
  daysStroke: const Color(0xffECECEC).withOpacity(0.09),
);

@immutable
class GeneralCycleColors extends ThemeExtension<GeneralCycleColors> {
  const GeneralCycleColors({
    required this.back,
    required this.backStroke,
    required this.circleBack,
    required this.daysBack,
    required this.daysStroke,
  });

  final Color? back;
  final Color? backStroke;
  final Color? circleBack;
  final Color? daysBack;
  final Color? daysStroke;

  @override
  GeneralCycleColors copyWith({
    Color? back,
    Color? backStroke,
    Color? circleBack,
    Color? daysBack,
    Color? daysStroke,
  }) {
    return GeneralCycleColors(
      back: back ?? this.back,
      backStroke: backStroke ?? this.backStroke,
      circleBack: circleBack ?? this.circleBack,
      daysBack: daysBack ?? this.daysBack,
      daysStroke: daysStroke ?? this.daysStroke,
    );
  }

  @override
  GeneralCycleColors lerp(ThemeExtension<GeneralCycleColors>? other, double t) {
    if (other is! GeneralCycleColors) {
      return this;
    }
    return GeneralCycleColors(
      back: Color.lerp(back, other.back, t),
      backStroke: Color.lerp(backStroke, other.backStroke, t),
      circleBack: Color.lerp(circleBack, other.circleBack, t),
      daysBack: Color.lerp(daysBack, other.daysBack, t),
      daysStroke: Color.lerp(daysStroke, other.daysStroke, t),
    );
  }

  GeneralCycleColors harmonized(ColorScheme dynamic) {
    return copyWith();
  }
}
