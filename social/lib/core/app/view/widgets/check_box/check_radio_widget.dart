import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/constants/assets_paths.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';

class CheckRadioWidget extends StatelessWidget {
  final bool isSelected;
  final Size? iconSize;
  final void Function()? onTap;

  const CheckRadioWidget({Key? key, required this.isSelected, this.onTap, this.iconSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: iconSize != null ? iconSize!.height : 16,
        width: iconSize != null ? iconSize!.width : 16,
        padding: const EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: context.colorScheme.surface),
        ),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? context.colorScheme.primary : context.colorScheme.background,
          ),
        ),
      ),
    );
  }
}
