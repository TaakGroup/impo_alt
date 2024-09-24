import 'package:social/features/share_experience/social/data/models/share_experience_comment_model.dart';
import 'package:taakitecture/taakitecture.dart';

class ShareExperienceActivitiesModel extends BaseModel with ModelMixin {
  late int totalCount;
  late List<ShareExperienceCommentModel> list;

  @override
  BaseModel getInstance() => ShareExperienceActivitiesModel();

  @override
  Map<String, dynamic> get properties => {};

  @override
  void setProp(String key, value) {
    switch (key) {
      case "totalCount":
        totalCount = value;
        break;
      case "list":
        list = [for (var mapJson in value) ShareExperienceCommentModel().fromJson(mapJson)];
        break;
    }
  }
}
