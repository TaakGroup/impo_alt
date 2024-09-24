
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
import 'package:get/get.dart';
import 'package:impo/src/screens/LoginAndRegister/globalRegister/name_register_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../../../firebase_analytics_helper.dart';

class VerifyCodeScreen extends StatefulWidget{

  final phoneOrEmail;
  final typeValue;
  final isRegister;
  final onlyLogin;

  VerifyCodeScreen({Key? key,this.phoneOrEmail,this.typeValue,this.isRegister,this.onlyLogin}):super(key:key);

  @override
  State<StatefulWidget> createState() => VerifyCodeScreenState();
}

class VerifyCodeScreenState extends State<VerifyCodeScreen> with TickerProviderStateMixin implements RegisterView{

  late RegisterPresenter _presenter;

  VerifyCodeScreenState(){
    _presenter = RegisterPresenter(this);
  }

  late ScrollController scrollController;
  late TextEditingController numberController;
  late TextEditingController controller1;
  late TextEditingController controller2;
  late TextEditingController controller3;
  late TextEditingController controller4;
  late TextEditingController controller5;
  late TextEditingController controller6;

  String number = '' ;

  Animations _animations = new Animations();


  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.VerifyCodePg_Self_Pg_Load);
    numberController = new TextEditingController();
    scrollController = new ScrollController();
    controller1 = new TextEditingController();
    controller2 = new TextEditingController();
    controller3 = new TextEditingController();
    controller4 = new TextEditingController();
    controller5 = new TextEditingController();
    controller6 = new TextEditingController();
    _presenter.initialDialogScale(this);
    _animations.shakeError(this);
    checkVisibilityKeyBoard();
    super.initState();
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

  // Widget _flightShuttleBuilder(
  //     BuildContext flightContext,
  //     Animation<double> animation,
  //     HeroFlightDirection flightDirection,
  //     BuildContext fromHeroContext,
  //     BuildContext toHeroContext,
  //     ) {
  //   return DefaultTextStyle(
  //     style: DefaultTextStyle.of(toHeroContext).style,
  //     child: toHeroContext.widget,
  //     textAlign: TextAlign.right,
  //   );
  // }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.VerifyCodePg_Back_NavBar_Clk);
      return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child:  Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              controller: scrollController,
              child:    Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(30)
                    ),
                    child: Text(
                      'دوست عزیزم کد ارسال شده به ${widget.typeValue == 0 ? 'شماره تلفن ${widget.phoneOrEmail}' : 'ایمیل${widget.phoneOrEmail}'} را در این قسمت وارد کنید',
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyMedium!.copyWith(
                        height: 1.8
                      )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: ScreenUtil().setWidth(50),
                      left: ScreenUtil().setWidth(50),
                      top: ScreenUtil().setWidth(80),
                    ),
                    child:  Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width - ScreenUtil().setWidth(80),
                          height: ScreenUtil().setWidth(50),
                          child:  ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 6,
                            separatorBuilder: (context,index){
                              return  Container(
                                height: ScreenUtil().setHeight(50),
                                width: ScreenUtil().setWidth(2),
                                color: ColorPallet().gray.withOpacity(0.6),
                              );
                            },
                            itemBuilder: (context,index){
                              return  Container(
                                  width: (MediaQuery.of(context).size.width - ScreenUtil().setWidth(30))/7,
                                  child:  Center(
                                      child:  Theme(
                                          data: Theme.of(context).copyWith(
                                            textSelectionTheme: TextSelectionThemeData(
                                                selectionColor: Color(0xffaaaaaa),
                                                cursorColor: ColorPallet().mainColor
                                            ),
                                          ),
                                          child: TextField(
                                            controller: index == 0 ? controller6 : index == 1 ? controller5 : index == 2 ? controller4 : index == 3 ? controller3 : index == 4 ? controller2 : controller1,
                                            textAlign: TextAlign.center,
                                            maxLength: 1,
                                            style: context.textTheme.titleSmall!.copyWith(
                                              color: ColorPallet().mainColor,
                                            ),
                                            decoration:  InputDecoration(
                                              border: InputBorder.none,
                                              counterText: '',
                                              // contentPadding: EdgeInsets.only(
                                              //   bottom: ScreenUtil().setWidth(15),
                                              // ),
                                            ),
                                          )
                                      )
                                  )
                              );
                            },
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            textSelectionTheme: TextSelectionThemeData(
                                selectionColor: Color(0xffaaaaaa),
                                cursorColor: ColorPallet().mainColor
                            ),
                          ),
                          child:  TextField(
                            controller: numberController,
                            onChanged: (value){
                              onChange(value);
                            },
                            onSubmitted: (v){
                            },
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            textDirection: TextDirection.ltr,
                            showCursor: false,
                            style:  TextStyle(
                              color: ColorPallet().mainColor,
                              fontSize: ScreenUtil().setSp(0),
                            ),
                            decoration:  InputDecoration(
                              counterText: '',
                              labelText: 'کد تایید',
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                    color: ColorPallet().gray
                                ),
                              ),
                              enabledBorder:  OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                    color: ColorPallet().gray
                                ),
                              ),
                              labelStyle: context.textTheme.labelMedium,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(
                                    color: ColorPallet().gray
                                ),
                              ),
                              contentPadding: EdgeInsets.only(
//                    bottom: ScreenUtil().setWidth(30),
//                              top: ScreenUtil().setWidth(0),
                                  right: ScreenUtil().setWidth(0),
                                  left:  ScreenUtil().setWidth(0)
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
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
                                                  style: context.textTheme.bodySmall!.copyWith(
                                                    color: Color(0xffEE5858),
                                                  )
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
                        top: ScreenUtil().setWidth(150),
                      ),
                      child:  StreamBuilder(
                        stream: _presenter.isLoadingObserve,
                        builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                          if(snapshotIsLoading.data != null){
                            if(!snapshotIsLoading.data!){
                              return  CustomButton(
                                title: 'ادامه',
                                onPress: (){
                                  // Navigator.push(
                                  //     context,
                                  //     PageTransition(
                                  //         type: PageTransitionType.fade,
                                  //         child:  NameRegisterScreen(
                                  //           phoneOrEmail: "09666666666",
                                  //         )
                                  //     )
                                  // );
                                   onPressAccept();
                                },
                                colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                                borderRadius: 10.0,
                                enableButton: true,
                              );
                            }else{
                              return  LoadingViewScreen(
                                  color: ColorPallet().mainColor
                              );
                            }
                          }else{
                            return  Container();
                          }
                        },
                      )
                  )
                ],
              ),
            ),
            bottomNavigationBar:  Padding(
              padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(70)),
              child: BottomTextRegister(),
            )
        ),
      ),
    );
  }

  onChange(String value){

//    print(numberController.text.length);
//    print(number.length);

    if(numberController.text.length >= number.length){
//      print('add');
      if(numberController.text.length <= 6){
        setState(() {
          if(numberController.text.length == 1){
            controller1.text = numberController.text.substring(0);
          }else if(numberController.text.length == 2){
            controller2.text = numberController.text.substring(1);
          }else if(numberController.text.length == 3){
            controller3.text = numberController.text.substring(2);
          }else if(numberController.text.length == 4){
            controller4.text = numberController.text.substring(3);
          }else if(numberController.text.length == 5){
            controller5.text = numberController.text.substring(4);
          }else if(numberController.text.length == 6){
            controller6.text = numberController.text.substring(5);
          }

        });
      }

    }else{
//      print('del');
      setState(() {
        if(numberController.text.length == 5){
          controller6.text = '';
        }else if(numberController.text.length == 4){
          controller5.text = '';
        }else if(numberController.text.length == 3){
          controller4.text = '';
        }else if(numberController.text.length == 2){
          controller3.text = '';
        }else if(numberController.text.length == 1){
          controller2.text = '';
        }else if(numberController.text.length == 0){
          controller1.text = '';
        }

      });
    }

    setState(() {
      number = numberController.text;
    });



//  print(numberController.text);

  }

  onPressAccept(){
    _animations.isErrorShow.sink.add(false);
    if(numberController.text.length == 6){

      AnalyticsHelper().log(AnalyticsEvents.VerifyCodePg_VerifyCode_Btn_Clk,parameters: {'code' :numberController.text});
      if(widget.isRegister){
        _presenter.validateIdentity(widget.phoneOrEmail, context, _animations, numberController.text);
      }else{
        _presenter.validateForForgot(widget.phoneOrEmail, context, _animations, numberController.text,widget.onlyLogin);
      }

    }else{
      _animations.showShakeError('کد وارد شده صحیح نیست');
    }
  }


  @override
  void onError(msg) {

  }

  @override
  void onSuccess(msg){

  }

}