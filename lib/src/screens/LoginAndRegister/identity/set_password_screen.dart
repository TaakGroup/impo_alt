


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/register_presenter.dart';
import 'package:impo/src/architecture/view/register_view.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/bottom_text_register.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:impo/src/components/text_field_area.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:string_validator/string_validator.dart';

import '../../../firebase_analytics_helper.dart';

class SetPasswordScreen extends StatefulWidget{

  final phoneOrEmail;
  // final interfaceCode;
  // final RegisterParamViewModel registerParamViewModel;
  final isRegister;
  final onlyLogin;

  SetPasswordScreen({Key? key,this.phoneOrEmail,this.isRegister,this.onlyLogin}):super(key:key);

  @override
  State<StatefulWidget> createState() => SetPasswordScreenState();

}

class SetPasswordScreenState extends State<SetPasswordScreen> with TickerProviderStateMixin implements RegisterView{


  late RegisterPresenter _presenter;

  SetPasswordScreenState(){
    _presenter = RegisterPresenter(this);
  }


  late TextEditingController passController;
  late TextEditingController repeatPassController;
  late ScrollController scrollController;


  Animations _animations =  Animations();

  bool visibilityKeyBoard = false;

  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.SetPasswordPg_Self_Pg_Load);
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
    AnalyticsHelper().log(AnalyticsEvents.SetPasswordPg_Back_NavBar_Clk);
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
            resizeToAvoidBottomInset: true,
            body:  SingleChildScrollView(
                controller: scrollController,
                child:                  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
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
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil().setWidth(10),
                        right: ScreenUtil().setWidth(50),
                        left: ScreenUtil().setWidth(50),
                      ),
                      child:   Text(
                        'دوست عزیزم رمز عبور شما برای ورود به اپلیکیشن باید ترکیبی از حروف و عدد و حداقل 5 کارکتر باشد',
                        textAlign: TextAlign.center,
                          style: context.textTheme.labelLarge
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(100)),
                    TextFieldArea(
                      notFlex: true,
                      label: 'رمز عبور',
                      textController: passController,
                      readOnly: false,
                      editBox: false,
                      icon: 'assets/images/ic_pass.svg',
                      bottomMargin: 0,
                      topMargin: 0,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      maxLength: 30,
                    ),
                    TextFieldArea(
                      maxLength: 30,
                      notFlex: true,
                      label: 'تکرار رمز عبور',
                      textController: repeatPassController,
                      readOnly: false,
                      editBox: false,
                      icon: 'assets/images/ic_pass.svg',
                      bottomMargin: 0,
                      topMargin: 50,
                      obscureText: true,
                      keyboardType: TextInputType.text,
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
                                                margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(60)),
                                                padding: EdgeInsets.only(left: _animations.animationShakeError.value + 4.0, right: 4.0 -_animations.animationShakeError.value),
                                                child: Text(
                                                  snapshot.data != null ? snapshot.data! : '',
                                                  style:  TextStyle(
                                                      color: Color(0xffEE5858),
                                                      fontSize: ScreenUtil().setWidth(28)
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
                    Align(
                      alignment: Alignment.center,
                      child:  StreamBuilder(
                        stream: _presenter.isLoadingObserve,
                        builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                          if(snapshotIsLoading.data != null){
                            if(!snapshotIsLoading.data!){
                              return  Padding(
                                padding: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(30),
                                    bottom: ScreenUtil().setWidth(30)
                                ),
                                child:  CustomButton(
                                  title: 'ثبت نام',
                                  onPress: (){
                                    onPressAccept();
                                    // _presenter.enterName(nameController.text);
                                  },
                                  colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                                  borderRadius: 10.0,
                                  enableButton: true,
                                ),
                              );
                            }else{
                              return  Padding(
                                padding: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(30),
                                    bottom: ScreenUtil().setWidth(30)
                                ),
                                child:  LoadingViewScreen(
                                    color: ColorPallet().mainColor
                                ),
                              );
                            }
                          }else{
                            return  Container();
                          }
                        },
                      ),
                    )
                  ],
                ),
            ),
            bottomNavigationBar:  Padding(
              padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
              child: BottomTextRegister(),
            )
        ),
      ),
    );
  }

  onPressAccept(){
    _animations.isErrorShow.sink.add(false);

    if(passController.text.length != 0 || repeatPassController.text.length != 0){

      if(passController.text == repeatPassController.text){

        if(passController.text.length >= 5){

          if(!isNumeric(passController.text) && !isAlpha(passController.text)){

            AnalyticsHelper().log(AnalyticsEvents.SetPasswordPg_Reg_Btn_Clk);
            if(widget.isRegister){
              _presenter.sendRegister(_animations, widget.phoneOrEmail, passController.text,context);
            }else{
              _presenter.forgot(widget.phoneOrEmail, passController.text, context, _animations,widget.onlyLogin);
            }

          }else{
            _animations.showShakeError('رمز عبور باید ترکیبی از حرف و عدد باشد');

          }

        }else{

          _animations.showShakeError('رمز عبور نباید کمتر از ۵ رقم باشد');

        }

      }else{

        _animations.showShakeError('رمز ورود و تایید رمز ورود متفاوت هستند!');

      }

    }else{

      _animations.showShakeError('رمز عبور نباید کمتر از ۵ رقم باشد');

    }

  }

  @override
  void onError(msg) {

  }

  @override
  void onSuccess(msg){

  }



}