import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/widgets/toast.dart';
import 'package:impo/src/features/activation/controller/get_questions_controller.dart';
import 'package:impo/src/features/authentication/register/data/models/register_otp_model.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:taakitecture/taakitecture.dart';
import '../../../../core/app.dart';
import '../../../../core/app/utiles/classes/vibration.dart';
import '../../../../core/app/view/widgets/snackbar/snackbar.dart';
import '../data/models/register_otp_result_model.dart';
import '../view/widgets/pin_widget.dart';

class VerifyCodeController extends BaseController<RegisterOtpResultModel> with GetTickerProviderStateMixin {
  SnackbarController? snackbarController;
  final String username = Get.arguments;
  TextEditingController pinController = TextEditingController();
  Rx<PinState> pinState = PinState.normal.obs;
  late AnimationController lottieController;
  late AnimationController rightAnimationController;
  FocusNode focusNode = FocusNode();

  VerifyCodeController(super.remoteRepository);

  static VerifyCodeController get to => Get.find<VerifyCodeController>();

  @override
  void onInit() {
    initAnim();
    change(null, status: RxStatus.success());
    super.onInit();
  }

  initAnim(){
    rightAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    lottieController = AnimationController(vsync: this,duration: Duration(milliseconds: 1000));
  }

  void onPinChanged(String pin) {
    if (pin.length != 5) {
      pinState.value = PinState.normal;
    }
  }

  RegisterOtpModel buildRegisterModel(String code) {
    return RegisterOtpModel.fromValue(identity: username, code: code, phoneModel: App.phoneModel);
  }

  setIdentity(String token) {
    lottieController.forward();
    create(model: buildRegisterModel(token));
  }

  @override
  onSuccess(result) async {
    if (result.result) {
      Get.focusScope?.unfocus();
      pinState.value = PinState.success;
      onCodeVerified();
    } else {
      pinState.value = PinState.error;
      toast(message: 'کد عبور وارد شده اشتباه است',snackPosition: SnackPosition.TOP);
      focusNode.requestFocus();
      change(result,status: RxStatus.success());
      Future.delayed(
        const Duration(milliseconds: 1000),
            () => pinController.clear(),
      );
    }
    // return super.onSuccess(result);
  }

  onCodeVerified() => GetQuestionsController.to.getQuestions();

  @override
  onFailure(String requestId, Failure failure, Function action) {
    snackbarController?.close();
    snackbarController = Snackbar.serviceFailure(retry: () => action());
  }

  @override
  onLoading() {
    snackbarController?.close();
    return super.onLoading();
  }

  @override
  void dispose() async {
    await SmsAutoFill().unregisterListener();
    pinController.dispose();
    snackbarController?.close();
    super.dispose();
  }
}
