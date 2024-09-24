import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import '../models/expert/info.dart';
import 'colors.dart';
import 'custom_button.dart';

class ClinicBox extends StatelessWidget{
  final InfoAdviceTypes? infoAdviceTypes;
  final Function()? onPress;

  ClinicBox({this.infoAdviceTypes,this.onPress});

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return GestureDetector(
      onTap: onPress,
      child: Container(
        height: ScreenUtil().setWidth(320),
        margin: EdgeInsets.only(
          right: ScreenUtil().setWidth(30),
          left: ScreenUtil().setWidth(30),
          bottom: ScreenUtil().setWidth(25),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(20),
          // vertical: ScreenUtil().setWidth(15)
        ),
        decoration: BoxDecoration(
            color: Color(0xffF8F8F8),
            borderRadius: BorderRadius.circular(16)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setWidth(20)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      infoAdviceTypes!.name,
                      style: context.textTheme.labelLargeProminent
                    ),
                    Text(
                      infoAdviceTypes!.description,
                      style: context.textTheme.bodySmall
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${infoAdviceTypes!.price} تومان',
                          style: context.textTheme.labelMediumProminent
                        ),
                        CustomButton(
                          title: infoAdviceTypes!.cta,
                          margin: 0,
                          padding: ScreenUtil().setWidth(20),
                          height: ScreenUtil().setWidth(60),
                          colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                          enableButton: true,
                          isLoadingButton: false,
                          child:  Text(
                            infoAdviceTypes!.cta,
                            textAlign: TextAlign.center,
                            style:  context.textTheme.labelMedium!.copyWith(
                              color: Colors.white,
                            )
                          ),
                          onPress: onPress
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(15)),
            Flexible(
              child: Container(
                height: ScreenUtil().setWidth(320),
                padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setWidth(20)
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  infoAdviceTypes!.id == 5 ? 'assets/images/pregnancy_women.png' :
                  infoAdviceTypes!.id == 3  ? 'assets/images/sexTherapy.png' :
                  infoAdviceTypes!.id == 0 ? 'assets/images/psychology.png' :
                  'assets/images/global_clinic.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}