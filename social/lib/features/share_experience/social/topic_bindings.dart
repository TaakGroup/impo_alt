import 'package:taakitecture/taakitecture.dart';

import '../topic/controller/topic_controller.dart';
import '../topic/data/datasources/topic_remote_datasource.dart';
import '../topic/data/repositories/topic_repository.dart';

class TopicBindings extends Injection {
  @override
  initController() {
    singleton(TopicController(sl<TopicRepository>()));
  }

  @override
  initDataSource() {
    singleton(TopicRemoteDatasource(sl()));
  }

  @override
  initRepository() {
    singleton(TopicRepository(sl<TopicRemoteDatasource>(), sl()));
  }
}