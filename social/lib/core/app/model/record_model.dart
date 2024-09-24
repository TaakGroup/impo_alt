import 'package:taakitecture/taakitecture.dart';

class RecordeModel extends BaseModel {
  final List<(String , dynamic)> records;

  RecordeModel(this.records);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};

    for ((String , dynamic) record in records) {
      json[record.$1] = record.$2;
    }

    return json;
  }

  @override
  fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}
