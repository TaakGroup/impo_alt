

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
import 'package:impo/src/components/back_button.dart';
import 'package:impo/src/components/bottom_text_register.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/LoginAndRegister/menstruationRegister/cycleDay_register_screen.dart';

import '../../../../packages/flutter_material_pickers-3.6.0/helpers/show_scroll_picker.dart';
import '../../../firebase_analytics_helper.dart';
import '../../../models/dashboard/pregnancy_numbers_model.dart';



class PeriodDayRegisterScreen extends StatefulWidget{

  // final Map registerParamViewModel;
  final hasAbortion;
  final phoneOrEmail; /// if this null ==> fromChangeStatus
  // final interfaceCode;

  PeriodDayRegisterScreen({Key? key,this.phoneOrEmail,this.hasAbortion}):super(key:key);


  @override
  State<StatefulWidget> createState() => PeriodDayRegisterScreenState();
}

class PeriodDayRegisterScreenState extends State<PeriodDayRegisterScreen>with TickerProviderStateMixin implements RegisterView{


  late RegisterPresenter _presenter;

  PeriodDayRegisterScreenState(){
    _presenter = RegisterPresenter(this);
  }

  List<String> dayPereoids = ['2 روز','3 روز','4 روز','5 روز','6 روز','7 روز','8 روز','9 روز','10 روز'];

  late AnimationController animationControllerScaleSendButton;


  Animations _animations =  Animations();

  int indexDays = 1 ;

  late String selectedPeriodDay ;

  bool isApi19 = false;

  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.PeriodDayRegPg_Self_Pg_Load);
    AnalyticsHelper().enableEventsList([AnalyticsEvents.PeriodDayRegPg_PeriodLengthList_Picker_Scr]);
    animationControllerScaleSendButton = _animations.pressButton(this);
    if(widget.phoneOrEmail == null)getSelectedDefaultPeriodDay();
    selectedPeriodDay = dayPereoids[indexDays];
    super.initState();
  }

  getSelectedDefaultPeriodDay(){
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
        DateTime periodEnd = DateTime.parse(periodCycles[periodCycles.length-1].periodEnd!);
        DateTime cycleEnd = DateTime.parse(periodCycles[periodCycles.length-1].circleEnd!);
        int cycleLength = MyDateTime().myDifferenceDays(periodStart,cycleEnd) + 1;
        int periodLength = MyDateTime().myDifferenceDays(periodStart,periodEnd) + 1;
        for(int i=0 ; i<dayPereoids.length ; i++){
          if(pregnancyInfo.pregnancyNumbers.weekNoPregnancy! < cycleLength~/7) {
            if (dayPereoids[i] == '$periodLength روز') {
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

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.PeriodDayRegPg_Back_NavBar_Clk);
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
                child:  Column(
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
                        AnalyticsHelper().log(AnalyticsEvents.PeriodDayRegPg_Back_Btn_Clk);
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
                          bottom: ScreenUtil().setWidth(100)
                      ),
                      child:   Text(
                        'معمولا پریودت چند روز طول میکشه ؟',
                        textAlign: TextAlign.center,
                          style: context.textTheme.labelLarge
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(100)),
                    Platform.isAndroid ?
                    FutureBuilder(
                      future: checkAndroidVersion(),
                      builder: (context,AsyncSnapshot<int> snapshot){
                        if(snapshot.data != null){
                          if(snapshot.data! <= 19){
                            return  CustomButton(
                              title: selectedPeriodDay,
                              center: true,
                              onPress: (){
                                showMaterialScrollPicker(
                                  context: context,
                                  showDivider: false,
                                  title: "پریود",
                                  confirmText: 'انتخاب',
                                  cancelText: 'لغو',
                                  items: dayPereoids,
                                  selectedItem: selectedPeriodDay,
                                  onChanged: (String value){
                                    setState(() {
                                      selectedPeriodDay = value;
                                    });
                                  },
                                );
                              },
                              enableButton: true,
                            );
                          }else{
                            return  Container(
                                alignment: Alignment.center,
                                height: ScreenUtil().setWidth(220),
                                child:  Center(
                                    child:  NotificationListener<OverscrollIndicatorNotification>(
                                        onNotification: (overscroll) {
                                          overscroll.disallowIndicator();
                                          return true;
                                        },
                                        child:Theme(
                                          data: ThemeData(
                                              cupertinoOverrideTheme: CupertinoThemeData(
                                                  textTheme: CupertinoTextThemeData(
                                                    pickerTextStyle: TextStyle(color: ColorPallet().mainColor),
                                                  )
                                              )
                                          ),
                                          child:   CupertinoPicker(
                                              scrollController: FixedExtentScrollController(initialItem:indexDays),
                                              itemExtent: ScreenUtil().setWidth(110),
                                              onSelectedItemChanged: (index){
                                                AnalyticsHelper().log(AnalyticsEvents.PeriodDayRegPg_PeriodLengthList_Picker_Scr,remainEventActive:false );
                                                setState(() {
                                                  indexDays = index;
                                                });
                                              },
                                              children: List.generate(dayPereoids.length, (index){
                                                return  Center(
                                                  child:  Text(
                                                    dayPereoids[index],
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
                    )
                        :
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
                                        AnalyticsHelper().log(AnalyticsEvents.PeriodDayRegPg_PeriodLengthList_Picker_Scr,remainEventActive:false );
                                        setState(() {
                                          indexDays = index;
                                        });
                                      },
                                      children: List.generate(dayPereoids.length, (index){
                                        return  Center(
                                          child:  Text(
                                            dayPereoids[index],
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
                                      _presenter.enterPeriodDay(int.parse(selectedPeriodDay.replaceAll(' روز', '')));
                                    }else{
                                      _presenter.enterPeriodDay(int.parse(dayPereoids[indexDays].replaceAll(' روز', '')));
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
              bottomNavigationBar: widget.phoneOrEmail != null ?
              Padding(
                padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
                child: BottomTextRegister(),
              ) : Container(width: 0,height: 0,)
          )
      ),
    );
  }

  @override
  void onError(var msg) {

  }

  @override
  void onSuccess(var days){

    var registerInfo = locator<RegisterParamModel>();

    // widget.registerParamViewModel['periodDay'] = days;

    registerInfo.setPeriodDay(days);
    AnalyticsHelper().log(AnalyticsEvents.PeriodDayRegPg_Cont_Btn_Clk);
    Navigator.push(context,
      PageRouteBuilder(
        transitionDuration: Duration(seconds: 2),
        pageBuilder: (_, __, ___) => CycleDayRegisterScreen(
          // registerParamViewModel: widget.registerParamViewModel,
          // interfaceCode: widget.interfaceCode,
          phoneOrEmail: widget.phoneOrEmail,
          hasAbortion: widget.hasAbortion,
        ),
      ),
    );

  }

}