import 'package:taakitecture/taakitecture.dart';

class ShareExperienceFileModel extends BaseModel with ModelMixin {
  late bool valid;
  late String name;

  @override
  BaseModel getInstance() => ShareExperienceFileModel();

  @override
  Map<String, dynamic> get properties => {
        "valid" : valid,
        "name" : name,
  };

  @override
  void setProp(String key, value) {
    switch (key) {
      case "valid":
        valid = value;
        break;
      case "name":
        name = value;
        break;
    }
  }
}
