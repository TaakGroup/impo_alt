

import 'package:shamsi_date/shamsi_date.dart';

class PolarHistoryModel{

  late String time;
  late int polar;
  late String name;
  late int type;


  PolarHistoryModel.fromJson(Map<String,dynamic> parsedJson){
    DateTime timeDate = DateTime.parse(parsedJson['time']);
    time = Jalali.fromDateTime(timeDate).toString().replaceAll('Jalali','').replaceAll('(','').replaceAll(')','').replaceAll(',','/').replaceAll(' ','');
    polar = parsedJson['polar'];
    name = parsedJson['name'];
    type = parsedJson['type'];
  }

}