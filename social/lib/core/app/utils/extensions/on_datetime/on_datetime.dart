import 'package:intl/intl.dart';
import 'package:shamsi_date/extensions.dart';

extension ToString on DateTime {
  String toServerString() => DateFormat('yyyy-MM-dd HH:mm:ss.sssss').format(this);

  String get toPersianText {
    Jalali jalali = toJalali();
    final formatter = jalali.formatter;
    return "${formatter.d} ${formatter.mN}، ${formatter.yyyy}";
  }
}
