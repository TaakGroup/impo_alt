
import 'package:taakitecture/taakitecture.dart';

class RegisterOtpModel extends BaseModel with ModelMixin{
  late String identity;
  late String  code;
  late String phoneModel;

  static fromValue({required String identity, required String code, required String phoneModel}) => RegisterOtpModel().fromJson({
    'identity': identity,
    'code': code,
    'phoneModel': phoneModel,
  });

  @override
  BaseModel getInstance() => RegisterOtpModel();

  @override
  Map<String, dynamic> get properties => {
    "identity" : identity,
    "code" : code,
    "phoneModel" : phoneModel,
  };

  @override
  void setProp(String key, value) {
    switch (key) {
      case "identity":
        identity = value;
        break;
      case "code":
        code = value;
        break;
      case "phoneModel":
        phoneModel = value;
        break;
    }
  }

  
}