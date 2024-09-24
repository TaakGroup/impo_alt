import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/constans/assets_paths.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/core/app/view/themes/styles/buttons/button_types.dart';
import 'package:impo/src/core/app/view/themes/styles/buttons/icon_button__style.dart';
import 'package:impo/src/core/app/view/themes/styles/buttons/loading_button/elevation_loading_button.dart';
import 'package:impo/src/core/app/view/themes/styles/decorations.dart';
import 'package:impo/src/core/app/view/widgets/design_size_figma.dart';
import 'package:impo/src/core/app/view/widgets/loading/loading_indicator_widget.dart';
import 'package:impo/src/features/subscription/view/widgets/discount_widget.dart';
import 'package:impo/src/features/subscription/view/widgets/item_sub_widget.dart';

import '../../controller/subscription_controller.dart';


class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DesignSizeFigma(
      builder: (context) {
        return Scaffold(
          bottomNavigationBar: Padding(
            padding: Decorations.pagePaddingHorizontal.copyWith(
              bottom: 45
            ),
            child: Obx(
                ()=> ElevatedButton(
                  onPressed: SubscriptionController.to.onPayment,
                  style: context.buttonThemes.elevatedButtonStyle(),
                  child: !SubscriptionController.to.paymentLoading.value ?
                  Text('ورود به صفحه پرداخت') : LoadingIndicatorWidget(),
                )
            ),
          ),
          body: SubscriptionController.to.obx(
              (subscription) => SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          Image.asset(
                            AssetPaths.subBanner,
                            width: Get.width,
                            fit: BoxFit.cover,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: (){},
                                icon: Icon(Icons.arrow_back_rounded),
                                style: IconButtonStyle.of(context).outlineStyle(
                                  color: ButtonColors.surface,
                                ),
                              ),
                              IconButton(
                                onPressed: (){},
                                icon: Icon(Icons.arrow_back_rounded),
                                style: IconButtonStyle.of(context).outlineStyle(
                                  color: ButtonColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: Decorations.pagePaddingHorizontal,
                        child: Column(
                          children: [
                            Text(
                              "ایمپو چجوری کار میکنه؟",
                              style: context.textTheme.titleLarge,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "اینجا بهت میگیم 7 روز استفاده از ایمپو رایگانه و بعدش باید یه مبلغی بپردازی عزیزم",
                              style: context.textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      Obx(() => Column(
                        children: [
                          Padding(
                            padding:Decorations.pagePaddingHorizontal,
                            child: ListView.builder(
                              itemCount: SubscriptionController.to.packages.length,
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context,index){
                                return Obx(
                                    () => ItemSubWidget(
                                      package: SubscriptionController.to.packages[index],
                                      onTap: SubscriptionController.to.onPackageSelect,
                                      isSelected: SubscriptionController.to.subsId.value == SubscriptionController.to.packages[index].id,
                                    )
                                );
                              },
                            ),
                          ),
                          subscription!.packages.length <= 2 || SubscriptionController.to.packages.length > 2 ?
                          SizedBox.shrink() :
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Flexible(child: Divider(color: context.colorScheme.surface)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 9),
                                  child: TextButton(
                                      onPressed: SubscriptionController.to.moreLoad,
                                      child: Text(
                                        'مشاهده بیشتر پلن ها',
                                        style: context.textTheme.labelMedium,
                                      )
                                  ),
                                ),
                                Flexible(child: Divider(color: context.colorScheme.surface)),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),
                          DiscountWidget(subscription: subscription),
                          SizedBox(height: 24),
                        ],
                       ),
                      ),
                    ],
                  ),
                ),
              ),
            onLoading: Center(child: LoadingIndicatorWidget(color: context.colorScheme.primary,))
          ),

        );
      }
    );
  }
}
