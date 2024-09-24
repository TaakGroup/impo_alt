import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/features/share_experience/social/controller/upload_image_mixin.dart';
import 'package:taakitecture/taakitecture.dart';

import '../../controller/new_experience_controller.dart';


class ShareExperienceMediaController extends BaseController with UploadImageMixin {
  Uint8List? pickedImage;
  RxBool hasImage = false.obs;
  RxBool imageLoading = false.obs;

  @override
  String get catchDir => '/file';

  ShareExperienceMediaController(super.remoteRepository);

  @override
  onImagePicked(XFile file) async {
    pickedImage = await file.readAsBytes();
    hasImage.value = true;

    return super.onImagePicked(file);
  }

  @override
  void onUploadImage(Uint8List bytes, String name) {
    imageLoading.value = true;

    super.onUploadImage(bytes, name);
  }

  @override
  onImageUploaded(Uint8List bytes, String name) {
    imageLoading.value = false;
    NewExperienceController.to.experience.image = name;

    return super.onImageUploaded(bytes, name);
  }

  onRemoveImage() {
    NewExperienceController.to.experience.image = null;
    return hasImage.value = false;
  }
}
