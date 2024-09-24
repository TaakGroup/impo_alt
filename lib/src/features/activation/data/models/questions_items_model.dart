import 'package:impo/src/features/activation/data/models/questions_page_model.dart';
import 'package:taakitecture/taakitecture.dart';

class QuestionsItemsModel extends BaseModel with ModelMixin {
  late int id;
  late String type;
  late QuestionsPageModel page;


  @override
  BaseModel getInstance() => QuestionsItemsModel();

  @override
  Map<String, dynamic> get properties => {
    'id' : id,
    'type' : type,
    'page' : page
  };

  @override
  void setProp(String key, value) {
    switch (key) {
      case "id":
        id = value;
        break;
      case "type":
        type = value;
        break;
      case "page":
        page = QuestionsPageModel().fromJson(value);
        break;
    }

  }

}