import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../../constants/messages.dart';

extension Convertor on Jalali {
  String get toServerStr => DateFormat('yyyy-MM-dd HH:mm:ss.sssss').format(toDateTime()).toString();

  String get toStr => '${formatter.d} ${formatter.mN} ${formatter.yyyy}';

  String get toStrNoYear => '${formatter.d} ${formatter.mN}';

  String get toStrNumber => '${formatter.yy}/${formatter.mm}/${formatter.d}';
}

extension Utils on Jalali {
  String get properShamsiString => '$year/$month/$day';

  String get validDateTimeString {
    return DateTime(toDateTime().year, toDateTime().month, toDateTime().day).toString();
  }

  // String get timeOfDayName {
  //   if (hour > 19 || hour < 4) {
  //     return Messages.night;
  //   } else if (hour > 15) {
  //     return Messages.afterNoon;
  //   } else if (hour > 10) {
  //     return Messages.noon;
  //   } else {
  //     return Messages.morning;
  //   }
  // }
  //
  // toZeroHour() => copy(hour: 0, minute: 0, second: 0, millisecond: 0);
}
