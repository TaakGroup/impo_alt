import 'package:flutter/material.dart';

class PositionAnimations extends StatelessWidget {
  final Widget child;
  final AnimationController animationController;
  late final Animation<Offset> offsetAnimation;
  final Curve curve;

  PositionAnimations.top({Key? key, required this.child,required this.animationController,this.curve = Curves.ease}) :super(key: key){
    offsetAnimation = _offset(const Offset(0.0,-1.0));
  }

   PositionAnimations.bottom({Key? key, required this.child,required this.animationController,this.curve = Curves.ease}) :super(key: key){
     offsetAnimation = _offset(const Offset(0.0,2.0));
   }

  PositionAnimations.right({Key? key, required this.child,required this.animationController,this.curve = Curves.ease}) :super(key: key){
    offsetAnimation = _offset(const Offset(1.0,0.0));
  }


  PositionAnimations.left({Key? key, required this.child,required this.animationController,this.curve = Curves.ease}) :super(key: key){
    offsetAnimation = _offset(const Offset(-1.0,0.0));
  }


  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }

  Animation<Offset> _offset(Offset begin){
    return  Tween<Offset>(
      begin: begin,
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: curve,
    ));
  }


}
