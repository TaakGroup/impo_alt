

import 'package:taakitecture/taakitecture.dart';

class ValidModel extends BaseModel {
  bool? valid;

  @override
  fromJson(Map<String, dynamic> json) {
    valid = json['valid'] ?? json['isValid'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() => {'valid': valid};
}
