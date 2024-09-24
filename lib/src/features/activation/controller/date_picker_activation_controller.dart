import 'package:impo/src/core/app/constans/app_routes.dart';
import 'package:impo/src/core/app/utiles/classes/vibration.dart';
import 'package:impo/src/core/app/utiles/extensions/on_datetime/on_jalali.dart';
import 'package:impo/src/core/app/utiles/helper/activation_next_step_helper.dart';
import 'package:impo/src/core/app/utiles/helper/replace_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shamsi_date/extensions.dart';
import '../../../core/app/utiles/helper/get_progress_bar_helper.dart';
import '../../../core/app/utiles/helper/get_quesiton_page_with_id.dart';
import '../../authentication/register/controller/register_controller.dart';
import '../data/models/question_view_model.dart';
import '../data/models/questions_page_model.dart';

class DatePickerActivationController extends GetxController with GetTickerProviderStateMixin{
  final int pageId = Get.arguments;
  late Rx<QuestionViewModel> infoDatePicker = QuestionViewModel().obs;
  late AnimationController buttonAnimationController;
  late TabController pregnancyTabController;

  List<int> registrationPageIds = [11,35,51,63];

  //CycleLengthPage
  RxInt currentIndexCycle = 0.obs;
  List<int> dayCycles = [];

  //PeriodLength
  RxInt currentIndexPeriod = 0.obs;
  List<int> dayPeriods = [];

  static DatePickerActivationController get to => Get.find();

  @override
  void onInit() {
    initInfoPeriod();
    initAnim();
    updatePage(pageId);
    super.onInit();
  }

  initAnim() {
    buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    Future.delayed(Duration(seconds: 1),(){
      buttonAnimationController.forward();
    });
  }

  initInfoPeriod(){
    switch (pageId){

      case  9:
      case 33:
      case 49:
        RegisterController.to.registerModel.startPeriodDate = Jalali.now();
        break;

      case 10:
      case 34:
      case 50:
        generateCycleDays();
        break;

      case 11:
      case 35:
      case 51:
        generatePeriodDays();
        break;


      case 28:

        break;

      case 63:
        pregnancyTabController = TabController(length: 2, vsync: this);
        RegisterController.to.registerModel.pregnancyDate = Jalali.now();
        break;
    }
  }

  generateCycleDays() {
    for (int i = 3; i < 81; i++) {
      dayCycles.add(i);
    }
    for(int i=0 ; i<dayCycles.length ; i++){
      if(dayCycles[i] == 28){
        currentIndexCycle.value = i;
        break;
      }
    }
    RegisterController.to.registerModel.totalCycleLength = dayCycles[currentIndexCycle.value];
  }

  generatePeriodDays(){
    for(int i=2 ; i<RegisterController.to.registerModel.totalCycleLength! ; i++){
      dayPeriods.add(i);
    }
    for(int i=0 ; i<dayPeriods.length ; i++){
      if(dayPeriods[i] <= 7){
        currentIndexPeriod.value = i;
      }
    }
    RegisterController.to.registerModel.periodLength = dayPeriods[currentIndexPeriod.value];
  }

  updatePage(int pageId) {
    QuestionsPageModel page = getQuestionsPageWithId(pageId);
    infoDatePicker.update((model) {
      model!.title = replaceName(page.title);
      model.questions = page.options;
      model.description = replaceName(page.description);
      model.subtitl = page.subtitle;
      model.progressBar = getProgressBarHelper(pageId);
    });
  }

  //Period
  onLastPeriodChanged(Jalali date){
    print(date.toServerStr);
    RegisterController.to.registerModel.startPeriodDate = date;
  }
  onChangeCyclePicker(index) {
    currentIndexCycle.value = index;
    RegisterController.to.registerModel.totalCycleLength = dayCycles[currentIndexCycle.value];
  }
  onChangePeriodPicker(index) {
    currentIndexPeriod.value = index;
    RegisterController.to.registerModel.periodLength = dayPeriods[currentIndexPeriod.value];
  }

  //Pregnancy
  pressTabPregnancy(_) => RegisterController.to.registerModel.pregnancyDate = Jalali.now();
  onPregnancyDateChanged(Jalali date) => RegisterController.to.registerModel.pregnancyDate = date;

  //PeriodTracker
  onLastPeriodPlanning(Jalali date) => print(date);
  skipPeriodPlanning() => Get.toNamed(AppRoutes.question,arguments: 30);

  nextSubmit(){
    CustomVibration().normalVibrator();
    ActivationNextStepHelper().nextStep(pageId,infoDatePicker.value);
  }

  @override
  void dispose() {
    buttonAnimationController.dispose();
    super.dispose();
  }
}