import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social/core/app/utils/extensions/context/style_shortcut.dart';


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
    return Expanded(
        flex: 1,
        child: Stack(
          fit: StackFit.loose,
          children: [
            Positioned(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 18),
                height: height,
                decoration: const BoxDecoration(color: Colors.transparent),
                child: CupertinoPicker(
                  selectionOverlay: Container(),
                  backgroundColor: Colors.transparent,
                  scrollController: scrollController!,
                  squeeze: 0.95,
                  diameterRatio: 1.5,
                  itemExtent: itemExtent,
                  onSelectedItemChanged: onChange,
                  looping: looping,
                  children: children,
                ),
              ),
            ),
            Positioned(
              child: Container(
                  margin: const EdgeInsets.only(top: 63),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /// SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Expanded(
                        child: Divider(
                          color: context.colorScheme.outline,
                          height: 1,
                          thickness: 1,
                        ),
                      ),

                      /// SizedBox(width: MediaQuery.of(context).size.width * 0.02)
                    ],
                  )),
            ),
            Positioned(
              child: Container(
                  margin: const EdgeInsets.only(top: 99),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /// SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Expanded(
                        child: Divider(
                          color: context.colorScheme.outline,
                          height: 1,
                          thickness: 1,
                        ),
                      ),

                      /// SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    ],
                  )),
            ),
          ],
        ));
  }
}
