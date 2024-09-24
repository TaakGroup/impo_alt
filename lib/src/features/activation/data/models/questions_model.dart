import 'package:impo/src/features/activation/data/models/questions_items_model.dart';
import 'package:taakitecture/taakitecture.dart';

class QuestionsModel extends BaseModel with ModelMixin{
  late List<QuestionsItemsModel> items;

  @override
  BaseModel getInstance() => QuestionsModel();

  @override
  Map<String, dynamic> get properties =>{
    'items' : items
  };

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'items':
        items = [for (var mapJson in value) QuestionsItemsModel().fromJson(mapJson)];
        break;
    }
  }

}