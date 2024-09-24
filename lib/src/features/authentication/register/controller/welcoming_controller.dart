import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app.dart';
import 'package:impo/src/core/app/constans/app_routes.dart';
import 'package:impo/src/core/app/utiles/helper/box_helpers.dart';

import '../../../../core/app/utiles/classes/vibration.dart';

class WelcomingController extends GetxController with GetTickerProviderStateMixin {

  static WelcomingController get to => Get.find();

  late AnimationController logoAnimationController;
  late AnimationController titleAnimationController;
  late AnimationController subTitleAnimationController;

  @override
  Future<void> onInit() async {
    initAnimation();
    await App.init();
    // Future.delayed(const Duration(seconds: 5), () {
    //   Navigator.pushReplacement(
    //       Get.context!,
    //       PageTransition(
    //           type: PageTransitionType.fade,
    //           child:  SplashScreen(
    //             localPass: true,
    //             index: 4,
    //           )
    //       )
    //   );
    //
    // });
    super.onInit();
  }

  @override
  void dispose() {
    logoAnimationController.dispose();
    titleAnimationController.dispose();
    subTitleAnimationController.dispose();
    super.dispose();
  }

  initAnimation() async {
     logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..addListener(() async {
      if(logoAnimationController.value >= 0.5){
        await titleAnimationController.forward();
      }
     });

     titleAnimationController = AnimationController(
       duration: const Duration(milliseconds: 1000),
       reverseDuration: const Duration(milliseconds: 750),
       vsync: this,
     );

     subTitleAnimationController = AnimationController(
       duration: const Duration(milliseconds: 750),
       reverseDuration: const Duration(milliseconds: 750),
       vsync: this,
     );
     forwardAnim();
  }

  forwardAnim()async{
    Future.delayed(Duration(milliseconds: 2000),(){
      CustomVibration().normalVibrator();
    });
    await logoAnimationController.forward();
    // await titleAnimationController.forward();
    CustomVibration().normalVibrator();
    await subTitleAnimationController.forward();;
    Future.delayed(Duration(milliseconds: 1500),(){
       reverseAnim();
    });
  }

   reverseAnim()async{
     titleAnimationController.reverse();
     subTitleAnimationController.reverse();
     Future.delayed(Duration(milliseconds: 750),(){
       bool isLogged = BoxHelper.hasToken;
       fireRoute(isLogged);
     });
  }

  fireRoute(bool logged) async {
    if (logged) {
      // var result = await LoginController.to.autoLogin();
      // result.fold((l) => onFailureSplash(LoginController.to.autoLogin), (r) => null);
      // Get.offNamed(AppRoutes.subscription);
      Get.offNamed(AppRoutes.index);
    } else {
      Get.offNamed(AppRoutes.number);
    }
  }


  // goToPhoneNumber() => Get.offNamed(AppRoutes.number);

}
