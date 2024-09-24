
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/components/bottom_text_register.dart';
import 'package:impo/src/components/box_status.dart';
import 'package:impo/src/components/colors.dart';
import 'package:get/get.dart';
import 'package:impo/src/screens/LoginAndRegister/globalRegister/Intention%20_install_screen.dart';
import 'package:impo/src/screens/LoginAndRegister/menstruationRegister/periodDay_register_screen.dart';
import 'package:impo/src/screens/LoginAndRegister/pregnancyRegister/bardari_register_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../../../data/locator.dart';
import '../../../firebase_analytics_helper.dart';
import '../../../models/register/register_parameters_model.dart';

class SelectStatusScreen extends StatefulWidget{
  final phoneOrEmail;

  SelectStatusScreen({Key? key,this.phoneOrEmail}):super(key:key);

  @override
  State<StatefulWidget> createState() => SelectStatusScreenState();
}

class SelectStatusScreenState extends State<SelectStatusScreen>{

  var registerInfo = locator<RegisterParamModel>();

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.SelectStatusPg_Back_NavBar_Clk);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(120),
                          bottom: ScreenUtil().setWidth(80)),
                      height: ScreenUtil().setWidth(180),
                      width: ScreenUtil().setWidth(180),
                      child: Image.asset(
                        'assets/images/file.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil().setWidth(20),
                        right: ScreenUtil().setWidth(50),
                        left: ScreenUtil().setWidth(50),
                      ),
                      child: Text(
                        'در چه وضعیتی هستی و می‌خوای از کدوم قسمت ایمپو استفاده کنی؟',
                        textAlign: TextAlign.center,
                          style: context.textTheme.labelLarge
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(50)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(45)),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              registerInfo.setStatus(1);
                              AnalyticsHelper().log(AnalyticsEvents.SelectStatusPgPeriodState_Btn_Clk);
                              // Navigator.push(
                              //   context,
                              //   PageTransition(
                              //       child: PeriodDayRegisterScreen(
                              //         phoneOrEmail: widget.phoneOrEmail,
                              //         hasAbortion: false,
                              //       ),
                              //       type: PageTransitionType.fade
                              //   )
                              // );
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: IntentionInstallScreen(
                                        phoneOrEmail: widget.phoneOrEmail,
                                      ),
                                      type: PageTransitionType.fade
                                  )
                              );
                            },
                            child: BoxStatus(
                              title: "قاعدگی",
                              subTitle:
                              "تقویم قاعدگی و سلامت روان",
                              lowColor: ColorPallet().lightMainColor,
                              highColor: ColorPallet().mainColor,
                              pathImage: 'assets/images/ghaedegi_state.svg',
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setWidth(25),
                          ),
                          InkWell(
                            onTap: () {
                              registerInfo.setStatus(2);
                              registerInfo.setPeriodStatus(0);
                              AnalyticsHelper().log(AnalyticsEvents.SelectStatusPgPregnancyState_Btn_Clk);
                              Navigator.push(
                                context,
                                  PageTransition(
                                      child: BardariRegisterScreen(
                                        phoneOrEmail: widget.phoneOrEmail,
                                      ),
                                      type: PageTransitionType.fade
                                  )
                              );
                            },
                            child: BoxStatus(
                              title: "بارداری",
                              subTitle:
                              "خودمراقبتی هفته به هفته دوران بارداری",
                              lowColor: ColorPallet().mentalHigh,
                              highColor: ColorPallet().mentalMain,
                              pathImage: 'assets/images/baby_state.svg',
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
            child: BottomTextRegister(),
          )
      ),
    );
  }



}