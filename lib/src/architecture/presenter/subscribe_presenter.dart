import 'dart:async';
import 'package:flutter/material.dart';
import 'package:impo/main.dart';
// import 'package:flutter_poolakey/flutter_poolakey.dart';
import 'package:impo/src/architecture/model/subscribe_model.dart';
import 'package:impo/src/architecture/view/subscribe_view.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/core/app/Utiles/helper/version_to_int.dart';
import 'package:impo/src/core/app/view/widgets/snackbar/custom_snack_bar.dart';
import 'package:impo/src/core/app/view/themes/theme.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:myket_iap/myket_iap.dart';
import 'package:myket_iap/util/iab_result.dart';
import 'package:myket_iap/util/purchase.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/http.dart';
import '../../firebase_analytics_helper.dart';
import '../../models/register/register_parameters_model.dart';
import '../../models/subscribe/subscribes_get_model.dart';
import '../../models/subscribe/subscribtions_packages_model.dart';
import '../../screens/splash_screen.dart';
import '../../singleton/payload.dart';

class SubscribePresenter{

  late SubscribeView _subscribeView;
  SubscribeModel _subscribeModel =  SubscribeModel();

  SubscribePresenter(SubscribeView view){

    this._subscribeView = view;

  }

  late PanelController panelController;
  late TextEditingController subOrganizationalTextController;
  late TextEditingController tokenStoreController;
  late TextEditingController discountController;

  final isLoading = BehaviorSubject<bool>.seeded(false);
  final isLoadingButton = BehaviorSubject<bool>.seeded(false);
  final isLoadingOrganizationButton = BehaviorSubject<bool>.seeded(false);
  final tryButtonError = BehaviorSubject<bool>.seeded(false);
  final valueError = BehaviorSubject<String>.seeded('');
  final subscribe = BehaviorSubject<SubscribesGetModel>();
  final textList = BehaviorSubject<List<String>>.seeded([]);
  final isLoadingCheckCodeButton = BehaviorSubject<bool>.seeded(false);
  final subscribtionsPackagesSelected = BehaviorSubject<SubscribtionsPackagesModel>();


  Stream<bool> get isLoadingObserve => isLoading.stream;
  Stream<bool> get isLoadingButtonObserve => isLoadingButton.stream;
  Stream<bool> get isLoadingOrganizationButtonObserve => isLoadingOrganizationButton.stream;
  Stream<bool> get tryButtonErrorObserve => tryButtonError.stream;
  Stream<String> get valueErrorObserve => valueError.stream;
  Stream<SubscribesGetModel> get subscribeObserve => subscribe.stream;
  Stream<List<String>> get textListObserve => textList.stream;
  Stream<bool> get isLoadingCheckCodeButtonObserve => isLoadingCheckCodeButton.stream;
  Stream<SubscribtionsPackagesModel> get subscribtionsPackagesSelectedObserve => subscribtionsPackagesSelected.stream;

  late StreamSubscription uniLinkSub;


  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


  String getName(){
    return _subscribeModel.registerInfo.register.name!;
  }

  Future<RegisterParamViewModel> getRegister()async{
    RegisterParamViewModel register =  _subscribeModel.getRegisters();
    return register;
  }


  getSubscribtions(bool discount,BuildContext context)async{
    RegisterParamViewModel register = await getRegister();
    if(!discount || discountController.text != ''){

      if(!isLoading.isClosed){
        isLoading.sink.add(true);
      }
      if(!tryButtonError.isClosed){
        tryButtonError.sink.add(false);
      }
      Map<String,dynamic>? responseBody = await Http().sendRequest(
          womanUrl,
          'info/subscribtions_v5',
          // 'info/subscribtions',
          'POST',
          {
            'code' : discountController.text
          },
          register.token!
      );
      print(responseBody);
      if(responseBody != null){
        if(discount){
          showToast(responseBody['discountCodeHelper'], scaffoldKey.currentContext);
        }
        if(responseBody['isValid']){
          if(!isLoading.isClosed){
            isLoading.sink.add(false);
          }
          subscribe.value = SubscribesGetModel.fromJson(responseBody);
          if(!discount){
            if(subscribe.value.packages.length != 0){
              subscribe.value.packages[0].selected = true;
              if(!subscribtionsPackagesSelected.isClosed){
                subscribtionsPackagesSelected.sink.add(subscribe.value.packages[0]);
              }
            }
            discountController.clear();
          }else{
            for(int i=0 ; i<subscribe.value.packages.length ; i++){
              if(subscribe.value.packages[i].viewId == subscribtionsPackagesSelected.value.viewId){
                subscribe.value.packages[i].selected = true;
                if(!subscribtionsPackagesSelected.isClosed){
                  subscribtionsPackagesSelected.sink.add(subscribe.value.packages[i]);
                }

              }
            }
          }
          // createTextList(subscribe.stream.value.text3);
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
    }else{
      if(discount && discountController.text == ''){
        showToast('کد تخفیف را وارد کنید',scaffoldKey.currentContext);
      }
    }
  }

  createTextList(String text3){
    textList.value =  text3.split('\n');

  }

  pressFreeSub(BuildContext context,String id)async{
    RegisterParamViewModel register = await getRegister();
    AnalyticsHelper().log(
        AnalyticsEvents.ChooseSubscriptionPg_FreeSub_Item_Clk,
       parameters: {
          'id' : id
       }
    );
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(true);
    }
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'info/subscribtions/free/$id',
        'GET',
        {},
        register.token!
    );

    print(responseBody);
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(false);
    }
    if(responseBody != null){
      if(responseBody['valid']){
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child:  SplashScreen(
                  localPass: false,
                  index: 4,
                )
            )
        );
      }else{
        showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
      }
    }else{
      showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
    }

  }

  pressPackagesSub(BuildContext context,String id,int totalPay)async{
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(true);
    }
    RegisterParamViewModel register = await getRegister();
    // Map<String,dynamic> responseBody = await Http().sendRequest(
    //     womanUrl,
    //     'financial/subscribtion/$id/$value',
    //     'GET',
    //     {},
    //     await getToken()
    // );
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'financial/subscribtiondiscount',
        'POST',
        {
          'packageId' : id,
          'value' : totalPay,
          'discount' : discountController.text,
          'isWeb' : false
        },
        register.token!
    );

    print(responseBody);
    if(responseBody != null){
      if(responseBody['isSuccess']){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userName = prefs.getString('userName');
        await _launchURL("https://web.impo.app/financial/AsanPardakht/${responseBody['token']}/$userName");
        Timer(Duration(seconds: 1),(){
          if(!isLoadingButton.isClosed){
            isLoadingButton.sink.add(false);
          }
        });
      }else{
        showToast(responseBody['message'], context);
      }
    }else{
      showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
    }

  }

  Future<Null> initUniLinks(context) async {
    uniLinkSub = uriLinkStream.listen((Uri? uri)async{

      Map res = uri!.queryParameters;
      // print(res);
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
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child:  SplashScreen(
                    localPass: false,
                    index: 4,
                  )
              )
          );
        }else{
          if(!isLoadingButton.isClosed){
            isLoadingButton.sink.add(false);
          }
          showToast('مشکلی در پرداخت پیش آمد، دوباره تلاش کنید',context);

        }
      }
    }, onError: (err) {

    });

  }

  onPressItem(int index){
    for(int i=0 ; i < subscribe.value.packages.length ; i++){
      subscribe.value.packages[i].selected = false;
    }
    subscribe.value.packages[index].selected = true;

    subscribe.sink.add(subscribe.value);
    if(!subscribtionsPackagesSelected.isClosed){
      subscribtionsPackagesSelected.sink.add(subscribe.value.packages[index]);
    }
  }

  Future<bool> isCafeBazar()async{
    try{
      AppInfo app = await InstalledApps.getAppInfo('com.farsitel.bazaar');
      if(getExtendedVersionNumber(app.versionName) >= getExtendedVersionNumber('19.0.0')){
        return true;
      }else{
        return false;
      }
    }catch(e){
      print('Cafe Bazar not installed');
      return false;
    }
  }


  // payCafeBazar(String productId,context)async{
  //   print(productId);
  //   // print('payCafeBazar');
  //   try{
  //     PurchaseInfo purchaseInfo = await FlutterPoolakey.purchase(productId, payload: 'DEVELOPER_PAYLOAD');
  //     print(purchaseInfo);
  //     await consumeCafeBazar(purchaseInfo,context);
  //   }catch(e){
  //     // pressPackagesSub(context,subscribtionsPackagesSelected.stream.value.id,subscribtionsPackagesSelected.stream.value.totalPay);
  //     if(!isLoadingButton.isClosed){
  //       isLoadingButton.sink.add(false);
  //     }
  //     showToast('ارتباط با کافه بازار برقرار نشد، لطفا مجددا تلاش کنید', context);
  //     print(e);
  //   }
  // }
  //
  // consumeCafeBazar(PurchaseInfo purchaseInfo,context)async{
  //   bool result = await FlutterPoolakey.consume(purchaseInfo.purchaseToken);
  //   print(result);
  //   if(result){
  //     await acceptBazar(purchaseInfo, context);
  //   }else{
  //     if(!isLoadingButton.isClosed){
  //       isLoadingButton.sink.add(false);
  //     }
  //     showToast('ارتباط با کافه بازار برقرار نشد، لطفا مجددا تلاش کنید', context);
  //   }
  // }
  //
  // acceptBazar(PurchaseInfo purchaseInfo,context)async{
  //   // print('acceptCafeBazar');
  //   if(!isLoadingButton.isClosed){
  //     isLoadingButton.sink.add(true);
  //   }
  //   RegisterParamViewModel register =  _subscribeModel.getRegisters();
  //   Map<String,dynamic>? responseBody = await Http().sendRequest(
  //       womanUrl,
  //       'financial/acceptBazaar',
  //       'POST',
  //       {
  //         'packageName' : purchaseInfo.packageName,
  //         'productId' : purchaseInfo.productId,
  //         'purchaseToken' : purchaseInfo.purchaseToken,
  //         'payType' : 1
  //       },
  //       /// payType ==>  1 = cafeBazar  //  2 = myket
  //       register.token!
  //   );
  //   print(responseBody);
  //   if(responseBody != null){
  //     if(responseBody['valid']){
  //       if(!isLoadingButton.isClosed){
  //         isLoadingButton.sink.add(false);
  //       }
  //       Navigator.pushReplacement(
  //           context,
  //           PageTransition(
  //               type: PageTransitionType.fade,
  //               child:  SplashScreen(
  //                 localPass: false,
  //                 index: 4,
  //               )
  //           )
  //       );
  //     }else{
  //       if(!isLoadingButton.isClosed){
  //         isLoadingButton.sink.add(false);
  //       }
  //       showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید',context);
  //     }
  //   }else{
  //     if(!isLoadingButton.isClosed){
  //       isLoadingButton.sink.add(false);
  //     }
  //     showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید',context);
  //   }
  // }
  ////////////////////////////////////////////////////////////////////////////////////////////


  payMyket(String productId,context)async{
    // print('payMykey');
    // print(productId);
    try{
      var result = await MyketIAP.launchPurchaseFlow(sku: productId, payload:"DEVELOPER_PAYLOAD");
      print(result);
      Purchase purchase = result[MyketIAP.PURCHASE];
      IabResult purchaseResult = result[MyketIAP.RESULT];
      print('purchaseResult.mResponse : ${purchaseResult.mResponse}');
      if(purchaseResult.mResponse == 0){
        consumeCafeMyket(purchase, context);
      }else{
        if(!isLoadingButton.isClosed){
          isLoadingButton.sink.add(false);
        }
        showToast('ارتباط با مایکت برقرار نشد، لطفا مجددا تلاش کنید', context);
      }
    }catch(e){
      if(!isLoadingButton.isClosed){
        isLoadingButton.sink.add(false);
      }
      showToast('ارتباط با مایکت برقرار نشد، لطفا مجددا تلاش کنید', context);
      print(e);
    }
  }

  consumeCafeMyket(Purchase purchase,context)async{
    // print('consumeCafeMyket');
    var result = await MyketIAP.consume(purchase: purchase);
    print(result);
    IabResult purchaseResult = result[MyketIAP.RESULT];
    Purchase _purchase = result[MyketIAP.PURCHASE];
    if(purchaseResult.mResponse == 0){
      await acceptMyket(_purchase, context);
    }else{
      if(!isLoadingButton.isClosed){
        isLoadingButton.sink.add(false);
      }
      showToast('ارتباط با مایکت برقرار نشد، لطفا مجددا تلاش کنید', context);
    }
  }

  acceptMyket(Purchase purchase,context)async{
    // print('acceptMyket');
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(true);
    }
    RegisterParamViewModel register =  _subscribeModel.getRegisters();
    Map<String,dynamic> responseBody = await Http().sendRequest(
        womanUrl,
        'financial/acceptBazaar',
        'POST',
        {
          'packageName' : purchase.mPackageName,
          'productId' : purchase.mSku,
          'purchaseToken' : purchase.mToken,
          'payType' : 2
        },
        /// payType ==>  1 = cafeBazar  //  2 = myket
        register.token!
    );
    print(responseBody);
    if(responseBody != null){
      if(responseBody['valid']){
        if(!isLoadingButton.isClosed){
          isLoadingButton.sink.add(false);
        }
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child:  SplashScreen(
                  localPass: false,
                  index: 4,
                )
            )
        );
      }else{
        if(!isLoadingButton.isClosed){
          isLoadingButton.sink.add(false);
        }
        showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید',context);
      }
    }else{
      if(!isLoadingButton.isClosed){
        isLoadingButton.sink.add(false);
      }
      showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید',context);
    }
  }

  showMyBottomSheet(context,SubscribesGetModel subscribesGetModel){
    panelController.open();
  }

  acceptOrganization(Animations animations,context)async{
    animations.isErrorShow.sink.add(false);
    if(subOrganizationalTextController.text.isEmpty){
      animations.showShakeError('لطفا فیلد ورودی را پر کنید');
    }else{
      if(!isLoadingOrganizationButton.isClosed){
        isLoadingOrganizationButton.sink.add(true);
      }
      RegisterParamViewModel register =  _subscribeModel.getRegisters();
      Map<String,dynamic>? responseBody = await Http().sendRequest(
          womanUrl,
          'info/organization',
          'POST',
          {
            'code' : subOrganizationalTextController.text,
          },
          register.token!
      );
      if(!isLoadingOrganizationButton.isClosed){
        isLoadingOrganizationButton.sink.add(false);
      }
      if(responseBody != null){
        if(responseBody['valid']){
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child:  SplashScreen(
                    localPass: false,
                    index: 4,
                  )
              )
          );
        }else{
          animations.showShakeError(responseBody['message']);
        }
      }else{
        animations.showShakeError('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
      }
    }
  }


  checkCode(Animations animations,context)async{
    animations.isErrorShow.sink.add(false);
    if(tokenStoreController.text.isEmpty){
      animations.showShakeError('لطفا فیلد ورودی را پر کنید');
    }else{
      if(!isLoadingCheckCodeButton.isClosed){
        isLoadingCheckCodeButton.sink.add(true);
      }
      print(tokenStoreController.text);
      RegisterParamViewModel register =  _subscribeModel.getRegisters();
      Map<String,dynamic>? responseBody = await Http().sendRequest(
          womanUrl,
          'info/checkCode',
          'POST',
          {
            'code' : tokenStoreController.text,
            'payType' : typeStore
          },
          register.token!
      );
      if(!isLoadingCheckCodeButton.isClosed){
        isLoadingCheckCodeButton.sink.add(false);
      }
      print(responseBody);
      if(responseBody != null){
        if(responseBody['valid']){
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child:  SplashScreen(
                    localPass: false,
                    index: 4,
                  )
              )
          );
        }else{
          animations.showShakeError('توکن وارد شده اشتباه است');
        }
      }else{
        animations.showShakeError('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
      }
    }
  }

  Future<bool> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication)) throw 'Could not launch $url';
    return true;
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
    subscribe.close();
    textList.close();
    isLoadingButton.close();
    isLoadingOrganizationButton.close();
    isLoadingCheckCodeButton.close();
    subscribtionsPackagesSelected.close();
  }

  cancelUniLinkSub(){
    uniLinkSub.cancel();
  }

}