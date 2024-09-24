import 'package:taakitecture/taakitecture.dart';

class AuthModel extends BaseModel {
  late bool isRegister;

  @override
  fromJson(Map<String, dynamic> json) {
    isRegister = json['isRegister'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() => {'isRegister': isRegister};
}
