import 'package:taakitecture/taakitecture.dart';
import 'controller/messenger_controller.dart';
import 'data/datasources/file_datasource.dart';
import 'data/datasources/messenger_datasource.dart';
import 'data/repositories/file_repository.dart';
import 'data/repositories/messenger_repository.dart';

class MessengerBindings extends Injection {
  @override
  initController() {
    singleton(MessengerController(sl<MessengerRepository>()));
  }

  @override
  initDataSource() {
    singleton(MessengerRemoteDatasource(sl()));
  }

  @override
  initRepository() {
    singleton(MessengerRepository(sl<MessengerRemoteDatasource>(), sl()));
  }
}

