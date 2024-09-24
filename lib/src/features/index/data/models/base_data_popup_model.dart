import 'package:impo/src/features/index/data/models/multi_option_sheet_model.dart';
import 'package:taakitecture/taakitecture.dart';

import 'base_popup_model.dart';
import 'dialog_model.dart';
import 'interaction_sheet_model.dart';

class BaseDataPopupModel extends BaseModel with ModelMixin {
  late String title;
  late String description;

  @override
  BaseModel getInstance() => BaseDataPopupModel();

  @override
  Map<String, dynamic> get properties => {
        'title': title,
        'description': description,
      };

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'title':
        title = value;
        break;
      case 'description':
        description = value;
        break;
    }
  }

  static BaseDataPopupModel? fromType(value, PopupType type) {
    switch (type) {
      case PopupType.multiOption:
        return MultiOptionSheetModel().fromJson(value);
      case PopupType.interaction:
        return InteractionSheetModel().fromJson(value);
      case PopupType.dialog:
        return DialogModel().fromJson(value);
    }
  }
}
