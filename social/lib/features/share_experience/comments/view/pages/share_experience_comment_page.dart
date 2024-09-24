import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:social/features/share_experience/comments/controller/comment_controller.dart';
import 'package:social/features/share_experience/comments/controller/create_reply_controller.dart';

import '../../../../../core/app/constants/assets_paths.dart';
import '../../../../../core/app/view/themes/styles/buttons/button_types.dart';
import '../../../../../core/app/view/themes/styles/decorations.dart';
import '../../../../../core/app/view/widgets/loading_indicator_widget.dart';
import '../../../social/controller/other_share_experience_controller.dart';
import '../../../social/view/widgets/share_exerience_input.dart';
import '../../../social/view/widgets/share_experience_comment_widget.dart';
import '../widgets/comment_card_widget.dart';

class ShareExperienceCommentPage extends StatelessWidget {
  const ShareExperienceCommentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommentController>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
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
        ),
        body: CommentController.to.obx(
          (model) => Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  displacement: 1,
                  onRefresh: CommentController.to.onRefresh,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: CommentController.to.scroll,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GetBuilder<OtherShareExperienceController>(
                            builder: (controller){
                              return CommentCardWidget(
                                padding: Decorations.pagePaddingHorizontal,
                                backgroundColor: context.colorScheme.surfaceVariant,
                                comment: CommentController.to.comment,
                                onLike: controller.like,
                                onDislike: controller.dislike,
                                onOpenProfile: CommentController.to.openProfile,
                                onMoreMenuPressed: controller.moreMenuExperience,
                              );
                            }
                        ),
                        const Divider(
                          height: 0,
                          thickness: 4,
                        ),
                        CommentController.to.obx(
                          (_) => CommentController.to.items.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.only(top: context.height * 0.1),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(AssetPaths.ticketsEmptyState, width: context.width * 0.3),
                                      const SizedBox(
                                        height: 16,
                                        width: double.infinity,
                                      ),
                                      Text(
                                        CommentController.to.comment.selfExperience
                                            ? 'هنوز هیچ نظری برای تجربه تو ثبت نشده'
                                            : 'اولین نظر رو برای این تجربه، ثبت کن',
                                        style: context.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: CommentController.to.items.length,
                                  padding: Decorations.pagePaddingHorizontal.copyWith(bottom: 16, top: 24),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (_, index) => Column(
                                    children: [
                                      ShareExperienceCommentWidget(
                                        comment: CommentController.to.items[index],
                                        onReplyPressed: (a, b) => CreateReplyController.to.focusOnReply(context, a, b),
                                        onLike: CommentController.to.like,
                                        onDislike: CommentController.to.dislike,
                                        onDeletePressed: (comment) =>
                                            CommentController.to.deleteComment(comment, CommentController.to.comment.id),
                                        onReplyLikePressed: (comment, reply) => CreateReplyController.to.like(reply, path: comment.id),
                                        onReplyDislikePressed: (comment, reply) =>
                                            CreateReplyController.to.dislike(reply, path: comment.id),
                                        onReplyDeletePressed: CreateReplyController.to.deleteReply,
                                        onProfilePressed: CommentController.to.openProfile,
                                      ),
                                      if (index + 1 == CommentController.to.items.length)
                                        Center(
                                          child: Obx(
                                            () => LoadingIndicatorWidget(
                                              isShow: CommentController.to.isPaginationLoading.value,
                                              color: context.colorScheme.primary,
                                              padding: const EdgeInsets.only(top: 16),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                  separatorBuilder: (_, index) => const Divider(height: 32),
                                ),
                          onLoading: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(48.0),
                              child: LoadingIndicatorWidget(color: context.colorScheme.primary),
                            ),
                          ),
                          // onEmpty: Padding(
                          //   padding: EdgeInsets.only(top: context.height * 0.1),
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Image.asset(AssetPaths.ticketsEmptyState, width: context.width * 0.3),
                          //       const SizedBox(
                          //         height: 16,
                          //         width: double.infinity,
                          //       ),
                          //       Text('هنوز هیچ نظری برای تجربه شما ثبت نشده.', style: context.textTheme.bodyMedium),
                          //     ],
                          //   ),
                          // ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Obx(
                () => ShareExperienceInput(
                  onTap: CommentController.to.newExperience,
                  hintText: 'نظرت رو در مورد این تجربه بنویس',
                  avatar: CommentController.to.profile.avatarImage!,
                  controller: CreateReplyController.to.replyTextController,
                  replayTo: CreateReplyController.to.replyOn.name,
                  replyMode: CreateReplyController.to.replyMode.value,
                  onSendPressed: CreateReplyController.to.sendReply,
                  focusNode: CreateReplyController.to.focusNode,
                  onCancelReplyPressed: CreateReplyController.to.cancelReply,
                ),
              ),
            ],
          ),
          onLoading: GetBuilder<CommentController>(
            builder: (controller) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    if (controller.comment.text != null)
                      Column(
                        children: [
                          GetBuilder<OtherShareExperienceController>(
                              builder: (otherShareExpController){
                                return CommentCardWidget(
                                  padding: Decorations.pagePaddingHorizontal,
                                  backgroundColor: context.colorScheme.surfaceVariant,
                                  comment: controller.comment,
                                  onLike: otherShareExpController.like,
                                  onDislike: otherShareExpController.dislike,
                                  onOpenProfile: controller.openProfile,
                                );
                              }
                          ),
                          const Divider(
                            height: 0,
                            thickness: 4,
                          ),
                        ],
                      ),
                    Expanded(child: Center(child: LoadingIndicatorWidget(color: context.colorScheme.primary))),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
