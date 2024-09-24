import 'package:taakitecture/taakitecture.dart';
import '../../../../core/app/constants/api_paths.dart';
import '../models/file_response_model.dart';

class FileRemoteDatasource extends BaseRemoteDatasource {
  FileRemoteDatasource(IClient client)
      : super(
          client: client,
          model: FileResponseModel(),
          path: ApiPaths.file,
        );
}
