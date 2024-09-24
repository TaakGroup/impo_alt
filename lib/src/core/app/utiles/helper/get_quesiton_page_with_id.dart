

import 'package:impo/src/features/activation/controller/get_questions_controller.dart';
import 'package:impo/src/features/activation/data/models/questions_page_model.dart';

QuestionsPageModel getQuestionsPageWithId(int id) {
  return GetQuestionsController.to.questions.items
      .where((e) => e.id == id).toList().first.page;
}