import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/core/app/view/themes/styles/buttons/loading_button/elevation_loading_button.dart';
import 'package:impo/src/features/index/data/models/interaction_sheet_model.dart';
import 'package:social/core/app/view/themes/styles/decorations.dart';

class InteractionSheet extends StatelessWidget {
  final InteractionSheetModel model;
  final Function() onSubmit;
  final StateMixin state;
  final bool isDismissible;

  const InteractionSheet({
    super.key,
    required this.model,
    required this.onSubmit,
    required this.state,
    required this.isDismissible,
  });

  static Future showSheet({
    required InteractionSheetModel model,
    required Function() onSubmit,
    required StateMixin state,
    required bool isDismissible,
  }) =>
      Get.bottomSheet(
        InteractionSheet(
          model: model,
          onSubmit: onSubmit,
          state: state,
          isDismissible: isDismissible,
        ),
        isScrollControlled: true,
        ignoreSafeArea: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        isDismissible: isDismissible,
        enableDrag: isDismissible,
      );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: isDismissible,
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
              SvgPicture.network(
                model.object,
                height: context.height * 0.25,
              ),
              SizedBox(height: 16),
              Text(
                model.title,
                style: context.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              SizedBox(
                height: context.height * 0.3,
                child: Text(
                  model.description,
                  style: context.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              ElevationStateButton(
                state: state,
                wide: true,
                onPressed: onSubmit,
                text: model.button.text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
