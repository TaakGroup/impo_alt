part of 'date_picker_i18n.dart';

/// Farsi (Fa) Iran
class _StringsFa extends _StringsI18n {
  const _StringsFa();

  @override
  String getCancelText() {
    return 'لغو';
  }

  @override
  String getDoneText() {
    return 'تایید';
  }

  @override
  List<String> getMonths() {
    return [
      'فروردین',
      'اردیبهشت',
      'خرداد',
      'تیر',
      'مرداد',
      'شهریور',
      'مهر',
      'آبان',
      'آذر',
      'دی',
      'بهمن',
      'اسفند'
    ];
  }

  @override
  List<String> getWeeksFull() {
    return [
      'دوشنبه',
      'سه شنبه',
      'چهارشنبه',
      'پنج شنبه',
      'جمعه',
      'شنبه',
      'یکشنبه'
    ];
  }

  @override
  List<String> getWeeksShort() {
    return [
      'دوشنبه',
      'سه شنبه',
      'چهارشنبه',
      'پنج شنبه',
      'جمعه',
      'شنبه',
      'یکشنبه'
    ];
  }
}
