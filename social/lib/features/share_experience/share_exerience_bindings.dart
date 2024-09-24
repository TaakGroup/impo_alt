import 'package:social/features/share_experience/social/controller/other_share_experience_controller.dart';
import 'package:social/features/share_experience/social/controller/share_experience_controller.dart';
import 'package:social/features/share_experience/social/controller/share_experience_media_controller.dart';
import 'package:social/features/share_experience/social/data/datasources/share_experience_datasource.dart';
import 'package:social/features/share_experience/social/data/datasources/share_experience_file_remote_datasource.dart';
import 'package:social/features/share_experience/social/data/repositories/share_experience_file_repository.dart';
import 'package:social/features/share_experience/social/data/repositories/share_experience_repository.dart';
import 'package:taakitecture/taakitecture.dart';

import 'comments/controller/reply_controller.dart';
import 'controller/new_experience_controller.dart';


class ShareExperienceBindings extends Injection {
  @override
  initController() {
    singleton(OtherShareExperienceController(sl<ShareExperienceRepository>()));
    // singleton(SelfShareExperienceController(sl<ShareExperienceRepository>()));
    singleton(ShareExperienceController(sl<ShareExperienceRepository>()));
    singleton(NewExperienceController(sl<ShareExperienceRepository>()));
    factory(() => ReplyController(sl<ShareExperienceRepository>()));
  }

  @override
  initDataSource() {
    singleton(ShareExperienceDatasource(sl()));
  }

  @override
  initRepository() {
    singleton(ShareExperienceRepository(sl<ShareExperienceDatasource>(), sl()));
  }
}

class UploadShareExperienceBindings extends Injection {
  @override
  initController() {
    factory(() => ShareExperienceMediaController(sl<ShareExperienceFileRepository>()));
  }

  @override
  initDataSource() {
    singleton(ShareExperienceFileRemoteDatasource(sl()));
  }

  @override
  initRepository() {
    singleton(ShareExperienceFileRepository(sl<ShareExperienceFileRemoteDatasource>(), sl()));
  }
}




