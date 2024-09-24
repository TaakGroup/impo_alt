import 'dart:typed_data';

import 'package:get/get.dart';
import '../../social/controller/share_experience_media_controller.dart';
import '../../social/controller/upload_image_mixin.dart';
import '../data/models/profile_model.dart';
import 'edit_share_experience_profile_controller.dart';
import 'share_experience_profile_controller.dart';

class UploadShareExperienceProfileController extends ShareExperienceMediaController with UploadImageMixin {
  final (ProfileModel profile, String hint) args = Get.arguments;

  UploadShareExperienceProfileController(super.remoteRepository);

  static UploadShareExperienceProfileController get to => Get.find();

  @override
  onInit() {
    change(args.$1.avatarImage, status: RxStatus.success());

    super.onInit();
  }

  @override
  void onUploadImage(Uint8List bytes, String name) {
    change(bytes, status: RxStatus.success());

    super.onUploadImage(bytes, name);
  }

  @override
  onImageUploaded(Uint8List bytes, String name) {
    EditShareExperienceProfileController.to.avatarImage = name;
    EditShareExperienceProfileController.to.profile.selectedIndex = -1;

    return super.onImageUploaded(bytes, name);
  }

  @override
  onLoading() {
    EditShareExperienceProfileController.to.change(null, status: RxStatus.empty());
  }

  @override
  onSuccess(result) {
    EditShareExperienceProfileController.to.change(null, status: RxStatus.success());
  }
}
