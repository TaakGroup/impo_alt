import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/constans/app_routes.dart';
import 'package:impo/src/core/app/constans/messages.dart';
import 'package:impo/src/core/app/model/record_model.dart';
import 'package:impo/src/core/app/packages/url_launcher/implementation/url_launcher.dart';
import 'package:impo/src/core/app/view/widgets/dialog/base_dialog.dart';
import 'package:impo/src/core/app/view/widgets/toast.dart';
import 'package:taakitecture/taakitecture.dart';
import '../../../../core/app.dart';
import '../data/repositories/auth_repository.dart';

abstract class IRegisterController extends BaseController with GetTickerProviderStateMixin {
  SnackbarController? snackbarController;
  final formKey = GlobalKey<FormState>();
  late TextEditingController userIdentityTextEditingController;
  final AuthRemoteRepository authRemoteRepository;
  RxDouble topPaddingLogo = 215.0.obs;
  late AnimationController titleAnimationController;
  late AnimationController subTitleAnimationController;
  late AnimationController buttonAnimationController;
  late TapGestureRecognizer tapGestureRecognizer;
  late FocusNode identityFocusNode = FocusNode();

  IRegisterController(super.remoteRepository, this.authRemoteRepository);


  @override
  onInit() async {
    change(null, status: RxStatus.success());
    initTapGestureRecognizer();
    initTextEditingController();
    initAnimation();
    super.onInit();
  }

  initTextEditingController(){
    userIdentityTextEditingController = TextEditingController()..addListener(() {
      if(userIdentityTextEditingController.text.length >= 11){
        change(null,status: RxStatus.success());
        buttonAnimationController.forward();
      }else{
        buttonAnimationController.reverse();
      }
    });
  }

  initTapGestureRecognizer(){
    tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = _handlePress;
  }


  _handlePress() {
    UrlLauncher().launchWeb('https://impo.app/privacy.html');
  }


  onChangedInput(String value){
    if(!status.isSuccess) change(null,status: RxStatus.success());
  }

  @override
  void dispose() {
    snackbarController?.close();
    userIdentityTextEditingController.dispose();
    titleAnimationController.dispose();
    subTitleAnimationController.dispose();
    tapGestureRecognizer.dispose();
    buttonAnimationController.dispose();
    super.dispose();
  }

  initAnimation() async {
    titleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    subTitleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );

    buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );
    forwardAnim();
  }

  forwardAnim()async{
    await titleAnimationController.forward();
    await subTitleAnimationController.forward();
    await moveLogo();
    Future.delayed(Duration(milliseconds: 250),(){
      identityFocusNode.requestFocus();
    });
  }


  Future<void> moveLogo()async {
    Future.delayed(Duration(milliseconds: 100),(){
      topPaddingLogo.value = 44;
    });
  }

  sendCode() async {
    return edit(
      model: JsonModel({
        "identity": userIdentityTextEditingController.text,
        "phoneModel": App.phoneModel,
      }),
    );
  }


  Future statusIdentity() async {
    onLoading();

    final resultOrFailure = await authRemoteRepository.find(userIdentityTextEditingController.text);

    await resultOrFailure.fold(
      (failures) async => onFailure(userIdentityTextEditingController.text, failures, statusIdentity),
      (result) {
        if (result.isRegister) {
          change(null, status: RxStatus.success());
          BaseDialog.show(
            description: dialogText,
            action: () => print('GoToLoginPage'),
          );
        } else {
          return sendCode();
        }
      },
    );
  }

  String get dialogText;

  // onLogin();


  @override
  onSuccess(result) {
    Get.toNamed(AppRoutes.verifyCode, arguments: userIdentityTextEditingController.text);
    super.onSuccess(result);
  }

  @override
  onFailure(String requestId, Failure failure, Function action) {
    change(null, status: RxStatus.success());

    toast(message: Messages.serverFailureTitle, snackPosition: SnackPosition.TOP);
  }

  @override
  onLoading() {
    snackbarController?.close();
    return super.onLoading();
  }

}
