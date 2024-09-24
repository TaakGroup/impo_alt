import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/constans/app_routes.dart';
import 'package:impo/src/core/app/utiles/helper/get_quesiton_page_with_id.dart';
import 'package:impo/src/core/app/view/widgets/toast.dart';
import 'package:impo/src/features/activation/data/models/questions_page_model.dart';
import 'package:taakitecture/taakitecture.dart';

import '../../../core/app/constans/messages.dart';
import '../../../core/app/model/record_model.dart';
import '../../../core/app/utiles/classes/validation.dart';

class AddPartnerController extends BaseController with GetSingleTickerProviderStateMixin{

  AddPartnerController(super.remoteRepository);
  static AddPartnerController get to => Get.find();
  late QuestionsPageModel page = getQuestionsPageWithId(14);
  late String title;
  late String description;
  late AnimationController buttonAnimationController;
  late TextEditingController phoneTextEditingController = TextEditingController();

  @override
  void onInit() {
    change(null, status: RxStatus.success());
    initAnim();
    setValues();
    super.onInit();
  }

  initAnim(){
    buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  setValues(){
    title = page.title;
    description = page.description;
  }

  onChangePhone(String value){
    if(!status.isSuccess) change(null,status: RxStatus.success());
    if(value.length > 10){
      buttonAnimationController.forward();
    }else{
      buttonAnimationController.reverse();
    }
  }

  onNextStepPressed() {
    change(null,status: RxStatus.loading());
    String? error = phoneNumberValidation(phoneTextEditingController.text);
    if (error == null){
      createPartner();
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

  createPartner() => create(
      model: JsonModel({
        "code": phoneTextEditingController.text,
      })
  );

  @override
  onFailure(String requestId, Failure failure, Function action) {
    change(null, status: RxStatus.success());

    toast(message: Messages.serverFailureTitle, snackPosition: SnackPosition.TOP);
  }

  @override
  onSuccess(result) {
    // Get.offNamed(AppRoutes.subscription);
    Get.offNamed(AppRoutes.index);
    return super.onSuccess(result);
  }

  @override
  void dispose() {
    buttonAnimationController.dispose();
    phoneTextEditingController.dispose();
    super.dispose();
  }

}