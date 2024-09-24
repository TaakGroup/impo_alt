import 'package:taakitecture/taakitecture.dart';

import 'base_data_widget_model.dart';

class ReportEmptyStateWidgetModel extends BaseDataWidgetModel {
  late int days;
  late int percent;
  late String image;

  @override
  BaseModel getInstance() => ReportEmptyStateWidgetModel();

  @override
  Map<String, dynamic> get properties => {
        'days': days,
        'percent': percent,
        'image': image,
      };

  @override
  void setProp(String key, value) {
    super.setProp(key, value);

    switch (key) {
      case 'days':
        days = value;
        break;
      case 'percent':
        percent = value;
        break;
      case 'image':
        image = value;
        break;
    }
  }
}
