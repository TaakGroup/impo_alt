import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

class CupertinoTimePickerWidget extends StatelessWidget {
  final double height;
  final double itemExtent;
  final FixedExtentScrollController? scrollController;
  final Function(TimeOfDay) onChange;
  final bool looping;
  final double squeeze;
  TimeOfDay timeOfDay;

  CupertinoTimePickerWidget({
    Key? key,
    required this.onChange,
    this.height = 147,
    this.itemExtent = 48,
    this.scrollController,
    this.looping = false,
    this.squeeze = 0.95,
    required this.timeOfDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CupertinoPicker(
                    selectionOverlay: Container(
                      decoration: const BoxDecoration(
                        color: CupertinoColors.tertiarySystemFill,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                    ),
                    squeeze: squeeze,
                    diameterRatio: 1.5,
                    itemExtent: itemExtent,
                    onSelectedItemChanged: (hour) => onChange.call(timeOfDay = TimeOfDay(hour: hour, minute: timeOfDay.minute)),
                    looping: looping,
                    scrollController: FixedExtentScrollController(initialItem: timeOfDay.hour),
                    children: [
                      for (int hour = 0; hour < 24; hour++)
                        Text(
                          intl.NumberFormat("00").format(hour),
                          style: context.textTheme.headlineLarge?.copyWith(height: 2.2),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    selectionOverlay: Container(
                      decoration: const BoxDecoration(
                        color: CupertinoColors.tertiarySystemFill,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                    ),
                    squeeze: squeeze,
                    diameterRatio: 1.5,
                    itemExtent: itemExtent,
                    onSelectedItemChanged: (min) => onChange.call(timeOfDay = TimeOfDay(hour: timeOfDay.hour, minute: min)),
                    looping: looping,
                    scrollController: FixedExtentScrollController(initialItem: timeOfDay.minute),
                    children: [
                      for (int min = 0; min < 60; min++)
                        Text(
                          intl.NumberFormat("00").format(min),
                          style: context.textTheme.headlineLarge?.copyWith(height: 2.2),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              ":",
              style: context.textTheme.displaySmall,
            ),
          ],
        ),
      ),
    );
  }
}
