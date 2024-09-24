import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../core/app/view/themes/colors/custom_color.dart';
import '../../constants/assets_paths.dart';

class ToastState {
  final String iconPath;
  final Color color;

  const ToastState(this.color, this.iconPath);

  static get warning => ToastState(CustomColors.to.warning!, AssetPaths.warning);

  static get success => ToastState(CustomColors.to.success!, AssetPaths.success);

  static get error => ToastState(CustomColors.to.error!, AssetPaths.error);
}

toast(
    {String? title,
      required String message,
      ToastState? state,
      bool isLoading = false,
      Duration? duration,
      SnackPosition? snackPosition,
      bool? autoClose}) async {
  state ??= ToastState.warning;
  autoClose ??= true;

  final toastController = Get.showSnackbar(
    GetSnackBar(
      titleText: Text(
        title ?? '',
        style: Get.textTheme.bodyLarge?.copyWith(
          color: Get.theme.colorScheme.surfaceVariant,
          fontSize: title == null ? 0 : Get.textTheme.bodyLarge?.fontSize,
        ),
      ),
      messageText: Text(message, style: Get.textTheme.labelLarge?.copyWith(color: Get.theme.colorScheme.surfaceVariant)),
      backgroundColor: Get.theme.colorScheme.inverseSurface,
      margin: const EdgeInsets.all(16).copyWith(bottom: 108),
      padding: const EdgeInsets.all(8.0).copyWith(top: title == null ? 2 : 8),
      borderRadius: 8.0,
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      icon: isLoading
          ? Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(color: state!.color, strokeWidth: 1),
          ),
        ],
      )
          : Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6, right: 8),
            child: SvgPicture.asset(
              state!.iconPath,
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(state.color, BlendMode.srcIn),
            ),
          ),
          Container(width: 0.8, height: title == null ? 30 : 45, color: Get.theme.colorScheme.outlineVariant)
        ],
      ),
      mainButton: IconButton(
        onPressed: () => Get.closeCurrentSnackbar(),
        icon: SvgPicture.asset(
          AssetPaths.close,
          height: 24,
          width: 24,
          colorFilter: ColorFilter.mode(Get.theme.colorScheme.outlineVariant, BlendMode.srcIn),
        ),
      ),
    ),
  );

  if (autoClose) {
    await Future.delayed(duration ?? const Duration(seconds: 3));
    Get.closeCurrentSnackbar();
  } else {
    return toastController;
  }
}
