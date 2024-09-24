import 'package:social/features/messenger/data/models/messenger_model.dart';
import 'package:taakitecture/taakitecture.dart';
import '../../../../core/app/constants/api_paths.dart';

class MessengerRemoteDatasource extends BaseRemoteDatasource {
  MessengerRemoteDatasource(IClient client)
      : super(
          client: client,
          model: MessengerModel(),
          path: ApiPaths.chat,
        );
}
