import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/components/circle_check_radio_widget.dart';

class RadioListTileWidget extends StatelessWidget {
  final String title;
  final bool value;
  final void Function() onChanged;
  final EdgeInsets? padding;

  const RadioListTileWidget({Key? key, required this.title, required this.value, required this.onChanged, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      onTap: onChanged,
      child: Container(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: CircleCheckRadioWidget(isSelected: value),
                  ),
                ),
                const SizedBox(width: 20),
                Text(title, style: context.textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
