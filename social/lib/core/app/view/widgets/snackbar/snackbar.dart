import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/messages.dart';

class Snackbar {
  static SnackbarController showSnackbarButton({
    required String title,
    required String message,
    required String buttonText,
    required void Function()? onButtonPressed,
  }) {
    return Get.snackbar(
      title,
      message,
      backgroundColor: Get.theme.colorScheme.surfaceVariant,
      isDismissible: false,
      borderRadius: 12,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      margin: const EdgeInsets.all(16),
      animationDuration: const Duration(milliseconds: 500),
      duration: const Duration(days: 365),
      mainButton: TextButton(
        onPressed: onButtonPressed,
        style: Get.theme.textButtonTheme.style?.copyWith(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          padding: MaterialStateProperty.all(
            const EdgeInsets.only(left: 24),
          ),
        ),
        child: Text(buttonText),
      ),
    );
  }

  static SnackbarController serviceFailure({required void Function()? retry}) {
    return Snackbar.showSnackbarButton(
      title: Messages.connectionErrorTitle,
      message: Messages.connectionErrorTitle,
      buttonText: Messages.connectionErrorButtonText,
      onButtonPressed: retry,
    );
  }
}
