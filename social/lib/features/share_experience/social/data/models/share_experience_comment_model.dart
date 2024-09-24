import 'package:get/get.dart';
import 'package:taakitecture/taakitecture.dart';


enum ExperienceActionState { none, like, dislike }

class ShareExperienceCommentModel extends BaseModel with ModelMixin {
  String? topicName;
  String? userId;
  late bool isEdit;
  String? text;
  String? image;
  late bool isPin;
  late String id;
  late bool isDelete;
  late DateTime createTime;
  String? name;
  bool selfExperience = false;
  late bool prohibtComment;
  late String avatar;
  late bool approvedProfile;
  late RxInt likeCount;
  late RxInt disliked;
  Rx<ExperienceActionState>? state;
  RxInt? commentCount;
  late int repliesCount = 0;
  late RxList<ShareExperienceCommentModel> replies = <ShareExperienceCommentModel>[].obs;
  String biography = '';
  int get remainReplyCount => repliesCount - replies.length;

  @override
  BaseModel getInstance() => ShareExperienceCommentModel();

  @override
  List<Object?> get props => [id];

  @override
  Map<String, dynamic> get properties => {
        "topicName": topicName,
        // "isEdit": isEdit,
        "text": text,
        "image": image,
        // "isPin": isPin,
        "id": id,
        // "isDelete": isDelete,
        "createTime": createTime,
        "name": name,
        // "selfExperience": selfExperience,
        // "prohibtComment": prohibtComment,
        "avatar": avatar,
        "approvedProfile": approvedProfile,
        "likeCount": likeCount.value,
        "disliked": disliked.value,
        "state": state,
        "commentCount": commentCount?.value,
        "biography": biography,
      };

  @override
  void setProp(String key, value) {

    switch (key) {
      case "topicName":
        topicName = value;
        break;
      case "userId":
        userId = value;
        break;
      case "isEdit":
        isEdit = value;
        break;
      case "text":
        text = value;
        break;
      case "image":
        image = value;
        break;
      case "isPin":
        isPin = value;
        break;
      case "id":
        id = value;
        break;
      case "isDelete":
        isDelete = value;
        break;
      case "createTime":
        createTime = DateTime.parse(value);
        break;
      case "name":
      case "userName":
        name = value;
        break;
      case "selfExperience":
      case "selfComment":
      case "self":
        selfExperience = value;
        break;
      case "prohibtComment":
        prohibtComment = value;
        break;
      case "avatar":
        avatar = value;
        break;
      case "approvedProfile":
        approvedProfile = value;
        break;
      case "likeCount":
        likeCount = (value as int).obs;
        break;
      case "disliked":
      case "dislikeCount":
        disliked = (value as int).obs;
        break;
      case "state":
        state = ExperienceActionState.values[value].obs;
        break;
      case "commentCount":
        commentCount = (value as int).obs;
        break;
      case "biography":
        biography = value;
        break;
      case "repliesCount":
        repliesCount = value;
        break;
      case "replies":
        List<ShareExperienceCommentModel> list = [for(var mapJson in value) ShareExperienceCommentModel().fromJson(mapJson)];
        replies = list.obs;
        break;
    }
  }
}
