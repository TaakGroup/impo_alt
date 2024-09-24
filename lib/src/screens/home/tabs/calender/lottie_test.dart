
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LottieTest extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => LottieTestState();
}



class LottieTestState extends State<LottieTest> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              'assets/images/back.png',
              fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height
            ),
            Padding(
              padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(60),
                right:  ScreenUtil().setWidth(25),
                left: ScreenUtil().setWidth(25),
              ),
              child: Image.asset(
                  'assets/images/back1.png',
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(50)
              ),
              child:Lottie.asset(
                  'assets/json2.zip',
                  fit: BoxFit.cover,
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height
              )
            )
          ],
        )
    );
  }
}
