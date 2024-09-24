import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/core/app/view/widgets/jalali_date_picker_widget.dart';
import 'package:shamsi_date/extensions.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../../controller/date_picker_activation_controller.dart';

class CalculateWeekPregnancyWidget extends StatelessWidget {
  final DatePickerActivationController controller;

  const CalculateWeekPregnancyWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(height: 16),
          DefaultTabController(
            length: controller.infoDatePicker.value.questions.length,
            child: TabBar(
              onTap: controller.pressTabPregnancy,
              controller: controller.pregnancyTabController,
              tabs: [
                Text(
                    controller.infoDatePicker.value.questions.where((e) => e.id == 1).toList().first.text,
                    textAlign: TextAlign.center
                ),
                Text(
                    controller.infoDatePicker.value.questions.where((e) => e.id == 2).toList().first.text,
                    textAlign: TextAlign.center),
              ],
              labelStyle: context.textTheme.labelSmall,
              labelColor: context.colorScheme.primary,
              unselectedLabelColor: context.colorScheme.outline,
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: EdgeInsets.only(bottom: 8),

            ),
          ),
          Container(
            height: 200,
            child: TabBarView(
                controller: controller.pregnancyTabController,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  datePicker(
                      context,
                      startPregnancyDate: Jalali.now().addDays(-294), // معادل 42 هفته
                      endPregnancyDate: Jalali.now(),
                      focusedDate: Jalali.now()
                  ),
                  datePicker(
                      context,
                      startPregnancyDate: Jalali.now(),
                      endPregnancyDate: Jalali.now().addDays(294), // معادل 42 هفته
                      focusedDate: Jalali.now().addDays(294) // معادل 42 هفته
                  )
                ]
            ),
          )
        ],
      ),
    );
  }

  datePicker(BuildContext context,{required Jalali startPregnancyDate,required Jalali endPregnancyDate,required Jalali focusedDate}){
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 35),
          child: JalaliDatePickerWidget(
            onChange: controller.onPregnancyDateChanged,
            startDate: startPregnancyDate,
            endDate: endPregnancyDate,
            dateFormat: 'dd/MMMM/yyyy',
            dividerColor: Colors.transparent,
            focusedDate: focusedDate,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            // top: 43,
              bottom: 7,
              right: 16,
              left: 16),
          child: Divider(
            color: context.colorScheme.onSurface.withOpacity(0.16),
            thickness: 0.75,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 77, right: 16, left: 16),
          child: Divider(
            color: context.colorScheme.onSurface.withOpacity(0.16),
            thickness: 0.75,
          ),
        )
      ],
    );
  }

}
