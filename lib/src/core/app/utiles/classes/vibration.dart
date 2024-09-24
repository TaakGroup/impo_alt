import 'package:flutter/services.dart';

class CustomVibration {
  onChangedDatePicker() async {
    HapticFeedback.lightImpact();
    // if (await Vibration.hasVibrator() ?? false) {
    //   if (await Vibration.hasCustomVibrationsSupport() ?? false) {
    //     Vibration.vibrate(duration: 60);
    //   } else {
    //     Vibration.vibrate();
    //     await Future.delayed(Duration(milliseconds: 30));
    //     Vibration.vibrate();
    //   }
    // }
  }

  normalVibrator() async {
    HapticFeedback.vibrate();
  }

  heavyVibrator() async {
    HapticFeedback.heavyImpact();
  }
}
