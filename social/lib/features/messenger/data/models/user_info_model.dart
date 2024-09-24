import 'package:taakitecture/taakitecture.dart';

enum Gender { female, male }

class UserInfoModel extends BaseModel with ModelMixin {
  late Gender gender;
  late String title;
  late String age;
  late String sex;
  late String phase;
  late String phaseDetail;

  @override
  BaseModel getInstance() => UserInfoModel();

  @override
  Map<String, dynamic> get properties => {
        "gender": gender,
        "title": title,
        "age": age,
        "sex": sex,
        "phase": phase,
        "phaseDetail": phaseDetail,
      };

  @override
  void setProp(String key, value) {
    switch (key) {
      case "gender":
        gender = value;
        break;
      case "title":
        title = value;
        break;
      case "age":
        age = value;
        break;
      case "sex":
        sex = value;
        break;
      case "phase":
        phase = value;
        break;
      case "phaseDetail":
        phaseDetail = value;
        break;
    }
  }
}
