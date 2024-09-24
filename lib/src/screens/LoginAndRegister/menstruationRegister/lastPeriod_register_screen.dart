

import 'dart:io';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as INTL;
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
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/dashboard/pregnancy_numbers_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/LoginAndRegister/identity/set_password_screen.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../../../../packages/flutter_material_pickers-3.6.0/helpers/show_scroll_picker.dart';
import '../../../firebase_analytics_helper.dart';


class LastPeriodRegisterScreen extends StatefulWidget{

  final hasAbortion;
  final phoneOrEmail; /// if this null ==> fromChangeStatus
  // final interfaceCode;

  LastPeriodRegisterScreen({Key? key,this.phoneOrEmail,this.hasAbortion}):super(key:key);

  @override
  State<StatefulWidget> createState() => LastPeriodRegisterScreenState();
}

class LastPeriodRegisterScreenState extends State<LastPeriodRegisterScreen>with TickerProviderStateMixin implements RegisterView{

  late RegisterPresenter _presenter;

  LastPeriodRegisterScreenState(){
    _presenter = RegisterPresenter(this);
  }

  List<String> days = [];

  List<String> daysForSaves = [];

  late AnimationController animationControllerScaleSendButton;


  Animations _animations =  Animations();

  int indexDays = 0;

  late String selectedLastPeriodDay;

  bool isApi19 = false;

  var registerInfo = locator<RegisterParamModel>();


  @override
  void initState() {
    AnalyticsHelper().enableEventsList([AnalyticsEvents.LastPeriodRegPg_LastPeriodList_Picker_Scr]);
    animationControllerScaleSendButton = _animations.pressButton(this);
    _animations.shakeError(this);
    generateDatePeriods();
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

  generateDatePeriods(){

    Jalali j1 = Jalali.now();

    DateTime now = DateTime.now();


    for(int i=0 ; i<60 ; i++){
      DateTime yesterday =  DateTime(now.year,now.month,now.day - i);
      if(registerInfo.register.calendarType == 1){
        final INTL.DateFormat formatter = INTL.DateFormat('dd LLL yyyy','fa');
        days.add(formatter.format(yesterday));

      }else{
        days.add(format1(j1.addDays(-i)));
      }
      daysForSaves.add(yesterday.toString());
    }

    if(widget.phoneOrEmail == null)getSelectedDefaultLastPeriodDay();

    setState((){
      selectedLastPeriodDay = days[indexDays];
    });

  }

  getSelectedDefaultLastPeriodDay(){
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
        print(cycleLength~/7);
        for(int i=0 ; i<daysForSaves.length ; i++){
          if(pregnancyInfo.pregnancyNumbers.weekNoPregnancy! < cycleLength~/7){
            if(daysForSaves[i] == DateTime(cycleEnd.year,cycleEnd.month,cycleEnd.day + 1).toString()){
              setState(() {
                indexDays = i;
              });
              break;
            }
          }else{
            setState(() {
              indexDays = 0;
            });
          }
        }
      }else{
        setState(() {
          indexDays = 0;
        });
      }
    }
  }


  String format1(Date d) {
    final f = d.formatter;

    Jalali now = Jalali.now();

    if(registerInfo.register.nationality == 'IR'){
      if(d == now){

        return 'امروز  ${f.d}  ${f.mN}';

      }else if(d == now.addDays(-1)){

        return 'دیروز  ${f.d}  ${f.mN}';

      }else{

        return '${f.wN}  ${f.d}  ${f.mN}';

      }
    }else{
      if(d == now){

        return 'امروز  ${f.d}  ${f.mnAf}';

      }else if(d == now.addDays(-1)){

        return 'دیروز  ${f.d}  ${f.mnAf}';

      }else{

        return '${f.wN}  ${f.d}  ${f.mnAf}';

      }
    }


  }

  @override
  void dispose() {
    _animations.animationControllerShakeError.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.LastPeriodRegPg_Back_NavBar_Clk);
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
              body:  SingleChildScrollView(
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
                        AnalyticsHelper().log(AnalyticsEvents.LastPeriodRegPg_Back_Btn_Clk);
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
                          right: ScreenUtil().setWidth(50),
                          left: ScreenUtil().setWidth(50),
                      ),
                      child:   Text(
                        'خب ${registerInfo.register.name} جان حالا تاریخ آخرین باری که پریود شدی رو انتخاب کن',
                        textAlign: TextAlign.center,
                          style: context.textTheme.labelLarge
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(85)),
                    Platform.isAndroid ?
                    FutureBuilder(
                      future: checkAndroidVersion(),
                      builder: (context,AsyncSnapshot<int> snapshot){
                        if(snapshot.data != null){
                          if(snapshot.data! <= 19){
                            return   CustomButton(
                              title: selectedLastPeriodDay,
                              center: true,
                              onPress: (){
                                showMaterialScrollPicker(
                                  context: context,
                                  showDivider: false,
                                  title: "آخرین پریود",
                                  confirmText: 'انتخاب',
                                  cancelText: 'لغو',
                                  items: days,
                                  selectedItem: selectedLastPeriodDay,
                                  onChanged: (String value){
                                    setState(() {
                                      selectedLastPeriodDay = value;
                                    });
                                  },
                                );
                              },
                              enableButton: true,
                            );
                          }else{
                            return   Container(
                                alignment: Alignment.center,
                                height: ScreenUtil().setWidth(200),
                                child:  Center(
                                    child:  NotificationListener<OverscrollIndicatorNotification>(
                                        onNotification: (overscroll){
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
                                                AnalyticsHelper().log(AnalyticsEvents.LastPeriodRegPg_LastPeriodList_Picker_Scr,remainEventActive: false);
                                                indexDays = index;
                                              },
                                              children: List.generate(days.length, (index){
                                                return  Center(
                                                  child:  Text(
                                                    days[index],
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
                        height: ScreenUtil().setWidth(200),
                        child:  Center(
                            child:  NotificationListener<OverscrollIndicatorNotification>(
                                onNotification: (overscroll){
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
                                        AnalyticsHelper().log(AnalyticsEvents.LastPeriodRegPg_LastPeriodList_Picker_Scr,remainEventActive: false);
                                        indexDays = index;
                                      },
                                      children: List.generate(days.length, (index){
                                        return  Center(
                                          child:  Text(
                                            days[index],
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
                                          builder: (context,AsyncSnapshot<String> snapshot){
                                            return Container(
                                                margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(65)),
                                                padding: EdgeInsets.only(left: _animations.animationShakeError.value + 4.0, right: 4.0 -_animations.animationShakeError.value),
                                                child: Text(
                                                  snapshot.data != null ? snapshot.data! : '',
                                                  style:  TextStyle(
                                                      color: Color(0xffEE5858),
                                                      fontSize: ScreenUtil().setWidth(28),
                                                      fontWeight: FontWeight.w400
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
                                  top: ScreenUtil().setWidth(80),

                                ),
                                child:  StreamBuilder(
                                  stream: _presenter.isLoadingObserve,
                                  builder: (context,snapshotIsLoading){
                                    if(snapshotIsLoading.data != null){
                                      return CustomButton(
                                        title: 'ادامه',
                                        onPress: (){
                                          if(isApi19){
                                            for(int i=0 ; i<days.length ; i++){
                                              if(days[i] == selectedLastPeriodDay){
                                                // print(daysForSaves[i]);
                                                _presenter.enterLastPeriodDay(daysForSaves[i]);
                                              }
                                            }
                                          }else{
                                            _presenter.enterLastPeriodDay(daysForSaves[indexDays]);
                                          }
                                        },
                                        colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                                        borderRadius: 10.0,
                                        enableButton: true,
                                        isLoadingButton: snapshotIsLoading.data,
                                      );
                                    }else{
                                      return Container();
                                    }
                                  },
                                )
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
              ) : Container(width: 0,height: 0,)
          )
      ),
    );
  }

  @override
  void onError(msg) {

  }

  @override
  void onSuccess(day){


    registerInfo.setLastPeriod(day.toString());

    AnalyticsHelper().log(AnalyticsEvents.LastPeriodRegPg_Cont_Btn_Clk);
    if(widget.phoneOrEmail != null){
      Navigator.push(context,
        PageRouteBuilder(
          transitionDuration: Duration(seconds: 2),
          pageBuilder: (_, __, ___) => SetPasswordScreen(
            isRegister: true,
            phoneOrEmail: widget.phoneOrEmail,
            onlyLogin: false,
          ),
        ),
      );
    }else{
      _presenter.requestChangeStatus(1,_animations,context,widget.hasAbortion);
    }

  }

}