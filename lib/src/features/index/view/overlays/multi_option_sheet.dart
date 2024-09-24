import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/components/circle_check_radio_widget.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/core/app/view/themes/styles/buttons/loading_button/elevation_loading_button.dart';
import 'package:social/core/app/view/themes/styles/decorations.dart';
import '../../data/models/multi_option_sheet_model.dart';

class MultiOptionSheet extends StatelessWidget {
  final MultiOptionSheetModel model;
  final Rx<OptionItemModel> selectedItem;
  final Function(OptionItemModel) onItemSelected;
  final Function() onSubmit;
  final StateMixin state;

  const MultiOptionSheet({
    super.key,
    required this.model,
    required this.selectedItem,
    required this.onItemSelected,
    required this.onSubmit,
    required this.state,
  });

  static Future showSheet({
    required MultiOptionSheetModel model,
    required Rx<OptionItemModel> selectedItem,
    required Function(OptionItemModel) onItemSelected,
    required Function() onSubmit,
    required StateMixin state,
  }) =>
      Get.bottomSheet(
        MultiOptionSheet(
          model: model,
          selectedItem: selectedItem,
          onItemSelected: onItemSelected,
          onSubmit: onSubmit,
          state: state,
        ),
        isScrollControlled: true,
        ignoreSafeArea: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        enableDrag: false,
      );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: Decorations.pagePaddingHorizontal.copyWith(bottom: 32, top: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(
                color: context.colorScheme.surface,
                indent: context.width * 0.35,
                endIndent: context.width * 0.35,
                height: 4,
              ),
              SizedBox(height: 28),
              Text(
                model.title,
                style: context.textTheme.labelLarge,
              ),
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 24),
                shrinkWrap: true,
                itemCount: model.items.length,
                separatorBuilder: (_, index) => SizedBox(height: 16),
                itemBuilder: (_, index) {
                  var item = model.items[index];
                  return Obx(
                    () => OptionItemWidget(
                      model: item,
                      isSelected: item == selectedItem.value,
                      onTap: onItemSelected,
                    ),
                  );
                },
              ),
              ElevationStateButton(
                state: state,
                wide: true,
                onPressed: onSubmit,
                text: model.submit.text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionItemWidget extends StatelessWidget {
  final bool isSelected;
  final OptionItemModel model;
  final Function(OptionItemModel) onTap;

  const OptionItemWidget({
    super.key,
    required this.isSelected,
    required this.model,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap.call(model),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xffFFEBF2) : context.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            CircleCheckRadioWidget(isSelected: isSelected),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                model.title,
                style: context.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
