
import 'package:get/get.dart';
import 'package:impo/src/core/app/utiles/helper/activation_next_step_helper.dart';
import 'package:impo/src/core/app/utiles/helper/get_quesiton_page_with_id.dart';
import 'package:impo/src/features/activation/data/models/question_view_model.dart';
import 'package:impo/src/features/activation/data/models/reward_view_model.dart';
import '../../../core/app/utiles/helper/replace_name.dart';
import '../data/models/questions_page_model.dart';

class RewardController extends GetxController{
  final int pageId = Get.arguments;
  late Rx<RewardViewModel> reward = RewardViewModel().obs;

  static RewardController get to => Get.find();

  @override
  void onInit() {
    updatePage(pageId);
    super.onInit();
  }

  updatePage(int pageId){
    QuestionsPageModel page = getQuestionsPageWithId(pageId);
    reward.update((model){
      model!.enable = page.enable;
      model.btnLabel = page.btnLabel;
      model.btnLabel2 = page.btnLabel2;
      model.title = replaceName(page.title);
      model.description = replaceName(page.description);
      model.image = page.image;
      model.gradient = page.gradient;
      model.doRepeat = page.doRepeat;
    });
  }

  nextSubmit() => ActivationNextStepHelper().nextStep(pageId,QuestionViewModel()); // QuestionViewModel() == null لازم نداریم

}