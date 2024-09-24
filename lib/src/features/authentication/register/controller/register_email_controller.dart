
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/constans/app_routes.dart';
import 'package:impo/src/core/app/utiles/classes/validation.dart';
import 'package:impo/src/core/app/view/widgets/toast.dart';
import 'package:impo/src/features/authentication/register/controller/i_register_controller.dart';

class RegisterEmailController extends IRegisterController {
  RegisterEmailController(super.remoteRepository, super.authRemoteRepository);
  static RegisterEmailController get to => Get.find();


  onNextStepPressed() {
    change(null,status: RxStatus.loading());
    String? error = emailValidation(userIdentityTextEditingController.text);
    if (error == null){
      statusIdentity();
    }else{
      change(null,status: RxStatus.empty());
      toast(message: error,snackPosition: SnackPosition.TOP);
    }
  }


  String? emailValidation(String? value) {
    return Validation.emailValidator(value);
  }


  @override
  String get dialogText => 'دوست عزیز قبلا با این ایمیل حساب کاربری ایجاد شده است.لطفا پس از تایید رمز عبور خود را وارد کنید.';

  goToNumberPage(context){
    FocusScope.of(context).unfocus();
    Get.toNamed(AppRoutes.number);
  }

}