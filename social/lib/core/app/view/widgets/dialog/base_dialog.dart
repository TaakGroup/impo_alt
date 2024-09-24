import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';

class BaseDialog extends StatelessWidget {
  final void Function()? action;
  final String? description;
  final String? buttonText;
  final String? title;
  final Widget? icon;
  final Widget? actions;
  final Widget? content;
  final EdgeInsets? padding, margin;
  final MainAxisSize? mainAxisSize;

  const BaseDialog({
    super.key,
    this.action,
    this.description,
    this.buttonText,
    this.title,
    this.icon,
    this.actions,
    this.content,
    this.padding,
    this.margin,
    this.mainAxisSize,
  });

  static show({
    required String description,
    String? buttonText,
    String? title,
    Widget? icon,
    Widget? actions,
    Widget? content,
    EdgeInsets? padding,
    EdgeInsets? margin,
    void Function()? action,
    MainAxisSize? mainAxisSize,
  }) =>
      Get.dialog(
        BaseDialog(
          description: description,
          icon: icon,
          action: action,
          buttonText: buttonText,
          title: title,
          actions: actions,
          content: content,
          padding: padding,
          margin: margin,
          mainAxisSize: mainAxisSize,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: mainAxisSize ?? MainAxisSize.min,
      children: [
        Container(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          margin: margin ?? const EdgeInsets.symmetric(horizontal: 16),
          decoration: ShapeDecoration(
            color: context.colorScheme.background,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Material(
            color: context.colorScheme.background,
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
                if (description != null)
                  Text(
                    description!,
                    style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                if (content != null) content!,
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
        ),
      ],
    );
  }
}
