import 'package:taakitecture/taakitecture.dart';

import '../../../social/data/models/share_experience_comment_model.dart';
import '../../../social/data/models/share_experience_topic_model.dart';

class TopicModel extends BaseModel with ModelMixin {
  bool? isValidAction;
  late int totalCount;
  late String id;
  late String coverImage;
  late String inputText;
  late String bio;
  late bool prohibtShareExp;
  late String name;
  late String image;
  ShareExperienceTopicModel currentTopic = ShareExperienceTopicModel();
  late List<ShareExperienceCommentModel> list;

  @override
  BaseModel getInstance() => TopicModel();

  @override
  Map<String, dynamic> get properties => {
        "totalCount": totalCount,
        "id": id,
        "coverImage": coverImage,
        "inputText": inputText,
        "bio": bio,
        "prohibtShareExp": prohibtShareExp,
        "name": name,
        "image": image,
        "list": list,
      };

  @override
  void setProp(String key, value) {
    currentTopic.setProp(key, value);

    switch (key) {
      case "totalCount":
        totalCount = value;
        break;
      case "id":
        id = value;
        break;
      case "coverImage":
        coverImage = value;
        break;
      case "inputText":
        inputText = value;
        break;
      case "bio":
        bio = value;
        break;
      case "prohibtShareExp":
        prohibtShareExp = value;
        break;
      case "name":
        name = value;
        break;
      case "image":
        image = value;
        break;
      case "list":
        list = [for (var mapJson in value) ShareExperienceCommentModel().fromJson(mapJson)];
        break;
    }
  }
}
