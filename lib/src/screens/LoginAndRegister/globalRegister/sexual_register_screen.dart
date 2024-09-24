
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/register_presenter.dart';
import 'package:impo/src/architecture/view/register_view.dart';
import 'package:impo/src/components/bottom_text_register.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/LoginAndRegister/globalRegister/select_status_screen.dart';
import 'package:impo/src/screens/LoginAndRegister/menstruationRegister/periodDay_register_screen.dart';
import '../../../firebase_analytics_helper.dart';

class SexualRegisterScreen extends StatefulWidget{

  // final Map registerParamViewModel;
  final phoneOrEmail;
  // final interfaceCode;

  SexualRegisterScreen({Key? key,this.phoneOrEmail}):super(key:key);

  @override
  State<StatefulWidget> createState() => SexualRegisterScreenState();
}

class SexualRegisterScreenState extends State<SexualRegisterScreen>with TickerProviderStateMixin implements RegisterView{

  late RegisterPresenter _presenter;

  SexualRegisterScreenState(){
    _presenter = RegisterPresenter(this);
  }


  List<String> yesOrNo = ['ندارم','دارم'];


  int indexList = 1 ;

//  CircleModel circleModel;

  Map<String,dynamic> circles = {};

  late DateTime lastPeriod ;
  var registerInfo = locator<RegisterParamModel>();
  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.SexualRegPg_Cont_Btn_Clk);
    super.initState();
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.SexualRegPg_Back_NavBar_Clk);
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
          child:  Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              body:
              SingleChildScrollView(
                child: Column(
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
                        '${registerInfo.register.name} جان آیا رابطه جنسی داری ؟',
                        textAlign: TextAlign.center,
                          style: context.textTheme.labelLarge
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(100)),
                    Container(
                        alignment: Alignment.center,
                        height: ScreenUtil().setWidth(220),
                        child:  Center(
                            child:  NotificationListener<OverscrollIndicatorNotification>(
                                onNotification: (overscroll) {
                                  overscroll.disallowIndicator();
                                  return true;
                                },
                                child: Theme(
                                  data: ThemeData(
                                      cupertinoOverrideTheme: CupertinoThemeData(
                                          textTheme: CupertinoTextThemeData(
                                            pickerTextStyle: TextStyle(color: ColorPallet().mainColor),
                                          )
                                      )
                                  ),
                                  child:   CupertinoPicker(
                                      scrollController: FixedExtentScrollController(initialItem:1),
                                      itemExtent: ScreenUtil().setWidth(110),
                                      onSelectedItemChanged: (index){
                                        indexList = index;
                                      },
                                      children: List.generate(yesOrNo.length, (index){
                                        return  Center(
                                          child:  Text(
                                            yesOrNo[index],
                                            style:  context.textTheme.labelLarge!.copyWith(
                                              color: ColorPallet().mainColor
                                            )
                                          ),
                                        );
                                      })
                                  ),
                                )
                            )
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
                                    _presenter.enterTypeSex(yesOrNo[indexList]);
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
  void onSuccess(msg)async{

    int typeSex = 0;

    // if(msg == 'دارم') widget.registerParamViewModel['typeSex'] = 1;
    //
    // if(msg == 'ندارم') widget.registerParamViewModel['typeSex'] = 0;

    if(msg == 'دارم') typeSex = 1;

    if(msg == 'ندارم') typeSex= 0;

    // widget.registerParamViewModel['token'] = '';
    //
    // widget.registerParamViewModel['calendarType'] = 0;

    var registerInfo = locator<RegisterParamModel>();
    registerInfo.setSex(typeSex);


    // RegisterParamViewModel registerParamViewModel;
    //
    // registerParamViewModel =   RegisterParamViewModel.fromJson(widget.registerParamViewModel);


    if(typeSex == 1){
      Navigator.push(context,
        PageRouteBuilder(
          transitionDuration: Duration(seconds: 2),
          pageBuilder: (_, __, ___) => SelectStatusScreen(
            phoneOrEmail: widget.phoneOrEmail,
          ),
        ),
      );

    }else{
      registerInfo.setStatus(1);
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