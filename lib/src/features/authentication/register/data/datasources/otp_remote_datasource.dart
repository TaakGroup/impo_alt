import 'package:impo/src/core/app/constans/api_paths.dart';
import 'package:impo/src/features/authentication/register/data/models/register_otp_result_model.dart';
import 'package:taakitecture/taakitecture.dart';


class OtpRemoteDataSource extends BaseRemoteDatasource {
  OtpRemoteDataSource(IClient client)
      : super(
          client: client,
          model: RegisterOtpResultModel(),
          path: ApiPaths.setIdentity,
        );
}
