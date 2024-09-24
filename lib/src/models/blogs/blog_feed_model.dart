import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:intl/intl.dart';

class BlogFeedModel{

  late String image;
  late String title;
  late String date;
  late String link;

  _format1(Date d) {
    var registerInfo = locator<RegisterParamModel>();
    String _nationality = registerInfo.register.nationality!;
    final f = d.formatter;

    if(_nationality == 'IR'){
      return "${f.d} ${f.mN} ${f.yyyy}";
    }else{
      return "${f.d} ${f.mnAf} ${f.yyyy}";
    }
  }

  BlogFeedModel.fromJson(Map<String,dynamic> parsedJson){
    image = parsedJson['description'].split('"')[1];
    title = parsedJson['title'];
    link = parsedJson['link2'];
    DateFormat formatter = DateFormat('d LLL yyyy H:m:s');
    DateTime dateMilady =  formatter.parse(parsedJson['pubDate'].toString().split(', ')[1]);
    Jalali dateShamsi = Jalali.fromDateTime(dateMilady);
    date = _format1(dateShamsi);
  }

}

// import 'package:shamsi_date/shamsi_date.dart';
// import 'package:intl/intl.dart';
//
// class BlogFeedModel{
//
//   String image;
//   String title;
//   String creator;
//   String date;
//   String link;
//   int counterForIcon;
//
//   _format1(Date d) {
//     final f = d.formatter;
//
//     // if(_nationality == 'IR'){
//       return "${f.d} ${f.mN} ${f.yyyy}";
//     // }else{
//     //   return "${f.d} ${f.mnAf} ${f.yyyy}";
//     // }
//   }
//
//   BlogFeedModel.fromJson(_image,_title,_creator,DateTime _date,_link,_counterForIcon){
//     image = _image;
//     title = _title;
//     creator = _creator;
//     // print(_date.split(', ')[1]);
//     // DateFormat formatter = DateFormat('d LLL yyyy H:m:s');
//     // DateTime dateMilady =  formatter.parse(_date.split(', ')[1]);
//     // print(dateMilady);
//     Jalali dateShamsi = Jalali.fromDateTime(_date);
//     date = _format1(dateShamsi);
//     link = _link;
//     counterForIcon = _counterForIcon;
//   }
//
// }