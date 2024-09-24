import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/constans/app_routes.dart';
import 'package:impo/src/core/app/constans/messages.dart';
import 'package:impo/src/core/app/utiles/classes/validation.dart';
import 'package:impo/src/core/app/view/widgets/toast.dart';
import 'i_register_controller.dart';


class RegisterNumberController extends IRegisterController{
  RegisterNumberController(super.remoteRepository, super.authRemoteRepository);
  static RegisterNumberController get to => Get.find();
  bool autofocus = false;

  onNextStepPressed() {
    change(null,status: RxStatus.loading());
    String? error = phoneNumberValidation(userIdentityTextEditingController.text);
    if (error == null){
      statusIdentity();
    }else{
      change(null,status: RxStatus.empty());
      toast(message: error,snackPosition: SnackPosition.TOP);
    }
  }


  String? phoneNumberValidation(String? value) {
    return Validation.phoneNumberValidator(
      value,
      onNotValidPrefix: () => Messages.phoneNumberErrorNotValidPrefix,
      onEmpty: () => Messages.phoneNumberErrorEmpty,
      onNotValidLength: () => Messages.phoneNumberErrorNotValidLength,
    );
  }


  @override
  String get dialogText => 'دوست عزیز قبلا با این شماره تلفن حساب کاربری ایجاد شده است.لطفا پس از تایید رمز عبور خود را وارد کنید.';

  // @override
  // onLogin() {
  //   print('okk');
  // }

   goToEmailPage(context){
     if(!autofocus) autofocus = true;
     FocusScope.of(context).unfocus();
     Get.toNamed(AppRoutes.email);
   }

}