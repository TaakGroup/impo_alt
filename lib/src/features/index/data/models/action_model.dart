import 'package:taakitecture/taakitecture.dart';

import 'base_popup_model.dart';

enum ActionType {
  None,
  InternalRout,
  ApiCall,
  NextStep,
  Done;
}

class ActionModel extends BaseModel with ModelMixin {
  late ActionType type;
  int? internal;
  String? api;
  BasePopupModel? popup;

  @override
  BaseModel getInstance() => ActionModel();

  @override
  Map<String, dynamic> get properties => {};

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'actionType':
        type = ActionType.values[value];
        break;
      case 'internal':
        internal = value;
        break;
      case 'api':
        api = value;
        break;
      case 'nextStep':
        if (value != null) popup = BasePopupModel().fromJson(value);
        break;
    }
  }
}
