import 'package:taakitecture/taakitecture.dart';
import '../../../../../core/app/constants/api_paths.dart';
import '../models/share_experience_model.dart';

class ShareExperienceDatasource extends BaseRemoteDatasource {
  ShareExperienceDatasource(IClient client)
      : super(
          client: client,
          model: ShareExperienceModel(),
          path: ApiPaths.shareExperience,
        );
}
