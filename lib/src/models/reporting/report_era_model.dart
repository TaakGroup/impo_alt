import 'package:intl/intl.dart';

class ReportEraModel{
  late String titleText;
  late bool valid;
  late String message;
  List<EraList> eraList = [];
  int counterForShopScreen = 0;
  int _id = 9;

  ReportEraModel.fromJson(Map<String,dynamic> parsedJson){
    titleText = parsedJson['titleText'];
    valid = parsedJson['valid'];
    message = parsedJson['message'];
    parsedJson['eraList'].forEach((item){
      _id++;
      counterForShopScreen++;
      if(counterForShopScreen == 4){
        counterForShopScreen = 1;
      }
      eraList.add(EraList.fromJson(item,counterForShopScreen,_id));
    });
  }

}

class EraList{
  late int id;
  late int polar;
  late int cycleCount;
  late String text;
  late String price;
  late int counterForColor;
  bool isSelected = false;

  final oCcy = new NumberFormat("#,##0", "en_US");

  EraList.fromJson(Map<String,dynamic> parsedJson,_counterForIcon,_id){
    id =  _id;
    polar = parsedJson['polar'];
    cycleCount = parsedJson['cycleCount'];
    text = parsedJson['text'];
    counterForColor = _counterForIcon;
    // price = oCcy.format(parsedJson['price']);
    price = oCcy.format(parsedJson['price']);
  }

}