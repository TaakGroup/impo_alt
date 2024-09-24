import 'package:get/get.dart';
import 'package:social/features/share_experience/profile/data/models/profile_model.dart';
import 'package:social/features/share_experience/social/data/models/share_experience_comment_model.dart';
import 'package:social/features/share_experience/social/data/models/share_experience_topic_model.dart';
import 'package:taakitecture/taakitecture.dart';

class ShareExperienceProfileModel extends BaseModel with ModelMixin {
  late String topicsTitleText;
  late String selfTitleText;
  late String activitiesTitleText;
  late String usernameHintText;
  late String notificationActivationMessage;
  late ProfileModel profile;
  late bool isSelf;
  late bool isDr;
  late bool showMoreActivity;
  late bool showMoreStory;
  late RxBool isNotificationActive;
  late List<ShareExperienceTopicModel> topics;
  late List<ShareExperienceCommentModel> self;
  late List<ShareExperienceCommentModel> activities;

  @override
  BaseModel getInstance() => ShareExperienceProfileModel();

  @override
  Map<String, dynamic> get properties => {};

  @override
  void setProp(String key, value) {
    switch (key) {
      case "topicsTitleText":
        topicsTitleText = value;
        break;
      case "selfTitleText":
        selfTitleText = value;
        break;
      case "activitiesTitleText":
        activitiesTitleText = value;
        break;
      case "usernameHintText":
        usernameHintText = value;
        break;
      case "profile":
        profile = ProfileModel().fromJson(value);
        break;
      case "topics":
        topics = value;
        break;
      case "isSelf":
        isSelf = value;
        break;
      case "notificationActivationMessage":
        notificationActivationMessage = value;
        break;
      case "isNotificationActive":
        isNotificationActive = (value as bool).obs;
        break;
      case "self":
        self = [for (var mapJson in value) ShareExperienceCommentModel().fromJson(mapJson)];
        break;
      case "activities":
        activities = [for (var mapJson in value) ShareExperienceCommentModel().fromJson(mapJson)];
        break;
      case "isDr":
        isDr = value;
        break;
      case "showMoreActivity":
        showMoreActivity = value;
        break;
      case "showMoreStory":
        showMoreStory = value;
        break;
    }
  }
}
