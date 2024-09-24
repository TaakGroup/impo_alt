import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/constants/assets_paths.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:social/features/messenger/data/models/user_info_model.dart';

import 'mini_chip.dart';

class UserProfileWidget extends StatelessWidget {
  final UserInfoModel userInfo;

  const UserProfileWidget({
    super.key,
    required this.userInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: ShapeDecoration(
        color: context.colorScheme.primary,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: context.colorScheme.surface,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2, top: 2, right: 8),
            child: Row(
              children: [
                Icon(
                  Icons.info_rounded,
                  color: context.colorScheme.background,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  'مشخصات بیمار',
                  style: context.textTheme.bodyLarge?.copyWith(color: context.colorScheme.background),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0).copyWith(top: 12),
            decoration: ShapeDecoration(
              color: context.colorScheme.background,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignOutside,
                  color: context.colorScheme.surface,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6.0),
                      width: 48,
                      height: 48,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFEEE5FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Center(
                        child: Image.asset(AssetPaths.userProfile),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userInfo.title,
                          style: context.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            MiniChip(
                              text: userInfo.age,
                              icon: SvgPicture.asset(
                                AssetPaths.userAlert,
                                width: 18,
                                height: 18,
                              ),
                            ),
                            const SizedBox(width: 6),
                            MiniChip(
                              text: userInfo.sex,
                              icon: SvgPicture.asset(
                                AssetPaths.group,
                                width: 18,
                                height: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                if (userInfo.phase.isNotEmpty || userInfo.phaseDetail.isNotEmpty) const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    userInfo.phase.isEmpty
                        ? const SizedBox()
                        : Text(
                            userInfo.phase,
                            style: context.textTheme.bodyLarge,
                          ),
                    userInfo.phaseDetail.isEmpty
                        ? const SizedBox()
                        : Text(
                            userInfo.phaseDetail,
                            style: context.textTheme.bodyLarge,
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
