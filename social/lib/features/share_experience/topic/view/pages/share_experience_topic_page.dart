import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/constants/assets_paths.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:social/core/app/view/themes/styles/decorations.dart';
import 'package:social/features/share_experience/topic/controller/topic_controller.dart';
import '../../../../../core/app/constants/app_routes.dart';
import '../../../../../core/app/view/widgets/loading_indicator_widget.dart';
import '../../../social/view/widgets/share_exerience_input.dart';
import '../../../social/view/widgets/share_experience_comment_widget.dart';

class ShareExperienceTopicPage extends StatelessWidget {
  const ShareExperienceTopicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TopicController.to.obx(
        (_) => ShareExperienceInput(
          onTap: TopicController.to.newExperience,
          hintText: TopicController.to.topic.inputText,
          avatar: TopicController.to.profile.avatarImage!,
        ),
        onLoading: TopicController.to.topic.name != null
            ? ShareExperienceInput(
                onTap: TopicController.to.newExperience,
                hintText: TopicController.to.topic.inputText,
                avatar: TopicController.to.profile.avatarImage!,
              )
            : const SizedBox(),
      ),
      body: TopicController.to.obx(
        (_) => CustomScrollView(
          controller: TopicController.to.scroll,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: false,
              snap: false,
              pinned: true,
              expandedHeight: 220,
              leading: IconButton(
                style: ElevatedButton.styleFrom(backgroundColor: context.colorScheme.background),
                onPressed: Get.back,
                icon: SvgPicture.asset(
                  AssetPaths.back,
                  color: context.colorScheme.onBackground,
                  height: 24,
                  width: 24,
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: const SizedBox(),
                background: Stack(
                  children: [
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: TopicController.to.topic.coverImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: Decorations.paddingHorizontal,
                      left: Decorations.paddingHorizontal,
                      bottom: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            TopicController.to.topic.name!,
                            style: context.textTheme.titleMedium?.copyWith(color: context.colorScheme.background),
                          ),
                          const SizedBox(height: 4),
                          if (TopicController.to.topic.bio.isNotEmpty)
                            Text(
                              TopicController.to.topic.bio,
                              style: context.textTheme.labelLarge?.copyWith(
                                color: context.colorScheme.background,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Make the initial height of the SliverAppBar larger than normal.
            ),
            CupertinoSliverRefreshControl(
              onRefresh: TopicController.to.onRefresh,
            ),
            TopicController.to.obx(
              (_) => SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: Decorations.paddingHorizontal),
                sliver: SliverList(
                  // initialItemCount: TopicController.to.items.length,
                  delegate: SliverChildBuilderDelegate(
                    (_, index) => Column(
                      children: [
                        ShareExperienceCommentWidget(
                          comment: TopicController.to.items[index],
                          onLike: TopicController.to.like,
                          onDislike: TopicController.to.dislike,
                          onComment: (comment) => TopicController.to.onComment(comment),
                          onDeletePressed: TopicController.to.deleteExperience,
                          onProfilePressed: (id) {
                            if (id != null) {
                              Get.toNamed(
                                AppRoutes.shareExperienceProfile,
                                arguments: (
                                  id,
                                  TopicController.to.profile,
                                  TopicController.to.topics,
                                ),
                              );
                            }
                          },
                        ),
                        if (index + 1 == TopicController.to.items.length)
                          Center(
                            child: Obx(
                              () => LoadingIndicatorWidget(
                                isShow: TopicController.to.isPaginationLoading.value,
                                color: context.colorScheme.primary,
                                padding: const EdgeInsets.only(top: 16),
                              ),
                            ),
                          )
                        else
                          const Divider(height: 32)
                      ],
                    ),
                    childCount: TopicController.to.items.length,
                  ),
                ),
              ),
              onLoading: SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                  (_, index) => Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(child: LoadingIndicatorWidget(color: context.colorScheme.primary)),
                  ),
                ),
              ),
              onEmpty: SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                  (_, index) => SizedBox(
                    height: context.height / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AssetPaths.ticketsEmptyState, width: context.width * 0.3),
                        const SizedBox(
                          height: 16,
                          width: double.infinity,
                        ),
                        Text('هنوز هیچ نظری برای این تالار ثبت نشده.', style: context.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        onLoading: CustomScrollView(
          controller: TopicController.to.scroll,
          physics: const BouncingScrollPhysics(),
          slivers: [
            if (TopicController.to.topic.name != null)
              SliverAppBar(
                floating: false,
                snap: false,
                pinned: true,
                expandedHeight: 220,
                leading: IconButton(
                  style: ElevatedButton.styleFrom(backgroundColor: context.colorScheme.background),
                  onPressed: Get.back,
                  icon: SvgPicture.asset(
                    AssetPaths.back,
                    color: context.colorScheme.onBackground,
                    height: 24,
                    width: 24,
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: const SizedBox(),
                  background: Stack(
                    children: [
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: TopicController.to.topic.coverImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: Decorations.paddingHorizontal,
                        left: Decorations.paddingHorizontal,
                        bottom: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              TopicController.to.topic.name!,
                              style: context.textTheme.titleMedium?.copyWith(color: context.colorScheme.background),
                            ),
                            const SizedBox(height: 4),
                            if (TopicController.to.topic.bio.isNotEmpty)
                              Text(
                                TopicController.to.topic.bio,
                                style: context.textTheme.labelLarge?.copyWith(
                                  color: context.colorScheme.background,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Make the initial height of the SliverAppBar larger than normal.
              ),
            CupertinoSliverRefreshControl(
              onRefresh: TopicController.to.onRefresh,
            ),
            SliverFillRemaining(
              child: Center(
                child: LoadingIndicatorWidget(color: context.colorScheme.primary),
              ),
            )
          ],
        ),
      ),
    );
  }
}
