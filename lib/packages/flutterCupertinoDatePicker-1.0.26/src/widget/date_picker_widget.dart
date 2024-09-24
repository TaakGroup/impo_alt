
///

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../date_time_formatter.dart';
import '../date_picker_theme.dart';
import '../date_picker_constants.dart';
import '../i18n/date_picker_i18n.dart';
import 'date_picker_title_widget.dart';
import 'package:shamsi_date/shamsi_date.dart';

/// Solar months of 31 days.
const List<int> _solarMonthsOf31DaysJalali = const <int>[1, 2, 3, 4, 5, 6];
const List<int> _solarMonthsOf31Days = const <int>[1, 3, 5, 7, 8, 10, 12];
const List<int> _leapYears = const <int>[1375,1379,1383,1387,1391,1395,1399,1404,1409,1414,1419];

/// DatePicker widget.
///
/// @author dylan wu
/// @since 2019-05-10
class DatePickerWidget extends StatefulWidget {
  DatePickerWidget({
    Key? key,
    this.minDateTime,
    this.maxDateTime,
    this.initialDateTime,
    this.dateFormat = DATETIME_PICKER_DATE_FORMAT,
    this.locale = DATETIME_PICKER_LOCALE_DEFAULT,
    this.pickerTheme = DateTimePickerTheme.Default,
    this.onCancel,
    this.onChange,
    this.onChangeJalali,
    this.onConfirmJalali,
    this.onConfirm,
    this.statusRegister,
    this.initialJalaliTime,
    this.minDateJalaliTime,
    this.maxDateJalaliTime,
    this.isJalali
  }) : super(key: key) {
    DateTime minTime = minDateTime ?? DateTime.parse(DATE_PICKER_MIN_DATETIME);
    DateTime maxTime = maxDateTime ?? DateTime.parse(DATE_PICKER_MAX_DATETIME);
    Jalali maxTimeJalali = maxDateJalaliTime ?? Jalali(1500,12,29);
    Jalali minTimeJalali = minDateJalaliTime ?? Jalali(1300,01,01);
    assert(minTime.compareTo(maxTime) < 0);
    assert(minTimeJalali.compareTo(maxTimeJalali) < 0);
  }

  final DateTime? minDateTime, maxDateTime, initialDateTime;
  final Jalali? minDateJalaliTime, maxDateJalaliTime,initialJalaliTime;
  final String dateFormat;
  final DateTimePickerLocale locale;
  final DateTimePickerTheme pickerTheme;

  final DateVoidCallback? onCancel;
  final DateValueCallback? onChange, onConfirm;
  final DateValueCallbackForDatePicker? onChangeJalali , onConfirmJalali;
  final bool? statusRegister;
  final bool? isJalali;

  @override
  State<StatefulWidget> createState() => _DatePickerWidgetState(
      this.minDateTime, this.maxDateTime, this.initialDateTime , this.initialJalaliTime,
      this.minDateJalaliTime,this.maxDateJalaliTime,this.isJalali!
  );
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  late DateTime _minDateTime, _maxDateTime;
  late Jalali _minJalaliTime, _maxJalaliTime;
  late int _currYear, _currMonth, _currDay;
  late List<int> _yearRange, _monthRange, _dayRange;
  late FixedExtentScrollController _yearScrollCtrl, _monthScrollCtrl, _dayScrollCtrl;

  late Map<String, FixedExtentScrollController> _scrollCtrlMap;
  late Map<String, List<int>> _valueRangeMap;
  late bool _isJalali;

  bool _isChangeDateRange = false;

  _DatePickerWidgetState(
      DateTime? minDateTime, DateTime? maxDateTime, DateTime? initialDateTime , Jalali? initialJalaliTime
      , Jalali? minJalaliTime , Jalali? maxJalaliTime , bool isJalali  ) {
    // handle current selected year、month、day
    Jalali initJalaliDateTime;
    DateTime initDateTime;

    _isJalali = isJalali;

    if(_isJalali){
      initJalaliDateTime = initialJalaliTime ?? Jalali.now();
      this._currYear = initJalaliDateTime.year;
      this._currMonth = initJalaliDateTime.month;
      this._currDay = initJalaliDateTime.day;
    }else{
      initDateTime = initialDateTime ?? DateTime.now();
      this._currYear = initDateTime.year;
      this._currMonth = initDateTime.month;
      this._currDay = initDateTime.day;
    }


    // handle DateTime range
    if(_isJalali){
      this._minJalaliTime = minJalaliTime ?? Jalali(1300,01,01);
      this._maxJalaliTime = maxJalaliTime ?? Jalali(1500,12,29);
    }else{
      this._minDateTime = minDateTime ?? DateTime.parse(DATE_PICKER_MIN_DATETIME);
      this._maxDateTime = maxDateTime ?? DateTime.parse(DATE_PICKER_MAX_DATETIME);
    }

    // limit the range of year
    this._yearRange = _calcYearRange();
    if(_isJalali){
      this._currYear = min(max(_minJalaliTime.year, _currYear), _maxJalaliTime.year);
    }else{
      this._currYear = min(max(_minDateTime.year, _currYear), _maxDateTime.year);
    }

    // limit the range of month
    this._monthRange = _calcMonthRange();
    this._currMonth = min(max(_monthRange.first, _currMonth), _monthRange.last);

    // limit the range of day
    this._dayRange = _calcDayRange();
    this._currDay = min(max(_dayRange.first, _currDay), _dayRange.last);

    // create scroll controller
    _yearScrollCtrl =
        FixedExtentScrollController(initialItem: _currYear - _yearRange.first);
    _monthScrollCtrl = FixedExtentScrollController(
        initialItem: _currMonth - _monthRange.first);
    _dayScrollCtrl =
        FixedExtentScrollController(initialItem: _currDay - _dayRange.first);

    _scrollCtrlMap = {
      'y': _yearScrollCtrl,
      'M': _monthScrollCtrl,
      'd': _dayScrollCtrl
    };
    _valueRangeMap = {'y': _yearRange, 'M': _monthRange, 'd': _dayRange};
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: new Container(
          width: MediaQuery.of(context).size.width,
          decoration: new BoxDecoration(
          ),
          child: _renderPickerView(context)
      ),
    );
  }

  /// render date picker widgets
  Widget _renderPickerView(BuildContext context) {
    Widget datePickerWidget = _renderDatePickerWidget();

    // display the title widget
    if (widget.pickerTheme.title != null || widget.pickerTheme.showTitle) {
      Widget titleWidget = DatePickerTitleWidget(
        pickerTheme: widget.pickerTheme,
        locale: widget.locale,
        onCancel: () => _onPressedCancel(),
        onConfirm: () => _onPressedConfirm(),
      );
      return Column(
          children: <Widget>[
            titleWidget,
            datePickerWidget,
//            widget.statusRegister ?
//            new Container()
//                : new Container(
//                height: ScreenUtil().setWidth(100),
//                width:  MediaQuery.of(context).size.width - ScreenUtil().setWidth(200),
//                decoration: new BoxDecoration(
//                    gradient:   LinearGradient(
//                        colors: [
//                          new Color(0xff494949),
//                          new Color(0xff353535),
//                        ],
//                        begin: Alignment.topCenter,
//                        end: Alignment.bottomCenter
//                    ),
//                    borderRadius: BorderRadius.only(
//                        bottomLeft: Radius.circular(20),
//                        bottomRight: Radius.circular(20)
//                    )
//                ),
//                child: new Align(
//                    alignment: Alignment.center,
//                    child: new Padding(
//                      padding: EdgeInsets.only(
//                          left: ScreenUtil().setWidth(30)
//                      ),
//                      child: new Row(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          new OutLineButton(
//                            title: 'لغو',
//                            onPress: widget.onCancel,
//                            height: ScreenUtil().setHeight(90),
//                            width: ScreenUtil().setWidth(300),
//                            fontSize: ScreenUtil().setSp(52),
//                            colorBorder: ColorsPalette().red,
//                            colorText: Color(0xff999999),
//                          ),
//                          new SizedBox(
//                            width: ScreenUtil().setWidth(40),
//                          ),
//                          new OutLineButton(
//                            title: 'تایید',
//                            onPress: widget.onConfirm,
//                            height: ScreenUtil().setHeight(90),
//                            width:ScreenUtil().setWidth(300),
//                            fontSize: ScreenUtil().setSp(52),
//                            colorBorder: ColorsPalette().primaryLight2,
//                            colorText: Color(0xff999999),
//                          ),
//                        ],
//                      ),
//                    )
//                )
//            )
          ]);
    }
    return datePickerWidget;
  }

  /// pressed cancel widget
  void _onPressedCancel() {
    if (widget.onCancel != null) {
      widget.onCancel!();
    }
//    Navigator.pop(context);
  }

  /// pressed confirm widget
  void _onPressedConfirm() {
    if (widget.onConfirmJalali != null) {
      // DateTime dateTime = DateTime(_currYear, _currMonth, _currDay);
      Jalali dateTime = Jalali(_currYear, _currMonth, _currDay);
      widget.onConfirmJalali!(dateTime, _calcSelectIndexList());
    }
    if (widget.onConfirm != null) {
      DateTime dateTime = DateTime(_currYear, _currMonth, _currDay);
      widget.onConfirm!(dateTime, _calcSelectIndexList());
    }
//    Navigator.pop(context);
  }

  /// notify selected date changed
  void _onSelectedChange() {
    if (widget.onChangeJalali != null) {
      // DateTime dateTime = DateTime(_currYear, _currMonth, _currDay);
      Jalali dateTime = Jalali(_currYear, _currMonth, _currDay);
      widget.onChangeJalali!(dateTime, _calcSelectIndexList());
    }
    if (widget.onChange != null) {
      DateTime dateTime = DateTime(_currYear, _currMonth, _currDay);
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
    List<Widget> pickers = <Widget>[];
    List<String> formatArr =
    DateTimeFormatter.splitDateFormat(widget.dateFormat);
    formatArr.forEach((format) {
      List<int>? valueRange = _findPickerItemRange(format);

      Widget pickerColumn = _renderDatePickerColumnComponent(
        scrollCtrl: _findScrollCtrl(format)!,
        valueRange: valueRange!,
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
      );
      pickers.add(pickerColumn);
    });
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: pickers);
  }

  Widget _renderDatePickerColumnComponent({
    required FixedExtentScrollController scrollCtrl,
    required List<int> valueRange,
    required String format,
    required ValueChanged<int> valueChanged,
  }) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.all(0.0),
        height: widget.pickerTheme.pickerHeight,
        decoration: BoxDecoration(
          color : widget.statusRegister! ? Colors.transparent : null ,
          gradient: widget.statusRegister! ? null:
          LinearGradient(
              colors: [
                new Color(0xff494949),
                new Color(0xff353535),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          ),
        ),
        child: CupertinoPicker.builder(
          // borderColor: Color(0xffc33091),
          backgroundColor: widget.statusRegister! ? Colors.white.withOpacity(0.25):  Color(0xff494949),
          scrollController: scrollCtrl,
          itemExtent: widget.pickerTheme.itemHeight,
          onSelectedItemChanged: valueChanged,
          childCount: valueRange.last - valueRange.first + 1,
          itemBuilder: (context, index) =>
              _renderDatePickerItemComponent(valueRange.first + index, format),
        ),
      ),
    );
  }

  Widget _renderDatePickerItemComponent(int value, String format) {
    return Container(
      height: widget.pickerTheme.itemHeight,
      alignment: Alignment.center,
      child: Text(
        DateTimeFormatter.formatDateTime(value, format, widget.locale),
        style:
        widget.pickerTheme.itemTextStyle ?? DATETIME_PICKER_ITEM_TEXT_STYLE,
      ),
    );
  }

  /// change the selection of year picker
  void _changeYearSelection(int index) {
    int year = _yearRange.first + index;
    if (_currYear != year) {
      _currYear = year;
      _changeDateRange();
      _onSelectedChange();
    }
  }

  /// change the selection of month picker
  void _changeMonthSelection(int index) {
    int month = _monthRange.first + index;
    if (_currMonth != month) {
      _currMonth = month;
      _changeDateRange();
      _onSelectedChange();
    }
  }

  /// change the selection of day picker
  void _changeDaySelection(int index) {
    int dayOfMonth = _dayRange.first + index;
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
    bool monthRangeChanged = _monthRange.first != monthRange.first ||
        _monthRange.last != monthRange.last;
    if (monthRangeChanged) {
      // selected year changed
      _currMonth = max(min(_currMonth, monthRange.last), monthRange.first);
    }

    List<int> dayRange = _calcDayRange();
    bool dayRangeChanged =
        _dayRange.first != dayRange.first || _dayRange.last != dayRange.last;
    if (dayRangeChanged) {
      // day range changed, need limit the value of selected day
      _currDay = max(min(_currDay, dayRange.last), dayRange.first);
    }

    setState(() {
      _monthRange = monthRange;
      _dayRange = dayRange;

      _valueRangeMap['M'] = monthRange;
      _valueRangeMap['d'] = dayRange;
    });

    if (monthRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currMonth = _currMonth;
      _monthScrollCtrl.jumpToItem(monthRange.last - monthRange.first);
      if (currMonth < monthRange.last) {
        _monthScrollCtrl.jumpToItem(currMonth - monthRange.first);
      }
    }

    if (dayRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currDay = _currDay;
      _dayScrollCtrl.jumpToItem(dayRange.last - dayRange.first);
      if (currDay < dayRange.last) {
        _dayScrollCtrl.jumpToItem(currDay - dayRange.first);
      }
    }

    _isChangeDateRange = false;
  }

  /// calculate the count of day in current month
  int _calcDayCountOfMonth() {
    if(_isJalali){
      if (_currMonth == 12) {
        return isLeapYear(_currYear) ? 29 : 30;
      } else if (_solarMonthsOf31DaysJalali.contains(_currMonth)) {
        return 31;
      }else{
        return 30;
      }
    }else{
      if (_currMonth == 2) {
        return isLeapYear(_currYear) ? 29 : 28;
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
  bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  }

  /// calculate selected index list
  List<int> _calcSelectIndexList() {
    if(_isJalali){
      int yearIndex = _currYear - _minJalaliTime.year;
      int monthIndex = _currMonth - _monthRange.first;
      int dayIndex = _currDay - _dayRange.first;
      return [yearIndex, monthIndex, dayIndex];
    }else{
      int yearIndex = _currYear - _minDateTime.year;
      int monthIndex = _currMonth - _monthRange.first;
      int dayIndex = _currDay - _dayRange.first;
      return [yearIndex, monthIndex, dayIndex];
    }
  }

  /// calculate the range of year
  List<int> _calcYearRange() {
    if(_isJalali){
      return [_minJalaliTime.year, _maxJalaliTime.year];
    }else{
      return [_minDateTime.year, _maxDateTime.year];
    }
  }

  /// calculate the range of month
  List<int> _calcMonthRange() {
    if(_isJalali){
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
    }else{
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
    if(_isJalali){
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
    }else{
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
}
