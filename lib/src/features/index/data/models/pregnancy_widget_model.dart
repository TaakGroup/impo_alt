import 'package:taakitecture/taakitecture.dart';
import 'base_data_widget_model.dart';

class PregnancyWidgetModel extends BaseDataWidgetModel {
  late String image;
  late String trailingText;
  String? trailingIcon;
  late List<ListTileModel> tiles;

  @override
  BaseModel getInstance() => PregnancyWidgetModel();

  @override
  Map<String, dynamic> get properties => {};

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'image':
        image = value;
        break;
      case 'trailing':
        trailingText = value;
        break;
      case 'trailingIcon':
        trailingIcon = value;
        break;
      case 'tiles':
        tiles = [for (var mapJson in value) ListTileModel().fromJson(mapJson)];
        break;
    }

    super.setProp(key, value);
  }
}

class ListTileModel extends BaseModel with ModelMixin {
  late String name;
  late String text;
  late String icon;

  @override
  BaseModel getInstance() => ListTileModel();

  @override
  Map<String, dynamic> get properties => {
        'name': name,
        'text': text,
        'icon': icon,
      };

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'name':
        name = value;
        break;
      case 'text':
        text = value;
        break;
      case 'icon':
        icon = value;
        break;
    }
  }
}
