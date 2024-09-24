import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social/features/share_experience/social/controller/share_experience_action_mixin.dart';
import 'package:social/features/share_experience/social/data/models/new_experience_model.dart';
import 'package:social/features/share_experience/social/data/models/share_experience_comment_model.dart';
import 'package:social/features/share_experience/social/view/pages/delete_experience_sheet.dart';
import 'package:taakitecture/taakitecture.dart';

import '../../../../core/app/constants/messages.dart';
import '../../../../core/app/view/widgets/toast.dart';
import 'comment_controller.dart';

class CreateReplyController extends BaseController with ShareExperienceActionMixin {
  late final FocusNode focusNode;
  AnimatedListState animatedList = AnimatedListState();
  RxBool replyMode = false.obs;
  ShareExperienceCommentModel replyOn = ShareExperienceCommentModel();
  TextEditingController replyTextController = TextEditingController();

  CreateReplyController(super.remoteRepository);

  static CreateReplyController get to => Get.find();

  String get experienceId => CommentController.to.shareId;

  @override
  onInit() {
    focusNode = FocusNode();

    super.onInit();
  }

  focusOnReply(BuildContext context, ShareExperienceCommentModel value, AnimatedListState animatedList) async {
    focusNode.requestFocus();
    replyOn = value;
    replyMode.value = true;
    this.animatedList = animatedList;
    await Future.delayed(const Duration(milliseconds: 200));
    focusNode.requestFocus();
  }

  sendReply() async {
    if (replyTextController.text.isNotEmpty) {
      create(
        params: '$experienceId/comment/${replyOn.id}/reply',
        model: NewExperienceModel()..text = replyTextController.text,
      ).then(
        (either) => either.fold(
          (l) => null,
          (result) {
            int index = replyOn.replies.length;
            replyOn.replies.add(result.currentComment);
            animatedList.insertItem(index);
          },
        ),
      );

      cancelReply();
    } else {
      toast(message: Messages.experienceEmptyError);
    }
  }

  cancelReply() {
    replyTextController.clear();
    focusNode.unfocus();
    replyMode.value = false;
    replyTextController.clear();
  }

  @override
  like(ShareExperienceCommentModel reply, {String? path}) {
    return super.like(
      reply,
      path: '$experienceId/comments/$path/replies/${reply.id}/like',
    );
  }

  @override
  dislike(ShareExperienceCommentModel reply, {String? path, String? deletePath}) {
    return super.dislike(
      reply,
      path: '$experienceId/comments/$path/replies/${reply.id}/dislike',
      deletePath: '$experienceId/comments/$path/replies/${reply.id}/like',
    );
  }

  @override
  void onClose() {
    focusNode.dispose();
    super.onClose();
  }

  deleteReply(ShareExperienceCommentModel comment, ShareExperienceCommentModel reply, Function(int index) onRemoved) {
    RxBool isLoading = false.obs;

    return DeleteExperienceSheet.showSheet(
      isLoading: isLoading,
      isComment: true,
      onDeletePressed: () async {
        isLoading.value = true;

        delete('$experienceId/comment/${comment.id}/reply/${reply.id}');

        int index = comment.replies.indexOf(reply);

        if (index != -1) {
          comment.replies.removeAt(index);
          onRemoved.call(index);
        }

        Get.back();
      },
    );
  }
}
