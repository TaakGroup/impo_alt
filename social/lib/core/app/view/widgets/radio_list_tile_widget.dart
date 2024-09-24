import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/app/view/themes/styles/buttons/button_types.dart';
import '../../../../../core/app/view/themes/styles/buttons/icon_button__style.dart';
import 'check_box/circle_check_radio_widget.dart';

class IconRadioListTile extends StatelessWidget {
  final String title;
  final Widget icon;
  final bool? value;
  final void Function() onChanged;

  const IconRadioListTile({Key? key, required this.title, required this.icon, this.value, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: null,
                icon: icon,
                style: IconButtonStyle.of(context).outlineStyle(color: ButtonColors.surface),
              ),
              const SizedBox(width: 8),
              Text(title, style: context.textTheme.titleSmall),
            ],
          ),
          if (value != null)
            SizedBox(
              height: 16,
              child: FittedBox(
                fit: BoxFit.fill,
                child: CircleCheckRadioWidget(isSelected: value!),
              ),
            )
          else
            const SizedBox()
        ],
      ),
    );
  }
}
