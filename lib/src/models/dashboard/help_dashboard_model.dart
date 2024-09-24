

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:impo/src/components/colors.dart';

class HelpDashboardModel{

  String? title;
  String? subTitle;
  String? icon;
  String? circleIcon;
  String? selectedIcon;
  List<Color>? colors;
  bool selected;

  HelpDashboardModel({this.title,this.subTitle,this.icon,this.selected = false,this.circleIcon,this.selectedIcon,this.colors});

}


 List<HelpDashboardModel> helpDashboards = [

   HelpDashboardModel(
     title: 'دوره قاعدگی',
     subTitle: 'این روزا، خونریزی رو تجربه می‌کنی. خونریزی که ناشی از ریزش پوشش داخلی رحم هست که ممکنه با علائم جسمی و روانی همراه بشه',
     icon: 'assets/images/ic_help_period.svg',
     circleIcon: 'assets/images/circle_period.png',
     selectedIcon: 'assets/images/selected_period.png',
     colors: [
       Color(0xffc7439a),
       ColorPallet().periodLight
     ],
     selected: false
   ),
   HelpDashboardModel(
       title: 'دوره باروری',
       subTitle: 'دوره باروری به چند روز قبل و چند روز بعد از روز تخمک‌گذاری گفته می‌شه که در اون دوره احتمال بارداری نسبت به بقیه روزهای چرخه بالاتره',
       icon: 'assets/images/ic_help_oval.svg',
       circleIcon: 'assets/images/circle_fert.png',
       selectedIcon: 'assets/images/selected_fert.png',
       colors: [
         ColorPallet().fertDeep,
         ColorPallet().fertLight
       ],
       selected: false
   ),
   HelpDashboardModel(
       title: 'روز تخمک‌گذاری',
       subTitle: 'تخمک‌گذاری به روزی در چرخه قاعدگی گفته می‌شه که در اون تخمک از تخمدان آزاد می‌شه و احتمال بارداری در بالاترین حالت ممکن قرار داره',
       icon: 'assets/images/ic_help_oval.svg',
       circleIcon: 'assets/images/circle_fert.png',
       selectedIcon: 'assets/images/selected_fert.png',
       colors: [
         ColorPallet().fertDeep,
         ColorPallet().fertLight
       ],
       selected: false
   ),
   HelpDashboardModel(
       title: 'روز عادی',
       subTitle: 'این روزا کمترین تغییرات هورمونی رو تجربه می‌کنی \uD83D\uDE0A',
       circleIcon: 'assets/images/circle_normal.png',
       selectedIcon: 'assets/images/selected_normal.png',
       icon: 'assets/images/ic_help_normal.svg',
       colors: [
         ColorPallet().normalDeep,
         Color(0xff7ea0fc),
       ],
       selected: false
   ),
   HelpDashboardModel(
       title: 'دوره PMS',
       subTitle: 'علائم جسمی و روانی که ممکنه خیلی از ما روزهای قبل از قاعدگی تجربه کنیم مثل کج خلق شدن، تنش و اضطراب',
       circleIcon: 'assets/images/circle_pms.png',
       selectedIcon: 'assets/images/selected_pms.png',
       icon: 'assets/images/ic_help_pms.svg',
       colors: [
         ColorPallet().pmsLight,
         ColorPallet().pmsDeep,
       ],
       selected: false
   ),
 ] ;

List<HelpDashboardModel> helpDashboardBox = [
  HelpDashboardModel(
      title: 'دوره قاعدگی',
      colors: [
        ColorPallet().periodDeep,
        ColorPallet().periodLight
      ],
      selected: false
  ),
  HelpDashboardModel(
      title: 'دوره باروری',
      colors: [
        ColorPallet().fertDeep,
        ColorPallet().fertLight
      ],
      selected: false
  ),
  HelpDashboardModel(
      title: 'روز تخمک‌گذاری',
      colors: [
        ColorPallet().fertDeep,
        ColorPallet().fertLight
      ],
      selected: false
  ),
  HelpDashboardModel(
      title: 'روز عادی',
      colors: [
        Colors.white,
        Colors.white
      ],
      selected: false
  ),
  HelpDashboardModel(
      title: 'دوره pms',
      colors: [
        ColorPallet().pmsDeep,
        ColorPallet().pmsLight
      ],
      selected: false
  ),
];