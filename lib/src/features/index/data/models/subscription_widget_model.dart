import 'package:taakitecture/taakitecture.dart';

import '../../../subscription/data/models/subscription_model.dart';
import 'base_data_widget_model.dart';
import 'button_model.dart';

class SubscriptionWidgetModel extends BaseDataWidgetModel {
  ButtonModel? headlineButton;
  late SubscriptionPackagesModel package;
  late ButtonModel submitButton;

  @override
  BaseModel getInstance() => SubscriptionWidgetModel();

  @override
  Map<String, dynamic> get properties => {};

  @override
  void setProp(String key, value) {
    super.setProp(key, value);

    switch (key) {
      case 'headlineButton':
        headlineButton = ButtonModel().fromJson(value);
        break;
      case 'package':
        package = SubscriptionPackagesModel().fromJson(value);
        break;
      case 'submitButton':
        submitButton = ButtonModel().fromJson(value);
        break;
    }
  }
}
