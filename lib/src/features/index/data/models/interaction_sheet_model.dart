import 'package:impo/src/features/index/data/models/button_model.dart';
import 'package:taakitecture/taakitecture.dart';
import 'base_data_popup_model.dart';

class InteractionSheetModel extends BaseDataPopupModel {
  late String object;
  late ButtonModel button;

  @override
  BaseModel getInstance() => InteractionSheetModel();

  @override
  Map<String, dynamic> get properties => {};

  @override
  void setProp(String key, value) {
    super.setProp(key, value);

    switch (key) {
      case 'image':
        object = value;
        break;

      case 'button':
        button = ButtonModel().fromJson(value);
        break;
    }
  }
}
