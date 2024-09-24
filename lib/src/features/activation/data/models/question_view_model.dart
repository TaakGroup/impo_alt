
import 'package:impo/src/features/activation/data/models/questions_page_model.dart';
import 'package:taakitecture/taakitecture.dart';

class QuestionViewModel extends BaseModel with ModelMixin {
  late String title;
  late List<OptionsQuestionsPageModel> questions;
  late String description;
  late String subtitl;
  late String progressBar;
  @override
  BaseModel getInstance() => QuestionViewModel();

  @override
  // TODO: implement properties
  Map<String, dynamic> get properties => throw UnimplementedError();

  @override
  void setProp(String key, value) {
    // TODO: implement setProp
  }

}
