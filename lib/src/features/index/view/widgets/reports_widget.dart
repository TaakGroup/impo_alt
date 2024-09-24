import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/core/app/view/themes/styles/buttons/button_types.dart';
import 'package:impo/src/core/app/view/widgets/design_size_figma.dart';
import '../../../../core/app/view/themes/styles/decorations.dart';
import '../../data/models/reports_widget_model.dart';

class ReportsWidget extends StatelessWidget {
  final ReportsWidgetModel model;

  const ReportsWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: Decorations.pagePaddingHorizontal,
      padding: EdgeInsets.all(16.0),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(model.title, style: context.textTheme.titleSmall),
          Divider(color: context.colorScheme.surface, height: 16),
          Text(model.description, style: context.textTheme.bodySmall),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: model.list.length,
            padding: EdgeInsets.only(top: 12),
            itemBuilder: (_, index) => Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: model.list[index].backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.network(
                    model.list[index].icon,
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    model.list[index].title,
                    style: context.textTheme.labelSmall,
                  ),
                  SizedBox(height: 16, child: VerticalDivider(width: 16)),
                  Expanded(
                    child: Text(
                      model.list[index].text,
                      style: context.textTheme.labelSmall,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    model.list[index].trailing,
                    style: context.textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            separatorBuilder: (_, index) => SizedBox(height: 4),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: context.buttonThemes
                .elevatedButtonStyle(color: ButtonColors.surface, wide: true)
                ?.copyWith(elevation: WidgetStateProperty.all(0)),
            onPressed: () {},
            child: Text(model.buttonText),
          ),
        ],
      ),
    );
  }
}
