
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/core/app/view/themes/styles/buttons/button_types.dart';
import 'package:impo/src/core/app/view/themes/styles/buttons/loading_button/elevation_loading_button.dart';
import 'package:impo/src/core/app/view/widgets/animations/position_animations.dart';
import 'package:impo/src/core/app/view/widgets/design_size_figma.dart';
import 'package:impo/src/features/activation/controller/date_picker_activation_controller.dart';
import 'package:impo/src/features/activation/view/widgets/calculate_week_pregnancy_widget.dart';
import 'package:impo/src/features/activation/view/widgets/menstruation/cycle_length_widget.dart';
import 'package:impo/src/features/activation/view/widgets/menstruation/peiod_length_widget.dart';
import 'package:impo/src/features/activation/view/widgets/period_planning_widget.dart';
import '../../../../core/app/view/themes/styles/decorations.dart';
import '../../../../core/app/view/widgets/logo_widget.dart';
import '../../../authentication/register/controller/register_controller.dart';
import '../widgets/back_activation_widget.dart';
import '../widgets/header_activation_widget.dart';
import '../widgets/menstruation/last_period_widget.dart';

class DatePickerActivationPage extends StatelessWidget {
  const DatePickerActivationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DesignSizeFigma(
      builder: (BuildContext context) {
        return Scaffold(
          body: GetBuilder<DatePickerActivationController>(
              builder: (controller) {
                return Obx(() => Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            HeaderActivationWidget(progressBar: controller.infoDatePicker.value.progressBar),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: context.mediaQuery.viewPadding.top + Decorations.paddingTop + 44),
                                  child: LogoWidget(),
                                ),
                                SizedBox(height: 7),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 13
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        controller.infoDatePicker.value.description,
                                        textAlign: TextAlign.center,
                                        style: context.textTheme.bodySmall,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        controller.infoDatePicker.value.title,
                                        textAlign: TextAlign.center,
                                        style: context.textTheme.titleSmall,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        controller.infoDatePicker.value.subtitl,
                                        textAlign: TextAlign.center,
                                        style: context.textTheme.bodySmall,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        checkDatePicker(controller)
                      ],
                    ),
                    BackActivationWidget(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        controller.pageId == 28 ? TextButton(
                            onPressed: controller.skipPeriodPlanning,
                            child: Text(
                                controller.infoDatePicker.value.questions.where((i) => i.id == 1 ).toList().first.text
                            )
                        ) : SizedBox.shrink(),
                        PositionAnimations.bottom(
                          animationController: controller.buttonAnimationController,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 32,
                              ),
                              child: controller.registrationPageIds.contains(controller.pageId) ?
                              SizedBox(
                                width: Decorations.widthButtonActivation,
                                child: ElevationStateButton(
                                    onPressed: RegisterController.to.setRegister,
                                    state: RegisterController.to,
                                    text: 'ثبت نام',
                                ),
                              )
                                  :
                              SizedBox(
                                width: Decorations.widthButtonActivation,
                                child: ElevatedButton(
                                  style: context.buttonThemes.elevatedButtonStyle(),
                                  onPressed: controller.nextSubmit,
                                  child: Text('ادامه'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
                );
              }
          ),
        );
      },
    );
  }

  Widget checkDatePicker(DatePickerActivationController controller){
    switch (controller.pageId){

      case 9:
      case 33:
      case 49:
        return LastPeriodWidget(controller: controller);

      case 10:
      case 34:
      case 50:
        return CycleLengthWidget(controller: controller);

      case 11:
      case 35:
      case 51:
        return PeriodLengthWidget(controller: controller);

      case 28:
        return PeriodPlanningWidget(controller: controller);

      case 63:
        return CalculateWeekPregnancyWidget(controller: controller);
    }
    return SizedBox();
  }

}
