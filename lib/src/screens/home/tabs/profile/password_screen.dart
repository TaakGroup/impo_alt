

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/text_field_area.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/home/blank_screen.dart';
import 'package:impo/src/screens/home/home.dart';
import 'package:impo/src/screens/home/tabs/profile/profile_sceen.dart';
import 'package:impo/src/screens/home/tabs/profile/set_pass_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../firebase_analytics_helper.dart';

class PasswordScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => PasswordScreenState();

}

class PasswordScreenState extends State<PasswordScreen>{

  late TextEditingController passController;
  late TextEditingController changePassController;
  late TextEditingController fingerPrintController;
  bool active = false;
  bool fingerActive = false;
  bool isShowFingerPrint = false;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    passController =  TextEditingController(text: 'رمز قفل');
    changePassController =  TextEditingController(text: 'تغییر رمز قفل');
    fingerPrintController =  TextEditingController(text: 'ورود با اثر انگشت');
    checkSetPassword();
    checkFingerPrint();
    super.initState();
  }

  checkFingerPrint()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    if(canAuthenticate && availableBiometrics.isNotEmpty){
      setState(() {
        isShowFingerPrint = true;
      });
      if(prefs.getBool('fingerPrint') != null){
        if(prefs.getBool('fingerPrint')!){
          setState(() {
            fingerActive = true;
          });
        }else{
          setState(() {
            fingerActive = false;
          });
        }
      }
    }else{
      setState(() {
        isShowFingerPrint = false;
      });
    }
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.PasswordPg_Back_NavBar_Clk);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return  WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child:  Scaffold(
          backgroundColor: Colors.white,
          body:  Column(
            children: <Widget>[
               Padding(
                padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(60)),
                child:  CustomAppBar(
                  messages: false,
                  profileTab: true,
                  isEmptyLeftIcon: true,
                  icon: 'assets/images/ic_arrow_back.svg',
                  titleProfileTab: 'صفحه قبل',
                  subTitleProfileTab: 'رمز قفل',
                  onPressBack: (){
                    AnalyticsHelper().log(AnalyticsEvents.PasswordPg_Back_Btn_Clk);
                    Navigator.pop(context);
                  },
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(270),
                      ),
                      child: SvgPicture.asset(
                        'assets/images/ic_big_pass.svg',
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil().setWidth(10),
                      ),
                      child: Text(
                        'رمز قفل',
                        style: context.textTheme.headlineMedium!.copyWith(
                          color: ColorPallet().mainColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(30)),
              TextFieldArea(
                label: 'رمز قفل',
                textController: passController,
                readOnly: true,
                editBox: false,
                textColor: ColorPallet().black,
                isActivePass:  Padding(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(25)
                  ),
                  child: Transform.scale(
                      scale: ScreenUtil().setWidth(1.55),
                      child:  CupertinoSwitch(
                        value: active,
                        trackColor: ColorPallet().gray.withOpacity(0.5),
                        activeColor: ColorPallet().mainColor,
                        onChanged: (bool value)async{
                          if(value){
                            AnalyticsHelper().log(AnalyticsEvents.PasswordPg_TurnOnThePass_Switch_Clk);
                            Timer(Duration(milliseconds: 100),(){
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 500),
                                      child: SetPassScreen(

                                      )
                                  )
                              );
                            });
                          }else{
                            AnalyticsHelper().log(AnalyticsEvents.PasswordPg_TurnOffThePass_Switch_Clk);
                            setState(() {
                              active= value;
                            });
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.remove('pass');
                            prefs.remove('fingerPrint');
                          }
                        },
                      )
                  ) ,
                ),
//              onPressEdit: (){
//                onPressEdit();
//              },
                bottomMargin: 0,
                topMargin: 60,
                obscureText: false,
                keyboardType: TextInputType.number,
              ),
              active ? Flexible(
                  child:   Column(
                    children: <Widget>[
                      TextFieldArea(
                        label: 'تغییر رمز قفل',
                        textController: changePassController,
                        readOnly: true,
                        editBox: true,
                        textColor: ColorPallet().black,
                        icon: 'assets/images/ic_arrow_back.svg',
                        bottomMargin: 0,
                        topMargin: 60,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                        onPressEdit: (){
                          AnalyticsHelper().log(AnalyticsEvents.PasswordPg_EditPass_Btn_Clk);
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 500),
                                  child: SetPassScreen(

                                  )
                              )
                          );
                        },
                      ),
                      isShowFingerPrint ?
                      TextFieldArea(
                        label: 'ورود با اثر انگشت',
                        textController: fingerPrintController,
                        readOnly: true,
                        editBox: false,
                        textColor: ColorPallet().black,
                        isActivePass:  Padding(
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(25)
                          ),
                          child: Transform.scale(
                              scale: ScreenUtil().setWidth(1.55),
                              child:  CupertinoSwitch(
                                value: fingerActive,
                                trackColor: ColorPallet().gray.withOpacity(0.5),
                                activeColor: ColorPallet().mainColor,
                                onChanged: (bool value)async{
                                  setState(() {
                                    fingerActive= value;
                                  });
                                  setFingerPrint(value);
                                },
                              )
                          ) ,
                        ),
                        bottomMargin: 0,
                        topMargin: 60,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                      )
                          :  Container()
                    ],
                  )
              )
                  :  Container()
            ],
          ),
        ),
      ),
    );
  }


  checkSetPassword()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString('pass') != null){
      setState(() {
//        passController =  TextEditingController(text: 'فعال');
        active = true;
      });
    }else{
      setState(() {
//        passController =  TextEditingController(text: 'غیر فعال');
        active = false;
      });
    }
  }

  onPressEdit()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!active){
      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
              child: SetPassScreen(

              )
          )
      );
    }else{
      prefs.remove('pass');

      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
              child: BlankScreen(
                indexTab: 5,
              )
          )
      );

    }

  }


  setFingerPrint(bool value)async{
    // print(value);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(value){
      AnalyticsHelper().log(AnalyticsEvents.PasswordPg_TurnOnTheFinger_Switch_Clk);
      prefs.setBool('fingerPrint', true);
    }else{
      AnalyticsHelper().log(AnalyticsEvents.PasswordPg_TurnOffTheFinger_Switch_Clk);
      prefs.setBool('fingerPrint', false);
    }

  }




}