

import 'package:impo/src/models/calender/alarm_model.dart';

import 'list_dialy_remindes_model.dart';

class MainListRemindersModel {

  int? id;
  String? title;
  String? icon;
  bool? selected;

  MainListRemindersModel({this.title,this.icon,this.selected = false});

  MainListRemindersModel.fromJson(Map<String,dynamic> parsedJson){

    title = parsedJson['title'];
    icon = parsedJson['icon'];

  }

}


List<MainListRemindersModel> mainReminders = [

  MainListRemindersModel(
      title: 'یادآور نوشیدن آب',
      icon:  'assets/images/water.svg',
      selected: false
  ),
  MainListRemindersModel(
      title: 'یادآور مطالعه',
      icon:  'assets/images/study.svg',
      selected: false
  ),
  MainListRemindersModel(
      title: 'یادآور دارو',
      icon:  'assets/images/drug.svg',
      selected: false
  ),
  MainListRemindersModel(
      title: 'یادآور میوه',
      icon:  'assets/images/fruit.svg',
      selected: false
  ),
  MainListRemindersModel(
      title: 'یادآور ورزش',
      icon:  'assets/images/sport.svg',
      selected: false
  ),
  MainListRemindersModel(
      title: 'یادآور خواب',
      icon:  'assets/images/sleep.svg',
      selected: false
  ),
  MainListRemindersModel(
      title: 'یادآور استفاده از موبایل',
      icon:  'assets/images/mobile.svg',
      selected: false
  ),
  MainListRemindersModel(
      title: 'یادآور تعویض پد بهداشتی',
      icon:  'assets/images/pad.svg',
      selected: false
  ),

];