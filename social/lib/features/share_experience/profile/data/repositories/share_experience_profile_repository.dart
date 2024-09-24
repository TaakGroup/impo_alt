import 'package:dartz/dartz.dart';
import 'package:social/core/app/utils/helper/box_helpers.dart';
import 'package:taakitecture/taakitecture.dart';

import '../models/share_experience_profile_model.dart';

class ShareExperienceProfileRepository extends BaseRemoteRepository<ShareExperienceProfileModel> {
  ShareExperienceProfileRepository(super.remoteDataSource, super.networkInfo);


  @override
  Future<Either<Failure, ShareExperienceProfileModel>> find([String? params, Map<String, dynamic>? query]) async {
    final req = await super.find(params);

    req.fold((l) => null, (r) => saveProfile(r));

    return req;
  }

  saveProfile(ShareExperienceProfileModel shareExperienceProfileModel) {
    if (shareExperienceProfileModel.isSelf) {
      BoxHelper.saveShareExperienceProfile(shareExperienceProfileModel.profile);
    }
  }
}
