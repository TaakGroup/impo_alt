import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CircleCheckRadioWidget extends StatelessWidget {
  final bool isSelected;
  final void Function()? onTap;
  final double size;

  const CircleCheckRadioWidget({Key? key, required this.isSelected, this.onTap, this.size = 22}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(1.75),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? context.theme.colorScheme.primary : context.theme.colorScheme.outline,
          ),
        ),
        child: isSelected
            ? Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.theme.colorScheme.primary,
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
