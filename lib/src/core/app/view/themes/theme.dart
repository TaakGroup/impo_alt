import 'package:flutter/material.dart';
import 'package:impo/src/core/app/view/themes/colors/custom_color.dart';
import 'package:impo/src/core/app/view/themes/colors/neutral_palette.dart';
import 'package:impo/src/core/app/view/themes/colors/primary_palette.dart';
import 'package:impo/src/core/app/view/themes/styles/decorations.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'colors/color_schemes.dart';


const MaterialColor white = const MaterialColor(
  0xFFC33091,
  const <int, Color>{
    50: const Color(0xffC33091),
    100: const Color(0xffC33091),
    200: const Color(0xffC33091),
    300: const Color(0xffC33091),
    400: const Color(0xffC33091),
    500: const Color(0xffC33091),
    600: const Color(0xffC33091),
    700: const Color(0xffC33091),
    800: const Color(0xffC33091),
    900: const Color(0xffC33091),
  },
);


class ImpoTheme {

  static TextTheme lightTextTheme = ImpoTextTheme();

  static String fontFamily = 'YekanBakh';

  static ThemeData light = ThemeData(
    // MATERIAL 3
    useMaterial3: true,

        extensions: [
          primaryPalette,
          neutralPalette,
          customColorsLight
        ],

        // Light Theme
        brightness: Brightness.light,

        // Color Scheme
        colorScheme: lightColorScheme,
        scaffoldBackgroundColor: lightColorScheme.background,

        //FONT FAMILY
        fontFamily: fontFamily,

        // Text Theme
        textTheme: lightTextTheme,


        // primarySwatch: white,

        // primaryColor: ColorPallet().mainColor,


    visualDensity: VisualDensity.adaptivePlatformDensity,

    // //InputTheme
    // inputDecorationTheme: InputDecorationTheme(
    //   enabledBorder: OutlineInputBorder(
    //     borderRadius: Decorations.inputBorderRadius,
    //     borderSide: BorderSide(color: lightColorScheme.surface, width: Decorations.inputStrokeWidth),
    //   ),
    //   disabledBorder: OutlineInputBorder(
    //     borderRadius: Decorations.inputBorderRadius,
    //     borderSide: BorderSide(color: lightColorScheme.surfaceVariant, width: Decorations.inputStrokeWidth),
    //   ),
    //   focusedBorder: OutlineInputBorder(
    //     borderRadius: Decorations.inputBorderRadius,
    //     borderSide: BorderSide(color: lightColorScheme.primary, width: Decorations.inputStrokeWidth),
    //   ),
    //   errorBorder: OutlineInputBorder(
    //     borderRadius: Decorations.inputBorderRadius,
    //     borderSide: BorderSide(color: lightColorScheme.error, width: Decorations.inputStrokeWidth),
    //   ),
    //   focusedErrorBorder: OutlineInputBorder(
    //     borderRadius: Decorations.inputBorderRadius,
    //     borderSide: BorderSide(color: lightColorScheme.primary, width: Decorations.inputStrokeWidth),
    //   ),
    // ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: Decorations.buttonShape,
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: 8.0,
        shadowColor: Color(0xFFF13E7B).withOpacity(0.5),
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


  );

}