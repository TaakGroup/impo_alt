import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:taakitecture/taakitecture.dart';

import '../../social/data/models/share_experience_comment_model.dart';
import 'comment_controller.dart';

class ReplyController extends BaseController {
  final RxBool isPaginationLoading = false.obs;
  int pageSize = 5;
  int pageNo = 0;
  int skipSize = 1;

  ReplyController(super.remoteRepository);

  @override
  void onInit() {
    change(null, status: RxStatus.success());

    super.onInit();
  }

  String get experienceId => CommentController.to.shareId;

  getMoreReplies(ShareExperienceCommentModel comment, AnimatedListState animatedList) {
    find('$experienceId/comment/${comment.id}/replies/$skipSize/$pageNo/$pageSize').then(
      (value) => value.fold(
        (failure) => null,
        (result) {
          int index = comment.replies.length;
          comment.replies.addAll(result.list);
          animatedList.insertAllItems(index, result.list.length);
        },
      ),
    );
  }

  @override
  onLoading() {
    isPaginationLoading.value = true;
  }

  @override
  onSuccess(result) {
    pageNo += 1;
    isPaginationLoading.value = false;

    return super.onSuccess(result);
  }

  removeAt(int p1) {
  }
}
