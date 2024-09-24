import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/constants/assets_paths.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:social/core/app/view/themes/styles/decorations.dart';
import 'package:social/core/app/view/themes/styles/text_theme.dart';

class AvatarPickerSheet extends StatelessWidget {
  final String avatar;
  final List<String> avatars;
  final RxInt selectedIndex;

  const AvatarPickerSheet({
    super.key,
    required this.selectedIndex,
    required this.avatars,
    required this.avatar,
  });

  static showSheet(int selectedIndex, List<String> avatars, String avatar) => Get.bottomSheet(
        AvatarPickerSheet(
          selectedIndex: selectedIndex.obs,
          avatars: avatars,
          avatar: avatar,
        ),
        isScrollControlled: true,
        ignoreSafeArea: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: context.height * 0.08),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        child: Scaffold(
          bottomNavigationBar: Padding(
            padding: Decorations.pagePaddingHorizontal.copyWith(bottom: 32, top: 16),
            child: ElevatedButton(
              style: context.buttonThemes.elevatedButtonStyle(wide: true),
              onPressed: () => Get.back(result: selectedIndex.value),
              child: const Text('انتخاب پروفایل'),
            ),
          ),
          body: SingleChildScrollView(
            padding: Decorations.pagePaddingHorizontal,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  height: 4,
                  width: 32,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(14)),
                    color: context.colorScheme.surface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'پروفایل من',
                  style: context.textTheme.labelLargeProminent,
                ),
                const SizedBox(height: 24),
                Container(
                  width: 128,
                  height: 128,
                  decoration: ShapeDecoration(
                    shape: const CircleBorder(),
                    color: context.colorScheme.surface,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(avatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'آواتار های پیش‌فرض',
                    style: context.textTheme.labelLargeProminent,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  padding: Decorations.pagePaddingHorizontal,
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    for (int i = 0; i < avatars.length; i++)
                      Obx(
                        () => Badge(
                          isLabelVisible: i == selectedIndex.value,
                          alignment: Alignment.topRight,
                          backgroundColor: Colors.transparent,
                          smallSize: 30,
                          largeSize: 30,
                          label: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.colorScheme.onBackground,
                            ),
                            padding: EdgeInsets.all(8),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(AssetPaths.check),
                          ),
                          child: GestureDetector(
                            onTap: () => selectedIndex.value = i,
                            child: CachedNetworkImage(imageUrl: avatars[i]),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
