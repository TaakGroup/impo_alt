import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/constans/app_routes.dart';
import 'package:impo/src/core/app/utiles/helper/get_quesiton_page_with_id.dart';
import 'package:intl/intl.dart';
import 'package:shamsi_date/extensions.dart';
import '../../authentication/register/controller/register_controller.dart';
import '../data/models/questions_page_model.dart';

class SetDataOfBirthController extends GetxController with GetSingleTickerProviderStateMixin{

  late AnimationController rightAnimationController;

  static SetDataOfBirthController get to => Get.find();

  late QuestionsPageModel page = getQuestionsPageWithId(2);

  late String title;

  late String description;

  final DateFormat formatterDate = DateFormat('yyyy/MM/dd');
  
  @override
  void onInit() {
    RegisterController.to.registerModel.birthDate = Jalali.now();
    initAnim();
    setValues();
    super.onInit();
  }

  nextPressed(){
    Get.toNamed(AppRoutes.question,arguments: 3);
  }


  initAnim(){
    rightAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
  }

  setValues(){
    title = page.title;
    description = page.description;
  }

  onDateChange(Jalali date) => RegisterController.to.registerModel.birthDate = date;

  @override
  void dispose() {
    rightAnimationController.dispose();
    super.dispose();
  }

}