import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/themes/styles/buttons/loading_button/elevation_loading_button.dart';
import 'package:impo/src/core/app/view/themes/styles/decorations.dart';
import 'package:impo/src/core/app/view/widgets/animations/position_animations.dart';
import 'package:impo/src/core/app/view/widgets/design_size_figma.dart';
import 'package:impo/src/features/activation/controller/add_partner_controller.dart';
import 'package:impo/src/features/activation/view/widgets/back_activation_widget.dart';
import 'package:impo/src/features/activation/view/widgets/background_add_partner_widget.dart';
import '../../../../core/app/constans/assets_paths.dart';

class AppPartnerPage extends StatelessWidget {
  const AppPartnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DesignSizeFigma(
      builder: (BuildContext context) {
        return Scaffold(
            body: BackgroundAddPartnerWidget(
              content: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: context.mediaQuery.viewPadding.top + Decorations.paddingTop),
                      Image.asset(AssetPaths.partnerActivation),
                      SizedBox(height: 11),
                      Text(
                        AddPartnerController.to.title,
                        style: context.textTheme.titleMedium,
                      ),
                      SizedBox(height: 4),
                      Text(
                        AddPartnerController.to.description,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodySmall,
                      ),
                      SizedBox(height: 28),
                      TextField(
                        textAlign: TextAlign.center,
                        autofocus: true,
                        controller: AddPartnerController.to.phoneTextEditingController,
                        style: context.textTheme.titleLarge,
                        onChanged: AddPartnerController.to.onChangePhone,
                        maxLength: 11,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                  BackActivationWidget(),
                  PositionAnimations.bottom(
                    animationController: AddPartnerController.to.buttonAnimationController,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 16
                        ),
                        child: SizedBox(
                          width: Decorations.widthButtonActivation,
                          child: ElevationStateButton(
                            state: AddPartnerController.to,
                            onPressed: AddPartnerController.to.onNextStepPressed,
                            text:'ادامه',
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
