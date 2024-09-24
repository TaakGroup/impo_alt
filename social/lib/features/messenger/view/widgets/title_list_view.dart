import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';
import 'package:social/features/messenger/view/widgets/title_circle_button.dart';

import '../../../../core/app/view/widgets/radio_list_tile_widget.dart';

class TitleListWidget extends StatelessWidget {
  final List<TitleButtonData> titleButtonsData;

  const TitleListWidget({Key? key, required this.titleButtonsData}) : super(key: key);

  static showDialog(List<TitleButtonData> titleButtonsData) {
    return Get.bottomSheet(
      TitleListWidget(titleButtonsData: titleButtonsData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 32),
      color: context.colorScheme.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Divider(
            color: context.colorScheme.surface,
            height: 32,
            indent: context.width * 0.35,
            endIndent: context.width * 0.35,
            thickness: 3,
          ),
          Wrap(
            children: [
              for (var item in titleButtonsData)
                Column(
                  children: [
                    IconRadioListTile(
                      title: item.title,
                      onChanged: item.onPressed,
                      icon: SvgPicture.asset(
                        item.iconPath,
                        color: context.colorScheme.onBackground,
                      ),
                    ),
                    if (titleButtonsData.last != item) const Divider(height: 24)
                  ],
                )
            ],
          ),
        ],
      ),
    );
  }
}
