

import 'package:shamsi_date/shamsi_date.dart';

class TicketsModel{

  late String date;
  late String time;
  late int state;
  late String text;
  late bool isRate;
  late double rate;
  late String ticketId;
  late bool drValid;
  late String drName;
  late String drImage;
  late String drSpeciality;
  String drAcadimicCertificate = '';
  String? clinicName;
  int? clinicId;

  TicketsModel.fromJson(Map<String,dynamic> parsedJson){
    DateTime createTime = DateTime.parse(parsedJson['createTime']);
    Jalali shamsi = Jalali.fromDateTime(createTime);
    date = shamsi.formatter.date.toString().replaceAll('(', '').replaceAll(')', '').replaceAll('Jalali','').replaceAll(',', '/').replaceAll(' ','');
    time = parsedJson['createTime'].toString().substring(11,16);
    state = parsedJson['state'];
    text = parsedJson['text'];
    ticketId = parsedJson['ticketId'];
    drValid = parsedJson['drValid'];
    drName = parsedJson['drName'];
    rate = parsedJson['rate'] != null ? double.parse(parsedJson['rate'].toString()) : parsedJson['rate'];
    isRate = parsedJson['isRate'];
    drImage = parsedJson['drImage'];
    drSpeciality = parsedJson['drSpeciality'];
    drAcadimicCertificate = parsedJson['drAcadimicCertificate'] != null ? parsedJson['drAcadimicCertificate'] : '';
    clinicName = parsedJson['clinicName'];
    clinicId = parsedJson['clinicId'];
  }
}