import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';


extension Convertor on Jalali {
  String get toServerStr => DateFormat('yyyy-MM-dd').format(toDateTime()).toString();

  String get toStr => '${formatter.d} ${formatter.mN} ${formatter.yyyy}';

  String get toStrNoYear => '${formatter.d} ${formatter.mN}';

  String get toDateString => '${formatter.yyyy}/${formatter.mm}/${formatter.d}';
}

