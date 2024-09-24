import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social/features/share_experience/profile/controller/upload_share_experience_profile_controller.dart';
import 'package:taakitecture/taakitecture.dart';
import '../data/models/profile_model.dart';
import '../view/pages/avatar_picker_sheet.dart';

class EditShareExperienceProfileController extends BaseController {
  late TextEditingController usernameTextController;
  final (ProfileModel profile, String hint) args = Get.arguments;
  late String? avatarImage;

  EditShareExperienceProfileController(super.remoteRepository);

  static EditShareExperienceProfileController get to => Get.find();

  ProfileModel get profile => args.$1;

  @override
  onInit() {
    change(null, status: RxStatus.success());
    usernameTextController = TextEditingController(text: profile.username);
    avatarImage = profile.avatarImage;

    super.onInit();
  }

  onSubmit() {
    if (usernameTextController.text.isNotEmpty) {
      profile.username = usernameTextController.text;
      profile.avatarImage = avatarImage ?? profile.avatarImage;

      create(model: profile);
    }
  }

  @override
  onSuccess(result) {
    Get.back(result: true);

    return super.onSuccess(result);
  }

  pickAvatar() async {
    final int? selectedIndex = await AvatarPickerSheet.showSheet(
      profile.selectedIndex!,
      profile.avatars!,
      profile.avatarImage!,
    );

    if (selectedIndex != null) {
      profile.selectedIndex = selectedIndex;
      profile.avatarImage = profile.avatars![selectedIndex];
      avatarImage = profile.avatars![selectedIndex];
      UploadShareExperienceProfileController.to.change(profile.avatarImage, status: RxStatus.success());
    }
  }
}
