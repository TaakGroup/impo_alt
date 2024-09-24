import 'package:impo/src/features/index/data/models/action_model.dart';
import 'package:impo/src/features/index/data/models/button_model.dart';
import 'package:taakitecture/taakitecture.dart';

import 'base_data_popup_model.dart';

class MultiOptionSheetModel extends BaseDataPopupModel {
  late List<OptionItemModel> items;
  late ButtonModel submit;

  @override
  BaseModel getInstance() => MultiOptionSheetModel();

  @override
  Map<String, dynamic> get properties => {
        'items': [for (var item in items) item.toJson()],
        'submit': submit.toJson(),
      };

  @override
  void setProp(String key, value) {
    super.setProp(key, value);

    switch (key) {
      case 'items':
        items = [for (var mapJson in value) OptionItemModel().fromJson(mapJson)];
        break;
      case 'submit':
        submit = ButtonModel().fromJson(value);
        break;
    }
  }
}

class OptionItemModel extends BaseModel with ModelMixin {
  late String title;
  late ActionModel action;

  @override
  BaseModel getInstance() => OptionItemModel();

  @override
  Map<String, dynamic> get properties => {
        'title': title,
      };

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'title':
        title = value;
        break;
      case 'action':
        action = ActionModel().fromJson(value);
        break;
    }
  }
}
