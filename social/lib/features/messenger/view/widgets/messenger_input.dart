import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/constants/assets_paths.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import '../../../../core/app/view/themes/styles/decorations.dart';

class MessengerInput extends StatelessWidget {
  final void Function() onSendPressed;
  final TextEditingController messageTextEditingController;
  final RxBool canSend;

  const MessengerInput({
    Key? key,
    required this.onSendPressed,
    required this.messageTextEditingController,
    required this.canSend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            color: context.colorScheme.background.withOpacity(0.5),
            padding: Decorations.pagePaddingHorizontal.copyWith(top: 8, bottom: 8),
            child: Row(
              children: [
                Obx(
                  () => IconButton(
                    onPressed: onSendPressed,
                    icon: RotatedBox(
                      quarterTurns: 2,
                      child: SvgPicture.asset(
                        AssetPaths.sendComment,
                        color: canSend.value ? context.colorScheme.onPrimary : context.colorScheme.outline,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canSend.value ? context.colorScheme.primary : context.colorScheme.surface,
                      padding: const EdgeInsets.all(12.0),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: messageTextEditingController,
                    maxLines: 3,
                    minLines: 1,
                    style: context.textTheme.bodyLarge,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'پیامت رو بنویس...',
                      filled: true,

                      hintTextDirection: TextDirection.rtl,
                      hintStyle: context.textTheme.bodyLarge!.copyWith(color: context.colorScheme.outlineVariant),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
