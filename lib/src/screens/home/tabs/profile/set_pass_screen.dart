
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/profile_presenter.dart';
import 'package:impo/src/architecture/view/profile_view.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/text_field_area.dart';
import 'package:get/get.dart';
import 'package:impo/src/screens/home/tabs/profile/password_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../firebase_analytics_helper.dart';

class SetPassScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SetPassScreenState();

}

class SetPassScreenState extends State<SetPassScreen> with TickerProviderStateMixin implements ProfileView{

  late ProfilePresenter _presenter;

  SetPassScreenState(){
    _presenter = ProfilePresenter(this);
  }

  late TextEditingController passController;
  late TextEditingController repeatPassController;
  late ScrollController scrollController;


  Animations _animations =  Animations();

  bool visibilityKeyBoard = false;

  @override
  void initState() {
    passController = TextEditingController(text: '');
    repeatPassController = TextEditingController(text: '');
    _animations.shakeError(this);
    scrollController = ScrollController();
    checkVisibilityKeyBoard();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  checkVisibilityKeyBoard(){
    KeyboardVisibilityController().onChange.listen((bool visible) {
      if(mounted){
        if(visible){
          Timer(Duration(milliseconds: 50),(){

            scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500),curve: Curves.ease);
          });
        }
      }
    });
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.SetPassPg_Back_NavBar_Clk);
    Navigator.pushReplacement(
      context,
      PageTransition(
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 500),
          child:  PasswordScreen()
      ),
    );
    return Future.value(false);
  }


  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return  WillPopScope(
      onWillPop: _onWillPop,
      child:  Directionality(
        textDirection: TextDirection.rtl,
        child:  Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            body:  SingleChildScrollView(
              controller: scrollController,
              child:  Column(
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
                        AnalyticsHelper().log(AnalyticsEvents.SetPassPg_Back_Btn_Clk);
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              duration: Duration(milliseconds: 500),
                              child:  PasswordScreen()
                          ),
                        );
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
                            style:  context.textTheme.headlineMedium!.copyWith(
                                color: ColorPallet().gray
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(30)),
                  Text(
                    'یک رمز 4 رقمی برای ورود به اپلیکیشن انتخاب کن',
                    style:  context.textTheme.bodyMedium!.copyWith(
                      color: ColorPallet().gray,
                    ),
                  ),
                  TextFieldArea(
                      notFlex: true,
                      label: 'رمز قفل',
                      textController: passController,
                      readOnly: false,
                      editBox: false,
                      icon: 'assets/images/ic_myimpo_pass.svg',
                      maxLength: 4,
                      bottomMargin: 0,
                      topMargin: 60,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ]
                  ),
                  TextFieldArea(
                      notFlex: true,
                      label: 'تکرار رمز قفل',
                      textController: repeatPassController,
                      readOnly: false,
                      editBox: false,
                      icon: 'assets/images/ic_myimpo_pass.svg',
                      maxLength: 4,
                      bottomMargin: 0,
                      topMargin: 60,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ]
                  ),
                   Align(
                    alignment: Alignment.centerRight,
                    child:  Padding(
                      padding: EdgeInsets.only(
                          top: ScreenUtil().setWidth(15)
                      ),
                      child: AnimatedBuilder(
                          animation: _animations.animationShakeError,
                          builder: (buildContext, child) {
                            if (_animations.animationShakeError.value < 0.0) print('${_animations.animationShakeError.value + 8.0}');
                            return  StreamBuilder(
                              stream: _animations.isShowErrorObserve,
                              builder: (context,AsyncSnapshot<bool> snapshot){
                                if(snapshot.data != null){
                                  if(snapshot.data!){
                                    return  StreamBuilder(
                                        stream: _animations.errorTextObserve,
                                        builder: (context,AsyncSnapshot<String>snapshot){
                                          return Container(
                                              margin: EdgeInsets.symmetric(horizontal: 40.0),
                                              padding: EdgeInsets.only(left: _animations.animationShakeError.value + 4.0, right: 4.0 -_animations.animationShakeError.value),
                                              child: Text(
                                                snapshot.data != null ? snapshot.data! : '',
                                                style:  context.textTheme.bodySmall!.copyWith(
                                                  color: Color(0xffEE5858),
                                                ),
                                              )
                                          );
                                        }
                                    );
                                  }else {
                                    return  Opacity(
                                      opacity: 0.0,
                                      child:  Container(
                                        child:  Text(''),
                                      ),
                                    );
                                  }
                                }else{
                                  return  Opacity(
                                    opacity: 0.0,
                                    child:  Container(
                                      child:  Text(''),
                                    ),
                                  );
                                }
                              },
                            );
                          }),
                    ),
                  ),
                   Padding(
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setWidth(80),
                        bottom: ScreenUtil().setWidth(30)
                    ),
                    child:    CustomButton(
                      title: 'ثبت رمز',
                      onPress: (){
                        AnalyticsHelper().log(AnalyticsEvents.SetPassPg_PasswordRegistration_Btn_Clk);
                        _presenter.onPressSetPass(passController.text,repeatPassController.text);
                      },
                      colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                      enableButton: true,
                    ),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }



  @override
  void onError(msg) {
    _animations.showShakeError(msg);
  }

  @override
  void onSuccess(pass)async{
    _animations.isErrorShow.sink.add(false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('pass',pass);

    Timer(Duration(milliseconds: 50),(){
     Navigator.pushReplacement(
       context,
       PageTransition(
         type: PageTransitionType.fade,
         duration: Duration(milliseconds: 500),
         child:  PasswordScreen()
       ),
     );
    });


  }

}