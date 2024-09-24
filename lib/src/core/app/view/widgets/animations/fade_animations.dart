import 'package:flutter/material.dart';

class FadeAnimations extends StatelessWidget {
  final Widget child;
  final AnimationController animationController;
  late final Animation<double> opacityAnimation;
  final Curve curve;

  FadeAnimations({Key? key, required this.child,required this.animationController,this.curve = Curves.ease}) :super(key: key){
    opacityAnimation = _opacity(0.0);
  }


  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAnimation,
      child: child,
    );
  }

  Animation<double> _opacity(double begin){
    return  Tween<double>(
      begin: begin,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: curve,
    ));
  }

}