import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';

class BaseDialog extends StatelessWidget {
  final void Function()? action;
  final String description;
  final String? buttonText;
  final String? title;
  final Widget? icon;
  final Widget? actions;

  const BaseDialog({super.key, this.action, required this.description, this.buttonText, this.title, this.icon, this.actions});

  static show({
    required String description,
    String? buttonText,
    String? title,
    Widget? icon,
    Widget? actions,
    void Function()? action,
  }) =>
      Get.dialog(
        BaseDialog(
          description: description,
          icon: icon,
          action: action,
          buttonText: buttonText,
          title: title,
          actions: actions,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) icon!,
              if (icon != null) const SizedBox(height: 16),
              if (title != null)
                Text(
                  title!,
                  style: context.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              if (title != null) const SizedBox(height: 8),
              Text(
                description,
                style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (actions != null)
                actions!
              else
                ElevatedButton(
                  style: context.buttonThemes.elevatedButtonStyle(wide: true),
                  onPressed: action,
                  child: Text(buttonText ?? 'تایید'),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
