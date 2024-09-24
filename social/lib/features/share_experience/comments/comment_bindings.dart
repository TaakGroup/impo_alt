import 'package:taakitecture/taakitecture.dart';

import 'controller/comment_controller.dart';
import 'controller/create_reply_controller.dart';
import 'data/datasources/comment_datasource.dart';
import 'data/repositories/comment_repository.dart';

class CommentBindings extends Injection {
  @override
  initController() {
    singleton(CommentController(sl<CommentRepository>()));
    singleton(CreateReplyController(sl<CommentRepository>()));
  }

  @override
  initDataSource() {
    singleton(CommentDatasource(sl()));
  }

  @override
  initRepository() {
    singleton(CommentRepository(sl<CommentDatasource>(), sl()));
  }
}
