

import 'package:shamsi_date/shamsi_date.dart';
import 'package:intl/intl.dart';

class RegisterSendServerModel {

  late int status;
  late String firstName;
  late String lastName;
  late String identity;
  late String password;
  late String interFaceCode;
  String? deviceToken;
  late String birthDate;

  late int periodLength;
  late String startPeriodDate;
  late int totalCycleLength;

  late bool isDeliveryDate;
  late String pregnancyDate;
  late int hasAboration;
  late int pregnancyNo;


  late int sexualStatus;
  late String phoneModel;
  late int nationality;
  late int periodStatus;

  // String name;
  // String birthDate;
  // String startDatePeriod;
  // int maritalStatus;
  // int cycleLenght;
  // int periodLenght;
  // int deviceType;
  // int cycleType;
  // String periodStartDate;
  // String periodEndDate;
  // String cycleStartDate;
  // String cycleEndDate;
  // String deviceToken;
  // int nation;


  Map<String,dynamic> generateJson(
      int _status,
      String _name,
      String _identity,
      String _password,
      String _interFaceCode,
      String? _deviceToken,
      String _birthDate,

      int? _periodLength,
      String? _startPeriodDate,
      int? _totalCycleLength,

      bool? _isDeliveryDate,
      DateTime? _pregnancyDate,
      int? _hasAboration,
      int? _pregnancyNo,

      int _sexualStatus,
      String _phoneModel,
      String _nationality,
      int? _periodStatus,
      ){

    Map<String,dynamic> json = {};

    json['status'] = _status;
    status = _status;

    json['firstName'] = _name;
    firstName = _name;

    json['lastName'] = '';
    lastName = '';

    json['identity'] = _identity;
    identity = _identity;

    json['password'] = _password;
    password = _password;

    json['interfacecode'] = _interFaceCode;
    interFaceCode = _interFaceCode;

    json['deviceToken'] = _deviceToken;
    deviceToken = _deviceToken;

    List birthDay = _birthDate.split(',');
    Jalali _dateTime = Jalali(
        int.parse(birthDay[0]),
        int.parse(birthDay[1]),
        int.parse(birthDay[2])
    );
    json['birthDate'] = DateFormat('yyyy/MM/dd').format(_dateTime.toDateTime());
    birthDate = DateFormat('yyyy/MM/dd').format(_dateTime.toDateTime());



    if(_status == 2){
      json['isDeliveryDate'] = _isDeliveryDate;
      isDeliveryDate = _isDeliveryDate!;

      print(_pregnancyDate);
      // List _date = _pregnancyDate.split('/');
      // Jalali _shamsi = Jalali(
      //   int.parse(_date[0]),
      //     int.parse(_date[1]),
      //     int.parse(_date[2])
      // );


      json['pregnancyDate'] = _pregnancyDate.toString();
      pregnancyDate = _pregnancyDate.toString();

      json['HasAboration'] = _hasAboration;
      hasAboration = _hasAboration!;

      json['pregnancyNo'] = _pregnancyNo;
      pregnancyNo = _pregnancyNo!;

    }else{

      json['periodLength'] = _periodLength;
      periodLength = _periodLength!;

      json['startPeriodDate'] = DateFormat('yyyy/MM/dd').format(DateTime.parse(_startPeriodDate!));
      startPeriodDate = DateFormat('yyyy/MM/dd').format(DateTime.parse(_startPeriodDate));

      json['totalCycleLength'] = _totalCycleLength;
      totalCycleLength = _totalCycleLength!;
    }




    json['sexualStatus'] = _sexualStatus;
    sexualStatus = _sexualStatus;


    json['phoneModel'] = _phoneModel;
    phoneModel = _phoneModel;


    json['nationality'] = _nationality == 'IR' ? 0 : 1;
    nationality = _nationality == 'IR' ? 0 : 1;

    json['periodStatus'] = _periodStatus;
    periodStatus = _periodStatus!;


    return json;


    // List newItems = [];
    // List<int> old = [];
    //
    // for(int i=0 ; i<newItems.length ; i++){
    //   if(newItems[i].state == 2){
    //     if(old.contains(newItems[i].orderId)){
    //       //showToast
    //       for(int j=0 ; j<old.length ; j++){
    //         if(old[j] == newItems[i].orderId){
    //           old.removeAt(j);
    //         }
    //       }
    //     }
    //   }
      // if(old.contains(newItems[i].orderId)){
      //
      // }else{
      //   old.add(newItems[i].orderId);
      // }
    // }

  }

  //  @JsonProperty("Name")
//  private String Name;
//  @JsonProperty("BirthDate")
//  private String BirthDate;
//  @JsonProperty("StartDatePeriod")
//  private String StartDatePeriod;
//  @JsonProperty("MaritalStatus")
//  private int MaritalStatus;
//  @JsonProperty("CycleLenght")
//  private int CycleLenght;
//  @JsonProperty("PeriodLenght")
//  private int PeriodLenght;
//  @JsonProperty("DeviceType")
//  private int DeviceType;
//  @JsonProperty("CycleType") ///0
//  private int CycleType;
//  @JsonProperty("PeriodStartDate")
//  private String PeriodStartDate;
//  @JsonProperty("PeriodEndDate")
//  private String PeriodEndDate;
//  @JsonProperty("CycleStartDate")
//  private String CycleStartDate;
//  @JsonProperty("CycleEndDate")
//  private String CycleEndDate;
//  @JsonProperty("DeviceToken")
//  private String DeviceToken;

}