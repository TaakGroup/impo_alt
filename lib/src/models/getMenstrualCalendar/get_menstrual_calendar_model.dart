

import 'package:impo/src/models/calender/alarm_model.dart';
import 'package:impo/src/models/getMenstrualCalendar/get_backup_circle_item.dart';
import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

class GetMenstrualCalendarModel{

  late String _name;

  late int _periodLng;
  late int _cycleLng;
  late String _startDatePeriod;

  late DateTime _childBirthDate;
  late int _childType;
  late int _childBirthType;
  late String _childName;

  late bool _isDeliveryDate;
  late DateTime _pregnancyDate;
  late int _hasAboration;
  late int _pregnancyNo;

  late String _birthDate;
  late int _maritalStatus;
  late String _token;
  late int _nationality;
  List<GetBackupCircleItem> _calander = [];
  List<AlarmViewModel> _alarms = [];
  List<DailyRemindersViewModel> _reminders = [];
  late int _nation;
  late int _sign;
  late int _calendarType;
  late String _signText;
  int? _periodStatus;


  GetMenstrualCalendarModel();


  int get getNation => _nation;

   setNation(int value) {
    _nation = value;
  }

  List<AlarmViewModel> get getAlarms => _alarms;

   setAlarms(List<AlarmViewModel> value) {
    _alarms = value;
  }

  List<GetBackupCircleItem> get getCalander => _calander;

   setCalander(List<dynamic> value) {
     for(int i = 0 ; i<value.length ; i++){
       _calander.add(GetBackupCircleItem.fromJson(
           {
             'periodStartDate' : value[i]['periodStartDate'],
             'periodEndDate' :  value[i]['periodEndDate'],
             'cycleStartDate' :  value[i]['cycleStartDate'],
             'cycleEndDate' :  value[i]['cycleEndDate'],
             'status' : value[i]['status'],
             'cycleIndex' :  value[i]['cycleIndex'],
           }
       ));
     }
  }

  String get getStartDatePeriod => _startDatePeriod;

     setStartDatePeriod(String value) {
    _startDatePeriod = value;
  }

  String get getToken => _token;

   setToken(String value) {
    _token = value;
  }


  int get getMaritalStatus => _maritalStatus;

   setMaritalStatus(int value) {
    _maritalStatus = value;
  }

  String get getBirthDate => _birthDate;

   setBirthDate(String value) {
     _birthDate = value;
  }

  int get getCycleLng => _cycleLng;

   stCycleLng(int value) {
    _cycleLng = value;
  }

  int get getPeriodLng => _periodLng;

   setPeriodLng(int value) {
    _periodLng = value;
  }

  String get getName => _name;

   setName(String value) {
    _name = value;
  }

  List<DailyRemindersViewModel> get getReminders => _reminders;

   setReminders(List<DailyRemindersViewModel> value) {
    _reminders = value;
  }

  int get getNationality => _nationality;

   setNationality(int value) {
    _nationality = value;
  }

  int get getSign => _sign;

  setSign(int value) {
    _sign = value;
  }

  int get getCalendarType => _calendarType;

  setCalendarType(int value) {
    _calendarType = value;
  }

  String get getSignText => _signText;

  setSignText(String signText) {
    _signText = signText;
  }

  int? get getPeriodStatus => _periodStatus;

  setPeriodStatus(int? periodStatus) {
    _periodStatus = periodStatus;
  }


  bool get getIsDeliveryDate => _isDeliveryDate;

  setIsDeliveryDate(bool value) {
    _isDeliveryDate = value;
  }

  DateTime get getPregnancyDate => _pregnancyDate;

  setPregnancyDate(DateTime value) {
    _pregnancyDate = value;
  }

  int get getHasAboration => _hasAboration;

  setHasAboration(int value) {
    _hasAboration = value;
  }

  int get getPregnancyNo => _pregnancyNo;

  setPregnancyNo(int value) {
    _pregnancyNo = value;
  }


  DateTime get getChildBirthDate => _childBirthDate;

  setChildBirthDate(DateTime value) {
    _childBirthDate = value;
  }

  int get getChildType => _childType;

  setChildType(int value) {
    _childType = value;
  }

  int get getChildBirthType => _childBirthType;

  setChildBirthType(int value) {
    _childBirthType = value;
  }
  String get getChildName => _childName;

  setChildName(String value) {
    _childName = value;
  }

//  @JsonProperty("successed")
//  private boolean successed;
//  @JsonProperty("name")
//  private String name;
//  @JsonProperty("periodLng")
//  private int periodLng;
//  @JsonProperty("cycleLng")
//  private int cycleLng;
//  @JsonProperty("date")
//  private String date;
//  @JsonProperty("maritalStatus")
//  private int maritalStatus;
//  @JsonProperty("phone")
//  private String phone;
//  @JsonProperty("email")
//  private String email;
//  @JsonProperty("cycleType")
//  private int cycleType;
//  @JsonProperty("token")
//  private String token;
//  @JsonProperty("startDatePeriod")
//  private String startDatePeriod;
//  @JsonProperty("calander")
//  private List<GetBackUp_CircleItem> calander;
//  @JsonProperty("alarms")
//  private List<GetBackUp_AlarmItem> alarms;

}