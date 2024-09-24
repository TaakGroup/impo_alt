import 'package:flutter/material.dart';

class InputSize {
  final BuildContext context;
  final EdgeInsets padding;
  final TextStyle labelStyle;
  final TextStyle hintStyle;
  final TextStyle textStyle;
  final EdgeInsets labelPadding;

  InputSize(this.context, this.padding, this.labelStyle, this.hintStyle, this.textStyle, this.labelPadding);

  InputSize.large(this.context)
      : padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        labelStyle = Theme.of(context).textTheme.bodyMedium!,
        hintStyle = Theme.of(context).textTheme.bodyLarge!,
        textStyle = Theme.of(context).textTheme.bodyLarge!,
        labelPadding = const EdgeInsets.only(bottom: 5, right: 16);

  InputSize.medium(this.context)
      : padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        labelStyle = Theme.of(context).textTheme.bodySmall!,
        hintStyle = Theme.of(context).textTheme.bodyLarge!,
        textStyle = Theme.of(context).textTheme.bodyLarge!,
        labelPadding = const EdgeInsets.only(bottom: 3, right: 16);

  InputSize.small(this.context)
      : padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        labelStyle = Theme.of(context).textTheme.labelSmall!,
        hintStyle = Theme.of(context).textTheme.bodyMedium!,
        textStyle = Theme.of(context).textTheme.bodyMedium!,
        labelPadding = const EdgeInsets.only(bottom: 2, right: 16);

  InputSize copyWith({
    EdgeInsets? padding,
    TextStyle? labelStyle,
    TextStyle? hintStyle,
    TextStyle? textStyle,
    EdgeInsets? labelPadding,
  }) {
    return InputSize(
      context,
      padding ?? this.padding,
      labelStyle ?? this.labelStyle,
      hintStyle ?? this.hintStyle,
      textStyle ?? this.textStyle,
      labelPadding ?? this.labelPadding,
    );
  }
}