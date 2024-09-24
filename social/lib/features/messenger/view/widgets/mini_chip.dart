import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';

class MiniChip extends StatelessWidget {
  final String text;
  final Widget icon;

  const MiniChip({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 1.50,
        left: 8,
        right: 4,
        bottom: 1.50,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: context.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 4),
          Text(
            text,
            style: context.textTheme.labelLarge?.copyWith(color: context.colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
