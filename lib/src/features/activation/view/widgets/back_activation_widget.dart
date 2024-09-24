
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/core/app/view/themes/styles/decorations.dart';

class BackActivationWidget extends StatelessWidget {
  const BackActivationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding:  EdgeInsets.only(
            right: 16,
            top: context.mediaQuery.viewPadding.top + Decorations.paddingTop
        ),
        child: IconButton(
          onPressed: Get.back,
          icon: Icon(Icons.arrow_back),
          color: context.colorScheme.onSurfaceVariant,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.white.withOpacity(0.4))
          ),
        ),
      ),
    );
  }
}
