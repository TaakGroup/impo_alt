import 'package:flutter/material.dart';
import 'button_styles_properties.dart';
import 'button_types.dart';

class IconButtonStyle {
  final BuildContext context;

  IconButtonStyle.of(this.context);

  ButtonStyle? elevatedStyle({ButtonColors color = ButtonColors.primary}) {
    return ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) => elevatedBackgroundColor(context, color, states)),
          foregroundColor: MaterialStateProperty.resolveWith((states) => elevatedForegroundColor(context, color, states)),
        );
  }

  ButtonStyle? outlineStyle({ButtonColors color = ButtonColors.primary}) {
    return ButtonStyle(
      foregroundColor: MaterialStateProperty.resolveWith((states) => outlineForegroundColor(context, color, states)),
      overlayColor: MaterialStateProperty.resolveWith((states) => overlayColor(context, color, states)),
      side: MaterialStateProperty.resolveWith((states) => BorderSide(color: buttonBorderSideColor(context, color, states))),
    );
  }

  ButtonStyle? iconStyle({ButtonColors color = ButtonColors.primary}) {
    return ButtonStyle(
        // TODO
        );
  }
}
