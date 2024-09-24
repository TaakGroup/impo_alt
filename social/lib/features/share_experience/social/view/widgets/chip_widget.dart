import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';

class ChipWidget extends StatelessWidget {
  final bool isSelected;
  final String title;
  final String? icon;
  final void Function()? onTap;

  const ChipWidget({
    Key? key,
    required this.isSelected,
    required this.title,
    this.onTap,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8).copyWith(right: icon != null ? 8 : 16),
        decoration: ShapeDecoration(
          color: isSelected ? context.colorScheme.primary : context.colorScheme.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: isSelected ? context.colorScheme.primary : context.colorScheme.surface,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null)
              SvgPicture.asset(
                icon!,
                colorFilter: ColorFilter.mode(
                  isSelected ? context.colorScheme.onPrimaryContainer : context.colorScheme.onBackground,
                  BlendMode.srcIn,
                ),
              ),
            if (icon != null) const SizedBox(width: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.textTheme.labelLarge?.copyWith(
                color: isSelected ? context.colorScheme.background : context.colorScheme.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}