
import 'package:flutter/material.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';

abstract class AllDashBoardMessageAndNotifyModel extends ChangeNotifier {

  void addParentDashBoardMessage(Map<String,dynamic> map,status);
  List<ParentDashboardMessageAndNotifyViewModel> get  parentDashboardMessages;


  void addParentNotify(Map<String,dynamic> map,int status);
  List<ParentDashboardMessageAndNotifyViewModel> get  parentNotifies;



  void addMotivalMessage(Map<String,dynamic> map);
  void addOfflineMotivalMessage(Map<String,dynamic> map);
  List<DashBoardMessageAndNotifyViewModel> get  motivalMessages;

  void removeAllMessageAndNotifies();

}

class AllDashBoardMessageAndNotifyModelImplementation extends AllDashBoardMessageAndNotifyModel {


  List<ParentDashboardMessageAndNotifyViewModel>  _parentDashboardMessages = [];
  List<ParentDashboardMessageAndNotifyViewModel> _parentNotifies = [];
  List<DashBoardMessageAndNotifyViewModel>  _motivaldMessages = [];


  @override
  List<ParentDashboardMessageAndNotifyViewModel>  get parentDashboardMessages => _parentDashboardMessages;
  @override
  void addParentDashBoardMessage(Map<String,dynamic> map,status) {
    _parentDashboardMessages.add(ParentDashboardMessageAndNotifyViewModel.fromJson(map,'dashboardMessages',status));
    notifyListeners();
  }



  @override
  List<ParentDashboardMessageAndNotifyViewModel>  get parentNotifies => _parentNotifies;
  @override
  void addParentNotify(Map<String, dynamic> map,status) {
    _parentNotifies.add(ParentDashboardMessageAndNotifyViewModel.fromJson(map,'notifies',status));
    notifyListeners();
  }



  @override
  List<DashBoardMessageAndNotifyViewModel> get motivalMessages => _motivaldMessages;
  @override
  void addMotivalMessage(Map<String, dynamic> map) {
    _motivaldMessages.add(DashBoardMessageAndNotifyViewModel.fromJson(map,false));
    notifyListeners();
  }

  @override
  void removeAllMessageAndNotifies() {
    _parentDashboardMessages.clear();
    _parentNotifies.clear();
    _motivaldMessages.clear();
    notifyListeners();
  }

  @override
  void addOfflineMotivalMessage(Map<String, dynamic> map) {
    _motivaldMessages.add(DashBoardMessageAndNotifyViewModel.offlineModeMotivalFromJson(map));
    notifyListeners();
  }


}


class ParentDashboardMessageAndNotifyViewModel{

  int? id;
  String? timeId;
  String? timeSend;
  int? condition;
  int? womanSign;
  int? sexual;
  int? age;
  int? day;
  int? distance;
  int? birth;
  int? single;

  ///pregnancyAndBreastfeedingOnly
  int abortionHistory = 0;
  int pregnancyCount = 0;

  ///breastfeedingOnly
  int childType = 0;
  int childBirthType = 0;


  int monthName = 0; /// this only notifies pregnancy and breastfeeding

  List<DashBoardMessageAndNotifyViewModel> dashboardMessages = [];

  ParentDashboardMessageAndNotifyViewModel();

  ParentDashboardMessageAndNotifyViewModel.fromJson(Map<String,dynamic> parsedJson,nameList,int status){
    id = parsedJson['id'];
    timeId = parsedJson['timeId'];
    timeSend = parsedJson['timeSend'];
    condition = parsedJson['condition'];
    womanSign = parsedJson['womanSign'];
    sexual = parsedJson['sexual'];
    nameList == 'notifies' ? day = parsedJson['day'] : day = 0;
    age = parsedJson['age'];
    parsedJson[nameList] != [] ? parsedJson[nameList].forEach((item){
      dashboardMessages.add(DashBoardMessageAndNotifyViewModel.fromJson(item,nameList == 'notifies' ? true : false));
    }) : dashboardMessages = [];
    distance = parsedJson['distance'];
    birth = parsedJson['birth'];
    single = parsedJson['single'];
    if(status == 2){
      abortionHistory = parsedJson['abortionHistory'];
      pregnancyCount = parsedJson['pregnancyCount'];
      nameList == 'notifies' ? monthName = parsedJson['monthName'] : monthName = 0;
    }
    if(status == 3){
      abortionHistory = parsedJson['abortionHistory'];
      pregnancyCount = parsedJson['pregnancyCount'];
      nameList == 'notifies' ? monthName = parsedJson['monthName'] : monthName = 0;
      childType = parsedJson['childType'];
      childBirthType = parsedJson['childBirthType'];
    }

  }

}

class DashBoardMessageAndNotifyViewModel{

  int? offlineId;
  String? id;
  String? text;
  String? title;
  bool? isPin;
  String? link;
  int? typeLink;

  DashBoardMessageAndNotifyViewModel();

  DashBoardMessageAndNotifyViewModel.fromJson(Map<String,dynamic> parsedJson,bool isNotify){
    id = parsedJson['id'];
    text = parsedJson['text'];
    isNotify ? title = parsedJson['title'] : title = '';
    isPin = isNotify ? false : parsedJson['isPin'];
    link = isNotify ? '' : parsedJson['link'];
    typeLink = parsedJson['typeLink'];
  }

  DashBoardMessageAndNotifyViewModel.offlineModeMotivalFromJson(Map<String,dynamic> parsedJson){
    offlineId = parsedJson['id'];
    text = parsedJson['text'];
  }

}