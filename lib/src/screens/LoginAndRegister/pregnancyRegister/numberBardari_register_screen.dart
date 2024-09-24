import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/components/bottom_text_register.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/LoginAndRegister/pregnancyRegister/abortion_register_screen.dart';

import '../../../firebase_analytics_helper.dart';

class NumberBardariRegisterScreen extends StatefulWidget {
  final phoneOrEmail;/// if this null ==> fromChangeStatus

  const NumberBardariRegisterScreen({Key? key,this.phoneOrEmail}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NumberBardariRegisterScreenState();
}

class NumberBardariRegisterScreenState extends State<NumberBardariRegisterScreen> with TickerProviderStateMixin  {


  List<String> yesOrNo = ["داشتم", "نداشتم"];

  int indexDays = 1;
  var registerInfo = locator<RegisterParamModel>();

  String getName(){
    return registerInfo.register.name!;
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.NumberBardariRegPg_Back_NavBar_Clk);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.phoneOrEmail == null ?
                  CustomAppBar(
                    messages: false,
                    profileTab: true,
                    icon: 'assets/images/ic_arrow_back.svg',
                    titleProfileTab: 'صفحه قبل',
                    subTitleProfileTab: 'صفحه اصلی',
                    onPressBack: () {
                      AnalyticsHelper().log(AnalyticsEvents.NumberBardariRegPg_Back_Btn_Clk);
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
                    padding:
                    EdgeInsets.only(bottom: ScreenUtil().setWidth(100)),
                    child: Text(
                      '${getName()} جان آیا تا بحال سابقه زایمان داشتی؟',
                      textAlign: TextAlign.center,
                        style: context.textTheme.labelLarge
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(100)),
                  Container(
                      alignment: Alignment.center,
                      height: ScreenUtil().setWidth(220),
                      child: Center(
                          child: NotificationListener<
                              OverscrollIndicatorNotification>(
                              onNotification: (overscroll) {
                                overscroll.disallowIndicator();
                                return true;
                              },
                              child: Theme(
                                data: ThemeData(
                                    cupertinoOverrideTheme:
                                    CupertinoThemeData(
                                        textTheme: CupertinoTextThemeData(
                                          pickerTextStyle: TextStyle(
                                              color: ColorPallet().mainColor),
                                        ))),
                                child: CupertinoPicker(
                                    scrollController:
                                    FixedExtentScrollController(initialItem: 1),
                                    itemExtent: ScreenUtil().setWidth(110),
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        indexDays = index;
                                      });
                                    },
                                    children: List.generate(yesOrNo.length,
                                            (index) {
                                          return Center(
                                            child: Text(
                                              yesOrNo[index],
                                                style:  context.textTheme.bodyLarge!.copyWith(
                                                    color: ColorPallet().mainColor
                                                )
                                            ),
                                          );
                                        })),
                              )


                          )
                      )
                  ),
                  Align(
                    child: Padding(
                      padding: EdgeInsets.only(top: ScreenUtil().setWidth(130)),
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
    int typePregnancy = 0;


    if(yesOrNo[indexDays] == 'داشتم') typePregnancy = 1;

    if(yesOrNo[indexDays] == 'نداشتم') typePregnancy= 2;

    registerInfo.setPregnancyNo(typePregnancy);

    AnalyticsHelper().log(AnalyticsEvents.NumberBardariRegPg_Cont_Btn_Clk);
    Navigator.push(context,
      PageRouteBuilder(
        transitionDuration: Duration(seconds: 2),
        pageBuilder: (_, __, ___) => AbortionRegisterScreen(
          phoneOrEmail: widget.phoneOrEmail,
        ),
      ),
    );
  }



}
