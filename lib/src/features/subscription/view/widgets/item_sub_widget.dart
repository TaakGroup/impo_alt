import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:impo/src/core/app/constans/assets_paths.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/features/subscription/data/models/subscription_model.dart';
import 'package:impo/src/features/subscription/view/widgets/theme_item_sub_widget.dart';

class ItemSubWidget extends StatelessWidget {
  final bool isSelected;
  final SubscriptionPackagesModel package;
  final void Function(String id)? onTap;

  const ItemSubWidget({super.key, required this.package, required this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return ThemeItemSubWidget(
          package: package,
          cardBorderColor: context.colorScheme.primary,
          cardBackgroundColor: Color(0xffFFF0F5),
          backgroundColorSpecif: context.colorScheme.primary,
          textColorSpecif: Colors.white,
          circleColor: context.colorScheme.primary,
          textColor: context.colorScheme.onBackground,
          valueColor: context.colorScheme.onBackground,
          realValueColor: context.colorScheme.onInverseSurface,
          unitColor: context.colorScheme.onBackground,
          dividerColor: Color(0xffFFB7CF),
          descriptionColor: context.colorScheme.onBackground,
          contentCircle: SvgPicture.asset(AssetPaths.ticSelected),
          onTap: onTap,
      );
    } else {
      return ThemeItemSubWidget(
          package: package,
          cardBorderColor: context.colorScheme.outlineVariant,
          cardBackgroundColor: context.colorScheme.background,
          backgroundColorSpecif: context.colorScheme.outlineVariant,
          textColorSpecif: context.colorScheme.outline,
          circleColor: context.colorScheme.outlineVariant,
          textColor: context.colorScheme.outline,
          valueColor: context.colorScheme.outline,
          realValueColor: context.colorScheme.outlineVariant,
          unitColor: context.colorScheme.outline,
          dividerColor: context.colorScheme.surface,
          descriptionColor: context.colorScheme.outlineVariant,
          contentCircle: SizedBox.shrink(),
          onTap: onTap,
      );
    }
  }
}
