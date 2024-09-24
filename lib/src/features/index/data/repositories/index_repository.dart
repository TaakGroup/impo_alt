import 'package:taakitecture/taakitecture.dart';
import '../datasources/index_datasource.dart';

class IndexRepository extends BaseRemoteRepository {
  IndexRepository(IndexDatasource super.remoteDataSource, super.networkInfo);
}
