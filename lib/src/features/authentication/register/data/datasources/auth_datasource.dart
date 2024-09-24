import 'package:impo/src/core/app/constans/api_paths.dart';
import 'package:taakitecture/taakitecture.dart';

import '../models/auth_model.dart';


class AuthRemoteDataSource extends BaseRemoteDatasource {
  AuthRemoteDataSource(IClient client)
      : super(
          client: client,
          model: AuthModel(),
          path: ApiPaths.auth,
        );
}
