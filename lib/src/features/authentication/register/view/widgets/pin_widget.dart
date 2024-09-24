import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

enum PinState { error, success, normal }

class PinWidget extends StatelessWidget {
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final PinState state;
  final TextEditingController? controller;
  final int length;
  final bool obscureText;
  final bool readOnly;
  final double size;
  final double? fieldWidth;
  final double? fieldHeight;
  final PinCodeFieldShape pinCodeFieldShape;
  final Color? activeColor;
  final Color? fillColor;
  final Color? inactiveColor;
  final double? borderRadius;
  final TextStyle? textStyle;
  final FocusNode? focusNode;

  const PinWidget({
    Key? key,
    this.onCompleted,
    this.onChanged,
    this.state = PinState.normal,
    this.controller,
    this.length = 5,
    this.obscureText = false,
    this.readOnly = false,
    this.size = 50,
    this.pinCodeFieldShape = PinCodeFieldShape.box,
    this.activeColor,
    this.fillColor,
    this.borderRadius,
    this.fieldWidth,
    this.fieldHeight,
    this.inactiveColor,
    this.textStyle,
    this.focusNode,
  }) : super(key: key);

  Color boarderColor(PinState state) {
    switch (state) {
      case PinState.normal:
        return activeColor ?? Get.theme.colorScheme.onInverseSurface;
      case PinState.error:
        return activeColor ?? Get.theme.colorScheme.error;
        // return Get.theme.colorScheme.error;
      case PinState.success:
        return const Color.fromRGBO(84, 215, 113, 1);
      default:
        return activeColor ?? Get.theme.colorScheme.onInverseSurface;
    }
  }

  Color innerColor(PinState state) {
    switch (state) {
      case PinState.normal:
        return fillColor ?? Get.theme.scaffoldBackgroundColor;
      case PinState.error:
        return Get.theme.colorScheme.error.withOpacity(0.1);
        //return Get.theme.colorScheme.error.withOpacity(0.1);
      case PinState.success:
        return const Color.fromRGBO(84, 215, 113, 1).withOpacity(0.1);
      default:
        return Get.theme.scaffoldBackgroundColor;
    }
  }

  Color textColor(PinState state) {
    switch (state) {
      case PinState.normal:
        return Get.theme.colorScheme.onBackground;
      case PinState.error:
        return Get.theme.colorScheme.error;
      case PinState.success:
        return Get.theme.colorScheme.onBackground;
      default:
        return Get.theme.colorScheme.onBackground;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: PinCodeTextField(
        readOnly: readOnly,
        autoFocus: true,
        focusNode: focusNode,
        obscuringCharacter: '*',
        enablePinAutofill: true,
        controller: controller,
        keyboardType: TextInputType.number,
        textStyle: textStyle ?? context.textTheme.titleMedium!.copyWith(
          color: textColor(state)
        ),
        showCursor: false,
        length: length,
        obscureText: obscureText,
        obscuringWidget: obscureText
            ? Text(
          '*',
          style: context.textTheme.titleLarge?.copyWith(color: context.colorScheme.outlineVariant),
        )
            : null,
        autoDisposeControllers: false,
        blinkWhenObscuring: true,
        animationType: AnimationType.fade,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        pinTheme: PinTheme(
          activeColor: boarderColor(state),
          disabledColor: inactiveColor ?? Get.theme.colorScheme.surface,
          inactiveColor: inactiveColor ?? Get.theme.colorScheme.surface,
          selectedColor: boarderColor(state),
          borderWidth: 10.0,
          selectedBorderWidth: 1,
          errorBorderWidth: 1,
          activeBorderWidth: 1,
          inactiveBorderWidth: 1,
          shape: pinCodeFieldShape,
          borderRadius: BorderRadius.circular(borderRadius ?? 16),
          fieldHeight: fieldHeight ?? size,
          fieldWidth: fieldWidth ?? size,
          inactiveFillColor: innerColor(state),
          selectedFillColor: innerColor(state),
          activeFillColor: innerColor(state),
        ),
        animationDuration: const Duration(milliseconds: 300),
        onCompleted: onCompleted,
        onChanged: onChanged ?? (_) {},
        enableActiveFill: true,
        appContext: context,
      ),
    );
  }
}
