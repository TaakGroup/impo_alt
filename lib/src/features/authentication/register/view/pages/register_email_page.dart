
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/constans/assets_paths.dart';
import 'package:impo/src/core/app/view/themes/styles/decorations.dart';
import 'package:impo/src/core/app/view/widgets/design_size_figma.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/core/app/view/themes/styles/buttons/loading_button/elevation_loading_button.dart';
import 'package:impo/src/core/app/view/widgets/animations/fade_animations.dart';
import 'package:impo/src/core/app/view/widgets/animations/position_animations.dart';
import 'package:impo/src/core/app/view/widgets/background_register_widget.dart';
import 'package:impo/src/core/app/view/widgets/logo_widget.dart';
import 'package:impo/src/features/authentication/register/view/widgets/button_change_type_widget.dart';

import '../../controller/register_email_controller.dart';

class RegisterEmailPage extends StatelessWidget {
  const RegisterEmailPage({super.key});

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
                                  top: RegisterEmailController.to.topPaddingLogo.value
                              ),
                              duration: Duration(milliseconds: 500),
                              child: LogoWidget()
                          ),
                        ),
                        SizedBox(height: 16),
                        FadeAnimations(
                          animationController: RegisterEmailController.to.titleAnimationController,
                          child: Text(
                            'برای شروع میتونی با ایمیل وارد بشی',
                            style: context.textTheme.titleMedium,
                          ),
                        ),
                        SizedBox(height: 4),
                        FadeAnimations(
                          animationController: RegisterEmailController.to.subTitleAnimationController,
                          child: Text(
                            'یک کد 6 رقمی از طرف ایمپو برات ایمیل میشه.',
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodySmall,
                          ),
                        ),
                        // SizedBox(height: 10),
                        TextField(
                          textAlign: TextAlign.center,
                          //focusNode: RegisterEmailController.to.identityFocusNode,
                          autofocus: true,
                          textDirection: TextDirection.ltr,
                          controller: RegisterEmailController.to.userIdentityTextEditingController,
                          onChanged: RegisterEmailController.to.onChangedInput,
                          style: context.textTheme.titleLarge,
                          keyboardType: TextInputType.emailAddress,
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
                      animationController: RegisterEmailController.to.titleAnimationController,
                      child: ButtonChangeTypeWidget(
                        text: 'ورود/ثبت نام با شماره همراه',
                        onPressed: () => RegisterEmailController.to.goToNumberPage(context),
                      ),
                    ),
                    PositionAnimations.bottom(
                      animationController: RegisterEmailController.to.buttonAnimationController,
                      curve: Curves.easeIn,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: Decorations.widthButtonActivation,
                              child: ElevationStateButton(
                                onPressed: RegisterEmailController.to.onNextStepPressed,
                                text: 'دریافت کد ورود',
                                state: RegisterEmailController.to,
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
                                        recognizer: RegisterEmailController.to.tapGestureRecognizer,
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
