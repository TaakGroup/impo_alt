import 'dart:ui';

import 'package:taakitecture/taakitecture.dart';
import 'base_data_widget_model.dart';

class ArticleItemModel extends BaseModel with ModelMixin {
  late String image;
  late String title;
  late String link;

  @override
  BaseModel getInstance() => ArticleItemModel();

  @override
  Map<String, dynamic> get properties => {
        'image': image,
        'title': title,
        'link': link,
      };

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'image':
        image = value;
        break;
      case 'title':
        title = value;
        break;
      case 'link':
        link = value;
        break;
    }
  }
}

class ArticlesWidgetModel extends BaseDataWidgetModel {
  late List<ArticleItemModel> list;

  @override
  BaseModel getInstance() => ArticlesWidgetModel();

  @override
  Map<String, dynamic> get properties => {'list': list};

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'items':
        list = [for (var json in value) ArticleItemModel().fromJson(json)];
        break;
    }

    super.setProp(key, value);
  }
}
