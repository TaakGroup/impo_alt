import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:shamsi_date/extensions.dart';


enum DateTimeType { gregorian, jalali }

DateTimeType dateTimeType = DateTimeType.jalali;

abstract class AppDateTime extends Equatable {
  final DateTime dateTime;

  const AppDateTime({required this.dateTime});

  @override
  List<Object?> get props => [dateTime];

  int get day;

  int get weekDay;

  int get month;

  int get year;

  String get dd;

  String get mN;

  String get wN;

  String get yyyy;

  int get monthLength;

  static AppDateTime factory(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
  ]) {
    switch (dateTimeType) {
      case DateTimeType.gregorian:
        return GregorianDateTime(dateTime: DateTime(year, month, day, hour, minute, second, millisecond));
      case DateTimeType.jalali:
        return JalaliDateTime(dateTime: DateTime(year, month, day, hour, minute, second, millisecond));
    }
  }

  static AppDateTime parse(String value) {
    switch (dateTimeType) {
      case DateTimeType.gregorian:
        return GregorianDateTime(dateTime: DateTime.parse(value));
      case DateTimeType.jalali:
        return JalaliDateTime(dateTime: DateTime.parse(value));
    }
  }

  static AppDateTime fromDateTime(DateTime dateTime) {
    switch (dateTimeType) {
      case DateTimeType.gregorian:
        return GregorianDateTime(dateTime: dateTime);
      case DateTimeType.jalali:
        return JalaliDateTime(dateTime: dateTime);
    }
  }

  static AppDateTime now() {
    switch (dateTimeType) {
      case DateTimeType.gregorian:
        return GregorianDateTime(dateTime: DateTime.now());
      case DateTimeType.jalali:
        return JalaliDateTime(dateTime: DateTime.now());
    }
  }

  static AppDateTime today() {
    switch (dateTimeType) {
      case DateTimeType.gregorian:
        return GregorianDateTime(dateTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
      case DateTimeType.jalali:
        return JalaliDateTime(dateTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
    }
  }

  Duration distanceTo(AppDateTime appDateTime) => dateTime.difference(appDateTime.dateTime);

  AppDateTime addDays(int day) => AppDateTime.fromDateTime(dateTime.add(Duration(days: day)));

  AppDateTime copy({int? year, int? day, int? hour, int? minute}) => AppDateTime.fromDateTime(dateTime.copyWith(year: year, day: day, hour: hour, minute: minute));

  String toServerString() => DateFormat('yyyy-MM-dd HH:mm:ss.sssss').format(dateTime);

  AppDateTime withDay(int day);

  AppDateTime addMonths(int months);

  AppDateTime toZeroHour();

  bool operator <=(AppDateTime other) => dateTime.difference(other.dateTime).inMilliseconds <= 0;

  bool operator >=(AppDateTime other) => dateTime.difference(other.dateTime).inMilliseconds >= 0;

  bool operator <(AppDateTime other) => dateTime.difference(other.dateTime).inMilliseconds < 0;

  bool operator >(AppDateTime other) => dateTime.difference(other.dateTime).inMilliseconds > 0;

  AppDateTime addYears(int year);

  @override
  String toString() => "$day  $mN $year";

  String toTimeOfDayString() => DateFormat('HH:mm').format(dateTime);

  String toDateString() => '$year/$month/$day';
}

class GregorianDateTime extends AppDateTime {
  const GregorianDateTime({required super.dateTime});

  @override
  AppDateTime addMonths(int months) => AppDateTime.fromDateTime(dateTime.copyWith(month: dateTime.month + months));

  @override
  AppDateTime addYears(int year) => AppDateTime.fromDateTime(dateTime.copyWith(year: dateTime.year + year));

  @override
  int get day => dateTime.day;

  @override
  String get dd => DateFormat('dd').format(dateTime);

  @override
  String get mN => DateFormat('MMMM').format(dateTime);

  @override
  int get month => dateTime.month;

  @override
  AppDateTime toZeroHour() => AppDateTime.fromDateTime(dateTime.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0));

  @override
  int get weekDay => dateTime.weekday;

  @override
  AppDateTime withDay(int day) => AppDateTime.fromDateTime(dateTime.copyWith(day: day));

  @override
  int get year => dateTime.year;

  @override
  String get yyyy => DateFormat('yyyy').format(dateTime);

  @override
  int get monthLength => DateTime(dateTime.year , dateTime.month + 1, 0).day;

  @override
  String get wN => throw UnimplementedError();


}

class JalaliDateTime extends AppDateTime {
  const JalaliDateTime({required super.dateTime});

  @override
  AppDateTime addMonths(int months) => JalaliDateTime(dateTime: dateTime.toJalali().addMonths(months).toDateTime());

  @override
  AppDateTime addYears(int year) => JalaliDateTime(dateTime: dateTime.toJalali().addYears(year).toDateTime());

  @override
  int get day => dateTime.toJalali().day;

  @override
  String get dd => dateTime.toJalali().formatter.dd;

  @override
  String get mN => dateTime.toJalali().formatter.mN;

  @override
  int get month => dateTime.toJalali().month;

  @override
  AppDateTime toZeroHour() => AppDateTime.fromDateTime(dateTime
      .toJalali()
      .copy(
        // hour: 0,
        // minute: 0,
        // second: 0,
        // millisecond: 0,
      )
      .toDateTime());

  @override
  int get weekDay => dateTime.toJalali().weekDay;

  @override
  AppDateTime withDay(int day) => AppDateTime.fromDateTime(dateTime.toJalali().withDay(day).toDateTime());

  @override
  int get year => dateTime.toJalali().year;

  @override
  String get yyyy => dateTime.toJalali().formatter.yyyy;

  @override
  int get monthLength => dateTime.toJalali().monthLength;

  @override
  String get wN => dateTime.toJalali().formatter.wN;
}
