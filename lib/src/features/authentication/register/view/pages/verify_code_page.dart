
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/constans/assets_paths.dart';
import 'package:impo/src/core/app/constans/messages.dart';
import 'package:impo/src/core/app/view/widgets/design_size_figma.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/core/app/utiles/helper/custom_decoder_lottie.dart';
import 'package:impo/src/core/app/view/themes/styles/buttons/button_types.dart';
import 'package:impo/src/core/app/view/widgets/animations/position_animations.dart';
import 'package:impo/src/core/app/view/widgets/loading/loading_indicator_widget.dart';
import 'package:impo/src/features/activation/controller/get_questions_controller.dart';
import 'package:impo/src/features/authentication/register/controller/resend_code_controller.dart';
import 'package:impo/src/features/authentication/register/controller/verify_code_controller.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../../../../core/app/view/widgets/background_register_widget.dart';
import '../../../../../core/app/view/widgets/logo_widget.dart';
import '../widgets/pin_widget.dart';

class VerifyCodePage extends StatelessWidget {
  const VerifyCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DesignSizeFigma(
      builder: (BuildContext context){
        return Scaffold(
          body: BackgroundRegisterWidget(
           back: AssetPaths.backRegister,
            content: Stack(
              alignment: Alignment.topLeft,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 44
                      ),
                      child: LogoWidget(),
                    ),
                    SizedBox(height: 16),
                    PositionAnimations.right(
                      animationController: VerifyCodeController.to.rightAnimationController,
                      child:  Column(
                        children: [
                          Text(
                            'کد عبور رو وارد کن',
                            style: context.textTheme.titleMedium,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'کد 6 رقمی ارسال شده به شماره ${VerifyCodeController.to.username} رو وارد کن',
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodySmall,
                          ),
                          SizedBox(height: 29),
                          Column(
                            children: [
                              Obx(
                                      () => PinWidget(
                                    length: 6,
                                    fillColor: Colors.transparent,
                                    focusNode: VerifyCodeController.to.focusNode,
                                    inactiveColor: context.colorScheme.outlineVariant,
                                    controller: VerifyCodeController.to.pinController,
                                    onChanged: VerifyCodeController.to.onPinChanged,
                                    state: VerifyCodeController.to.pinState.value,
                                    onCompleted: VerifyCodeController.to.setIdentity,
                                  )
                              ),
                              // SizedBox(height: 20),
                              Obx(
                                    () {
                                  if (ResendCodeController.to.timeOut.value == 0) {
                                    return TextButton(
                                      // style: context.buttonThemes.elevatedButtonStyle(size: ButtonSizes.small),
                                      style: context.buttonThemes.textButtonStyle(size: ButtonSizes.small),
                                      onPressed: ResendCodeController.to.resendCode,
                                      child: Text(Messages.notReceiveCode),
                                    );
                                  } else {
                                    return ResendCodeController.to.obx(
                                          (_) => Obx(
                                            () => Text(
                                          '${Messages.notReceiveCode}(00:${NumberFormat("00").format(ResendCodeController.to.timeOut.value)})',
                                          style: context.textTheme.bodyMedium,
                                        ),
                                      ),
                                      onLoading: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 56),
                                        child: LoadingIndicatorWidget(),
                                      ),
                                    );
                                  }
                                },
                              ),
                              SizedBox(height: 16),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  GetQuestionsController.to.obx(
                                          (_) => Lottie.asset(
                                        'assets/json/success.lottie',
                                        // controller: VerifyCodeController.to.lottieController,
                                        // onLoaded: (composition) {
                                        //   // Configure the AnimationController with the duration of the
                                        //   // Lottie file and start the animation.
                                        //   VerifyCodeController.to.lottieController
                                        //     ..duration = composition.duration
                                        //     ..forward();
                                        // },
                                        decoder: customDecoder,
                                        width: 48,
                                      ),
                                      onLoading: SizedBox.shrink()
                                  ),
                                  VerifyCodeController.to.obx(
                                          (_) => SizedBox.shrink(),
                                      onLoading: SizedBox(
                                        width: 29,
                                        height: 29,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )
          ),
        );
      },
    );
  }
}
