import 'package:social/features/share_experience/profile/data/models/share_experience_profile_model.dart';
import 'package:taakitecture/taakitecture.dart';
import '../../../../../core/app/constants/api_paths.dart';

class ShareExperienceProfileDatasource extends BaseRemoteDatasource {
  ShareExperienceProfileDatasource(IClient client)
      : super(
          client: client,
          model: ShareExperienceProfileModel(),
          path: ApiPaths.shareExperienceProfile,
        );
}
