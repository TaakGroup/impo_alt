
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/constans/assets_paths.dart';
import 'package:impo/src/core/app/view/themes/styles/decorations.dart';
import 'package:impo/src/core/app/view/widgets/design_size_figma.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/core/app/view/themes/styles/buttons/loading_button/elevation_loading_button.dart';
import 'package:impo/src/core/app/view/widgets/animations/fade_animations.dart';
import 'package:impo/src/core/app/view/widgets/animations/position_animations.dart';
import 'package:impo/src/features/authentication/register/controller/register_number_controller.dart';
import 'package:impo/src/core/app/view/widgets/background_register_widget.dart';
import 'package:impo/src/core/app/view/widgets/logo_widget.dart';
import 'package:impo/src/features/authentication/register/view/widgets/button_change_type_widget.dart';

class RegisterNumberPage extends StatelessWidget {
  const RegisterNumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DesignSizeFigma(
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Scaffold(
              body: BackgroundRegisterWidget(
                back: AssetPaths.backRegister,
                content: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 16),
                        Obx(
                              () =>  AnimatedContainer(
                              curve: Curves.easeOutBack,
                              padding: EdgeInsets.only(
                                  top: RegisterNumberController.to.topPaddingLogo.value
                              ),
                              duration: Duration(milliseconds: 500),
                              child: LogoWidget()
                          ),
                        ),
                        SizedBox(height: 16),
                        FadeAnimations(
                          animationController: RegisterNumberController.to.titleAnimationController,
                          child: Text(
                            'برای شروع شماره همراهت رو وارد کن',
                            style: context.textTheme.titleMedium,
                          ),
                        ),
                        SizedBox(height: 4),
                        FadeAnimations(
                          animationController: RegisterNumberController.to.subTitleAnimationController,
                          child: Text(
                            'یک کد 6 رقمی از طرف ایمپو برات پیامک میشه.',
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodySmall,
                          ),
                        ),
                        // SizedBox(height: 10),
                        TextField(
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          focusNode: RegisterNumberController.to.identityFocusNode,
                          controller: RegisterNumberController.to.userIdentityTextEditingController,
                          style: context.textTheme.titleLarge,
                          maxLength: 11,
                          autofocus: RegisterNumberController.to.autofocus,
                          keyboardType: TextInputType.phone,
                          onChanged: RegisterNumberController.to.onChangedInput,
                          decoration: InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                    FadeAnimations(
                      animationController: RegisterNumberController.to.titleAnimationController,
                      child: ButtonChangeTypeWidget(
                        text: 'ورود/ثبت نام با ایمیل',
                        onPressed: () => RegisterNumberController.to.goToEmailPage(context),
                      )
                    ),
                    PositionAnimations.bottom(
                      animationController: RegisterNumberController.to.buttonAnimationController,
                      curve: Curves.easeIn,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: Decorations.widthButtonActivation,
                              child: ElevationStateButton(
                                onPressed: RegisterNumberController.to.onNextStepPressed,
                                text: 'دریافت کد ورود',
                                state: RegisterNumberController.to,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 24,
                                  bottom: 15
                              ),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    text : "با ورود به ایمپو",
                                    style: context.textTheme.labelSmall,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: ' قوانین و شرایط',
                                        recognizer: RegisterNumberController.to.tapGestureRecognizer,
                                        mouseCursor: SystemMouseCursors.precise,
                                        style: context.textTheme.labelSmall!.copyWith(
                                            decoration: TextDecoration.underline,
                                            color: context.colorScheme.primary
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' استفاده از اپلیکیشن رو می‌پذیرم',
                                        style: context.textTheme.labelSmall,
                                      ),
                                    ]
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
          ),
        );
      },
    );
  }
}
