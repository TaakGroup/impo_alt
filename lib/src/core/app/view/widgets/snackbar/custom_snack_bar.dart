import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomSnackBar{
  final BuildContext context;
  final String message;
  CustomSnackBar.show(this.context, this.message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.up,
        duration:  const Duration(milliseconds: 2000),
        backgroundColor: Colors.black,
        margin: View.of(context).viewInsets.bottom == 0  ?
        EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - ScreenUtil().setWidth(150),
          left: ScreenUtil().setWidth(20),
          right: ScreenUtil().setWidth(20),
        ) : null,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: context.textTheme.bodySmall!.copyWith(
              color: Colors.white
          ),
        ),
      ),
    );
    // Get.snackbar(
    //     'ایمپویی عزیز',
    //     message,
    //     titleText: SizedBox.shrink(),
    //     messageText: Text(
    //       message,textDirection: TextDirection.rtl,
    //       style: context.textTheme.bodySmall!.copyWith(
    //         color: Colors.white
    //       ),
    //     ),
    //     backgroundColor: Colors.black87
    // );
  }

}