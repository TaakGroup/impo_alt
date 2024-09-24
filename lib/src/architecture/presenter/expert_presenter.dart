
import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impo/src/architecture/model/expert_model.dart';
import 'package:impo/src/architecture/view/expert_view.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/core/app/view/widgets/snackbar/custom_snack_bar.dart';
import 'package:impo/src/data/helper.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/models/expert/apply_discount_model.dart';
import 'package:impo/src/models/expert/chat_ticket_model.dart';
import 'package:impo/src/models/expert/file_name_model.dart';
import 'package:impo/src/models/expert/info.dart';
import 'package:impo/src/models/expert/item_feedback_model.dart';
import 'package:impo/src/models/expert/polar_history_model.dart';
import 'package:impo/src/models/expert/price_list_model.dart';
import 'package:impo/src/models/expert/questionnaire_model.dart';
import 'package:impo/src/models/expert/send_questions_model.dart';
import 'package:impo/src/models/expert/tickets_model.dart';
import 'package:impo/src/models/expert/upload_file_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/home/blank_screen.dart';
import 'package:impo/src/screens/home/home.dart';
import 'package:impo/src/screens/home/tabs/expert/chat_screen.dart';
import 'package:impo/src/screens/home/tabs/expert/clinic_question_list.dart';
import 'package:impo/src/screens/home/tabs/profile/reporting/reporting_screen.dart';
import 'package:impo/src/core/app/view/themes/theme.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../firebase_analytics_helper.dart';
import '../../models/expert/clinic_type_model.dart';
import '../../models/expert/dr_info_model.dart';
import '../../models/expert/ticket_info_model.dart';
import '../../screens/home/tabs/expert/active_clinic_screen.dart';
import '../../screens/home/tabs/expert/clinic_payment_screen.dart';
import '../../screens/home/tabs/expert/clinic_question_screen.dart';
import '../../screens/splash_screen.dart';
import '../../singleton/payload.dart';

class ExpertPresenter{

  late ExpertView _expertView;

  ExpertModel _expertModel =  ExpertModel();

  late FocusNode focusNode;

  late AnimationController animationControllerDialog;
  late ScrollController scrollController;
  late TextEditingController clinicController;
  late StreamSubscription uniLinkSub;
  late TextEditingController discountCodeController;

  ExpertPresenter(ExpertView view){

    this._expertView = view;

  }

  final dialogScale = BehaviorSubject<double>.seeded(0.0);
  final questionnaire = BehaviorSubject<List<QuestionnaireModel>>.seeded([]);
  final isShowDialog = BehaviorSubject<bool>.seeded(false);
  final isLoading = BehaviorSubject<bool>.seeded(false);
  final isNet = BehaviorSubject<bool>.seeded(false);
  final valueError = BehaviorSubject<String>.seeded('');
  final tryButtonError = BehaviorSubject<bool>.seeded(false);
  final infoAdvice = BehaviorSubject<InfoAdviceModel>();
  final clinicType = BehaviorSubject<ClinicTypeModel>();
  final clinicTypId = BehaviorSubject<int>();
  final isShowDialogBackUp = BehaviorSubject<bool>.seeded(false);
  final ticketsList = BehaviorSubject<List<TicketsModel>>.seeded([]);
  final typeTicket = BehaviorSubject<int>.seeded(0);
  final indexTicket = BehaviorSubject<int>.seeded(0);
  final textDialog = BehaviorSubject<String>.seeded('');
  final isLoadingButton = BehaviorSubject<bool>.seeded(false);
  final enableButton = BehaviorSubject<bool>.seeded(false);
  final isError = BehaviorSubject<bool>.seeded(false);
  final uploadFiles = BehaviorSubject<List<UploadFileModel>>.seeded([]);
  final controllerTextTicket = BehaviorSubject<String>.seeded('');
  final chats = BehaviorSubject<ChatTicketModel>();
  // final fileNames = BehaviorSubject<List<FileNameModel>>.seeded([]);
  final textRate = BehaviorSubject<String>.seeded('');
  final valueRate = BehaviorSubject<double>.seeded(0.0);
  final priceList = BehaviorSubject<PriceModel>();
  final sendValuePercentUploadFile = BehaviorSubject<double>.seeded(0);
  final selectedPolar = BehaviorSubject<PriceListModel>();
  final isMoreLoading = BehaviorSubject<bool>.seeded(false);
  final counterMoreLoad = BehaviorSubject<int>.seeded(0);
  final descriptionShop = BehaviorSubject<String>.seeded('');
  final isShowRemoveTicketDialog = BehaviorSubject<bool>.seeded(false);
  final currentIndexTab = BehaviorSubject<int>.seeded(0);
  final positiveFeedBack = BehaviorSubject<List<ItemFeedBackModel>>.seeded([]);
  final negativeFeedBack = BehaviorSubject<List<ItemFeedBackModel>>.seeded([]);
  final isShowFeedbackDialog = BehaviorSubject<bool>.seeded(false);
  final polarHistories = BehaviorSubject<List<PolarHistoryModel>>.seeded([]);
  final listOfValue = BehaviorSubject<List<String>>.seeded([]);
  final ticketInfo = BehaviorSubject<TicketInfoAdviceModel>();
  final selectedDoctor = BehaviorSubject<DoctorInfoModel>();
  final drInfoProfile = BehaviorSubject<DrInfoModel>();
  final isLoadingDiscountButton = BehaviorSubject<bool>.seeded(false);
  final validApplyDiscount = BehaviorSubject<bool>.seeded(true);
  final isLoadingUpload = BehaviorSubject<bool>.seeded(false);

  Stream<double> get dialogScaleObserve => dialogScale.stream;
  Stream<bool> get isShowDialogObserve => isShowDialog.stream;
  Stream<List<QuestionnaireModel>> get questionnaireObserve => questionnaire.stream;
  Stream<bool> get isNetObserve  => isNet.stream;
  Stream<bool> get isLoadingObserve => isLoading.stream;
  Stream<String> get valueErrorObserve => valueError.stream;
  Stream<bool> get tryButtonErrorObserve => tryButtonError.stream;
  Stream<InfoAdviceModel> get infoAdviceObserve => infoAdvice.stream;
  Stream<ClinicTypeModel> get clinicTypeObserve => clinicType.stream;
  Stream<int> get clinicTypIdObserve => clinicTypId.stream;
  Stream<bool> get isShowDialogBackUpObserve => isShowDialogBackUp.stream;
  Stream<List<TicketsModel>> get ticketsListObserve => ticketsList.stream;
  Stream<int> get typeTicketObserve => typeTicket.stream;
  Stream<int> get indexTicketObserve => indexTicket.stream;
  Stream<String> get textDialogObserve => textDialog.stream;
  Stream<bool> get isLoadingButtonObserve => isLoadingButton.stream;
  Stream<bool> get enableButtonObserve => enableButton.stream;
  Stream<bool> get isErrorObserve => isError.stream;
  Stream<List<UploadFileModel>> get uploadFilesObserve => uploadFiles.stream;
  Stream<String> get controllerTextTicketObserve => controllerTextTicket.stream;
  Stream<ChatTicketModel> get chatsObserve => chats.stream;
  // Stream<List<FileNameModel>> get fileNamesObserve => fileNames.stream;
  Stream<String> get textRateObserve => textRate.stream;
  Stream<double> get valueRateObserve => valueRate.stream;
  Stream<PriceModel> get priceListObserve => priceList.stream;
  Stream<double> get sendValuePercentUploadFileObserve => sendValuePercentUploadFile.stream;
  Stream<PriceListModel> get selectedPolarObserve => selectedPolar.stream;
  Stream<bool> get isMoreLoadingObserve => isMoreLoading.stream;
  Stream<int> get counterMoreLoadObserve => counterMoreLoad.stream;
  Stream<String> get descriptionShopObserve => descriptionShop.stream;
  Stream<bool> get isShowRemoveTicketDialogObserve => isShowRemoveTicketDialog.stream;
  Stream<int> get currentIndexTabObserve => currentIndexTab.stream;
  Stream<List<ItemFeedBackModel>> get  positiveFeedBackObserve=> positiveFeedBack.stream;
  Stream<List<ItemFeedBackModel>> get  negativeFeedBackObserve=> negativeFeedBack.stream;
  Stream<bool> get isShowFeedbackDialogObserve => isShowFeedbackDialog.stream;
  Stream<List<PolarHistoryModel>> get polarHistoriesObserve => polarHistories.stream;
  Stream<List<String>> get listOfValueObserve => listOfValue.stream;
  Stream<TicketInfoAdviceModel> get ticketInfoObserve => ticketInfo.stream;
  Stream<DoctorInfoModel> get selectedDoctorObserve => selectedDoctor.stream;
  Stream<DrInfoModel> get drInfoProfileObserve => drInfoProfile.stream;
  Stream<bool> get isLoadingDiscountButtonObserve => isLoadingDiscountButton.stream;
  Stream<bool> get validApplyDiscountObserve => validApplyDiscount.stream;
  Stream<bool> get isLoadingUploadObserve => isLoadingUpload.stream;


  late TextEditingController rateValueController;
  late TabController tabController;
  late List<QuestionnaireModel> _listQuestions = [];
  late List<UploadFileModel> _uploadFiles = [];
  late InfoAdviceModel _infoAdviceModel;
  late ClinicTypeModel _clinicTypeModel;
  late List<TicketsModel> _tickets = [];
  String chatId = '';
  late ChatTicketModel _chatTicketModel;
  late List<FileNameModel> _fileNames = [];
  late PriceModel _priceList;
  Dio _dio =  Dio();
  PanelController? panelController;
  int counterNumPageTickets = 0;
  int totalCountTickets = 0;
  bool dismiss = false;
  int counterForShopScreen = 0;
  late List<ItemFeedBackModel> _positiveFeedBack = [];
  late List<ItemFeedBackModel> _negativeFeedBack = [];
  int counterNumPagePolarHistory = 0;
  int totalCountPolarHistories = 0;
  late List<PolarHistoryModel> _polarHistories = [];

  DrInfoModel? _drInfoProfile;
  int counterNumPageListCommit = 0;
  int totalCountListCommit = 0;
  late TicketInfoAdviceModel _ticketInfo;
  late DoctorInfoModel _selectedDoctor;


  initScrollController(){
    scrollController =  ScrollController();
  }

  disposeScrollController(){
    scrollController.dispose();
  }

  initPanelController(){
    panelController =  PanelController();
  }

  initTextEditingControllerFeedback(){
    rateValueController = TextEditingController();
  }

  initTabController(_this){
    tabController = TabController(length: 2, vsync: _this);
    if(!currentIndexTab.isClosed){
      currentIndexTab.sink.add(tabController.index);
    }
    tabController.addListener(() {
      if(!currentIndexTab.isClosed){
        currentIndexTab.sink.add(tabController.index);
      }
    });
  }

  Future<bool> onWillPopShopScreen()async{
    if(panelController!.isPanelOpen){
      panelController!.close();
    }else{
      return Future.value(true);
    }
    return Future.value(false);
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



  checkNet(isExpertScreen)async{
    if(await checkConnectionInternet()){
      if(!isNet.isClosed){
        isNet.sink.add(true);
      }
      getInfoPolar(isExpertScreen);
    }else{
      if(!isNet.isClosed){
        isNet.sink.add(false);
      }
      valueError.sink.add('برای ارتباط با مشاور نیاز است که اینترنت دستگاه خود را متصل کنید');
    }
  }

  String getToken(){
    return _expertModel.getRegisters().token!;
  }

  // checkBackUp()async{
  //   RegisterParamViewModel =   _expertModel.getRegisters();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if(prefs.getString('userName') != null){
  //     isBackup = true;
  //   }else{
  //     isBackup = false;
  //   }
  //
  // }
  //
  // checkToken(isExpertScreen)async{
  //   RegisterParamViewModel registerParamViewModel = _expertModel.getRegisters();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String userToken = '';
  //   if(prefs.getString('userToken') != null){
  //     userToken = prefs.getString('userToken');
  //   }else{
  //     userToken = '';
  //   }
  //   if(registerParamViewModel.token == ''){
  //   if(userToken != ''){
  //       loginToken(userToken,isExpertScreen);
  //     }else{
  //       registerTokenSaveToServer(isExpertScreen);
  //     }
  //   }else{
  //     getInfoPolar(isExpertScreen,token: registerParamViewModel.token);
  //   }
  // }
  //
  // registerTokenSaveToServer(isExpertScreen)async{
  //   // DataBaseProvider db  =  DataBaseProvider();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   RegisterParamViewModel registerParamViewModel =  _expertModel.getRegisters();
  //   if(prefs.getString('userToken') != null){
  //     if(prefs.getString('userToken') != ''){
  //       // print('yessssss@');
  //       getInfoPolar(isExpertScreen,token: registerParamViewModel.token);
  //     }else{
  //       registerToken(isExpertScreen);
  //     }
  //   }else{
  //     registerToken(isExpertScreen);
  //   }
  //
  // }
  //
  // registerToken(isExpertScreen)async{
  //   String phoneModel = '';
  //   RegisterParamViewModel registerParamViewModel =  _expertModel.getRegisters();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   if(Platform.isAndroid){
  //     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //     phoneModel = androidInfo.model;
  //   }else{
  //     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //     phoneModel = iosInfo.model;
  //   }
  //   // print(RegisterParamViewModel.sex);
  //   Map<String,dynamic>? json =  {};
  //   // RegisterSendServerModel().generateJson(
  //   //     RegisterParamViewModel.name, prefs.getString('deviceToken'),
  //   //     RegisterParamViewModel.birthDay,RegisterParamViewModel.periodDay,
  //   //     RegisterParamViewModel.lastPeriod, RegisterParamViewModel.circleDay,
  //   //     RegisterParamViewModel.sex,phoneModel,RegisterParamViewModel.nationality
  //   // );
  //   // print(json);
  //
  //   if(!isLoading.isClosed){
  //     isLoading.sink.add(true);
  //   }
  //
  //   if(!tryButtonError.isClosed){
  //     tryButtonError.sink.add(false);
  //   }
  //
  //   Map<String,dynamic>? responseBody = await Http().sendRequest(
  //       identityUrl,
  //       'customerAccount/registerToken',
  //       'PUT',
  //       json,
  //       ''
  //   );
  //
  //   // print(responseBody);
  //   // print('saved to server');
  //
  //   if(responseBody != null){
  //     if(responseBody['result']){
  //       prefs.setString('userToken',responseBody['userToken']);
  //       loginToken(responseBody['userToken'],isExpertScreen);
  //     }else{
  //       if(!tryButtonError.isClosed){
  //         tryButtonError.sink.add(true);
  //       }
  //       valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
  //     }
  //   }else{
  //     if(!tryButtonError.isClosed){
  //       tryButtonError.sink.add(true);
  //     }
  //     valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
  //   }
  // }
  //
  // loginToken(String userToken,isExpertScreen)async{
  //   String phoneModel = '';
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   if(Platform.isAndroid){
  //     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //     phoneModel = androidInfo.model;
  //   }else{
  //     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //     phoneModel = iosInfo.model;
  //   }
  //   Map<String,dynamic>? responseBody = await Http().sendRequest(
  //       identityUrl,
  //       'customerAccount/loginToken',
  //       'POST',
  //       {
  //         "deviceToken" :  prefs.getString('deviceToken'),
  //         "phoneModel" : phoneModel,
  //         "userToken" : userToken
  //       },
  //       ''
  //   );
  //
  //   // print(responseBody);
  //   if(responseBody != null){
  //     if(responseBody['result']){
  //       await _expertModel.updateRegister('token', responseBody['token']);
  //       getInfoPolar(isExpertScreen,token: responseBody['token']);
  //     }else{
  //       if(!tryButtonError.isClosed){
  //         tryButtonError.sink.add(true);
  //       }
  //       valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
  //     }
  //   }else{
  //     if(!tryButtonError.isClosed){
  //       tryButtonError.sink.add(true);
  //     }
  //     valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
  //   }
  //
  //
  // }


  getInfoPolar(isExpertScreen,{String chatId = '' , dynamic thiss = ''})async{

    if(!counterMoreLoad.isClosed){
      counterMoreLoad.sink.add(0);
    }

    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }

    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }

      Map<String,dynamic>? responseBody = await Http().sendRequest(
          womanUrl,
          // 'advice/clinic',
          'advice/newclinicv1',
          'GET',
          {

          },
          getToken()
      );
    print(responseBody);
    if(responseBody != null){
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
      // if(isExpertScreen){
      //   if(token != ''){
      //     checkBackUp();
      //   }
      // }else{
      //   getChatsTicket(chatId,thiss);
      // }
      if (!isExpertScreen) {
        getChatsTicket(chatId, thiss);
      }
      _infoAdviceModel = InfoAdviceModel.fromJson(responseBody);
      createListOfValues(_infoAdviceModel.listOfValues);
      if(!infoAdvice.isClosed){
        infoAdvice.sink.add(_infoAdviceModel);
      }


    }else{
      if(!tryButtonError.isClosed){
        tryButtonError.sink.add(true);
      }
      valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }

  }

  createListOfValues(String listOfValues){
    if(listOfValues != ''){
      listOfValue.value =  listOfValues.split('\n');
    }
  }

  getClinicType()async{

    if(!counterMoreLoad.isClosed){
      counterMoreLoad.sink.add(0);
    }

    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }

    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'advice/types/${clinicTypId.stream.value}',
        'GET',
        {

        },
        getToken()
    );
    // print(responseBody);
    if(responseBody != null){
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }

      _clinicTypeModel = ClinicTypeModel.fromJson(responseBody);
      if(!clinicType.isClosed){
        clinicType.sink.add(_clinicTypeModel);
      }


    }else{
      if(!tryButtonError.isClosed){
        tryButtonError.sink.add(true);
      }
      valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }

  }

  onPressActiveClinic(context,expertPresenter,TicketsModel ticketsModel,fromActiveClini){
    if(ticketsModel.state == 5){
       Navigator.push(
           context,
           PageTransition(
               type: PageTransitionType.fade,
               child:  ClinicQuestionScreen(
                expertPresenter: expertPresenter,
                 bodyTicketInfo: {'id' : ticketsModel.ticketId},
                 ticketId: ticketsModel.ticketId,
               )
           )
       );
    }else{
      if(!clinicTypId.isClosed){
        clinicTypId.sink.add(ticketsModel.clinicId!);
      }
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child:  ChatScreen(
                expertPresenter: expertPresenter,
                chatId: ticketsModel.ticketId,
                fromMainExpert: true,
                fromActiveClini: fromActiveClini,
              )
          )
      );
    }
  }

  // onPressClinic(context,currentValue,expertPresenter,int id,int index){
  //   print(id);
  //   if(!clinicTypId.isClosed){
  //     clinicTypId.sink.add(id);
  //   }
  //
  //   Navigator.push(
  //     context,
  //     PageTransition(
  //       type: PageTransitionType.fade,
  //       child: ExpertScreen(
  //         expertPresenter: expertPresenter,
  //         currentValue: currentValue,
  //       )
  //     )
  //   );
  // }

  onPressExpertAdvice(context,InfoAdviceTypes infoAdviceTypes,expertPresenter,int id){
    // if(isBackup){

      if(!typeTicket.isClosed){
        typeTicket.sink.add(id);
      }

      /// if(!indexTicket.isClosed){
      ///   indexTicket.sink.add(index);
      /// }

      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child:   ClinicQuestionScreen(
                expertPresenter: expertPresenter,
                bodyTicketInfo: {'type' : infoAdviceTypes.id},
              )
          )
      );
      /// Navigator.push(
      ///     context,
      ///     PageTransition(
      ///         type: PageTransitionType.fade,
      ///         child:  ExpertQuestionList(
      ///           currentValue: currentValue,
      ///           expertPresenter: expertPresenter,
      ///           randomMessage: e,
      ///         )randomMessag
      ///     )
      /// );
    // }else{
    //   showDialog();
    // }
  }


  showDialog(){
    Timer(Duration(milliseconds: 150),()async{
      animationControllerDialog.forward();
      if(!isShowDialog.isClosed){
        isShowDialog.sink.add(true);
      }
    });
  }

  onPressYesDialog()async{
    // print('ssassaas');
    await animationControllerDialog.reverse();
    if(!isShowDialog.isClosed){
      isShowDialog.sink.add(false);
    }
  }

  // showBackUpDialog(){
  //   Timer(Duration(milliseconds: 150),()async{
  //     animationControllerDialog.forward();
  //     if(!isShowDialogBackUp.isClosed){
  //       isShowDialogBackUp.sink.add(true);
  //     }
  //   });
  // }

  // onPressYesBackUpDialog()async{
  //   await animationControllerDialog.reverse();
  //   if(!isShowDialogBackUp.isClosed){
  //     isShowDialogBackUp.sink.add(false);
  //   }
  // }

  RegisterParamViewModel getRegister(){
    return  _expertModel.getRegisters();
  }

  String getName(){
    String name;
    name = getRegister().name!;
    return name;
  }

  setTypeTicketInit(bool isAllTicket){
    if(isAllTicket){
      if(!typeTicket.isClosed){
        typeTicket.sink.add(-2);
      }
    }
  }

  getTickets({int pageNum = 0 , int pageSize = 10, int? state})async{
    // print(pageNum);
    if(state == 0){
      if(!isLoading.isClosed){
        isLoading.sink.add(true);
      }
      if(!isMoreLoading.isClosed){
        isMoreLoading.sink.add(true);
      }

      _tickets.clear();
      if(!ticketsList.isClosed){
        ticketsList.sink.add(_tickets);
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
    print('typeTiiicket : ${typeTicket.stream.value}');
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'advice/tickets/$pageNum/$pageSize/${typeTicket.stream.value}',
        'GET',
        {

        },
        getToken()
    );
    // print(responseBody);
    if(responseBody != null){
      // print(responseBody['totalCount']);
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
      if(!isMoreLoading.isClosed){
        isMoreLoading.sink.add(false);
      }
      if(responseBody['totalCount'] != 0){
        if(state == 0){
          totalCountTickets = responseBody['totalCount'];
        }else{
          if(!isMoreLoading.isClosed){
            isMoreLoading.sink.add(false);
          }
          if(!counterMoreLoad.isClosed){
            counterMoreLoad.sink.add(1);
          }
        }
        responseBody['tickets'].forEach((item){
          _tickets.add(TicketsModel.fromJson(item));
        });
        // print(_tickets[0].text);
        // print(_tickets[1].text);
        if(!ticketsList.isClosed){
          ticketsList.sink.add(_tickets);
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
          getTickets(pageNum: pageNum,state: 1);
        });
      }
    }

  }

  moreLoadGetTickets(){
      if(ticketsList.stream.value.length < totalCountTickets){
        // if(!tryButtonError.stream.value){
        counterNumPageTickets = counterNumPageTickets + 1;
        // }
        getTickets(state: 1,pageNum: counterNumPageTickets);
    }
  }

  dismissMoreLoad(){
    // print('false');
    dismiss  = false;
  }

  getQuestions()async{
    _listQuestions.clear();
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }

    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }
    print(typeTicket.stream.value);
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'advice/questions/${typeTicket.stream.value}',
        'GET',
        {

        },
        getToken()
    );

    // print(responseBody);

    if(responseBody != null){
      if(responseBody['dialogVisible']){
        showDialog();
        if(!textDialog.isClosed){
          textDialog.sink.add('تایید/${responseBody['dialogText']}');
        }
      }
      if(responseBody['questionList'] != []){
        responseBody['questionList'].forEach((item){
          _listQuestions.add(QuestionnaireModel.fromJson(item));
        });

       b :  for(int i=0 ; i<_listQuestions.length ; i++){
         a : for(int j=0 ;j< _listQuestions[i].subAnswer.length ; j++){
            if(_listQuestions[i].subAnswer[j].subAnswer == _listQuestions[i].answer && _listQuestions[i].validAnswer){
              _listQuestions[i].selected = true;
              break a;
            }else{
              _listQuestions[i].selected = false;
            }
          }
        }

        if(!questionnaire.isClosed){
          questionnaire.sink.add(_listQuestions);
        }

        checkQuestions();

        // print(questionnaire.stream.value.length);
        // print(questionnaire.stream.value[0].text);
        // print(questionnaire.stream.value[1].text);
        // print(questionnaire.stream.value[2].text);
        // print(questionnaire.stream.value[3].text);
        // print(questionnaire.stream.value[4].text);
      }
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
    }else{
      if(!tryButtonError.isClosed){
        tryButtonError.sink.add(true);
      }
      valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }

  }

  checkQuestions(){
    List<String> answers = [];
    List<String> supplementAnswers = [];
    List<String> lengthHasSupplementAnswers = [];
    for(int i=0 ; i<questionnaire.stream.value.length ; i++){
      if(questionnaire.stream.value[i].answerController.text != ''){
        answers.add(questionnaire.stream.value[i].answerController.text);
      }
      if(questionnaire.stream.value[i].type == 0 && questionnaire.stream.value[i].hasSupplementAnswer){
        lengthHasSupplementAnswers.add(questionnaire.stream.value[i].supplementaryAnswerController.text);
        if(questionnaire.stream.value[i].subAnswer[0].selected){
          if(questionnaire.stream.value[i].supplementaryAnswerController.text != ''){
            supplementAnswers.add(questionnaire.stream.value[i].supplementaryAnswerController.text);
          }
        }else{
          supplementAnswers.add(questionnaire.stream.value[i].supplementaryAnswerController.text);
        }
      }
    }
    //&& supplementAnswers.length == lengthHasSupplementAnswers.length
    if(answers.length == questionnaire.stream.value.length){
      if(!enableButton.isClosed){
        enableButton.sink.add(true);
      }
    }else{
      if(!enableButton.isClosed){
        enableButton.sink.add(false);
      }
    }
  }

  onPressCreateFormatSendQuestion(context,ExpertPresenter expertPresenter , String name,currentValue){
    List<Map<String,dynamic>?> questionsList = [];
    for(int i=0 ; i<questionnaire.stream.value.length ; i++){
      questionsList.add(
        SendQuestionsModel().setJson(
            questionnaire.stream.value[i].id,
            questionnaire.stream.value[i].answerController.text,
            questionnaire.stream.value[i].type == 0 && questionnaire.stream.value[i].hasSupplementAnswer ? questionnaire.stream.value[i].supplementaryAnswerController.text : ''
        )
      );
    }
    // print(questionsList);
    sendQuestions(questionsList,context, expertPresenter ,name,currentValue);
  }

  sendQuestions(List<Map<String,dynamic>?> questionsList,context,ExpertPresenter expertPresenter ,String name,currentValue)async{
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(true);
    }

    if(!isError.isClosed){
      isError.sink.add(false);
    }

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'advice/questions',
        'POST',
        {
          'questionsList' : questionsList
        },
        getToken()
    );

    // print(responseBody);

    if(responseBody != null){
      if(responseBody['isValid']){
        if(!isLoadingButton.isClosed){
          isLoadingButton.sink.add(false);
        }
        /// Navigator.push(
        ///   context,
        ///   PageTransition(
        ///     type: PageTransitionType.fade,
        ///     child:   EnterQuestionScreen(
        ///       name: name,
        ///       expertPresenter: expertPresenter,
        ///       currentValue: currentValue,
        ///     )
        ///   )
        /// );
      }else{
        if(!isLoadingButton.isClosed){
          isLoadingButton.sink.add(false);
        }
        if(!isError.isClosed){
          isError.sink.add(true);
        }
        showErrorDialog();
        if(!valueError.isClosed){
          valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
        }
      }
    }else{
      if(!isLoadingButton.isClosed){
        isLoadingButton.sink.add(false);
      }
      if(!isError.isClosed){
        isError.sink.add(true);
      }
      showErrorDialog();
      if(!valueError.isClosed){
        valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
      }
    }

  }

  showErrorDialog(){
    Timer(Duration(milliseconds: 150),()async{
      animationControllerDialog.forward();
      if(!isError.isClosed){
        isError.sink.add(true);
      }
    });
  }

  onPressOkErrorDialog()async{
    await animationControllerDialog.reverse();
    if(!isError.isClosed){
      isError.sink.add(false);
    }
  }

  clearUploadFile(){
    _uploadFiles.clear();
    if(!uploadFiles.isClosed){
      uploadFiles.sink.add(_uploadFiles);
    }
  }

  getFileImage(int type ,bool isChatScreen,{String text = '',String chatId = '' })async{
    if(!isLoadingUpload.isClosed){
      isLoadingUpload.sink.add(true);
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
       _uploadFiles.add(
           UploadFileModel.fromJson(
               {
                 'name' : file!.path.split('/').last,
                 'type' : 0,
                 'fileNameForSend' : '',
                 'stateUpload' : 0,
                 'fileName' : file
               }
           )
       );

       if(!uploadFiles.isClosed){
         uploadFiles.sink.add(_uploadFiles);
       }

    }

    uploadFile(file!,isChatScreen,text,chatId);

  }

  uploadFile(PickedFile image,bool isChatScreen,String text,String ticketId)async{

    _dio = Dio();
    FormData formData = FormData();

    formData.files.addAll(
        [MapEntry('files',MultipartFile.fromFileSync(image.path))]);

    try{

      await _dio.put('$mediaUrl/file/private',data: formData,
      onSendProgress: (int sent, int total){
        // print(sent);
        // print(total);
        sendValuePercentUploadFile.sink.add((sent*100)/total);
      }
      ).
      then((res)async{
        // print(res.statusMessage);
        // print(res.statusCode);
        if(!isLoadingUpload.isClosed){
          isLoadingUpload.sink.add(false);
        }
        if(res.statusMessage == 'OK'){
          // print(res.data);
          _uploadFiles.insert(0,
              UploadFileModel.fromJson(
                  {
                    'name' : _uploadFiles[0].name,
                    'type' : _uploadFiles[0].type,
                    'fileNameForSend' : res.data,
                    'stateUpload' : 1,
                    'fileName' : _uploadFiles[0].fileName
                  }
              )
          );
          _uploadFiles.removeAt(1);
          if(!uploadFiles.isClosed){
            uploadFiles.sink.add(_uploadFiles);
          }
          final File saveFile = File('${await getAppDirectory()}/${res.data}');
          saveFile.writeAsBytes(await image.readAsBytes());
          // if(isChatScreen){
          //   onPressSendMessage(text, ticketId);
          // }
        }else{
          if(_uploadFiles.length != 0){
            showDialog();
            if(!textDialog.isClosed){
              textDialog.sink.add('تایید/مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
            }
            _uploadFiles.removeAt(0);
            if(!uploadFiles.isClosed){
              uploadFiles.sink.add(_uploadFiles);
            }
          }
        }

      });

    }catch(e){
      if(!isLoadingUpload.isClosed){
        isLoadingUpload.sink.add(false);
      }
      if(_uploadFiles.length != 0){
        showDialog();
        if(!textDialog.isClosed){
          textDialog.sink.add('تایید/مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
        }
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
    if(!isLoadingUpload.isClosed){
      isLoadingUpload.sink.add(false);
    }
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


  onChangeTextTicket(value){
    if(!controllerTextTicket.isClosed){
      controllerTextTicket.sink.add(value);
    }
  }

  onPressSendButton(){
    showDialog();
    if(!textDialog.isClosed){
      textDialog.sink.add('تایید/مشاوران ایمپو در اولین فرصت پاسخگوی شما هستند\n\nآیا از ارسال این سوال اطمینان دارید؟');
    }
  }
  //
  // pressPayForCreateTicket(context,expertPresenter,String ticketId,Animations animations){
  //   if(!isLoadingDiscountButton.stream.value){
  //     if(clinicController.text != ''){
  //       createTicketNewClinic(clinicController.text,context, expertPresenter,ticketId,animations);
  //     }else{
  //       FocusScope.of(context).requestFocus(focusNode);
  //       animations.showShakeError('لطفا فیلد سوال را پر کنید');
  //     }
  //   }
  // }

  createTicketNewClinic(context,expertPresenter,String? ticketId,Animations animations)async{
      if(!isLoadingButton.isClosed){
        isLoadingButton.sink.add(true);
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userName = prefs.getString('userName');
      if(ticketId == null){
        ticketId = '';
      }
      // print('ticketId : $ticketId');
      // print('code : ${ticketInfo.stream.value.info.dis}');
      Map<String,dynamic>? responseBody = await Http().sendRequest(
          womanUrl,
          'advice/new/$ticketId',
          'PUT',
          {
            "fileName" : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileNameForSend : '',
            "text" : clinicController.text,
            "ticket" : typeTicket.stream.value,
            'drId' : selectedDoctor.stream.value.id,
            'code' : ticketInfo.stream.value.info.discountCode
          },
          getToken()
      );
      print(responseBody);
      if(responseBody != null){
        if(responseBody['isValid']){
          if(responseBody['redirectBank']){
            if(responseBody['bankResp']['isSuccess']){
              await _launchURL("https://web.impo.app/financial/AsanPardakht/${responseBody['bankResp']['token']}/$userName");
              Timer(Duration(seconds: 1),(){
                if(!isLoadingButton.isClosed){
                  isLoadingButton.sink.add(false);
                }
              });
            }else{
              animations.showShakeError('مشکلی در پرداخت پیش آمد، دوباره تلاش کنید');
              if(!isLoadingButton.isClosed){
                isLoadingButton.sink.add(false);
              }
            }
          }else{
            if(!isLoadingButton.isClosed){
              isLoadingButton.sink.add(false);
            }
            chatId = responseBody['id'];
            goToChatScreen(context,expertPresenter);
          }
        }else{
          if(!isLoadingButton.isClosed){
            isLoadingButton.sink.add(false);
          }
          animations.showShakeError('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
          // showDialog();
          // if(!textDialog.isClosed){
          //   textDialog.sink.add('تایید/مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
          // }
        }
      }else{
        if(!isLoadingButton.isClosed){
          isLoadingButton.sink.add(false);
        }
        animations.showShakeError('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
        // showDialog();
        // if(!textDialog.isClosed){
        //   textDialog.sink.add('تایید/مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
        // }
      }

  }

  // createTicket(context,expertPresenter)async{
  //   if(!isLoadingButton.isClosed){
  //     isLoadingButton.sink.add(true);
  //   }
  //
  //   Map<String,dynamic>? responseBody = await Http().sendRequest(
  //       womanUrl,
  //       'advice',
  //       'PUT',
  //       {
  //         "fileName" : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileNameForSend : '',
  //         "text" : controllerTextTicket.stream.value,
  //         "ticket" : typeTicket.stream.value
  //       },
  //       getToken()
  //   );
  //
  //   if(responseBody != null){
  //     if(responseBody['isValid']){
  //       if(!isLoadingButton.isClosed){
  //         isLoadingButton.sink.add(false);
  //       }
  //       chatId = responseBody['id'];
  //       goToChatScreen(context,expertPresenter);
  //       // showDialog();
  //       // if(!textDialog.isClosed){
  //       //   textDialog.sink.add('تایید/سوال شما در اولین فرصت پاسخ داده میشود');
  //       // }
  //     }else{
  //       if(!isLoadingButton.isClosed){
  //         isLoadingButton.sink.add(false);
  //       }
  //       showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
  //       // showDialog();
  //       // if(!textDialog.isClosed){
  //       //   textDialog.sink.add('تایید/مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
  //       // }
  //     }
  //   }else{
  //     if(!isLoadingButton.isClosed){
  //       isLoadingButton.sink.add(false);
  //     }
  //     showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
  //     // showDialog();
  //     // if(!textDialog.isClosed){
  //     //   textDialog.sink.add('تایید/مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
  //     // }
  //   }
  //
  // }

  showToast(String message,context){
    //Fluttertoast.showToast(msg:message,toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.BOTTOM);
    CustomSnackBar.show(context, message);
  }

  goToChatScreen(context,expertPresenter)async{
    await animationControllerDialog.reverse();
    if(!isShowDialog.isClosed){
      isShowDialog.sink.add(false);
    }
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child:  ChatScreen(
          expertPresenter: expertPresenter,
          chatId: chatId,
          fromMainExpert: false,
          fromActiveClini: false,
        )
      )
    );
  }

  getChatsTicket(String ticketId,_this)async{
    String dir = await getAppDirectory();
    // _fileNames.clear();
    // if(!fileNames.isClosed){
    //   fileNames.sink.add(_fileNames);
    // }

    _uploadFiles.clear();
    if(!uploadFiles.isClosed){
      uploadFiles.sink.add(_uploadFiles);
    }

    if(!controllerTextTicket.isClosed){
      controllerTextTicket.sink.add('');
    }
    //  _chatTicketModel.chats.clear();
    //
    // if(!chats.isClosed){
    //   chats.sink.add(_chatTicketModel);
    // }

    // _chatTicketModel = ChatTicketModel.fromJson(
    //   {
    //
    //   }
    // );
    //
    // if(!chats.isClosed){
    //   chats.sink.add(_chatTicketModel);
    // }

    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'advice/ticket/$ticketId',
        'GET',
        {

        },
        getToken()
    );
    print(responseBody);
    if(responseBody != null){
      _chatTicketModel = ChatTicketModel.fromJson(responseBody);
      if(!chats.isClosed){
        chats.sink.add(_chatTicketModel);
      }
      if(_chatTicketModel.state == 3 && !_chatTicketModel.isRate){
        _negativeFeedBack.clear();
        _positiveFeedBack.clear();
        for(int i=0 ; i<_chatTicketModel.positive.length ; i++){
          _positiveFeedBack.add(ItemFeedBackModel(text: _chatTicketModel.positive[i],isSelected: false));
        }
        for(int i=0 ; i<_chatTicketModel.negative.length ; i++){
          _negativeFeedBack.add(ItemFeedBackModel(text: _chatTicketModel.negative[i],isSelected: false));
        }
        if(!positiveFeedBack.isClosed){
          positiveFeedBack.sink.add(_positiveFeedBack);
        }
        if(!negativeFeedBack.isClosed){
          negativeFeedBack.sink.add(_negativeFeedBack);
        }
      }
      for(int i=0 ; i< _chatTicketModel.chats.length ; i++){
        // print('sideType:${_chatTicketModel.chats[i].sideType}');
        _chatTicketModel.chats[i].animationController = AnimationController(vsync: _this,duration: Duration(milliseconds: 300));
        if(_chatTicketModel.chats[i].media != null){
          if(_chatTicketModel.chats[i].media != ''){
            File file = File('$dir/${_chatTicketModel.chats[i].media}');
            if(await file.exists()){
              _chatTicketModel.chats[i].progress = 100;
            }
          }
        }
      }
      if(_chatTicketModel.chats != []){
        List<String> fileNames = [];
        for(int i=0 ; i<_chatTicketModel.chats.length ; i++){
          fileNames.add(_chatTicketModel.chats[i].media == null ? '' : _chatTicketModel.chats[i].media!);
        }
        if(fileNames.length != 0){
          getSizeFile(fileNames);
        }else{
          if(!isLoading.isClosed){
            isLoading.sink.add(false);
          }
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

  Future download2(ChatsModel chatsModel,index) async {
    try {
      Response response = await _dio.get(
        '$mediaUrl/file/${chatsModel.media}',
        onReceiveProgress: (received, total){
          _chatTicketModel.chats[index].progress = (received / total * 100).toInt();
          if(!chats.isClosed){
            chats.sink.add(_chatTicketModel);
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
      final File saveFile = File('${await getAppDirectory()}/${chatsModel.media}');
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
            getToken()
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

        // _fileNames.add(FileNameModel.fromJson(
        //     {
        //       "fileName": '',
        //       "type": '',
        //       "fileSize": 20000
        //     }
        // ));

      }

    }

    for(int j=0 ; j<_fileNames.length ; j++){
      for(int i=0 ; i<_chatTicketModel.chats.length ; i++){
        // print(_chatTicketModel.chats[i].media);
        if(_chatTicketModel.chats[i].media != '' && _chatTicketModel.chats[i].fileSize == null){
          _chatTicketModel.chats[i].fileSize = _fileNames[j].fileSize;
          break;
        }
      }
    }
    if(!chats.isClosed){
      chats.sink.add(_chatTicketModel);
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

  onPressSendMessage(String text , String ticketId)async {
    // print('texttttt: $text');
    if (text != '' || uploadFiles.stream.value.length != 0) {
      if (!isLoadingButton.isClosed) {
        isLoadingButton.sink.add(true);
      }

      Map<String,dynamic>? responseBody = await Http().sendRequest(
          womanUrl,
          'advice/ticket/$ticketId',
          'PUT',
          {
            'text': text,
            'fileName': uploadFiles.stream.value.length != 0 ? uploadFiles
                .stream.value[0].fileNameForSend : ''
          },
          getToken()
      );

      if (responseBody != null) {
        if (responseBody['isValid']) {
          if (!isLoadingButton.isClosed) {
            isLoadingButton.sink.add(false);
          }
            showDialog();
            if (!textDialog.isClosed) {
              textDialog.sink.add('تایید/سوال شما در اولین فرصت پاسخ داده میشود');
            }
          }else{
          if (!isLoadingButton.isClosed) {
            isLoadingButton.sink.add(false);
          }
          showDialog();
          if (!textDialog.isClosed) {
            textDialog.sink.add(
                'تایید/مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
          }
        }
        } else {
        if (!isLoadingButton.isClosed) {
          isLoadingButton.sink.add(false);
        }
          showDialog();
          if (!textDialog.isClosed) {
            textDialog.sink.add(
                'تایید/مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
          }
        }
      }
  }

  onPressOkSuccessfulDialogInChatScreen(context,expertPresenter,chatId,fromMainExpert,fromActiveClini)async{
    await animationControllerDialog.reverse();
    if(!isShowDialog.isClosed){
      isShowDialog.sink.add(false);
    }
    Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child:  BlankScreen(
              indexTab: 6,
              expertPresenter: expertPresenter,
              chatId: chatId,
              fromMainExpert: fromMainExpert,
              fromActiveClini: fromActiveClini,
            )
        )
    );
  }

  // listenPort(id,status,progress){
  //   if (_chatTicketModel != null && _chatTicketModel.chats.isNotEmpty) {
  //     for(int i=0 ; i<_chatTicketModel.chats.length ; i++){
  //       if(_chatTicketModel.chats[i].taskId == id){
  //         _chatTicketModel.chats[i].status = status;
  //         _chatTicketModel.chats[i].progress = progress;
  //         chats.sink.add(_chatTicketModel);
  //       }
  //     }
  //   }
  // }

  clearTextRate(){
    if(!textRate.isClosed){
      textRate.sink.add('');
    }
    if(!valueRate.isClosed){
      valueRate.sink.add(0);
    }
  }

  changeRateValue(double value){
    AnalyticsHelper().log(AnalyticsEvents.RatePg_ChangeRateValue_Icon_Clk);
    if(!valueRate.isClosed){
      valueRate.sink.add(value);
    }
    if(value == 5.0 || value == 4.0){
      tabController.index = 1;
    }else{
      tabController.index = 0;
    }
    // if(value == 5.0 || value == 4.0){
    //   textRate.sink.add('خوشحالیم که تونستیم کمکت کنیم. ممنون از اعتمادت.');
    // }else if(value == 3){
    //   textRate.sink.add('خوشحالیم که تونستیم کمکت کنیم. امیدواریم در آینده، رضایت بیشتری داشته باشی.');
    // }else if(value == 2 || value == 1){
    //   textRate.sink.add('لطفاً نظرت رو واسمون بنویس تا بتونیم بررسی کنیم و در آینده سرویس بهتری ارائه بدیم.');
    // }else{
    //   textRate.sink.add('');
    // }
  }

  sendRequestDrRate(String ticketId,expertPresenter,context,fromMainExpert,fromActiveClini)async{
    if (!isLoadingButton.isClosed) {
      isLoadingButton.sink.add(true);
    }

    List<String> selectedFeedbackNegative = [];
    List<String> selectedFeedbackPositive = [];

    for(int i=0 ; i<_negativeFeedBack.length ; i++){
      if(_negativeFeedBack[i].isSelected){
        selectedFeedbackNegative.add(_negativeFeedBack[i].text!);
      }
    }

    for(int i=0 ; i<_positiveFeedBack.length ; i++){
      if(_positiveFeedBack[i].isSelected){
        selectedFeedbackPositive.add(_positiveFeedBack[i].text!);
      }
    }
    // print(valueRate.stream.value);
    // print(rateValueController.text);
    // print(selectedFeedbackNegative);
    // print(selectedFeedbackPositive);

    AnalyticsHelper().log(
        AnalyticsEvents.RatePg_SendFeedback_Btn_Clk,
      parameters: {
        'rate': valueRate.stream.value,
        'description' : rateValueController.text,
        'feedbackNegative' : selectedFeedbackNegative,
        'feedbackPositive' : selectedFeedbackPositive
      }
    );

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'advice/ticket/$ticketId/drRate',
        'POST',
        {
          'rate': valueRate.stream.value,
          'description' : rateValueController.text,
          'feedbackNegative' : selectedFeedbackNegative,
          'feedbackPositive' : selectedFeedbackPositive

        },
        getToken()
    );

    // print(responseBody);

    if (responseBody != null) {
      if (responseBody['isValid']) {
        if (!isLoadingButton.isClosed) {
          isLoadingButton.sink.add(false);
        }

        closeFeedbackDialog();
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child:  ChatScreen(
                  expertPresenter: expertPresenter,
                  chatId: ticketId,
                  fromRateScreen: true,
                  fromMainExpert: fromMainExpert,
                  fromActiveClini: fromActiveClini,
                )
            )
        );

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

  getPriceList()async{
    _priceList = PriceModel();

    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }

    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'advice/priceListv1',
        'GET',
        {

        },
        getToken()
    );

    print(responseBody);

    if(responseBody != null){
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }

      _priceList = PriceModel.fromJson(responseBody);

      if(!priceList.isClosed){
        priceList.sink.add(_priceList);
      }

      // responseBody['prices'].forEach((item){
      //   counterForShopScreen++;
      //   if(counterForShopScreen == 4){
      //     counterForShopScreen = 1;
      //   }
      //   _priceList.add(PriceListModel.fromJson(item,counterForShopScreen));
      // });
      // if(!descriptionShop.isClosed){
      //   if(responseBody['description'] != null){
      //     descriptionShop.sink.add(responseBody['description']);
      //   }
      // }
      // if(!priceList.isClosed){
      //   priceList.sink.add(_priceList);
      // }

    }else{

      if(!tryButtonError.isClosed){
        tryButtonError.sink.add(true);
      }
      valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');

    }

  }

  Future<Null> initUniLinks(Animations animations,int fromScreen,context,ExpertPresenter expertPresenter,name) async {
     /// 0 ==> ShopScreen
    /// 1 ==> EnterQuestion
    /// 2 ==> ReportingScreen
    /// 3 ===> ClinicQuestionScreen
    uniLinkSub = uriLinkStream.listen((Uri? uri)async{

      Map res = uri!.queryParameters;
      print('ressss : $res');
      print('ressss : $res');
      // print('fromScreen : $fromScreen');
      String type = res['type'] != null ? res['type'] : '';
      String drId = res['DrId'] != null ? res['DrId'] : '';
      if(type != ''){
          Payload.getGlobal().setPayload('type*$type*$drId*');
          runApp(
              MaterialApp(
                title: 'Impo',
                debugShowCheckedModeBanner: false,
                builder: (context, child) =>
                    MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!),
                theme: ImpoTheme.light,
                home: SplashScreen(
                  localPass: true,
                  // index: 2,
                ),
              )
          );
      }else{
        if(res['status'] == 'OK'){
          if(!isLoadingButton.isClosed){
            isLoadingButton.sink.add(false);
          }
          if(panelController != null){
            panelController!.close();
          }
          if(fromScreen == 1){
            /// int cValue = await refreshPolar();
            /// Navigator.pushReplacement(
            ///     context,
            ///     PageTransition(
            ///         type: PageTransitionType.fade,
            ///         duration: Duration(seconds: 1),
            ///         child: EnterQuestionScreen(
            ///           expertPresenter: expertPresenter,
            ///          name: name,
            ///           currentValue: cValue,
            ///         )
            ///     )
            /// );
          }else if(fromScreen == 2){
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    duration: Duration(seconds: 1),
                    child: ReportingScreen(
                      expertPresenter: expertPresenter,
                      name: name,
                    )
                )
            );
          }else if(fromScreen == 3){
            if(!isLoadingButton.isClosed){
              isLoadingButton.sink.add(false);
            }
            chatId = res['ticketId'];
            goToChatScreen(context,expertPresenter);
          } else{
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    settings: RouteSettings(name: "/Page1"),
                    duration: Duration(seconds: 1),
                    child:  FeatureDiscovery(
                        recordStepsInSharedPreferences: true,
                        child: Home(
                          indexTab: 1,
                          register: true,
                          isChangeStatus: false,
                        )
                    )
                )
            );
          }
        }else{
          if(!isLoadingButton.isClosed){
            isLoadingButton.sink.add(false);
          }
          animations.showShakeError('مشکلی در پرداخت پیش آمد، دوباره تلاش کنید');

        }
      }

    }, onError: (err) {

    });

  }

  // Future<int> refreshPolar()async{
  //
  //   RegisterParamViewModel registerParamViewModel =  _expertModel.getRegisters();
  //
  //   Map<String,dynamic>? responseBody = await Http().sendRequest(
  //       womanUrl,
  //       // 'advice/clinic',
  //       'advice/newclinic',
  //       'GET',
  //       {
  //
  //       },
  //       registerParamViewModel.token
  //   );
  //   if(responseBody != null){
  //     // if(!isLoading.isClosed){
  //     //   isLoading.sink.add(false);
  //     // }
  //     // print(responseBody);
  //     _infoAdviceModel = InfoAdviceModel.fromJson(responseBody);
  //     createListOfValues(_infoAdviceModel.listOfValues);
  //     if(!infoAdvice.isClosed){
  //       infoAdvice.sink.add(_infoAdviceModel);
  //     }
  //
  //     return _infoAdviceModel.currentValue;
  //
  //   }else{
  //     return infoAdvice.stream.value.currentValue;
  //   }
  //
  // }

  onPressBuyPolar(PriceListModel priceListModel,animations){
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(false);
    }
    animations.isErrorShow.sink.add(false);
    selectedPolar.sink.add(priceListModel);
    panelController!.open();
  }

  payFinancial(Animations animations,int polarCount)async{
    animations.isErrorShow.sink.add(false);
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(true);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('userName');
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'financial/chargeAp/$polarCount',
        'GET',
        {

        },
        getToken()
    );
    // print(responseBody);
    if(responseBody != null){
      if(responseBody['isSuccess']){

        // await _launchURL('https://pep.shaparak.ir/payment.aspx?n=${responseBody['token']}',animations);
        await _launchURL("https://web.impo.app/financial/AsanPardakht/${responseBody['token']}/$userName");
        // print("https://web.impo.app/financial/AsanPardakht/${responseBody['token']}/$userName");
        Timer(Duration(seconds: 1),(){
          if(!isLoadingButton.isClosed){
            isLoadingButton.sink.add(false);
          }
        });
      }else{
        animations.showShakeError('مشکلی در پرداخت پیش آمد، دوباره تلاش کنید');
        if(!isLoadingButton.isClosed){
          isLoadingButton.sink.add(false);
        }

      }
    }else{
      animations.showShakeError('لطفا اتصال اینترنت خود را بررسی کنید');
      if(!isLoadingButton.isClosed){
        isLoadingButton.sink.add(false);
      }
    }
  }

  Future<bool> _launchURL(String url) async {
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   animations.showShakeError('مشکلی در پرداخت پیش آمد، دوباره تلاش کنید');
    //   if(!isLoadingButton.isClosed){
    //     isLoadingButton.sink.add(false);
    //   }
    //   throw 'Could not launch $url';
    // }
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
    return true;
  }

  deleteTicket(ticketId,context,expertPresenter,currentValue,fromMainExpert,fromActiveClini)async{
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(true);
    }
    RegisterParamViewModel register =  _expertModel.getRegisters();

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'advice/ticket/$ticketId',
        'DELETE',
        {

        },
        register.token!
    );
    print(responseBody);
    if(responseBody != null){
      if(responseBody['isValid']['valid']){
        if(!isLoadingButton.isClosed){
          isLoadingButton.sink.add(false);
        }
        yesRemoveTicketDialog(context, expertPresenter,currentValue,fromMainExpert,fromActiveClini);
      }else{
        if(!isLoadingButton.isClosed){
          isLoadingButton.sink.add(false);
        }
        showToast('امکان حذف این تیکت را ندارید', context);
      }
    }else{
      if(!isLoadingButton.isClosed){
        isLoadingButton.sink.add(false);
      }
      showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
    }
  }

  showRemoveTicketDialog(){
    Timer(Duration(milliseconds: 150),()async{
      animationControllerDialog.forward();
      if(!isShowRemoveTicketDialog.isClosed){
        isShowRemoveTicketDialog.sink.add(true);
      }
    });
  }

   yesRemoveTicketDialog(context,expertPresenter,currentValue,fromMainExpert,fromActiveClini)async{
    await animationControllerDialog.reverse();
    if(!isShowRemoveTicketDialog.isClosed){
      isShowRemoveTicketDialog.sink.add(false);
    }
    if(fromMainExpert){
      if(fromActiveClini){
        checkNet(true);
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: ActiveClinicScreen(
                  expertPresenter: expertPresenter,
                )
            )
        );
      }else{
        Navigator.pushReplacement(
            context,
            PageTransition(
                settings: RouteSettings(name: "/Page1"),
                type: PageTransitionType.fade,
                child: FeatureDiscovery(
                    recordStepsInSharedPreferences: true,
                    child: Home(
                      indexTab: 1,
                      isChangeStatus: false,
                    )
                )
            )
        );
      }
    }else{
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: ClinicQuestionList(
                expertPresenter: expertPresenter,
                currentValue: expertPresenter.infoAdvice.stream.value.currentValue.toString(),
                isAllTicket: false,
              )
          )
      );
    }
  }

  onPressCancelRemoveTicketDialog()async{
    await animationControllerDialog.reverse();
    if(!isShowRemoveTicketDialog.isClosed){
      isShowRemoveTicketDialog.sink.add(false);
    }
  }


  onPressItemFeedback(bool isPositive,int index){
    if(isPositive){
      _positiveFeedBack[index].isSelected = ! _positiveFeedBack[index].isSelected;
      if(_positiveFeedBack[index].isSelected){
        AnalyticsHelper().log(AnalyticsEvents.RatePg_AddPositiveFeedback_Item_Clk);
      }else{
        AnalyticsHelper().log(AnalyticsEvents.RatePg_RemovePositiveFeedback_Item_Clk);
      }
      if(!positiveFeedBack.isClosed){
        positiveFeedBack.sink.add(_positiveFeedBack);
      }
    }else{
      _negativeFeedBack[index].isSelected = ! _negativeFeedBack[index].isSelected;
      if(_negativeFeedBack[index].isSelected){
        AnalyticsHelper().log(AnalyticsEvents.RatePg_AddNegativeFeedback_Item_Clk);
      }else{
        AnalyticsHelper().log(AnalyticsEvents.RatePg_RemoveNegativeFeedback_Item_Clk);
      }
      if(!negativeFeedBack.isClosed){
        negativeFeedBack.sink.add(_negativeFeedBack);
      }
    }
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

  Future<bool> onWillPopRateScreen(context,expertPresenter,fromActiveClini,fromMainExpert,chatId)async{
    AnalyticsHelper().log(AnalyticsEvents.RatePg_Back_NavBar_Clk);
    if(isShowFeedbackDialog.stream.value){
      closeFeedbackDialog();
    }else{
      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: ChatScreen(
                expertPresenter: expertPresenter,
                chatId: chatId,
                fromActiveClini: fromActiveClini,
                fromMainExpert: fromMainExpert,
              )
          )
      );
    }
    return Future.value(false);
  }

  getTurnover({int pageNum = 0 , int pageSize = 10, int? state})async{
    if(state == 0){
      if(!isLoading.isClosed){
        isLoading.sink.add(true);
      }
      if(!isMoreLoading.isClosed){
        isMoreLoading.sink.add(true);
      }

      _polarHistories.clear();
      if(!polarHistories.isClosed){
        polarHistories.sink.add(_polarHistories);
      }

      counterNumPagePolarHistory = 0;
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
        'financial/turnover/$pageNum/$pageSize',
        'GET',
        {

        },
        getToken()
    );
    // print(responseBody);
    if(responseBody != null){
      // print(responseBody['totalCount']);
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
      if(!isMoreLoading.isClosed){
        isMoreLoading.sink.add(false);
      }
      if(responseBody['totalCount'] != 0){
        if(state == 0){
          totalCountPolarHistories = responseBody['totalCount'];
        }else{
          if(!isMoreLoading.isClosed){
            isMoreLoading.sink.add(false);
          }
          if(!counterMoreLoad.isClosed){
            counterMoreLoad.sink.add(1);
          }
        }
        responseBody['items'].forEach((item){
          _polarHistories.add(PolarHistoryModel.fromJson(item));
        });
        // print(_tickets[0].text);
        // print(_tickets[1].text);
        if(!polarHistories.isClosed){
          polarHistories.sink.add(_polarHistories);
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
          getTurnover(pageNum: pageNum,state: 1);
        });
      }
    }

  }

  moreLoadGetPolarHistory(){
    if(polarHistories.stream.value.length < totalCountPolarHistories){
      // if(!tryButtonError.stream.value){
      counterNumPagePolarHistory = counterNumPagePolarHistory + 1;
      // }
      getTurnover(state: 1,pageNum: counterNumPagePolarHistory);
    }
  }



  getTicketInfo(context,expertPresenter,Map body)async{
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
    print('bodyy');
    print(body);
    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'advice/ticketInfo',
        'POST',
        // loadingPay ? 'advice/noPayTicket/$ticketId' : 'advice/ticketInfo',
        // loadingPay ? 'GET' : 'POST',
        body,
        getToken()
    );
    print(responseBody);
    if(responseBody != null){
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
      if(responseBody['isValid']){
        _ticketInfo = TicketInfoAdviceModel.fromJson(responseBody);
        _ticketInfo.info.dr[0].selected = true;
        if(!ticketInfo.isClosed){
          ticketInfo.sink.add(_ticketInfo);
        }
        _selectedDoctor = _ticketInfo.info.dr[0];
        if(!selectedDoctor.isClosed){
          selectedDoctor.sink.add(_selectedDoctor);
        }
          clinicController = TextEditingController(text: responseBody['text']);
        if(!typeTicket.isClosed){
          typeTicket.sink.add(responseBody['type']);
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

  getDoctorInfo()async{
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
    if(!isMoreLoading.isClosed){
      isMoreLoading.sink.add(false);
    }

    if(_drInfoProfile != null){
      _drInfoProfile!.info.comments.list.clear();
    }

    totalCountListCommit = 0;
    counterNumPageListCommit = 0;
    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'advice/drInfo',
        'POST',
        // loadingPay ? 'advice/noPayTicket/$ticketId' : 'advice/ticketInfo',
        // loadingPay ? 'GET' : 'POST',
        {
          'id' : selectedDoctor.stream.value.id
        },
        getToken()
    );
    print(responseBody);
    if(responseBody != null){
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
      if(responseBody['isValid']){
        _drInfoProfile = DrInfoModel.fromJson(responseBody);
        _drInfoProfile!.info.selected = true;
        totalCountListCommit = _drInfoProfile!.info.comments.totalCount;

        if(!drInfoProfile.isClosed){
          drInfoProfile.sink.add(_drInfoProfile!);
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


  Future<bool> getDrComments({int pageNum = 0})async{
      if(!isMoreLoading.isClosed){
        isMoreLoading.sink.add(true);
      }

    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }
    // print(selectedDoctor.stream.value.id);
    // print(pageNum);
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'advice/drcomments/${selectedDoctor.stream.value.id}/$pageNum',
        'GET',
        {

        },
        getToken()
    );

    if(responseBody != null){

      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
      if(!isMoreLoading.isClosed){
        isMoreLoading.sink.add(false);
      }

      if(responseBody['comment']['totalCount'] != 0){

          if(!isMoreLoading.isClosed){
            isMoreLoading.sink.add(false);
          }
          if(!counterMoreLoad.isClosed){
            counterMoreLoad.sink.add(1);
          }

        responseBody['comment']['list'].forEach((item){
          _drInfoProfile!.info.comments.list.add(ListCommentsInfoModel.fromJson(item));
        });

          if(!drInfoProfile.isClosed){
            drInfoProfile.sink.add(_drInfoProfile!);
          }
      }
    }else{
        Timer(Duration(seconds: 3),(){
          getDrComments(pageNum: pageNum);
        });
    }
    return true;
  }

  Future<bool> moreLoadGetListCommit()async{
    // if(drInfoProfile.stream.value.info.comments.list.length < totalCountListCommit){

      counterNumPageListCommit = counterNumPageListCommit + 1;

      if(_drInfoProfile!.info.comments.pageMax >= counterNumPageListCommit){
        await getDrComments(pageNum: counterNumPageListCommit);
      }

      return true;
    // }

  }

  changeSelectedDoctor(int index,context){
    for(int i=0 ; i<_ticketInfo.info.dr.length ; i++){
      _ticketInfo.info.dr[i].selected = false;
    }
    _ticketInfo.info.dr[index].selected = true;
    if(!ticketInfo.isClosed){
      ticketInfo.sink.add(_ticketInfo);
    }
    _selectedDoctor = _ticketInfo.info.dr[index];
    if(!selectedDoctor.isClosed){
      selectedDoctor.sink.add(_selectedDoctor);
    }
    Navigator.pop(context);
  }

  setLoadings(){
    if(!isLoadingDiscountButton.isClosed){
      isLoadingDiscountButton.sink.add(false);
    }
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(false);
    }
  }

  nextPressClinicQuestion(context,expertPresenter,ticketId,ticketInfo,animations){
    if(clinicController.text != ''){
      AnalyticsHelper().log(AnalyticsEvents.ClinicQuestionPg_next_Btn_Clk);
      Navigator.push(
          context,
          PageTransition(
            child: ClinicPaymentScreen(
              expertPresenter: expertPresenter,
              ticketId: ticketId,
              ticketInfoAdviceModel: ticketInfo,
            ),
            type: PageTransitionType.fade,
          )
      );
    }else{
      FocusScope.of(context).requestFocus(focusNode);
      animations.showShakeError('مشکلت رو در این قسمت بنویس');
    }
  }

  applyDiscount(TicketInfoAdviceModel ticketInfoAdviceModel)async{
      if(!isLoadingDiscountButton.isClosed){
        isLoadingDiscountButton.sink.add(true);
      }
      Map<String,dynamic>? responseBody = await Http().sendRequest(
          womanUrl,
          'advice/applyDiscount',
          'POST',
          {
            'code' : discountCodeController.text,
            'DrId' : selectedDoctor.stream.value.id,
            'type' : ticketInfoAdviceModel.type,
          },
          getToken()
      );
      print(responseBody);
      if(responseBody != null){
        if(!isLoadingDiscountButton.isClosed){
          isLoadingDiscountButton.sink.add(false);
        }
        if(!validApplyDiscount.isClosed){
          validApplyDiscount.sink.add(responseBody['valid']);
        }
        if(responseBody['valid']){

          ApplyDiscountPrice.fromJson(responseBody,_ticketInfo);

          ticketInfo.sink.add(_ticketInfo);

        }else{


        }
      }else{
        if(!isLoadingDiscountButton.isClosed){
          isLoadingDiscountButton.sink.add(false);
        }

      }
  }

  dispose(){
    dialogScale.close();
    isShowDialog.close();
    questionnaire.close();
    isNet.close();
    isLoading.close();
    valueError.close();
    tryButtonError.close();
    infoAdvice.close();
    isShowDialogBackUp.close();
    ticketsList.close();
    typeTicket.close();
    textDialog.close();
    isLoadingButton.close();
    enableButton.close();
    isError.close();
    uploadFiles.close();
    controllerTextTicket.close();
    chats.close();
    // fileNames.close();
    textRate.close();
    valueRate.close();
    priceList.close();
    sendValuePercentUploadFile.close();
    selectedPolar.close();
    isMoreLoading.close();
    counterMoreLoad.close();
    descriptionShop.close();
    indexTicket.close();
    isShowRemoveTicketDialog.close();
    currentIndexTab.close();
    positiveFeedBack.close();
    negativeFeedBack.close();
    isShowFeedbackDialog.close();
    polarHistories.close();
    clinicType.close();
    clinicTypId.close();
    listOfValue.close();
    ticketInfo.close();
    selectedDoctor.close();
    drInfoProfile.close();
    isLoadingDiscountButton.close();
    validApplyDiscount.close();
    isLoadingUpload.close();
  }

  cancelUniLinkSub(){
    uniLinkSub.cancel();
  }

}

// loadQuestionnaire(){
//   _list.add(
//     QuestionnaireModel.fromJson(
//       {
//         'id' : 'csdco6+5v',
//         'validAnswer' : false,
//         'answer' : '',
//         'text' : 'آیا تا به حال عمل جراحی داشته اید؟',
//         'subAnswer' : ['دارم','ندارم'],
//         'validSupplementAnswer' : false,
//         'supplementAnswer' : '',
//         'hasSupplementAnswer' : false,
//         'type' : 0
//       }
//     ),
//   );
//   _list.add(
//     QuestionnaireModel.fromJson(
//         {
//           'id' : 'csdco6+5v',
//           'validAnswer' : false,
//           'answer' : '',
//           'text' : 'آیا تا به حال عمل جراحی داشته اید؟',
//           'subAnswer' : ['دارم','ندارم'],
//           'validSupplementAnswer' : false,
//           'supplementAnswer' : '',
//           'hasSupplementAnswer' : true,
//           'type' : 0
//         }
//     ),
//   );
//   _list.add(
//     QuestionnaireModel.fromJson(
//         {
//           'id' : 'csdco6+5v',
//           'validAnswer' : false,
//           'answer' : '',
//           'text' : 'آیا تا به حال عمل جراحی داشته اید؟',
//           'subAnswer' : ['دارم','ندارم'],
//           'validSupplementAnswer' : false,
//           'supplementAnswer' : '',
//           'hasSupplementAnswer' : false,
//           'type' : 0
//         }
//     ),
//   );
//   _list.add(
//     QuestionnaireModel.fromJson(
//         {
//           'id' : 'csdco6+5v',
//           'validAnswer' : false,
//           'answer' : '',
//           'text' : 'آیا تا به حال عمل جراحی داشته اید؟',
//           'subAnswer' : ['دارم','ندارم'],
//           'validSupplementAnswer' : false,
//           'supplementAnswer' : '',
//           'hasSupplementAnswer' : false,
//           'type' : 0
//         }
//     ),
//   );
//   _list.add(
//     QuestionnaireModel.fromJson(
//         {
//           'id' : 'csdco6+5v',
//           'validAnswer' : false,
//           'answer' : '',
//           'text' : 'آیا تا به حال عمل جراحی داشته اید؟',
//           'subAnswer' : ['دارم','ندارم'],
//           'validSupplementAnswer' : false,
//           'supplementAnswer' : '',
//           'hasSupplementAnswer' : false,
//           'type' : 0
//         }
//     ),
//   );
//   _list.add(
//     QuestionnaireModel.fromJson(
//         {
//           'id' : 'csdco6+5v',
//           'validAnswer' : false,
//           'answer' : '',
//           'text' : 'آیا تا به حال عمل جراحی داشته اید؟',
//           'subAnswer' : ['دارم','ندارم'],
//           'validSupplementAnswer' : false,
//           'supplementAnswer' : '',
//           'hasSupplementAnswer' : false,
//           'type' : 0
//         }
//     ),
//   );
//   _list.add(
//     QuestionnaireModel.fromJson(
//         {
//           'id' : 'csdco6+5v',
//           'validAnswer' : false,
//           'answer' : '',
//           'text' : 'آیا تا به حال عمل جراحی داشته اید؟',
//           'subAnswer' : ['دارم','ندارم'],
//           'validSupplementAnswer' : false,
//           'supplementAnswer' : '',
//           'hasSupplementAnswer' : false,
//           'type' : 0
//         }
//     ),
//   );
//   _list.add(
//     QuestionnaireModel.fromJson(
//         {
//           'id' : 'csdco6+5v',
//           'validAnswer' : false,
//           'answer' : '',
//           'text' : 'آیا تا به حال عمل جراحی داشته اید؟',
//           'subAnswer' : ['دارم','ندارم'],
//           'validSupplementAnswer' : false,
//           'supplementAnswer' : '',
//           'hasSupplementAnswer' : false,
//           'type' : 0
//         }
//     ),
//   );
//   _list.add(
//     QuestionnaireModel.fromJson(
//         {
//           'id' : 'csdco6+5v',
//           'validAnswer' : false,
//           'answer' : '',
//           'text' : 'آیا تا به حال عمل جراحی داشته اید؟',
//           'subAnswer' : ['دارم','ندارم'],
//           'validSupplementAnswer' : false,
//           'supplementAnswer' : '',
//           'hasSupplementAnswer' : false,
//           'type' : 0
//         }
//     ),
//   );
//   _list.add(
//     QuestionnaireModel.fromJson(
//         {
//           'id' : 'csdco6+5v',
//           'validAnswer' : false,
//           'answer' : '',
//           'text' : ' آیا تا به حال عمل جراحی داشته اید؟آیا تا به حال عمل جراحی داشته اید؟',
//           'subAnswer' : ['دارم','ندارم'],
//           'validSupplementAnswer' : false,
//           'supplementAnswer' : '',
//           'hasSupplementAnswer' : false,
//           'type' : 0
//         }
//     ),
//   );
//   if(!questionnaire.isClosed){
//     questionnaire.sink.add(_list);
//   }
// }