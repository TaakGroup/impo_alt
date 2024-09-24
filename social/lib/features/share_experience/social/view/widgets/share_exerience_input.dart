import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/constants/assets_paths.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:social/core/app/view/themes/styles/buttons/button_types.dart';
import 'package:social/core/app/view/widgets/input/input.dart';
import '../../../../../core/app/view/themes/styles/decorations.dart';

class ShareExperienceInput extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? onSendPressed;
  final void Function()? onCancelReplyPressed;
  final String hintText;
  final String avatar;
  final String? replayTo;
  final bool replyMode;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  const ShareExperienceInput({
    super.key,
    this.onTap,
    required this.hintText,
    required this.avatar,
    this.controller,
    this.replayTo,
    this.replyMode = false,
    this.onSendPressed,
    this.focusNode,
    this.onCancelReplyPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 0),
          if (replyMode)
            GestureDetector(
              onTap: onCancelReplyPressed,
              child: Container(
                color: context.colorScheme.surfaceVariant,
                padding: Decorations.pagePaddingHorizontal.copyWith(top: 10, bottom: 10),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AssetPaths.close,
                      color: context.colorScheme.onBackground,
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'پاسخ به ${replayTo!}',
                      style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onInverseSurface),
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: Decorations.pagePaddingHorizontal.copyWith(bottom: 8, top: 8),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: ShapeDecoration(
                    color: context.colorScheme.surface,
                    shape: const CircleBorder(),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(avatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Input(
                    focusNode: focusNode,
                    controller: controller,
                    inputSize: InputSize.medium(context).copyWith(
                      hintStyle: context.textTheme.bodySmall,
                      textStyle: context.textTheme.bodySmall,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    ),
                    suffixIconPadding: const EdgeInsets.all(4.0),
                    onTap: replyMode ? null : onTap,
                    enabled: replyMode,
                    hintText: hintText,
                    suffixIcon: ElevatedButton(
                      style: context.buttonThemes.elevatedButtonStyle(size: ButtonSizes.small),
                      onPressed: onSendPressed ?? onTap,
                      child: const Text('ارسال'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
