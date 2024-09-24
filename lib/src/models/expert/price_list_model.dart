
import 'package:intl/intl.dart';

class PriceModel {

  late String description;
  late String polarPrice;
  late String unitPrice;
  List<PriceListModel> prices = [];
  int counterForShopScreen = 0;

  PriceModel();

  PriceModel.fromJson(Map<String,dynamic> parsedJson){
    description = parsedJson['description'];
    polarPrice = oCcy.format(parsedJson['polarPrice']);
    unitPrice = parsedJson['unitPrice'];
    parsedJson['prices'] != [] ?
        parsedJson['prices'].forEach((item){
          counterForShopScreen++;
          if(counterForShopScreen == 4){
            counterForShopScreen = 1;
          }
          prices.add(PriceListModel.fromJson(item, counterForShopScreen));
        }) :
        prices = [];
  }

  final oCcy = new NumberFormat("#,##0", "en_US");
}


class PriceListModel{

  late int polarCount;
  late String price;
  late String realPrice;
  bool selected = false;
  late int counterForColor;

  final oCcy = new NumberFormat("#,##0", "en_US");

  PriceListModel.fromJson(Map<String,dynamic> parsedJson,_counterForIcon){
    polarCount = parsedJson['polarCount'];
    price = oCcy.format(parsedJson['price']);
    realPrice = oCcy.format(parsedJson['realPrice']);
    counterForColor = _counterForIcon;
  }

}