import 'package:get/get.dart';
import 'package:taakitecture/taakitecture.dart';

import '../../../../core/app/view/widgets/toast.dart';
import '../data/models/share_experience_comment_model.dart';
import '../view/pages/delete_experience_sheet.dart';
import '../view/widgets/report_experience_dialog.dart';
import '../view/widgets/share_experience_more_menu_sheet.dart';

mixin ShareExperienceActionMixin<Model> on BaseController<Model> {
  like(ShareExperienceCommentModel comment, {String? path}) {
    if (comment.state?.value == ExperienceActionState.like) {
      comment.state!.value = ExperienceActionState.none;
      comment.likeCount.value -= 1;
      return delete(path ?? 'like/${comment.id}');
    } else {
      if (comment.state?.value == ExperienceActionState.dislike) {
        comment.state!.value = ExperienceActionState.none;
        comment.disliked.value -= 1;
      }
      comment.state!.value = ExperienceActionState.like;
      comment.likeCount.value += 1;
      return find(path ?? 'like/${comment.id}');
    }
  }

  dislike(ShareExperienceCommentModel comment, {String? path, String? deletePath}) {
    if (comment.state?.value == ExperienceActionState.dislike) {
      comment.state!.value = ExperienceActionState.none;
      comment.disliked.value -= 1;
      return delete(deletePath ?? 'like/${comment.id}');
    } else {
      if (comment.state?.value == ExperienceActionState.like) {
        comment.state!.value = ExperienceActionState.none;
        comment.likeCount.value -= 1;
      }
      comment.state!.value = ExperienceActionState.dislike;
      comment.disliked.value += 1;
      return find(path ?? 'dislike/${comment.id}');
    }
  }

  deleteExperience(ShareExperienceCommentModel comment) {
    RxBool isLoading = false.obs;

    return DeleteExperienceSheet.showSheet(
      isLoading: isLoading,
      onDeletePressed: () {
        isLoading.value = true;
        delete(comment.id).then((either) {
          either.fold(
            (l) {
              // should be Handle in HandleFailureMixin
            },
            (r) => Get.back(result: true),
          );
        });
      },
    );
  }

  moreMenuExperience(ShareExperienceCommentModel comment) {
    return ShareExperienceMoreMenuSheet.showSheet(onReportPressed: () => reportExperience(comment));
  }

  reportExperience(ShareExperienceCommentModel comment) {
    RxBool isLoading = false.obs;

    return ReportDialog.showDialog(
      isLoading: isLoading,
      reportPressed: () {
        isLoading.value = true;
        find('report/${comment.id}').then((either) {
          either.fold(
            (l) {
              // should be Handle in HandleFailureMixin
            },
            (r) {
              Get.back(result: true);
              toast(message: 'پست با موفقیت ریپورت شد', snackPosition: SnackPosition.TOP);
            },
          );
        });
      },
    );
  }

  deleteComment(ShareExperienceCommentModel comment, String shareId) {
    RxBool isLoading = false.obs;

    return DeleteExperienceSheet.showSheet(
      isComment: true,
      isLoading: isLoading,
      onDeletePressed: () {
        isLoading.value = true;
        delete('$shareId/comments/${comment.id}').then((either) {
          either.fold(
            (l) {
              // should be Handle in HandleFailureMixin
            },
            (r) => Get.back(),
          );
        });
      },
    );
  }
}
