import 'package:taakitecture/taakitecture.dart';

import '../../../../../core/app/constants/api_paths.dart';
import '../model/comment_model.dart';

class CommentDatasource extends BaseRemoteDatasource {
  CommentDatasource(IClient client)
      : super(
          client: client,
          model: CommentModel(),
          path: ApiPaths.comment,
        );
}
