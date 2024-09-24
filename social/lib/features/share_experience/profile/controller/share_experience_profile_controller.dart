import 'package:get/get.dart';
import 'package:social/core/app/constants/app_routes.dart';
import 'package:social/features/share_experience/social/controller/share_experience_action_mixin.dart';
import 'package:social/features/share_experience/social/data/models/share_experience_comment_model.dart';
import 'package:social/features/share_experience/social/data/models/share_experience_topic_model.dart';
import 'package:taakitecture/taakitecture.dart';

import '../../social/controller/share_experience_controller.dart';
import '../data/models/profile_model.dart';
import '../data/models/share_experience_profile_model.dart';

class ShareExperienceProfileController extends BaseController<ShareExperienceProfileModel> with ShareExperienceActionMixin {
  (String userId, ProfileModel profile, List<ShareExperienceTopicModel> topics) args = Get.arguments;
  late ShareExperienceProfileModel shareExperienceProfile;

  ShareExperienceProfileController(super.remoteRepository);

  static ShareExperienceProfileController get to => Get.find();

  @override
  onInit() {
    getProfile();

    super.onInit();
  }

  String get id => args.$1;

  getProfile() => find(id);

  openTopic(ShareExperienceTopicModel topic, ProfileModel profile, List<ShareExperienceTopicModel> topics) async {
    final result = await Get.toNamed(AppRoutes.topic, arguments: (topic, profile, topics));
    if (result == true) {
      getProfile();
    }
  }

  @override
  onSuccess(ShareExperienceProfileModel result) {
    shareExperienceProfile = result;

    return super.onSuccess(result);
  }

  void openActivity() => Get.toNamed(
        AppRoutes.profileActivity,
        arguments: (
          '$id/activity',
          shareExperienceProfile.activitiesTitleText,
        ),
      );

  void openSelf() => Get.toNamed(
        AppRoutes.profileActivity,
        arguments: (
          '$id/self',
          shareExperienceProfile.selfTitleText,
        ),
      );

  Future<void> editProfile() async {
    final result = await Get.toNamed(
      AppRoutes.editShareExperienceProfile,
      arguments: (
        shareExperienceProfile.profile,
        shareExperienceProfile.usernameHintText,
      ),
    );

    if (result == true) {
      getProfile();
    }
  }

  void onComment(ShareExperienceCommentModel comment) => Get.toNamed(
        AppRoutes.comment,
        arguments: (
          comment,
          args.$2,
          args.$3,
        ),
      );

  void onOpenProfile(String? id) {
    if (id != null) {
      Get.toNamed(
        AppRoutes.shareExperienceProfile,
        arguments: (
          id,
          args.$2,
          args.$3,
        ),
      );
    }
  }

  @override
  deleteExperience(ShareExperienceCommentModel comment) async {
    final result = await ShareExperienceController.to.deleteExperience(comment);
    if (result == true) {
      getProfile();
    }
  }

  @override
  reportExperience(ShareExperienceCommentModel comment) {
    ShareExperienceController.to.reportExperience(comment);
  }
}
