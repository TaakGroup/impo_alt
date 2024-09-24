
import 'package:taakitecture/taakitecture.dart';

class RewardViewModel extends BaseModel with ModelMixin {
  late bool enable;
  late String btnLabel;
  late String btnLabel2;
  late String title;
  late String description;
  late String image;
  late List<String> gradient;
  late bool doRepeat;

  @override
  BaseModel getInstance() => RewardViewModel();

  @override
  // TODO: implement properties
  Map<String, dynamic> get properties => throw UnimplementedError();

  @override
  void setProp(String key, value) {
    // TODO: implement setProp
  }

}
