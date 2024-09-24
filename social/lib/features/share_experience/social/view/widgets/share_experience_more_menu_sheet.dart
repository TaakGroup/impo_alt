import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';

import '../../../../../core/app/constants/assets_paths.dart';
import '../../../../../core/app/view/themes/styles/decorations.dart';

class ShareExperienceMoreMenuSheet extends StatelessWidget {
  final void Function() onReportPressed;

  const ShareExperienceMoreMenuSheet({
    super.key,
    required this.onReportPressed,
  });

  static showSheet({required void Function() onReportPressed}) => Get.bottomSheet(
        ShareExperienceMoreMenuSheet(onReportPressed: onReportPressed),
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
            height: 24,
            width: double.infinity,
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Get.back();
              onReportPressed.call();
            },
            child: Row(
              children: [
                SvgPicture.asset(AssetPaths.warning),
                const SizedBox(width: 8),
                Text('ریپورت', style: context.textTheme.bodyMedium),
                Spacer(),
                Icon(
                  Icons.chevron_right_rounded,
                  color: context.colorScheme.outline,
                  size: 24,
                ),
                SizedBox(width: 8),
              ],
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
