import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/core/app/view/themes/styles/decorations.dart';
import 'package:impo/src/features/index/view/widgets/updating_cycle_wave_animation.dart';
import '../../controller/cycle_controller.dart';
import '../../data/models/action_model.dart';
import '../widgets/animated_scale.dart';
import '../widgets/cycle_wave.dart';

class ArcClipper extends CustomClipper<Path> {
  final double arcHeight;

  ArcClipper({required this.arcHeight});

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 24);
    path.quadraticBezierTo(size.width / 2, size.height + 24, size.width, size.height - 24);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class CycleWidget extends StatelessWidget {
  final String headline;
  final Function(ActionModel) onActionPressed;

  const CycleWidget({super.key, required this.headline, required this.onActionPressed});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CycleController>(
      builder: (controller) => ClipPath(
        clipper: ArcClipper(arcHeight: 470),
        child: Container(
          height: 500,
          color: controller.cycle.backgroundColor,
          child: Stack(
            children: [
              Obx(
                () => AnimatedCrossFade(
                  duration: Duration(milliseconds: 1000),
                  crossFadeState: controller.crossFade.value,
                  firstChild: SlideTransition(
                    position: controller.waveAnimationPosition,
                    child: CycleWaveWidget(color: controller.cycle.foregroundColor),
                  ),
                  secondChild: SizedBox(
                    height: 500,
                    child: UpdatingCycleWaveAnimation(
                      color: controller.cycle.foregroundColor,
                      controller: controller.lottieWaveAnimation,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: Decorations.pagePaddingHorizontal,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: context.mediaQuery.padding.top + 16),
                    ScaleAnimation(
                      animation: controller.successTextAnimation,
                      child: Text(
                        headline,
                        style: context.textTheme.labelMedium?.copyWith(color: controller.cycle.textColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 16),
                    ScaleAnimation(
                      animation: controller.successTextAnimation,
                      child: Text(
                        controller.cycle.leading,
                        style: context.textTheme.titleSmall?.copyWith(color: controller.cycle.textColor, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 8),
                    ScaleAnimation(
                      animation: controller.successTextAnimation,
                      child: Container(
                        height: 116,
                        alignment: Alignment.center,
                        child: Text(
                          controller.cycle.title,
                          style: context.textTheme.headlineLarge?.copyWith(color: controller.cycle.textColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    ScaleAnimation(
                      animation: controller.successTextAnimation,
                      child: Text(
                        controller.cycle.description,
                        style: context.textTheme.labelLarge?.copyWith(color: controller.cycle.textColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 72),
                    ScaleAnimation(
                      animation: controller.successTextAnimation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (var button in controller.cycle.buttons)
                            ElevatedButton(
                              style: context.buttonThemes.elevatedButtonStyle()?.copyWith(
                                    backgroundColor: WidgetStateProperty.all(button.backgroundColor),
                                    foregroundColor: WidgetStateProperty.all(button.foregroundColor),
                                    elevation: WidgetStateProperty.all(0),
                                  ),
                              child: Text(button.text),
                              onPressed: () => onActionPressed(button.action),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
              Center(
                child: ScaleAnimation(
                  animation: controller.updatingTextAnimation,
                  child: ScaleAnimation(
                    animation: controller.pulseAnimation,
                    child: Obx(
                      () => Text(
                        controller.loadingText.value,
                        style: context.textTheme.titleMedium,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
