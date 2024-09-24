import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/themes/colors/custom_color.dart';

import '../../constans/assets_paths.dart';


class ToastState {
  final String iconPath;
  final Color color;

  const ToastState(this.color, this.iconPath);

  static get warning => ToastState(CustomColors.to.warning!, AssetPaths.warning);

  static get success => ToastState(CustomColors.to.success!, AssetPaths.success);

  static get error => ToastState(CustomColors.to.error!, AssetPaths.error);
}

toast({
  String? title,
  required String message,
  ToastState? state,
  bool isLoading = false,
  Duration? duration,
  SnackPosition? snackPosition,
  bool? autoClose,
}) async {
  state ??= ToastState.warning;
  autoClose ??= true;

  final toastController = Get.showSnackbar(
    GetSnackBar(
      titleText: Text(
        title ?? '',
        style: Get.textTheme.labelMedium?.copyWith(fontSize: title == null ? 0 : Get.textTheme.labelMedium?.fontSize),
      ),
      messageText: Text(message,
          style: Get.textTheme.bodySmall!.copyWith(
            color: Get.theme.colorScheme.surface
          )
      ),
      backgroundColor: Get.theme.colorScheme.inverseSurface,
      margin: const EdgeInsets.all(16).copyWith(bottom: 108),
      // padding: const EdgeInsets.all(8.0).copyWith(top: title == null ? 2 : 8),
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 8
      ),
      // borderColor: state!.color,
      borderRadius: 8.0,
      borderWidth: 0.8,
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      icon:
      // isLoading
      //     ? Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           SizedBox.square(
      //             dimension: 24,
      //             child: CircularProgressIndicator(color: state!.color, strokeWidth: 1),
      //           ),
      //         ],
      //       )
      //     :
      Row(
              children: [
                SizedBox(width: 13),
                SvgPicture.asset(
                  state!.iconPath,
                  height: 24,
                  width: 24,
                  // colorFilter: ColorFilter.mode(state.color, BlendMode.srcIn),
                ),
                SizedBox(width: 4),
                Container(width: 0.8, height: title == null ? 30 : 45, color: Get.theme.colorScheme.onSurfaceVariant),
              ],
            ),
      // mainButton: IconButton(
      //   onPressed: () => Get.closeCurrentSnackbar(),
      //   icon: SvgPicture.asset(
      //     AssetPaths.close,
      //     height: 24,
      //     width: 24,
      //     colorFilter: ColorFilter.mode(Get.theme.colorScheme.outlineVariant, BlendMode.srcIn),
      //   ),
      // ),
    ),
  );

  if (autoClose) {
    await Future.delayed(duration ?? const Duration(seconds: 3));
    Get.closeCurrentSnackbar();
  } else {
    return toastController;
  }
}
