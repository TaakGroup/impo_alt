

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/register_presenter.dart';
import 'package:impo/src/architecture/view/register_view.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/bottom_text_register.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/dialogs/check_version_dialog.dart';
import 'package:impo/src/components/dialogs/exit_app_dialog.dart';
import 'package:impo/src/components/dialogs/qus_dialog.dart';
import 'package:impo/src/components/item_phone_or_number.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:impo/src/components/text_field_area.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:string_validator/string_validator.dart';
import 'package:impo/src/singleton/payload.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import '../../../firebase_analytics_helper.dart';

class EnterNumberScreen extends StatefulWidget{
  final value;
  EnterNumberScreen({Key? key,this.value}):super(key:key);
  @override
  State<StatefulWidget> createState() => EnterNumberScreenState();
}

class EnterNumberScreenState extends State<EnterNumberScreen> with TickerProviderStateMixin implements RegisterView{

  late RegisterPresenter _presenter;

  ExitAppDialog exitAppDialog = new ExitAppDialog();

  CheckVersionDialog checkVersionDialog = new CheckVersionDialog();

  EnterNumberScreenState(){
    _presenter = RegisterPresenter(this);
  }

  Animations _animations = new Animations();

  late AnimationController _animationController;

  late TextEditingController controller;
  late ScrollController scrollController;
  late TapGestureRecognizer _tapGestureRecognizer;

  late FocusNode _focusNode;

  // String country ='';

  @override
  void initState() {
    // checkCountry();
    checkPayload();
    initUserName();
    initTypeValue();
    _focusNode = FocusNode();
    scrollController = ScrollController();
    checkVisibilityKeyBoard();
    _animations.shakeError(this);
    _animationController = _animations.pressButton(this);
    _presenter.initialDialogScale(this);
    exitAppDialog.initialDialogScale(this);
    checkVersionDialog.initialDialogScale(this);
    checkVersionDialog.checkVersion();
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = _handlePress;
    super.initState();
  }

  void _handlePress() {
    AnalyticsHelper().log(AnalyticsEvents.EnterNumberPg_Privacy_Text_Clk);
    _launchURL('https://impo.app/privacy.html');
  }

  Future<bool> _launchURL(String url) async {
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
    return true;
  }



  checkPayload(){
    if(Payload.getGlobal().getPayload() != null && Payload.getGlobal().getPayload() != ''){
      Payload.getGlobal().setPayload('');
    }
  }

  initUserName()async{
    if(widget.value != null){
      // print(widget.value);
      if(this.mounted){
        setState(() {
          controller = new TextEditingController(text: widget.value);
        });
      }
    }else{
      controller = new TextEditingController();
    }
  }

  initTypeValue(){
    // if(country == 'IR'){
      if(itemsPhoneNumberOrPhone[0].selected!){
        setState(() {
          typeValue = 0;
        });
      }else{
        setState(() {
          typeValue = 1;
        });
      }
    // }else{
    //   setState(() {
    //     typeValue = 1;
    //   });
    // }
  }

  @override
  void dispose() {
    scrollController.dispose();
    checkVersionDialog.dispose();
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  checkVisibilityKeyBoard(){
    KeyboardVisibilityController().onChange.listen((bool visible) {
      if(mounted){
        if(visible){
          Timer(Duration(milliseconds: 300),(){
            if(scrollController.hasClients){
              scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500),curve: Curves.ease);
            }
          });
        }
      }
    });
  }


  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.EnterNumberPg_Back_NavBar_Clk);
    exitAppDialog.onPressShowDialog();
    return Future.value(false);
  }


  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            body:  Stack(
              children: <Widget>[
                SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
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
                      Text(
                        'لطفا ${typeValue == 0 ? 'شماره تلفن همراه ' : 'ایمیل '}خود را در این\nقسمت وارد کنید',
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top:  ScreenUtil().setWidth(55),
                            left: ScreenUtil().setWidth(55),
                            right:  ScreenUtil().setWidth(50)
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
                          topMargin: 100,
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
                                                  margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(65)),
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
                      Align(
                        alignment: Alignment.center,
                        child:  StreamBuilder(
                          stream: _presenter.isLoadingObserve,
                          builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                            if(snapshotIsLoading.data != null){
                              if(!snapshotIsLoading.data!){
                                return  Padding(
                                  padding: EdgeInsets.only(
                                      top: ScreenUtil().setWidth(100),
                                      bottom: ScreenUtil().setWidth(30)
                                  ),
                                  child:  CustomButton(
                                    title: 'ادامه',
                                    onPress: onPressAcceptNumber,
                                    colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                                    borderRadius: 10.0,
                                    enableButton: true,
                                  ),
                                );
                              }else{
                                return  Padding(
                                  padding: EdgeInsets.only(
                                      top: ScreenUtil().setWidth(50),
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
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setWidth(10)
                        ),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text : "با ورود و یا ثبت‌نام در ایمپو، شما\n",
                              style: context.textTheme.labelSmall!.copyWith(
                                color: ColorPallet().gray,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' قوانین و مقررات',
                                  recognizer: _tapGestureRecognizer,
                                  mouseCursor: SystemMouseCursors.precise,
                                  style: context.textTheme.labelSmall!.copyWith(
                                    decoration: TextDecoration.underline,
                                    color: ColorPallet().mainColor,
                                  ),
                                ),
                                TextSpan(
                                  text: ' آن را می‌پذیرید',
                                  style: context.textTheme.labelSmall!.copyWith(
                                    color: ColorPallet().gray,
                                  ),
                                ),
                              ]
                          ),
                        ),
                      ),
                      // ElevatedButton(
                      //   onPressed: ()async{
                      //     AppInfo app = await InstalledApps.getAppInfo('com.farsitel.bazaar');
                      //     print(app.name);
                      //     print(app.versionName);
                      //   },
                      //   child: Text('click'),
                      // )
                    ],
                  ),
                ),
                StreamBuilder(
                  stream: _presenter.isShowDialogObserve,
                  builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog){
                    if(snapshotIsShowDialog.data != null){
                      if(snapshotIsShowDialog.data!){
                        return  StreamBuilder(
                          stream: _presenter.valueDialogTextObserve,
                          builder: (context,snapshotValueDialogText){
                            if(snapshotValueDialogText.data != null){
                              return   QusDialog(
                                scaleAnim: _presenter.dialogScaleObserve,
                                onPressCancel:(){
                                  _presenter.onPressCancelDialog();
                                } ,
                                value: snapshotValueDialogText.data,
                                // value: "دوست عزیز، قبلا با این ${typeValue == 0 ? 'شماره تلفن' : 'ایمیل'} حساب کاربری ایجاد شده است. لطفا پس از تایید رمز عبور خود را وارد کنید",
                                yesText: 'تایید',
                                noText: 'نه',
                                onPressYes: (){
                                  /// if(widget.hasCircles){
                                  ///   _presenter.onPressCancelDialog();
                                  /// }else{
                                    _presenter.onPressOkDialog(context,controller.text);
                                  /// }
                                },
                                isOneBtn: true,
                                isIcon: false,
                                colors: [Colors.white,Colors.white],
                                topIcon: 'assets/images/ic_box_question.svg',
                                isLoadingButton: false,
                              );
                            }else{
                              return  Container();
                            }
                          },
                        );
                      }else{
                        return  Container();
                      }
                    }else{
                      return  Container();
                    }
                  },
                ),
                StreamBuilder(
                  stream: checkVersionDialog.isShowCheckUpdateDialogObserve,
                  builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog){
                    if(snapshotIsShowDialog.data != null){
                      if(snapshotIsShowDialog.data!){
                        return  StreamBuilder(
                          stream: checkVersionDialog.valueCheckUpdateDialogObserve,
                          builder: (context,AsyncSnapshot<List>snapshotValue){
                            if(snapshotValue.data != null){
                              return  QusDialog(
                                scaleAnim: checkVersionDialog.dialogScaleObserve,
                                onPressCancel: (){
                                  if(!snapshotValue.data![2]){
                                    checkVersionDialog.cancelUpdate();
                                  }
                                },
                                value: snapshotValue.data![0],
                                yesText: 'بزن بریم',
                                noText: 'بعدا',
                                onPressYes: (){
                                  checkVersionDialog.acceptUpdate(snapshotValue.data![1]);
                                },
                                isIcon: true,
                                isOneBtn: snapshotValue.data![2] ? true : null,
                                colors: [Colors.white,Colors.white],
                                topIcon: 'assets/images/ic_box_question.svg',
                                isLoadingButton: false,
                              );
                            }else{
                              return  Container();
                            }
                          },
                        );
                      }else{
                        return  Container();
                      }
                    }else{
                      return  Container();
                    }
                  },
                ),
                StreamBuilder(
                  stream: exitAppDialog.isShowExitDialogObserve,
                  builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog){
                    if(snapshotIsShowDialog.data != null){
                      if(snapshotIsShowDialog.data!){
                        return   QusDialog(
                          scaleAnim: exitAppDialog.dialogScaleObserve,
                          onPressCancel: (){
                            AnalyticsHelper().log(AnalyticsEvents.EnterNumberPg_ExitImpoNoDlg_Btn_Clk);
                            exitAppDialog.cancelDialog();
                          },
                          value: '\nمطمئنی می‌خوای از ایمپو خارج بشی؟\n',
                          yesText: 'آره برمیگردم',
                          noText: 'نه',
                          onPressYes: (){
                            AnalyticsHelper().log(AnalyticsEvents.EnterNumberPg_ExitImpoYesDlg_Btn_Clk);
                            exitAppDialog.acceptDialog(context);
                          },
                          isIcon: true,
                          colors: [Colors.white,Colors.white],
                          topIcon: 'assets/images/ic_box_question.svg',
                          isLoadingButton: false,
                        );
                      }else{
                        return  Container();
                      }
                    }else{
                      return  Container();
                    }
                  },
                ),
                // RaisedButton(
                //   onPressed: (){
                //     Navigator.push(
                //         context,
                //         PageTransition(
                //             type: PageTransitionType.fade,
                //             child: SelectStatusScreen()
                //         )
                //     );
                //   },
                // )
              ],
            ),
            bottomNavigationBar:  StreamBuilder(
              stream: _presenter.isShowDialogObserve,
              builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                if(snapshotIsLoading.data != null){
                  if(!snapshotIsLoading.data!){
                    return  StreamBuilder(
                      stream: exitAppDialog.isShowExitDialogObserve,
                      builder: (context,AsyncSnapshot<bool>snapshotIsShowExitDialog){
                        if(snapshotIsShowExitDialog.data != null){
                          if(!snapshotIsShowExitDialog.data!){
                            return  StreamBuilder(
                              stream: checkVersionDialog.isShowCheckUpdateDialogObserve,
                              builder: (context,AsyncSnapshot<bool>snapshotIsShowCheckUpdateDialog){
                                if(snapshotIsShowCheckUpdateDialog.data != null){
                                  if(!snapshotIsShowCheckUpdateDialog.data!){
                                    return  Padding(
                                      padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(70)),
                                      child: BottomTextRegister(),
                                    );
                                  }else{
                                    return  Container(width: 0,height: 0);
                                  }
                                }else{
                                  return  Container();
                                }
                              },
                            );
                          }else{
                            return  Container(width: 0,height: 0,);
                          }
                        }else{
                          return  Container();
                        }
                      },
                    );
                  }else{
                    return  Container(
                      width: 0,
                      height: 0,
                    );
                  }
                }else{
                  return  Container();
                }
              },
            )
        ),
      )
    );
  }

  // bool isNumeric(String s) {
  //   if(s == null) {
  //     return false;
  //   }
  //   return double.parse(s, (e) => null) != null;
  // }

  onPressAcceptNumber(){
    _animations.isErrorShow.sink.add(false);
    if(controller.text != ''){
      if(typeValue == 0){
        if(controller.text.startsWith('09') && controller.text.length == 11){

          // _presenter.checkIsRegisterToken(controller.text,context,_animations,'');
          _presenter.isRegisterStatus(controller.text, context, _animations,typeValue);


        }else{
          _animations.showShakeError('شماره تلفن باید ۱۱ رقم باشه و با ۰۹ شروع بشه');
        }
      }else{

        if(isEmail(controller.text)){

          // _presenter.checkIsRegisterToken(controller.text,context,_animations,'');
          _presenter.isRegisterStatus(controller.text, context, _animations,typeValue);

        }else{
          _animations.showShakeError('فرمت ایمیل وارد شده صحیح نیست');
        }

      }
    }else{
      if(typeValue == 0){
        _animations.showShakeError('شماره تلفن باید ۱۱ رقم باشه و با ۰۹ شروع بشه');
      }else{
        _animations.showShakeError('فرمت ایمیل وارد شده صحیح نیست');
      }
    }
  }



  @override
  void onError(msg) {

  }

  @override
  void onSuccess(msg) {

  }

  itemPhoneNumberOrEmail(int _typeValue){

    return  GestureDetector(
      onTap: ()async{
        FocusScope.of(context).unfocus();
        Timer(Duration(milliseconds: 50),(){
          _focusNode.requestFocus();
          controller.clear();
        });
        _animationController.reverse();
        setState(() {
          typeValue = _typeValue;
          for(int i=0 ; i<itemsPhoneNumberOrPhone.length ; i++){
            itemsPhoneNumberOrPhone[i].selected = false;
          }
          itemsPhoneNumberOrPhone[_typeValue].selected = !itemsPhoneNumberOrPhone[_typeValue].selected!;
        });
        print(_typeValue);
        if(_typeValue == 0){
          AnalyticsHelper().log(AnalyticsEvents.EnterNumberPg_Phone_Btn_Clk);
        }else{
          AnalyticsHelper().log(AnalyticsEvents.EnterNumberPg_Email_Btn_Clk);
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
              height: _typeValue == 0 ? ScreenUtil().setWidth(35) :  ScreenUtil().setWidth(30) ,
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

}

