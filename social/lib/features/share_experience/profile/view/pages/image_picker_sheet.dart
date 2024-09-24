import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/constants/assets_paths.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:social/core/app/view/themes/styles/decorations.dart';
import 'package:social/core/app/view/themes/styles/text_theme.dart';

import '../../controller/edit_share_experience_profile_controller.dart';
import '../../controller/upload_share_experience_profile_controller.dart';

class ImagePickerSheet extends StatelessWidget {
  const ImagePickerSheet({super.key});

  static void showSheet() => Get.bottomSheet(
        const ImagePickerSheet(),
        isScrollControlled: true,
        ignoreSafeArea: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: context.height * 0.08),
      padding: Decorations.pagePaddingHorizontal,
      decoration: BoxDecoration(
        color: context.colorScheme.background,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Wrap(
        children: [
          const SizedBox(
            height: 12,
            width: double.infinity,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 4,
              width: 32,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                color: context.colorScheme.surface,
              ),
            ),
          ),
          const SizedBox(
            height: 12,
            width: double.infinity,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'پروفایل من',
              style: context.textTheme.labelLargeProminent,
            ),
          ),
          const SizedBox(
            height: 24,
            width: double.infinity,
          ),
          GestureDetector(
            onTap: () {
              Get.back();
              UploadShareExperienceProfileController.to.onPickImagePressed();
            },
            child: Row(
              children: [SvgPicture.asset(AssetPaths.gallery), const SizedBox(width: 4), const Text('انتخاب از گالری')],
            ),
          ),
          const Divider(height: 32),
          GestureDetector(
            onTap: () {
              Get.back();
              EditShareExperienceProfileController.to.pickAvatar();
            },
            child: Row(
              children: [SvgPicture.asset(AssetPaths.gallery), const SizedBox(width: 4), const Text('آواتار های پیش‌فرض')],
            ),
          ),
          const Divider(height: 32),
          GestureDetector(
            onTap: () {
              Get.back();
              UploadShareExperienceProfileController.to.onPickImageFromCameraPressed();
            },
            child: Row(
              children: [SvgPicture.asset(AssetPaths.camera), const SizedBox(width: 4), const Text('استفاده از دوربین')],
            ),
          ),
          const SizedBox(
            height: 32,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
