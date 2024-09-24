
import 'package:impo/src/models/support/category_items_model.dart';

class SupportCategoryModel{
  List<CategoryItemsModel> items = [];
  late String id;
  late String url;
  late String describtion;
  late String title;

  SupportCategoryModel.fromJson(Map<String,dynamic> parsedJson){
    parsedJson['items'].forEach((item){
      items.add(CategoryItemsModel.fromJson(item));
    });
    id = parsedJson['id'];
    url = parsedJson['url'];
    describtion = parsedJson['describtion'];
    title = parsedJson['title'];
  }

}