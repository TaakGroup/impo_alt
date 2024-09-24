import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/themes/styles/new_text_theme.dart';
import 'package:impo/src/core/app/view/themes/theme.dart';
import 'package:responsive_framework/responsive_framework.dart';

class DesignSizeFigma extends StatelessWidget {
  final WidgetBuilder builder;
  const DesignSizeFigma({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return Theme(
        data: ImpoTheme.light.copyWith(
          textTheme: NewImpoTextTheme(),
        ),
        child: ResponsiveWrapper.builder(
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.autoScale(360, name: MOBILE),
            ResponsiveBreakpoint.resize(480, name: TABLET),
          ],
          AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: context.isDarkMode ? Brightness.light : Brightness.dark,
                statusBarBrightness: context.isDarkMode ? Brightness.dark : Brightness.light,
              ),
              child: Builder(builder: builder)
          ),
        )
    );
  }
}
