import 'package:taakitecture/taakitecture.dart';

class JsonModel extends BaseModel {
  Map<String, dynamic> json;

  JsonModel([this.json = const {}]);

  @override
  Map<String, dynamic> toJson() => json;

  @override
  fromJson(Map<String, dynamic> json) => this.json = json;
}
