import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SplashTextStaggerAnimation extends StatelessWidget{

  SplashTextStaggerAnimation({Key? key,this.animationController})
      :
        opacity = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(
    CurvedAnimation(
      parent: animationController!,
      curve: const Interval(0.0, 1.0, curve: Curves.ease),
    ),
  ),
        margitTop = Tween<double>(
          begin: 550.0,
          end: 350.0,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.0, 1.0, curve: Curves.ease),
          ),
        ),
        super(key:key);

  final AnimationController? animationController;
  final Animation<double> opacity;
  final Animation<double> margitTop;

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return  Padding(
      padding: EdgeInsets.only(
        top: ScreenUtil().setWidth(margitTop.value)
      ),
      child: Opacity(
        opacity: opacity.value,
        child: Text(
          'بزرگترین پلتفرم حوزه سلامت بانوان',
          style:context.textTheme.titleSmall!.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: animationController!,
    );
  }

}