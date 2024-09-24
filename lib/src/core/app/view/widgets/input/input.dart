import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'input_size.dart';
export 'input_size.dart';

class Input extends StatelessWidget {
  final void Function()? onTap;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? label;
  final String? helperText;
  final String? hintText;
  final String? counterText;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool? autofocus;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final TextDirection? hintTextDirection;
  final bool enabled;
  final TextAlign textAlign;
  final bool showError;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final Color? hintColor;
  final bool obscureText;
  final bool filled;
  final TextStyle? counterStyle;
  RxBool isError = false.obs;
  InputSize? inputSize;

  checkError(value) {
    final errorText = validator!(value);
    isError.value = errorText != null;
    return errorText;
  }

  Input({
    Key? key,
    this.suffixIcon,
    this.prefixIcon,
    this.inputSize,
    this.label,
    this.helperText,
    this.controller,
    this.validator,
    this.textInputAction,
    this.keyboardType,
    this.hintText,
    this.autofocus,
    this.maxLength,
    this.minLines,
    this.maxLines,
    this.hintTextDirection,
    this.enabled = true,
    this.onTap,
    this.textAlign = TextAlign.start,
    this.showError = true,
    this.onChanged,
    this.focusNode,
    this.hintColor,
    this.obscureText = false,
    this.filled = false,
    this.counterText,
    this.counterStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    inputSize ??= InputSize.medium(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Padding(
              padding: inputSize!.labelPadding,
              child: Obx(
                () => Text(
                  label!,
                  style: inputSize!.labelStyle.copyWith(
                    color: isError.value
                        ? Theme.of(context).colorScheme.error
                        : context.isDarkMode
                            ? Theme.of(context).colorScheme.outline
                            : Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
            ),
          TextFormField(
            obscureText: obscureText,
            enableSuggestions: !obscureText,
            autocorrect: !obscureText,
            focusNode: focusNode,
            onChanged: onChanged,
            textAlign: textAlign,
            readOnly: !enabled,
            enabled: enabled,
            minLines: minLines,
            maxLines: maxLines,
            controller: controller,
            textInputAction: textInputAction,
            keyboardType: keyboardType,
            validator: (value) => checkError(value),
            style: inputSize!.textStyle,
            autofocus: autofocus ?? false,
            maxLength: maxLength,
            decoration: InputDecoration(
              filled: filled,
              hintTextDirection: hintTextDirection,
              errorStyle:
                  showError ? context.textTheme.labelSmall!.copyWith(color: context.colorScheme.error) : const TextStyle(fontSize: 0.0001),
              counterText: counterText ?? '',
              counterStyle: counterStyle,
              isDense: true,
              helperText: helperText,
              hintText: hintText,
              hintStyle: inputSize!.hintStyle.copyWith(color: hintColor ?? context.colorScheme.outline),
              contentPadding: inputSize!.padding,
              prefixIconConstraints: const BoxConstraints(minHeight: 24, minWidth: 24),
              suffixIconConstraints: const BoxConstraints(minHeight: 24, minWidth: 24),
              prefixIconColor: context.isDarkMode ? Theme.of(context).colorScheme.outline : Theme.of(context).colorScheme.onBackground,
              suffixIconColor: Theme.of(context).colorScheme.error,
              suffixIcon: suffixIcon != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: inputSize!.padding.right),
                      child: suffixIcon,
                    )
                  : null,
              prefixIcon: prefixIcon != null
                  ? Padding(
                      padding: EdgeInsets.only(right: inputSize!.padding.right, left: 8),
                      child: prefixIcon,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
