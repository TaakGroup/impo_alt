import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/features/index/data/models/prediction_widget_model.dart';

import '../../../../core/app/view/themes/styles/decorations.dart';

class PredictionWidget extends StatelessWidget {
  final PredictionWidgetModel model;

  const PredictionWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: Decorations.pagePaddingHorizontal,
      padding: EdgeInsets.all(16.0),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(model.title, style: context.textTheme.titleSmall),
          Divider(color: context.colorScheme.surface, height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: model.list.length,
            padding: EdgeInsets.only(top: 8),
            itemBuilder: (_, index) => Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              decoration: BoxDecoration(
                color: model.list[index].backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.network(
                    model.list[index].icon,
                    height: 40,
                    width: 40,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      model.list[index].title,
                      style: context.textTheme.labelSmall,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        model.list[index].trailingUp,
                        style: context.textTheme.labelSmall,
                      ),
                      SizedBox(height: 2),
                      Text(
                        model.list[index].trailingDown,
                        style: context.textTheme.labelSmall?.copyWith(color: context.colorScheme.onInverseSurface),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            separatorBuilder: (_, index) => SizedBox(height: 4),
          )
        ],
      ),
    );
  }
}
