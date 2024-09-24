import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/core/app/constants/assets_paths.dart';
import '../../../core/app/constants/messages.dart';
import '../view/widgets/title_circle_button.dart';
import '../view/widgets/title_list_view.dart';
import 'image_picker_mixin.dart';

mixin MessengerMediaMixin on ImagePickerMixin {
  onImagePicked(XFile bytes) => Get.back();

  onFilePicked(XFile bytes) {}

  openMediaSheet() {
    Get.bottomSheet(
      TitleListWidget(
        titleButtonsData: [
          TitleButtonData(
            onPressed: onCameraButtonPressed,
            iconPath: AssetPaths.camera,
            title: Messages.camera,
          ),
          TitleButtonData(
            onPressed: onGalleryButtonPressed,
            iconPath: AssetPaths.gallery,
            title: Messages.gallery,
          ),
          TitleButtonData(
            onPressed: onFileButtonPressed,
            iconPath: AssetPaths.file,
            title: Messages.file,
          ),
        ],
      ),
    );
  }

  onCameraButtonPressed() async {
    XFile? file = await pickImage(ImageSource.camera, false, compress: !kIsWeb);
    if (file != null) onImagePicked.call(file);
  }

  onGalleryButtonPressed({bool? shouldCrop}) async {
    XFile? file = await pickImage(
      ImageSource.gallery,
      shouldCrop ?? false,
      compress: !kIsWeb,
    );

    if (file != null) onImagePicked.call(file);
  }

  onFileButtonPressed({FileType? fileType}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: fileType ?? FileType.any);
    if (result != null && result.files.isNotEmpty) {
      final XFile bytes = kIsWeb ? XFile.fromData(result.files.first.bytes!, name: result.files.first.name) : XFile(result.files.single.path!);
      onFilePicked.call(bytes);
    }
  }
}
