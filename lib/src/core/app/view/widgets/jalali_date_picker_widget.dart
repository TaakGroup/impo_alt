import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/packages/flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:impo/src/core/app/constans/messages.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:shamsi_date/extensions.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../../../../packages/flutter_holo_date_picker/date_picker.dart';
import '../../../../../packages/flutter_holo_date_picker/date_picker_theme.dart';


class JalaliDatePickerWidget extends StatelessWidget {
  final Jalali? startDate;
  final Jalali? endDate;
  final Jalali? focusedDate;
  final Function(Jalali jalali) onChange;
  final String dateFormat;
  final Color? dividerColor;

   JalaliDatePickerWidget({
    Key? key,
    required this.onChange,
    this.startDate,
    this.endDate,
    this.focusedDate,
    this.dateFormat = "dd/MMMM/yyyy",
    this.dividerColor
    // this.dateTimeType = DateTimeType.jalali,
  }) : super(key: key);

  // final DateTimeType dateTimeType;

  @override
  Widget build(BuildContext context) {
    return DatePickerWidget(
      // isJalali: dateTimeType == DateTimeType.jalali,
      isJalali: true,
      looping: false,
      firstDateJalaliTime: startDate ?? Jalali(1330),
      initialJalaliTime: focusedDate,
      lastDateJalaliTime: endDate ?? Jalali.now(),
      firstDate: DateTime(1960),
      lastDate: endDate?.toDateTime() ?? DateTime.now(),
      initialDate: focusedDate?.toDateTime(),
      dateFormat: dateFormat,
     // locale: DatePicker.localeFromString(dateTimeType == DateTimeType.jalali ? 'fa' : 'en'),
      locale: DatePicker.localeFromString('fa'),
      // onChange: (DateTime newDate, _) => dateTimeType == DateTimeType.jalali ? onChange(AppDateTime.fromDateTime(Jalali(newDate.year, newDate.month, newDate.day).toDateTime())) : onChange(AppDateTime.fromDateTime(newDate)),
      onChange: (DateTime newDate, _) => onChange(Jalali.fromDateTime(Jalali(newDate.year, newDate.month, newDate.day).toDateTime())),
      pickerTheme: DateTimePickerTheme(
        backgroundColor: Colors.transparent,
        itemTextStyle: context.textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.w600
        ),
        dividerColor: context.colorScheme.onSurfaceVariant,
        itemHeight: 50,
      ),
      dividerColor: dividerColor,
    );
  }
}

class JalaliDatePickerBottomSheet extends StatelessWidget {
  final Jalali? startDate;
  final Jalali? endDate;
  final Jalali? focusedDate;
  final Function(Jalali jalali) onChange;
  final Rx<Jalali> selectedDate = Jalali.fromDateTime(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)).obs;
  final Widget? content;

  JalaliDatePickerBottomSheet({Key? key, this.startDate, this.endDate, required this.onChange, this.focusedDate,this.content}) : super(key: key);

  static showBottomSheet(final Function(Jalali jalali) onChange, {Jalali? focusedDate,Widget? content}) => Get.bottomSheet(
        JalaliDatePickerBottomSheet(
          onChange: onChange,
          focusedDate: focusedDate,
          content: content,
        ),
        isScrollControlled: true,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colorScheme.background,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 32),
      child: Wrap(
        children: [
          content!,
          const SizedBox(height: 32),
          JalaliDatePickerWidget(
            onChange: (date) => selectedDate.value = date,
            focusedDate: focusedDate,
            startDate: startDate,
            endDate: endDate,
          ),
          const SizedBox(
            height: 18,
            width: double.infinity,
          ),
          ElevatedButton(
            style: context.buttonThemes.elevatedButtonStyle(wide: true),
            onPressed: () {
              onChange.call(selectedDate.value);
              Get.back();
            },
            child: Text(Messages.applyChanges),
          ),
        ],
      ),
    );
  }
}
