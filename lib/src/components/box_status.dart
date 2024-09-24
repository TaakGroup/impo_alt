import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


class BoxStatus extends StatelessWidget {
  final String? pathImage;
  final String? title;
  final String? subTitle;
  final Color? lowColor;
  final Color? highColor;
  final marginHorizontal;

  BoxStatus({Key? key, this.pathImage, this.highColor, this.lowColor,this.title,this.subTitle,this.marginHorizontal})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: marginHorizontal != null ? ScreenUtil().setWidth(marginHorizontal) : 0
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: [
            lowColor!,
            highColor!,
          ]),
        ),
        child: Padding(
          padding:EdgeInsets.all(ScreenUtil().setWidth(25)),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
                decoration: BoxDecoration(color: Colors.white,  borderRadius: BorderRadius.circular(10),),
                child: SvgPicture.asset(
                  pathImage!,
                  width:ScreenUtil().setWidth(55) ,
                  height:ScreenUtil().setWidth(55) ,
                ),
              ),
              SizedBox(width: ScreenUtil().setWidth(15),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: context.textTheme.labelLarge!.copyWith(
                      color: Colors.white,
                    )
                  ),
                  Text(
                    subTitle!,
                    style: context.textTheme.bodySmall!.copyWith(
                      color: Colors.white,
                    )
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
