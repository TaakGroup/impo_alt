import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/constants/assets_paths.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:social/core/app/view/themes/styles/buttons/loading_button/elevation_loading_button.dart';
import 'package:social/core/app/view/widgets/check_box/check_radio_widget.dart';
import '../../../../core/app/view/themes/styles/buttons/button_types.dart';
import '../../../../core/app/view/themes/styles/decorations.dart';
import '../../controller/new_experience_controller.dart';
import '../../social/data/models/share_experience_topic_model.dart';

class GetTopicSheet extends StatelessWidget {
  final List<ShareExperienceTopicModel> topics;

  const GetTopicSheet({super.key, required this.topics});

  static Future showSheet(List<ShareExperienceTopicModel> topics) async {
    NewExperienceController.to.selectedTopicIndex.value = double.maxFinite.toInt();

    return await Get.bottomSheet(
      GetTopicSheet(topics: topics),
      isScrollControlled: true,
      ignoreSafeArea: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewExperienceController>(
      builder: (controller) => SafeArea(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
          child: Container(
            margin: const EdgeInsets.only(top: 80),
            color: context.colorScheme.background,
            child: Container(
              padding: const EdgeInsets.all(Decorations.paddingHorizontal).copyWith(top: 8),
              color: context.colorScheme.background,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'انتخاب تالار',
                        style: context.textTheme.labelLarge,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: Get.back,
                        icon: SvgPicture.asset(
                          AssetPaths.close,
                          color: context.colorScheme.onBackground,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  const SizedBox(width: double.infinity, height: 16),
                  Text(
                    'این تجربه مربوط به کدوم تالاره؟',
                    style: context.textTheme.labelMedium,
                  ),
                  const SizedBox(width: double.infinity, height: 8),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: topics.length,
                      separatorBuilder: (_, index) => const Divider(height: 16),
                      itemBuilder: (_, index) {
                        return Obx(
                          () => GestureDetector(
                            onTap: () => controller.selectTopic(index, topics),
                            behavior: HitTestBehavior.opaque,
                            child: Row(
                              children: [
                                CheckRadioWidget(
                                  isSelected: index == controller.selectedTopicIndex.value,
                                  iconSize: const Size.square(24),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  topics[index].name!,
                                  style: context.textTheme.bodyMedium,
                                ),
                                const Spacer(),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(topics[index].coverImage),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: double.infinity, height: 16),
                  Obx(
                    () => ElevationStateButton(
                      wide: true,
                      size: ButtonSizes.small,
                      // onPressed: () => controller.sendExperience(shareId: shareOn),
                      onPressed: controller.selectedTopicIndex.value > topics.length ? null : controller.sendExperience,
                      state: controller,
                      text: 'ثبت تجربه',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
