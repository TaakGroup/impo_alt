import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/constans/assets_paths.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/core/app/view/themes/styles/decorations.dart';
import '../../data/models/hint_widget_model.dart';

class HintsWidget extends StatelessWidget {
  final HintWidgetModel model;

  const HintsWidget({
    super.key,
    required this.model,
  });

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(AssetPaths.hint),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: model.hints.length,
                      separatorBuilder: (BuildContext context, int index) => Divider(
                        color: context.colorScheme.surface,
                        height: 16,
                      ),
                      itemBuilder: (context, index) {
                        return Text(
                          model.hints[index].text,
                          style: context.textTheme.bodyMedium,
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}