import 'package:flutter/material.dart';
import 'package:taakitecture/taakitecture.dart';
import 'base_popup_model.dart';
import 'base_widget_model.dart';

enum WidgetType {
  cycle,
  story,
  hint,
  prediction,
  article,
  report,
  reportEmpty,
  pregnancy,
  breastfeeding,
  subscription;
}

class IndexModel extends BaseModel with ModelMixin {
  late Color background;
  late String headline;
  late List<BaseWidgetModel> widgets;
  List<BasePopupModel> actions = [];

  @override
  BaseModel getInstance() => IndexModel();

  @override
  Map<String, dynamic> get properties => {};

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'backgroundColor':
        background = Color(int.parse(value));
        break;
      case 'headline':
      case 'date':
        headline = value;
        break;
      case 'wigets':
        widgets = [for (var mapJson in value) BaseWidgetModel().fromJson(mapJson)];
        break;
      case 'actions':
        actions = [for (var mapJson in value) BasePopupModel().fromJson(mapJson)];
        break;
    }
  }
}
