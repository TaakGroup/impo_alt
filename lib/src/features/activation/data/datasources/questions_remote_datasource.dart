import 'package:impo/src/core/app/constans/api_paths.dart';
import 'package:taakitecture/taakitecture.dart';
import '../models/questions_model.dart';



class QuestionsRemoteDataSource extends BaseRemoteDatasource {
  QuestionsRemoteDataSource(IClient client)
      : super(
    client: client,
    model: QuestionsModel(),
    path: ApiPaths.questions,
  );
}
