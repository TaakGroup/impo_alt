import 'package:taakitecture/taakitecture.dart';

class DirectPayModel extends BaseModel with ModelMixin {
  late bool isSuccess;
  late String message;
  late String token;

  @override
  BaseModel getInstance() => DirectPayModel();

  @override
  Map<String, dynamic> get properties => {};

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'isSuccess':
        isSuccess = value;
        break;
      case 'message':
        message = value;
        break;
      case 'token':
        token = value;
        break;
    }
  }
}