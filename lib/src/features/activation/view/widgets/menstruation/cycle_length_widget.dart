import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/widgets/custom_picker.dart';
import 'package:impo/src/features/activation/controller/date_picker_activation_controller.dart';

class CycleLengthWidget extends StatelessWidget {
  final DatePickerActivationController controller;
  const CycleLengthWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.only(
          // top: 85,
          top: 35,
          right: 16,
          left: 16
        ),
        child: CustomPicker(
          scrollController: FixedExtentScrollController(initialItem: controller.currentIndexCycle.value),
          onChange: (index) => controller.onChangeCyclePicker(index),
          itemExtent: 50,
          children: List.generate(controller.dayCycles.length, (index) {
            return Container(
              height: 50,
              alignment: Alignment.center,
              child: AutoSizeText(
                controller.dayCycles[index].toString(),
                maxLines: 1,
                style: context.textTheme.bodyLarge
              ),
            );
          }),
        ),
      ),
    );
  }
}
