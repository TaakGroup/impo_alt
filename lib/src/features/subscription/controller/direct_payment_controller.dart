import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/constans/api_paths.dart';
import 'package:impo/src/core/app/constans/messages.dart';
import 'package:impo/src/core/app/model/record_model.dart';
import 'package:impo/src/core/app/utiles/classes/service_controller.dart';
import 'package:impo/src/core/app/utiles/helper/box_helpers.dart';
import 'package:impo/src/features/subscription/controller/subscription_controller.dart';
import 'package:impo/src/features/subscription/data/models/subscription_model.dart';
import 'package:social/core/app/utils/mixin/handle_failure_mixin.dart';
import '../../../core/app/model/valid_model.dart';
import '../../../core/app/packages/url_launcher/implementation/url_launcher.dart';
import '../../../core/app/view/widgets/toast.dart';
import '../data/models/direct_pay_model.dart';


class DirectPayController extends ServiceController<DirectPayModel> with HandleFailureMixin {
  DirectPayController() : super(path: ApiPaths.directSubscriptions, model: DirectPayModel());

  static DirectPayController get to => Get.find();

  payment(SubscriptionPackagesModel package){
    create(model: JsonModel(
      {
        'packageId' : package.id,
        'value' : package.totalPay,
        'discount' : SubscriptionController.to.codeController.text,
        'isWeb' : false
      }
    ));
  }

  @override
  onSuccess(DirectPayModel result) async {
    if (result.isSuccess) {
      await UrlLauncher().launchWeb('https://web.impo.app/financial/AsanPardakht/${result.token}/${BoxHelper.user}');
    } else {
      toast(message: Messages.paymentNotValid);
    }
    return super.onSuccess(result);
  }
}

class FreePayController extends ServiceController<ValidModel> with HandleFailureMixin{
  FreePayController() : super(path: ApiPaths.freeSubscription, model: ValidModel());

  static FreePayController get to => Get.find();

  payment(SubscriptionPackagesModel package) => find(package.id);

  @override
  onSuccess(ValidModel result) {
    if (result.valid == true) {
      // SplashController.restart();
    }

    return super.onSuccess(result);
  }
}

// class OrganizationPayController extends ServiceController<ValidModel> {
//   final TextEditingController codeController = TextEditingController();
//
//   OrganizationPayController() : super(path: ApiPaths.organizationPay, model: ValidModel());
//
//   static OrganizationPayController get to => Get.find();
//
//   @override
//   onInit() {
//     change(null, status: RxStatus.success());
//     codeController.clear();
//
//     super.onInit();
//   }
//
//   payment() {
//     if (codeController.text.isNotEmpty) {
//       create(model: JsonModel({'code': codeController.text}));
//     } else {
//       toast(message: 'لطفا فیلد ورودی را پر کنید.');
//     }
//   }
//
//   @override
//   onSuccess(ValidModel result) {
//     if (result.valid == true) {
//       SplashController.restart();
//     } else {
//       toast(message: result.message!);
//     }
//
//     return super.onSuccess(result);
//   }
// }