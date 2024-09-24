
import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impo/src/architecture/model/memory_model.dart';
import 'package:impo/src/architecture/view/memory_view.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/core/app/view/widgets/snackbar/custom_snack_bar.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/models/expert/upload_file_model.dart';
import 'package:impo/src/models/memory/memort_get_model.dart';
import 'package:impo/src/models/partner/partner_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/home/tabs/calender/memory/memory_game_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/extensions.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image/image.dart' as IMG ;

import '../../firebase_analytics_helper.dart';

class MemoryPresenter {

  late MemoryView _memoryView;

  MemoryModel _memoryModel = MemoryModel();

  MemoryPresenter(MemoryView view) {
    this._memoryView = view;
  }

  late PanelController panelController;
  late AnimationController animationControllerDialog;

  final isLoading = BehaviorSubject<bool>.seeded(false);
  final isMoreLoading = BehaviorSubject<bool>.seeded(true);
  final tryButtonError = BehaviorSubject<bool>.seeded(false);
  final valueError = BehaviorSubject<String>.seeded('');
  final memories = BehaviorSubject<List<MemoryGetModel>>.seeded([]);
  final counterMoreLoad = BehaviorSubject<int>.seeded(0);
  final uploadFiles = BehaviorSubject<List<UploadFileModel>>.seeded([]);
  final sendValuePercentUploadFile = BehaviorSubject<double>.seeded(0);
  final isLoadingButton = BehaviorSubject<bool>.seeded(false);
  final dialogScale = BehaviorSubject<double>.seeded(0.0);
  final isShowDialog = BehaviorSubject<bool>.seeded(false);
  final creator = BehaviorSubject<String>.seeded('');


  Stream<bool> get isLoadingObserve => isLoading.stream;
  Stream<bool> get isMoreLoadingObserve => isMoreLoading.stream;
  Stream<bool> get tryButtonErrorObserve => tryButtonError.stream;
  Stream<String> get valueErrorObserve => valueError.stream;
  Stream<List<MemoryGetModel>> get memoriesObserve => memories.stream;
  Stream<int> get counterMoreLoadObserve => counterMoreLoad.stream;
  Stream<List<UploadFileModel>> get uploadFilesObserve => uploadFiles.stream;
  Stream<double> get sendValuePercentUploadFileObserve => sendValuePercentUploadFile.stream;
  Stream<bool> get isLoadingButtonObserve => isLoadingButton.stream;
  Stream<double> get dialogScaleObserve => dialogScale.stream;
  Stream<bool> get isShowDialogObserve => isShowDialog.stream;
  Stream<String> get creatorObserve => creator.stream;

  String _token = '';
  int counterNumPageTickets = 0;
  List<MemoryGetModel> _memories = [];
  int totalCountTickets = 0;
  List<UploadFileModel> _uploadFiles = [];
  Dio _dio =  Dio();


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

  initPanelController()async{
    panelController =  PanelController();
  }

  openSlidingPanel()async{

    await panelController.open();
  }

  closeSlidingPanel()async{

    await panelController.close();
  }




  Future<String> getToken()async{
    if(_token == ''){
      RegisterParamViewModel register =  _memoryModel.getRegisters();
      _token = register.token!;
    }
    return _token;
  }

  Future<RegisterParamViewModel> getRegister()async{
      RegisterParamViewModel register =  _memoryModel.getRegisters();
      return register;
  }

  Future<String> getToday()async{
    RegisterParamViewModel register = await getRegister();
    Jalali d = Jalali.now();
    final f = d.formatter;
    if(register.nationality == 'IR'){
      return "${f.d} ${f.mN} ${f.yyyy}";
    }else{
      return "${f.d} ${f.mnAf} ${f.yyyy}";
    }
  }


  getMemories({int pageNum = 0 , int pageSize = 10, int? state})async{
    RegisterParamViewModel register = await getRegister();
    String dir = await getAppDirectory();
    if(state == 0){
      if(!isLoading.isClosed){
        isLoading.sink.add(true);
      }
      if(!isMoreLoading.isClosed){
        isMoreLoading.sink.add(true);
      }

      _memories.clear();
      if(!memories.isClosed){
        memories.sink.add(_memories);
      }
      counterNumPageTickets = 0;
    }else if(state == 1){
      if(!isMoreLoading.isClosed){
        isMoreLoading.sink.add(true);
      }
    }

    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'memory/$pageNum/$pageSize',
        'GET',
        {

        },
        register.token!
    );
    print(responseBody);
    if(responseBody != null){

      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
      if(!isMoreLoading.isClosed){
        isMoreLoading.sink.add(false);
      }
      if(responseBody['count'] != 0){
        if(state == 0){
          totalCountTickets = responseBody['count'];
        }else{
          if(!isMoreLoading.isClosed){
            isMoreLoading.sink.add(false);
          }
          if(!counterMoreLoad.isClosed){
            counterMoreLoad.sink.add(1);
          }
        }
        responseBody['memories'].forEach((item){
          _memories.add(MemoryGetModel.fromJson(item,register.nationality));
        });
        seIsDateAndLocalPath(dir);

        if(!memories.isClosed){
          memories.sink.add(_memories);
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
          getMemories(pageNum: pageNum,state: 1);
        });
      }
    }

  }

  moreLoadGetTickets(){
    if(memories.stream.value.length < totalCountTickets){
      counterNumPageTickets = counterNumPageTickets + 1;
      getMemories(state: 1,pageNum: counterNumPageTickets);
    }
  }


  seIsDateAndLocalPath(dir)async{
    String date = '';
    for(int i=0 ; i<_memories.length ; i++){
      if(_memories[i].date != date){
        _memories[i].isDate = true;
        date = _memories[i].date;
      }
      if(_memories[i].fileName != null){
        if(_memories[i].fileName != ''){
          File file = File('$dir/${_memories[i].fileName}');
          if(await file.exists()){
            _memories[i].localPath = file.path;
          }
        }
      }
    }
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

  getFileImage(int type ,context,bool isChatScreen,{String text = '',String chatId = '' })async{
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
        if(!uploadFiles.isClosed){
          uploadFiles.sink.add(_uploadFiles);
        }
        // print(file);
      } else {
        // User canceled the picker
      }
    }else{
      // ignore: invalid_use_of_visible_for_testing_member
      file = await ImagePicker.platform.pickImage(source: type == 0 ? ImageSource.gallery : ImageSource.camera);

      // File f = File(file.path);

      if(file != null){
        cropImage(file.path,isChatScreen, text,chatId,context);
      }

      // IMG.Image imageTemp = IMG.decodeImage(f.readAsBytesSync());
      //
      // imageTemp.exif.orientation = 1;
      // print(imageTemp.width);
      // print(imageTemp.height);
      //
      // if(imageTemp.width > imageTemp.height){
      //
      //   if(imageTemp.width <= 600){
      //     uploadFile(isChatScreen,text,chatId,context,f);
      //   }else{
      //     // IMG.Image  resizedImg = IMG.copyResize(imageTemp,height:(600*imageTemp.height)~/imageTemp.width,width: 600);
      //     File compressedFile = await FlutterNativeImage.compressImage(file.path, quality: 100, percentage: (1200*100)~/imageTemp.width);
      //     // File fileResize =  File('${await getAppDirectory()}/test1.jpg')..writeAsBytesSync(IMG.encodeJpg(resizedImg));
      //     uploadFile(isChatScreen,text,chatId,context,compressedFile);
      //   }
      //
      //
      // }else if(imageTemp.width < imageTemp.height){
      //
      //   if(imageTemp.height <= 1200){
      //     uploadFile(isChatScreen,text,chatId,context,f);
      //   }else{
      //     // IMG.Image  resizedImg = IMG.copyResize(imageTemp,width:(1200*imageTemp.width)~/imageTemp.height,height: 1200);
      //     File compressedFile = await FlutterNativeImage.compressImage(file.path, quality: 100, percentage: (2400*100)~/imageTemp.height);
      //     // File fileResize =  File('${await getAppDirectory()}/test1.jpg')..writeAsBytesSync(IMG.encodeJpg(resizedImg));
      //     uploadFile(isChatScreen,text,chatId,context,compressedFile);
      //   }
      //
      //
      // }else{
      //
      //   if(imageTemp.width <= 600){
      //     uploadFile(isChatScreen,text,chatId,context,f);
      //   }else{
      //     // IMG.Image  resizedImg = IMG.copyResize(imageTemp,width:600,height: 600);
      //     File compressedFile = await FlutterNativeImage.compressImage(file.path, quality: 100, percentage: (1200*100)~/imageTemp.width);
      //     // File fileResize =  File('${await getAppDirectory()}/test1.jpg')..writeAsBytesSync(IMG.encodeJpg(resizedImg));
      //     uploadFile(isChatScreen,text,chatId,context,compressedFile);
      //   }
      //
      // }


    }

    // uploadFile(file,isChatScreen,text,chatId,context);

  }

  cropImage(String imagePath,isChatScreen, text, ticketId, context,)async{

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'ایمپو',
            toolbarColor: ColorPallet().mainColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: true
        ),
        IOSUiSettings(
          title: 'ایمپو',
        ),
      ],
    );

    File file = File(croppedFile!.path);

    uploadFile(isChatScreen, text, ticketId, context,file);
  }


  uploadFile(bool isChatScreen,String text,String ticketId,context,File file)async{
    print('tokken : ${await getToken()}');
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

    _dio = Dio();
    _dio.options.contentType = Headers.formUrlEncodedContentType;
    FormData formData = FormData();

    formData.files.addAll(
        [MapEntry('files',MultipartFile.fromFileSync(file.path))]);

    try{

      await _dio.put('$mediaUrl/woman/private',data: formData,
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
                    'fileNameForSend' : res.data['fileName'],
                    'stateUpload' : 1,
                    'fileName' : _uploadFiles[0].fileName
                  }
              )
          );
          _uploadFiles.removeAt(1);
          if(!uploadFiles.isClosed){
            uploadFiles.sink.add(_uploadFiles);
          }
          final File saveFile = File('${await getAppDirectory()}/${res.data['fileName']}');
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


  sendMemory(String title,text,context)async{
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(true);
    }
    print(title);
    print(text);
    AnalyticsHelper().log(AnalyticsEvents.AddMemoryPg_RecordMemory_Btn_Clk);
    Map<String,dynamic> responseBody = await Http().sendRequest(
        womanUrl,
        'memory',
        'PUT',
        {
          "fileName" : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileNameForSend : '',
          "title" : title,
          "text" : text
        },
        await getToken()
    );
    print(responseBody);
    if(responseBody != null){
      if(responseBody['valid']){
        if(!isLoadingButton.isClosed){
          isLoadingButton.sink.add(false);
        }
        goToMemoryListScreen(context);

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

  goToMemoryListScreen(context)async{

    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child:  MemoryGameScreen(

            )
        )
    );
  }

  Future<bool> backProfileMemoryScreen(){
    if(isShowDialog.stream.value){
      cancelDeleteMemoryDialog();
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }

  showDeleteMemoryDialog(){
    Timer(Duration(milliseconds: 150),()async{
      animationControllerDialog.forward();
      if(!isShowDialog.isClosed){
        isShowDialog.sink.add(true);
      }
    });
  }

  cancelDeleteMemoryDialog()async{
    await animationControllerDialog.reverse();
    if(!isShowDialog.isClosed){
      isShowDialog.sink.add(false);
    }
  }

  deleteMemory(id,context)async{
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(true);
    }
    Map<String,dynamic> responseBody = await Http().sendRequest(
        womanUrl,
        'memory',
        'POST',
        {
          "id" : id
        },
        await getToken()
    );
    print(responseBody);
    if(responseBody != null){
      if(responseBody['valid']){
        if(!isLoadingButton.isClosed){
          isLoadingButton.sink.add(false);
        }
        cancelDeleteMemoryDialog();
        goToMemoryListScreen(context);

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

    getPartnerName(){
    PartnerViewModel partner =  _memoryModel.getPartner();
    return partner != null ? partner.manName : '';
  }

  initCreator(MemoryGetModel memoryGetModel)async{
    if(!memoryGetModel.fromMan){
      if(!creator.isClosed){
        creator.sink.add('شما');
      }
    }else{
      if(!creator.isClosed){
        creator.sink.add(getPartnerName());
      }
    }
  }

  sendComment(id,text,context)async{
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(true);
    }

    Map<String,dynamic> responseBody = await Http().sendRequest(
        womanUrl,
        'memory/comment',
        'POST',
        {
          "id" : id,
          "text" : text
        },
        await getToken()
    );
    print(responseBody);
    if(responseBody != null){
      if(responseBody['valid']){
        if(!isLoadingButton.isClosed){
          isLoadingButton.sink.add(false);
        }
        // goToMemoryListScreen(context);
        setLocalCommentForDisplay(id,text,context);
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

  setLocalCommentForDisplay(id,textPartner,context){
    for(int i=0 ; i<_memories.length ; i++){
      if(_memories[i].id == id){
        _memories[i].textPartner = textPartner;
        _memories[i].validPartner = true;
      }
    }
    if(!memories.isClosed){
      memories.sink.add(_memories);
    }
    Navigator.pop(context);
  }


  showToast(String message,context){
    //Fluttertoast.showToast(msg:message,toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.BOTTOM);
    CustomSnackBar.show(context, message);
  }



  dispose(){
    isLoading.close();
    tryButtonError.close();
    isMoreLoading.close();
    memories.close();
    valueError.close();
    counterMoreLoad.close();
    uploadFiles.close();
    sendValuePercentUploadFile.close();
    isLoadingButton.close();
    isShowDialog.close();
    dialogScale.close();
    creator.close();
  }


}