
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/constans/app_routes.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/core/app/utiles/helper/custom_decoder_lottie.dart';
import 'package:impo/src/core/app/utiles/helper/text_helper.dart';
import 'package:impo/src/core/app/view/themes/styles/buttons/impo_buttons.dart';
import 'package:impo/src/core/app/view/widgets/design_size_figma.dart';
import 'package:impo/src/features/activation/controller/reward_controller.dart';
import 'package:impo/src/features/activation/view/widgets/back_activation_widget.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/app/view/themes/styles/buttons/button_styles_properties.dart';

class RewardPage extends StatelessWidget {
  const RewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DesignSizeFigma(
      builder: (BuildContext context){
        return Scaffold(
          body: GetBuilder<RewardController>(
            builder: (controller) {
              return Obx(
                  ()=> Stack(
                    children: [
                      Column(
                        children: [
                          Flexible(
                            flex: 2,
                            child: Container(
                              width: Get.width,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [for(var color in controller.reward.value.gradient) Color(int.parse(color))],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter
                                  )
                              ),
                              child:   controller.reward.value.image != '' ?
                              controller.reward.value.image.contains('.lottie') ?
                              Lottie.network(
                                controller.reward.value.image,
                                repeat: controller.reward.value.doRepeat,
                                decoder: customDecoder,
                              ) :
                              Image.network(
                                controller.reward.value.image,
                                width: Get.width,
                                fit: BoxFit.cover,
                              ) : SizedBox.shrink(),
                            ),
                          ),
                          SizedBox(height: 25),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        controller.reward.value.title,
                                        textAlign: TextAlign.center,
                                        style: context.textTheme.headlineSmall,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        controller.reward.value.description,
                                        textAlign: TextAlign.center,
                                        style: context.textTheme.bodySmall,
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 32),
                                  child: Column(
                                    children: [
                                      controller.reward.value.btnLabel2 != '' ?
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 9
                                        ),
                                        child: TextButton(
                                            onPressed: (){
                                              Get.offAllNamed(AppRoutes.subscription);
                                            },
                                            child: Text(
                                              controller.reward.value.btnLabel2,
                                              style: context.textTheme.labelLarge,
                                            )
                                        ),
                                      )
                                          : SizedBox.shrink(),
                                      ConstrainedBox(
                                        // width: textSize(controller.reward.value.btnLabel,buttonTextStyle(context, ButtonSizes.large)!).width <= 204 ? 204 :
                                        // textSize(controller.reward.value.btnLabel,buttonTextStyle(context, ButtonSizes.large)!).width,
                                        constraints: BoxConstraints(
                                          minWidth: 204
                                        ),
                                        child: ElevatedButton(
                                            style: context.buttonThemes.elevatedButtonStyle(size: ButtonSizes.large),
                                            onPressed: controller.nextSubmit,
                                            child: SizedBox(
                                              child: Text(controller.reward.value.btnLabel,textAlign: TextAlign.center),
                                            )
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      BackActivationWidget()
                    ],
                  )
                  //     Stack(
                  //   children: [
                  //     SizedBox.expand(
                  //       child: Container(
                  //         decoration: BoxDecoration(
                  //             gradient: LinearGradient(
                  //               colors: [for(var color in controller.reward.value.gradian) Color(int.parse(color))],
                  //               begin: Alignment.topCenter,
                  //               end: Alignment.bottomCenter
                  //             )
                  //         ),
                  //       ),
                  //     ),
                  //     Center(
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           controller.reward.value.image != '' ?
                  //           Flexible(
                  //             child: controller.reward.value.image.contains('.lottie') ?
                  //             Lottie.network(
                  //               controller.reward.value.image,
                  //               repeat: controller.reward.value.doRepeat,
                  //               decoder: customDecoder,
                  //             ) :
                  //             Image.network(
                  //               controller.reward.value.image,
                  //               width: Get.width,
                  //               fit: BoxFit.cover,
                  //             ),
                  //           ) : SizedBox.shrink(),
                  //           Padding(
                  //             padding: const EdgeInsets.symmetric(
                  //               horizontal: 27
                  //             ),
                  //             child: Column(
                  //               children: [
                  //                 Text(
                  //                   controller.reward.value.title,
                  //                   textAlign: TextAlign.center,
                  //                   style: context.textTheme.headlineSmall,
                  //                 ),
                  //                 SizedBox(height: 4),
                  //                 Text(
                  //                   controller.reward.value.description,
                  //                   textAlign: TextAlign.center,
                  //                   style: context.textTheme.bodySmall,
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //           Padding(
                  //             padding: const EdgeInsets.only(bottom: 32),
                  //             child: Column(
                  //               children: [
                  //                 controller.reward.value.btnLabel2 != '' ?
                  //                     Padding(
                  //                       padding: const EdgeInsets.only(
                  //                         bottom: 9
                  //                       ),
                  //                       child: TextButton(
                  //                           onPressed: (){},
                  //                           child: Text(
                  //                             controller.reward.value.btnLabel2,
                  //                             style: context.textTheme.labelLarge,
                  //                           )
                  //                       ),
                  //                     )
                  //                  : SizedBox.shrink(),
                  //                 ElevatedButton(
                  //                     style: context.buttonThemes.elevatedButtonStyle(size: ButtonSizes.large),
                  //                     onPressed: controller.nextSubmit,
                  //                     child: SizedBox(
                  //                       width: textSize(controller.reward.value.btnLabel,buttonTextStyle(context, ButtonSizes.large)!).width <= 150 ? 150 :
                  //                       textSize(controller.reward.value.btnLabel,buttonTextStyle(context, ButtonSizes.large)!).width,
                  //                       child: Text(controller.reward.value.btnLabel,textAlign: TextAlign.center),
                  //                     )
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     BackActivationWidget()
                  //   ],
                  // )
              );
            }
          ),
        );
      },
    );
  }
}
