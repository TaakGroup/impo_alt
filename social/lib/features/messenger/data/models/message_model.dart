import 'package:get/get.dart';
import 'package:taakitecture/taakitecture.dart';

enum MessageSide { self, other }

enum MessageStatus { pending, sent, seen }

class MessagesModel extends BaseModel with ModelMixin {
  String? id;
  String? replyId;
  late String text;
  late DateTime time;
  late MessageSide side;
  Rx<MessageStatus> messageStatus = MessageStatus.sent.obs;

  @override
  BaseModel getInstance() => MessagesModel();

  @override
  Map<String, dynamic> get properties => {
        "id": id,
        "createTime": time.toString(),
        "text": text,
        "replyId": replyId,
        "side": side.index,
      };

  bool get isOwner => side == MessageSide.self;

  @override
  List<Object?> get props => [id];

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'id':
        id = value;
        break;
      case 'replyId':
        replyId = value;
        break;
      case 'createTime':
        time = DateTime.parse(value);
        break;
      case 'text':
        text = value;
        break;
      case 'side':
        side = MessageSide.values[value];
        break;
    }
  }
}
