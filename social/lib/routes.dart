import 'package:get/get.dart';
import 'package:social/features/share_experience/profile/controller/share_experience_profile_activities_controller.dart';
import 'package:social/features/share_experience/profile/view/pages/edit_share_experience_profile_page.dart';
import 'package:social/features/share_experience/profile/view/pages/share_experience_profile_page.dart';
import 'package:social/features/share_experience/social/view/pages/share_experience_page.dart';
import 'package:social/features/share_experience/topic/view/pages/share_experience_topic_page.dart';
import 'core/app/constants/app_routes.dart';
import 'features/messenger/messanger_bindings.dart';
import 'features/messenger/view/pages/messenger_page.dart';
import 'features/share_experience/comments/comment_bindings.dart';
import 'features/share_experience/profile/share_experience_profile_bindings.dart';
import 'features/share_experience/profile/view/pages/share_experience_profile_activities_page.dart';
import 'features/share_experience/share_exerience_bindings.dart';
import 'features/share_experience/comments/view/pages/share_experience_comment_page.dart';
import 'features/share_experience/social/topic_bindings.dart';

class Routs {
  static List<GetPage> routs = <GetPage>[
    GetPage(
      name: AppRoutes.shareExperience,
      page: () => const ShareExperiencePage(),
      bindings: [
        ShareExperienceBindings(),
        UploadShareExperienceBindings(),
      ],
    ),
    GetPage(
      name: AppRoutes.topic,
      page: () => const ShareExperienceTopicPage(),
      binding: TopicBindings(),
    ),
    GetPage(
      name: AppRoutes.comment,
      page: () => const ShareExperienceCommentPage(),
      binding: CommentBindings(),
    ),
    GetPage(
      name: AppRoutes.shareExperienceProfile,
      page: () => const ShareExperienceProfilePage(),
      binding: ShareExperienceProfileBindings(),
    ),
    GetPage(
      name: AppRoutes.profileActivity,
      page: () => const shareExperienceProfileActivitiesPage(),
      binding: ShareExperienceProfileActivityBindings(),
    ),
    GetPage(
      name: AppRoutes.editShareExperienceProfile,
      page: () => const EditShareExperienceProfilePage(),
      binding: EditShareExperienceProfileBindings(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const MessengerPage(),
      binding: MessengerBindings(),
    ),
  ];
}
