

import 'package:shamsi_date/extensions.dart';

class GetMessagesPartnerModel {
  late String messageId;
  late String text;
  late String fileName;
  late String createTime;
  late bool readFlag;
  late bool fromMan;



  GetMessagesPartnerModel.fromJson(Map<String,dynamic> parsedJson){
    messageId = parsedJson['messageId'];
    text = parsedJson['text'];
    fileName = parsedJson['fileName'];
    DateTime dateTime =  DateTime.parse(parsedJson['createTime']);
    DateTime today = DateTime.now();
    // DateTime today = DateTime(2022,03,09);
    DateTime yesterday = DateTime(today.year,today.month,today.day - 1);
    String date = '';
    if(dateTime.year == today.year && dateTime.month == today.month && dateTime.day == today.day){
      date = 'امروز';
    }else if(dateTime.year == yesterday.year && dateTime.month == yesterday.month && dateTime.day == yesterday.day){
      date = 'دیروز';
    }else{
      Jalali shamsiDateTime =  Jalali.fromDateTime(dateTime);
      date = shamsiDateTime.toString().replaceAll('Jalali','').
      replaceAll(',','/').replaceAll(')','').replaceAll('(','').replaceAll(' ','');
    }

    String time = parsedJson['createTime'].toString().substring(11,16);
    createTime = '$time $date';
    readFlag = parsedJson['readFlag'];
    fromMan = parsedJson['fromMan'];
  }
}