import 'package:impo/src/core/app/constans/api_paths.dart';
import 'package:taakitecture/taakitecture.dart';
import '../models/validate_register_model.dart';


class RegisterRemoteDataSource extends BaseRemoteDatasource {
  RegisterRemoteDataSource(IClient client)
      : super(
    client: client,
    model: ValidateRegisterModel(),
    path: ApiPaths.register,
  );
}
