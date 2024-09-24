import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import '../../colors/primary_palette.dart';
import '../../colors/neutral_palette.dart';
import 'button_types.dart';

Size wideSize(ButtonSizes buttonSizes) {
  switch (buttonSizes) {
    case ButtonSizes.small:
      return const Size.fromHeight(32);
    case ButtonSizes.medium:
      return const Size.fromHeight(40);
    case ButtonSizes.large:
      return const Size.fromHeight(48);
  }
}

EdgeInsets buttonPadding(ButtonSizes buttonSize, {bool icon = false, required bool isLtr}) {
  switch (buttonSize) {
    case ButtonSizes.small:
      if (icon) {
        if (isLtr) {
          return const EdgeInsets.fromLTRB(12, 7, 16, 7);
        } else {
          return const EdgeInsets.fromLTRB(16, 7, 12, 7);
        }
      } else {
        return const EdgeInsets.symmetric(vertical: 7, horizontal: 12);
      }
    case ButtonSizes.medium:
      if (icon) {
        if (isLtr) {
          return const EdgeInsets.fromLTRB(16, 7, 24, 7);
        } else {
          return const EdgeInsets.fromLTRB(24, 8, 16, 8);
        }
      } else {
        return const EdgeInsets.symmetric(vertical: 10, horizontal: 24);
      }
    case ButtonSizes.large:
      if (icon) {
        if (isLtr) {
          return const EdgeInsets.fromLTRB(24, 7, 28, 7);
        } else {
          return const EdgeInsets.fromLTRB(28, 10, 24, 10);
        }
      } else {
        return const EdgeInsets.symmetric(vertical: 11, horizontal: 28);
      }
  }
}

double buttonIconGap(ButtonSizes buttonSize) {
  switch (buttonSize) {
    case ButtonSizes.small:
      return 4;
    case ButtonSizes.medium:
      return 4;
    case ButtonSizes.large:
      return 6;
  }
}

double buttonIconSize(ButtonSizes buttonSize) {
  switch (buttonSize) {
    case ButtonSizes.small:
      return 16;
    case ButtonSizes.medium:
      return 18;
    case ButtonSizes.large:
      return 24;
  }
}

TextStyle? buttonTextStyle(BuildContext context, ButtonSizes buttonSize) {
  switch (buttonSize) {
    case ButtonSizes.small:
      return Theme.of(context).textTheme.labelLarge;
    case ButtonSizes.medium:
      return Theme.of(context).textTheme.bodyLarge;
    case ButtonSizes.large:
      return Theme.of(context).textTheme.headlineMedium;
  }
}

Color elevatedForegroundColor(BuildContext context, ButtonColors buttonColor, Set<MaterialState> states) {
  switch (buttonColor) {
    case ButtonColors.primary:
      if (states.contains(MaterialState.disabled)) {
        return Theme.of(context).colorScheme.outline;
      } else {
        return Theme.of(context).colorScheme.onPrimary;
      }
    case ButtonColors.base:
      if (states.contains(MaterialState.disabled)) {
        return Theme.of(context).colorScheme.onSurfaceVariant;
      } else {
        return Theme.of(context).colorScheme.background;
      }
    case ButtonColors.surface:
      if (states.contains(MaterialState.disabled)) {
        return Theme.of(context).colorScheme.outlineVariant;
      } else {
        return Theme.of(context).colorScheme.onSurface;
      }
  }
}

Color elevatedBackgroundColor(BuildContext context, ButtonColors buttonColor, Set<MaterialState> states) {
  switch (buttonColor) {
    case ButtonColors.primary:
      if (states.contains(MaterialState.disabled)) {
        return Theme.of(context).colorScheme.outlineVariant;
      } else {
        return Theme.of(context).colorScheme.primary;
      }
    case ButtonColors.base:
      if (states.contains(MaterialState.disabled)) {
        return Theme.of(context).colorScheme.surfaceVariant;
      } else {
        return Theme.of(context).colorScheme.onBackground;
      }
    case ButtonColors.surface:
      if (states.contains(MaterialState.disabled)) {
        return Theme.of(context).colorScheme.outlineVariant;
      } else {
        return Theme.of(context).colorScheme.surface;
      }
  }
}

Color? elevatedOverlayColor(BuildContext context, ButtonColors buttonColor, Set<MaterialState> states) {
  switch (buttonColor) {
    case ButtonColors.primary:
      if (states.contains(MaterialState.hovered)) {
        return context.isDarkMode ? context.colorScheme.primary : context.colorScheme.primary;
      } else if (states.contains(MaterialState.focused)) {
        return context.isDarkMode ? context.colorScheme.primary : context.colorScheme.primary;
      } else if (states.contains(MaterialState.pressed)) {
        return context.isDarkMode ? context.colorScheme.primary : context.colorScheme.primary;
      }
      break;
    case ButtonColors.base:
      if (states.contains(MaterialState.hovered)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral80! : NeutralPalette.of(context).neutral20!;
      } else if (states.contains(MaterialState.focused)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral60! : NeutralPalette.of(context).neutral30!;
      } else if (states.contains(MaterialState.pressed)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral50! : NeutralPalette.of(context).neutral40!;
      }
      break;
    case ButtonColors.surface:
      if (states.contains(MaterialState.hovered)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral30! : NeutralPalette.of(context).neutral90!;
      } else if (states.contains(MaterialState.focused)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral40! : NeutralPalette.of(context).neutral80!;
      } else if (states.contains(MaterialState.pressed)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral50! : NeutralPalette.of(context).neutral60!;
      }
      break;
  }
  return null;
}

Color buttonBorderSideColor(BuildContext context, ButtonColors buttonColor, Set<MaterialState> states) {
  switch (buttonColor) {
    case ButtonColors.primary:
      if (states.contains(MaterialState.hovered)) {
        return context.isDarkMode ? PrimaryPalette.of(context).primary60! : PrimaryPalette.of(context).primary50!;
      } else if (states.contains(MaterialState.focused)) {
        return context.isDarkMode ? PrimaryPalette.of(context).primary70! : PrimaryPalette.of(context).primary40!;
      } else if (states.contains(MaterialState.pressed)) {
        return context.isDarkMode ? PrimaryPalette.of(context).primary80! : PrimaryPalette.of(context).primary30!;
      } else if (states.contains(MaterialState.disabled)) {
        return Theme.of(context).colorScheme.outlineVariant;
      } else {
        return Theme.of(context).colorScheme.primary;
      }
    case ButtonColors.base:
      if (states.contains(MaterialState.hovered)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral80! : NeutralPalette.of(context).neutral20!;
      } else if (states.contains(MaterialState.focused)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral60! : NeutralPalette.of(context).neutral30!;
      } else if (states.contains(MaterialState.pressed)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral50! : NeutralPalette.of(context).neutral40!;
      } else if (states.contains(MaterialState.disabled)) {
        return Theme.of(context).colorScheme.outlineVariant;
      } else {
        return Theme.of(context).colorScheme.onBackground;
      }
    case ButtonColors.surface:
      if (states.contains(MaterialState.hovered)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral30! : NeutralPalette.of(context).neutral90!;
      } else if (states.contains(MaterialState.focused)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral40! : NeutralPalette.of(context).neutral80!;
      } else if (states.contains(MaterialState.pressed)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral50! : NeutralPalette.of(context).neutral60!;
      } else if (states.contains(MaterialState.disabled)) {
        return Theme.of(context).colorScheme.outlineVariant;
      } else {
        return Theme.of(context).colorScheme.surface;
      }
  }
}

Color outlineForegroundColor(BuildContext context, ButtonColors buttonColor, Set<MaterialState> states) {
  switch (buttonColor) {
    case ButtonColors.primary:
      if (states.contains(MaterialState.hovered)) {
        return context.isDarkMode ? PrimaryPalette.of(context).primary50! : PrimaryPalette.of(context).primary50!;
      } else if (states.contains(MaterialState.focused)) {
        return context.isDarkMode ? PrimaryPalette.of(context).primary40! : PrimaryPalette.of(context).primary40!;
      } else if (states.contains(MaterialState.pressed)) {
        return context.isDarkMode ? PrimaryPalette.of(context).primary30! : PrimaryPalette.of(context).primary30!;
      } else if (states.contains(MaterialState.disabled)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral95! : NeutralPalette.of(context).neutral95!;
      } else {
        return Theme.of(context).colorScheme.primary;
      }
    case ButtonColors.base:
      if (states.contains(MaterialState.hovered)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral95! : NeutralPalette.of(context).neutral20!;
      } else if (states.contains(MaterialState.focused)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral95! : NeutralPalette.of(context).neutral30!;
      } else if (states.contains(MaterialState.pressed)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral95! : NeutralPalette.of(context).neutral40!;
      } else if (states.contains(MaterialState.disabled)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral95! : NeutralPalette.of(context).neutral90!;
      } else {
        return Theme.of(context).colorScheme.onBackground;
      }
    case ButtonColors.surface:
      if (states.contains(MaterialState.disabled)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral95! : NeutralPalette.of(context).neutral90!;
      } else {
        return Theme.of(context).colorScheme.onSurface;
      }
  }
}

Color overlayColor(BuildContext context, ButtonColors buttonColor, Set<MaterialState> states) {
  switch (buttonColor) {
    case ButtonColors.primary:
      if (states.contains(MaterialState.hovered)) {
        return Theme.of(context).colorScheme.primary.withOpacity(0.1);
      } else if (states.contains(MaterialState.focused)) {
        return Theme.of(context).colorScheme.primary.withOpacity(0.1);
      } else if (states.contains(MaterialState.pressed)) {
        return Theme.of(context).colorScheme.primary.withOpacity(0.1);
      } else if (states.contains(MaterialState.disabled)) {
        return Theme.of(context).colorScheme.primary.withOpacity(0.1);
      } else {
        return Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1);
      }
    case ButtonColors.base:
      if (states.contains(MaterialState.hovered)) {
        return (context.isDarkMode ? NeutralPalette.of(context).neutral95 : NeutralPalette.of(context).neutral20)!.withOpacity(0.1);
      } else if (states.contains(MaterialState.focused)) {
        return (context.isDarkMode ? NeutralPalette.of(context).neutral95 : NeutralPalette.of(context).neutral30)!.withOpacity(0.1);
      } else if (states.contains(MaterialState.pressed)) {
        return (context.isDarkMode ? NeutralPalette.of(context).neutral95 : NeutralPalette.of(context).neutral40)!.withOpacity(0.1);
      } else if (states.contains(MaterialState.disabled)) {
        return (context.isDarkMode ? NeutralPalette.of(context).neutral95 : NeutralPalette.of(context).neutral90)!.withOpacity(0.1);
      } else {
        return Theme.of(context).colorScheme.onBackground.withOpacity(0.1);
      }
    case ButtonColors.surface:
      if (states.contains(MaterialState.disabled)) {
        return (context.isDarkMode ? NeutralPalette.of(context).neutral95 : NeutralPalette.of(context).neutral90)!.withOpacity(0.1);
      } else {
        return Theme.of(context).colorScheme.onSurface.withOpacity(0.1);
      }
  }
}

Color textButtonForegroundColor(BuildContext context, ButtonColors buttonColor, Set<MaterialState> states) {
  switch (buttonColor) {
    case ButtonColors.primary:
      if (states.contains(MaterialState.hovered)) {
        return Theme.of(context).colorScheme.primary;
      } else if (states.contains(MaterialState.focused)) {
        return Theme.of(context).colorScheme.primary;
      } else if (states.contains(MaterialState.pressed)) {
        return Theme.of(context).colorScheme.primary;
      } else if (states.contains(MaterialState.disabled)) {
        return context.colorScheme.outline;
      } else {
        return Theme.of(context).colorScheme.primary;
      }
    case ButtonColors.base:
      if (states.contains(MaterialState.hovered)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral95! : NeutralPalette.of(context).neutral20!;
      } else if (states.contains(MaterialState.focused)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral95! : NeutralPalette.of(context).neutral30!;
      } else if (states.contains(MaterialState.pressed)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral95! : NeutralPalette.of(context).neutral40!;
      } else if (states.contains(MaterialState.disabled)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral95! : NeutralPalette.of(context).neutral90!;
      } else {
        return Theme.of(context).colorScheme.onBackground;
      }
    case ButtonColors.surface:
      if (states.contains(MaterialState.disabled)) {
        return context.isDarkMode ? NeutralPalette.of(context).neutral95! : NeutralPalette.of(context).neutral90!;
      } else {
        return Theme.of(context).colorScheme.onSurface;
      }
  }
}

double buttonBorderRadius(ButtonSizes buttonSize, bool wide) {
  if (!wide) return 90;

  switch (buttonSize) {
    case ButtonSizes.small:
      return 5;
    case ButtonSizes.medium:
      return 7;
    case ButtonSizes.large:
      return 10;
  }
}

double buttonBorderSideWidth(ButtonSizes buttonSize) {
  switch (buttonSize) {
    case ButtonSizes.small:
      return 1;
    case ButtonSizes.medium:
      return 1;
    case ButtonSizes.large:
      return 2;
  }
}
