

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/themes/styles/decorations.dart';

class BackgroundRegisterWidget extends StatelessWidget {
  final Widget content;
  final String back;
  const BackgroundRegisterWidget({super.key, required this.content, required this.back});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: Image.asset(
              back,
              width: Get.width,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: context.mediaQuery.viewPadding.top + Decorations.paddingTop
            ),
            child: content,
          )
        ],
      ),
    );
  }
}
