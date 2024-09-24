import 'dart:ui';
import 'package:blur/blur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app.dart';
import 'package:social/core/app/constants/assets_paths.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:social/core/app/view/themes/styles/buttons/button_types.dart';
import 'package:social/core/app/view/themes/styles/buttons/loading_button/elevation_loading_button.dart';
import '../../../../core/app/view/themes/styles/decorations.dart';
import '../../controller/new_experience_controller.dart';
import '../../profile/data/models/profile_model.dart';
import '../../social/controller/share_experience_media_controller.dart';
import '../../social/data/models/share_experience_topic_model.dart';

class NewExperiencePage extends StatelessWidget {
  final ProfileModel profile;
  final List<ShareExperienceTopicModel>? topics;
  final String? topicId;
  final bool pickTopic;

  const NewExperiencePage({
    super.key,
    required this.profile,
    this.topics,
    this.topicId,
    this.pickTopic = true,
  });

  bool get canPickTopic => pickTopic && topics != null && topics!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewExperienceController>(
      initState: (_) => _.controller?.resetExperience(),
      builder: (controller) => SafeArea(
        child: Scaffold(
          bottomSheet: Material(
            color: context.colorScheme.background,
            child: Padding(
              padding: const EdgeInsets.all(Decorations.paddingHorizontal),
              child: ElevationStateButton(
                wide: true,
                size: ButtonSizes.small,
                onPressed: () => canPickTopic ? controller.openTopicSheet(topics) : controller.sendExperience(topicId: topicId),
                state: controller,
                text: canPickTopic ? 'بعدی' : 'پست کردن',
              ),
            ),
          ),
          body: Container(
            color: context.colorScheme.background,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(Decorations.paddingHorizontal).copyWith(top: 8),
                color: context.colorScheme.background,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          style: context.buttonThemes.outlineButtonStyle(color: ButtonColors.surface)?.copyWith(
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(8.0),
                                ),
                              ),
                          onPressed: Get.back,
                          icon: SvgPicture.asset(
                            AssetPaths.arrowRight,
                            color: context.colorScheme.onSurface,
                            height: 24,
                            width: 24,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'تجربه جدید',
                          style: context.textTheme.labelLarge,
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
                            color: context.colorScheme.surface,
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
                                    hintText: 'تجربه خودت رو اینجا بنویس',
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    focusedErrorBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    hintStyle: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.outline),
                                    counter: const SizedBox(),
                                  ),
                                ),
                              ),
                              GetBuilder<ShareExperienceMediaController>(
                                builder: (controller) => UploadImageWidget(controller: controller),
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
          ),
        ),
      ),
    );
  }
}

class UploadImageWidget extends StatelessWidget {
  final ShareExperienceMediaController controller;

  const UploadImageWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedSize(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        child: Container(
          child: controller.hasImage.value
              ? Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Stack(
                    children: [
                      Obx(
                        () => Blur(
                          blur: controller.imageLoading.value ? 5 : 0,
                          overlay: controller.imageLoading.value
                              ? CircularProgressIndicator(color: context.colorScheme.background)
                              : const SizedBox(),
                          colorOpacity: 0.1,
                          blurColor: Colors.grey,
                          child: Image.memory(controller.pickedImage!),
                        ),
                      ),
                      Obx(
                        () => Container(
                          child: !controller.imageLoading.value
                              ? Positioned(
                                  top: 8,
                                  right: 8,
                                  width: 24,
                                  height: 24,
                                  child: GestureDetector(
                                    onTap: controller.onRemoveImage,
                                    child: Container(
                                      decoration: ShapeDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        shape: const CircleBorder(),
                                      ),
                                      child: SvgPicture.asset(
                                        AssetPaths.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ),
                      ),
                    ],
                  ),
                )
              : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: controller.onPickImagePressed,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 0.8),
                    child: SvgPicture.asset(AssetPaths.galleryAdd),
                  ),
                ),
        ),
      ),
    );
  }
}
