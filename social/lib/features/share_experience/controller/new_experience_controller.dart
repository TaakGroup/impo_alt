import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:social/core/app/constants/messages.dart';
import 'package:social/core/app/view/widgets/toast.dart';
import 'package:taakitecture/taakitecture.dart';

import '../social/data/models/new_experience_model.dart';
import '../social/data/models/share_experience_topic_model.dart';
import '../view/pages/get_topic_sheet.dart';

class NewExperienceController extends BaseController {
  NewExperienceModel experience = NewExperienceModel();
  final RxInt inputCounter = 0.obs;
  final RxInt selectedTopicIndex = double.maxFinite.toInt().obs;
  final RxBool isTopicSelected = false.obs;

  NewExperienceController(super.remoteRepository);

  static NewExperienceController get to => Get.find();

  @override
  onInit() {
    change(null, status: RxStatus.success());

    super.onInit();
  }

  onTextChanged(String text) {
    inputCounter.value = text.length;
    experience.text = text;
  }

  sendExperience({String? shareId, String? topicId}) {
    if (experience.text!.isNotEmpty) {
      experience.topicId ??= topicId;
      return create(model: experience, params: shareId);
    } else {
      toast(message: Messages.experienceEmptyError);
    }
  }



  resetExperience() => experience = NewExperienceModel();

  @override
  onSuccess(result) {
    resetExperience();
    Get.back(result: true);

    return super.onSuccess(result);
  }

  selectTopic(int? index, List<ShareExperienceTopicModel> topics) {
    if (index != null) {
      isTopicSelected.value = true;
      experience.topicId = topics[index].id;
      selectedTopicIndex.value = index;
    }
  }

  Future<void> openTopicSheet(topics) async {
    if (experience.text != null && experience.text!.isNotEmpty) {
      Get.focusScope?.unfocus();
      final res = await GetTopicSheet.showSheet(topics);
      if(res == true) Get.back(result: res);
    } else {
      toast(message: Messages.experienceEmptyError);
    }
  }
}
