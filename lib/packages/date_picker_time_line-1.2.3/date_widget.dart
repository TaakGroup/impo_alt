/// ***
/// This class consists of the DateWidget that is used in the ListView.builder
///
/// Author: Vivek Kaushik <me@vivekkasuhik.com>
/// github: https://github.com/iamvivekkaushik/
/// ***

import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

typedef DateSelectionCallback = void Function(Jalali selectedDate);


class DateWidget extends StatelessWidget {
  final double? width;
  final Jalali date;
  final TextStyle? monthTextStyle, dayTextStyle, dateTextStyle;
  final Color selectionColor;
  final DateSelectionCallback? onDateSelected;
  final String? locale;

  DateWidget({
    required this.date,
    required this.monthTextStyle,
    required this.dayTextStyle,
    required this.dateTextStyle,
    required this.selectionColor,
    this.width,
    this.onDateSelected,
    this.locale
  });

  String formatMoon(Date d) {
    final f = d.formatter;

    if(locale == 'fa') {
      return '${f.mN}';
    }else{
      return '${f.mnAf}';
    }
  }

  String formatWeekDay(Date d) {
    final f = d.formatter;

    return '${f.wN}';
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: width,
        margin: EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: selectionColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(formatWeekDay(date),
                  // WeekDay
                  style: dayTextStyle),
              Text(date.day.toString(), // Date
                  style: dateTextStyle),
              Text(formatMoon(date),
                  // Month
                  style: monthTextStyle),
//              Text(new DateFormat("MMM", locale).format(date).toUpperCase(),
//                  // Month
//                  style: monthTextStyle),
//              Text(date.day.toString(), // Date
//                  style: dateTextStyle),
//              Text(new DateFormat("E", locale).format(date).toUpperCase(),
//                  // WeekDay
//                  style: dayTextStyle)
            ],
          ),
        ),
      ),
      onTap: () {
        // Check if onDateSelected is not null
        if (onDateSelected != null) {
          // Call the onDateSelected Function
          onDateSelected!(this.date);
        }
      },
    );
  }
}
