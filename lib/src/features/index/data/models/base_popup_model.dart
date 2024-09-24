import 'package:impo/src/features/index/data/models/base_data_popup_model.dart';
import 'package:taakitecture/taakitecture.dart';

enum PopupType { multiOption, interaction, dialog }

class BasePopupModel extends BaseModel with ModelMixin {
  late PopupType type;
  late BaseDataPopupModel? data;
  late bool isDismissible;

  @override
  BaseModel getInstance() => BasePopupModel();

  @override
  Map<String, dynamic> get properties => {
        'type': type.index,
      };

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'type':
        type = PopupType.values[value];
        break;
      case 'data':
        data = BaseDataPopupModel.fromType(value, type);
        break;
      case 'isDismissible':
        isDismissible = value;
        break;
    }
  }
}
