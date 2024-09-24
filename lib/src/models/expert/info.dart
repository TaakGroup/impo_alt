import 'package:impo/src/models/expert/tickets_model.dart';
import 'package:intl/intl.dart';

class InfoAdviceModel {
  late int currentValue;
  List<TicketsModel> tickets = [];
  List<InfoAdviceTypes> types = [];
  late String title;
  late String description;
  late String listOfValues;
  late String activeTicketsTitle;
  late String activeTicketsOneTitle;
  late  String activeTicketsMore;

  InfoAdviceModel.fromJson(Map<String,dynamic> parsedJson){
    currentValue = parsedJson['currentValue'];
    parsedJson['tickets'] != [] ? parsedJson['tickets'].forEach((item){
      tickets.add(TicketsModel.fromJson(item));
    }) : tickets = [];
    parsedJson['types'] != [] ? parsedJson['types'].forEach((item){
      if(item['visible']){
        types.add(InfoAdviceTypes.fromJson(item));
      }
    }) : types = [];
    title = parsedJson['title'];
    description = parsedJson['description'];
    listOfValues = parsedJson['listOfValues'];
    activeTicketsTitle = parsedJson['activeTicketsTitle'];
    activeTicketsOneTitle = parsedJson['activeTicketsOneTitle'];
    activeTicketsMore = parsedJson['activeTicketsMore'];
  }

}


class InfoAdviceTypes{
  late String cta;
  late String price;
  late String priceUnit;
  late int id;
  late String name;
  late bool visible;
  late String description;

  final oCcy = new NumberFormat("#,##0", "en_US");

  InfoAdviceTypes.fromJson(Map<String,dynamic> parsedJson){
    cta = parsedJson['cta'];
    price = oCcy.format(parsedJson['price']);
    priceUnit = parsedJson['priceUnit'];
    id = parsedJson['id'];
    name = parsedJson['name'];
    visible = parsedJson['visible'];
    description = parsedJson['description'];
  }

}