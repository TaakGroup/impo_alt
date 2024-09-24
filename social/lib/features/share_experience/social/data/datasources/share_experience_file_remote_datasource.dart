import 'package:taakitecture/taakitecture.dart';
import '../../../../../core/app/constants/api_paths.dart';
import '../models/share_experience_file_model.dart';

class ShareExperienceFileRemoteDatasource extends BaseRemoteDatasource {
  ShareExperienceFileRemoteDatasource(IClient client)
      : super(
          client: client,
         model: ShareExperienceFileModel(),
         path: ApiPaths.shareExperienceFile,
        );
}
