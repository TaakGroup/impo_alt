import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:social/core/app/view/widgets/loading_indicator_widget.dart';
import '../../../../../core/app/constants/assets_paths.dart';
import '../../../../../core/app/view/themes/styles/decorations.dart';
import '../../../../../core/app/view/widgets/input/input.dart';
import '../../controller/edit_share_experience_profile_controller.dart';
import '../../controller/upload_share_experience_profile_controller.dart';
import 'avatar_picker_sheet.dart';
import 'image_picker_sheet.dart';

class EditShareExperienceProfilePage extends StatelessWidget {
  const EditShareExperienceProfilePage({super.key});

  String? get avatarImage => EditShareExperienceProfileController.to.profile.avatarImage;

  String? get username => EditShareExperienceProfileController.to.profile.username;

  String get hint => EditShareExperienceProfileController.to.args.$2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ویرایش پروفایل')),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(Decorations.paddingHorizontal),
        child: EditShareExperienceProfileController.to.obx(
          (_) => ElevatedButton(
            onPressed: EditShareExperienceProfileController.to.onSubmit,
            style: context.buttonThemes.elevatedButtonStyle(wide: true),
            child: const Text('ثبت تغییرات'),
          ),
          onLoading: ElevatedButton(
            onPressed: () {},
            style: context.buttonThemes.elevatedButtonStyle(wide: true),
            child: const LoadingIndicatorWidget(),
          ),
          onEmpty: ElevatedButton(
            onPressed: null,
            style: context.buttonThemes.elevatedButtonStyle(wide: true),
            child: const Text('ثبت تغییرات'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: Decorations.pagePaddingHorizontal.copyWith(top: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity),
            UploadShareExperienceProfileController.to.obx(
              (image) => GestureDetector(
                onTap: () => ImagePickerSheet.showSheet(),
                child: Badge(
                  backgroundColor: context.colorScheme.primary,
                  alignment: Alignment.bottomRight,
                  smallSize: 28,
                  largeSize: 28,
                  label: SvgPicture.asset(
                    AssetPaths.changeImage,
                    color: context.colorScheme.background,
                    height: 20,
                    width: 20,
                  ),
                  child: image != null && image is String
                      ? Container(
                          height: 88,
                          width: 88,
                          decoration: BoxDecoration(
                            color: context.colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                            border: Border.all(color: context.colorScheme.surface),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider('$avatarImage'),
                            ),
                          ),
                        )
                      : image != null && image is Uint8List
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(300.0),
                              child: Image.memory(
                                image,
                                fit: BoxFit.cover,
                                height: 88,
                                width: 88,
                              ),
                            )
                          : SvgPicture.asset(
                              AssetPaths.avatar,
                              height: 88,
                              width: 88,
                            ),
                ),
              ),
            ),
            SizedBox(height: context.height * 0.1),
            Input(
              label: 'نام کاربری',
              controller: EditShareExperienceProfileController.to.usernameTextController,
              hintText: username,
              suffixIcon: SvgPicture.asset(AssetPaths.edit, color: context.colorScheme.onBackground),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                color: Color(0xffFFF1E3),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    AssetPaths.info,
                    color: const Color(0xffF47500),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      hint,
                      style: context.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
