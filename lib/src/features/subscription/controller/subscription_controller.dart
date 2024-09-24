
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:impo/src/core/app/model/record_model.dart';
import 'package:impo/src/features/subscription/data/models/subscription_model.dart';
import 'package:taakitecture/taakitecture.dart';
import 'package:dartz/dartz.dart';
import 'direct_payment_controller.dart';

class SubscriptionController extends BaseController<SubscriptionModel>{
  SubscriptionController(super.remoteRepository);
  static SubscriptionController get to => Get.find();

  final RxBool isDiscountExpand = false.obs;
  final TextEditingController codeController = TextEditingController();
  late RxList<SubscriptionPackagesModel> packages = <SubscriptionPackagesModel>[].obs;
  RxBool paymentLoading = false.obs;
  RxString subsId = ''.obs;

  @override
  void onInit() {
    change(null,status: RxStatus.success());
    getSubscription();
    super.onInit();
  }

  getSubscription() => create(model: JsonModel({"code" : ''}));

  @override
  onSuccess(SubscriptionModel result) {
    if (subsId.value.isEmpty) {
      subsId.value = result.packages.first.id;
    }
    addTwoPackages(result.packages);
    return super.onSuccess(result);
  }

  addTwoPackages(List<SubscriptionPackagesModel> allPackages){
    if(allPackages.length >2){
      for(int i=0 ; i<2 ; i++){
        packages.add(allPackages[i]);
      }
    }else{
      packages.addAll(allPackages);
    }
  }

  moreLoad(){
    for(int i=2 ; i<value!.packages.length ; i++){
      packages.add(value!.packages[i]);
    }
  }

  onPayment() async {
    paymentLoading.value = true;
    final package = value!.packages.firstWhere((element) => element.id == subsId.value);
    // Either result;
    if (package.isFree) {
         await FreePayController.to.payment(package);
         paymentLoading.value = false;
    }else{
         await DirectPayController.to.payment(package);
         paymentLoading.value = false;
    }
    // result.fold(
    //     ifLeft,
    //     (_){}
    // );
    // } else if (AppSetting.market == MarketType.direct) {
    //   await DirectPayController.to.payment(package);
    // } else {
    //   await MarketPaymentController.to.payment(package);
    // }
  }

  void onPackageSelect(String id) => subsId.value = id;

  void applyCode() => create(model: JsonModel({'code': codeController.text}));

  void onExpansionChanged(bool value) => isDiscountExpand.value =value;

}