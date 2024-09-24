
import 'package:get/get.dart';
import 'package:impo/src/core/app/constans/app_routes.dart';
import 'package:impo/src/core/app/constans/messages.dart';
import 'package:impo/src/core/app/view/widgets/toast.dart';
import 'package:impo/src/features/activation/controller/date_picker_activation_controller.dart';
import 'package:impo/src/features/authentication/register/data/models/register_model.dart';
import 'package:impo/src/features/authentication/register/data/models/validate_register_model.dart';
import 'package:taakitecture/taakitecture.dart';

import '../../../../core/app/utiles/helper/box_helpers.dart';

class RegisterController extends BaseController<ValidateRegisterModel>{
  RegisterModel registerModel = RegisterModel();

  RegisterController(super.remoteRepository);
  static RegisterController get to => Get.find();

  setRegister() => create(model: registerModel);

  @override
  void onInit() {
    change(null,status: RxStatus.success());
    super.onInit();
  }

  @override
  onFailure(String requestId, Failure failure, Function action) {
    change(null, status: RxStatus.success());

    toast(message: Messages.serverFailureTitle, snackPosition: SnackPosition.TOP);
  }

  @override
  onSuccess(ValidateRegisterModel result) {
    saveUserInfo(result.token);
    if(result.pair){
      DatePickerActivationController.to.nextSubmit();
    }else{
      // Get.offAllNamed(AppRoutes.subscription);
      Get.offAllNamed(AppRoutes.index);
    }
    // return super.onSuccess(result);
  }

  saveUserInfo(String token){
    BoxHelper.setToken(token);
    BoxHelper.setUser(registerModel.identity!);
    BoxHelper.setPassword(registerModel.password!);
  }

}