import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/constans/app_routes.dart';
import 'package:impo/src/core/app/utiles/helper/get_quesiton_page_with_id.dart';
import '../../authentication/register/controller/register_controller.dart';
import '../data/models/questions_page_model.dart';

class SetNameController extends GetxController with GetTickerProviderStateMixin{

  late AnimationController buttonAnimationController;
  late TextEditingController nameTextEditingController = TextEditingController();
  late AnimationController rightAnimationController;
  late QuestionsPageModel page = getQuestionsPageWithId(1);
  static SetNameController get to => Get.find();

  late String title;

  late String description;

  nextPressed(){
    RegisterController.to.registerModel.firstName = nameTextEditingController.text;
    Get.toNamed(AppRoutes.setBirth);
  }

  @override
  void onInit() {
    initAnim();
    setValues();
    super.onInit();
  }


  initAnim(){
    rightAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );
  }

  setValues(){
    title = page.title;
    description = page.description;
  }

  onChangeName(String value){
    if(value.length >= 3){
      buttonAnimationController.forward();
    }else{
      buttonAnimationController.reverse();
    }
  }


  @override
  void dispose() {
    buttonAnimationController.dispose();
    nameTextEditingController.dispose();
    nameTextEditingController.dispose();
    super.dispose();
  }

}