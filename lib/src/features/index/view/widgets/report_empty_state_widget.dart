import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/core/app/view/themes/styles/new_text_theme.dart';
import 'package:social/core/app/view/themes/styles/decorations.dart';

import '../../data/models/report_empty_state_widget_model.dart';

class ReportEmptyStateWidget extends StatelessWidget {
  final ReportEmptyStateWidgetModel model;

  const ReportEmptyStateWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Decorations.pagePaddingHorizontal,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: ColoredBox(
          color: context.colorScheme.background,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 385/161,
                child: CachedNetworkImage(
                  imageUrl: model.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.0).copyWith(top: 4.0),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.0, end: max(model.percent / 100, 0.01)),
                          duration: const Duration(milliseconds: 500),
                          builder: (context, value, _) => SizedBox.square(
                            dimension: 64,
                            child: CircularProgressIndicator(
                              value: value,
                              color: context.colorScheme.primary,
                              backgroundColor: context.colorScheme.primary.withOpacity(0.12),
                              strokeWidth: 8,
                              strokeAlign: CircularProgressIndicator.strokeAlignInside,
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                        ),
                        Text(
                          '${model.days} روز\nمانده',
                          style: context.textTheme.labelSmallProminent,
                        )
                      ],
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.title,
                            style: context.textTheme.titleSmall,
                          ),
                          SizedBox(height: 8),
                          Text(
                            model.description,
                            style: context.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
