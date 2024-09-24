import 'package:taakitecture/taakitecture.dart';

class ValidateRegisterModel extends BaseModel with ModelMixin{
  late bool result;
  late bool pair;
  late String token;
  @override
  BaseModel getInstance() => ValidateRegisterModel();

  @override
  Map<String, dynamic> get properties => {
    'result' : result,
    'pair' : pair,
    'token' : token
  };

  @override
  void setProp(String key, value) {
    switch (key) {
      case "result":
        result = value;
        break;
      case "pair":
        pair = value;
        break;
      case "token":
        token = value;
        break;
    }
  }

}