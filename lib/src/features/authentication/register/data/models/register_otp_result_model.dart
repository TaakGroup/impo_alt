import 'package:taakitecture/taakitecture.dart';

class RegisterOtpResultModel extends BaseModel with ModelMixin {
  late bool result;
  late String token;

  @override
  BaseModel getInstance() => RegisterOtpResultModel();

  @override
  Map<String, dynamic> get properties => {
        'result': result,
        'token': token,
      };

  @override
  void setProp(String key, value) {
    switch (key) {
      case "result":
        result = value;
        break;
      case "token":
        token = value;
        break;
    }
  }
}
