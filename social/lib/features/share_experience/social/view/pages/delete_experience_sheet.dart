import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/constants/assets_paths.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:social/core/app/view/themes/styles/buttons/button_types.dart';
import 'package:social/core/app/view/widgets/loading_indicator_widget.dart';

import '../../../../../core/app/view/themes/styles/decorations.dart';
import '../../../controller/new_experience_controller.dart';

class DeleteExperienceSheet extends StatelessWidget {
  final void Function()? onDeletePressed;
  final RxBool isLoading;
  final bool isComment;

  const DeleteExperienceSheet({
    super.key,
    this.onDeletePressed,
    required this.isLoading,
    required this.isComment,
  });

  static showSheet({
    void Function()? onDeletePressed,
    required RxBool isLoading,
    bool isComment = false,
  }) async {
    return await Get.bottomSheet(
      DeleteExperienceSheet(
        isLoading: isLoading,
        onDeletePressed: onDeletePressed,
        isComment: isComment,
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewExperienceController>(
      builder: (controller) => SafeArea(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
          child: Container(
            margin: const EdgeInsets.only(top: 40),
            color: context.colorScheme.background,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(Decorations.paddingHorizontal).copyWith(top: 8),
                    color: context.colorScheme.background,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isComment ? 'حذف نظر' : 'حذف تجربه',
                              style: context.textTheme.titleMedium,
                            ),
                            IconButton(
                              onPressed: Get.back,
                              icon: SvgPicture.asset(
                                AssetPaths.close,
                                color: context.colorScheme.onBackground,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        const SizedBox(width: double.infinity, height: 16),
                        Text(
                          isComment ? 'مطمئنی میخوای نظرت رو پاک کنی؟' : 'مطمئنی میخوای تجربت رو پاک کنی؟',
                          style: context.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: OutlinedButton(
                                style: context.buttonThemes.outlineButtonStyle(color: ButtonColors.surface),
                                onPressed: Get.back,
                                child: const Text('انصراف'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Obx(
                              () => Expanded(
                                flex: 3,
                                child: !isLoading.value
                                    ? ElevatedButton(
                                        style: context.buttonThemes.elevatedButtonStyle(),
                                        onPressed: onDeletePressed,
                                        child: const Text('آره'),
                                      )
                                    : ElevatedButton(
                                        style: context.buttonThemes.elevatedButtonStyle(),
                                        onPressed: () {},
                                        child: const LoadingIndicatorWidget(),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
