import 'package:taakitecture/taakitecture.dart';
import 'message_model.dart';

class MessengerModel extends BaseModel with ModelMixin {
  String? id;
  late DateTime createTime;
  late String partnerName;
  late String partnerAvatar;
  late String text;
  late List<MessagesModel> messages;

  @override
  BaseModel getInstance() => MessengerModel();

  @override
  Map<String, dynamic> get properties => {};

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'items':
        messages = [for (var mapJson in value) MessagesModel().fromJson(mapJson)];
        break;
      case 'createTime':
        createTime = DateTime.parse(value);
        break;
      case 'partnerName':
        partnerName = value;
        break;
      case 'partnerAvatar':
        partnerAvatar = value;
        break;
      case 'text':
        text = value;
        break;
      case 'id':
        id = value;
        break;
    }
  }
}
