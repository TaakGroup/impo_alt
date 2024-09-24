import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/constants/assets_paths.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:social/core/app/view/themes/styles/text_theme.dart';
import '../../../../../core/app/view/themes/styles/decorations.dart';
import '../../data/models/profile_model.dart';

class ActiveNotificationSheet extends StatelessWidget {
  final String username;
  final ProfileModel profile;
  final String notificationActivationMessage;
  final RxBool isNotificationActive;
  final Function(bool value) onChange;

  const ActiveNotificationSheet({
    super.key,
    required this.notificationActivationMessage,
    required this.isNotificationActive,
    required this.onChange,
    required this.profile,
    required this.username,
  });

  static Future showSheet({
    required String username,
    required ProfileModel profile,
    required String notificationActivationMessage,
    required RxBool isNotificationActive,
    required Function(bool value) onChange,
  }) {
    return Get.bottomSheet(
      ActiveNotificationSheet(
        notificationActivationMessage: notificationActivationMessage,
        isNotificationActive: isNotificationActive,
        onChange: onChange,
        profile: profile,
        username: username,
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: Decorations.pagePaddingHorizontal.copyWith(bottom: 32, top: 12),
      child: Wrap(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 4,
              width: 32,
              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(14)), color: Color(0xffD4D4D8)),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'باخبرم کن',
              style: context.textTheme.labelLargeProminent,
            ),
          ),
          const SizedBox(
            height: 24,
            width: double.infinity,
          ),
          Badge(
            offset: const Offset(-4, -10),
            alignment: Alignment.topRight,
            backgroundColor: Colors.transparent,
            largeSize: 30,
            smallSize: 24,
            label: SizedBox(
              child: Image.asset(AssetPaths.bell, width: 30, height: 30),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: const BoxDecoration(
                color: Color(0xffFCE7F3),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: context.textTheme.labelLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notificationActivationMessage,
                          style: context.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (profile.avatarImage != null && profile.avatarImage!.isNotEmpty)
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.colorScheme.surfaceVariant,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(profile.avatarImage!),
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.colorScheme.surfaceVariant,
                        border: Border.all(width: 1, color: context.colorScheme.surfaceVariant),
                      ),
                      child: SvgPicture.asset(AssetPaths.profileUser),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 24,
            width: double.infinity,
          ),
          Text(
            'با فعال کردن این اعلان، وقتی ${profile.username} تجربه جدیدی بذاره، بهت خبر میدیم تا تجربه‌هاش رو از دست ندی',
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 16,
            width: double.infinity,
          ),
          Row(
            children: [
              SvgPicture.asset(
                AssetPaths.bellRinging,
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 16),
              Text(
                'باخبرم کن',
                style: context.textTheme.bodyMedium,
              ),
              const Spacer(),
              Obx(
                () => SizedBox(
                  height: 45,
                  child: FittedBox(
                    child: Switch(
                      value: isNotificationActive.value,
                      onChanged: onChange,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
