import 'package:flutter/material.dart';
import 'package:impo/src/architecture/model/sendMessage_model.dart';
import 'package:impo/src/architecture/view/sendMessage_view.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/core/app/view/widgets/snackbar/custom_snack_bar.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/models/partner/get_messages_partner_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:rxdart/rxdart.dart';


class SendMessagePresenter {

  late SendMessageView _sendMessageView;

  SendMessageModel _messageModel = SendMessageModel();

  SendMessagePresenter(SendMessageView view) {
    this._sendMessageView = view;
  }

  final isLoading = BehaviorSubject<bool>.seeded(false);
  final tryButtonError = BehaviorSubject<bool>.seeded(false);
  final valueError = BehaviorSubject<String>.seeded('');
  final isLoadingButton = BehaviorSubject<bool>.seeded(false);
  final messages = BehaviorSubject<List<GetMessagesPartnerModel>>.seeded([]);
  final textMessage = BehaviorSubject<String>.seeded('');


  Stream<bool> get isLoadingObserve => isLoading.stream;
  Stream<bool> get tryButtonErrorObserve => tryButtonError.stream;
  Stream<String> get valueErrorObserve => valueError.stream;
  Stream<bool> get isLoadingButtonObserve => isLoadingButton.stream;
  Stream<List<GetMessagesPartnerModel>> get messagesObserve => messages.stream;
  Stream<String> get textMessageObserve => textMessage.stream;


  String _token = '';
  List<GetMessagesPartnerModel> _allMessages = [];

  Future<String> getToken()async{
    if(_token == ''){
      RegisterParamViewModel register =  _messageModel.getRegisters();
      _token = register.token!;
    }
    return _token;
  }

  onChangeTextField(String value){
    // if(value.length >= 301){
    //   showToast('تعداد حرفها نمیتواند بیشتر از 300 حرف باشد', context,gravity: 2);
    // }
    if(!textMessage.isClosed){
      textMessage.sink.add(value);
    }
  }


  Future<RegisterParamViewModel> getRegister()async{
    RegisterParamViewModel register =  _messageModel.getRegisters();
    return register;
  }


  getMessages()async{
    _allMessages.clear();
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'message',
        'GET',
        {

        },
        await getToken()
    );

    if(responseBody != null){

      if(responseBody['messages'] != []){
        responseBody['messages'].forEach((item){
          _allMessages.add(GetMessagesPartnerModel.fromJson(item));
        });
        // print(_allMessages.length);
        // print(_allMessages[0].text);
        // print(_allMessages[1].text);
        // print(_allMessages[2].text);
        // print(_allMessages[3].text);
        // print('///////////////////////');
        List<GetMessagesPartnerModel> _messages = [];
        if(_allMessages.length > 2){
          // print('a');
          _messages.add(_allMessages[_allMessages.length-2]);
          _messages.add(_allMessages[_allMessages.length-1]);
        }else{
          // print('b');
          _messages = _allMessages;
        }

        List<String> messageIds = [];
        for(int i=0 ; i<_allMessages.length ; i++){
          if(_allMessages[i].fromMan && !_allMessages[i].readFlag){
            messageIds.add(_allMessages[i].messageId);
          }
        }

        if(messageIds.isNotEmpty){
          readMessages(messageIds);
        }else{
          if(!isLoading.isClosed){
            isLoading.sink.add(false);
          }
        }

        if(!messages.isClosed){
          messages.sink.add(_messages);
        }

      }else{
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }
      }

    }else{
      if(!tryButtonError.isClosed){
        tryButtonError.sink.add(true);
      }
      valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }
  }

  createMessage(context)async{
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(true);
    }

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'message',
        'PUT',
        {
          "fileName" : '',
          "text" : textMessage.stream.value
        },
        await getToken()
    );
    print(responseBody);
    if(responseBody != null){
      if(responseBody['valid']){
        if(!isLoadingButton.isClosed){
          isLoadingButton.sink.add(false);
        }
        if(!textMessage.isClosed){
          textMessage.sink.add('');
        }
        getMessages();

      }else{
        if(!isLoadingButton.isClosed){
          isLoadingButton.sink.add(false);
        }
        showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);

      }
    }else{
      if(!isLoadingButton.isClosed){
        isLoadingButton.sink.add(false);
      }
      showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
    }

 }

  readMessages(List<String> messageIds)async{
    print('readMessages');
    print(messageIds);
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'message',
        'POST',
        {
          "messageIds" : messageIds,
        },
        await getToken()
    );
    print(responseBody);
    if(responseBody != null){
      if(responseBody['valid']){
        setNotReadMessage();
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }
      }else{
        if(!tryButtonError.isClosed){
          tryButtonError.sink.add(true);
        }
        valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');

      }

    }else{
      if(!tryButtonError.isClosed){
        tryButtonError.sink.add(true);
      }
      valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }
  }

  setNotReadMessage()async{
    if(!notReadMessage.isClosed){
      notReadMessage.sink.add(0);
    }
  }

  showToast(String message,context){
    //Fluttertoast.showToast(msg:message,toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.BOTTOM);
    CustomSnackBar.show(context, message);
  }

  dispose(){
    isLoading.close();
    tryButtonError.close();
    valueError.close();
    isLoadingButton.close();
    messages.close();
    textMessage.close();
  }

}