import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/constants/assets_paths.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:social/core/app/view/themes/styles/buttons/button_types.dart';
import 'package:social/core/app/view/themes/styles/buttons/loading_button/elevation_loading_button.dart';
import '../../../../core/app/view/themes/styles/decorations.dart';
import '../../controller/new_experience_controller.dart';
import '../../profile/data/models/profile_model.dart';
import '../../social/data/models/share_experience_topic_model.dart';

class NewCommentPage extends StatelessWidget {
  final ProfileModel profile;
  final String? shareOn, topicId;
  final List<ShareExperienceTopicModel> topics;

  const NewCommentPage({
    super.key,
    required this.profile,
    required this.topics,
    this.shareOn,
    this.topicId,
  });

  static showSheet(
    ProfileModel profile,
    List<ShareExperienceTopicModel> topics, {
    String? shareOn,
    String? topicId,
  }) async {
    return await Get.bottomSheet(
      NewCommentPage(
        profile: profile,
        topics: topics,
        shareOn: shareOn,
        topicId: topicId,
      ),
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
        child: Container(
          color: context.colorScheme.background,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(Decorations.paddingHorizontal).copyWith(top: 8),
                  color: context.colorScheme.background,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'نظر جدید',
                            style: context.textTheme.labelLarge,
                          ),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: ShapeDecoration(
                              shape: const CircleBorder(),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider('${profile.avatarImage}'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      profile.username,
                                      style: context.textTheme.bodyLarge,
                                    ),
                                    Obx(
                                      () => Text(
                                        '${controller.inputCounter.value}/400',
                                        style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.outline),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                AnimatedSize(
                                  alignment: Alignment.topCenter,
                                  duration: const Duration(milliseconds: 200),
                                  clipBehavior: Clip.hardEdge,
                                  child: TextFormField(
                                    maxLength: 400,
                                    onChanged: controller.onTextChanged,
                                    autofocus: true,
                                    minLines: 1,
                                    maxLines: 8,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(bottom: 24),
                                      hintText: 'نظرت رو در مورد این تجربه اینجا بنویس',
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      focusedErrorBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      hintStyle: context.textTheme.bodyMedium,
                                      counter: const SizedBox(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(Decorations.paddingHorizontal),
                  child: ElevationStateButton(
                    size: ButtonSizes.small,
                    onPressed: () => controller.sendExperience(shareId: shareOn, topicId: topicId),
                    state: controller,
                    text: 'پست کردن',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
