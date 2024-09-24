import 'package:impo/src/features/index/controller/index_controller.dart';
import 'package:impo/src/features/index/controller/action_controller.dart';
import 'package:impo/src/features/index/data/datasources/edit_cycle_datasource.dart';
import 'package:taakitecture/taakitecture.dart';
import 'controller/cycle_controller.dart';
import 'controller/story_controller.dart';
import 'data/datasources/index_datasource.dart';
import 'data/datasources/story_datasource.dart';
import 'data/repositories/edit_cycle_repository.dart';
import 'data/repositories/index_repository.dart';
import 'data/repositories/story_repository.dart';

class IndexBindings extends Injection {
  @override
  initController() {
    singleton(CycleController());
    singleton(IndexController(sl<IndexRepository>()));
  }

  @override
  initDataSource() {
    singleton(IndexDatasource(sl()));
  }

  @override
  initRepository() {
    singleton(IndexRepository(sl(), sl()));
  }
}

class StoryBindings extends Injection {
  @override
  initController() {
    singleton(StoryServiceController(sl<StoryRepository>()));
  }

  @override
  initDataSource() {
    singleton(StoryDatasource(sl()));
  }

  @override
  initRepository() {
    singleton(StoryRepository(sl(), sl()));
  }
}

class EditCycleBindings extends Injection {
  @override
  initController() {
    singleton(ActionController(sl<EditCycleRepository>()));
  }

  @override
  initDataSource() {
    singleton(EditCycleDatasource(sl()));
  }

  @override
  initRepository() {
    singleton(EditCycleRepository(sl(), sl()));
  }
}


