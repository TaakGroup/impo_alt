

import 'package:impo/src/models/circle_model.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:intl/intl.dart';
import '../calender/alarm_model.dart';

class SetMenstrualCalendarModel{

  late String name;
  late String birthDate;
  late String startDatePeriod;
  late int maritalStatus;
  late int cycleLenght;
  late int periodLenght;
  String? deviceToken;
  late String phoneNumber;
  late String email;
  late String password;
  late int nation;
  int? calendarType;
  List<Map<String,dynamic>> setMenstrualCalendar = [];

  SetMenstrualCalendarModel.fromJson(_name,_birthDate,_startDatePeriod,_maritalStatus,_cycleLenght,_periodLenght,_deviceToken,_phoneNumber,_email,_password,List<CycleViewModel> _circleModel,_nation,int? _calendarType, int status){

    name = _name;
    List listBirthDay;
    if(_birthDate.toString().contains(',')){
      listBirthDay = _birthDate.toString().split(',');
    }else{
      listBirthDay = _birthDate.toString().split('/');
    }
    Jalali _dateTime = Jalali(
        int.parse(listBirthDay[0]),
        int.parse(listBirthDay[1]),
        int.parse(listBirthDay[2])
    );
    birthDate = DateFormat('yyyy/MM/dd').format(_dateTime.toDateTime());


    maritalStatus = _maritalStatus;


    if(status == 1){
      startDatePeriod = DateFormat('yyyy/MM/dd').format(DateTime.parse(_startDatePeriod));

      cycleLenght = _cycleLenght;

      periodLenght = _periodLenght;
    }


    deviceToken = _deviceToken;

    phoneNumber = _phoneNumber;

    email = _email;

    password = _password;

    if(_circleModel != []){
      for(int i=0 ; i<_circleModel.length ; i++){
        String periodEndDate;
        if(_circleModel[i].periodEnd != null){
          periodEndDate = DateFormat('yyyy/MM/dd').format(DateTime.parse(_circleModel[i].periodEnd!));
        }else{
          DateTime _periodStart = DateTime.parse(_circleModel[i].periodStart!);
          periodEndDate = DateTime(_periodStart.year,_periodStart.month,_periodStart.day + 3).toString();
        }
        setMenstrualCalendar.add(
            {
              'PeriodStartDate' : DateFormat('yyyy/MM/dd').format(DateTime.parse(_circleModel[i].periodStart!)),
              'PeriodEndDate' : periodEndDate,
              'CycleStartDate' : DateFormat('yyyy/MM/dd').format(DateTime.parse(_circleModel[i].periodStart!)),
              'CycleEndDate' : DateFormat('yyyy/MM/dd').format(DateTime.parse(_circleModel[i].circleEnd!)),
              'CycleIndex' : i,
              'status' :_circleModel[i].status
            }
        );
      }
      // _circleModel.forEach((item) {
      //   setMenstrualCalendar.add(
      //       {
      //         'PeriodStartDate' : DateFormat('yyyy/MM/dd').format(DateTime.parse(item.periodStart)),
      //         'PeriodEndDate' :  DateFormat('yyyy/MM/dd').format(DateTime.parse(item.periodEnd)),
      //         'CycleStartDate' : DateFormat('yyyy/MM/dd').format(DateTime.parse(item.periodStart)),
      //         'CycleEndDate' : DateFormat('yyyy/MM/dd').format(DateTime.parse(item.circleEnd)),
      //         'CycleIndex' : item.id
      //       }
      //   );
      // });
    }


    nation = _nation;

    calendarType = _calendarType;


  }


}

//  @JsonProperty("Date")
//  private String Date;
//  @JsonProperty("Hour")
//  private int Hour;
//  @JsonProperty("Minute")
//  private int Minute;
//  @JsonProperty("Text")
//  private String Text;
//  @JsonProperty("Description")
//  private String Description;
//  @JsonProperty("IsActive")
//  private boolean IsActive;


//@JsonProperty("PeriodStartDate")
//private String PeriodStartDate;
//@JsonProperty("PeriodEndDate")
//private String PeriodEndDate;
//@JsonProperty("CycleStartDate")
//private String CycleStartDate;
//@JsonProperty("CycleEndDate")
//private String CycleEndDate;
//@JsonProperty("CycleIndex")
//private String CycleIndex;


//@JsonProperty("Name")
//private String Name;
//@JsonProperty("BirthDate")
//private String BirthDate;
//@JsonProperty("StartDatePeriod")
//private String StartDatePeriod;
//@JsonProperty("MaritalStatus")
//private int MaritalStatus;
//@JsonProperty("CycleLenght")
//private int CycleLenght;
//@JsonProperty("PeriodLenght")
//private int PeriodLenght;
//@JsonProperty("DeviceType")
//private int DeviceType;
//@JsonProperty("CycleType")
//private int CycleType;
//@JsonProperty("DeviceToken")
//private String DeviceToken;
//@JsonProperty("PhoneNumber")
//private String PhoneNumber;
//@JsonProperty("Email")
//private String Email;
//@JsonProperty("Password")
//private String Password;
//@JsonProperty("setMenstrualCalendar")
//private List<reqCircle_Item> setMenstrualCalendar;
//@JsonProperty("alarms")
//private List<reqAlarmItem> alarms;