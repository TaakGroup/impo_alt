
import 'package:impo/src/models/expert/ticket_info_model.dart';
import 'package:shamsi_date/shamsi_date.dart';

class DrInfoModel {
  late bool isValid;
  late DoctorInfoModel info;

  DrInfoModel.fromJson(Map<String,dynamic> parsedJson){
    isValid = parsedJson['isValid'];
    info = DoctorInfoModel.fromJson(parsedJson['info'],true);
  }
}

class CommentsInfoModel{
  late int pageNo;
  late int pageSize;
  late int pageMax;
  late int totalCount;
  List<ListCommentsInfoModel> list = [];

  CommentsInfoModel.fromJson(Map<String,dynamic> parsedJson){
    pageNo = parsedJson['pageNo'];
    pageSize = parsedJson['pageSize'];
    pageMax = parsedJson['pageMax'];
    totalCount = parsedJson['totalCount'];
    parsedJson['list'] != [] ? parsedJson['list'].forEach((item){
      list.add(ListCommentsInfoModel.fromJson(item));
    }) : list = [];
  }

}

class ListCommentsInfoModel{
  late String time;
  late int rate;
    List<String> positives = [];
    List<String> negatives = [];
  late String descritpion;
  late String userName;

    ListCommentsInfoModel.fromJson(Map<String,dynamic> parsedJson){
      DateTime createTime = DateTime.parse(parsedJson['time']);
      Jalali shamsi = Jalali.fromDateTime(createTime);
      time = shamsi.formatter.date.toString().replaceAll('(', '').replaceAll(')', '').replaceAll('Jalali','').replaceAll(',', '/').replaceAll(' ','');
      rate = parsedJson['rate'];
      parsedJson['positives'] != null ?
      parsedJson['positives'].forEach((item){
        positives.add(item);
      }) : positives =  [];

      parsedJson['negatives'] != null ?
      parsedJson['negatives'].forEach((item){
        negatives.add(item);
      }) : negatives =  [];

      descritpion = parsedJson['descritpion'];
      userName = parsedJson['userName'];
    }
}