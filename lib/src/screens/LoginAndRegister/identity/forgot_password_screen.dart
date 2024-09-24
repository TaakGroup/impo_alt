

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

import '../../../firebase_analytics_helper.dart';


class ForgotPasswordScreen extends StatefulWidget {

  final userName;
  final isBack;

  ForgotPasswordScreen({Key? key,this.userName,this.isBack}):super(key:key);

  @override
  State<StatefulWidget> createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> with TickerProviderStateMixin implements RegisterView{

  late RegisterPresenter _presenter;

  Animations _animations =  Animations();
  late AnimationController animationControllerScaleSendButton;



  ForgotPasswordScreenState(){
    _presenter = RegisterPresenter(this);
  }

  late TextEditingController controller;
  late ScrollController scrollController;
  late FocusNode _focusNode;


  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.ForgotPasswordPg_Self_Pg_Load);
    initTypeValue();
    checkVisibilityKeyBoard();
    scrollController =  ScrollController();
    controller =  TextEditingController(text: widget.userName);
    animationControllerScaleSendButton = _animations.pressButton(this);
    _animations.shakeError(this);
    _presenter.initialDialogScale(this);
    _focusNode = FocusNode();
    super.initState();
  }

  checkVisibilityKeyBoard(){
    KeyboardVisibilityController().onChange.listen((bool visible) {
      if(mounted){
        if(visible){
          Timer(Duration(milliseconds: 50),(){
//            print( scrollController.position.maxScrollExtent);
              if(scrollController.hasClients){
                scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500),curve: Curves.ease);
              }
          });
        }
      }
    });
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
  }

  
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop()async{
    if(widget.isBack){
      AnalyticsHelper().log(AnalyticsEvents.ForgotPasswordPg_Back_NavBar_Clk);
      return Future.value(true);
    }else{
      return Future.value(false);
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
            body: SingleChildScrollView(
                controller: scrollController,
                child:  Column(
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
                        bottom: ScreenUtil().setWidth(100),
                        right: ScreenUtil().setWidth(50),
                        left: ScreenUtil().setWidth(50),
                      ),
                      child:   Text(
                         widget.isBack ? 'ایمپویی عزیز، برای بازگردانی حساب کاربری،\nشماره یا ایمیل خودت رو وارد کن' : 'ایمپویی عزیز مثل اینکه رمز عبورت تغییر کرده\nبرای همین با این دستگاه باید دوباره رمزتو بسازی\nتا اطلاعاتت خودکار ذخیره بشه و مشکلی پیش نیاد',
                        textAlign: TextAlign.center,
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: ColorPallet().gray
                          )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(55)
                      ),
                      child:  Row(
                        mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          StreamBuilder(
                            stream: _animations.squareScaleBackButtonObserve,
                            builder: (context,AsyncSnapshot<double>snapshotScale){
                              if(snapshotScale.data != null){
                                return  Transform.scale(
                                    scale: typeValue == 0 ? snapshotScale.data : 1.0,
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
                                    scale: typeValue == 1 ? snapshotScale.data : 1.0,
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
                    TextFieldArea(
                        label: typeValue == 0 ?  'شماره تلفن همراه' : 'ایمیل',
                        textController: controller,
                        isEmail: typeValue == 0 ? null : true,
                        readOnly: false,
                        editBox: false,
                        bottomMargin: 0,
                        topMargin: 60,
                        obscureText: false,
                        keyboardType: typeValue == 0 ? TextInputType.phone : TextInputType.emailAddress,
                        notFlex: true,
                        focusNode: _focusNode,
                        icon: typeValue == 0 ? 'assets/images/ic_mobile.svg' : 'assets/images/ic_gray_email.svg',
                        inputFormatters: typeValue == 0 ? <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ] : null
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
                                                margin: EdgeInsets.symmetric(horizontal: 35.0),
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
                    StreamBuilder(
                      stream: _presenter.isLoadingObserve,
                      builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                        if(snapshotIsLoading.data != null){
                          if(!snapshotIsLoading.data!){
                            return  Padding(
                              padding: EdgeInsets.only(
                                top: ScreenUtil().setWidth(150),

                              ),
                              child:  CustomButton(
                                title: 'ادامه',
                                onPress: (){
                                  _presenter.onPressForgotPassword(controller.text, _animations, context,widget.isBack ? false : true);
                                },
                                colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                                borderRadius: 10.0,
                                enableButton: true,
                              ),
                            );
                          }else{
                            return  Padding(
                              padding: EdgeInsets.only(
                                top: ScreenUtil().setWidth(100),
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
                  ],
                ),
            ),
        ),
      )
    );
  }

  itemPhoneNumberOrEmail(int _typeValue){
    return  GestureDetector(
      onTap: ()async{
        animationControllerScaleSendButton.reverse();
        FocusScope.of(context).unfocus();
        Timer(Duration(milliseconds: 50),(){
          _focusNode.requestFocus();
          controller.clear();
        });
        setState(() {
          typeValue = _typeValue;
          for(int i=0 ; i<itemsPhoneNumberOrPhone.length ; i++){
            itemsPhoneNumberOrPhone[i].selected = false;
          }
          itemsPhoneNumberOrPhone[_typeValue].selected = !itemsPhoneNumberOrPhone[_typeValue].selected!;
        });
        if(_typeValue == 0){
          AnalyticsHelper().log(AnalyticsEvents.ForgotPasswordPg_Phone_Btn_Clk);
        }else{
          AnalyticsHelper().log(AnalyticsEvents.ForgotPasswordPg_Email_Btn_Clk);
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
                itemsPhoneNumberOrPhone[_typeValue].selected! ? Colors.white : ColorPallet().mainColor,
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