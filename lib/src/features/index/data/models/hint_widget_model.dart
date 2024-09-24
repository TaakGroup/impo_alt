import 'package:taakitecture/taakitecture.dart';
import 'base_data_widget_model.dart';

class HintModel extends BaseModel with ModelMixin {
  late String id;
  late String text;
  late String? title;
  late String? internalLink;
  late String? externalLink;

  @override
  BaseModel getInstance() => HintModel();

  @override
  Map<String, dynamic> get properties => {
        'id': id,
        'text': text,
        'title': title,
        'internalLink': internalLink,
        'externalLink': externalLink,
      };

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'text':
        text = value;
        break;
      case 'title':
        title = value;
        break;
      case 'internalLink':
        internalLink = value;
        break;
      case 'externalLink':
        externalLink = value;
        break;
    }
  }
}

class HintWidgetModel extends BaseDataWidgetModel {
  late List<HintModel> hints;

  @override
  BaseModel getInstance() => HintWidgetModel();

  @override
  Map<String, dynamic> get properties => {
        'list': hints,
      };

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'list':
        hints = [for (var story in value) HintModel().fromJson(story)];
        break;
    }

    super.setProp(key, value);
  }
}
