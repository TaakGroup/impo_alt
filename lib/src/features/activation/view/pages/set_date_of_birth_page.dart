import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/constans/assets_paths.dart';
import 'package:impo/src/core/app/view/themes/styles/decorations.dart';
import 'package:impo/src/core/app/view/widgets/design_size_figma.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/core/app/view/widgets/animations/position_animations.dart';
import 'package:impo/src/core/app/view/widgets/jalali_date_picker_widget.dart';
import 'package:impo/src/features/activation/controller/set_data_of_birth_controller.dart';
import 'package:impo/src/core/app/view/widgets/background_register_widget.dart';
import 'package:shamsi_date/extensions.dart';

import '../../../../core/app/view/widgets/logo_widget.dart';
import '../widgets/back_activation_widget.dart';

class SetDateOfBirthPage extends StatelessWidget {
  const SetDateOfBirthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DesignSizeFigma(
      builder: (BuildContext context) {
        return Scaffold(
            body: BackgroundRegisterWidget(
              back: AssetPaths.backRegister,
              content: Stack(
                // alignment: Alignment.topLeft,
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
                        animationController: SetDataOfBirthController.to.rightAnimationController,
                        child: Column(
                          children: [
                            Text(
                              SetDataOfBirthController.to.description,
                              style: context.textTheme.bodySmall,
                            ),
                            SizedBox(height: 4),
                            Text(
                              SetDataOfBirthController.to.title,
                              textAlign: TextAlign.center,
                              style: context.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 28),
                      Expanded(
                        child: Container(
                          alignment: Alignment.topCenter,
                          // padding: const EdgeInsets.only(top: 80),
                          padding: const EdgeInsets.only(top: 30),
                          child: JalaliDatePickerWidget(
                            onChange: SetDataOfBirthController.to.onDateChange,
                            focusedDate: Jalali.now().addYears(-20),
                          ),
                        ),
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 32
                      ),
                      child: SizedBox(
                        width: Decorations.widthButtonActivation,
                        child: ElevatedButton(
                          style: context.buttonThemes.elevatedButtonStyle(),
                          onPressed: SetDataOfBirthController.to.nextPressed,
                          child: Text('ادامه'),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: -(context.mediaQuery.viewPadding.top + Decorations.paddingTop),
                      right: -16,
                      child: BackActivationWidget()
                  )
                ],
              ),
            )
        );
      },
    );
  }
}
