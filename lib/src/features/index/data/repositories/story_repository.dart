import 'package:taakitecture/taakitecture.dart';
import '../datasources/story_datasource.dart';

class StoryRepository extends BaseRemoteRepository {
  StoryRepository(StoryDatasource super.remoteDataSource, super.networkInfo);
}
