

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/register_presenter.dart';
import 'package:impo/src/architecture/view/register_view.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/item_phone_or_number.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:impo/src/components/text_field_area.dart';
import 'package:get/get.dart';
import 'package:impo/src/screens/LoginAndRegister/identity/forgot_password_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../../../firebase_analytics_helper.dart';


class LoginScreen extends StatefulWidget{
  final phoneOrEmail;
  final isBack;

  LoginScreen({Key? key,this.phoneOrEmail,this.isBack}):super(key:key);

  @override
  State<StatefulWidget> createState() => LoginScreenState();

}

class LoginScreenState extends State<LoginScreen>with TickerProviderStateMixin implements RegisterView{

  late RegisterPresenter _presenter;

  Animations _animations =  Animations();

  late AnimationController animationControllerScaleSendButton;

  LoginScreenState(){
    _presenter = RegisterPresenter(this);
  }

//  TextEditingController userNameController;
  late TextEditingController passwordController;
//  ScrollController scrollController;

  late TextEditingController controller;
  late ScrollController scrollController;


  int modePress = 0;
  bool isKeyBoard = false;
  bool _obscureText = true;

  late FocusNode _focusNode;

  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.LoginPg_Self_Pg_Load);
    initTypeValue();
    passwordController =  TextEditingController();
    _focusNode = FocusNode();
    checkPhoneOrEmail();
    scrollController = ScrollController();
    animationControllerScaleSendButton = _animations.pressButton(this);
    _animations.shakeError(this);
    checkVisibilityKeyBoard();
    super.initState();
  }

  checkPhoneOrEmail(){
    if(widget.phoneOrEmail != null){
      if(widget.phoneOrEmail.toString().startsWith("0")){
        setState(() {
          typeValue =0;
        });
      }else{
        setState(() {
          typeValue =1;
        });
      }
      controller = TextEditingController(text: widget.phoneOrEmail);
    }else{
      controller = TextEditingController();
    }
  }

  initTypeValue(){
    if(itemsPhoneNumberOrPhone[0].selected!){
      setState(() {
        typeValue = 0;
      });
    }else{
      setState(() {
        typeValue = 1;
      });
    }
    // print(itemsPhoneNumberOrPhone[1].selected);
  }

  checkVisibilityKeyBoard(){
    KeyboardVisibilityController().onChange.listen((bool visible) {
      if(mounted){
        if(visible){
          setState(() {
            isKeyBoard = true;
          });
          Timer(Duration(milliseconds: 50),(){
            scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500),curve: Curves.ease);
          });
        }else{
          setState(() {
            isKeyBoard = false;
          });
        }
      }
    });
  }

  Future<bool> _onWillPop()async{
    if(widget.isBack != null){
      return Future.value(false);
    }else{
      AnalyticsHelper().log(AnalyticsEvents.LoginPg_Back_NavBar_Clk);
      return Future.value(true);
    }
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
            body:  Stack(
              children: <Widget>[
                 SingleChildScrollView(
                  controller: scrollController,
                  child:  Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(55)
                            ),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                 StreamBuilder(
                                  stream: _animations.squareScaleBackButtonObserve,
                                  builder: (context,AsyncSnapshot<double>snapshotScale){
                                    if(snapshotScale.data != null){
                                      return  Transform.scale(
                                          scale: modePress == 0 ? typeValue == 0 ? snapshotScale.data : 1.0 : 1.0,
                                          child: itemPhoneNumberOrEmail(0)
                                      );
                                    }else{
                                      return  Container();
                                    }
                                  },
                                ),
                                 Text(
                                  'یا',
                                     style:  context.textTheme.labelLarge
                                ),
                                 StreamBuilder(
                                  stream: _animations.squareScaleBackButtonObserve,
                                  builder: (context,AsyncSnapshot<double>snapshotScale){
                                    if(snapshotScale.data != null){
                                      return  Transform.scale(
                                          scale: modePress == 0 ? typeValue == 1 ? snapshotScale.data : 1.0 : 1.0,
                                          child: itemPhoneNumberOrEmail(1)
                                      );
                                    }else{
                                      return  Container();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                           Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextFieldArea(
                                  label: typeValue == 0 ?  'شماره تلفن همراه' : 'ایمیل',
                                  textController: controller,
                                  readOnly: false,
                                  editBox: false,
                                  bottomMargin: 0,
                                  topMargin: 60,
                                  obscureText: false,
                                  keyboardType: typeValue == 0 ? TextInputType.phone : TextInputType.emailAddress,
                                  notFlex: true,
                                  isEmail: typeValue == 0 ? null : true,
                                  focusNode: _focusNode,
                                  icon: typeValue == 0 ? 'assets/images/ic_mobile.svg' : 'assets/images/ic_gray_email.svg',
                                  inputFormatters: typeValue == 0 ? <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                  ] : null
                              ),
                              TextFieldArea(
                                notFlex: true,
                                label: 'رمز عبور',
                                textController: passwordController,
                                readOnly: false,
                                editBox: false,
                                icon: 'assets/images/ic_cheshm.svg',
                                bottomMargin: 10,
                                topMargin: 30,
                                obscureText: _obscureText,
                                onHoldObscureText: (){
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                keyboardType: TextInputType.text,
                                maxLength: 30,
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
                                                          margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(65)),
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
                               Padding(
                                  padding: EdgeInsets.only(
                                      top: ScreenUtil().setWidth(10),
                                      right: ScreenUtil().setWidth(55),
                                      left: ScreenUtil().setWidth(55)
                                  ),
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                       StreamBuilder(
                                        stream: _presenter.isLoadingObserve,
                                        builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                                          if(snapshotIsLoading.data != null){
                                            if(!snapshotIsLoading.data!){
                                              return  CustomButton(
                                                title: 'ورود به ایمپو',
                                                onPress: (){
                                                  _presenter.onPressEnterAccount(controller.text,passwordController.text,context,_animations);
                                                },
                                                margin: 10,
                                                colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                                                borderRadius: 10.0,
                                                enableButton: true,
                                              );
                                            }else{
                                              return  Center(
                                                child:  LoadingViewScreen(color: ColorPallet().mainColor,)
                                              );
                                            }
                                          }else{
                                            return  Container();
                                          }
                                        },
                                      ),
                                       StreamBuilder(
                                        stream: _animations.squareScaleBackButtonObserve,
                                        builder: (context,AsyncSnapshot<double>snapshotDialogScale){
                                          if(snapshotDialogScale.data != null){
                                            return  Transform.scale(
                                              scale: modePress == 1 ? snapshotDialogScale.data : 1.0,
                                              child:  GestureDetector(
                                                onTap: ()async{
                                                  setState(() {
                                                    modePress = 1;
                                                  });
                                                  await animationControllerScaleSendButton.reverse();
                                                  AnalyticsHelper().log(AnalyticsEvents.LoginPg_ForgotPassword_Text_Clk);
                                                  Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          type: PageTransitionType.fade,
                                                          duration: Duration(milliseconds: 500),
                                                          child:  ForgotPasswordScreen(
                                                            userName: controller.text,
                                                            isBack: true,
                                                          )
                                                      )
                                                  );
                                                },
                                                child:  Text(
                                                  'رمز عبور رو فراموش کردم',
                                                  style:  context.textTheme.labelMedium!.copyWith(
                                                    color: ColorPallet().gray,
                                                  )
                                                ),
                                              ),
                                            );
                                          }else{
                                            return  Container();
                                          }
                                        },
                                      )
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ],
                      ),


                ),
                !isKeyBoard ?
                 Align(
                  alignment: Alignment.bottomCenter,
                  child:   Padding(
                      padding: EdgeInsets.only(
                          bottom: ScreenUtil().setWidth(60)
                      ),
                      child:    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                           Text(
                            'important',
                            style:  TextStyle(
                                color: ColorPallet().mainColor,
                                fontSize: ScreenUtil().setSp(50),
                                fontWeight: FontWeight.bold
                            ),
                          ),
                           SizedBox(width: ScreenUtil().setWidth(15)),
                           Text(
                            'i am',
                            style:  TextStyle(
                                color: Color(0xff707070),
                                fontSize: ScreenUtil().setSp(50),
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      )
                  )
                )
                    :  Container(),
              ],
            )
        ),
      )
    );
  }

  itemPhoneNumberOrEmail(int _typeValue){
    return  GestureDetector(
      onTap: ()async{
        setState(() {
          modePress = 0;
        });
        animationControllerScaleSendButton.reverse();
        FocusScope.of(context).unfocus();
        controller.clear();
        setState(() {
          typeValue = _typeValue;
          for(int i=0 ; i<itemsPhoneNumberOrPhone.length ; i++){
            itemsPhoneNumberOrPhone[i].selected = false;
          }
          itemsPhoneNumberOrPhone[_typeValue].selected = !itemsPhoneNumberOrPhone[_typeValue].selected!;
          Timer(Duration(milliseconds:50),(){
            _focusNode.requestFocus();
          });
        });
        if(_typeValue == 0){
          AnalyticsHelper().log(AnalyticsEvents.LoginPg_Phone_Btn_Clk);
        }else{
          AnalyticsHelper().log(AnalyticsEvents.LoginPg_Email_Btn_Clk);
        }
      },
      child:  Container(
        width: MediaQuery.of(context).size.width / 2.75,
        padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setWidth(18),
//          horizontal: ScreenUtil().setWidth(60)
        ),
        decoration:  BoxDecoration(
            color: itemsPhoneNumberOrPhone[_typeValue].selected! ? ColorPallet().mainColor : Colors.white,
            border: Border.all(
                color: ColorPallet().mainColor,
                width: 1
            ),
            borderRadius: BorderRadius.circular(20)
        ),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              itemsPhoneNumberOrPhone[_typeValue].icon!,
              width: _typeValue == 0 ? ScreenUtil().setWidth(35) :  ScreenUtil().setWidth(30) ,
              height: _typeValue == 0 ? ScreenUtil().setWidth(35) :  ScreenUtil().setWidth(30),
              fit: BoxFit.fitWidth,
              colorFilter: ColorFilter.mode(
                  itemsPhoneNumberOrPhone[_typeValue].selected!? Colors.white : ColorPallet().mainColor,
                  BlendMode.srcIn
              ),
              // fit: BoxFit.fitWidth
            ),
            SizedBox(width: ScreenUtil().setWidth(20)),
            Text(
                itemsPhoneNumberOrPhone[_typeValue].title!,
                style: context.textTheme.labelMedium!.copyWith(
                    color: itemsPhoneNumberOrPhone[_typeValue].selected! ?
                    Colors.white : ColorPallet().mainColor
                )
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onError(msg) {

  }

  @override
  void onSuccess(msg){

  }

}