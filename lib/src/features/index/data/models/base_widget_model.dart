import 'package:impo/src/features/index/data/models/index_model.dart';
import 'package:taakitecture/taakitecture.dart';

import 'base_data_widget_model.dart';

class BaseWidgetModel extends BaseModel with ModelMixin {
  late WidgetType type;
  late int order;
  late BaseDataWidgetModel? data;

  @override
  BaseModel getInstance() => BaseWidgetModel();

  @override
  Map<String, dynamic> get properties => {
        'type': type,
        'order': order,
      };

  @override
  List<Object?> get props => [order];

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'type':
        type = WidgetType.values[value];
        break;
      case 'order':
        order = value;
        break;
      case 'data':
        data = BaseDataWidgetModel.fromType(type, value);
        break;
      default:
    }
  }
}
