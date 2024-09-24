import 'package:taakitecture/taakitecture.dart';

import '../../../social/data/models/share_experience_comment_model.dart';

class CommentModel extends BaseModel with ModelMixin {
  bool? isValidAction;
  late int totalCount;
  ShareExperienceCommentModel currentComment = ShareExperienceCommentModel();
  late ShareExperienceCommentModel reply;
  late List<ShareExperienceCommentModel> list;

  @override
  BaseModel getInstance() => CommentModel();

  @override
  Map<String, dynamic> get properties => {
        "list": list,
      };

  @override
  void setProp(String key, value) {
    currentComment.setProp(key, value);

    switch (key) {
      case "comments":
        list = [for (var mapJson in value) ShareExperienceCommentModel().fromJson(mapJson)];
        break;
      case "commentCount":
        totalCount = value;
        break;
      case "valid":
        isValidAction = value;
        break;
      case "reply":
        currentComment = ShareExperienceCommentModel().fromJson(value);
        break;
    }
  }
}
