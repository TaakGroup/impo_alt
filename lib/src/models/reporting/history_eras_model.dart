
import 'package:shamsi_date/shamsi_date.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:intl/intl.dart';
import '../expert/info.dart';

class ReportHistory{
  late InfoAdviceTypes clinic;
  List<HistoryErasModel> eras = [];
  int counterForShopScreen = 0;

  ReportHistory.fromJson(Map<String,dynamic> parsedJson,RegisterParamViewModel register){
    clinic = InfoAdviceTypes.fromJson(parsedJson['clinic']);
    parsedJson['eras'].forEach((item){
      counterForShopScreen++;
      if(counterForShopScreen == 7){
        counterForShopScreen = 1;
      }
      eras.add(HistoryErasModel.fromJson(item,counterForShopScreen,register));
    });
  }

}

class HistoryErasModel {
  late String title;
  late String description;
  late int periodLength;
  late int cycleLength;
  late String createTime;
  late String createDate;
  late int polarCount;
  bool isSelected = false;
  late int counterForIcon;
  List<ErasModel> eras = [];

  String _format1(Date d,RegisterParamViewModel register) {
    final f = d.formatter;

    if(register.nationality == 'IR'){
      return "${f.d} ${f.mN} ${f.yyyy}";
    }else{
      return "${f.d} ${f.mnAf} ${f.yyyy}";
    }
  }

  final DateFormat formatterMiladi = DateFormat('yyyy/MM/dd');

  String _formatShamsi(Date d) {
    final f = d.formatter;
    return "${f.yyyy}/${f.m}/${f.d}";

  }
  
  DateTime toDateTime(String dateTmeString){
    List data = dateTmeString.split('/');
    DateTime dateTime = Jalali(
      int.parse(data[0]),
      int.parse(data[1]),
      int.parse(data[2]),
    ).toDateTime();
    return dateTime;
  }

  HistoryErasModel.fromJson(Map<String,dynamic> parsedJson,_counterForIcon,RegisterParamViewModel register){
    title = parsedJson['title'];
    if (register.calendarType == 1) {
      String _description = parsedJson['description'].toString().replaceAll('از تاریخ','').replaceAll(' ','');
      String _fromDate = _description.split('تاتاریخ')[0];
      String _toDate = _description.split('تاتاریخ')[1];
      if(_fromDate.startsWith('1') || _toDate.startsWith('1')){
        DateTime fromDate = toDateTime(_fromDate);
        DateTime toDate = toDateTime(_toDate);
        description = 'از تاریخ ${formatterMiladi.format(fromDate)} تا تاریخ ${formatterMiladi.format(toDate)}';
      }else{
        description = parsedJson['description'];
      }
    } else {
      String _description = parsedJson['description'].toString().replaceAll('از تاریخ','').replaceAll(' ','');
      String _fromDate = _description.split('تاتاریخ')[0].replaceAll('/','-');
      String _toDate = _description.split('تاتاریخ')[1].replaceAll('/','-');
      if(_fromDate.startsWith('2') || _toDate.startsWith('2')){
        DateTime fromDate = DateTime.parse(_fromDate);
        DateTime toDate = DateTime.parse(_toDate);
        description = 'از تاریخ ${_formatShamsi(Jalali.fromDateTime(fromDate))} تا تاریخ ${_formatShamsi(Jalali.fromDateTime(toDate))}';
      }else{
        description = parsedJson['description'];
      }
    }
    periodLength = parsedJson['periodLength'];
    cycleLength = parsedJson['cycleLength'];
    DateTime _createTime = DateTime.parse(parsedJson['createTime']);
    if(register.calendarType == 1){
      final DateFormat formatter = DateFormat('d LLL yyyy','fa');
      createDate = formatter.format(_createTime);
    }else{
      Jalali shamsi = Jalali.fromDateTime(_createTime);
      createDate = _format1(shamsi, register);
    }
    createTime = '${_createTime.hour}:${_createTime.minute}';
    polarCount = parsedJson['polarCount'];
    counterForIcon = _counterForIcon;
    parsedJson['eras'].forEach((item){
      eras.add(ErasModel.fromJson(item));
    });
  }

}

class ErasModel {
  late String periodStart;
  late String periodEnd;
  late String cycleEnd;
  ErasModel.fromJson(Map<String,dynamic> parsedJson){
    periodStart = parsedJson['periodStart'];
    periodEnd = parsedJson['periodEnd'];
    cycleEnd = parsedJson['cycleEnd'];
  }
}