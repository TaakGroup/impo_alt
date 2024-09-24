import 'package:audioplayers/audioplayers.dart';
import 'package:story_view/models/story_model.dart';
import 'package:taakitecture/taakitecture.dart';
import 'base_data_widget_model.dart';

class StoryWidgetModel extends BaseDataWidgetModel {
  late List<StoryModel> stories;

  @override
  BaseModel getInstance() => StoryWidgetModel();

  @override
  Map<String, dynamic> get properties => {
        'stories': stories,
      };

  @override
  void setProp(String key, value) {
    switch (key) {
      case 'list':
        stories = [for (var story in value) StoryModel.fromJson(story)];
        break;
    }

    super.setProp(key, value);
  }
}
