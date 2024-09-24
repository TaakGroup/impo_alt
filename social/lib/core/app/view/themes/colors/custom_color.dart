import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

CustomColors customColorsLight = CustomColors(
  passlockBack: const Color(0xffFFB1C2),
  warning: const Color(0xffFFC400),
  success: const Color(0xff31C440),
  error: const Color(0xffBA1A1A),
  period: const Color(0xffFFBBDC),
  fertility: const Color(0xffADFFF9),
  pms: const Color(0xffDBBCFF),
  barPlotCycle: const Color(0xffFFDCE3),
  iconBackgroundColor: const Color(0xffFFECEE),
  ovulation: const Color(0xff004F51),
  normalDays: const Color(0xff087AC3),
);

CustomColors customColorsDark = CustomColors(
  passlockBack: const Color(0xff1D1819),
  warning: const Color(0xffFFC400),
  success: const Color(0xff31C440),
  error: const Color(0xffFFB4AB),
  period: const Color(0xffFFBBDC),
  fertility: const Color(0xffADFFF9),
  pms: const Color(0xffDBBCFF),
  barPlotCycle: const Color(0xffFFDCE3),
  iconBackgroundColor: const Color(0xffFFECEE),
  ovulation: const Color(0xff1A9DA0),
  normalDays: const Color(0xffDAF0FF),
);

class CustomColors extends ThemeExtension<CustomColors> {
  final Color? passlockBack;
  final Color? warning;
  final Color? success;
  final Color? error;
  final Color? period;
  final Color? fertility;
  final Color? pms;
  final Color? barPlotCycle;
  final Color? iconBackgroundColor;
  final Color? ovulation;
  final Color? normalDays;

  CustomColors({
    required this.passlockBack,
    required this.warning,
    required this.success,
    required this.error,
    required this.period,
    required this.fertility,
    required this.pms,
    required this.barPlotCycle,
    required this.iconBackgroundColor,
    required this.ovulation,
    required this.normalDays,
  });

  static CustomColors of(BuildContext context) => Theme.of(context).extension<CustomColors>()!;

  static CustomColors get to => of(Get.context!);

  @override
  ThemeExtension<CustomColors> copyWith({
    Color? passlockBack,
    Color? warning,
    Color? success,
    Color? error,
    Color? period,
    Color? fertility,
    Color? pms,
    Color? iconBackgroundColor,
    Color? ovulation,
    Color? normalDays,
  }) {
    return CustomColors(
      passlockBack: passlockBack ?? this.passlockBack,
      warning: warning ?? this.warning,
      period: warning ?? this.period,
      fertility: warning ?? this.fertility,
      pms: pms ?? this.pms,
      success: success ?? this.success,
      error: error ?? this.error,
      barPlotCycle: barPlotCycle ?? this.barPlotCycle,
      iconBackgroundColor: barPlotCycle ?? this.iconBackgroundColor,
      ovulation: ovulation ?? this.ovulation,
      normalDays: normalDays ?? this.normalDays,
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(covariant ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;

    return CustomColors(
      passlockBack: Color.lerp(passlockBack, other.passlockBack, t),
      warning: Color.lerp(warning, other.warning, t),
      period: Color.lerp(period, other.period, t),
      fertility: Color.lerp(fertility, other.fertility, t),
      pms: Color.lerp(pms, other.pms, t),
      success: Color.lerp(success, other.success, t),
      error: Color.lerp(error, other.error, t),
      barPlotCycle: Color.lerp(barPlotCycle, other.barPlotCycle, t),
      iconBackgroundColor: Color.lerp(iconBackgroundColor, other.iconBackgroundColor, t),
      ovulation: Color.lerp(ovulation, other.ovulation, t),
      normalDays: Color.lerp(normalDays, other.normalDays, t),
    );
  }
}
