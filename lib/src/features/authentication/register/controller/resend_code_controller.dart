import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app.dart';
import 'package:impo/src/core/app/model/record_model.dart';
import 'package:impo/src/core/app/view/widgets/snackbar/snackbar.dart';
import 'package:impo/src/features/authentication/register/controller/verify_code_controller.dart';
import 'package:taakitecture/taakitecture.dart';


class ResendCodeController extends BaseController with GetSingleTickerProviderStateMixin {
  RxInt timeOut = 60.obs;
  SnackbarController? snackbarController;

  ResendCodeController(super.remoteRepository);

  static ResendCodeController get to => Get.find();

  late final AnimationController resendButtonController;

  @override
  void onInit() {
    _initAnimation();
    change(null, status: RxStatus.success());
    startTimer(timeOut);
    super.onInit();
  }

  _initAnimation() {
    resendButtonController = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );
  }

  startTimer(RxInt timeOut) {
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        if (timeOut.value != 0) {
          timeOut.value--;
        } else {
          await resendButtonController.forward();
          timer.cancel();
        }
      },
    );
  }

  resendCode() async {
    await resendButtonController.reverse();
    edit(
      model: JsonModel({
        "identity": VerifyCodeController.to.username,
        "phoneModel": App.phoneModel,
      }),
    );
  }

  @override
  onSuccess(result) {
    timeOut.value = 60;
    startTimer(timeOut);
    super.onSuccess(result);
    // if (result.valid) {
    //   startTimer(timeOut);
    // } else {
    // showSnackbar(
    //     title: Messages.resendCodeError,
    //     iconType: SnackBarIconType.warning
    // );
    // }
  }

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
  void dispose() {
    snackbarController?.close();
    resendButtonController.dispose();
    super.dispose();
  }
}
