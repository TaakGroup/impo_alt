
class CategoryItemsModel{

  late String id;
  late String title;
  bool isSelected = false;

  CategoryItemsModel.fromJson(Map<String,dynamic> parsedJson){
    id = parsedJson['id'];
    title = parsedJson['title'];
  }

}