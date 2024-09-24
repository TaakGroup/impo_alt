
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:impo/src/architecture/model/partner_model.dart';
import 'package:impo/src/architecture/presenter/dashboard_presenter.dart';
import 'package:impo/src/core/app/view/widgets/snackbar/custom_snack_bar.dart';
import 'package:impo/src/data/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:impo/src/architecture/view/partner_view.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/data/messages/generate_dashboard_notify_and_messages.dart';
import 'package:impo/src/models/partnerBioRhythm/partner_biorhythm_view_model.dart';
import 'package:impo/src/models/partner/partner_model.dart' as pb;
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/home/tabs/profile/partner/partner_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../packages/featureDiscovery/src/foundation/feature_discovery.dart';
import '../../models/partner/partner_code_model.dart';
import '../../screens/home/home.dart';


class PartnerPresenter{

  late PartnerView _partnerView;
  late TextEditingController distanceTypeController;

  PartnerModel partnerModel =  PartnerModel();

  PartnerPresenter(PartnerView view){

    this._partnerView = view;

  }

  late AnimationController animationControllerDialog;
  late PanelController partnerCodeSharePanelController;

  final isLoading = BehaviorSubject<bool>.seeded(false);
  final tryButtonError = BehaviorSubject<bool>.seeded(false);
  final valueError = BehaviorSubject<String>.seeded('');
  final partnerDetail = BehaviorSubject<pb.PartnerViewModel>();
  final isShowExitDialog = BehaviorSubject<bool>.seeded(false);
  final dialogScale = BehaviorSubject<double>.seeded(0.0);
  final isLoadingButton = BehaviorSubject<bool>.seeded(false);
    final partnerCode = BehaviorSubject<PartnerCodeModel>();
    final isLoadingRefreshIcon = BehaviorSubject<bool>.seeded(false);
    final codeOrPhoneOrEmail = BehaviorSubject<String>.seeded('');


  Stream<bool> get isLoadingObserve => isLoading.stream;
  Stream<bool> get tryButtonErrorObserve => tryButtonError.stream;
  Stream<String> get valueErrorObserve => valueError.stream;
  Stream<pb.PartnerViewModel> get partnerDetailObserve => partnerDetail.stream;
  Stream<bool> get isShowExitDialogObserve => isShowExitDialog.stream;
  Stream<double> get dialogScaleObserve => dialogScale.stream;
  Stream<bool> get isLoadingButtonObserve => isLoadingButton.stream;
  Stream<PartnerCodeModel> get partnerCodeObserve => partnerCode.stream;
  Stream<bool> get isLoadingRefreshIconObserve => isLoadingRefreshIcon.stream;
  Stream<String> get codeOrPhoneOrEmailObserve => codeOrPhoneOrEmail.stream;

  late pb.PartnerViewModel _partnerGetModel;
  // bool isExitScreen = false;
  // Timer timer;

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



  onPressShowDialog(){
    Timer(Duration(milliseconds: 50),()async{
      animationControllerDialog.forward();
      if(!isShowExitDialog.isClosed){
        isShowExitDialog.sink.add(true);
      }
    });

  }

  acceptDialog()async{
    await animationControllerDialog.reverse();
    if(!isShowExitDialog.isClosed){
      isShowExitDialog.sink.add(false);
    }
  }

  cancelDialog()async{
    await animationControllerDialog.reverse();
    if(!isShowExitDialog.isClosed){
      isShowExitDialog.sink.add(false);
    }
  }

  String getRegisters(){
    RegisterParamViewModel register =  partnerModel.getRegisters();
    return register.nationality!;
  }


  /// setBackup()async{
  ///   await AutoBackup().setCycleInfo();
  ///   await AutoBackup().setGeneralInfo();
  ///   await AutoBackup().setCycleCalender();
  ///   await AutoBackup().setCheckList();
  ///   getPair();
  /// }

  getPair(context)async{
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }
    // String nationality =  getRegisters();
    RegisterParamViewModel register =  partnerModel.getRegisters();
    SharedPreferences prefs = await SharedPreferences.getInstance();

     bool? womansubscribtion = prefs.getBool('womansubscribtion');
    print(register.token);
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'info/pairv1',
        'GET',
        {

        },
        register.token!
    );
    print(responseBody);
    if(responseBody != null){
      if(womansubscribtion!){
        await updateLocalNotificationAndDashBoardMessages();
      }
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
      _partnerGetModel = pb.PartnerViewModel.fromJson(
          {
            'isPair'  : !responseBody['validToken'],
            'token' : responseBody['token'],
            'time' : responseBody['time'],
            'manName' : responseBody['manName'],
            'birtDate' : responseBody['birtDate'],
            'createTime' : responseBody['createTime'],
            'distanceType' : responseBody['distanceType'],
            'text' : responseBody['text'],
            'shareText' : responseBody['shareText'],
            'downloadText' : responseBody['downloadText'],
            'directDownloadLink' : responseBody['directDownloadLink'],
            'googleDownloadLink' : responseBody['googleDownloadLink']
          }
      );
      if(!partnerDetail.isClosed){
        partnerDetail.sink.add(_partnerGetModel);
      }
      var partnerInfo = locator<pb.PartnerModel>();
      partnerInfo.addPartner(
          {
            'isPair'  : !responseBody['validToken'],
            'token' : responseBody['token'],
            'time' : responseBody['time'],
            'manName' : responseBody['manName'],
            'birtDate' : responseBody['birtDate'],
            'createTime' : responseBody['createTime'],
            'distanceType' : responseBody['distanceType'],
            'text' : responseBody['text'],
            'shareText' : responseBody['shareText'],
            'downloadText' : responseBody['downloadText'],
            'directDownloadLink' : responseBody['directDownloadLink'],
            'googleDownloadLink' : responseBody['googleDownloadLink']
          }
      );
      setIsPair(!responseBody['validToken']);
      distanceTypeController =  TextEditingController(text: _partnerGetModel.distanceType == 0 ? 'نزدیک به هم' : 'دور از هم');

      if(!_partnerGetModel.isPair){
        partnerCodeRequest(false,context);
        //  timer =  Timer(Duration(minutes:_partnerGetModel.time),(){
        //     getPair();
        // });
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

    // print(responseBody);

  }

  setIsPair(bool value)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('pair', value);
  }

  updateLocalNotificationAndDashBoardMessages()async{
    /// await partnerModel.removeTable('Partner');
    /// await partnerModel.insertToLocal(
    ///     {
    ///       'isPair'  :  !validToken ? 1 : 0,
    ///       'manName' :  manName,
    ///       'birtDate' : birtDate,
    ///       'createTime' : createTime,
    ///       'distanceType' : distanceType
    ///     },
    ///     'Partner'
    /// );
    /// await partnerModel.removeTable('SugMessages');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? womansubscribtion = prefs.getBool('womansubscribtion');
    if(womansubscribtion!){
      bottomMessageDashboard.clear();
      await GenerateDashboardAndNotifyMessages().checkForNotificationMessage();
    }
  }

  partnerCodeRequest(bool isRefreshCode,context)async{
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
    RegisterParamViewModel register =  partnerModel.getRegisters();
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'partner/code',
        isRefreshCode ? 'PUT': 'GET',
        {

        },
        register.token!
    );
    print(responseBody);
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
      if(!partnerCode.isClosed){
        partnerCode.sink.add(PartnerCodeModel.fromJson(responseBody));
      }
    }else{
      if(isRefreshCode){
        if(!isLoadingRefreshIcon.isClosed){
          isLoadingRefreshIcon.sink.add(false);
        }
        showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
      }else{
        if(!tryButtonError.isClosed){
          tryButtonError.sink.add(true);
        }
        valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
      }
    }

  }

  onChangedInputCode(String value){
    if(!codeOrPhoneOrEmail.isClosed){
      codeOrPhoneOrEmail.sink.add(value);
    }
  }

  createPartner(context)async{
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(true);
    }
    RegisterParamViewModel register =  partnerModel.getRegisters();
    print(codeOrPhoneOrEmail.stream.value);
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'partner/create',
        'POST',
        {
          'code' : codeOrPhoneOrEmail.stream.value
        },
        register.token!
    );
    print(responseBody);
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(false);
    }
    if(responseBody != null){
      if(responseBody['valid']){
        // showToast('درخواست شما با موفقیت ارسال شد', context,grv: 1);
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
                      isShowSnackBar: true,
                    )
                )
            )
        );
      }else{
        showToast('شماره / ایمیلی که وارد کردی مشکل داره. لطفا یک شماره یا ایمیل دیگه رو وارد کن', context);
      }
    }else{
        showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
    }

  }

  //
  // cancelTimer(){
  //   if(timer != null){
  //     timer.cancel();
  //     print('CANCEL');
  //   }
  // }

   unPair(context)async{
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(true);
    }

    RegisterParamViewModel register =  partnerModel.getRegisters();
    print(register.token);
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'info/unPair',
        'POST',
        {

        },
        register.token!
    );
    print(responseBody);
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(false);
    }
    if(responseBody != null){
      if(responseBody['valid']){
        await updateLocalNotificationAndDashBoardMessages();
        acceptDialog();
        getPair(context);
        viewPartnerBioRhythms.clear();
        partnerAllRandomMessages.clear();
      }else{
        showToast('!! شما امکان حذف همدل خود را ندارید', context);
        if(!isLoadingButton.isClosed){
          isLoadingButton.sink.add(false);
        }
      }
    }else{
       showToast('لطفا اتصال به اینترنت خود را بررسی کنید', context);
      if(!isLoadingButton.isClosed){
        isLoadingButton.sink.add(false);
      }
    }
  }
  showToast(String message,context){
      // Fluttertoast.showToast(msg:message,toastLength: Toast.LENGTH_LONG,gravity:grv);
    CustomSnackBar.show(context, message);
  }

  changeDistanceType(int distanceType,context)async{
    print(distanceType);
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(true);
    }

    RegisterParamViewModel register =  partnerModel.getRegisters();
    print(register.token);
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'info/distanceType',
        'POST',
        {
          'type' : distanceType
        },
        register.token!
    );
    print(responseBody);

    if(responseBody != null){
      if(responseBody['valid']){
        await updateLocalNotificationAndDashBoardMessages();
        if(!isLoadingButton.isClosed){
          isLoadingButton.sink.add(false);
        }
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child:  PartnerScreen()
          )
        );

      }else{
        showToast('!! شما امکان ویراش نوع رابطه را ندارید', context);
        if(!isLoadingButton.isClosed){
          isLoadingButton.sink.add(false);
        }
      }
    }else{
      showToast('لطفا اتصال به اینترنت خود را بررسی کنید', context);
      if(!isLoadingButton.isClosed){
        isLoadingButton.sink.add(false);
      }
    }

  }


  dispose(){
    isLoading.close();
    tryButtonError.close();
    valueError.close();
    partnerDetail.close();
    isShowExitDialog.close();
    dialogScale.close();
    isLoadingButton.close();
    partnerCode.close();
    isLoadingRefreshIcon.close();
    codeOrPhoneOrEmail.close();
  }

}