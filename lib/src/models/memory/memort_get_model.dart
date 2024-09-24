

import 'package:shamsi_date/shamsi_date.dart';

class MemoryGetModel {

  late String title;
  late String text;
  late String fileName;
  late String date;
  late bool fromMan;
  late String id;
  late bool validPartner;
  late String textPartner;
  late String timePartner;
  String? localPath;
  bool isDate = false;


  String format1(Date d,nationality) {
    final f = d.formatter;

    if(nationality == 'IR'){
      return "${f.d} ${f.mN} ${f.yyyy}";
    }else{
      return "${f.d} ${f.mnAf} ${f.yyyy}";
    }
  }



  MemoryGetModel.fromJson(Map<String,dynamic> parsedJson,nationality){
    title = parsedJson['title'];
    text = parsedJson['text'];
    fileName = parsedJson['fileName'];
    DateTime _date = DateTime.parse(parsedJson['time']);
    date = format1(Jalali.fromDateTime(_date), nationality);
    print(date);
    fromMan = parsedJson['fromMan'];
    id = parsedJson['id'];
    validPartner = parsedJson['validPartner'];
    textPartner = parsedJson['textPartner'];
    timePartner = parsedJson['timePartner'];
  }

}