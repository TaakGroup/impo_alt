

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/register_presenter.dart';
import 'package:impo/src/architecture/view/register_view.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/bottom_text_register.dart';
import 'package:impo/src/components/calender.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/LoginAndRegister/globalRegister/sexual_register_screen.dart';
import 'package:impo/src/screens/LoginAndRegister/menstruationRegister/periodDay_register_screen.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../../firebase_analytics_helper.dart';


class BirthdayRegisterScreen extends StatefulWidget{

  // final Map registerParamViewModel;
  final phoneOrEmail;
  // final interfaceCode;

  BirthdayRegisterScreen({Key? key,this.phoneOrEmail}):super(key:key);

  @override
  State<StatefulWidget> createState() => BirthdayRegisterScreenState();
}

class BirthdayRegisterScreenState extends State<BirthdayRegisterScreen>with TickerProviderStateMixin implements RegisterView{

  late RegisterPresenter _presenter;

  BirthdayRegisterScreenState(){
    _presenter = RegisterPresenter(this);
  }


  late AnimationController animationControllerScaleSendButton;


  Animations _animations =  Animations();

  int indexDays = 1 ;

  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.BirthdayRegPg_Cont_Btn_Clk);
    animationControllerScaleSendButton = _animations.pressButton(this);
    super.initState();
  }

  Jalali birthDate = Jalali(
      Jalali.now().year - 25,
      Jalali.now().month,
      Jalali.now().day
  );

  late Calender calender;

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.BirthdayRegPg_Back_NavBar_Clk);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.5;
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return  WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
          textDirection: TextDirection.rtl,
          child:  Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              body:   SingleChildScrollView(
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
                        'توی کدوم سال و ماه و روز، دنیا رو با اومدنت قشنگ‌تر کردی ؟',
                        textAlign: TextAlign.center,
                        style: context.textTheme.labelLarge!.copyWith(
                          height: 1.8
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(65)),
                    Center(
                        child: calender = Calender(
                          isBirthDate: true,
                          // mode: 0,
                          dateTime:  birthDate,
                          // typeCalendar: 0,
                          maxDate:  Jalali(
                              Jalali.now().year - 6,
                              12,
                              29
                          ),
                          minDate:             Jalali(
                              Jalali.now().year - 65,
                              1,
                              1
                          ),
                        )
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
                                  top: ScreenUtil().setWidth(150),

                                ),
                                child:  CustomButton(
                                  title: 'ادامه',
                                  onPress: (){
                                    _presenter.enterBirthDay('okk');
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
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
                child: BottomTextRegister(),
              )
          )
      ),
    );
  }

  @override
  void onError(msg) {

  }

  @override
  void onSuccess(birthday) {

    // print(widget.registerParamViewModel['birthDay']);
    var registerInfo = locator<RegisterParamModel>();

    registerInfo.setBirthDay(calender.getDateTime().toString().replaceAll('Jalali', '').replaceAll('(', '').replaceAll(')', ''));

    DateTime now = DateTime.now();

    int diff = ((now.millisecondsSinceEpoch -
        calender.getDateTime().toDateTime().millisecondsSinceEpoch) ~/ 31556926000);


    if(diff >= 14){
      Navigator.push(context,
        PageRouteBuilder(
          transitionDuration: Duration(seconds: 2),
          pageBuilder: (_, __, ___) => SexualRegisterScreen(
            // registerParamViewModel: widget.registerParamViewModel,
            // interfaceCode: widget.interfaceCode,
            phoneOrEmail: widget.phoneOrEmail,
          ),
        ),
      );
    }else{
      registerInfo.setStatus(1);
      registerInfo.setSex(0);
      registerInfo.setPeriodStatus(0);
      Navigator.push(context,
        PageRouteBuilder(
          transitionDuration: Duration(seconds: 2),
          pageBuilder: (_, __, ___) => PeriodDayRegisterScreen(
            hasAbortion: false,
            // registerParamViewModel: widget.registerParamViewModel,
            // interfaceCode: widget.interfaceCode,
            phoneOrEmail: widget.phoneOrEmail,
          ),
        ),
      );
    }

  }

}