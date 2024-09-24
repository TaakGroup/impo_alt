import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/utiles/classes/vibration.dart';
import 'package:impo/src/core/app/utiles/helper/activation_next_step_helper.dart';
import 'package:impo/src/core/app/utiles/helper/get_progress_bar_helper.dart';
import 'package:impo/src/features/activation/data/models/question_view_model.dart';
import '../../../core/app/utiles/helper/get_quesiton_page_with_id.dart';
import '../../../core/app/utiles/helper/replace_name.dart';
import '../data/models/questions_page_model.dart';

class QuestionController extends GetxController with GetTickerProviderStateMixin {
  final int pageId = Get.arguments;
  late Rx<QuestionViewModel> question = QuestionViewModel().obs;
  late AnimationController buttonAnimationController;

  static QuestionController get to => Get.find();

  @override
  void onInit() {
    initAnim();
    updatePage(pageId);
    super.onInit();
  }

  initAnim() {
    buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  updatePage(int pageId) {
    QuestionsPageModel page = getQuestionsPageWithId(pageId);
    question.update((model) {
      model!.title = replaceName(page.title);
      model.questions = page.options;
      model.description = replaceName(page.description);
      model.subtitl = page.subtitle;
      model.progressBar = getProgressBarHelper(pageId);
    });
    if (question.value.questions.where((i) => i.selected.value).toList().isNotEmpty) {
      buttonAnimationController.forward();
    }
  }

  onTabItems(int selectedIndex) {
    question.value.questions[selectedIndex].selected.value = !question.value.questions[selectedIndex].selected.value;
    for (int i = 0; i < question.value.questions.length; i++) {
      if (i != selectedIndex) {
        question.value.questions[i].selected.value = false;
      }
    }
    if (question.value.questions.where((e) => e.selected.value).toList().length > 0) {
      if (!buttonAnimationController.isCompleted) {
        buttonAnimationController.forward();
      }
    } else {
      buttonAnimationController.reverse();
    }
  }

  @override
  void dispose() {
    buttonAnimationController.dispose();
    super.dispose();
  }

  nextSubmit(){
    CustomVibration().normalVibrator();
    ActivationNextStepHelper().nextStep(pageId,question.value);
  }

}
