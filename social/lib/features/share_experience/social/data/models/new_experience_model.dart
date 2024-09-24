import 'package:taakitecture/taakitecture.dart';

class NewExperienceModel extends BaseModel with ModelMixin {
  String? text;
  String? topicId;
  String? image;

  @override
  BaseModel getInstance() => NewExperienceModel();

  @override
  Map<String, dynamic> get properties => {
        "text": text,
        "topicId": topicId ?? '',
        "image": image ?? '',
      };

  @override
  void setProp(String key, value) {
    switch (key) {
      case "text":
        text = value;
        break;
      case "topicId":
        topicId = value;
        break;
      case "image":
        image = value;
        break;
    }
  }
}
