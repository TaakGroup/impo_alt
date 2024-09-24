import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/utiles/classes/arc_clipper.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/core/app/view/widgets/animations/position_animations.dart';
import 'package:impo/src/core/app/view/widgets/design_size_figma.dart';
import 'package:impo/src/core/app/view/widgets/logo_widget.dart';
import 'package:impo/src/features/activation/controller/question_controller.dart';
import 'package:impo/src/features/activation/view/widgets/back_activation_widget.dart';
import 'package:impo/src/features/activation/view/widgets/header_activation_widget.dart';
import 'package:impo/src/features/activation/view/widgets/option_question_item_widget.dart';
import '../../../../core/app/view/themes/styles/decorations.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DesignSizeFigma(
      builder: (BuildContext context) {
        return Scaffold(
          body: GetBuilder<QuestionController>(builder: (controller) {
            return Obx(() => Stack(
                  // alignment: Alignment.bottomCenter,
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                              bottom: 80,
                              top: 300,
                              right: 16,
                              left: 16
                          ),
                          itemCount: controller.question.value.questions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return OptionQuestionItemWidget(
                              item: controller.question.value.questions[index],
                              onTap: () => controller.onTabItems(index),
                            );
                          },
                        ),
                        ClipPath(
                            clipper: ArcClipper(),
                            child: Container(
                                color: Colors.white,
                                child: HeaderActivationWidget(progressBar: controller.question.value.progressBar)
                            )
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: context.mediaQuery.viewPadding.top + Decorations.paddingTop + 44),
                              child: LogoWidget(),
                            ),
                            SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                controller.question.value.title,
                                textAlign: TextAlign.center,
                                style: context.textTheme.titleSmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    BackActivationWidget(),
                    PositionAnimations.bottom(
                      animationController: controller.buttonAnimationController,
                      // curve: Curves.easeIn,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 32,
                          ),
                          child: SizedBox(
                            width: Decorations.widthButtonActivation,
                            child: ElevatedButton(
                              style: context.buttonThemes.elevatedButtonStyle(),
                              onPressed: controller.nextSubmit,
                              child: Text('ادامه'),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ));
          }),
        );
      },
    );
  }
}
