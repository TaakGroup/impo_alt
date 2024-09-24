import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import '../../../../core/app/view/themes/styles/buttons/button_types.dart';
import '../../../../core/app/view/themes/styles/decorations.dart';
import '../../../subscription/view/widgets/item_sub_widget.dart';
import '../../data/models/action_model.dart';
import '../../data/models/subscription_widget_model.dart';

class SubscriptionWidget extends StatelessWidget {
  final SubscriptionWidgetModel model;
  final Function(ActionModel)? onActionPressed, onSubmitPressed;

  const SubscriptionWidget({super.key, required this.model, this.onActionPressed, this.onSubmitPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: Decorations.pagePaddingHorizontal,
      padding: EdgeInsets.all(16.0),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  model.title,
                  style: context.textTheme.labelLarge,
                ),
              ),
              if (model.headlineButton != null)
                ElevatedButton(
                  style: context.buttonThemes.elevatedButtonStyle(size: ButtonSizes.small)?.copyWith(
                        // backgroundColor: WidgetStateProperty.all(model.headlineButton!.backgroundColor),
                        // foregroundColor: WidgetStateProperty.all(model.headlineButton!.foregroundColor),
                        elevation: WidgetStateProperty.all(0),
                      ),
                  onPressed: () => onActionPressed?.call(model.submitButton.action),
                  child: Text(model.headlineButton!.text),
                )
              else
                SizedBox(),
            ],
          ),
          Divider(
            height: 45,
            color: context.colorScheme.surface,
          ),
          ItemSubWidget(
            package: model.package,
            isSelected: true,
          ),
          SizedBox(height: 18),
          ElevatedButton(
            onPressed: () => onSubmitPressed?.call(model.submitButton.action),
            style: context.buttonThemes.elevatedButtonStyle(wide: true)?.copyWith(
                  // backgroundColor: WidgetStateProperty.all(model.submitButton.backgroundColor),
                  // foregroundColor: WidgetStateProperty.all(model.submitButton.foregroundColor),
                  elevation: WidgetStateProperty.all(0),
                ),
            child: Text(model.submitButton.text),
          ),
        ],
      ),
    );
  }
}
