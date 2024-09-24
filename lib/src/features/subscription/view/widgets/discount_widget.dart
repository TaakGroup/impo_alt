import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/constans/assets_paths.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/core/app/view/widgets/input/input.dart';
import 'package:impo/src/features/subscription/controller/subscription_controller.dart';
import 'package:impo/src/features/subscription/data/models/subscription_model.dart';

class DiscountWidget extends StatelessWidget {
  late SubscriptionModel subscription;
   DiscountWidget({super.key,required this.subscription});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Theme(
        data: context.theme.copyWith(splashColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: SubscriptionController.to.onExpansionChanged,
          title: Row(
            children: [
              SvgPicture.asset(AssetPaths.percent, color: context.colorScheme.outline),
              const SizedBox(width: 4),
              Text(
                'کد تخفیف خود را اینجا وارد کنید',
                style: context.textTheme.bodyMedium,
              ),
            ],
          ),
          trailing: Obx(
            () => AnimatedRotation(
              turns: SubscriptionController.to.isDiscountExpand.value ? 1.125 : 1,
              duration: const Duration(milliseconds: 300),
              child: SvgPicture.asset(
                AssetPaths.plus,
                color: SubscriptionController.to.isDiscountExpand.value
                    ? context.colorScheme.error
                    : context.colorScheme.outline,
              ),
            ),
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          backgroundColor: context.colorScheme.surfaceVariant,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          collapsedBackgroundColor: context.colorScheme.surfaceVariant,
          clipBehavior: Clip.hardEdge,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Input(
                    hintText: 'کد تخفیف رو وارد کن',
                    controller: SubscriptionController.to.codeController,
                  ),
                ),
                const SizedBox(width: 4),
                ElevatedButton(
                  style: context.buttonThemes.elevatedButtonStyle(),
                  onPressed: SubscriptionController.to.applyCode,
                  child: const Text('اعمال'),
                )
              ],
            ),
            if (subscription.discountCodeHelper.isNotEmpty) const SizedBox(height: 8),
            if (subscription.discountCodeHelper.isNotEmpty)
              Text(
                subscription.discountCodeHelper,
                style: context.textTheme.bodySmall?.copyWith(
                  color: subscription.isValidDiscountCode ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
