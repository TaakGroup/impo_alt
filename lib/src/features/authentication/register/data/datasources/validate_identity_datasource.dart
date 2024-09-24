import 'package:impo/src/core/app/constans/api_paths.dart';
import 'package:taakitecture/taakitecture.dart';
import '../models/register_otp_result_model.dart';

class ValidateIdentityDataSource extends BaseRemoteDatasource {
  ValidateIdentityDataSource(IClient client)
      : super(
          client: client,
          model: RegisterOtpResultModel(),
          path: ApiPaths.otp,
        );
}
