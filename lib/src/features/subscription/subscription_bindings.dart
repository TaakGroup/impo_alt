
import 'package:impo/src/features/subscription/controller/subscription_controller.dart';
import 'package:impo/src/features/subscription/data/datasources/subscription_remote_datasource.dart';
import 'package:impo/src/features/subscription/data/repositories/subscription_repository.dart';
import 'package:taakitecture/taakitecture.dart';

import 'controller/direct_payment_controller.dart';

class SubscriptionBindings extends Injection{
  @override
  initController() {
    singleton(SubscriptionController(sl<SubscriptionRemoteRepository>()));
    singleton(DirectPayController());
    singleton(FreePayController());
  }

  @override
  initDataSource() {
    singleton(SubscriptionRemoteDatasource(sl()));
  }

  @override
  initRepository() {
    singleton(SubscriptionRemoteRepository(sl<SubscriptionRemoteDatasource>(),sl()));
  }

}