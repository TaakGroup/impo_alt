import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import '../../../../widgets/loading_indicator_widget.dart';
import '../../../../../utils/helper/text_helper.dart';
import '../button_styles_properties.dart';
import '../button_types.dart';

class ElevationStateButton extends StatelessWidget {
  final StateMixin state;
  final ButtonColors color;
  final ButtonSizes size;
  final bool wide;
  final String text;
  final void Function()? onPressed;

  const ElevationStateButton({
    super.key,
    required this.state,
    this.onPressed,
    required this.text,
    this.color = ButtonColors.primary,
    this.size = ButtonSizes.medium,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    return state.obx(
      (state) => ElevatedButton(
        onPressed: onPressed,
        style: context.buttonThemes.elevatedButtonStyle(color: color, size: size, wide: wide),
        child: Text(text),
      ),
      onLoading: ElevatedButton(
        onPressed: () {},
        style: context.buttonThemes.elevatedButtonStyle(color: color, size: size, wide: wide),
        child: SizedBox(
          width: textSize(text, buttonTextStyle(context, size)!).width,
          child: const Column(mainAxisSize: MainAxisSize.min ,children: [LoadingIndicatorWidget()]),
        ),
      ),
      onEmpty: ElevatedButton(
        onPressed: null,
        style: context.buttonThemes.elevatedButtonStyle(color: color, size: size, wide: wide),
        child: SizedBox(
          width: textSize(text, Theme.of(context).textTheme.titleMedium!).width,
          child: Text(text),
        ),
      ),
    );
  }
}
