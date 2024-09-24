import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social/core/app/view/themes/styles/decorations.dart';
import 'package:social/core/app/view/themes/styles/text_theme.dart';
import 'colors/biorhythm_color.dart';
import 'colors/color_schemes.dart';
import 'colors/custom_color.dart';
import 'colors/cycle_colors/fertility_cycle_color.dart';
import 'colors/cycle_colors/general_cycle_color.dart';
import 'colors/cycle_colors/normal_cycle_color.dart';
import 'colors/cycle_colors/period_cycle_color.dart';
import 'colors/cycle_colors/pms_cycle_color.dart';
import 'colors/neutral_palette.dart';
import 'colors/primary_palette.dart';
import 'colors/secondary_palette.dart';

class ImpoTheme {
  static changeTheme() {
    if (Get.isDarkMode) {
      Get.changeThemeMode(ThemeMode.light);
    } else {
      Get.changeThemeMode(ThemeMode.dark);
    }
  }

  static TextTheme darkTextTheme = ImpoTextTheme();

  static TextTheme lightTextTheme = ImpoTextTheme();

  static String fontFamily = 'YekanBakh';

  static ThemeData light = ThemeData(
    // MATERIAL 3
    useMaterial3: true,
    extensions: [
      primaryPalette,
      secondaryPalette,
      neutralPalette,
      lightGeneralCycleColors,
      lightNormalCycleColors,
      lightPeriodCycleColors,
      lightFertilityCycleColors,
      lightPmsCycleColors,
      lightBiorhythmColors,
      customColorsLight
    ],

    // Light Theme
    brightness: Brightness.light,

    // Color Scheme
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: lightColorScheme.background,

    // Tap Effect
    splashFactory: InkRipple.splashFactory,

    //FONT FAMILY
    fontFamily: fontFamily,

    // Text Theme
    textTheme: lightTextTheme,

    //InputTheme
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: Decorations.inputBorderRadius,
        borderSide: BorderSide(color: lightColorScheme.surfaceVariant, width: Decorations.inputStrokeWidth),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: Decorations.inputBorderRadius,
        borderSide: BorderSide(color: lightColorScheme.surface, width: Decorations.inputStrokeWidth),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: Decorations.inputBorderRadius,
        borderSide: BorderSide(color: lightColorScheme.primary, width: Decorations.inputStrokeWidth),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: Decorations.inputBorderRadius,
        borderSide: BorderSide(color: lightColorScheme.error, width: Decorations.inputStrokeWidth),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: Decorations.inputBorderRadius,
        borderSide: BorderSide(color: lightColorScheme.primary, width: Decorations.inputStrokeWidth),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: Decorations.buttonShape,
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: 0.0,
        shadowColor: Colors.transparent,
        // animationDuration: Duration(milliseconds: 800),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: Decorations.buttonShape,
        foregroundColor: lightColorScheme.primary,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: 0.0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: Decorations.buttonShape.copyWith(side: BorderSide(color: lightColorScheme.primary)),
        foregroundColor: lightColorScheme.primary,
        side: BorderSide(color: lightColorScheme.primary),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: 0.0,
      ),
    ),

    // Divider theme
    dividerTheme: DividerThemeData(color: lightColorScheme.surface),

    // Chips theme
    chipTheme: ChipThemeData(
      labelStyle: lightTextTheme.labelMedium?.copyWith(fontFamily: fontFamily),
      side: BorderSide(color: lightColorScheme.surface),
    ),

    // TimePickerThemeData
    timePickerTheme: TimePickerThemeData(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
        hourMinuteTextStyle: lightTextTheme.titleLarge,
        hourMinuteTextColor: lightColorScheme.outline,
        hourMinuteShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
        dayPeriodTextStyle: lightTextTheme.bodyMedium,
        dayPeriodBorderSide: BorderSide(color: lightColorScheme.surfaceVariant),
        dayPeriodShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        backgroundColor: lightColorScheme.background,
        dialBackgroundColor: lightColorScheme.background,
        helpTextStyle: lightTextTheme.titleSmall,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: lightColorScheme.onSurface, width: Decorations.inputStrokeWidth),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: lightColorScheme.surfaceVariant, width: Decorations.inputStrokeWidth),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: lightColorScheme.primary, width: Decorations.inputStrokeWidth),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: lightColorScheme.error, width: Decorations.inputStrokeWidth),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: lightColorScheme.primary, width: Decorations.inputStrokeWidth),
          ),
        )),

    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.background,
      scrolledUnderElevation: 0,
      titleTextStyle: lightTextTheme.labelLarge?.copyWith(fontFamily: fontFamily),
      elevation: 0,
      titleSpacing: 8,
    ),
  );

// static ThemeData dark = ThemeData(
//   // MATERIAL 3
//   useMaterial3: true,
//
//     // Extensions Color
//     extensions: [
//       primaryPalette,
//       secondaryPalette,
//       neutralPalette,
//       darkGeneralCycleColors,
//       darkNormalCycleColors,
//       darkPeriodCycleColors,
//       darkFertilityCycleColors,
//       darkPmsCycleColors,
//       darkBiorhythmColors,
//       customColorsDark
//     ],
//
//   // Light Theme
//   brightness: Brightness.dark,
//
//   // Color Scheme
//   colorScheme: darkColorScheme,
//   scaffoldBackgroundColor: darkColorScheme.background,
//
//   // Tap Effect
//   splashFactory: InkRipple.splashFactory,
//
//   // FONT FAMILY
//   fontFamily: fontFamily,
//
//   // Text Theme
//   textTheme: darkTextTheme,
//
//   //InputTheme
//   inputDecorationTheme: InputDecorationTheme(
//     enabledBorder: OutlineInputBorder(
//       borderRadius: Decorations.inputBorderRadius,
//       borderSide: BorderSide(color: darkColorScheme.surface, width: Decorations.inputStrokeWidth),
//     ),
//     disabledBorder: OutlineInputBorder(
//       borderRadius: Decorations.inputBorderRadius,
//       borderSide: BorderSide(color: darkColorScheme.surfaceVariant, width: Decorations.inputStrokeWidth),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: Decorations.inputBorderRadius,
//       borderSide: BorderSide(color: darkColorScheme.primary, width: Decorations.inputStrokeWidth),
//     ),
//     errorBorder: OutlineInputBorder(
//       borderRadius: Decorations.inputBorderRadius,
//       borderSide: BorderSide(color: darkColorScheme.error, width: Decorations.inputStrokeWidth),
//     ),
//     focusedErrorBorder: OutlineInputBorder(
//       borderRadius: Decorations.inputBorderRadius,
//       borderSide: BorderSide(color: darkColorScheme.primary, width: Decorations.inputStrokeWidth),
//     ),
//   ),
//   elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//     shape: Decorations.buttonShape,
//     backgroundColor: darkColorScheme.primary,
//     foregroundColor: darkColorScheme.onPrimary,
//     minimumSize: Size.zero,
//     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//     elevation: 0.0,
//     shadowColor: Colors.transparent,
//     // animationDuration: Duration(milliseconds: 800),
//   )),
//   textButtonTheme: TextButtonThemeData(
//     style: TextButton.styleFrom(
//       shape: Decorations.buttonShape,
//       foregroundColor: darkColorScheme.primary,
//       minimumSize: Size.zero,
//       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//       elevation: 0.0,
//     ),
//   ),
//   outlinedButtonTheme: OutlinedButtonThemeData(
//     style: OutlinedButton.styleFrom(
//       shape: Decorations.buttonShape.copyWith(side: BorderSide(color: lightColorScheme.primary)),
//       foregroundColor: darkColorScheme.primary,
//       side: BorderSide(color: darkColorScheme.primary),
//       minimumSize: Size.zero,
//       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//       elevation: 0.0,
//     ),
//   ),
//
//   // Divider theme
//   dividerTheme: DividerThemeData(color: darkColorScheme.surface),
//
//   // Chips theme
//   chipTheme: ChipThemeData(
//     labelStyle: darkTextTheme.labelMedium?.copyWith(fontFamily: fontFamily),
//     side: BorderSide(
//       color: darkColorScheme.surface,
//     ),
//   ),
//   timePickerTheme: TimePickerThemeData(
//     shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
//     hourMinuteTextStyle: darkTextTheme.titleLarge,
//     hourMinuteTextColor: darkColorScheme.outline,
//     hourMinuteShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
//     dayPeriodTextStyle: lightTextTheme.bodyMedium,
//     dayPeriodBorderSide: BorderSide(color: darkColorScheme.surfaceVariant),
//     dayPeriodShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
//     backgroundColor: darkColorScheme.background,
//     dialBackgroundColor: darkColorScheme.background,
//     helpTextStyle: darkTextTheme.titleSmall,
//     inputDecorationTheme: InputDecorationTheme(
//       enabledBorder: OutlineInputBorder(
//         borderRadius: const BorderRadius.all(Radius.circular(8)),
//         borderSide: BorderSide(color: darkColorScheme.surfaceVariant, width: Decorations.inputStrokeWidth),
//       ),
//       disabledBorder: OutlineInputBorder(
//         borderRadius: const BorderRadius.all(Radius.circular(8)),
//         borderSide: BorderSide(color: darkColorScheme.surfaceVariant, width: Decorations.inputStrokeWidth),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: const BorderRadius.all(Radius.circular(8)),
//         borderSide: BorderSide(color: darkColorScheme.primary, width: Decorations.inputStrokeWidth),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: const BorderRadius.all(Radius.circular(8)),
//         borderSide: BorderSide(color: darkColorScheme.error, width: Decorations.inputStrokeWidth),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: const BorderRadius.all(Radius.circular(8)),
//         borderSide: BorderSide(color: darkColorScheme.primary, width: Decorations.inputStrokeWidth),
//       ),
//     ),
//   ),
//   appBarTheme: AppBarTheme(
//     backgroundColor: darkColorScheme.background,
//     scrolledUnderElevation: 0,
//     titleTextStyle: darkTextTheme.titleMedium?.copyWith(fontFamily: fontFamily),
//     elevation: 0,
//     titleSpacing: 8,
//   ),
// );
}
