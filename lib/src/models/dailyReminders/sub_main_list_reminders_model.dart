

import 'package:impo/src/models/calender/alarm_model.dart';
import 'package:impo/src/models/dailyReminders/list_dialy_remindes_model.dart';

class SubMainListRemindersModel {

  String? title;
  String? icon;
  String? subTitle;

  SubMainListRemindersModel({this.title,this.icon,this.subTitle});


}

List<SubMainListRemindersModel> subMainReminders = [

  SubMainListRemindersModel(
    title: 'یادآور نوشیدن آب',
    icon: 'assets/images/water.svg',
    subTitle: 'ایمپویی عزیز می‌دونی برای سلامت بدنت لازمه هر روز به مقدار کافی آب بنوشی؟',
  ),
  SubMainListRemindersModel(
    title: 'یادآور مطالعه',
    icon: 'assets/images/study.svg',
    subTitle: 'حتی روزی 5 دقیقه، مهم اینه که روز بدون مطالعه نداشته باشی!',
  ),
  SubMainListRemindersModel(
    title: 'یادآور دارو',
    icon: 'assets/images/drug.svg',
    subTitle: 'ایمپویی عزیز لازمه که داروها و مکمل‌هات رو سر موقع مصرف کنی',
  ),
  SubMainListRemindersModel(
    title: 'یادآور میوه',
    icon: 'assets/images/fruit.svg',
    subTitle: 'برنامه غذایی بدون میوه، یه برنامه غذایی کامل نیست',
  ),
  SubMainListRemindersModel(
    title: 'یادآور ورزش',
    icon: 'assets/images/sport.svg',
    subTitle: 'اگه ورزش نمی‌کنی حق داری از آینده بترسی',
  ),
  SubMainListRemindersModel(
    title: 'یادآور خواب',
    icon: 'assets/images/sleep.svg',
    subTitle: 'ایمپویی عزیز، مهمه که هم به موقع بخوابی هم به اندازه کافی',
  ),
  SubMainListRemindersModel(
    title: 'یادآور استفاده از موبایل',
    icon: 'assets/images/mobile.svg',
    subTitle: 'لازمه بعضی از ساعت‌های روز رو بدون موبایل بگذرونی',
  ),
  SubMainListRemindersModel(
    title: 'یادآور تعویض پد بهداشتی',
    icon: 'assets/images/pad.svg',
    subTitle: 'ایمپویی عزیز، بهتره هر 4 ساعت پد، تامپون یا کاپ قاعدگیت رو تعویض کنی!',
  ),

];