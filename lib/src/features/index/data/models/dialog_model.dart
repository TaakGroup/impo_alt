import 'package:taakitecture/taakitecture.dart';

import 'base_data_popup_model.dart';
import 'button_model.dart';

class DialogModel extends BaseDataPopupModel {
  late ButtonModel first;
  late ButtonModel second;

  @override
  BaseModel getInstance() => DialogModel();

  @override
  Map<String, dynamic> get properties => {};

  @override
  void setProp(String key, value) {
    super.setProp(key, value);

    switch (key) {
      case 'first':
        first = ButtonModel().fromJson(value);
        break;
      case 'second':
        second = ButtonModel().fromJson(value);
        break;
    }
  }
}
