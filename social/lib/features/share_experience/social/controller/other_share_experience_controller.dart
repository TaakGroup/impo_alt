import 'package:get/get.dart';
import 'base_share_experience_controller.dart';
import 'share_experience_controller.dart';

class OtherShareExperienceController extends BaseShareExperienceController {
  OtherShareExperienceController(super.remoteRepository);

  static OtherShareExperienceController get to  => Get.find();

  @override
  String get path => 'other';

  @override
  Future<void> onRefresh() async {
    initPaging();
    ShareExperienceController.to.getShareExperience();
  }
}