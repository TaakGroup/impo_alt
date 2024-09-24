

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/register_presenter.dart';
import 'package:impo/src/architecture/view/register_view.dart';
import 'package:impo/src/components/DateTime/my_datetime.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/bottom_text_register.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/dashboard/pregnancy_numbers_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/LoginAndRegister/menstruationRegister/lastPeriod_register_screen.dart';

import '../../../../packages/flutter_material_pickers-3.6.0/helpers/show_scroll_picker.dart';
import '../../../firebase_analytics_helper.dart';


class CycleDayRegisterScreen extends StatefulWidget{

  final hasAbortion;
  // final Map registerParamViewModel;
  final phoneOrEmail; /// if this null ==> fromChangeStatus
  // final interfaceCode;

  CycleDayRegisterScreen({Key? key,this.phoneOrEmail,this.hasAbortion}):super(key:key);

  @override
  State<StatefulWidget> createState() => CycleDayRegisterScreenState();
}

class CycleDayRegisterScreenState extends State<CycleDayRegisterScreen>with TickerProviderStateMixin implements RegisterView{

  late RegisterPresenter _presenter;

  CycleDayRegisterScreenState(){
    _presenter = RegisterPresenter(this);
  }

  List<String> circleDays = [];

  int indexDays = 1 ;

  late String selectedCircleDay ;

  bool isApi19 = false;

  late AnimationController animationControllerScaleSendButton;


  Animations _animations =  Animations();

  int age = 20;

  @override
  void initState() {
    AnalyticsHelper().enableEventsList([AnalyticsEvents.CycleDayRegPg_CycleLengthList_Picker_Scr]);
    animationControllerScaleSendButton = _animations.pressButton(this);
    generateCircleDays();
    super.initState();
  }


  Future<int> checkAndroidVersion()async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if(androidInfo.version.sdkInt <= 19){
      setState(() {
        isApi19 = true;
      });
    }else{
      setState(() {
        isApi19 = false;
      });
    }
    return androidInfo.version.sdkInt;
  }

  var registerInfo = locator<RegisterParamModel>();

  generateCircleDays(){


    for(int i=1 ; i < 42 ; i++){
      circleDays.add('${i+19} روز');
    }

    if(registerInfo.register.periodDay == 6){
      circleDays.removeRange(0,1);
    }else if(registerInfo.register.periodDay == 7){
      circleDays.removeRange(0, 2);
    }else if(registerInfo.register.periodDay  == 8){
      circleDays.removeRange(0, 3);
    }else if(registerInfo.register.periodDay  == 9){
      circleDays.removeRange(0, 4);
    }else if(registerInfo.register.periodDay  == 10){
      circleDays.removeRange(0, 5);
    }

    if(widget.phoneOrEmail == null)getSelectedDefaultCycleDay();
    selectedCircleDay = circleDays[indexDays];

  }

  getSelectedDefaultCycleDay(){
    var cycleInfo = locator<CycleModel>();
    var pregnancyInfo = locator<PregnancyNumberModel>();
    if(cycleInfo.cycle.isNotEmpty){
      List<CycleViewModel> periodCycles = [];
      for(int i=0 ; i<cycleInfo.cycle.length ; i++){
        if(cycleInfo.cycle[i].status == 0){
          periodCycles.add(cycleInfo.cycle[i]);
        }
      }
      if(periodCycles.length != 0){
        DateTime periodStart = DateTime.parse(periodCycles[periodCycles.length-1].periodStart!);
        DateTime cycleEnd = DateTime.parse(periodCycles[periodCycles.length-1].circleEnd!);
        int cycleLength = MyDateTime().myDifferenceDays(periodStart,cycleEnd) + 1;
        for(int i=0 ; i<circleDays.length ; i++){
          if(pregnancyInfo.pregnancyNumbers.weekNoPregnancy! < cycleLength~/7) {
            if (circleDays[i] == '$cycleLength روز') {
              setState(() {
                indexDays = i;
              });
              break;
            }
          }else{
            setState(() {
              indexDays = 1;
            });
          }
        }
      }else{
        setState(() {
          indexDays = 1;
        });
      }
    }
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.CycleDayRegPg_Back_NavBar_Clk);
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
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    widget.phoneOrEmail == null ?
                    CustomAppBar(
                      messages: false,
                      profileTab: true,
                      icon: 'assets/images/ic_arrow_back.svg',
                      titleProfileTab: 'صفحه قبل',
                      subTitleProfileTab: 'صفحه اصلی',
                      onPressBack: () {
                        AnalyticsHelper().log(AnalyticsEvents.CycleDayRegPg_Back_Btn_Clk);
                        Navigator.pop(context);
                      },
                    ) : Container(),
                    widget.phoneOrEmail != null ?
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
                    ) : Container(
                      width: ScreenUtil().setWidth(80),
                      height: ScreenUtil().setWidth(80),),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: ScreenUtil().setWidth(100),
                          right: ScreenUtil().setWidth(30),
                          left: ScreenUtil().setWidth(30),
                      ),
                      child:   Column(
                        children: [
                          Text(
                            '${registerInfo.register.name} جان، طول دوره پریودت رو انتخاب کن',
                            textAlign: TextAlign.center,
                              style: context.textTheme.labelLarge
                          ),
                          SizedBox(height: ScreenUtil().setWidth(8)),
                          Text(
                            'از شروع یک پریود تا شروع پریود بعدیت چند روز طول می‌کشه؟',
                            textAlign: TextAlign.center,
                            style:  context.textTheme.bodySmall!.copyWith(
                              color: Color(0xff707070),
                            )
                          ),
                        ],
                      )
                    ),
                    SizedBox(height: ScreenUtil().setHeight(100)),
                    Platform.isAndroid ?
                    FutureBuilder(
                      future: checkAndroidVersion(),
                      builder: (context,AsyncSnapshot<int> snapshot){
                        if(snapshot.data != null){
                          if(snapshot.data! <= 19){
                            return   CustomButton(
                              title: selectedCircleDay,
                              center: true,
                              onPress: (){
                                showMaterialScrollPicker(
                                  context: context,
                                  showDivider: false,
                                  title: "طول سیکل پریود",
                                  confirmText: 'انتخاب',
                                  cancelText: 'لغو',
                                  items: circleDays,
                                  selectedItem: selectedCircleDay,
                                  onChanged: (String value){
                                    setState(() {
                                      selectedCircleDay = value;
                                    });
                                  },
                                );
                              },
                              enableButton: true,
                            );
                          }else{
                            return    Container(
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
                                          child:  CupertinoPicker(
                                              scrollController: FixedExtentScrollController(initialItem:indexDays),
                                              itemExtent: ScreenUtil().setWidth(110),
                                              onSelectedItemChanged: (index){
                                                AnalyticsHelper().log(AnalyticsEvents.CycleDayRegPg_CycleLengthList_Picker_Scr,remainEventActive: false);
                                                setState(() {
                                                  indexDays = index;
                                                });
                                              },
                                              children: List.generate(circleDays.length, (index){
                                                return  Center(
                                                  child:  Text(
                                                    circleDays[index],
                                                      style:  context.textTheme.bodyLarge!.copyWith(
                                                          color: ColorPallet().mainColor
                                                      )
                                                  ),
                                                );
                                              })
                                          ),
                                        )
                                    )
                                )
                            );
                          }
                        }else{
                          return  Container();
                        }
                      },
                    ) :
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
                                  child:  CupertinoPicker(
                                      scrollController: FixedExtentScrollController(initialItem:indexDays),
                                      itemExtent: ScreenUtil().setWidth(110),
                                      onSelectedItemChanged: (index){
                                        AnalyticsHelper().log(AnalyticsEvents.CycleDayRegPg_CycleLengthList_Picker_Scr,remainEventActive: false);
                                        setState(() {
                                          indexDays = index;
                                        });
                                      },
                                      children: List.generate(circleDays.length, (index){
                                        return  Center(
                                          child:  Text(
                                            circleDays[index],
                                              style:  context.textTheme.bodyLarge!.copyWith(
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
                                    if(isApi19){
                                      _presenter.enterCircleDay(int.parse(selectedCircleDay.replaceAll(' روز', '')));
                                    }else{
                                      _presenter.enterCircleDay(int.parse(circleDays[indexDays].replaceAll(' روز', '')));
                                    }
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
              bottomNavigationBar:  widget.phoneOrEmail != null ?
              Padding(
                padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
                child: BottomTextRegister(),
              ) : Container(width: 0,height: 0)

          )
      ),
    );
  }

  @override
  void onError(msg) {
  }

  @override
  void onSuccess(days){
    // widget.registerParamViewModel['circleDay'] = days;
    // print(days);

    registerInfo.setCircleDay(days);
    AnalyticsHelper().log(AnalyticsEvents.CycleDayRegPg_Cont_Btn_Clk);
    Navigator.push(context,
      PageRouteBuilder(
        transitionDuration: Duration(seconds: 2),
        pageBuilder: (_, __, ___) => LastPeriodRegisterScreen(
          // registerParamViewModel: widget.registerParamViewModel,
          // interfaceCode: widget.interfaceCode,
          phoneOrEmail: widget.phoneOrEmail,
          hasAbortion: widget.hasAbortion,
        ),
      ),
    );

  }

}