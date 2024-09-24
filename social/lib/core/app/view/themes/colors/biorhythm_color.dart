import 'package:flutter/material.dart';

const gBiorhythmColor =  Color.fromRGBO(236, 236, 236, 0.09);

BiorhythmColors lightBiorhythmColors =  const BiorhythmColors(
  emotional: Color(0xffFF895D),
  physical: Color(0xff53E0A2),
  mental: Color(0xff736AE1),
  strokeBack: Color(0xffFFE9AE),
  back: Color(0xffFFFCF5),
);

BiorhythmColors darkBiorhythmColors =  const BiorhythmColors(
  emotional: Color(0xffFF8C61),
  physical: Color(0xff79E8B7),
  mental: Color(0xff9189F9),
  strokeBack: Color(0xff2C271A),
  back: Color(0xff1C1A17),
);

@immutable
class BiorhythmColors extends ThemeExtension<BiorhythmColors> {
  const BiorhythmColors({
    required this.emotional,
    required this.physical,
    required this.mental,
    required this.strokeBack,
    required this.back
  });

  final Color? emotional;
  final Color? physical;
  final Color? mental;
  final Color? strokeBack;
  final Color? back;

  @override
  BiorhythmColors copyWith({
    Color? emotional,
    Color? physical,
    Color? mental,
    Color? strokeBack,
    Color? back,
  }) {
    return BiorhythmColors(
      emotional: emotional ?? this.emotional,
      physical: physical ?? this.physical,
      mental: mental ?? this.mental,
      strokeBack: strokeBack ?? this.strokeBack,
      back: back ?? this.back,
    );
  }

  @override
  BiorhythmColors lerp(ThemeExtension<BiorhythmColors>? other, double t) {
    if (other is! BiorhythmColors) {
      return this;
    }
    return BiorhythmColors(
      emotional: Color.lerp(emotional, other.emotional, t),
      physical: Color.lerp(physical, other.physical, t),
      mental: Color.lerp(mental, other.mental, t),
      strokeBack: Color.lerp(strokeBack, other.strokeBack, t),
      back: Color.lerp(back, other.back, t),
    );
  }

  BiorhythmColors harmonized(ColorScheme dynamic) {
    return copyWith(
    );
  }
}