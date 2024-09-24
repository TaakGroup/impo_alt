import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:impo/src/core/app/utiles/classes/vibration.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../date_time_formatter.dart';
import '../date_picker_theme.dart';
import '../date_picker_constants.dart';
import '../i18n/date_picker_i18n.dart';

/// Solar months of 31 days.
const List<int> _solarMonthsOf31DaysJalali = const <int>[1, 2, 3, 4, 5, 6];
const List<int> _solarMonthsOf31Days = const <int>[1, 3, 5, 7, 8, 10, 12];

/// DatePicker widget.
class DatePickerWidget extends StatefulWidget {
  DatePickerWidget({
    Key? key,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.dateFormat= DATETIME_PICKER_DATE_FORMAT,
    this.locale= DATETIME_PICKER_LOCALE_DEFAULT,
    this.pickerTheme= DateTimePickerTheme.Default,
    this.onCancel,
    this.onChange,
    this.onConfirm,
    this.onChangeJalali,
    this.onConfirmJalali,
    this.initialJalaliTime,
    this.firstDateJalaliTime,
    this.lastDateJalaliTime,
    this.isJalali,
    this.looping= false,
    this.dividerColor
  }) : super(key: key) {
    DateTime minTime = firstDate ?? DateTime.parse(DATE_PICKER_MIN_DATETIME);
    DateTime maxTime = lastDate ?? DateTime.parse(DATE_PICKER_MAX_DATETIME);
    Jalali maxTimeJalali = lastDateJalaliTime ?? Jalali(1500, 12, 29);
    Jalali minTimeJalali = firstDateJalaliTime ?? Jalali(1300, 01, 01);
    assert(minTime.compareTo(maxTime) < 0);
    assert(minTimeJalali.compareTo(maxTimeJalali) < 0);
  }

  final DateTime? firstDate, lastDate, initialDate;
  final Jalali? firstDateJalaliTime, lastDateJalaliTime, initialJalaliTime;
  final String? dateFormat;
  final DateTimePickerLocale? locale;
  final DateTimePickerTheme? pickerTheme;

  final DateVoidCallback? onCancel;
  final DateValueCallback? onChange, onConfirm;
  final DateValueCallbackForDatePicker? onChangeJalali, onConfirmJalali;
  final bool? isJalali;
  final bool looping;
  Color? dividerColor;

  @override
  State<StatefulWidget> createState() => _DatePickerWidgetState(this.firstDate, this.lastDate, this.initialDate, this.initialJalaliTime,
      this.firstDateJalaliTime, this.lastDateJalaliTime, this.isJalali);
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  late DateTime _minDateTime, _maxDateTime;
  late Jalali _minJalaliTime, _maxJalaliTime;
  int? _currYear, _currMonth, _currDay;
  List<int>? _yearRange, _monthRange, _dayRange;
  FixedExtentScrollController? _yearScrollCtrl, _monthScrollCtrl, _dayScrollCtrl;
  late bool _isJalali;
  late Map<String, FixedExtentScrollController?> _scrollCtrlMap;
  late Map<String, List<int>?> _valueRangeMap;

  bool _isChangeDateRange = false;

  _DatePickerWidgetState(DateTime? minDateTime, DateTime? maxDateTime, DateTime? initialDateTime, Jalali? initialJalaliTime,
      Jalali? minJalaliTime, Jalali? maxJalaliTime, bool? isJalali) {
    // handle current selected year、month、day
    Jalali initJalaliDateTime = initialJalaliTime ?? Jalali.now();
    DateTime initDateTime = initialDateTime ?? DateTime.now();

    _isJalali = isJalali!;

    if (_isJalali) {
      initJalaliDateTime = initialJalaliTime ?? Jalali.now();
      this._currYear = initJalaliDateTime.year;
      this._currMonth = initJalaliDateTime.month;
      this._currDay = initJalaliDateTime.day;
    } else {
      initDateTime = initialDateTime ?? DateTime.now();
      this._currYear = initDateTime.year;
      this._currMonth = initDateTime.month;
      this._currDay = initDateTime.day;
    }

    // handle DateTime range
    if (_isJalali) {
      this._minJalaliTime = minJalaliTime ?? Jalali(1300, 01, 01);
      this._maxJalaliTime = maxJalaliTime ?? Jalali(1500, 12, 29);
    } else {
      this._minDateTime = minDateTime ?? DateTime.parse(DATE_PICKER_MIN_DATETIME);
      this._maxDateTime = maxDateTime ?? DateTime.parse(DATE_PICKER_MAX_DATETIME);
    }

    // limit the range of year
    this._yearRange = _calcYearRange();
    if (_isJalali) {
      this._currYear = min(max(_minJalaliTime.year, _currYear!), _maxJalaliTime.year);
    } else {
      this._currYear = min(max(_minDateTime.year, _currYear!), _maxDateTime.year);
    }

    // limit the range of month
    this._monthRange = _calcMonthRange();
    this._currMonth = min(max(_monthRange!.first, _currMonth!), _monthRange!.last);

    // limit the range of day
    this._dayRange = _calcDayRange();
    this._currDay = min(max(_dayRange!.first, _currDay!), _dayRange!.last);

    // create scroll controller
    _yearScrollCtrl = FixedExtentScrollController(initialItem: _currYear! - _yearRange!.first);
    _monthScrollCtrl = FixedExtentScrollController(initialItem: _currMonth! - _monthRange!.first);
    _dayScrollCtrl = FixedExtentScrollController(initialItem: _currDay! - _dayRange!.first);

    _scrollCtrlMap = {'y': _yearScrollCtrl, 'M': _monthScrollCtrl, 'd': _dayScrollCtrl};
    _valueRangeMap = {'y': _yearRange, 'M': _monthRange, 'd': _dayRange};
  }

  @override
  Widget build(BuildContext context) {
    widget.dividerColor = widget.dividerColor != null  ? widget.dividerColor : context.colorScheme.onSurface.withOpacity(0.16);
    return Container(
      //padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: widget.dividerColor!,width: 0.75),
                bottom: BorderSide(color: widget.dividerColor!,width: 0.75)
              )
            ),
          ),
          GestureDetector(
            child: Material(color: Colors.transparent, child: _renderPickerView(context)),
          ),
        ],
      ),
    );
  }

  /// render date picker widgets
  Widget _renderPickerView(BuildContext context) {
    Widget datePickerWidget = _renderDatePickerWidget();

    return datePickerWidget;
  }

  /// notify selected date changed
  Future<void> _onSelectedChange() async {
    if (widget.onChangeJalali != null) {
      // DateTime dateTime = DateTime(_currYear, _currMonth, _currDay);
      Jalali dateTime = Jalali(_currYear!, _currMonth!, _currDay!);
      widget.onChangeJalali!(dateTime, _calcSelectIndexList());
    }
    if (widget.onChange != null) {
      DateTime dateTime = DateTime(_currYear!, _currMonth!, _currDay!);
      CustomVibration().onChangedDatePicker();
      widget.onChange!(dateTime, _calcSelectIndexList());
    }
  }

  /// find scroll controller by specified format
  FixedExtentScrollController? _findScrollCtrl(String format) {
    FixedExtentScrollController? scrollCtrl;
    _scrollCtrlMap.forEach((key, value) {
      if (format.contains(key)) {
        scrollCtrl = value;
      }
    });
    return scrollCtrl;
  }

  /// find item value range by specified format
  List<int>? _findPickerItemRange(String format) {
    List<int>? valueRange;
    _valueRangeMap.forEach((key, value) {
      if (format.contains(key)) {
        valueRange = value;
      }
    });
    return valueRange;
  }

  /// render the picker widget of year、month and day
  Widget _renderDatePickerWidget() {
    List<Widget> pickers = [];
    List<String> formatArr = DateTimeFormatter.splitDateFormat(widget.dateFormat);
    formatArr.forEach((format) {
      List<int> valueRange = _findPickerItemRange(format)!;

      Widget pickerColumn = _renderDatePickerColumnComponent(
          scrollCtrl: _findScrollCtrl(format),
          valueRange: valueRange,
          format: format,
          valueChanged: (value) {
            if (format.contains('y')) {
              _changeYearSelection(value);
            } else if (format.contains('M')) {
              _changeMonthSelection(value);
            } else if (format.contains('d')) {
              _changeDaySelection(value);
            }
          },
          fontSize: widget.pickerTheme!.itemTextStyle.fontSize ?? sizeByFormat(widget.dateFormat!));
      pickers.add(pickerColumn);
    });
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: pickers);
  }

  Widget _renderDatePickerColumnComponent(
      {required FixedExtentScrollController? scrollCtrl,
      required List<int> valueRange,
      required String format,
      required ValueChanged<int> valueChanged,
      double? fontSize}) {
    return Expanded(
      flex: 1,
      child: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Positioned(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 18),
              height: widget.pickerTheme!.pickerHeight,
              decoration: BoxDecoration(color: widget.pickerTheme!.backgroundColor),
              child: CupertinoPicker(
                selectionOverlay: Container(),
                backgroundColor: widget.pickerTheme!.backgroundColor,
                scrollController: scrollCtrl,
                squeeze: 0.95,
                diameterRatio: 3,
                magnification: 1.3,
                itemExtent: widget.pickerTheme!.itemHeight,
                onSelectedItemChanged: valueChanged,
                looping: widget.looping,
                children: List<Widget>.generate(
                  valueRange.last - valueRange.first + 1,
                  (index) {
                    return _renderDatePickerItemComponent(
                      valueRange.first + index,
                      format,
                      fontSize,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double sizeByFormat(String format) {
    if (format.contains("-MMMM") || format.contains("MMMM-")) return DATETIME_PICKER_ITEM_TEXT_SIZE_SMALL;

    return DATETIME_PICKER_ITEM_TEXT_SIZE_BIG;
  }

  Widget _renderDatePickerItemComponent(int value, String format, double? fontSize) {
    int weekday;

    weekday = DateTime(_currYear!, _currMonth!, value).weekday;

    return Container(
      height: widget.pickerTheme!.itemHeight,
      alignment: Alignment.center,
      child: AutoSizeText(
        DateTimeFormatter.formatDateTime(value, format, widget.locale, weekday),
        maxLines: 1,
        // style: TextStyle(
        //     color: widget.pickerTheme!.itemTextStyle.color,
        //     fontSize: fontSize ?? widget.pickerTheme!.itemTextStyle.fontSize
        // ),
        style: widget.pickerTheme?.itemTextStyle ?? DATETIME_PICKER_ITEM_TEXT_STYLE,
      ),
    );
  }

  /// change the selection of year picker
  void _changeYearSelection(int index) {
    int year = _yearRange!.first + index;
    if (_currYear != year) {
      _currYear = year;
      _changeDateRange();
      _onSelectedChange();
    }
  }

  /// change the selection of month picker
  void _changeMonthSelection(int index) {
    int month = _monthRange!.first + index;
    if (_currMonth != month) {
      _currMonth = month;
      _changeDateRange();
      _onSelectedChange();
    }
  }

  /// change the selection of day picker
  void _changeDaySelection(int index) {
    if (_isChangeDateRange) {
      return;
    }

    int dayOfMonth = _dayRange!.first + index;
    if (_currDay != dayOfMonth) {
      _currDay = dayOfMonth;
      _onSelectedChange();
    }
  }

  /// change range of month and day
  void _changeDateRange() {
    if (_isChangeDateRange) {
      return;
    }
    _isChangeDateRange = true;

    List<int> monthRange = _calcMonthRange();
    bool monthRangeChanged = _monthRange!.first != monthRange.first || _monthRange!.last != monthRange.last;
    if (monthRangeChanged) {
      // selected year changed
      _currMonth = max(min(_currMonth!, monthRange.last), monthRange.first);
    }

    List<int> dayRange = _calcDayRange();
    bool dayRangeChanged = _dayRange!.first != dayRange.first || _dayRange!.last != dayRange.last;
    if (dayRangeChanged) {
      // day range changed, need limit the value of selected day
      _currDay = max(min(_currDay!, dayRange.last), dayRange.first);
    }

    setState(() {
      _monthRange = monthRange;
      _dayRange = dayRange;

      _valueRangeMap['M'] = monthRange;
      _valueRangeMap['d'] = dayRange;
    });

    if (monthRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currMonth = _currMonth!;
      _monthScrollCtrl!.jumpToItem(monthRange.last - monthRange.first);
      if (currMonth < monthRange.last) {
        _monthScrollCtrl!.jumpToItem(currMonth - monthRange.first);
      }
    }

    if (dayRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currDay = _currDay!;

      if (currDay < dayRange.last) {
        _dayScrollCtrl!.jumpToItem(currDay - dayRange.first);
      } else {
        _dayScrollCtrl!.jumpToItem(dayRange.last - dayRange.first);
      }
    }

    _isChangeDateRange = false;
  }

  /// calculate the count of day in current month
  int _calcDayCountOfMonth() {
    if (_isJalali) {
      if (_currMonth == 12) {
        return isLeapYearJalali(_currYear!) ? 30 : 29;
      } else if (_solarMonthsOf31DaysJalali.contains(_currMonth)) {
        return 31;
      } else {
        return 30;
      }
    } else {
      if (_currMonth == 2) {
        return isLeapYearMiladi(_currYear!) ? 29 : 28;
      } else if (_solarMonthsOf31Days.contains(_currMonth)) {
        return 31;
      }
      return 30;
    }
//    if(!_leapYears.contains(_currYear)){
//      if(_currMonth == 12){
//        return 29;
//      }
//    }
//    return 30;
  }

  /// whether or not is leap year
  bool isLeapYearJalali(int year) {
    final r = calculate(year);
    final isLeap = r.leap == 0;
    return isLeap;
  }

  bool isLeapYearMiladi(int year) {
    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  }

  /// calculate selected index list
  List<int> _calcSelectIndexList() {
    if (_isJalali) {
      int yearIndex = _currYear! - _minJalaliTime.year;
      int monthIndex = _currMonth! - _monthRange!.first;
      int dayIndex = _currDay! - _dayRange!.first;
      return [yearIndex, monthIndex, dayIndex];
    } else {
      int yearIndex = _currYear! - _minDateTime.year;
      int monthIndex = _currMonth! - _monthRange!.first;
      int dayIndex = _currDay! - _dayRange!.first;
      return [yearIndex, monthIndex, dayIndex];
    }
  }

  /// calculate the range of year
  List<int> _calcYearRange() {
    if (_isJalali) {
      return [_minJalaliTime.year, _maxJalaliTime.year];
    } else {
      return [_minDateTime.year, _maxDateTime.year];
    }
  }

  /// calculate the range of month
  List<int> _calcMonthRange() {
    if (_isJalali) {
      int minMonth = 1, maxMonth = 12;
      int minYear = _minJalaliTime.year;
      int maxYear = _maxJalaliTime.year;
      if (minYear == _currYear) {
        // selected minimum year, limit month range
        minMonth = _minJalaliTime.month;
      }
      if (maxYear == _currYear) {
        // selected maximum year, limit month range
        maxMonth = _maxJalaliTime.month;
      }
      return [minMonth, maxMonth];
    } else {
      int minMonth = 1, maxMonth = 12;
      int minYear = _minDateTime.year;
      int maxYear = _maxDateTime.year;
      if (minYear == _currYear) {
        // selected minimum year, limit month range
        minMonth = _minDateTime.month;
      }
      if (maxYear == _currYear) {
        // selected maximum year, limit month range
        maxMonth = _maxDateTime.month;
      }
      return [minMonth, maxMonth];
    }
  }

  /// calculate the range of day
  List<int> _calcDayRange({currMonth}) {
    if (_isJalali) {
      int minDay = 1, maxDay = _calcDayCountOfMonth();
      int minYear = _minJalaliTime.year;
      int maxYear = _maxJalaliTime.year;
      int minMonth = _minJalaliTime.month;
      int maxMonth = _maxJalaliTime.month;
      if (currMonth == null) {
        currMonth = _currMonth;
      }
      if (minYear == _currYear && minMonth == currMonth) {
        // selected minimum year and month, limit day range
        minDay = _minJalaliTime.day;
      }
      if (maxYear == _currYear && maxMonth == currMonth) {
        // selected maximum year and month, limit day range
        maxDay = _maxJalaliTime.day;
      }
      return [minDay, maxDay];
    } else {
      int minDay = 1, maxDay = _calcDayCountOfMonth();
      int minYear = _minDateTime.year;
      int maxYear = _maxDateTime.year;
      int minMonth = _minDateTime.month;
      int maxMonth = _maxDateTime.month;
      if (currMonth == null) {
        currMonth = _currMonth;
      }
      if (minYear == _currYear && minMonth == currMonth) {
        // selected minimum year and month, limit day range
        minDay = _minDateTime.day;
      }
      if (maxYear == _currYear && maxMonth == currMonth) {
        // selected maximum year and month, limit day range
        maxDay = _maxDateTime.day;
      }
      return [minDay, maxDay];
    }
  }

  ///////////////////////////////////////////////// Add from ShamsiDate
  static _JalaliCalculation calculate(int jy) {
    // Jalali years starting the 33-year rule.
    final List<int> breaks = [
      -61,
      9,
      38,
      199,
      426,
      686,
      756,
      818,
      1111,
      1181,
      1210,
      1635,
      2060,
      2097,
      2192,
      2262,
      2324,
      2394,
      2456,
      3178,
    ];

    final int bl = breaks.length;
    final int gy = jy + 621;
    int leapJ = -14;
    int jp = breaks[0];
    int jump = 0;

    // should not happen
    if (jy < -61 || jy >= 3178) {
      throw StateError('should not happen');
    }

    // Find the limiting years for the Jalali year jy.
    for (int i = 1; i < bl; i += 1) {
      final int jm = breaks[i];
      jump = jm - jp;
      if (jy < jm) {
        break;
      }
      leapJ = leapJ + (jump ~/ 33) * 8 + (((jump % 33)) ~/ 4);
      jp = jm;
    }
    int n = jy - jp;

    // Find the number of leap years from AD 621 to the beginning
    // of the current Jalali year in the Persian calendar.
    leapJ = leapJ + ((n) ~/ 33) * 8 + (((n % 33) + 3) ~/ 4);
    if ((jump % 33) == 4 && jump - n == 4) {
      leapJ += 1;
    }

    // And the same in the Gregorian calendar (until the year gy).
    final int leapG = ((gy) ~/ 4) - (((((gy) ~/ 100) + 1) * 3) ~/ 4) - 150;

    // Determine the Gregorian date of Farvardin the 1st.
    final int march = 20 + leapJ - leapG;

    // Find how many years have passed since the last leap year.
    if (jump - n < 6) {
      n = n - jump + ((jump + 4) ~/ 33) * 33;
    }
    int leap = ((((n + 1) % 33) - 1) % 4);
    if (leap == -1) {
      leap = 4;
    }

    return _JalaliCalculation(leap: leap, gy: gy, march: march);
  }
///////////////////////////////////////////////////////////////
}

class _JalaliCalculation {
  /// Number of years since the last leap year
  /// (0 (inclusive) to 4 (exclusive))
  final int leap;

  /// Gregorian year of the beginning of Jalali year
  final int gy;

  /// The March day of Farvardin the 1st (1st day of jy)
  final int march;

  const _JalaliCalculation({
    required this.leap,
    required this.gy,
    required this.march,
  });
}
