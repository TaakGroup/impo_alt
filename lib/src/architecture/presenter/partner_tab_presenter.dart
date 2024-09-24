import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:impo/src/architecture/model/partner_tab_model.dart';
import 'package:impo/src/architecture/view/partner_tab_view.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/core/app/view/widgets/snackbar/custom_snack_bar.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/advertise_model.dart';
import 'package:impo/src/models/challenge/get_challenge_model.dart';
import 'package:impo/src/models/partner/partner_model.dart';
import 'package:impo/src/models/partnerBioRhythm/partner_bioRhythm_messages_model.dart';
import 'package:impo/src/models/partnerBioRhythm/partner_bio_model.dart';
import 'package:impo/src/models/partnerBioRhythm/partner_biorhythm_view_model.dart';
import 'package:impo/src/models/partnerBioRhythm/partner_question_messages_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../firebase_analytics_helper.dart';
import '../../models/partner/get_requests_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:impo/src/screens/home/home.dart';
import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';


class PartnerTabPresenter{

  late PartnerTabView _partnerTabView;

  late PartnerTabModel _partnerTabModel =  PartnerTabModel();

  PartnerTabPresenter(PartnerTabView view){

    this._partnerTabView = view;

  }

  late AnimationController animationControllerDialog;

  final isLoading = BehaviorSubject<bool>.seeded(false);
  final tryButtonError = BehaviorSubject<bool>.seeded(false);
  final valueError = BehaviorSubject<String>.seeded('');
  final bioRhythms = BehaviorSubject<List<PartnerBioRhythmViewModel>>.seeded([]);
  final messageRandomBio = BehaviorSubject<String>.seeded('');
  final messageList = BehaviorSubject<List<String>>.seeded([]);
  final dialogScale = BehaviorSubject<double>.seeded(0.0);
  final isShowBioritmDialog = BehaviorSubject<bool>.seeded(false);
  final exitPartner = BehaviorSubject<bool>.seeded(false);
  // final hasSubscribtion = BehaviorSubject<bool>.seeded(false);
  final isLoadingButton = BehaviorSubject<bool>.seeded(false);
  final advertis = BehaviorSubject<AdvertiseViewModel>();
  final isShowCeriticalDialog = BehaviorSubject<bool>.seeded(false);
  final requests = BehaviorSubject<List<GetRequestsModel>>.seeded([]);
  final isShowRejectPartnerDialog = BehaviorSubject<bool>.seeded(false);
  final isLoadingRefreshIcon = BehaviorSubject<bool>.seeded(false);
  final challenge = BehaviorSubject<GetChallengeModel>();



  Stream<bool> get isLoadingObserve => isLoading.stream;
  Stream<bool> get tryButtonErrorObserve => tryButtonError.stream;
  Stream<String> get valueErrorObserve => valueError.stream;
  Stream<List<PartnerBioRhythmViewModel>> get bioRhythmsObserve => bioRhythms.stream;
  Stream<String> get messageRandomBioObserve => messageRandomBio.stream;
  Stream<List<String>> get messageListObserve => messageList.stream;
  Stream<double> get dialogScaleObserve => dialogScale.stream;
  Stream<bool> get isShowBioritmDialogObserve => isShowBioritmDialog.stream;
  Stream<bool> get exitPartnerObserve => exitPartner.stream;
  // Stream<bool> get hasSubscribtionObserve => hasSubscribtion.stream;
  Stream<bool> get isLoadingButtonObserve => isLoadingButton.stream;
  Stream<AdvertiseViewModel> get advertisObserve => advertis.stream;
  Stream<bool> get isShowCeriticalDialogObserve => isShowCeriticalDialog.stream;
  Stream<List<GetRequestsModel>> get requestsObserve => requests.stream;
  Stream<bool> get isShowRejectPartnerDialogObserve => isShowRejectPartnerDialog.stream;
  Stream<bool> get isLoadingRefreshIconObserve => isLoadingRefreshIcon.stream;
  Stream<GetChallengeModel> get challengeObserve => challenge.stream;


  String _token = '';
  List<PartnerQuestionMessagesModel>? _listMessages = [];
  late PartnerBioModel _partnerBioModel;
  List<PartnerBioRhythmMessagesModel>? _biorhythmMessages = [];
  List<String> _messageList = [];
  List<GetRequestsModel> _requests = [];
  late GetRequestsModel selectedPartner;
  List<String> acceptPartnerAccess = ['مشاهده چرخه قاعدگی/بارداری','مشاهده وضعیت بیوریتم'];


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

  Future<String> getToken()async{
    if(_token == ''){
      RegisterParamViewModel register =  _partnerTabModel.getRegisters();
      _token = register.token!;
    }
    return _token;
  }


  getAdvertise(){
    var advertiseInfo = locator<AdvertiseModel>();
    List<AdvertiseViewModel> allAds = advertiseInfo.advertises;
    List<AdvertiseViewModel> partnerDown = [];
    AdvertiseViewModel? showAds;
    if(allAds.length != 0){
      for(int i=0 ; i<allAds.length ; i++){
        if(allAds[i].place == 3){
          partnerDown.add(allAds[i]);
        }
      }
      if(partnerDown.isNotEmpty){
        if(partnerDown.length > 1){
          final _random =  Random();
          showAds = partnerDown[_random.nextInt(partnerDown.length)];

        }else{
          showAds = partnerDown[0];
        }
      }

    }
    if(!advertis.isClosed && showAds != null){
      advertis.sink.add(showAds);
    }
  }

  getManInfo(BuildContext context,bool autoRefresh)async{
    if(autoRefresh){
      partnerAllRandomMessages.clear();
      viewPartnerBioRhythms.clear();
    }
    _listMessages!.clear();
    _biorhythmMessages!.clear();
    _messageList.clear();
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'info/manInfov3',
        'GET',
        {

        },
        await getToken()
    );
    // print(responseBody);
    if(responseBody != null){
      if(responseBody['valid']){
        if(!exitPartner.isClosed){
          exitPartner.sink.add(true);
        }
        getChallenge();
        // if(!hasSubscribtion.isClosed){
        //   hasSubscribtion.sink.add(responseBody['hasSubscribtion']);
        // }
        responseBody['manSigns'].forEach((item){
          _listMessages!.add(PartnerQuestionMessagesModel.fromJson(
              {
                'text' : item
              }
          ));
        });

        responseBody['biorythimMan']['bodyMessage'].forEach((item){
          _biorhythmMessages!.add(PartnerBioRhythmMessagesModel.fromJson(
              {
                'text' : item,
                'type' : 0
              }
          ));
        });

        responseBody['biorythimMan']['emotionalMessage'].forEach((item){
          _biorhythmMessages!.add(PartnerBioRhythmMessagesModel.fromJson(
              {
                'text' : item,
                'type' : 1
              }
          ));
        });

        responseBody['biorythimMan']['cognitiveMessage'].forEach((item){
          _biorhythmMessages!.add(PartnerBioRhythmMessagesModel.fromJson(
              {
                'text' : item,
                'type' : 2
              }
          ));
        });

        _partnerBioModel = (PartnerBioModel.fromJson(responseBody['biorythimMan']));
        var partnerInfo = locator<PartnerModel>();
        partnerInfo.addPartner(
            {
              'isPair'  : !responseBody['pairData']['validToken'],
              'token' : responseBody['pairData']['token'],
              'time' : responseBody['pairData']['time'],
              'manName' : responseBody['pairData']['manName'],
              'birtDate' : responseBody['pairData']['birtDate'],
              'createTime' : responseBody['pairData']['createTime'],
              'distanceType' : responseBody['pairData']['distanceType'],
              'text' : responseBody['pairData']['text'],
              'shareText' : responseBody['pairData']['shareText'],
              'downloadText' : responseBody['pairData']['downloadText'],
              'directDownloadLink' : responseBody['pairData']['directDownloadLink'],
              'googleDownloadLink' : responseBody['pairData']['googleDownloadLink']
            }
        );
        initBioRhythm(context);
      }else{
        getRequest(false,context);
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }
        if(!exitPartner.isClosed){
          exitPartner.sink.add(false);
        }
        // if(!tryButtonError.isClosed){
        //   tryButtonError.sink.add(true);
        // }
        // valueError.sink.add('شما همدل ندارید، لطفا همدل خودتو اضافه کن :)');

      }

    }else{
      if(!tryButtonError.isClosed){
        tryButtonError.sink.add(true);
      }
      valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }
  }


  getRequest(bool isRefreshCode,BuildContext context)async{
    if(isRefreshCode){
      if(!isLoadingRefreshIcon.isClosed){
        isLoadingRefreshIcon.sink.add(true);
      }
    }else{
      if(!isLoading.isClosed){
        isLoading.sink.add(true);
      }
      if(!tryButtonError.isClosed){
        tryButtonError.sink.add(false);
      }
    }
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'partner/requests',
        'GET',
        {

        },
        await getToken()
    );
    // print(responseBody);
    if(responseBody != null){
      if(isRefreshCode){
        if(!isLoadingRefreshIcon.isClosed){
          isLoadingRefreshIcon.sink.add(false);
        }
      }else{
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }
      }
      _requests.clear();
      responseBody['list'].forEach((item){
        _requests.add(GetRequestsModel.fromJson(item));
      });

      if(!requests.isClosed){
        requests.sink.add(_requests);
      }

    }else{
      if(isRefreshCode){
        showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
        if(!isLoadingRefreshIcon.isClosed){
          isLoadingRefreshIcon.sink.add(false);
        }
      }else{
        if(!tryButtonError.isClosed){
          tryButtonError.sink.add(true);
        }
        valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
      }
    }
  }



  String getName(){
    String name;
    RegisterParamViewModel registerParametersModel =  _partnerTabModel.getRegisters();
    name = registerParametersModel.name!;
    return name;
  }

  String randomNameGET(name){
    List<String> names = [];
    names.add("$name عزیز");
    names.add("$name جان")   ;
    return names[new Random().nextInt(2)];
  }


  initBioRhythm(BuildContext context)async{
    if(viewPartnerBioRhythms.isEmpty){
      viewPartnerBioRhythms.clear();
      viewPartnerBioRhythms.add(PartnerBioRhythmViewModel(
        /// title: 'جسمانی',
        /// mainColor: ColorPallet().powerMain,
        /// gradientColors: [ColorPallet().powerHigh,ColorPallet().powerLight],
        /// icon: 'assets/images/ic_power.svg',
        /// percent: _bioRhythm.bodyPercent < 20 ? (370-((370*20)/100)) : (370-((370*_bioRhythm.bodyPercent)/100)),
        /// viewPercent: '${_bioRhythm.bodyPercent}',
        /// isSelected: false
          title: 'جسمانی',
          mainColor: ColorPallet().powerHigh,
          mainPersent: _partnerBioModel.bodyPercent,
          gradientColors: [ColorPallet().powerHigh, ColorPallet().powerMain],
          gradientIcon: [ColorPallet().powerMain, ColorPallet().powerHigh],
          icon: 'assets/images/ic_power_active.svg',
          deactiveIcon: 'assets/images/ic_power.svg',
          percent:  MediaQuery.of(context).size.width /2 - ( MediaQuery.of(context).size.width /2 - ((_partnerBioModel.bodyPercent *  MediaQuery.of(context).size.width /2) / 100)),
          viewPercent: '${_partnerBioModel.bodyPercent}',
          isSelected: false
      )
      );
      viewPartnerBioRhythms.add(PartnerBioRhythmViewModel(
        /// title: 'احساسی',
        /// mainColor: ColorPallet().emotionalMain,
        /// gradientColors: [ColorPallet().emotionalHigh,ColorPallet().emotionalLight],
        /// icon: 'assets/images/ic_emotional.svg',
        /// percent: _bioRhythm.emotionalPercent < 20 ? (370-((370*20)/100)) : (370-((370*_bioRhythm.emotionalPercent)/100)),
        /// viewPercent: '${_bioRhythm.emotionalPercent}',
        /// isSelected: false
          title: 'احساسی',
          mainPersent: _partnerBioModel.emotionalPercent,
          mainColor: ColorPallet().emotionalHigh,
          gradientColors: [
            ColorPallet().emotionalHigh,
            ColorPallet().emotionalMain
          ],
          gradientIcon: [
            ColorPallet().emotionalMain,
            ColorPallet().emotionalHigh,
          ],
          icon: 'assets/images/ic_emotional_active.svg',
          deactiveIcon: 'assets/images/ic_emotional.svg',
          percent:
          MediaQuery.of(context).size.width /2 - ( MediaQuery.of(context).size.width /2 - ((_partnerBioModel.emotionalPercent *  MediaQuery.of(context).size.width /2) / 100)),
          viewPercent: '${_partnerBioModel.emotionalPercent}',
          isSelected: false
      )
      );
      viewPartnerBioRhythms.add(PartnerBioRhythmViewModel(
        /// title: 'ذهنی',
        /// mainColor: ColorPallet().mentalMain,
        /// gradientColors: [ColorPallet().mentalHigh,ColorPallet().mentalLight],
        /// icon: 'assets/images/ic_mental.svg',
        /// percent: _bioRhythm.cognitivePercent < 20 ? (370-((370*20)/100)) : (370-((370*_bioRhythm.cognitivePercent)/100)),
        /// viewPercent: '${_bioRhythm.cognitivePercent}',
        /// isSelected: false
          title: 'ذهنی   ',
          mainColor: ColorPallet().mentalHigh,
          mainPersent: _partnerBioModel.cognitivePercent,
          gradientColors: [ColorPallet().mentalHigh, ColorPallet().mentalMain],
          gradientIcon: [ColorPallet().mentalMain, ColorPallet().mentalHigh],
          icon: 'assets/images/ic_mental_active.svg',
          deactiveIcon: 'assets/images/ic_mental.svg',
          percent:
          MediaQuery.of(context).size.width /2 - ( MediaQuery.of(context).size.width /2 - ((_partnerBioModel.cognitivePercent *  MediaQuery.of(context).size.width /2) / 100)),
          viewPercent: '${_partnerBioModel.cognitivePercent}',
          isSelected: false
      )
      );
      List<double> percents = [];
      for(int i=0 ; i<viewPartnerBioRhythms.length ; i++){
        percents.add(double.parse(viewPartnerBioRhythms[i].viewPercent!));
      }

      double bigPercent =  percents.reduce(max);

      for(int i=0 ; i<viewPartnerBioRhythms.length ; i++){
        if(bigPercent == double.parse(viewPartnerBioRhythms[i].viewPercent!)){
          viewPartnerBioRhythms[i].isSelected = true;
          break;
        }
      }

    }
    if(!bioRhythms.isClosed){
      bioRhythms.sink.add(viewPartnerBioRhythms);
    }
    initRandomMessages();
    initQuestionMessages();
  }

  initRandomMessages()async{
    final _random =  Random();
    List<PartnerBioRhythmMessagesModel> powerMessages = [];
    List<PartnerBioRhythmMessagesModel> emotionalMessages = [];
    List<PartnerBioRhythmMessagesModel> mentalMessages = [];

    if(_biorhythmMessages != null){
      for(int i=0 ; i<_biorhythmMessages!.length ; i++){
        if(_biorhythmMessages![i].type == 0){
          powerMessages.add(_biorhythmMessages![i]);
        }else if(_biorhythmMessages![i].type == 1){
          emotionalMessages.add(_biorhythmMessages![i]);
        }else if(_biorhythmMessages![i].type == 2){
          mentalMessages.add(_biorhythmMessages![i]);
        }else{

        }
      }
    }

    if(partnerAllRandomMessages.isEmpty){

      if(powerMessages.isNotEmpty){
        partnerAllRandomMessages.add(
            PartnerBioRhythmMessagesModel(
                text: '${powerMessages[_random.nextInt(powerMessages.length)].text}',
                type: powerMessages[_random.nextInt(powerMessages.length)].type
            )
        );
      }else{
        partnerAllRandomMessages.add(PartnerBioRhythmMessagesModel(type: 0,text: ''));
      }


      if(emotionalMessages.isNotEmpty){
        partnerAllRandomMessages.add(
            PartnerBioRhythmMessagesModel(
                text: '${emotionalMessages[_random.nextInt(emotionalMessages.length)].text}',
                type: emotionalMessages[_random.nextInt(emotionalMessages.length)].type
            )
        );
      }else{
        partnerAllRandomMessages.add(PartnerBioRhythmMessagesModel(type: 1,text: ''));
      }


      if(mentalMessages.isNotEmpty){
        partnerAllRandomMessages.add(
            PartnerBioRhythmMessagesModel(
                text: '${mentalMessages[_random.nextInt(mentalMessages.length)].text}',
                type: mentalMessages[_random.nextInt(mentalMessages.length)].type
            )
        );
      }else{
        partnerAllRandomMessages.add(PartnerBioRhythmMessagesModel(type: 2,text: ''));
      }
    }

    RegisterParamViewModel register =  _partnerTabModel.getRegisters();
    PartnerViewModel? partner =  _partnerTabModel.getPartner();

    for(int i=0 ; i<partnerAllRandomMessages.length ; i++){
      partnerAllRandomMessages[i].text =  partnerAllRandomMessages[i].text!.replaceAll('%women%',register.name!);
      partnerAllRandomMessages[i].text = partnerAllRandomMessages[i].text!.replaceAll('%men%',partner != null ? partner.manName : 'همدلت');
    }

    for(int i=0 ; i<viewPartnerBioRhythms.length ; i++){
      if(viewPartnerBioRhythms[i].isSelected){
        if(!messageRandomBio.isClosed){
          messageRandomBio.sink.add(partnerAllRandomMessages[i].text!);
        }
      }
    }


  }

  initQuestionMessages()async{
    List<String> allMessages = [];
    if(_listMessages != null){
      if(_listMessages!.isNotEmpty){
        for(int i=0 ; i<_listMessages!.length ; i++){
          allMessages.add(_listMessages![i].text!);
        }
      }
    }
    if(allMessages.length <= 2){
      _messageList = allMessages;
    }else{
      _messageList = getTwoRandomQuestionMessages(allMessages);
    }

    RegisterParamViewModel register =  _partnerTabModel.getRegisters();
    PartnerViewModel? partner =  _partnerTabModel.getPartner();

    for(int i=0 ; i<_messageList.length ; i++){
      _messageList[i] =  _messageList[i].replaceAll('%women%',register.name!);
      _messageList[i] = _messageList[i].replaceAll('%men%',partner != null ? partner.manName : 'همدلت');
    }


    if(!messageList.isClosed){
      messageList.sink.add(_messageList);
    }
    if(!isLoading.isClosed){
      isLoading.sink.add(false);
    }
  }

  List<String> getTwoRandomQuestionMessages(List<String> quesMessages) {
    int random1 =  Random().nextInt(quesMessages.length);
    int random2 =  Random().nextInt(quesMessages.length);
    if (random1 == random2)
      return getTwoRandomQuestionMessages(quesMessages);
    else {
      List<String> twoStr = [];
      twoStr.add(quesMessages[random1]);
      twoStr.add(quesMessages[random2]);
      return twoStr;
    }
  }

  onPressItemBio(index){
    if(index == 0){
      AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_Body_Item_Clk);
    }else if(index == 1){
      AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_Emotional_Item_Clk);
    }else{
      AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_Mental_Item_Clk);
    }
    for(int i=0 ; i<viewPartnerBioRhythms.length ; i++){
      viewPartnerBioRhythms[i].isSelected = false;
    }
    viewPartnerBioRhythms[index].isSelected = true;

    if(!bioRhythms.isClosed){
      bioRhythms.sink.add(viewPartnerBioRhythms);
    }

    if(partnerAllRandomMessages.isNotEmpty){
      for(int i=0 ; i<partnerAllRandomMessages.length ; i++){
        if(!messageRandomBio.isClosed){
          messageRandomBio.sink.add(partnerAllRandomMessages[index].text!);
        }
      }
    }

  }


  bioritmShowDialog(){
    Timer(Duration(milliseconds: 50),()async{
      animationControllerDialog.forward();
      if(!isShowBioritmDialog.isClosed){
        isShowBioritmDialog.sink.add(true);
      }
    });
  }

  ceriticalShowDialog() {
    Timer(Duration(milliseconds: 50), () async {
      animationControllerDialog.forward();
      if (!isShowCeriticalDialog.isClosed) {
        isShowCeriticalDialog.sink.add(true);
      }
    });
  }

  bioritmCancelDialog()async{
    await animationControllerDialog.reverse();
    if(!isShowBioritmDialog.isClosed){
      isShowBioritmDialog.sink.add(false);
    }

  }

  ceritialCancelDialog() async {
    await animationControllerDialog.reverse();
    if (!isShowCeriticalDialog.isClosed) {
      isShowCeriticalDialog.sink.add(false);
    }
  }


  createMessage(context)async{
    PartnerViewModel partner =  _partnerTabModel.getPartner()!;
    String partnerName = partner.manName;
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(true);
    }

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'message',
        'PUT',
        {
          "fileName" : '',
          "text" : '$partnerNameجان اشتراک همدلمون در ایمپو تموم شده. برای ادامه همدلی، لازمه که اشتراک رو شارژ کنیم.'
        },
        await getToken()
    );
    // print(responseBody);
    if(responseBody != null){
      if(responseBody['valid']){
        if(!isLoadingButton.isClosed){
          isLoadingButton.sink.add(false);
        }


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


  acceptPartner(context,int typeDistance)async{
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(true);
    }
    print(typeDistance);
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'partner/accept',
        'PUT',
        {
          'id' : selectedPartner.id,
          'type' : typeDistance
        },
        await getToken()
    );
    // print(responseBody);
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(false);
    }
    if(responseBody != null){

      if(responseBody['valid']){
        setIsPair(true);
        Navigator.pushReplacement(context,
            PageTransition(
                settings: RouteSettings(name: "/Page1"),
                type: PageTransitionType.topToBottom,
                child:  FeatureDiscovery(
                    recordStepsInSharedPreferences: true,
                    child: Home(
                      indexTab: 2,
                      register: true,
                      isChangeStatus: false,
                    )
                )
            )
        );

      }else{
        showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید',context);
      }

    }else{
      showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید',context);
    }
  }


  setIsPair(bool value)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('pair', value);
  }

  rejectPartner(context)async{
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(true);
    }
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'partner/reject',
        'PUT',
        {
          'id' : selectedPartner.id,
        },
        await getToken()
    );
    // print(responseBody);
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(false);
    }
    if(responseBody != null){

      if(responseBody['valid']){

        rejectPartnerCancelDialog();
        getManInfo(context,true);

      }else{
        showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید',context);
      }

    }else{
      showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید',context);
    }
  }

  rejectPartnerShowDialog() {
    Timer(Duration(milliseconds: 50), () async {
      animationControllerDialog.forward();
      if (!isShowRejectPartnerDialog.isClosed) {
        isShowRejectPartnerDialog.sink.add(true);
      }
    });
  }


  rejectPartnerCancelDialog() async {
    await animationControllerDialog.reverse();
    if (!isShowRejectPartnerDialog.isClosed) {
      isShowRejectPartnerDialog.sink.add(false);
    }
  }

  showToast(String message,context){
    //Fluttertoast.showToast(msg:message,toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.BOTTOM);
    CustomSnackBar.show(context, message);
  }

  getChallenge()async{
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'challenge',
        'GET',
        {

        },
        _partnerTabModel.getRegisters().token!
    );
    print(responseBody);
    if(responseBody != null){
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
      if(responseBody['valid']){
        if(!exitPartner.isClosed){
          exitPartner.sink.add(true);
        }
      }else{
        if(!exitPartner.isClosed){
          exitPartner.sink.add(false);
        }
      }
      if(!challenge.isClosed){
        challenge.sink.add(GetChallengeModel.fromJson(responseBody));
      }

    }else{
      if(!tryButtonError.isClosed){
        tryButtonError.sink.add(true);
      }
      valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }
  }

  dispose(){
    isLoading.close();
    tryButtonError.close();
    valueError.close();
    bioRhythms.close();
    messageRandomBio.close();
    messageList.close();
    dialogScale.close();
    isShowBioritmDialog.close();
    exitPartner.close();
    // hasSubscribtion.close();
    isLoadingButton.close();
    advertis.close();
    isShowCeriticalDialog.close();
    requests.close();
    isShowRejectPartnerDialog.close();
    isLoadingRefreshIcon.close();
    challenge.close();
  }

}