import 'package:flutter/cupertino.dart';

class PickerWidget extends StatelessWidget {
  final double height;
  final double itemExtent;
  final FixedExtentScrollController? scrollController;
  final Function(int) onChange;
  final List<Widget> children;
  final bool looping;
  final double squeeze;

  const PickerWidget({
    Key? key,
    required this.onChange,
    required this.children,
    this.height = 147,
    this.itemExtent = 48,
    this.scrollController,
    this.looping = false,
    this.squeeze = 0.95,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CupertinoPicker(
        scrollController: scrollController,
        squeeze: squeeze,
        diameterRatio: 1.5,
        itemExtent: itemExtent,
        onSelectedItemChanged: onChange,
        looping: looping,
        children: children,
      ),
    );
  }
}
