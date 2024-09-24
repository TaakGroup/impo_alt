import 'package:taakitecture/taakitecture.dart';

class ProfileModel extends BaseModel with ModelMixin {
  late String id;
  String? medicalNumber;
  late String username;
  late String expertise;
  late String biography;
  String? avatarImage;
  List<String>? avatars;
  int? selectedIndex;

  @override
  BaseModel getInstance() => ProfileModel();

  @override
  Map<String, dynamic> get properties => {
        "id": id,
        "medicalNumber": medicalNumber,
        "username": username,
        "expertise": expertise,
        "biography": biography,
        "avatarImage": avatarImage,
        "avatars": avatars,
        "selectedIndex": selectedIndex,
      };

  @override
  void setProp(String key, value) {
    switch (key) {
      case "id":
      case "userId":
        id = value;
        break;
      case "medicalNumber":
        medicalNumber = value;
        break;
      case "username":
        username = value;
        break;
      case "expertise":
        expertise = value;
        break;
      case "biography":
        biography = value;
        break;
      case "avatarImage":
        avatarImage = value;
        break;
      case "selectedIndex":
        selectedIndex = value;
        break;
      case "avatars":
        avatars = [for(var avatar in value) avatar.toString()];
        break;
    }
  }
}
