import 'package:taakitecture/taakitecture.dart';

import '../models/questions_model.dart';


class QuestionsRemoteRepository extends BaseRemoteRepository<QuestionsModel> {
  QuestionsRemoteRepository(super.baseRemoteDataSource, super.networkInfo);
}