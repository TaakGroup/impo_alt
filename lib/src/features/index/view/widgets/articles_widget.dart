import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';
import 'package:impo/src/core/app/view/themes/styles/buttons/button_types.dart';
import '../../../../core/app/view/themes/styles/decorations.dart';
import '../../data/models/articles_widget_model.dart';

class ArticlesWidget extends StatelessWidget {
  final ArticlesWidgetModel model;

  const ArticlesWidget({super.key, required this.model});

  double get w => (Get.width - 64) / 2.4;

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
          Container(
            height: 126,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: model.list.length,
              padding: EdgeInsets.only(top: 8),
              itemBuilder: (_, index) => SizedBox(
                width: w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 142 / 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        child: CachedNetworkImage(
                          imageUrl: model.list[index].image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      model.list[index].title,
                      style: context.textTheme.labelMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              separatorBuilder: (_, index) => SizedBox(width: 4),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            style: context.buttonThemes.elevatedButtonStyle(color: ButtonColors.surface, wide: true)?.copyWith(elevation: WidgetStateProperty.all(0)),
            onPressed: () {},
            child: Text('مشاهده همه مقالات'),
          )
        ],
      ),
    );
  }
}
