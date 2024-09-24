import 'package:taakitecture/taakitecture.dart';

import '../datasources/edit_cycle_datasource.dart';

class EditCycleRepository extends BaseRemoteRepository {
  EditCycleRepository(EditCycleDatasource super.remoteDataSource, super.networkInfo);
}
