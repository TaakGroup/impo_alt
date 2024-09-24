import 'package:flutter/cupertino.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:intl/intl.dart';



abstract class PartnerModel extends ChangeNotifier {

  void addPartner(Map<String,dynamic> map);

  PartnerViewModel get  partnerDetail;

}

class PartnerModelImplementation extends PartnerModel {

  PartnerViewModel  _partnerDetail = PartnerViewModel();


  @override
  PartnerViewModel  get partnerDetail => _partnerDetail;

  @override
  void addPartner(Map<String,dynamic> map) {
    _partnerDetail = PartnerViewModel.fromJson(map);
    notifyListeners();
  }

}



class PartnerViewModel{

  late bool isPair;
  late String token;
  late int time;
  late String manName;
  late String createTime;
  late String text;
  late String shareText;
  late String birthDate;
  late int distanceType;
  late String downloadText;
  late String directDownloadLink;
  late String googleDownloadLink;

  PartnerViewModel();

  String format1(Date d){
    var registerInfo = locator<RegisterParamModel>();
    String nationality = registerInfo.register.nationality!;
    final f = d.formatter;

    if(nationality == 'IR'){
      return "${f.d} ${f.mN} ${f.yyyy}";
    }else{
      return "${f.d} ${f.mnAf} ${f.yyyy}";
    }
  }

  PartnerViewModel.fromJson(Map<String,dynamic> parsedJson){
    isPair = parsedJson['isPair'];
    token = parsedJson['token'];
    time = parsedJson['time'];
    manName = parsedJson['manName'];
    final f = new DateFormat('yyyy/MM/dd hh:mm:ss');
    DateTime t = f.parse(parsedJson['createTime']);
    createTime =  format1(Jalali.fromDateTime(t));
    text = parsedJson['text'];
    shareText = parsedJson['shareText'];
    birthDate = parsedJson['birtDate'];
    distanceType = parsedJson['distanceType'];
    downloadText= parsedJson['downloadText'];
    directDownloadLink= parsedJson['directDownloadLink'];
    googleDownloadLink = parsedJson['googleDownloadLink'];
  }

}