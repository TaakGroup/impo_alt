
import 'package:flutter/cupertino.dart';

abstract class AdvertiseModel extends ChangeNotifier {

  void addAdvertise(Map<String,dynamic> map);

  List<AdvertiseViewModel> get  advertises;

  // void removeAlarm(String noteId);
  //
  // void removeAllAlarms();

}

class AdvertiseModelImplementation extends AdvertiseModel {

  List<AdvertiseViewModel>  _advertises = [];

  @override
  List<AdvertiseViewModel>  get advertises => _advertises;

  @override
  void addAdvertise(Map<String,dynamic> map) {
    _advertises.add(AdvertiseViewModel.fromJson(map));
    notifyListeners();
  }

  // @override
  // void removeAlarm(String noteId) {
  //   _alarm.removeWhere((element) => element.noteId == noteId);
  //   notifyListeners();
  // }
  //
  // @override
  // void removeAllAlarms() {
  //   _alarm.clear();
  //   notifyListeners();
  // }

}


class  AdvertiseViewModel {

  late String link;
  late String image;
  late int place;
  late String id;
  late String text1;
  late String text2;
  late String text3;
  late int typeLink;



  AdvertiseViewModel.fromJson(Map<String, dynamic> parsedJson){
    link = parsedJson['link'];
    image = parsedJson['image'];
    place = parsedJson['place'];
    id = parsedJson['id'];
    text1 = parsedJson['text1'];
    text2 = parsedJson['text2'];
    text3 = parsedJson['text3'];
    typeLink = parsedJson['typeLink'];
  }
}
