import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/core/app.dart';
import 'package:taakitecture/taakitecture.dart';
import 'package:dio/dio.dart' as dio;

mixin UploadImageMixin on BaseController {
  String get catchDir => '';

  onPickImagePressed() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      final XFile bytes =
          kIsWeb ? XFile.fromData(result.files.first.bytes!, name: result.files.first.name) : XFile(result.files.single.path!);
      onImagePicked.call(bytes);
    }
  }

  onPickImageFromCameraPressed() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      onImagePicked.call(photo);
    }
  }

  onImagePicked(XFile file) async {
    final bytes = await file.readAsBytes();
    final name = file.name;
    onUploadImage(bytes, name);
  }

  void onUploadImage(Uint8List bytes, String name) async {
    final multipartFile = dio.MultipartFile.fromBytes(bytes, filename: name);
    final formData = dio.FormData();
    formData.files.add(MapEntry('files', multipartFile));

    uploadFile(formData: formData).then(
      (response) => response.fold(
        (l) => onFailure(name, l, () => onUploadImage(bytes, name)),
        (r) => onImageUploaded(bytes, r.name),
      ),
    );
  }

  onImageUploaded(Uint8List bytes, String name) => catchImage(name, bytes);

  catchImage(String name, Uint8List bytes) => DefaultCacheManager().putFile('${App.baseUrl}$catchDir/$name', bytes);
}
