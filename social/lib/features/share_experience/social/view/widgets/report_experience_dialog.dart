import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import '../../../../../core/app/view/themes/styles/buttons/button_types.dart';
import '../../../../../core/app/view/themes/styles/buttons/loading_button/elevation_loading_button.dart';
import '../../../../../core/app/view/themes/styles/decorations.dart';
import '../../../../../core/app/view/widgets/dialog/base_dialog.dart';
import '../../../../../core/app/view/widgets/loading_indicator_widget.dart';

class ReportDialog extends StatelessWidget {
  final RxBool isLoading;
  final Function() reportPressed;

  const ReportDialog({super.key, required this.reportPressed, required this.isLoading});

  static showDialog({required Function() reportPressed, required RxBool isLoading}) {
    Get.bottomSheet(
      ReportDialog(
        isLoading: isLoading,
        reportPressed: reportPressed,
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.background,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 12,
            width: double.infinity,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 4,
              width: 32,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                color: context.colorScheme.surface,
              ),
            ),
          ),
          BaseDialog(
            margin: EdgeInsets.zero,
            padding: Decorations.pagePaddingHorizontal.copyWith(bottom: 32, top: 8),
            title: 'ریپورت پست',
            description: 'ایمپویی عزیز، از ریپورت کردن این پست مطمئنی؟',
            actions: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: context.buttonThemes.textButtonStyle(color: ButtonColors.surface, size: ButtonSizes.small),
                  onPressed: Get.back,
                  child: const Text('خیر'),
                ),
                const SizedBox(width: 8),
                Obx(
                  () => TextButton(
                    style: context.buttonThemes.textButtonStyle(size: ButtonSizes.small),
                    onPressed: !isLoading.value ? reportPressed : () {},
                    child: !isLoading.value
                        ? const Text('بله')
                        : LoadingIndicatorWidget(color: context.colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
