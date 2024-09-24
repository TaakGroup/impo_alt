import 'package:get/get.dart';
import 'package:social/core/app/constants/app_routes.dart';
import 'package:social/features/share_experience/social/controller/share_experience_action_mixin.dart';
import 'package:social/features/share_experience/social/data/models/share_experience_model.dart';
import 'package:taakitecture/taakitecture.dart';
import '../../controller/new_experience_controller.dart';
import '../../profile/data/models/profile_model.dart';
import '../../view/pages/new_experience_page.dart';
import '../data/models/share_experience_comment_model.dart';
import '../data/models/share_experience_topic_model.dart';
import 'other_share_experience_controller.dart';

class ShareExperienceController extends BaseController<ShareExperienceModel> with ShareExperienceActionMixin {
  Map<String, String?>? parameters = Get.parameters;
  Rx<ShareExperienceType> shareExperienceType = ShareExperienceType.other.obs;
  List<ShareExperienceCommentModel> pins = [];

  ShareExperienceController(super.remoteRepository);

  static ShareExperienceController get to => Get.find();

  @override
  onInit() {
    shareExperienceType.value = ShareExperienceType.other;

    initShareExperience().then(
      (request) {
        request.fold(
          (l) => null,
          (ShareExperienceModel r) {
            if (parameters?['route'] == AppRoutes.comment) {
              onComment(ShareExperienceCommentModel()..id = parameters!['id']!, r.profile, r.topics);
            } else if (parameters?['route'] == AppRoutes.topic) {
              openTopic(ShareExperienceTopicModel()..id = parameters!['id']!, r.profile, r.topics);
            }
          },
        );
      },
    );

    super.onInit();
  }

  initShareExperience() {
    OtherShareExperienceController.to.initPaging();
    // SelfShareExperienceController.to.initPaging();

    return getShareExperience();
  }

  getShareExperience() => find();

  @override
  onSuccess(ShareExperienceModel result) async {
    pins.addAll(result.pins.where((element) => element.isPin));
    OtherShareExperienceController.to.items.addAll(result.otherComments);

    super.onSuccess(result);
  }

  newExperience(ProfileModel profile, List<ShareExperienceTopicModel> topics) async {
    NewExperienceController.to.resetExperience();

    final bool? hasNewExperience = await Get.to(
      NewExperiencePage(
        profile: profile,
        topics: topics,
      ),
      transition: Transition.downToUp,
    );

    NewExperienceController.to.resetExperience();

    if (hasNewExperience == true) initShareExperience();
  }

  openTopic(ShareExperienceTopicModel topic, ProfileModel profile, List<ShareExperienceTopicModel> topics) =>
      Get.toNamed(AppRoutes.topic, arguments: (topic, profile, topics))?.then((result) {
        initShareExperience();
      });

  onComment(ShareExperienceCommentModel comment, ProfileModel profile, List<ShareExperienceTopicModel> topics) =>
      Get.toNamed(AppRoutes.comment, arguments: (comment, profile, topics))?.then(
        (result) {
          if (result != null) {
            comment.likeCount.value = result.likeCount.value;
            comment.disliked.value = result.disliked.value;
            comment.commentCount?.value = result.commentCount?.value;
            comment.state?.value = result.state?.value;
          }
        },
      );

  void openProfile(String? userId, profile, topics) {
    if (userId != null && userId.isNotEmpty) {
      Get.toNamed(
        AppRoutes.shareExperienceProfile,
        arguments: (
          userId,
          profile,
          topics,
        ),
      )?.then((value) => initShareExperience());
    }
  }
}
