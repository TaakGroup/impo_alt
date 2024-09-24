
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/register_presenter.dart';
import 'package:impo/src/architecture/view/register_view.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/bottom_text_register.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/text_field_area.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/local/save_data_offline_mode.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/LoginAndRegister/globalRegister/birthday_register_screen.dart';
import 'package:impo/src/screens/LoginAndRegister/globalRegister/nationality_register_screen.dart';

import '../../../firebase_analytics_helper.dart';

class NameRegisterScreen extends StatefulWidget{

  final phoneOrEmail;

  NameRegisterScreen({Key? key,this.phoneOrEmail}):super(key : key);

  @override
  State<StatefulWidget> createState() => NameRegisterScreenState();
}

class NameRegisterScreenState extends State<NameRegisterScreen>with TickerProviderStateMixin implements RegisterView{

  late RegisterPresenter _presenter;

  NameRegisterScreenState(){
    _presenter = RegisterPresenter(this);
  }


  late AnimationController animationControllerScaleSendButton;

  late AnimationController shakeErrorController;


  Animations _animations = new Animations();

  late TextEditingController nameController;
  late TextEditingController interFaceCode;

  // Map<String,dynamic> registerParamViewModel = {};

  int modePress = 0;
  late ScrollController scrollController;


  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.NameRegPg_Self_Pg_Load);
   animationControllerScaleSendButton = _animations.pressButton(this);

   nameController =  TextEditingController();
   interFaceCode =  TextEditingController();
   scrollController = ScrollController();
   checkVisibilityKeyBoard();
   shakeErrorController = _animations.shakeError(this);
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

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.NameRegPg_Back_NavBar_Clk);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {

    timeDilation = 0.5;
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child:   Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body:    SingleChildScrollView(
                controller: scrollController,
                child:    Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
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
                            horizontal: ScreenUtil().setWidth(50)
                          ),
                          child: Text(
                            'دوست داری با چه اسم قشنگی تو ایمپو صدات کنیم؟',
                            textAlign: TextAlign.center,
                            style: context.textTheme.labelLarge,
                          ),
                        ),
                        TextFieldArea(
                          label: 'نام',
                          textController: nameController,
                          readOnly: false,
                          editBox: false,
                          bottomMargin: 0,
                          topMargin: 100,
                          obscureText: false,
                          keyboardType:TextInputType.text ,
                          notFlex: true,
                          maxLength: 15,
                          icon: 'assets/images/ic_name.svg',
                        ),
                        TextFieldArea(
                            label: 'کد معرف(اختیاری)',
                            textController: interFaceCode,
                            readOnly: false,
                            editBox: false,
                            bottomMargin: 0,
                            topMargin: 50,
                            obscureText: false,
                            keyboardType:TextInputType.number ,
                            notFlex: true,
                            icon: 'assets/images/ic_enter_face_code.svg',
                            color: ColorPallet().gray,
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
                        Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: ScreenUtil().setWidth(100),
                              ),
                              child:  CustomButton(
                                title: 'ادامه',
                                onPress: (){
                                  _presenter.enterName(nameController.text);
                                },
                                colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                                borderRadius: 10.0,
                                enableButton: true,
                              ),
                            )
                        )
                      ],
                    ),
                  ],
                )
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
              child: BottomTextRegister(),
            )
        ),
      ),
    );
  }

  @override
  void onError(var msg) {

    _animations.showShakeError(msg);
  }

  @override
  void onSuccess(var name){

    _animations.isErrorShow.sink.add(false);

    var registerInfo = locator<RegisterParamModel>();
    registerInfo.setName(name);
    registerInfo.setInterFaceCode(interFaceCode.text);

    registerInfo.setNationality('IR');
    SaveDataOfflineMode().saveNationality();

    AnalyticsHelper().log(AnalyticsEvents.NameRegPg_Cont_Btn_Clk,parameters:{'interFaceCode' : interFaceCode.text});
    // Navigator.push(context,
    //   PageRouteBuilder(
    //     transitionDuration: Duration(seconds: 2),
    //     pageBuilder: (_, __, ___) => NationalityRegisterScreen(
    //       // registerParamViewModel: registerParamViewModel,
    //       // interfaceCode: interFaceCode.text,
    //       phoneOrEmail: widget.phoneOrEmail,
    //     ),
    //   ),
    // );
    Navigator.push(context,
      PageRouteBuilder(
        transitionDuration: Duration(seconds: 2),
        pageBuilder: (_, __, ___) => BirthdayRegisterScreen(
          // registerParamViewModel: widget.registerParamViewModel,
          // interfaceCode: widget.interfaceCode,
          phoneOrEmail: widget.phoneOrEmail,
        ),
      ),
    );
  }

}
