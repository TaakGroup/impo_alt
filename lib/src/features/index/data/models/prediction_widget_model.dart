import 'dart:ui';

import 'package:taakitecture/taakitecture.dart';
import 'base_data_widget_model.dart';

class PredictionItemModel extends BaseModel with ModelMixin {
  late String icon;
  late Color backgroundColor;
  late String title;
  late String trailingUp;
  late String trailingDown;

  @override
  BaseModel getInstance() => PredictionItemModel();

  @override
  Map<String, dynamic> get properties => {
        'icon': icon,
        'backgroundColor': backgroundColor,
        'title': title,
        'trailingUp': trailingUp,
        'trailingDown': trailingDown,
      };

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'icon':
        icon = value;
        break;
      case 'backgroundColor':
        backgroundColor = Color(int.parse(value));
        break;
      case 'title':
        title = value;
        break;
      case 'trailingUp':
        trailingUp = value;
        break;
      case 'trailingDown':
        trailingDown = value;
        break;
    }
  }
}

class PredictionWidgetModel extends BaseDataWidgetModel {
  late List<PredictionItemModel> list;

  @override
  BaseModel getInstance() => PredictionWidgetModel();

  @override
  Map<String, dynamic> get properties => {
        'list': list,
      };

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'items':
        list = [for (var story in value) PredictionItemModel().fromJson(story)];
        break;
    }

    super.setProp(key, value);
  }
}
