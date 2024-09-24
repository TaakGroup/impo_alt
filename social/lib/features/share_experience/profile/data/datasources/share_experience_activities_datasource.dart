import 'package:social/features/share_experience/profile/data/models/share_experience_profile_model.dart';
import 'package:taakitecture/taakitecture.dart';
import '../../../../../core/app/constants/api_paths.dart';
import '../models/share_experience_activities_model.dart';

class ShareExperienceActivityDatasource extends BaseRemoteDatasource {
  ShareExperienceActivityDatasource(IClient client)
      : super(
          client: client,
          model: ShareExperienceActivitiesModel(),
          path: ApiPaths.shareExperienceProfile,
        );
}
