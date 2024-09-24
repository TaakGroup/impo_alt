import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/constants/assets_paths.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:social/core/app/utils/extensions/on_datetime/convertor.dart';
import 'package:social/core/app/view/themes/styles/text_theme.dart';
import 'package:social/features/messenger/view/widgets/bubble/image_widget.dart';
import 'package:social/features/share_experience/comments/controller/reply_controller.dart';
import 'package:social/features/share_experience/social/data/models/share_experience_comment_model.dart';

class CommentCardWidget extends GetWidget<ReplyController> {
  final ShareExperienceCommentModel comment;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final void Function(ShareExperienceCommentModel model)? onLike;
  final void Function(ShareExperienceCommentModel model)? onDislike;
  final void Function(String? userId)? onOpenProfile;
  final void Function(ShareExperienceCommentModel model)? onMoreMenuPressed;

  const CommentCardWidget({
    super.key,
    required this.comment,
    this.onLike,
    this.onDislike,
    this.onOpenProfile,
    this.backgroundColor,
    this.padding,
    this.onMoreMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 56,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => comment.selfExperience ? () {} : onOpenProfile?.call(comment.userId),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: ShapeDecoration(
                      color: context.colorScheme.surface,
                      shape: const CircleBorder(),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(comment.avatar),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              comment.name!,
                              style: context.textTheme.labelLargeProminent,
                            ),
                            const SizedBox(width: 2.0),
                            if (comment.approvedProfile)
                              SvgPicture.asset(
                                AssetPaths.verifyTick,
                                height: 16,
                                width: 16,
                              ),
                          ],
                        ),
                        if (comment.biography.isNotEmpty) const SizedBox(height: 4),
                        if (comment.biography.isNotEmpty) Text(comment.biography, style: context.textTheme.bodySmall),
                        Text(
                          '${comment.createTime.toNowText} ${comment.topicName != null && comment.topicName!.isNotEmpty ? '.' : ''} ${comment.topicName ?? ''}',
                          style: context.textTheme.labelSmall?.copyWith(color: context.colorScheme.outline),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            comment.text!,
            style: context.textTheme.bodySmall,
          ),
          if (comment.image != null && comment.image!.isNotEmpty) const SizedBox(height: 8),
          if (comment.image != null && comment.image!.isNotEmpty)
            AspectRatio(
              aspectRatio: 1,
              child: ImageWidget(
                imageUrl: comment.image!,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: comment.state != null && !comment.selfExperience ? () => onLike?.call(comment) : null,
                  child: Row(
                    children: [
                      Opacity(
                        opacity: comment.selfExperience ? 0.3 : 1.0,
                        child: SvgPicture.asset(
                          comment.state?.value == ExperienceActionState.like ? AssetPaths.likeFill : AssetPaths.like,
                          height: 20,
                          width: 20,
                          color: comment.state?.value == ExperienceActionState.like
                              ? context.colorScheme.primary
                              : context.colorScheme.outline,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        comment.likeCount.value.toString(),
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => GestureDetector(
                  onTap: comment.state != null && !comment.selfExperience ? () => onDislike?.call(comment) : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: comment.selfExperience ? 0.3 : 1.0,
                        child: SvgPicture.asset(
                          comment.state?.value == ExperienceActionState.dislike
                              ? AssetPaths.dislikeFill
                              : AssetPaths.dislike,
                          height: 20,
                          width: 20,
                          color: comment.state?.value == ExperienceActionState.dislike
                              ? context.colorScheme.primary
                              : context.colorScheme.outline,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        comment.disliked.value.toString(),
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.asset(AssetPaths.message),
                    const SizedBox(width: 4),
                    Text(
                      comment.commentCount!.value.toString(),
                      style: context.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              if (!comment.selfExperience)
                Align(
                  alignment: Alignment.bottomLeft,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onMoreMenuPressed?.call(comment),
                    child: Icon(
                      Icons.more_vert_rounded,
                      size: 20,
                      color: context.colorScheme.outline,
                    ),
                  ),
                )
              else
                const SizedBox(height: 20, width: 20),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
