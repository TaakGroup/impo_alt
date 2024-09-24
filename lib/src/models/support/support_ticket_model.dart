import 'package:impo/src/models/support/support_chat_model.dart';
import 'package:shamsi_date/shamsi_date.dart';

class SupportTicketModel{
  late String text;
  late String title;
  late String date;
  late String time;
  late int status;
  late String categoryName;
  late String id;
  late double rate;
  late String rateDescription;
  late  bool isRate;
  List<SupportChatModel> items = [];

  SupportTicketModel.fromJson(Map<String,dynamic> parsedJson){
    text = parsedJson['text'];
    title = parsedJson['title'];
    DateTime createTime = DateTime.parse(parsedJson['createTime']);
    Jalali shamsi = Jalali.fromDateTime(createTime);
    date = shamsi.formatter.date.toString().replaceAll('(', '').replaceAll(')', '').replaceAll('Jalali','').replaceAll(',', '/').replaceAll(' ','');
    time = parsedJson['createTime'].toString().substring(11,16);
    status = parsedJson['status'];
    categoryName = parsedJson['categoryName'];
    rate = parsedJson['rate'].toDouble();
    isRate = parsedJson['isRate'];
    id = parsedJson['id'];
    rateDescription = parsedJson['rateDescription'];
    parsedJson['items'].forEach((item){
      items.add(SupportChatModel.fromJson(item));
    });
  }

}