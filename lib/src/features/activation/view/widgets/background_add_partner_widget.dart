import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/constans/assets_paths.dart';


class BackgroundAddPartnerWidget extends StatelessWidget {
  final Widget content;
  const BackgroundAddPartnerWidget({super.key, required this.content});

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
              AssetPaths.backRegister,
              width: Get.width,
              fit: BoxFit.cover,
            ),
          ),
          content
        ],
      ),
    );
  }
}
