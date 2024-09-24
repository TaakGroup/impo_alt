import 'package:social/features/share_experience/social/data/models/share_experience_comment_model.dart';
import 'package:taakitecture/taakitecture.dart';

import '../../../profile/data/models/profile_model.dart';
import 'share_experience_topic_model.dart';

enum ShareExperienceType { other, self }

class ShareExperienceModel extends BaseModel with ModelMixin {
  bool? valid;
  late String selfTitleText;
  late String groupsTitleText;
  late String otherTitleText;
  late String inputText;
  late String topicName;
  late ProfileModel profile;
  late List<ShareExperienceTopicModel> topics;
  late List<ShareExperienceCommentModel> otherComments;
  late List<ShareExperienceCommentModel> selfComments;
  late List<ShareExperienceCommentModel> pins;
  int? totalCount;
  late List<ShareExperienceCommentModel> list;

  @override
  BaseModel getInstance() => ShareExperienceModel();

  @override
  Map<String, dynamic> get properties => {
        "selfTitleText": selfTitleText,
        "groupsTitleText": groupsTitleText,
        "otherTitleText": otherTitleText,
        "inputText": inputText,
        "topics": topics,
        "other": otherComments,
        "self": otherComments,
      };

  @override
  void setProp(String key, value) {
    switch (key) {
      case "topics":
        topics = [for (var mapJson in value) ShareExperienceTopicModel().fromJson(mapJson)];
        break;
      case "other":
        otherComments = [for (var mapJson in value) ShareExperienceCommentModel().fromJson(mapJson)];
        break;
      case "self":
        selfComments = [for (var mapJson in value) ShareExperienceCommentModel().fromJson(mapJson)];
        break;
      case "pin":
        pins = [for (var mapJson in value) ShareExperienceCommentModel().fromJson(mapJson)];
        break;
      case "list":
        list = [for (var mapJson in value) ShareExperienceCommentModel().fromJson(mapJson)];
        break;
      case "replies":
        list = [for (var mapJson in value) ShareExperienceCommentModel().fromJson(mapJson)];
        break;
      case "selfTitleText":
        selfTitleText = value;
        break;
      case "groupsTitleText":
        groupsTitleText = value;
        break;
      case "otherTitleText":
        otherTitleText = value;
        break;
      case "inputText":
        inputText = value;
        break;
      case "profile":
        profile = ProfileModel().fromJson(value);
        break;
      case "totalCount":
        totalCount = value;
        break;
      case "topicName":
        topicName = value;
        break;
      case "valid":
        valid = value;
        break;
    }
  }
}
