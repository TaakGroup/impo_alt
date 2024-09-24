
import 'package:flutter/material.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/core/app/view/widgets/jalali_date_picker_widget.dart';
import 'package:shamsi_date/extensions.dart';

import '../../../controller/date_picker_activation_controller.dart';

class LastPeriodWidget extends StatelessWidget {
  final DatePickerActivationController controller;
  const LastPeriodWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 35),
          child: JalaliDatePickerWidget(
            onChange: controller.onLastPeriodChanged,
            startDate: Jalali.now().addMonths(-6),
            dateFormat: 'dd/MMMM/yyyy',
            dividerColor: Colors.transparent,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              // top: 43,
              bottom: 7,
              right: 16,
              left: 16
          ),
          child: Divider(
            color: context.colorScheme.onSurface.withOpacity(0.16),
            thickness: 0.75,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 77,
              right: 16,
              left: 16
          ),
          child: Divider(
            color: context.colorScheme.onSurface.withOpacity(0.16),
            thickness: 0.75,
          ),
        )
      ],
    );
  }
}
