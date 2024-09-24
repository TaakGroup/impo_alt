import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:intl/intl.dart';
import '../../../data/models/message_model.dart';

class MessagesBubbleWidget extends StatelessWidget {
  final MessagesModel message;
  final void Function()? onTap;
  final void Function(Offset)? onLongPress;
  final Animation<double> animation;

  const MessagesBubbleWidget({
    Key? key,
    required this.message,
    this.onTap,
    this.onLongPress,
    required this.animation,
  }) : super(key: key);

  String get timeText => DateFormat('kk:mm').format(message.time);

  String get text => message.text;

  Color? bubbleFillColor(BuildContext context) {
    if (message.isOwner) {
      return null;
    } else {
      return context.colorScheme.background;
    }
  }

  Color sendDateColor(BuildContext context) {
    if (message.isOwner) {
      return context.colorScheme.background;
    } else {
      return context.colorScheme.outline;
    }
  }

  BorderRadius get bubbleBoarder {
    if (message.isOwner) {
      return const BorderRadius.all(Radius.circular(13)).copyWith(bottomRight: Radius.zero);
    } else {
      return const BorderRadius.all(Radius.circular(13)).copyWith(bottomLeft: Radius.zero);
    }
  }

  TextStyle messageTextStyle(BuildContext context) {
    if (message.isOwner) {
      return context.textTheme.bodyMedium!.copyWith(color: context.colorScheme.background);
    } else {
      return context.textTheme.bodyMedium!;
    }
  }

  Gradient? get gradiant {
    if (message.isOwner) {
      return LinearGradient(
        begin: Alignment(0.93, -0.36),
        end: Alignment(-0.93, 0.36),
        colors: [Color(0xFFE26879), Color(0xFFF87461)],
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: message.isOwner ? const Offset(1, 0) : const Offset(-1, 0),
          end: Offset.zero,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Align(
          alignment: message.isOwner ? Alignment.topRight : Alignment.topLeft,
          child: Container(
            constraints: BoxConstraints(maxWidth: context.width * 0.7),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: bubbleFillColor(context), borderRadius: bubbleBoarder, gradient: gradiant),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (text.isNotEmpty)
                  SelectableText(
                    text,
                    style: messageTextStyle(context),
                  ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => Icon(
                        message.messageStatus.value == MessageStatus.sent ? Icons.check_rounded : Icons.access_time,
                        color: sendDateColor(context),
                        size: 12,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      timeText,
                      style: context.theme.textTheme.labelSmall?.copyWith(color: sendDateColor(context)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
