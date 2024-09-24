import 'package:social/core/app/utils/mixin/handle_failure_mixin.dart';
import 'package:taakitecture/taakitecture.dart';

enum TopicStatus { scheduled, live, closed , none}

class ShareExperienceTopicModel extends BaseModel with ModelMixin {
  late String id;
  late String image;
  String? name;
  late String inputText;
  late String coverImage;
  late String bio;
  TopicStatus? topicStatus;

  @override
  BaseModel getInstance() => ShareExperienceTopicModel();

  bool get isLive => topicStatus == TopicStatus.live;

  @override
  Map<String, dynamic> get properties => {
        "id": id,
        "image": image,
        "name": name,
        "inputText": inputText,
        "coverImage": coverImage,
        "bio": bio,
        "topicStatus": topicStatus?.index ?? TopicStatus.none.index,
      };

  @override
  void setProp(String key, value) {
    switch (key) {
      case "id":
        id = value;
        break;
      case "image":
        image = value;
        break;
      case "name":
        name = value;
        break;
      case "inputText":
        inputText = value;
        break;
      case "coverImage":
        coverImage = value;
        break;
      case "bio":
        bio = value;
        break;
      case "topicStatus":
        topicStatus = TopicStatus.values[value];
        break;
    }
  }
}
