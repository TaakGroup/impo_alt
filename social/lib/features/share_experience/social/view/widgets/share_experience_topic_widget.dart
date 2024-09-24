import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:pulsator/pulsator.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:social/core/app/view/themes/styles/text_theme.dart';

import '../../data/models/share_experience_topic_model.dart';

class ShareExperienceTopicWidget extends StatelessWidget {
  final ShareExperienceTopicModel topic;
  final void Function(ShareExperienceTopicModel shareExperienceTopic)? onTap;

  const ShareExperienceTopicWidget({super.key, required this.topic, this.onTap});

  Widget get widget => Container(
        clipBehavior: Clip.hardEdge,
        decoration: ShapeDecoration(
          color: Get.context?.colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          image: DecorationImage(
            image: CachedNetworkImageProvider(topic.image),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (topic.isLive) const LiveTopicBadge(),
            const Spacer(),
            Container(
              height: 32,
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: FittedBox(
                child: Text(
                  topic.name!,
                  style: Get.textTheme.labelSmallProminent?.copyWith(color: Get.theme.colorScheme.background),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(topic),
      child: AspectRatio(
        aspectRatio: 104 / 120,
        child: !topic.isLive
            ? widget
            : AnimatedGradientBorder(
                borderSize: 3,
                glowSize: -2,
                animationTime: 1,
                gradientColors: const [
                  Color(0xFFFF4CED),
                  Color(0xFFE83D7A),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child: widget,
              ),
      ),
    );
  }
}

class LiveTopicBadge extends StatelessWidget {
  const LiveTopicBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 77,
      height: 26,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(14),
          ),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Pulsator(
              style: PulseStyle(color: Color(0xFFFF4CED)),
              count: 3,
              duration: Duration(seconds: 2),
              repeat: 0,
              startFromScratch: false,
              autoStart: true,
              fit: PulseFit.contain,
            ),
          ),
          SizedBox(width: 4),
          Expanded(
            flex: 3,
            child: Text(
              'گفتگو زنده',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFFD32397),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
