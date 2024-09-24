import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/constants/assets_paths.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:social/core/app/view/themes/styles/buttons/button_icon/elevated_button_icon.dart';
import 'package:social/core/app/view/themes/styles/buttons/button_types.dart';
import 'package:social/core/app/view/widgets/loading_indicator_widget.dart';

import '../../../../../core/app/view/themes/styles/decorations.dart';
import '../../../social/controller/share_experience_controller.dart';
import '../../../social/view/widgets/share_experience_comment_widget.dart';
import '../../controller/follow_notification_controller.dart';
import '../../controller/share_experience_profile_controller.dart';
import 'active_notification_sheet.dart';

class ShareExperienceProfilePage extends StatelessWidget {
  const ShareExperienceProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShareExperienceProfileController.to.obx(
          (model) => Text(
            model!.profile.username,
            style: context.textTheme.labelLarge,
          ),
          onLoading: const SizedBox(),
          onEmpty: const SizedBox(),
        ),
        leading: IconButton(
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
        actions: [
          ShareExperienceProfileController.to.obx(
            (model) => model!.isSelf
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(left: Decorations.paddingHorizontal),
                    child: IconButton(
                      style: context.buttonThemes.outlineButtonStyle(color: ButtonColors.surface)?.copyWith(
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.all(8.0),
                            ),
                          ),
                      onPressed: () => ActiveNotificationSheet.showSheet(
                        username: ShareExperienceProfileController.to.args.$2.username,
                        profile: model.profile,
                        notificationActivationMessage: model.notificationActivationMessage,
                        isNotificationActive: model.isNotificationActive,
                        onChange: (value) => FollowNotificationController.to.onNotificationChange(
                          model.profile.id,
                          model.isNotificationActive.value = value,
                        ),
                      ),
                      icon: Obx(
                        () => SvgPicture.asset(
                          model.isNotificationActive.value ? AssetPaths.bellRingingFill : AssetPaths.bellRinging,
                          color:  model.isNotificationActive.value ? context.colorScheme.primary : context.colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),
            onLoading: const SizedBox(),
          ),
        ],
      ),
      body: ShareExperienceProfileController.to.obx(
        (model) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: Decorations.pagePaddingHorizontal,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              model!.profile.username,
                              style: context.textTheme.titleMedium,
                            ),
                            const SizedBox(width: 4),
                            if (model.isDr)
                              SvgPicture.asset(
                                AssetPaths.blueTick,
                                height: 20,
                                width: 20,
                              ),
                          ],
                        ),
                        if (model.profile.biography.isNotEmpty) Text(model.profile.biography, style: context.textTheme.labelMedium),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.colorScheme.surfaceVariant,
                        border: Border.all(width: 1, color: context.colorScheme.surfaceVariant),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(model.profile.avatarImage!),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              if (model.isSelf) const SizedBox(height: 16),
              if (model.isSelf)
                Padding(
                  padding: Decorations.pagePaddingHorizontal,
                  child: Row(
                    children: [
                      if (model.isSelf)
                        Expanded(
                          child: ElevatedButtonIcon(
                            onPressed: ShareExperienceProfileController.to.editProfile,
                            label: const Text('ویرایش پروفایل'),
                            icon: SvgPicture.asset(
                              AssetPaths.edit,
                              color: context.colorScheme.onBackground,
                            ),
                            color: ButtonColors.surface,
                            size: ButtonSizes.small,
                          ),
                        ),
                      // SizedBox(width: 8),
                      // Expanded(
                      //   child: ElevatedButtonIcon(
                      //     onPressed: () {},
                      //     label: const Text('خدمات شما'),
                      //     icon: SvgPicture.asset(AssetPaths.messages),
                      //     color: ButtonColors.primary,
                      //     size: ButtonSizes.small,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              // SizedBox(height: 16),
              // Text(model.topicsTitleText),
              // SizedBox(height: 16),
              // ListView.separated(
              //   itemCount: model.topics.length,
              //   padding: Decorations.pagePaddingHorizontal,
              //   physics: const BouncingScrollPhysics(),
              //   shrinkWrap: true,
              //   scrollDirection: Axis.horizontal,
              //   separatorBuilder: (_, index) => const SizedBox(width: 8),
              //   itemBuilder: (_, index) => ShareExperienceTopicWidget(
              //     topic: model.topics[index],
              //     onTap: (topic) => ShareExperienceProfileController.to.openTopic(topic, model.profile, model.topics),
              //   ),
              // ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(
                  right: Decorations.paddingHorizontal,
                  top: 16,
                  bottom: 12,
                ),
                child: Text(model.selfTitleText, style: context.textTheme.titleSmall),
              ),
              if (model.self.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: context.height * 0.03),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AssetPaths.messageBubbleEmptyState, width: context.width * 0.3),
                      const SizedBox(
                        height: 16,
                        width: double.infinity,
                      ),
                      Text('هنوز هیچ فعالیتی ثبت نشده', style: context.textTheme.bodyMedium),
                      const SizedBox(
                        height: 16,
                        width: double.infinity,
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  itemCount: model.self.length,
                  padding: Decorations.pagePaddingHorizontal.copyWith(bottom: 24),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (_, index) => const Divider(height: 32),
                  itemBuilder: (_, index) => ShareExperienceCommentWidget(
                    comment: model.self[index],
                    onLike: ShareExperienceController.to.like,
                    onDislike: ShareExperienceController.to.dislike,
                    onComment: ShareExperienceProfileController.to.onComment,
                    onDeletePressed: ShareExperienceProfileController.to.deleteExperience,
                    hasDeletePlaceholder: true,
                    onMoreMenuPressed: ShareExperienceProfileController.to.moreMenuExperience,
                  ),
                ),
              if (model.self.isNotEmpty && model.showMoreStory)
                const Divider(
                  height: 0,
                  endIndent: Decorations.paddingHorizontal,
                  indent: Decorations.paddingHorizontal,
                ),
              if (model.self.isNotEmpty && model.showMoreStory) const SizedBox(height: 24),
              if (model.self.isNotEmpty && model.showMoreStory)
                LoadMoreWidget(
                  onTap: ShareExperienceProfileController.to.openSelf,
                  text: 'مشاهده تمام پست های ${model.isSelf ? ' شما' : model.profile.username}',
                ),

              const Divider(
                height: 16,
                thickness: 4,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: Decorations.paddingHorizontal,
                  top: 16,
                  bottom: 12,
                ),
                child: Text(
                  model.activitiesTitleText,
                  style: context.textTheme.titleSmall,
                ),
              ),
              if (model.activities.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: context.height * 0.03),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AssetPaths.messageBubbleEmptyState, width: context.width * 0.3),
                      const SizedBox(
                        height: 16,
                        width: double.infinity,
                      ),
                      Text('هنوز هیچ فعالیتی ثبت نشده', style: context.textTheme.bodyMedium),
                    ],
                  ),
                )
              else
                ListView.separated(
                  itemCount: model.activities.length,
                  padding: Decorations.pagePaddingHorizontal.copyWith(bottom: 24),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (_, index) => const Divider(height: 32),
                  itemBuilder: (_, index) => ShareExperienceCommentWidget(
                    comment: model.activities[index],
                    onLike: ShareExperienceController.to.like,
                    onDislike: ShareExperienceController.to.dislike,
                    onComment: ShareExperienceProfileController.to.onComment,
                    onProfilePressed: ShareExperienceProfileController.to.onOpenProfile,
                    hasDeletePlaceholder: true,
                    onDeletePressed: ShareExperienceProfileController.to.deleteExperience,
                  ),
                ),
              if (model.activities.isNotEmpty && model.showMoreActivity)
                const Divider(
                  height: 0,
                  endIndent: Decorations.paddingHorizontal,
                  indent: Decorations.paddingHorizontal,
                ),
              if (model.activities.isNotEmpty && model.showMoreActivity) const SizedBox(height: 24),
              if (model.activities.isNotEmpty && model.showMoreActivity)
                LoadMoreWidget(
                  onTap: ShareExperienceProfileController.to.openActivity,
                  text: 'مشاهده تمام فعالیت های ${model.isSelf ? 'شما' : model.profile.username}',
                ),
            ],
          ),
        ),
        onLoading: Center(
          child: LoadingIndicatorWidget(
            color: context.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class LoadMoreWidget extends StatelessWidget {
  final void Function()? onTap;
  final String text;

  const LoadMoreWidget({
    super.key,
    this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: context.textTheme.labelMedium?.copyWith(color: context.colorScheme.primary),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              AssetPaths.arrowLeft,
              color: context.colorScheme.primary,
              width: 20,
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
