import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/components/calender.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/LoginAndRegister/breastfeedingRegister/specification_baby_register_screen.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shamsi_date/extensions.dart';

import '../../../firebase_analytics_helper.dart';


class PregnancyDateRegisterScreen extends StatefulWidget {

  @override
  State<PregnancyDateRegisterScreen> createState() =>
      PregnancyDateRegisterScreenState();
}

class PregnancyDateRegisterScreenState extends State<PregnancyDateRegisterScreen> {

late AnimationController animationControllerScaleSendButton;

  bool isLoading = false;
var registerInfo = locator<RegisterParamModel>();
  Jalali birthShamsiDateTime = Jalali.now();


  late Calender calender;
  @override
  void initState() {
    setMaxAndMinCalendar();
    super.initState();
  }

late Jalali maxDate;
late Jalali minDate;

  setMaxAndMinCalendar(){
      DateTime today  = DateTime.now();
      minDate = Jalali.fromDateTime(
        DateTime(today.year,today.month,today.day - 175)
      );
      maxDate = Jalali.now();
  }

Future<bool> _onWillPop()async{
  AnalyticsHelper().log(AnalyticsEvents.PregnancyDateRegPg_Back_NavBar_Clk);
  return Future.value(true);
}

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomAppBar(
                        messages: false,
                        profileTab: true,
                        icon: 'assets/images/ic_arrow_back.svg',
                        titleProfileTab: 'صفحه قبل',
                        subTitleProfileTab: 'صفحه اصلی',
                        onPressBack: () {
                          AnalyticsHelper().log(AnalyticsEvents.PregnancyDateRegPg_Back_Btn_Clk);
                          Navigator.pop(context);
                        },
                      ),
                       Padding(
                        padding: EdgeInsets.only(
                          top: ScreenUtil().setWidth(180),
                          right: ScreenUtil().setWidth(50),
                          left: ScreenUtil().setWidth(50),
                        ),
                        child: Text(
                          'لطفا تاریخ زایمانت رو انتخاب کن',
                          textAlign: TextAlign.center,
                          style: context.textTheme.labelLargeProminent!.copyWith(
                            color: ColorPallet().gray,
                          ),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(45)),
                      Container(
                          height: ScreenUtil().setWidth(350),
                          child: calender = Calender(
                            // mode: 1,
                            isBirthDate: false,
                            // dateTime: registerInfo.register.calendarType == 1 ?
                            // birthDateTime :
                            // birthShamsiDateTime,
                            dateTime: birthShamsiDateTime,
                            minDate: minDate,
                            maxDate: maxDate,
                          )),
                      SizedBox(
                        height: ScreenUtil().setWidth(40),
                      ),
                      Align(
                        child: Padding(
                          padding: EdgeInsets.only(top: ScreenUtil().setWidth(0)),
                          child: CustomButton(
                            title: 'ادامه',
                            onPress: accept,
                            colors: [
                              ColorPallet().mentalHigh,
                              ColorPallet().mentalMain
                            ],
                            borderRadius: 10.0,
                            enableButton: true,
                          ),
                        ),
                      ),


                    ],
                  ),
                )
              ],
            ),
           ),
      ),
    );
  }

  
  accept() {
    var registerInfo = locator<RegisterParamModel>();
    if(registerInfo.register.calendarType == 1){
      registerInfo.setChildBirthDate(calender.getDateTime());
    }else{
      registerInfo.setChildBirthDate(calender.getDateTime().toDateTime());
    }

    AnalyticsHelper().log(AnalyticsEvents.PregnancyDateRegPg_Cont_Btn_Clk);
    Navigator.push(
        context,
        PageTransition(
            child: SpecificationBabyRegisterScreen(),
            type: PageTransitionType.fade
        )
    );
  }

}
