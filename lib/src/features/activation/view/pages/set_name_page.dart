import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/constans/assets_paths.dart';
import 'package:impo/src/core/app/view/themes/styles/decorations.dart';
import 'package:impo/src/core/app/view/widgets/design_size_figma.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/core/app/view/widgets/animations/position_animations.dart';
import 'package:impo/src/features/activation/controller/set_name_controller.dart';
import 'package:impo/src/core/app/view/widgets/background_register_widget.dart';
import 'package:impo/src/core/app/view/widgets/logo_widget.dart';

class SetNamePage extends StatelessWidget {
  const SetNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DesignSizeFigma(
      builder: (BuildContext context) {
        return Scaffold(
            body: BackgroundRegisterWidget(
              back: AssetPaths.backRegister,
              content: Stack(
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
                        animationController: SetNameController.to.rightAnimationController,
                        child: Column(
                          children: [
                            Text(
                              SetNameController.to.description,
                              style: context.textTheme.bodySmall,
                            ),
                            SizedBox(height: 4),
                            Text(
                              SetNameController.to.title,
                              textAlign: TextAlign.center,
                              style: context.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 28),
                      TextField(
                        textAlign: TextAlign.center,
                        autofocus: true,
                        controller: SetNameController.to.nameTextEditingController,
                        style: context.textTheme.titleLarge,
                        onChanged: SetNameController.to.onChangeName,
                        maxLength: 11,
                        decoration: InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                  PositionAnimations.bottom(
                    animationController: SetNameController.to.buttonAnimationController,
                    curve: Curves.easeIn,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 16
                        ),
                        child: SizedBox(
                          width: Decorations.widthButtonActivation,
                          child: ElevatedButton(
                            style: context.buttonThemes.elevatedButtonStyle(
                            ),
                            onPressed: SetNameController.to.nextPressed,
                            child: Text('ادامه'),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
        );
      },
    );
  }
}
