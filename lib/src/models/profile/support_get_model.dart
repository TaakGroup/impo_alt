
class SupportGetModel{

  List<ItemsSupportModel> items = [];
  late String description;
  late String title;


  SupportGetModel.fromJson(Map<String,dynamic> parsedJson){
    title = parsedJson['title'];
    description = parsedJson['description'];
    parsedJson['items'].forEach((item){
      items.add(ItemsSupportModel(title: item));
    });
  }

}

class ItemsSupportModel{
  String? title;
  bool isSelected = false;

  ItemsSupportModel({this.title});

}