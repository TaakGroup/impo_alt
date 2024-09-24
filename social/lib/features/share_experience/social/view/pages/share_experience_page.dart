import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:social/core/app/view/themes/styles/decorations.dart';
import 'package:social/core/app/view/widgets/loading_indicator_widget.dart';
import '../../../../../core/app/constants/app_routes.dart';
import '../../../../../core/app/constants/assets_paths.dart';
import '../../controller/other_share_experience_controller.dart';
import '../../controller/share_experience_controller.dart';
import '../widgets/share_exerience_input.dart';
import '../widgets/share_experience_comment_widget.dart';
import '../widgets/share_experience_topic_widget.dart';

class ShareExperiencePage extends StatelessWidget {
  const ShareExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('اشتراک تجربه'),
        ),
        actions: [
          ShareExperienceController.to.obx(
              (model) => GestureDetector(
                    onTap: () => ShareExperienceController.to.openProfile(model.profile.id, model.profile, model.topics),
                    child: Container(
                      margin: const EdgeInsets.only(left: Decorations.paddingHorizontal),
                      padding: Decorations.pagePaddingHorizontal,
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: context.colorScheme.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: context.colorScheme.surface),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider('${model!.profile.avatarImage}'),
                        ),
                      ),
                    ),
                  ),
              onLoading: const SizedBox())
        ],
      ),
      bottomNavigationBar: ShareExperienceController.to.obx(
        (model) => ShareExperienceInput(
          onTap: () => ShareExperienceController.to.newExperience(model.profile, model.topics),
          hintText: model!.inputText,
          avatar: model.profile.avatarImage!,
        ),
        onLoading: const SizedBox(),
      ),
      body: ShareExperienceController.to.obx(
        (model) => Column(
          children: [
            // Padding(
            //   padding: Decorations.pagePaddingHorizontal.copyWith(top: 8),
            //   child: Obx(
            //     () => Row(
            //       children: [
            //         Expanded(
            //           child: ChipWidget(
            //             isSelected: ShareExperienceController.to.shareExperienceType.value == ShareExperienceType.other,
            //             title: model!.otherTitleText,
            //             onTap: () => ShareExperienceController.to.onChangeTab(ShareExperienceType.other),
            //           ),
            //         ),
            //         const SizedBox(width: 8),
            //         Expanded(
            //           child: ChipWidget(
            //             isSelected: ShareExperienceController.to.shareExperienceType.value == ShareExperienceType.self,
            //             title: model.selfTitleText,
            //             onTap: () => ShareExperienceController.to.onChangeTab(ShareExperienceType.self),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 16),
            Expanded(
              child: GetBuilder<OtherShareExperienceController>(builder: (controller) {
                return RefreshIndicator(
                  displacement: 1,
                  onRefresh: controller.onRefresh,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    controller: controller.scroll,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (ShareExperienceController.to.pins.isNotEmpty)
                          ListView.separated(
                            itemCount: ShareExperienceController.to.pins.length,
                            padding: Decorations.pagePaddingHorizontal.copyWith(bottom: 16, top: 8),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (_, index) => const Divider(height: 32),
                            itemBuilder: (_, index) => ShareExperienceCommentWidget(
                              comment: ShareExperienceController.to.pins[index],
                              onLike: ShareExperienceController.to.like,
                              onDislike: ShareExperienceController.to.dislike,
                              onComment: (comment) => ShareExperienceController.to.onComment(comment, model!.profile, model.topics),
                              onProfilePressed: (id) => id != null
                                  ? Get.toNamed(AppRoutes.shareExperienceProfile, arguments: (id, model!.profile, model.topics))
                                  : null,
                            ),
                          ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: Decorations.pagePaddingHorizontal.copyWith(top: 8),
                            child: Text(
                              model!.groupsTitleText,
                              style: context.textTheme.titleSmall,
                            ),
                          ),
                        ),
                        Container(
                          height: 132,
                          padding: const EdgeInsets.only(top: 8),
                          child: ListView.separated(
                            itemCount: model!.topics.length,
                            padding: Decorations.pagePaddingHorizontal,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, index) => ShareExperienceTopicWidget(
                              topic: model.topics[index],
                              onTap: (topic) => ShareExperienceController.to.openTopic(topic, model.profile, model.topics),
                            ),
                            separatorBuilder: (_, index) => const SizedBox(width: 8),
                          ),
                        ),
                        const Divider(
                          thickness: 4,
                          height: 32,
                        ),
                        controller.obx(
                          (_) => ListView.separated(
                            itemCount: controller.items.length,
                            padding: Decorations.pagePaddingHorizontal.copyWith(bottom: 24),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (_, index) {
                              return Column(
                                children: [
                                  ShareExperienceCommentWidget(
                                    comment: controller.items[index],
                                    onLike: controller.like,
                                    onDislike: controller.dislike,
                                    onComment: (comment) => ShareExperienceController.to.onComment(comment, model!.profile, model.topics),
                                    onDeletePressed: controller.deleteExperience,
                                    onProfilePressed: (id) => id != null
                                        ? Get.toNamed(AppRoutes.shareExperienceProfile, arguments: (id, model!.profile, model.topics))
                                        : null,
                                    hasDeletePlaceholder: false,
                                    onMoreMenuPressed: controller.moreMenuExperience,
                                  ),
                                  if (index + 1 == controller.items.length)
                                    Center(
                                      child: Obx(
                                        () => LoadingIndicatorWidget(
                                          isShow: controller.isPaginationLoading.value,
                                          color: context.colorScheme.primary,
                                          padding: const EdgeInsets.only(top: 16),
                                        ),
                                      ),
                                    )
                                ],
                              );
                            },
                            separatorBuilder: (_, index) => const Divider(height: 32),
                          ),
                          onLoading: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: LoadingIndicatorWidget(color: context.colorScheme.primary),
                            ),
                          ),
                          onEmpty: Center(
                            child: SizedBox(
                              height: context.height * 0.8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Spacer(),
                                  Image.asset(AssetPaths.ticketsEmptyState, width: context.width * 0.3),
                                  const SizedBox(
                                    height: 16,
                                    width: double.infinity,
                                  ),
                                  Text('هنوز هیچ نظری برای این تالار ثبت نشده.', style: context.textTheme.bodyMedium),
                                  const Spacer(flex: 2),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            )
          ],
        ),
        onLoading: Center(child: LoadingIndicatorWidget(color: context.colorScheme.primary)),
      ),
    );
  }
}
