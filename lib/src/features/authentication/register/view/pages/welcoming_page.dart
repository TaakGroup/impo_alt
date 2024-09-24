import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/constans/assets_paths.dart';
import 'package:impo/src/core/app/view/widgets/design_size_figma.dart';
import 'package:impo/src/core/app/view/widgets/animations/fade_animations.dart';
import 'package:impo/src/features/authentication/register/controller/welcoming_controller.dart';
import 'package:impo/src/core/app/view/widgets/background_register_widget.dart';
import 'package:impo/src/core/app/view/widgets/logo_widget.dart';

class WelcomingPage extends StatelessWidget{
  const WelcomingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DesignSizeFigma(
        builder: (BuildContext context) {
          return Scaffold(
              body: BackgroundRegisterWidget(
                back: AssetPaths.backRegister,
                content: Column(
                  children: [
                    SizedBox(height: 231),
                    FadeAnimations(
                        animationController: WelcomingController.to.logoAnimationController,
                        child: LogoWidget()
                    ),
                    SizedBox(height: 16),
                    FadeAnimations(
                      animationController: WelcomingController.to.titleAnimationController,
                      child: Text(
                        'عزیز مهربون سلام!',
                        style: context.textTheme.titleMedium,
                      ),
                    ),
                    SizedBox(height: 8),
                    FadeAnimations(
                      animationController: WelcomingController.to.subTitleAnimationController,
                      child: Text(
                        'خوشحالیم که ب خودت اهمیت میدی و برای مراقبت از خودت به جمع ایمپویی‌ها پیوستی',
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              )
          );
        },
    );
  }
}



