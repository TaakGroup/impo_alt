import 'package:flutter/material.dart';
import 'package:taakitecture/taakitecture.dart';
import 'base_data_widget_model.dart';
import 'button_model.dart';

class CycleWidgetModel extends BaseDataWidgetModel {
  late Color backgroundColor;
  late Color foregroundColor;
  late Color textColor;
  late String leading;
  late List<ButtonModel> buttons;

  @override
  BaseModel getInstance() => CycleWidgetModel();

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'leading':
        leading = value;
        break;
      case 'textColor':
        textColor = Color(int.parse(value));
        break;
      case 'foregroundColor':
      case 'forgroundColor':
        foregroundColor = Color(int.parse(value));
        break;
      case 'backgroundColor':
        backgroundColor = Color(int.parse(value));
        break;
      case 'button':
        buttons = [for(var map in value) ButtonModel().fromJson(map)];
        break;
    }

    super.setProp(key, value);
  }
}
