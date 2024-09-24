
import 'package:impo/src/core/app/constans/api_paths.dart';
import 'package:taakitecture/taakitecture.dart';
import '../models/subscription_model.dart';

class SubscriptionRemoteDatasource extends BaseRemoteDatasource{
  SubscriptionRemoteDatasource(IClient client)
      : super(
    client: client,
    model: SubscriptionModel(),
    path: ApiPaths.subscription,
  );
}