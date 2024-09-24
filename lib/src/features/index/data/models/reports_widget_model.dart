import 'dart:ui';

import 'package:taakitecture/taakitecture.dart';
import 'base_data_widget_model.dart';

class ReportItemModel extends BaseModel with ModelMixin {
  late String icon;
  late Color backgroundColor;
  late String title;
  late String text;
  late String trailing;

  @override
  BaseModel getInstance() => ReportItemModel();

  @override
  Map<String, dynamic> get properties => {
        'icon': icon,
        'backgroundColor': backgroundColor,
        'title': title,
        'text': text,
        'trailing': trailing,
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
      case 'text':
        text = value;
        break;
      case 'trailing':
        trailing = value;
        break;
    }
  }
}

class ReportsWidgetModel extends BaseDataWidgetModel {
  late List<ReportItemModel> list;
  late String buttonText;

  @override
  BaseModel getInstance() => ReportsWidgetModel();

  @override
  Map<String, dynamic> get properties => {
        'list': list,
        'buttonText': buttonText,
      };

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'list':
        list = [for (var story in value) ReportItemModel().fromJson(story)];
        break;
      case 'buttonText':
        buttonText = value;
        break;
    }

    super.setProp(key, value);
  }
}
