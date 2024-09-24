import 'package:taakitecture/taakitecture.dart';
import '../models/auth_model.dart';

class AuthRemoteRepository extends BaseRemoteRepository<AuthModel> {
  AuthRemoteRepository(super.baseRemoteDataSource, super.networkInfo);
}