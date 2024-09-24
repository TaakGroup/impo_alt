import 'package:taakitecture/taakitecture.dart';

class ValidModel extends BaseModel {
  bool? valid;
  bool? result;

  @override
  fromJson(Map<String, dynamic> json) {
    valid = json['valid'] ?? json['isValid'] ?? json['result'];
    result = json['result'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() => {'valid': valid};
}
