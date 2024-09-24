import 'package:taakitecture/taakitecture.dart';

import '../social/data/datasources/share_experience_file_remote_datasource.dart';
import '../social/data/repositories/share_experience_file_repository.dart';
import 'controller/edit_share_experience_profile_controller.dart';
import 'controller/follow_notification_controller.dart';
import 'controller/share_experience_profile_activities_controller.dart';
import 'controller/share_experience_profile_controller.dart';
import 'controller/upload_share_experience_profile_controller.dart';
import 'data/datasources/share_experience_activities_datasource.dart';
import 'data/datasources/share_experience_profile_datasource.dart';
import 'data/repositories/share_experience_activities_repository.dart';
import 'data/repositories/share_experience_profile_repository.dart';

class ShareExperienceProfileBindings extends Injection {
  @override
  initController() {
    singleton(ShareExperienceProfileController(sl<ShareExperienceProfileRepository>()));
    singleton(FollowNotificationController(sl<ShareExperienceProfileRepository>()));
  }

  @override
  initDataSource() {
    singleton(ShareExperienceProfileDatasource(sl()));
  }

  @override
  initRepository() {
    singleton(ShareExperienceProfileRepository(sl<ShareExperienceProfileDatasource>(), sl()));
  }
}

class ShareExperienceProfileActivityBindings extends Injection {
  @override
  initController() {
    singleton(ShareExperienceProfileActivitiesController(sl<ShareExperienceActivityRepository>()));
  }

  @override
  initDataSource() {
    singleton(ShareExperienceActivityDatasource(sl()));
  }

  @override
  initRepository() {
    singleton(ShareExperienceActivityRepository(sl<ShareExperienceActivityDatasource>(), sl()));
  }
}

class EditShareExperienceProfileBindings extends Injection {
  @override
  initController() {
    singleton(EditShareExperienceProfileController(sl<ShareExperienceProfileRepository>()));
    singleton(UploadShareExperienceProfileController(sl<ShareExperienceFileRepository>()));
  }

  @override
  initDataSource() {
    singleton(ShareExperienceProfileDatasource(sl()));
    singleton(ShareExperienceFileRemoteDatasource(sl()));
  }

  @override
  initRepository() {
    singleton(ShareExperienceProfileRepository(sl<ShareExperienceProfileDatasource>(), sl()));
    singleton(ShareExperienceFileRepository(sl<ShareExperienceFileRemoteDatasource>(), sl()));
  }
}
