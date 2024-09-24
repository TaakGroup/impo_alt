import 'package:dartz/dartz.dart';
import 'package:taakitecture/taakitecture.dart';
import '../../../../../core/app/utils/helper/box_helpers.dart';
import '../models/share_experience_model.dart';

class ShareExperienceRepository extends BaseRemoteRepository<ShareExperienceModel> {
  ShareExperienceRepository(super.remoteDataSource, super.networkInfo);

  @override
  Future<Either<Failure, ShareExperienceModel>> find([String? params, Map<String, dynamic>? query]) async {
    final req = await super.find(params);

    req.fold((l) => null, (r) => saveProfile(r));

    return req;
  }

  saveProfile(ShareExperienceModel shareExperienceProfileModel) {
    BoxHelper.saveShareExperienceProfile(shareExperienceProfileModel.profile);
  }
}
