import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social/core/app/view/widgets/toast.dart';
import 'package:social/features/messenger/data/models/messenger_model.dart';
import 'package:taakitecture/taakitecture.dart';
import '../../../core/app/utils/mixin/handle_failure_mixin.dart';
import '../data/models/message_model.dart';
import 'package:flutter/scheduler.dart';

class MessengerController extends BaseController<MessengerModel> with HandleFailureMixin {
  final GlobalKey<SliverAnimatedListState> listKey = GlobalKey<SliverAnimatedListState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  bool initService = true;
  String chatId = Get.parameters['id'] ?? "";
  ScrollController scrollController = ScrollController();
  TextEditingController messageTextEditingController = TextEditingController();
  List<MessagesModel> messages = [];
  RxBool canSendMessages = false.obs;
  bool hasPartner = true;

  MessengerController(super.remoteRepository);

  static MessengerController get to => Get.find();

  @override
  Future<void> onInit() async {
    getAllMessage();

    messageTextEditingController.addListener(() => canSendMessages.value = messageTextEditingController.text.isNotEmpty);

    super.onInit();
  }

  Future<Either> getAllMessage() => find('$chatId/chat');

  refreshChat() async {
    final request = await getAllMessage();

    request.fold((l) => null, (result) {
      final oldLength = messages.length;
      final newLength = result.messages.length;
      final deference = newLength - oldLength;

      messages.clear();
      messages.addAll(result.messages);
      _animatedList.insertAllItems(0, deference);
    });
  }

  SliverAnimatedListState get _animatedList => listKey.currentState!;

  sendMessage({String? replayId}) async {
    String text = messageTextEditingController.text.trim();
    messageTextEditingController.clear();

    if (text.isNotEmpty) {
      MessagesModel newMessage = MessagesModel()
        ..text = text
        ..messageStatus.value = MessageStatus.pending
        ..side = MessageSide.self
        ..time = DateTime.now()
        ..replyId = replayId;

      messages.insert(0, newMessage);
      _animatedList.insertItem(0);

      final request = await create(model: newMessage, params: '$chatId/chat');

      request.fold((l) => null, (r) {
        if(r.id.isNotEmpty) {
          newMessage.id == r.id;
          newMessage.messageStatus.value = MessageStatus.sent;
        } else {
          hasPartner = false;
          toast(message: 'پارتنرت رابطه همدلی رو حذف کرده و ادامه چالش ممکن نیست');
        }
      });
    }
  }

  @override
  onLoading() {
    if (initService) {
      super.onLoading();
    }
  }

  @override
  onSuccess(result) {
    if (initService) {
      messages.addAll(result.messages);
      initService = false;
      super.onSuccess(result);
    }
  }
}
