import 'package:shamsi_date/extensions.dart';
import 'package:social/core/app/utils/extensions/on_datetime/on_jalali.dart';
import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../../constants/messages.dart';

extension Convertor on DateTime {
  String get toServerStr => DateFormat('yyyy-MM-dd HH:mm:ss.sssss').format(this).toString();


  String get toNowText {
    var toNow = DateTime.now().difference(this);

    if (toNow > const Duration(days: 1) && toNow < const Duration(days: 7)) {
      return Messages.daysAgo.replaceFirst('@day', toNow.inDays.toString());
    } else if (toNow > const Duration(hours: 1) && toNow < const Duration(hours: 24)) {
      return Messages.hoursAgo.replaceFirst('@hour', toNow.inHours.toString());
    } else if (toNow > const Duration(minutes: 1) && toNow < const Duration(hours: 1)) {
      return Messages.minutesAgo.replaceFirst('@min', toNow.inMinutes.toString());
    } else if (toNow < const Duration(minutes: 1)) {
      return Messages.recently;
    } else {
      return toJalali().toStr;
    }
  }
}
