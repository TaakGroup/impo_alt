import 'package:social/features/share_experience/topic/data/models/topic_model.dart';
import 'package:taakitecture/taakitecture.dart';

import '../../../../../core/app/constants/api_paths.dart';

class TopicRemoteDatasource extends BaseRemoteDatasource {
  TopicRemoteDatasource(IClient client)
      : super(
          client: client,
         model: TopicModel(),
         path: ApiPaths.topic,
        );
}
