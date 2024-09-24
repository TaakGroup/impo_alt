import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:impo/src/architecture/model/support_model.dart';
import 'package:impo/src/architecture/view/support_view.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/core/app/view/widgets/snackbar/custom_snack_bar.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/models/expert/file_name_model.dart';
import 'package:impo/src/models/expert/upload_file_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/models/support/support_chat_model.dart';
import 'package:impo/src/models/support/support_category_model.dart';
import 'package:impo/src/models/support/support_hostory_model.dart';
import 'package:impo/src/models/support/support_ticket_model.dart';
import 'package:impo/src/screens/home/blank_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/supportOnline/pages/chat_support_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webview_flutter/webview_flutter.dart';


class SupportPresenter {

  late SupportView _supportView;
  SupportModel _supportModel = SupportModel();

  SupportPresenter(SupportView view) {
    this._supportView = view;
  }

  final dialogScale = BehaviorSubject<double>.seeded(0.0);
  final isLoading = BehaviorSubject<bool>.seeded(false);
  final isLoadingButton = BehaviorSubject<bool>.seeded(false);
  final tryButtonError = BehaviorSubject<bool>.seeded(false);
  final valueError = BehaviorSubject<String>.seeded('');
  final allCategory = BehaviorSubject<SupportCategoryModel>();
  final uploadFiles = BehaviorSubject<List<UploadFileModel>>.seeded([]);
  final sendValuePercentUploadFile = BehaviorSubject<double>.seeded(0);
  final textSend = BehaviorSubject<String>.seeded('');
  final isMoreHistoryLoading = BehaviorSubject<bool>.seeded(false);
  final historySupports = BehaviorSubject<List<SupportHistoryModel>>.seeded([]);
  final supportTicket = BehaviorSubject<SupportTicketModel>();
  final controllerTextChat = BehaviorSubject<String>.seeded('');
  final textRate = BehaviorSubject<String>.seeded('');
  final valueRate = BehaviorSubject<double>.seeded(0.0);
  final isShowFeedbackDialog = BehaviorSubject<bool>.seeded(false);


  Stream<double> get dialogScaleObserve => dialogScale.stream;
  Stream<bool> get isLoadingObserve => isLoading.stream;
  Stream<bool> get isLoadingButtonObserve => isLoadingButton.stream;
  Stream<bool> get tryButtonErrorObserve => tryButtonError.stream;
  Stream<String> get valueErrorObserve => valueError.stream;
  Stream<SupportCategoryModel> get allCategoryObserve => allCategory.stream;
  Stream<List<UploadFileModel>> get uploadFilesObserve => uploadFiles.stream;
  Stream<double> get sendValuePercentUploadFileObserve => sendValuePercentUploadFile.stream;
  Stream<String> get textSendObserve => textSend.stream;
  Stream<bool> get isMoreHistoryLoadingObserve => isMoreHistoryLoading.stream;
  Stream<List<SupportHistoryModel>> get historySupportsObserve => historySupports.stream;
  Stream<SupportTicketModel> get supportTicketObserve => supportTicket.stream;
  Stream<String> get controllerTextChatObserve => controllerTextChat.stream;
  Stream<String> get textRateObserve => textRate.stream;
  Stream<double> get valueRateObserve => valueRate.stream;
  Stream<bool> get isShowFeedbackDialogObserve => isShowFeedbackDialog.stream;


  late  WebViewController webViewController;
  String _token = '';
  late PanelController panelController;
  List<UploadFileModel> _uploadFiles = [];
  Dio _dio =  Dio();
  List<SupportHistoryModel> _historySupports = [];
  int counterNumPageHistorySupports = 0;
  int totalCountHistorySupports = 0;
  late SupportTicketModel _supportTicket;
  List<FileNameModel> _fileNames = [];
  late AnimationController animationControllerDialog;
  late TextEditingController rateValueController;

  Future<String> getToken()async{
    if(_token == ''){
      RegisterParamViewModel register =  _supportModel.getRegisters();
      _token = register.token!;
    }
    return _token;
  }

  initialDialogScale(_this){
    animationControllerDialog = AnimationController(
        vsync: _this,
        lowerBound: 0.0,
        upperBound: 1,
        duration: Duration(milliseconds: 250));
    animationControllerDialog.addListener(() {
      dialogScale.sink.add(animationControllerDialog.value);
    });
  }

  RegisterParamViewModel getRegisters(){
    return _supportModel.getRegisters();
  }


  initPanelController()async{
    panelController =  PanelController();
  }

  openSlidingPanel()async{

    await panelController.open();
  }

  closeSlidingPanel()async{

    await panelController.close();
  }

  onChangeTextField(String value,context){
    if(value.length >= 301){
      showToast('تعداد حرفها نمیتواند بیشتر از 300 حرف باشد', context);
    }
    if(!textSend.isClosed){
      textSend.sink.add(value);
    }
  }

  clearFiles(){
    _uploadFiles.clear();
    if(!uploadFiles.isClosed){
      uploadFiles.sink.add(_uploadFiles);
    }
  }

  sendSupport(context,SupportPresenter supportPresenter) async {
    print(textSend.stream.value);
    if (!isLoadingButton.isClosed) {
      isLoadingButton.sink.add(true);
    }
    String categoryId =allCategory.stream.value.id;
    String categoryName = allCategory.stream.value.title;
    print(categoryName);

    Map<String,dynamic>? responseBody = await Http()
        .sendRequest(womanUrl,
        'support/chat',
        'POST',
        {
          'categoryId' : categoryId,
          'categoryName' : categoryName,
          'title' : '',
          'text' : textSend.stream.value,
          "fileName" : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileNameForSend : '',
        },
        await getToken()
    );
    print(responseBody);
    if (!isLoadingButton.isClosed) {
      isLoadingButton.sink.add(false);
    }
    if (responseBody != null) {

        if(!textSend.isClosed){
          textSend.sink.add('');
        }

        Navigator.pushReplacement(context,
            PageTransition(
                type: PageTransitionType.bottomToTop,
                child:  ChatSupportScreen(
                  supportPresenter: supportPresenter,
                  chatId: responseBody['id'],
                  fromNotify: false,
                  // dashboardPresenter: widget.presenter,
                )
            )
        );

    } else {
      showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
    }
  }

  getAllCategory(context,{String categoryId  = ''})async{
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }
    _historySupports.clear();
    if(!historySupports.isClosed){
      historySupports.sink.add(_historySupports);
    }
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'support/category/$categoryId',
        'GET',
        {},
        await getToken()
    );

    print(responseBody);

    if(responseBody != null){
      if(!allCategory.isClosed){
        allCategory.sink.add(SupportCategoryModel.fromJson(responseBody));
      }
      if(allCategory.stream.value.url == ''){
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }
      }

      if(categoryId == ''){
        responseBody['tickets'].forEach((item){
          _historySupports.add(SupportHistoryModel.fromJson(item));
        });
        if(!historySupports.isClosed){
          historySupports.sink.add(_historySupports);
        }
      }
      if(allCategory.stream.value.url != ''){
        webViewController = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (String url) {
                if(!isLoading.isClosed){
                  isLoading.sink.add(false);
                }
              },
            ),
          )
          ..loadRequest(
            Uri.parse(allCategory.stream.value.url),
          );
      }

    }else{
      if(!tryButtonError.isClosed){
        tryButtonError.sink.add(true);
      }
      valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }

  }



  getFileImage(int type ,context,{String text = '',String chatId = '' })async{
    _uploadFiles.clear();
    if(!uploadFiles.isClosed){
      uploadFiles.sink.add(_uploadFiles);
    }
    PickedFile? file;
    if(type == 2){
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['pdf','doc','rtf','dotx','dotm','docm','docx']);

      if(result != null) {
        file = PickedFile(result.files.single.path!);
        _uploadFiles.add(
            UploadFileModel.fromJson(
                {
                  'name' : file.path.split('/').last,
                  'type' : 1,
                  'fileNameForSend' : '',
                  'stateUpload' : 0,
                  'fileName' : file
                }
            )
        );
        // if(!uploadFiles.isClosed){
        //   uploadFiles.sink.add(_uploadFiles);
        // }
        File fileUpload = File(file.path);
        uploadFile(text, chatId, context,fileUpload,true);
        // print(file);
      } else {
        // User canceled the picker
      }
    }else{
      // ignore: invalid_use_of_visible_for_testing_member
      file = await ImagePicker.platform.pickImage(source: type == 0 ? ImageSource.gallery : ImageSource.camera);

      // File f = File(file.path);

      cropImage(file!.path,text,chatId,context);

    }

    // uploadFile(file,isChatScreen,text,chatId,context);

  }

  cropImage(String imagePath,text, ticketId, context,)async{

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'ایمپو',
            toolbarColor: ColorPallet().mainColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            hideBottomControls: true,
        ),
        IOSUiSettings(
          title: 'ایمپو',
        ),
      ],
    );

    File file = File(croppedFile!.path);

    uploadFile(text, ticketId, context,file,false);
  }


  uploadFile(String text,String ticketId,context,File file,bool isFile)async{
    print('tokken : ${await getToken()}');
    if(!isFile){
      _uploadFiles.add(
          UploadFileModel.fromJson(
              {
                'name' : file.path.split('/').last,
                'type' : 0,
                'fileNameForSend' : '',
                'stateUpload' : 0,
                'fileName' : PickedFile(file.path)
              }
          )
      );

      if(!uploadFiles.isClosed){
        uploadFiles.sink.add(_uploadFiles);
      }
    }
    _dio = Dio();
    _dio.options.contentType = Headers.formUrlEncodedContentType;
    FormData formData = FormData();

    formData.files.addAll(
        [MapEntry('files',MultipartFile.fromFileSync(file.path))]);

    try{

      await _dio.post('$womanUrl/support/file',data: formData,
          onSendProgress: (int sent, int total){
            sendValuePercentUploadFile.sink.add((sent*100)/total);
          },
          options: Options(
              headers: {
                "Authorization": "Bearer ${await getToken()}",
              }
          )

      ).
      then((res)async{
        print(res.statusMessage);
        print(res.statusCode);
        print(res.data);
        if(res.statusMessage == 'OK'){
          // print(res.data);
          _uploadFiles.insert(0,
              UploadFileModel.fromJson(
                  {
                    'name' : _uploadFiles[0].name,
                    'type' : _uploadFiles[0].type,
                    'fileNameForSend' : res.data['name'],
                    'stateUpload' : 1,
                    'fileName' : _uploadFiles[0].fileName
                  }
              )
          );
          _uploadFiles.removeAt(1);
          if(!uploadFiles.isClosed){
            uploadFiles.sink.add(_uploadFiles);
          }
          final File saveFile = File('${await getAppDirectory()}/${res.data['name']}');
          saveFile.writeAsBytes(await file.readAsBytes());
          // if(isChatScreen){
          //   onPressSendMessage(text, ticketId);
          // }
        }else{
          if(_uploadFiles.length != 0){
            showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
            _uploadFiles.removeAt(0);
            if(!uploadFiles.isClosed){
              uploadFiles.sink.add(_uploadFiles);
            }
          }
        }

      });

    }catch(e){
      print('errrrrorr');
      print(e);
      if(_uploadFiles.length != 0){
        showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
        _uploadFiles.removeAt(0);
        if(!uploadFiles.isClosed){
          uploadFiles.sink.add(_uploadFiles);
        }
      }

      // _fileImages.insert(0, ListImageFileModel.fromJson(
      //     {
      //       'name' : _fileImages[0].name,
      //       'fileImage' : _fileImages[0].fileImage,
      //       'stateUpload' : 2,
      //       'assetImages' : isFilm ? 'assets/images/youtube.png' : ''
      //     }
      // ));
      // _fileImages.removeAt(1);
      //
      // if(!fileImages.isClosed){
      //   fileImages.sink.add(_fileImages);
      // }
      //
      // if(!valueUpload.isClosed){
      //   valueUpload.sink.add(1.1);
      // }
      //
      // toastItem.sink.add(ToastModel.setItem('خطا در اتصال لطفا مجددا نلاش کنید', ColorsPalette().deepRed));
      //
      // await animationControllerToast.forward();

    }

  }

  cancelUpload(String path,String fileNameForSend)async{
    print('cancelUpload');
    try{
      File deletedFile = File('${await getAppDirectory()}/$fileNameForSend');
      await deletedFile.delete();
    }catch(e){

    }
    _uploadFiles.removeAt(0);
    if(!uploadFiles.isClosed){
      uploadFiles.sink.add(_uploadFiles);
    }
    _dio.close(force: true);
  }

  Future<String>getAppDirectory()async{
    String dir;
    if(Platform.isAndroid){
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var sdkInt = androidInfo.version.sdkInt;
      if(sdkInt >= 24){
        print('getApplicationDocumentsDirectory');
        dir = (await getApplicationDocumentsDirectory()).path;
      }else{
        print('getExternalStorageDirectory');
        dir = (await getExternalStorageDirectory())!.path;
      }
    }else{
      dir = (await getApplicationDocumentsDirectory()).path;
    }
    return dir;
  }



  getHistorySupport({int pageNum = 0 , int pageSize = 10, int? state})async{
    if(state == 0){
      if(!isLoading.isClosed){
        isLoading.sink.add(true);
      }
      if(!isMoreHistoryLoading.isClosed){
        isMoreHistoryLoading.sink.add(true);
      }

      _historySupports.clear();
      if(!historySupports.isClosed){
        historySupports.sink.add(_historySupports);
      }
      counterNumPageHistorySupports = 0;
    }else if(state == 1){
      if(!isMoreHistoryLoading.isClosed){
        isMoreHistoryLoading.sink.add(true);
      }
    }

    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'support/tickets/$pageNum/$pageSize',
        'GET',
        {

        },
        await getToken()
    );
    print(responseBody);
    if(responseBody != null){
      // print(responseBody['totalCount']);
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
      if(!isMoreHistoryLoading.isClosed){
        isMoreHistoryLoading.sink.add(false);
      }

      if(responseBody['totalCount'] != 0){
        if(state == 0){
          totalCountHistorySupports = responseBody['totalCount'];
        }else{
          if(!isMoreHistoryLoading.isClosed){
            isMoreHistoryLoading.sink.add(false);
          }
        }
        responseBody['items'].forEach((item){
          _historySupports.add(SupportHistoryModel.fromJson(item));
        });
        if(!historySupports.isClosed){
          historySupports.sink.add(_historySupports);
        }
      }
    }else{
      if(state == 0){
        if(!tryButtonError.isClosed){
          tryButtonError.sink.add(true);
        }
        valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
      }else{
        Timer(Duration(seconds: 3),(){
          getHistorySupport(pageNum: pageNum,state: 1);
        });
      }
    }

  }

  moreLoadGetHistories(){
    if(historySupports.stream.value.length < totalCountHistorySupports){
      // if(!tryButtonError.stream.value){
      counterNumPageHistorySupports = counterNumPageHistorySupports + 1;
      // }
      getHistorySupport(state: 1,pageNum: counterNumPageHistorySupports);
    }
  }

  getTicket(String chatId,_this)async{
    String dir = await getAppDirectory();
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }
    if(!controllerTextChat.isClosed){
      controllerTextChat.sink.add('');
    }
    _uploadFiles.clear();
    if(!uploadFiles.isClosed){
      uploadFiles.sink.add(_uploadFiles);
    }
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'support/ticket/$chatId',
        'GET',
        {},
        await getToken()
    );

    print(responseBody);

    if(responseBody != null){

      _supportTicket = SupportTicketModel.fromJson(responseBody);
      if(!supportTicket.isClosed){
        supportTicket.sink.add(_supportTicket);
      }

      for(int i=0 ; i< _supportTicket.items.length ; i++){
        // print('sideType:${_chatTicketModel.chats[i].sideType}');
        _supportTicket.items[i].animationController = AnimationController(vsync: _this,duration: Duration(milliseconds: 300));
        if(_supportTicket.items[i].fileName != null){
          if(_supportTicket.items[i].fileName != ''){
            File file = File('$dir/${_supportTicket.items[i].fileName}');
            if(await file.exists()){
              _supportTicket.items[i].progress = 100;
            }
          }
        }
      }
      if(_supportTicket.items != []){
        List<String> fileNames = [];
        for(int i=0 ; i<_supportTicket.items.length ; i++){
          fileNames.add(_supportTicket.items[i].fileName == null ? '' : _supportTicket.items[i].fileName!);
        }
        // if(fileNames.length != 0){
        //   getSizeFile(fileNames);
        // }else{
          if(!isLoading.isClosed){
            isLoading.sink.add(false);
          }
        // }
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

  Future download2(SupportChatModel chatsModel,index) async {
    try {
      Response response = await _dio.get(
        '$mediaUrl/file/${chatsModel.fileName}',
        onReceiveProgress: (received, total){
          _supportTicket.items[index].progress = (received / total * 100).toInt();
          if(!supportTicket.isClosed){
            supportTicket.sink.add(_supportTicket);
          }
        },
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      final File saveFile = File('${await getAppDirectory()}/${chatsModel.fileName}');
      saveFile.writeAsBytes(response.data);
    } catch (e) {
      print(e);
    }
  }

  getSizeFile(List<String> listFileName)async{

    for(int i=0 ; i<listFileName.length ; i++){
      if(listFileName[i] != ''){
        Map<String,dynamic>? responseBody = await Http().sendRequest(
            mediaUrl,
            'file/fileInfo/${listFileName[i]}',
            'GET',
            {

            },
            await getToken()
        );
        // print(responseBody);
        if(responseBody != null){

          _fileNames.add(FileNameModel.fromJson(
              {
                "fileName": responseBody['fileName'],
                "type": responseBody['type'],
                "fileSize": responseBody['fileSize']
              }
          ));

        }else{
          if(!tryButtonError.isClosed){
            tryButtonError.sink.add(true);
          }
          valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
          break;
        }

      }else{

      }

    }

    for(int j=0 ; j<_fileNames.length ; j++){
      for(int i=0 ; i<_supportTicket.items.length ; i++){
        // print(_chatTicketModel.chats[i].media);
        if(_supportTicket.items[i].fileName != '' && _supportTicket.items[i].fileSize == null){
          _supportTicket.items[i].fileSize = _fileNames[j].fileSize;
          break;
        }
      }
    }
    if(!supportTicket.isClosed){
      supportTicket.sink.add(_supportTicket);
    }
    if(!isLoading.isClosed){
      isLoading.sink.add(false);
    }
    // endOfScroll();

    // if(!fileNames.isClosed){
    //   fileNames.sink.add(_fileNames);
    // }
    // print(fileNames.stream.value);
  }

  onChangeTextTicket(value){
    if(!controllerTextChat.isClosed){
      controllerTextChat.sink.add(value);
    }
  }

  onPressSendMessage(TextEditingController textEditingController , String chatId,context,_this,SupportPresenter? supportPresenter)async {
    // print('texttttt: $text');
    if (textEditingController.text != '' || uploadFiles.stream.value.length != 0) {
      if (!isLoadingButton.isClosed) {
        isLoadingButton.sink.add(true);
      }

      Map<String,dynamic>? responseBody = await Http().sendRequest(
          womanUrl,
          'support/ticket/$chatId',
          'POST',
          {
            'text': textEditingController.text,
            'fileName': uploadFiles.stream.value.length != 0 ? uploadFiles
                .stream.value[0].fileNameForSend : ''
          },
          await getToken()
      );

      if (responseBody != null) {
        if (responseBody['valid']) {
          if (!isLoadingButton.isClosed) {
            isLoadingButton.sink.add(false);
          }
          textEditingController.clear();
          _uploadFiles.clear();
          if(!uploadFiles.isClosed){
            uploadFiles.sink.add(_uploadFiles);
          }
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child:  BlankScreen(
                    indexTab: 7,
                    supportPresenter: supportPresenter!,
                    chatId: chatId,
                  )
              )
          );
          // getTicket(chatId, _this);
        }else{
          if (!isLoadingButton.isClosed) {
            isLoadingButton.sink.add(false);
          }
          showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
        }
      } else {
        if (!isLoadingButton.isClosed) {
          isLoadingButton.sink.add(false);
        }
        showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
      }
    }
  }

  clearTextRate(){
    if(!textRate.isClosed){
      textRate.sink.add('');
    }
    if(!valueRate.isClosed){
      valueRate.sink.add(0);
    }
  }

  initTextEditingControllerFeedback(){
    rateValueController = TextEditingController();
  }

  showFeedBackDialog(){
    Timer(Duration(milliseconds: 150),()async{
      animationControllerDialog.forward();
      if(!isShowFeedbackDialog.isClosed){
        isShowFeedbackDialog.sink.add(true);
      }
    });
  }

  closeFeedbackDialog()async{
    await animationControllerDialog.reverse();
    if(!isShowFeedbackDialog.isClosed){
      isShowFeedbackDialog.sink.add(false);
    }
  }

  Future<bool> onWillPopRateScreen(context,supportPresenter,chatId)async{
   /// AnalyticsHelper().log(AnalyticsEvents.RatePg_Back_NavBar_Clk);
    if(isShowFeedbackDialog.stream.value){
      closeFeedbackDialog();
    }else{
      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: ChatSupportScreen(
                supportPresenter: supportPresenter,
                chatId: chatId,
                fromNotify: false,
              )
          )
      );
    }
    return Future.value(false);
  }

  changeRateValue(double value){
    ///AnalyticsHelper().log(AnalyticsEvents.RatePg_ChangeRateValue_Icon_Clk);
    if(!valueRate.isClosed){
      valueRate.sink.add(value);
    }
  }

  sendRate(String chatId,supportPresenter,context)async{
    if (!isLoadingButton.isClosed) {
      isLoadingButton.sink.add(true);
    }

    /// AnalyticsHelper().log(
    ///     AnalyticsEvents.RatePg_SendFeedback_Btn_Clk,
    ///     parameters: {
    ///       'rate': valueRate.stream.value,
    ///       'description' : rateValueController.text,
    ///     }
    /// );
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'support/ticket/$chatId/rate',
        'POST',
        {
          'rate': valueRate.stream.value.toInt(),
          'rateDescription' : rateValueController.text,
        },
        await getToken()
    );


    if (responseBody != null) {
        if (!isLoadingButton.isClosed) {
          isLoadingButton.sink.add(false);
        }
        closeFeedbackDialog();
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child:  ChatSupportScreen(
                  supportPresenter: supportPresenter,
                  chatId: chatId,
                  fromNotify: false,
                )
            )
        );

    } else {
      if (!isLoadingButton.isClosed) {
        isLoadingButton.sink.add(false);
      }
      showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
    }

  }

  showToast(String message,context){
    //Fluttertoast.showToast(msg:message,toastLength: Toast.LENGTH_LONG,gravity:gravity);
    CustomSnackBar.show(context, message);
  }

  dispose(){
    isLoading.close();
    isLoadingButton.close();
    tryButtonError.close();
    valueError.close();
    allCategory.close();
    uploadFiles.close();
    sendValuePercentUploadFile.close();
    textSend.close();
    isMoreHistoryLoading.close();
    supportTicket.close();
    controllerTextChat.close();
    dialogScale.close();
    textRate.close();
    valueRate.close();
    isShowFeedbackDialog.close();
    historySupports.close();
  }

}