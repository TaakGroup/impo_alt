
import 'package:shamsi_date/shamsi_date.dart';

class SupportHistoryModel {

  late String text;
  late  String title;
  late String date;
  late String time;
  late String id;
  late int status;
  late String categoryName;
  late String statusText;
  late String statusColor;

  SupportHistoryModel.fromJson(Map<String,dynamic> parsedJson){
    text = parsedJson['text'];
    title = parsedJson['title'];
    DateTime createTime = DateTime.parse(parsedJson['createTime']);
    Jalali shamsi = Jalali.fromDateTime(createTime);
    date = shamsi.formatter.date.toString().replaceAll('(', '').replaceAll(')', '').replaceAll('Jalali','').replaceAll(',', '/').replaceAll(' ','');
    time = parsedJson['createTime'].toString().substring(11,16);
    id = parsedJson['id'];
    status = parsedJson['status'];
    categoryName = parsedJson['categoryName'];
    statusText = parsedJson['statusText'];
    statusColor = parsedJson['statusColor'];
  }

}