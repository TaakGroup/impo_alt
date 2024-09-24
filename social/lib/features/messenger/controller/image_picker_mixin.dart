import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

mixin ImagePickerMixin {
  final ImagePicker picker = ImagePicker();
  int index = 0;

  Future<XFile?> getLostData() async {
    final LostDataResponse response = await picker.retrieveLostData();

    if (response.isEmpty) return null;

    final List<XFile>? files = response.files;

    return files?.first;
  }

  Future<XFile?> pickImage(ImageSource imageSource, bool shouldCrop, {Size? maxDimension, bool? compress}) async {
    XFile? file;

    XFile? pickedFile = await picker.pickImage(
      source: imageSource,
      maxWidth: maxDimension?.width ?? 1800,
      maxHeight: maxDimension?.height ?? 1800,
    );

    pickedFile = pickedFile ?? await getLostData();

    if (pickedFile != null) {
      if (shouldCrop) {
        XFile? croppedFile = await cropImage(pickedFile.path);
        if (croppedFile != null) file = XFile(croppedFile.path);
      }
    }

    if (file != null && compress == true) {
      final XFile? compressFile = await compressImage(file.path);
      if (compressFile != null) {
        return XFile(compressFile.path);
      }
    }

    return file;
  }

  Future<XFile?> compressImage(String filePath) async {
    try {
      final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
      final splitted = filePath.substring(0, (lastIndex));
      final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

      return await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        minWidth: 1024,
        minHeight: 768,
        quality: 85,
      );
    } catch (_) {
      return null;
    }
  }

  Future<XFile?> cropImage(String filePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
      cropStyle: CropStyle.circle,
      aspectRatioPresets: [CropAspectRatioPreset.square],
    );

    return croppedImage != null ? XFile(croppedImage.path) : null;
  }

  Future<String> getLatestImagePath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/latestImage.jpg';
  }

  Future<String?> storeLatestImage(File? file, [String? storePath]) async {
    if (file == null) return null;

    String pathToStore = '';
    String defaultPathToStore = '${await getLatestImagePath()}$index';
    pathToStore = storePath ?? defaultPathToStore;
    index++;

    await _storeImage(file, pathToStore);

    return storePath ?? defaultPathToStore;
  }

  Future _storeImage(File file, String storePath) async {
    await file.copy(storePath);
  }
}
