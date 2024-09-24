import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import '../../themes/styles/buttons/button_types.dart';
import '../input/input.dart';

class TimePickerWidget extends StatelessWidget {
  const TimePickerWidget({Key? key}) : super(key: key);

  static showDialog() {
    Get.dialog(
      const TimePickerWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'انتخاب ساعت',
              style: context.textTheme.titleSmall,
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ساعت', ),
                      const SizedBox(height: 6),
                      Input(
                        inputSize: InputSize.large(context).copyWith(padding: const EdgeInsets.symmetric(vertical: 56)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    ':',
                    style: context.textTheme.displayMedium,
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ساعت'),
                      const SizedBox(height: 6),
                      Input(),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                const Column(
                  children: [],
                )
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  style: context.buttonThemes.outlineButtonStyle(color: ButtonColors.surface),
                  onPressed: () {},
                  child: const Text("انصراف"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: context.buttonThemes.elevatedButtonStyle(color: ButtonColors.base),
                  onPressed: () {},
                  child: const Text("تایید"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
