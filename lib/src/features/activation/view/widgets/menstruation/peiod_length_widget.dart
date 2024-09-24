import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/widgets/custom_picker.dart';

import '../../../controller/date_picker_activation_controller.dart';

class PeriodLengthWidget extends StatelessWidget {
  final DatePickerActivationController controller;
  const PeriodLengthWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(
          // top: 85,
          top: 35,
          right: 16,
          left: 16
        ),
        child: CustomPicker(
          scrollController: FixedExtentScrollController(initialItem: controller.currentIndexPeriod.value),
          onChange: (index) => controller.onChangePeriodPicker(index),
          itemExtent: 50,
          children: List.generate(controller.dayPeriods.length, (index) {
            return Container(
              height: 50,
              alignment: Alignment.center,
              child: AutoSizeText(
                  controller.dayPeriods[index].toString(),
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
