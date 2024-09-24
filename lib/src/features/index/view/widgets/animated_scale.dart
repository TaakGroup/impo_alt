import 'package:flutter/material.dart';

class ScaleAnimation extends AnimatedWidget {
  final Animation<double> animation;
  final Widget child;

  const ScaleAnimation({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      alignment: Alignment.topCenter,
      child: child,
    );
  }
}
