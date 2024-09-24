import 'package:get/get.dart';
import 'package:social/core/app/constants/app_routes.dart';
import 'package:social/features/share_experience/social/controller/base_share_experience_controller.dart';
import 'package:social/features/share_experience/social/data/models/share_experience_comment_model.dart';
import 'package:social/features/share_experience/social/data/models/share_experience_topic_model.dart';
import 'package:social/features/share_experience/view/pages/new_comment_page.dart';

import '../../profile/data/models/profile_model.dart';

class CommentController extends BaseShareExperienceController {
  (ShareExperienceCommentModel comment, ProfileModel profile, List<ShareExperienceTopicModel> topics) arg = Get.arguments;
  late ShareExperienceCommentModel comment;
  late String shareId;

  CommentController(super.remoteRepository);

  static CommentController get to => Get.find();

  ProfileModel get profile => arg.$2;

  onWillBack() {
    Get.back(result: comment);
    return true;
  }

  @override
  String get path => 'comments/${comment.id}';

  @override
  like(ShareExperienceCommentModel comment, {String? path}) {
    return super.like(comment, path: "$shareId/comments/${comment.id}/like");
  }

  @override
  dislike(ShareExperienceCommentModel comment, {String? path, String? deletePath}) {
    return super.dislike(
      comment,
      path: "$shareId/comments/${comment.id}/dislike",
      deletePath: "$shareId/comments/${comment.id}/like",
    );
  }

  @override
  void onInit() {
    comment = arg.$1;
    shareId = comment.id;

    super.onInit();

    change(null, status: RxStatus.loading());

    getExperiences();
  }

  Future<void> newExperience() async {
    final bool? hasNewComment = await NewCommentPage.showSheet(
      arg.$2,
      arg.$3,
      shareOn: '${comment.id}/comments',
    );

    if (hasNewComment == true) onRefresh();
  }

  @override
  onLoading() {
    if (isInitialLoading) {
      change(null, status: RxStatus.loading());
    }
  }

  openProfile(String? userId) {
    if (userId != null && userId.isNotEmpty) {
      return Get.toNamed(
        AppRoutes.shareExperienceProfile,
        arguments: (
          userId,
          arg.$2,
          arg.$3,
        ),
      );
    }
  }

  @override
  onSuccess(result) {
    isInitialLoading = false;
  }

  @override
  void onResult(r) {
    isInitialLoading = false;
    comment.commentCount?.value = r.currentComment.commentCount.value;
    comment = r.currentComment;
    comment.id = shareId;
  }
}
