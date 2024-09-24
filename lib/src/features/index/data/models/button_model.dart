import 'package:flutter/material.dart';
import 'package:taakitecture/taakitecture.dart';

import 'action_model.dart';

class ButtonModel extends BaseModel with ModelMixin {
  late Color backgroundColor;
  late Color foregroundColor;
  late String text;
  late ActionModel action;

  @override
  BaseModel getInstance() => ButtonModel();

  @override
  Map<String, dynamic> get properties => {};

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'backgroundColor':
        backgroundColor = Color(int.parse(value));
        break;
      case 'foregroundColor':
        foregroundColor = Color(int.parse(value));
        break;
      case 'text':
        text = value;
        break;
      case 'action':
        action = ActionModel().fromJson(value);
        break;
    }
  }
}
