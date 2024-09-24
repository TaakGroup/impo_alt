import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';

class ButtonChangeTypeWidget extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  const ButtonChangeTypeWidget({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: context.buttonThemes.elevatedButtonStyle()!.copyWith(
            padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(vertical: 10, horizontal: 12)
            ),
          backgroundColor: WidgetStateProperty.all(Colors.white.withOpacity(0.32)),
          elevation: WidgetStateProperty.all(0)
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: context.textTheme.labelMedium!.copyWith(
              color: context.colorScheme.onSurface
          ),
        )
    );
  }
}
