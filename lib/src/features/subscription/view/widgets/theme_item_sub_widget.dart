import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/utiles/helper/text_helper.dart';
import 'package:impo/src/core/app/view/themes/styles/decorations.dart';
import 'package:impo/src/core/app/view/themes/styles/new_text_theme.dart';
import 'package:impo/src/features/subscription/data/models/subscription_model.dart';

class ThemeItemSubWidget extends StatelessWidget {
  late SubscriptionPackagesModel package;
  late Color cardBorderColor;
  late Color cardBackgroundColor;
  late Color backgroundColorSpecif;
  late Color textColorSpecif;
  late Color circleColor;
  late Color textColor;
  late Color valueColor;
  late Color realValueColor;
  late Color unitColor;
  late Color dividerColor;
  late Color descriptionColor;
  late Widget contentCircle;
  final void Function(String id)? onTap;

    ThemeItemSubWidget({
    super.key,
    required this.package,
    required this.cardBorderColor,
    required this.cardBackgroundColor,
    required this.backgroundColorSpecif,
    required this.textColorSpecif,
    required this.circleColor,
    required this.textColor,
    required this.valueColor,
    required this.realValueColor,
    required this.unitColor,
    required this.dividerColor,
    required this.descriptionColor,
    required this.contentCircle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(package.id),
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            border: Border.all(
                color: cardBorderColor,
                width: 1.5
            ),
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          children: [
            specificWidget(context),
            Padding(
              padding: Decorations.pagePaddingHorizontal.copyWith(
                  bottom: 16,
                  top: 18
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          circleTic(context),
                          SizedBox(width: 8),
                          Text(
                            package.text,
                            style: context.textTheme.titleSmall!.copyWith(
                              color: textColor
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          package.value != package.realValue ?
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  package.realValueText,
                                  style: context.textTheme.labelSmall!.copyWith(
                                      color: realValueColor
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 2),
                                  color: realValueColor,
                                  height: 1,
                                  width: textSize(package.realValueText, context.textTheme.labelSmall!).width,
                                ),
                              ],
                            ),
                          )
                              : SizedBox.shrink(),
                          Text(
                            package.valueText,
                            style: context.textTheme.labelLarge!.copyWith(
                              color: valueColor
                            ),
                          ),
                          !package.isFree ? Padding(
                            padding: const EdgeInsets.only(
                                right: 4
                            ),
                            child: Text(
                              package.unit,
                              style: context.textTheme.labelLarge!.copyWith(
                                color: unitColor
                              ),
                            ),
                          ) : SizedBox.shrink(),
                        ],
                      )
                    ],
                  ),
                  Divider(color: dividerColor),
                  Text(
                    'ماهانه 30.000 تومان برای کاربران جدید',
                    style: context.textTheme.bodySmall!.copyWith(
                      color: descriptionColor
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  specificWidget(BuildContext context){
    if(package.isSpecific){
      return Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
            color: backgroundColorSpecif,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.5),
                topRight: Radius.circular(10.5)
            )
        ),
        child: Center(
          child: Text(
            package.specificText,
            style: context.textTheme.labelSmallProminent!.copyWith(
                color: textColorSpecif
            ),
          ),
        ),
      );
    }else{
      return SizedBox.shrink();
    }
  }

  circleTic(BuildContext context){
    return Container(
      width: 18,
      height: 18,
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: circleColor,
              width: 1.6
          )
      ),
      child: contentCircle,
    );
  }

}