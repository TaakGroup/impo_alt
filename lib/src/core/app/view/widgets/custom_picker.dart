import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:impo/src/core/app/utiles/extensions/context/style_shortcut.dart';

class CustomPicker extends StatelessWidget {
  final double height;
  final double itemExtent;
  final FixedExtentScrollController? scrollController;
  final Function(int) onChange;
  final List<Widget> children;
  final bool looping;

  const CustomPicker({
    Key? key,
    required this.onChange,
    required this.children,
    this.height = 160,
    this.itemExtent = 36,
    this.scrollController,
    this.looping = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: context.colorScheme.onSurface.withOpacity(0.16), width: 0.75),
                    bottom: BorderSide(color: context.colorScheme.onSurface.withOpacity(0.16), width: 0.75))),
          ),
          GestureDetector(
            child: Material(
                color: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Stack(
                        fit: StackFit.loose,
                        children: <Widget>[
                          Positioned(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 18),
                              height: height,
                              decoration: BoxDecoration(color: Colors.transparent),
                              child: CupertinoPicker(
                                selectionOverlay: Container(),
                                backgroundColor: Colors.transparent,
                                scrollController: scrollController,
                                squeeze: 0.95,
                                diameterRatio: 3,
                                magnification: 1.3,
                                itemExtent: itemExtent,
                                onSelectedItemChanged: onChange,
                                looping: looping,
                                children: children,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
          ),
        ],
      ),
    );
  }
}
