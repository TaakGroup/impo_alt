import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:social/core/app/view/themes/styles/decorations.dart';

import '../../data/models/pregnancy_widget_model.dart';

class PregnancyWidget extends StatelessWidget {
  final PregnancyWidgetModel model;

  const PregnancyWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: Decorations.pagePaddingHorizontal,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        children: [
          Row(
            children: [
              CachedNetworkImage(
                imageUrl: model.image,
                width: context.width * 0.4,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.title,
                      style: context.textTheme.titleSmall,
                    ),
                    SizedBox(height: 2),
                    Text(
                      model.description,
                      style: context.textTheme.bodyMedium,
                    ),
                    Divider(height: 16),
                    ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) => IconListTileWidget(model: model.tiles[index]),
                      separatorBuilder: (_, index) => SizedBox(height: 12),
                      itemCount: model.tiles.length,
                    )
                  ],
                ),
              )
            ],
          ),
          Divider(),
          Row(
            children: [
              if (model.trailingIcon != null && model.trailingIcon!.isNotEmpty)
                CachedNetworkImage(imageUrl: model.trailingIcon!, width: 56, height: 56),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  model.trailingText,
                  style: context.textTheme.titleMedium,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class IconListTileWidget extends StatelessWidget {
  const IconListTileWidget({
    super.key,
    required this.model,
  });

  final ListTileModel model;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 32,
          width: 32,
          padding: EdgeInsets.all(6.4),
          child: Center(child: SvgPicture.asset(model.icon)),
          decoration: BoxDecoration(color: context.colorScheme.surfaceVariant, shape: BoxShape.circle),
        ),
        SizedBox(width: 2),
        Text.rich(
          TextSpan(
            text: model.name,
            style: context.textTheme.labelLarge,
            children: <InlineSpan>[
              TextSpan(
                text: model.text,
                style: context.textTheme.bodyMedium,
              )
            ],
          ),
        ),
      ],
    );
  }
}
