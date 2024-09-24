import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:impo/src/components/colors.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/my_separator.dart';
import '../../../../data/http.dart';
import '../../../../models/expert/ticket_info_model.dart';

class ItemDoctorWidget extends StatelessWidget {
  final DoctorInfoModel? doctorInfo;
  final Function()? press;
  final Function()? changeSelected;

   ItemDoctorWidget({Key? key,this.doctorInfo,this.press,this.changeSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return GestureDetector(
      onTap: changeSelected != null ? changeSelected : (){},
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(30)
        ),
        padding: EdgeInsets.only(
          top: ScreenUtil().setWidth(10),
          right: ScreenUtil().setWidth(30),
          left: ScreenUtil().setWidth(30),
          bottom: ScreenUtil().setWidth(10)
        ),
        decoration: BoxDecoration(
          gradient:
          LinearGradient(
              colors: [
                doctorInfo!.selected ? Color(0xffE9DCFF) : Colors.white,
                doctorInfo!.selected ? Color(0xffE0CDFF).withOpacity(0.12) : Colors.white
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight
          ) ,
          border: Border.all(
            color: doctorInfo!.selected ? Color(0xffC8AAF4) : Color(0xffE4E4E4)
          ),
          borderRadius: BorderRadius.circular(16)
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            height: ScreenUtil().setWidth(140),
                            width: ScreenUtil().setWidth(140),
                            decoration:  BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Color(0xffF2F2F2),
                                    width: ScreenUtil().setWidth(2)
                                ),
                                image:  DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      '$mediaUrl/file/${doctorInfo!.image}',
                                    )
                                )
                            ),
                          ),
                          doctorInfo!.isOnline ?
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(10),
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xff766DFC),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: ScreenUtil().setWidth(10),
                                  height: ScreenUtil().setWidth(10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white
                                  ),
                                ),
                                SizedBox(width: ScreenUtil().setWidth(5)),
                                Text(
                                  'آنلاین',
                                  style: context.textTheme.labelSmall!.copyWith(
                                    color: Colors.white,
                                    fontSize: 10
                                  ),
                                )
                              ],
                            ),
                          ) :
                          Container()
                        ],
                      ),
                      SizedBox(width: ScreenUtil().setWidth(10),),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${doctorInfo!.firstName} ${doctorInfo!.lastName}',
                              style: context.textTheme.labelMediumProminent!.copyWith(
                                color: Color(0xff3E3E3E),
                              )
                            ),
                            Text(
                              doctorInfo!.speciliaty,
                              style:context.textTheme.labelSmall!.copyWith(
                                color: ColorPallet().gray,
                              )
                            ),
                            doctorInfo!.nezamNumber != '' ?
                            Text(
                              'نظام پزشکی: ${doctorInfo!.nezamNumber}',
                              style: context.textTheme.labelSmall!.copyWith(
                            color: ColorPallet().gray,
                               )
                            ) : Container()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                press != null ?
                CustomButton(
                    title: 'صفحه متخصص',
                    margin: 0,
                    height: ScreenUtil().setWidth(50),
                    colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                    enableButton: true,
                    isLoadingButton: false,
                    child:  Text(
                      'صفحه متخصص',
                      textAlign: TextAlign.center,
                      style:  context.textTheme.labelSmall!.copyWith(
                        color: Colors.white,
                      )
                    ),
                    onPress: press
                )
                    : Container()
              ],
            ),
            SizedBox(height: ScreenUtil().setWidth(10)),
            MySeparator(color: Color(0xffD2B7FF),height: ScreenUtil().setWidth(1),),
            SizedBox(height: ScreenUtil().setWidth(15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'میانگین پاسخگویی:',
                        style: context.textTheme.labelSmall!.copyWith(
                          color: Color(0xff333333),
                        )
                    ),
                    SizedBox(height: ScreenUtil().setWidth(5)),
                    Text(
                      doctorInfo!.minTime,
                      style: context.textTheme.labelSmall!.copyWith(
                        color: Color(0xff454545),
                        fontWeight: FontWeight.w800
                      )
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15)),
                  color: Color(0xffD0D0D0),
                  width: 0.7,
                  height: ScreenUtil().setWidth(50),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'میانگین امتیازات:',
                      style: context.textTheme.labelSmall!.copyWith(
                        color: Color(0xff333333),
                      )
                    ),
                    SizedBox(height: ScreenUtil().setWidth(5)),
                    Row(
                      children: [
                        Text(
                          '${doctorInfo!.rate} ',
                            style: context.textTheme.labelSmall!.copyWith(
                                color: Color(0xff454545),
                                fontWeight: FontWeight.w800
                            )
                        ),
                        SvgPicture.asset(
                          'assets/images/ic_star.svg',
                          colorFilter: ColorFilter.mode(
                            Color(0xffffc404),
                            BlendMode.srcIn
                          ),
                          width: ScreenUtil().setWidth(25),
                        )
                      ],
                    )
                  ],
                ),
                Container(
                  color: Color(0xffD0D0D0),
                  margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15)),
                  width: 0.7,
                  height: ScreenUtil().setWidth(50),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'تعداد مشاوره‌ها:',
                        style: context.textTheme.labelSmall!.copyWith(
                          color: Color(0xff333333),
                        )
                    ),
                    SizedBox(height: ScreenUtil().setWidth(5)),
                    Text(
                      doctorInfo!.ticketCount,
                        style: context.textTheme.labelSmall!.copyWith(
                            color: Color(0xff454545),
                            fontWeight: FontWeight.w800
                        )
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
