import 'package:taakitecture/taakitecture.dart';

class FileResponseModel extends BaseModel with ModelMixin {
  late String name;
  late bool valid;

  @override
  BaseModel getInstance() => FileResponseModel();

  @override
  Map<String, dynamic> get properties => {
        "name" : name,
        "valid" : valid,
  };

  @override
  void setProp(String key, value) {
    switch (key) {
      case "name":
        name = value;
        break;
      case "valid":
        valid = value;
        break;
    }
  }
}
