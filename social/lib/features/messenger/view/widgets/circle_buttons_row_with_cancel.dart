import 'package:flutter/material.dart';
import 'package:social/features/messenger/view/widgets/title_circle_button.dart';

class CircleButtonsRowWithCancel extends StatelessWidget {
  final List<TitleButtonData> titleButtonsData;
  final TitleButtonData? cancelButtonData;
  final Color buttonBackgroundColor;
  final Color? buttonTitleColor;
  final Color buttonIconColor;
  final Color cancelButtonBackgroundColor;
  final Color cancelButtonIconColor;

  const CircleButtonsRowWithCancel(
      {Key? key,
      required this.titleButtonsData,
      this.cancelButtonData,
      required this.buttonBackgroundColor,
      this.buttonTitleColor,
      required this.buttonIconColor,
      required this.cancelButtonBackgroundColor,
      required this.cancelButtonIconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: createRow(),
    );
  }

  List<Widget> createRow() {
    List<Widget> row = [];

    for (int i = 0; i < titleButtonsData.length; i++) {
      row.add(
        TitleCircleButton(
          title: titleButtonsData[i].title,
          iconPath: titleButtonsData[i].iconPath,
          backgroundColor: buttonBackgroundColor,
          titleColor: buttonIconColor,
          iconColor: buttonTitleColor,
          onPressed: titleButtonsData[i].onPressed,
        ),
      );
      if (i < titleButtonsData.length - 1) {
        row.add(const SizedBox(width: 20));
      }
      if (i == titleButtonsData.length - 1) {
        row.add(const Expanded(child: SizedBox(width: 1)));
        if (cancelButtonData != null) {
          row.add(
            TitleCircleButton(
              title: cancelButtonData!.title,
              iconPath: cancelButtonData!.iconPath,
              backgroundColor: cancelButtonBackgroundColor,
              titleColor: cancelButtonIconColor,
              onPressed: cancelButtonData!.onPressed,
            ),
          );
        }
      }
    }

    return row;
  }
}
