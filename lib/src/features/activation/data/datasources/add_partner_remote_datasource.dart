import 'package:impo/src/core/app/constans/api_paths.dart';
import 'package:impo/src/core/app/model/valid_model.dart';
import 'package:taakitecture/taakitecture.dart';


class AddPartnerRemoteDataSource extends BaseRemoteDatasource {
  AddPartnerRemoteDataSource(IClient client)
      : super(
    client: client,
    model: ValidModel(),
    path: ApiPaths.createPartner,
  );
}
