import 'package:get/get.dart';
import 'package:impo/src/core/app/model/record_model.dart';
import 'package:taakitecture/taakitecture.dart';

class StoryServiceController extends BaseController {
  StoryServiceController(super.remoteRepository);

  static StoryServiceController get to => Get.find();

  seenStory(String id) {
    create(params: 'view/$id', model: JsonModel());
    update();
  }
}
