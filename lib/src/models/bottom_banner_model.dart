
import 'package:flutter/cupertino.dart';

abstract class BottomBannerModel extends ChangeNotifier {

  BottomBannerViewModel get bottomBanner;

  void addAllBottomBanner(Map<String,dynamic> map);

}

class BottomBannerModelImplementation extends BottomBannerModel {

  late BottomBannerViewModel _bottomBanner;

  @override
  void addAllBottomBanner(Map<String,dynamic> map) {
    _bottomBanner = BottomBannerViewModel.fromJson(map);
    notifyListeners();
  }

  @override
  BottomBannerViewModel get bottomBanner => _bottomBanner;

}


class BottomBannerViewModel{

  late bool visible;
  late String text;
  late int type;
  late String link;
  late String topicId;
  late String drId;
  late String experienceId;
  late  String ticketId;
  late String categoryId;

  BottomBannerViewModel.fromJson(Map<String,dynamic> parsedJson){
    visible = parsedJson['visible'];
    text = parsedJson['text'];
    type = parsedJson['type'];
    link = parsedJson['link'];
    topicId = parsedJson['topicId'];
    drId = parsedJson['drId'];
    experienceId = parsedJson['experienceId'];
    ticketId = parsedJson['ticketId'];
    categoryId = parsedJson['categoryId'];
  }

}