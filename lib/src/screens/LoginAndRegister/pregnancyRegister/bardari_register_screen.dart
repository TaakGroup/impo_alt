import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/components/bottom_text_register.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/LoginAndRegister/pregnancyRegister/numberBardari_register_screen.dart';
import 'package:shamsi_date/extensions.dart';
import 'package:impo/src/components/calender.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/item_birth_or_cycle.dart';
import 'package:impo/src/data/locator.dart';

import '../../../firebase_analytics_helper.dart';

class BardariRegisterScreen extends StatefulWidget {
  final phoneOrEmail;/// if this null ==> fromChangeStatus

  const BardariRegisterScreen({Key? key, this.phoneOrEmail,}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BardariRegisterScreenState();
}

class BardariRegisterScreenState extends State<BardariRegisterScreen> {


  // final TextEditingController bardariController = TextEditingController(
  //     text: Jalali.now()
  //         .toString()
  //         .replaceAll('Jalali', '')
  //         .replaceAll('(', '')
  //         .replaceAll(')', '')
  //         .replaceAll(',', '/'));

  var registerInfo = locator<RegisterParamModel>();
  Jalali bardariShamsiDateTime = Jalali.now();


  bool isLoading = false;
  late Calender calender;
  List<ItemsToggle> itemsBirthOrcycle = [
    ItemsToggle(
        title: "تاریخ زایمان",

        // icon: 'assets/images/ic_call.svg',
        selected: false),
    ItemsToggle(
        title: "اولین روز آخرین پریود",

        // icon: 'assets/images/ic_email.svg',
        selected: true),
  ];

  int typeValue = 1;

  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.BardariRegPg_Self_Pg_Load);
    super.initState();
  }

 String getName(){
    return registerInfo.register.name!;
  }

  int modePress = 0;

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.BardariRegPg_Back_NavBar_Clk);
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
                      widget.phoneOrEmail == null ?
                      CustomAppBar(
                        messages: false,
                        profileTab: true,
                        icon: 'assets/images/ic_arrow_back.svg',
                        titleProfileTab: 'صفحه قبل',
                        subTitleProfileTab: 'صفحه اصلی',
                        onPressBack: () {
                          AnalyticsHelper().log(AnalyticsEvents.BardariRegPg_Back_Btn_Clk);
                          Navigator.pop(context);
                        },
                      ) : Container(),
                      widget.phoneOrEmail != null ?
                      Container(
                        margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(120),
                            bottom: ScreenUtil().setWidth(80)
                        ),
                        height: ScreenUtil().setWidth(180),
                        width: ScreenUtil().setWidth(180),
                        child:  Image.asset(
                          'assets/images/file.png',
                          fit: BoxFit.cover,
                        ),
                      ) : Container(
                        width: ScreenUtil().setWidth(80),
                        height: ScreenUtil().setWidth(80),),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: ScreenUtil().setWidth(20),
                          right: ScreenUtil().setWidth(50),
                          left: ScreenUtil().setWidth(50),
                        ),
                        child: Text(
                          '${getName()} جان برای اینکه مشخص بشه در کدوم هفته بارداری هستی لازمه یکی از تاریخ‌های زیر رو مشخص کنی',
                          textAlign: TextAlign.center,
                            style: context.textTheme.labelLarge
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(80),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Transform.scale(
                              scale: 1.0,
                              child: _itemsBirthOrcycle(
                                0,
                              ),
                            ),
                            Container(
                              child: Text(
                                "یا",
                                  style:  context.textTheme.labelLarge
                              ),
                            ),
                            Transform.scale(
                              scale: 1.0,
                              child: _itemsBirthOrcycle(1),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(45)),
                      !isLoading ?
                      Container(
                          height: ScreenUtil().setWidth(350),
                          child: calender = Calender(
                            isBirthDate: false,
                            // mode: 1,
                            dateTime: bardariShamsiDateTime,
                            // controller: bardariController,
                            maxDate: typeValue == 0 ?
                            Jalali.fromDateTime( DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day + 279
                            )
                            ) : Jalali.fromDateTime(
                                DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day
                                )
                            ),
                            minDate:typeValue == 0 ?
                            Jalali.fromDateTime(  DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day
                            )) :             Jalali.fromDateTime(
                                DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day - 279
                                )
                            ),
                            // typeCalendar: typeValue == 0 ? 1 : 2,
                          )
                      ) : Container(
                        height: ScreenUtil().setWidth(350),
                      ),
                      // SizedBox(
                      //   height: ScreenUtil().setWidth(20),
                      // ),
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

                      // SizedBox(height: ScreenUtil().setWidth(100),),
                      // Align(
                      //   alignment: Alignment.bottomCenter,
                      //   child: Padding(
                      //       padding:
                      //           EdgeInsets.only(top: ScreenUtil().setWidth(60)),
                      //       child: BottomTextItem()),
                      // ),
                    ],
                  ),
                )
              ],
            ),
            bottomNavigationBar: widget.phoneOrEmail != null ?
            Padding(
              padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
              child: BottomTextRegister(),
            ) : Container(width: 0,height: 0,)
        ),
      ),
    );
  }

  accept(){

    if(registerInfo.register.calendarType == 1){
      registerInfo.setPregnancyDate(calender.getDateTime());
    }else{
      registerInfo.setPregnancyDate(calender.getDateTime().toDateTime());
    }

    registerInfo.setIsDeliveryDate(typeValue == 0 ? true : false);

    AnalyticsHelper().log(AnalyticsEvents.BardariRegPg_Cont_Btn_Clk);
    print(registerInfo.register.pregnancyDate);
    Navigator.push(context,
      PageRouteBuilder(
        transitionDuration: Duration(seconds: 2),
        pageBuilder: (_, __, ___) => NumberBardariRegisterScreen(
          phoneOrEmail: widget.phoneOrEmail,
        ),
      ),
    );

  }

  _itemsBirthOrcycle(int _typeValue) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          modePress = _typeValue;
          isLoading = true;
        });

        setState(() {
          typeValue = _typeValue;
          for (int i = 0; i < itemsBirthOrcycle.length; i++) {
            itemsBirthOrcycle[i].selected = false;
          }
          itemsBirthOrcycle[_typeValue].selected =
          !itemsBirthOrcycle[_typeValue].selected!;
        });
        Timer(Duration(milliseconds: 30),(){
          setState(() {
            isLoading = false;
          });
        });

        if(_typeValue == 0){
          AnalyticsHelper().log(AnalyticsEvents.BardariRegPg_DateofBirth_Btn_Clk);
        }else{
          AnalyticsHelper().log(AnalyticsEvents.BardariRegPg_LastPeriod_Btn_Clk);
        }
      },
      child: Container(
        width: ScreenUtil().setWidth(290),
        height: ScreenUtil().setWidth(77),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
              color: !itemsBirthOrcycle[_typeValue].selected!
                  ? ColorPallet().mentalMain
                  : Colors.white),
          gradient: LinearGradient(
              colors: itemsBirthOrcycle[_typeValue].selected!
                  ? [
                ColorPallet().mentalHigh,
                ColorPallet().mentalMain,
              ]
                  : [Colors.white, Colors.white]),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(10),
              vertical: ScreenUtil().setWidth(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  itemsBirthOrcycle[_typeValue].title!,
                  textAlign: TextAlign.center,
              style: context.textTheme.labelMedium!.copyWith(
                color: itemsBirthOrcycle[_typeValue].selected!
                    ? Colors.white
                    : ColorPallet().mentalMain,
              )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
