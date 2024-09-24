import 'package:taakitecture/taakitecture.dart';
import '../models/subscription_model.dart';


class SubscriptionRemoteRepository extends BaseRemoteRepository<SubscriptionModel> {
  SubscriptionRemoteRepository(super.baseRemoteDataSource, super.networkInfo);
}