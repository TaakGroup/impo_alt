import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impo/src/architecture/model/sharing_experience_model.dart';
import 'package:impo/src/architecture/view/sharing_experience_view.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/core/app/view/widgets/snackbar/custom_snack_bar.dart';
import 'package:impo/src/models/expert/upload_file_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/models/sharing_experience/all_share_experience_get_model.dart';
import 'package:impo/src/models/sharing_experience/comment_experience_model.dart';
import 'package:impo/src/models/sharing_experience/header_list_model.dart';
import 'package:impo/src/models/sharing_experience/other_experience_model.dart';
import 'package:impo/src/models/sharing_experience/self_experience_model.dart';
import 'package:impo/src/models/sharing_experience/topic_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../data/http.dart';

class SharingExperiencePresenter {
  late SharingExperienceView _sharingExperienceView;
  SharingExperienceModel _sharingExperienceModel = SharingExperienceModel();

  SharingExperiencePresenter(SharingExperienceView view) {
    this._sharingExperienceView = view;
  }

  late AnimationController controller;
  late AnimationController animationControllerDialog;

  final isLoading = BehaviorSubject<bool>.seeded(false);
  final tryButtonError = BehaviorSubject<bool>.seeded(false);
  final valueError = BehaviorSubject<String>.seeded('');
  final allExperiences = BehaviorSubject<AllShareExperienceGetModel>();
  final dialogScale = BehaviorSubject<double>.seeded(0.0);
  final isShowDeleteExpDialog = BehaviorSubject<bool>.seeded(false);
  final isLoadingButton = BehaviorSubject<bool>.seeded(false);
  final isMoreSelfLoading = BehaviorSubject<bool>.seeded(false);
  final selfExperiences = BehaviorSubject<List<SelfExperienceModel>>.seeded([]);
  final isMoreOtherLoading = BehaviorSubject<bool>.seeded(false);
  final otherExperiences = BehaviorSubject<List<OtherExperienceModel>>.seeded([]);
  final commentExperiences = BehaviorSubject<CommentExperienceModel>();
  final commentsList = BehaviorSubject<List<ListCommentExperienceModel>>.seeded([]);
  final isMoreCommentLoading = BehaviorSubject<bool>.seeded(false);
  final textSend = BehaviorSubject<String>.seeded('');
  final commentTextSend = BehaviorSubject<String>.seeded('');
  final isShowDeleteCommentExpDialog = BehaviorSubject<bool>.seeded(false);
  final topic = BehaviorSubject<TopicModel>();
  final topics = BehaviorSubject<List<TopicModel>>();
  final uploadFiles = BehaviorSubject<List<UploadFileModel>>.seeded([]);
  final sendValuePercentUploadFile = BehaviorSubject<double>.seeded(0);

  Stream<bool> get isLoadingObserve => isLoading.stream;
  Stream<bool> get tryButtonErrorObserve => tryButtonError.stream;
  Stream<String> get valueErrorObserve => valueError.stream;
  Stream<AllShareExperienceGetModel> get allExperiencesObserve => allExperiences.stream;
  Stream<double> get dialogScaleObserve => dialogScale.stream;
  Stream<bool> get isShowDeleteExpDialogObserve => isShowDeleteExpDialog.stream;
  Stream<bool> get isLoadingButtonObserve => isLoadingButton.stream;
  Stream<bool> get isMoreSelfLoadingObserve => isMoreSelfLoading.stream;
  Stream<List<SelfExperienceModel>> get selfExperiencesObserve => selfExperiences.stream;
  Stream<bool> get isMoreOtherLoadingObserve => isMoreOtherLoading.stream;
  Stream<List<OtherExperienceModel>> get otherExperiencesObserve => otherExperiences.stream;
  Stream<CommentExperienceModel> get commentExperiencesObserve => commentExperiences.stream;
  Stream<List<ListCommentExperienceModel>> get commentsListObserve => commentsList.stream;
  Stream<bool> get isMoreCommentLoadingObserve => isMoreCommentLoading.stream;
  Stream<String> get textSendObserve => textSend.stream;
  Stream<String> get commentTextSendObserve => commentTextSend.stream;
  Stream<bool> get isShowDeleteCommentExpDialogObserve => isShowDeleteCommentExpDialog.stream;
  Stream<TopicModel> get topicObserve => topic.stream;
  Stream<List<TopicModel>> get topicsObserve => topics.stream;
  Stream<List<UploadFileModel>> get uploadFilesObserve => uploadFiles.stream;
  Stream<double> get sendValuePercentUploadFileObserve => sendValuePercentUploadFile.stream;

  ScrollController? scrollController;

  late AllShareExperienceGetModel _allExperiences;
  
  List<SelfExperienceModel> _selfExperiences = [];
  int counterNumPageSelf = 0;
  int totalCountSelf = 0;
  
  List<OtherExperienceModel> _otherExperiences = [];
  int counterNumPageOther = 0;
  int totalCountOther = 0;
  List<TopicModel> _topics = [];

  late CommentExperienceModel _commentExperiences;
  List<ListCommentExperienceModel> _commentsList = [];
  int counterNumPageComment = 0;
  int totalCountComment = 0;
  
  String _token = '';
  late SelfExperienceModel selectedExpForDelete;
  late ListCommentExperienceModel selectedCommentExpForDelete;
  double keepPosition = 0 ;

  List<UploadFileModel> _uploadFiles = [];
  Dio _dio =  Dio();
  late PanelController panelController;

  List<HeaderListModel> headerItems = [
    HeaderListModel(title: 'تجربه‌های جدید',selected: false),
    HeaderListModel(title: 'تجربه‌های من',selected: false)
  ];

  initPanelController()async{
    panelController =  PanelController();
  }

  openSlidingPanel()async{

    await panelController.open();
  }

  closeSlidingPanel()async{

    await panelController.close();
  }

   initScrollController(){
     scrollController = ScrollController();
   }

   savePosition(){
     if(scrollController != null){
       if(scrollController!.hasClients){
         keepPosition = scrollController!.position.pixels;
       }
     }
   }

  initAnimationController(_this) {
    controller = AnimationController(vsync: _this);
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
    return _sharingExperienceModel.getRegisters();
  }

  Future<String> getToken() async {
    if (_token == '') {
      RegisterParamViewModel register = _sharingExperienceModel.getRegisters();
      _token = register.token!;
    }
    return _token;
  }

  Future<void> getShareExperience({bool fromSelfHeader = false}) async {
    if (!isLoading.isClosed) {
      isLoading.sink.add(true);
    }
    if (!tryButtonError.isClosed) {
      tryButtonError.sink.add(false);
    }
    clearTopics();
    Map<String,dynamic>? responseBody = await Http()
        .sendRequest(womanUrl, 'shareeexperiencev2', 'GET', {}, await getToken());
    print(responseBody);
    if (responseBody != null) {
        // if (!isLoading.isClosed) {
        //   isLoading.sink.add(false);
        // }
        _allExperiences = AllShareExperienceGetModel.fromJson(responseBody);
        if(!allExperiences.isClosed){
          allExperiences.sink.add(_allExperiences);
        }
        responseBody['topics'].forEach((item){
          _topics.add(TopicModel.fromJson(item));
        });
        if(!topics.isClosed){
          topics.sink.add(_topics);
        }
        if(!fromSelfHeader){
          headerItems[0].selected = true;
        }

        getOtherShareExperience(state: 0);
    } else {
      if (!tryButtonError.isClosed) {
        tryButtonError.sink.add(true);
      }
      valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }
  }

  getSelfShareExperience({int pageNum = 0 , int pageSize = 10, int? state})async{
    if(state == 0){
      if(!isLoading.isClosed){
        isLoading.sink.add(true);
      }
      if(!isMoreSelfLoading.isClosed){
        isMoreSelfLoading.sink.add(true);
      }

      _selfExperiences.clear();
      if(!selfExperiences.isClosed){
        selfExperiences.sink.add(_selfExperiences);
      }

      counterNumPageSelf = 0;
    }else if(state == 1){
      if(!isMoreSelfLoading.isClosed){
        isMoreSelfLoading.sink.add(true);
      }
    }

    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'shareeexperiencev2/self/$pageNum/$pageSize',
        'GET',
        {

        },
        await getToken()
    );
    // print(responseBody);
    if(responseBody != null){
      // print(responseBody['totalCount']);
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
      if(!isMoreSelfLoading.isClosed){
        isMoreSelfLoading.sink.add(false);
      }
      if(responseBody['totalCount'] != 0){
        if(state == 0){
          totalCountSelf = responseBody['totalCount'];
        }else{
          if(!isMoreSelfLoading.isClosed){
            isMoreSelfLoading.sink.add(false);
          }
          // if(!counterMoreLoad.isClosed){
          //   counterMoreLoad.sink.add(1);
          // }
        }
        responseBody['list'].forEach((item){
          _selfExperiences.add(SelfExperienceModel.fromJson(item));
        });
        // print(_tickets[0].text);
        // print(_tickets[1].text);
        if(!selfExperiences.isClosed){
          selfExperiences.sink.add(_selfExperiences);
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
          getSelfShareExperience(pageNum: pageNum,state: 1);
        });
      }
    }

  }

  moreLoadGetSelfExp(){
    if(selfExperiences.stream.value.length < totalCountSelf){
      // if(!tryButtonError.stream.value){
      counterNumPageSelf = counterNumPageSelf + 1;
      // }
      getSelfShareExperience(state: 1,pageNum: counterNumPageSelf);
    }
  }

  getOtherShareExperience({int pageNum = 0 , int pageSize = 10, int? state})async{
    if(state == 0){
      if(!isLoading.isClosed){
        isLoading.sink.add(true);
      }
      if(!isMoreOtherLoading.isClosed){
        isMoreOtherLoading.sink.add(true);
      }

      _otherExperiences.clear();
      if(!otherExperiences.isClosed){
        otherExperiences.sink.add(_otherExperiences);
      }
      counterNumPageOther = 0;
    }else if(state == 1){
      if(!isMoreOtherLoading.isClosed){
        isMoreOtherLoading.sink.add(true);
      }
    }

    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'shareeexperiencev2/other/$pageNum/$pageSize',
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
      if(!isMoreOtherLoading.isClosed){
        isMoreOtherLoading.sink.add(false);
      }
      if(responseBody['totalCount'] != 0){
        if(state == 0){
          totalCountOther = responseBody['totalCount'];
        }else{
          if(!isMoreOtherLoading.isClosed){
            isMoreOtherLoading.sink.add(false);
          }
          // if(!counterMoreLoad.isClosed){
          //   counterMoreLoad.sink.add(1);
          // }
        }
        responseBody['list'].forEach((item){
          _otherExperiences.add(OtherExperienceModel.fromJson(item));
        });
        // print(_tickets[0].text);
        // print(_tickets[1].text);
        if(!otherExperiences.isClosed){
          otherExperiences.sink.add(_otherExperiences);
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
          getOtherShareExperience(pageNum: pageNum,state: 1);
        });
      }
    }

  }

  moreLoadGetOtherExp(){
    if(otherExperiences.stream.value.length < totalCountOther){
      // if(!tryButtonError.stream.value){
      counterNumPageOther = counterNumPageOther + 1;
      // }
      getOtherShareExperience(state: 1,pageNum: counterNumPageOther);
    }
  }
  

  showExpDialog(int index){
    selectedExpForDelete = selfExperiences.stream.value[index];
    Timer(Duration(milliseconds: 150),()async{
      animationControllerDialog.forward();
      isShowDeleteExpDialog.sink.add(true);
    });
  }

  onPressCancelExpDialog()async{
    await animationControllerDialog.reverse();
    isShowDeleteExpDialog.sink.add(false);
  }

  deleteExp(context)async{
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(true);
    }
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'shareeexperiencev2/${selectedExpForDelete.id}',
        'DELETE',
        {}, await getToken());
    print(responseBody);
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(false);
    }
    if(responseBody != null){
      if(responseBody['valid']){
        onPressCancelExpDialog();
        await getShareExperience(fromSelfHeader: true);
        await getSelfShareExperience(state: 0);
        // if(_selfExperiences.length == 0){
        //   headerItems[0].selected = true;
        //   headerItems[1].selected = false;
        //   scrollController.jumpTo(keepPosition);
        // }
      }else{
        showToast('امکان حذف تجربه وجود ندارد', context);
      }
    }else{
      showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
    }
  }

  onChangeTextField(String value,context){
    if(value.length >= 301){
      showToast('تعداد حرفها نمیتواند بیشتر از 300 حرف باشد', context);
    }
    if(!textSend.isClosed){
      textSend.sink.add(value);
    }
  }

  sendShareExp(context,bool fromTopicScreen) async {
    print(textSend.stream.value);
    if (!isLoadingButton.isClosed) {
      isLoadingButton.sink.add(true);
    }
    String topicId = '';
    for(int i=0 ; i<_topics.length ; i++){
      if(_topics[i].selected){
        topicId = _topics[i].id;
        break;
      }
    }
    print(topicId);

    Map<String,dynamic>? responseBody = await Http()
        .sendRequest(womanUrl,
        'shareeexperiencev2',
        'POST',
        {
          'text' : textSend.stream.value,
          "image" : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileNameForSend : '',
          "topicId" : topicId
        },
        await getToken()
    );
    print(responseBody);
    if (responseBody != null) {

      if(responseBody['valid']){
        if(!textSend.isClosed){
          textSend.sink.add('');
        }

        if(fromTopicScreen){
          getTopicShareExperience(state: 0,topicId: topicId);
        }else{
          await getShareExperience(fromSelfHeader : true);
          getSelfShareExperience(state: 0);
        }
        if (!isLoadingButton.isClosed) {
          isLoadingButton.sink.add(false);
        }
        Navigator.pop(context);

      }else{
        showToast('امکان ارسال تجربه وجود ندارد', context);
      }

    } else {
      showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
    }
  }

  clearUploadFiles(){
    _uploadFiles.clear();
    if(!uploadFiles.isClosed){
      uploadFiles.sink.add(_uploadFiles);
    }
  }

  likeShareExp(int index,context,bool isPageCommentPage)async{

    // _otherExperiences[index].loadingLike = true;
    // if(!otherExperiences.isClosed){
    //   otherExperiences.sink.add(_otherExperiences);
    // }
    if(isPageCommentPage){
      _commentExperiences.likeCount++;
      if(_commentExperiences.state == 2 &&_commentExperiences.dislikeCount != 0){
        _commentExperiences.dislikeCount--;
      }
      _commentExperiences.state = 1;
      if(!commentExperiences.isClosed){
        commentExperiences.sink.add(_commentExperiences);
      }
    }
    _otherExperiences[index].likeCount++;
    if(_otherExperiences[index].state == 2 &&_otherExperiences[index].disliked != 0){
      _otherExperiences[index].disliked--;
    }
    _otherExperiences[index].state = 1;
    if(!otherExperiences.isClosed){
      otherExperiences.sink.add(_otherExperiences);
    }

    Map<String,dynamic>? responseBody = await Http()
        .sendRequest(
        womanUrl,
        'shareeexperiencev2/like/${_otherExperiences[index].id}',
        'POST',
        {
        },
        await getToken()
    );
    print(responseBody);
    // _otherExperiences[index].loadingLike = false;
    // if(!otherExperiences.isClosed){
    //   otherExperiences.sink.add(_otherExperiences);
    // }
    if(responseBody != null){
      if(responseBody['valid']){
        // _otherExperiences[index].likeCount++;
        // if(_otherExperiences[index].state == 2 &&_otherExperiences[index].disliked != 0){
        //   _otherExperiences[index].disliked--;
        // }
        // _otherExperiences[index].state = 1;
        // if(!otherExperiences.isClosed){
        //   otherExperiences.sink.add(_otherExperiences);
        // }
      }else{
        showToast('درخواست موجود نمی باشد', context);
      }
    }else{
      showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
    }
  }

  disLikeShareExp(int index,context,bool isPageCommentPage)async{
    // _otherExperiences[index].loadingDisLike = true;
    // if(!otherExperiences.isClosed){
    //   otherExperiences.sink.add(_otherExperiences);
    // }
    if(isPageCommentPage){
      _commentExperiences.dislikeCount++;
      if(_commentExperiences.state == 1 &&_commentExperiences.likeCount != 0){
        _commentExperiences.likeCount--;
      }
      _commentExperiences.state = 2;
      if(!commentExperiences.isClosed){
        commentExperiences.sink.add(_commentExperiences);
      }
    }


    _otherExperiences[index].disliked++;
    if(_otherExperiences[index].state == 1 &&_otherExperiences[index].likeCount != 0){
      _otherExperiences[index].likeCount--;
    }
    _otherExperiences[index].state = 2;
    if(!otherExperiences.isClosed){
      otherExperiences.sink.add(_otherExperiences);
    }

    Map<String,dynamic>? responseBody = await Http()
        .sendRequest(
        womanUrl,
        'shareeexperiencev2/dislike/${_otherExperiences[index].id}',
        'POST',
        {
        },
        await getToken()
    );
    print(responseBody);
    // _otherExperiences[index].loadingDisLike = false;
    // if(!otherExperiences.isClosed){
    //   otherExperiences.sink.add(_otherExperiences);
    // }
    if(responseBody != null){
      if(responseBody['valid']){

        // _otherExperiences[index].disliked++;
        // if(_otherExperiences[index].state == 1 &&_otherExperiences[index].likeCount != 0){
        //   _otherExperiences[index].likeCount--;
        // }
        // _otherExperiences[index].state = 2;
        // if(!otherExperiences.isClosed){
        //   otherExperiences.sink.add(_otherExperiences);
        // }

      }else{
        showToast('درخواست موجود نمی باشد', context);
      }
    }else{
      showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
    }
  }

  removeLikeShareExp(int index,context,bool isLike,bool isPageCommentPage)async{
    print('removeLikeShareExp');
    // if(isLike){
    //   _otherExperiences[index].loadingLike = true;
    // }else{
    //   _otherExperiences[index].loadingDisLike = true;
    // }
    // if(!otherExperiences.isClosed){
    //   otherExperiences.sink.add(_otherExperiences);
    // }
    if(isPageCommentPage){
      _commentExperiences.state = 0;
      if(isLike){
        _commentExperiences.likeCount--;
      }else{
        _commentExperiences.dislikeCount--;
      }
      if(!commentExperiences.isClosed){
        commentExperiences.sink.add(_commentExperiences);
      }
    }

    _otherExperiences[index].state = 0;
    if(isLike){
      _otherExperiences[index].likeCount--;
    }else{
      _otherExperiences[index].disliked--;
    }
    if(!otherExperiences.isClosed){
      otherExperiences.sink.add(_otherExperiences);
    }

    Map<String,dynamic>? responseBody = await Http()
        .sendRequest(
        womanUrl,
        'shareeexperiencev2/like/${_otherExperiences[index].id}',
        'DELETE',
        {
        },
        await getToken()
    );
    print(responseBody);
    // if(isLike){
    //   _otherExperiences[index].loadingLike = false;
    // }else{
    //   _otherExperiences[index].loadingDisLike = false;
    // }
    // if(!otherExperiences.isClosed){
    //   otherExperiences.sink.add(_otherExperiences);
    // }
    if(responseBody != null){
      if(responseBody['valid']){

        // _otherExperiences[index].state = 0;
        // if(isLike){
        //   _otherExperiences[index].likeCount--;
        // }else{
        //   _otherExperiences[index].disliked--;
        // }
        // if(!otherExperiences.isClosed){
        //   otherExperiences.sink.add(_otherExperiences);
        // }

      }else{
        showToast('درخواست موجود نمی باشد', context);
      }
    }else{
      showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
    }
  }

  getCommentShareExperience({int pageNum = 0 , int pageSize = 10, int? state,String? shareId})async{
    if(state == 0){
      if(!isLoading.isClosed){
        isLoading.sink.add(true);
      }
      if(!isMoreCommentLoading.isClosed){
        isMoreCommentLoading.sink.add(true);
      }

      _commentsList.clear();
      if(!commentsList.isClosed){
        commentsList.sink.add(_commentsList);
      }

      counterNumPageComment = 0;
    }else if(state == 1){
      if(!isMoreCommentLoading.isClosed){
        isMoreCommentLoading.sink.add(true);
      }
    }

    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'shareeexperiencev2/$shareId/comments/$pageNum/$pageSize',
        'GET',
        {

        },
        await getToken()
    );
    // print(responseBody);
    if(responseBody != null){
      // print(responseBody['totalCount']);
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
      if(!isMoreCommentLoading.isClosed){
        isMoreCommentLoading.sink.add(false);
      }

        if(state == 0){
          totalCountComment = responseBody['commentCount'];
          _commentExperiences = CommentExperienceModel.fromJson(responseBody);
          if(!commentExperiences.isClosed){
            commentExperiences.sink.add(_commentExperiences);
          }
        }else{
          if(!isMoreCommentLoading.isClosed){
            isMoreCommentLoading.sink.add(false);
          }
        }
        if(responseBody['comments'].length != 0){
          responseBody['comments'].forEach((item){
            _commentsList.add(ListCommentExperienceModel.fromJson(item));
          });
          if(!commentsList.isClosed){
            commentsList.sink.add(_commentsList);
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
          getCommentShareExperience(pageNum: pageNum,state: 1,shareId: shareId);
        });
      }
    }

  }

  moreLoadGetCommentExp(shareId){
    if(commentsList.stream.value.length < totalCountComment){
      // if(!tryButtonError.stream.value){
      counterNumPageComment = counterNumPageComment + 1;
      // }
      getCommentShareExperience(state: 1,pageNum: counterNumPageComment,shareId:shareId);
    }
  }


  likeCommentShareExp(int index,context,String sharedId)async{

    // _otherExperiences[index].loadingLike = true;
    // if(!otherExperiences.isClosed){
    //   otherExperiences.sink.add(_otherExperiences);
    // }
    _commentsList[index].likeCount++;
    if(_commentsList[index].state == 2 &&_commentsList[index].disliked != 0){
      _commentsList[index].disliked--;
    }
    _commentsList[index].state = 1;
    if(!commentsList.isClosed){
      commentsList.sink.add(_commentsList);
    }

    Map<String,dynamic>? responseBody = await Http()
        .sendRequest(
        womanUrl,
        'shareeexperiencev2/$sharedId/comments/${_commentsList[index].id}/like',
        'POST',
        {
        },
        await getToken()
    );
    print(responseBody);
    // _otherExperiences[index].loadingLike = false;
    // if(!otherExperiences.isClosed){
    //   otherExperiences.sink.add(_otherExperiences);
    // }
    if(responseBody != null){
      if(responseBody['isValid']){
        // _otherExperiences[index].likeCount++;
        // if(_otherExperiences[index].state == 2 &&_otherExperiences[index].disliked != 0){
        //   _otherExperiences[index].disliked--;
        // }
        // _otherExperiences[index].state = 1;
        // if(!otherExperiences.isClosed){
        //   otherExperiences.sink.add(_otherExperiences);
        // }
      }else{
        showToast('درخواست موجود نمی باشد', context);
      }
    }else{
      showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
    }
  }

  disLikeCommentShareExp(int index,context,String sharedId)async{
    // _otherExperiences[index].loadingDisLike = true;
    // if(!otherExperiences.isClosed){
    //   otherExperiences.sink.add(_otherExperiences);
    // }
    _commentsList[index].disliked++;
    if(_commentsList[index].state == 1 &&_commentsList[index].likeCount != 0){
      _commentsList[index].likeCount--;
    }
    _commentsList[index].state = 2;
    if(!commentsList.isClosed){
      commentsList.sink.add(_commentsList);
    }

    Map<String,dynamic>? responseBody = await Http()
        .sendRequest(
        womanUrl,
        'shareeexperiencev2/$sharedId/comments/${_commentsList[index].id}/dislike',
        'POST',
        {
        },
        await getToken()
    );
    print(responseBody);
    // _otherExperiences[index].loadingDisLike = false;
    // if(!otherExperiences.isClosed){
    //   otherExperiences.sink.add(_otherExperiences);
    // }
    if(responseBody != null){
      if(responseBody['isValid']){

        // _otherExperiences[index].disliked++;
        // if(_otherExperiences[index].state == 1 &&_otherExperiences[index].likeCount != 0){
        //   _otherExperiences[index].likeCount--;
        // }
        // _otherExperiences[index].state = 2;
        // if(!otherExperiences.isClosed){
        //   otherExperiences.sink.add(_otherExperiences);
        // }

      }else{
        showToast('درخواست موجود نمی باشد', context);
      }
    }else{
      showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
    }
  }

  removeLikeCommentShareExp(int index,context,bool isLike,String sharedId)async{
    print('removeLikeCommentShareExp');
    // if(isLike){
    //   _otherExperiences[index].loadingLike = true;
    // }else{
    //   _otherExperiences[index].loadingDisLike = true;
    // }
    // if(!otherExperiences.isClosed){
    //   otherExperiences.sink.add(_otherExperiences);
    // }
    _commentsList[index].state = 0;
    if(isLike){
      _commentsList[index].likeCount--;
    }else{
      _commentsList[index].disliked--;
    }
    if(!commentsList.isClosed){
      commentsList.sink.add(_commentsList);
    }

    Map<String,dynamic>? responseBody = await Http()
        .sendRequest(
        womanUrl,
        'shareeexperiencev2/$sharedId/comments/${_commentsList[index].id}/like',
        'DELETE',
        {
        },
        await getToken()
    );
    print(responseBody);
    // if(isLike){
    //   _otherExperiences[index].loadingLike = false;
    // }else{
    //   _otherExperiences[index].loadingDisLike = false;
    // }
    // if(!otherExperiences.isClosed){
    //   otherExperiences.sink.add(_otherExperiences);
    // }
    if(responseBody != null){
      if(responseBody['isValid']){

        // _otherExperiences[index].state = 0;
        // if(isLike){
        //   _otherExperiences[index].likeCount--;
        // }else{
        //   _otherExperiences[index].disliked--;
        // }
        // if(!otherExperiences.isClosed){
        //   otherExperiences.sink.add(_otherExperiences);
        // }

      }else{
        showToast('درخواست موجود نمی باشد', context);
      }
    }else{
      showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
    }
  }


  showCommentExpDialog(int index){
    selectedCommentExpForDelete = commentsList.stream.value[index];
    Timer(Duration(milliseconds: 150),()async{
      animationControllerDialog.forward();
      isShowDeleteCommentExpDialog.sink.add(true);
    });
  }

  onPressCancelCommentExpDialog()async{
    await animationControllerDialog.reverse();
    isShowDeleteCommentExpDialog.sink.add(false);
  }

  deleteCommentExp(context,String shareId,indexShareExp)async{
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(true);
    }
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'shareeexperiencev2/$shareId/comments/${selectedCommentExpForDelete.id}',
        'DELETE',
        {}, await getToken());
    print(responseBody);
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(false);
    }
    if(responseBody != null){
      if(responseBody['isValid']){
        onPressCancelCommentExpDialog();
        // await getShareExperience();
        // if(indexShareExp != null){
        //   _otherExperiences[indexShareExp].commentCount--;
        //   if(!otherExperiences.isClosed){
        //     otherExperiences.sink.add(_otherExperiences);
        //   }
        // }else {
        if(indexShareExp != null){
          _otherExperiences[indexShareExp].commentCount--;
          if(!otherExperiences.isClosed){
            otherExperiences.sink.add(_otherExperiences);
          }
        }else {
          for (int i = 0; i < _selfExperiences.length; i++) {
            if (_selfExperiences[i].id == shareId) {
              _selfExperiences[i].commentCount--;
            }
          }
          if (!selfExperiences.isClosed) {
            selfExperiences.sink.add(_selfExperiences);
          }
        }
        // }
        await getCommentShareExperience(state: 0,shareId: shareId);
        if(_commentsList.length == 0){
           Timer(Duration(milliseconds: 100),(){
           scrollController!.jumpTo(keepPosition);
           });
          Navigator.pop(context);
        }
      }else{
        showToast('امکان حذف  کامنت تجربه وجود ندارد', context);
      }
    }else{
      showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
    }
  }

  onChangeCommentTextField(String value,context){
    if(value.length >= 301){
      showToast('تعداد حرفها نمیتواند بیشتر از 300 حرف باشد', context);
    }
    if(!commentTextSend.isClosed){
      commentTextSend.sink.add(value);
    }
  }

  sendCommentShareExp(context,
      SharingExperiencePresenter sharingExperiencePresenter,
      String shareId,int? indexShareExp) async {
    print(commentTextSend.stream.value);
    if (!isLoadingButton.isClosed) {
      isLoadingButton.sink.add(true);
    }

    Map<String,dynamic>? responseBody = await Http()
        .sendRequest(womanUrl,
        'shareeexperiencev2/$shareId/comments',
        'POST',
        {
          'text' : commentTextSend.stream.value
        },
        await getToken()
    );
    print(responseBody);
    if (!isLoadingButton.isClosed) {
      isLoadingButton.sink.add(false);
    }
    if (responseBody != null) {

      if(responseBody['valid']){
        if(!commentTextSend.isClosed){
          commentTextSend.sink.add('');
        }
        // if (!isLoading.isClosed) {
        //   isLoading.sink.add(true);
        // }
        // await getShareExperience();
        if(indexShareExp != null){
          _otherExperiences[indexShareExp].commentCount++;
          if(!otherExperiences.isClosed){
            otherExperiences.sink.add(_otherExperiences);
          }
        }else {
          for (int i = 0; i < _selfExperiences.length; i++) {
            if (_selfExperiences[i].id == shareId) {
              _selfExperiences[i].commentCount++;
            }
          }
          if (!selfExperiences.isClosed) {
            selfExperiences.sink.add(_selfExperiences);
          }
        }
        await getCommentShareExperience(state: 0,shareId: shareId);
        // Navigator.pushReplacement(context,
        //     PageTransition(
        //         type: PageTransitionType.bottomToTop,
        //         child:  CommentShareExpScreen(
        //           sharingExperiencePresenter: sharingExperiencePresenter,
        //           shareId: shareId,
        //           indexShareExp: indexShareExp,
        //         )
        //     )
        // );

      }else{
        showToast('امکان ارسال کامنت تجربه وجود ندارد', context);
      }

    } else {
      showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
    }
  }

  getTopicShareExperience({int pageNum = 0 , int pageSize = 10, int? state,String? topicId})async{
    if(state == 0){
      if(!isLoading.isClosed){
        isLoading.sink.add(true);
      }
      if(!isMoreOtherLoading.isClosed){
        isMoreOtherLoading.sink.add(true);
      }

      _otherExperiences.clear();
      if(!otherExperiences.isClosed){
        otherExperiences.sink.add(_otherExperiences);
      }
      counterNumPageOther = 0;
    }else if(state == 1){
      if(!isMoreOtherLoading.isClosed){
        isMoreOtherLoading.sink.add(true);
      }
    }

    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'shareeexperiencev2/topic/$topicId/$pageNum/$pageSize',
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
      if(!isMoreOtherLoading.isClosed){
        isMoreOtherLoading.sink.add(false);
      }

      if(state == 0){
        if(!topic.isClosed){
          topic.sink.add(TopicModel.fromJson(responseBody));
        }
      }
      if(responseBody['totalCount'] != 0){
        if(state == 0){
          totalCountOther = responseBody['totalCount'];
        }else{
          if(!isMoreOtherLoading.isClosed){
            isMoreOtherLoading.sink.add(false);
          }
          // if(!counterMoreLoad.isClosed){
          //   counterMoreLoad.sink.add(1);
          // }
        }
        responseBody['list'].forEach((item){
          _otherExperiences.add(OtherExperienceModel.fromJson(item));
        });
        // print(_tickets[0].text);
        // print(_tickets[1].text);
        if(!otherExperiences.isClosed){
          otherExperiences.sink.add(_otherExperiences);
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
          getTopicShareExperience(pageNum: pageNum,state: 1,topicId: topicId);
        });
      }
    }

  }

  moreLoadGetTopicExp(topicId){
    print(totalCountOther);
    if(otherExperiences.stream.value.length < totalCountOther){
      // if(!tryButtonError.stream.value){
      counterNumPageOther = counterNumPageOther + 1;
      // }
      getTopicShareExperience(state: 1,pageNum: counterNumPageOther,topicId: topicId);
    }
  }

  clearTopics(){
    _topics.clear();
    if(!topics.isClosed){
      topics.sink.add(_topics);
    }
  }


  selectTopic({bool unselectAll  = false}){
    if(unselectAll){
      for(int i=0 ; i<_topics.length ; i++){
        _topics[i].selected = false;
      }
    }else{
      for(int i=0 ; i<_topics.length ; i++){
        if(_topics[i].id == topic.stream.value.id){
          _topics[i].selected = true;
        }else{
          _topics[i].selected = false;
        }
      }
    }
    if(!topics.isClosed){
      topics.sink.add(_topics);
    }
  }

  onPressListTopic(int index){
    for(int i=0 ; i<_topics.length ; i++){
      _topics[i].selected = false;
    }
    _topics[index].selected = !_topics[index].selected;
    if(!topics.isClosed){
      topics.sink.add(_topics);
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

      cropImage(file!.path,text,chatId,context);

    }

    // uploadFile(file,isChatScreen,text,chatId,context);

  }

  cropImage(String imagePath,text, ticketId, context,)async{

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

    uploadFile(text, ticketId, context,file);
  }


  uploadFile(String text,String ticketId,context,File file)async{
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

      await _dio.post('$womanUrl/shareeexperiencev2/file',data: formData,
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

  showToast(String message,context){
    //Fluttertoast.showToast(msg:message,toastLength: Toast.LENGTH_LONG,gravity:gravity);
    CustomSnackBar.show(context, message);
  }

  dispose() {
    isLoading.close();
    tryButtonError.close();
    valueError.close();
    allExperiences.close();
    controller.dispose();
    dialogScale.close();
    isShowDeleteExpDialog.close();
    isLoadingButton.close();
    isMoreSelfLoading.close();
    isMoreOtherLoading.close();
    selfExperiences.close();
    otherExperiences.close();
    textSend.close();
    isMoreCommentLoading.close();
    commentExperiences.close();
    commentsList.close();
    isShowDeleteCommentExpDialog.close();
    commentTextSend.close();
    topic.close();
    topics.close();
    uploadFiles.close();
    sendValuePercentUploadFile.close();
    // counterMoreLoad.close();
  }
}
