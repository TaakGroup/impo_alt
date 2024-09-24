import 'package:get/get.dart';
import 'package:impo/src/core/app.dart';
import 'package:impo/src/core/app/constans/app_routes.dart';
import 'package:impo/src/core/app/utiles/helper/generate_randrom_passwird.dart';
import 'package:impo/src/features/authentication/register/controller/verify_code_controller.dart';
import 'package:taakitecture/taakitecture.dart';
import '../../../core/app/utiles/classes/vibration.dart';
import '../../authentication/register/controller/register_controller.dart';
import '../data/models/questions_model.dart';

class GetQuestionsController extends BaseController<QuestionsModel>{
  GetQuestionsController(super.remoteRepository);
  static GetQuestionsController get to => Get.find();

  late QuestionsModel questions;


  getQuestions() => find();

  @override
  onSuccess(QuestionsModel result) {
    CustomVibration().heavyVibrator();
    questions = result;
    RegisterController.to.registerModel.identity = VerifyCodeController.to.username;
    RegisterController.to.registerModel.password = getRandomPassword(6);
    RegisterController.to.registerModel.phoneModel = App.phoneModel;
    VerifyCodeController.to.change(null,status: RxStatus.success());
    Future.delayed(
      const Duration(milliseconds: 2000),
          () => Get.offAllNamed(AppRoutes.setName)
    );
    return super.onSuccess(result);
  }



}