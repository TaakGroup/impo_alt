

import 'dart:async';

import 'package:angles/angles.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_sequence_animator/image_sequence_animator.dart';
import 'package:impo/src/architecture/presenter/calender_presenter.dart';
import 'package:impo/src/architecture/presenter/offlinemode_dashboard_presenter.dart';
import 'package:impo/src/architecture/view/calender_view.dart';
import 'package:impo/src/architecture/view/offlinemode_dashboard_view.dart';
import 'package:impo/src/components/DateTime/my_datetime.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/box_messages.dart';
import 'package:impo/src/components/canvas/circle_item.dart';
import 'package:impo/src/components/canvas/pregnancy_paint.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/dialogs/pregnancyand_breastfeeding_limit_week.dart';
import 'package:impo/src/components/dialogs/qus_dialog.dart';
import 'package:impo/src/components/number_to_text_withM.dart';
import 'package:impo/src/components/unicorn_outline_button.dart';
import 'package:impo/src/models/breastfeeding/breastfeeding_number_model.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/dashboard/dashboard_msg_offline_mode.dart';
import 'package:impo/src/models/dashboard/pregnancy_numbers_model.dart';
import 'package:impo/src/screens/home/tabs/profile/alarms/alarms_screen.dart';
import 'package:impo/src/screens/offlineMode/widget/item_offlineMode_button.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class OfflineDashboardScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => OfflineDashboardScreenState();
}

class OfflineDashboardScreenState extends State<OfflineDashboardScreen> with TickerProviderStateMixin implements OfflineModeDashboardView , CalenderView{

  PregnancyAndBreastfeedingLimitWeek pregnancyAndBreastfeedingLimitWeek = PregnancyAndBreastfeedingLimitWeek();
  Animations _animations =  Animations();
  int modePress = 0;
  late AnimationController animationControllerScaleButton;
  double width = 0;
  double height = 0;
  bool showCycle = false;
  late OfflineModeDashboardPresenter _dashboardPresenter;
  late CalenderPresenter _calenderPresenter;
  late AnimationController _controller;
  Tween<double> _tween = Tween(begin: 0.9, end: 0.93);
  late int periodDay, fertStartDays , fertEndDays;
  int? dayMode;
  int currentToday = 0;
  int maxDays = 0;
  int diffDays = 0;
  double padding = 25.0 - 90;
  late double angleOfDay , endOfPeriod , endOfCircle;
  late Jalali now;
  late DateTime lastPeriod ;
  late Angle periodStart , periodEnd , fertStart , fertEnd , ovumDay , pmsStart , pmsEnd , current , ovumDayEnd , cursor;
  DateTime today = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
  Map<String,dynamic> Circle = {};

  OfflineDashboardScreenState(){
    _dashboardPresenter = OfflineModeDashboardPresenter(this);
    _calenderPresenter = CalenderPresenter(this);
  }

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;


  @override
  void initState() {
    animationControllerScaleButton = _animations.pressButton(this);
    pregnancyAndBreastfeedingLimitWeek.initialDialogScale(this);
    checkIsAnim();
    checkStatus();
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 6000), vsync: this);
    _controller.repeat(reverse: true);
    initConnectivity();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }


  Future<void> initConnectivity() async {
     ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus = result;
    if(_connectionStatus == ConnectivityResult.mobile || _connectionStatus == ConnectivityResult.wifi){
       showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (context){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setWidth(15)),
                height: ScreenUtil().setWidth(5),
                width: ScreenUtil().setWidth(100),
                decoration: BoxDecoration(
                    color: Color(0xff707070).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15)),
              ),
              Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(30),
                      vertical: ScreenUtil().setWidth(30)),
                  child: Text(
                    'ایمپویی عزیز\nباتوجه به‌اینکه اینترنتت وصل شده، می‌خوای از حالت آنلاین اپلیکیشن استفاده کنی؟ ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorPallet().gray,
                        fontSize: ScreenUtil().setSp(30),
                        fontWeight: FontWeight.w500
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      child: UnicornOutlineButton(
                        strokeWidth: 2,
                        radius: 12,
                        onPressed: (){
                          // setState(() {
                          //   modePress=2;
                          // });
                          // await animationControllerScaleButton.reverse();
                          Navigator.pop(context);
                        },
                        minHeight: ScreenUtil().setWidth(73),
                        minWidth: ScreenUtil().setWidth(200),
                        gradient: LinearGradient(
                            colors:
                            [
                              ColorPallet().mentalMain,
                              ColorPallet().mentalHigh
                            ]),
                        child:  Center(
                          child: Text(
                            'آفلاین بمونه',
                            style: TextStyle(
                              color: ColorPallet().gray,
                              fontSize: ScreenUtil().setSp(30),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                  ),
                  SizedBox(width: ScreenUtil().setWidth(30)),
                  Flexible(
                    child:  GestureDetector(
                      onTap: (){
                        // setState(() {
                        //   modePress=1;
                        // });
                        // await animationControllerScaleButton.reverse();
                        _connectivitySubscription.cancel();
                        _dashboardPresenter.checkNet(context);
                      },
                      child:  Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(20),
                              vertical: ScreenUtil().setWidth(10)
                          ),
                          decoration:  BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  ColorPallet().mentalMain,
                                  ColorPallet().mentalHigh
                                ]
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:  Center(
                              child: Text(
                                'بریم آنلاین',
                                style:  TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(30),
                                    fontWeight: FontWeight.w700
                                ),
                              )
                          )
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setWidth(40),
              )
            ],
          );
          //   BaseBottomSheet(
          //   title: 'ایمپویی عزیز\nمثل اینکه اینترنتت وصل شده، اگه میخای برو حالت آنلاین',
          //   content: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       Flexible(
          //         child:  StreamBuilder(
          //           stream: _animations.squareScaleBackButtonObserve,
          //           builder: (context,snapshotScaleYes){
          //             if(snapshotScaleYes.data != null){
          //               return  Transform.scale(
          //                 scale: modePress == 1 ? snapshotScaleYes.data : 1.0,
          //                 child:  GestureDetector(
          //                   onTap: ()async{
          //                     setState(() {
          //                       modePress=1;
          //                     });
          //                     await animationControllerScaleButton.reverse();
          //                     _dashboardPresenter.checkNet(context);
          //                   },
          //                   child:  Container(
          //                       padding: EdgeInsets.symmetric(
          //                           horizontal: ScreenUtil().setWidth(20),
          //                           vertical: ScreenUtil().setWidth(10)
          //                       ),
          //                       decoration:  BoxDecoration(
          //                         gradient: LinearGradient(
          //                             colors: [ColorPallet().mainColor,ColorPallet().lightMainColor]
          //                         ),
          //                         borderRadius: BorderRadius.circular(12),
          //                       ),
          //                       child:  Center(
          //                           child: Text(
          //                             'میخام',
          //                             style:  TextStyle(
          //                                 color: Colors.white,
          //                                 fontSize: ScreenUtil().setSp(30),
          //                                 fontWeight: FontWeight.w700
          //                             ),
          //                           )
          //                       )
          //                   ),
          //                 ),
          //               );
          //             }else{
          //               return  Container();
          //             }
          //           },
          //         ),
          //       ),
          //       SizedBox(width: ScreenUtil().setWidth(30)),
          //       Flexible(
          //           child:  StreamBuilder(
          //             stream: _animations.squareScaleBackButtonObserve,
          //             builder: (context,snapshotScaleYes){
          //               if(snapshotScaleYes.data != null){
          //                 return  Transform.scale(
          //                   scale: modePress == 2 ? snapshotScaleYes.data : 1.0,
          //                   child:   UnicornOutlineButton(
          //                     strokeWidth: 2,
          //                     radius: 12,
          //                     onPressed: ()async{
          //                       setState(() {
          //                         modePress=2;
          //                       });
          //                       await animationControllerScaleButton.reverse();
          //                       Navigator.pop(context);
          //                     },
          //                     minHeight: ScreenUtil().setWidth(73),
          //                     minWidth: ScreenUtil().setWidth(200),
          //                     gradient: LinearGradient(
          //                         colors:
          //                         [ColorPallet().mainColor,
          //                           ColorPallet().lightMainColor
          //                         ]),
          //                     child:  Center(
          //                       child: Text(
          //                         'نمیخام',
          //                         style: TextStyle(
          //                           color: ColorPallet().mainColor,
          //                           fontSize: ScreenUtil().setSp(30),
          //                           fontWeight: FontWeight.w700,
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 );
          //               }else{
          //                 return  Container();
          //               }
          //             },
          //           )
          //       )
          //     ],
          //   ),
          // );
        }
      );
    }
  }




  checkIsAnim()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // if(prefs.getBool('isAnim')){
    //   if(this.mounted){
    //     setState(() {
    //       isAnim = true;
    //     });
    //   }
    //   prefs.setBool('isAnim',false);
    // }else{
    //   if(this.mounted){
    //     setState(() {
    //       isAnim = false;
    //     });
    //   }
    // }
    if(prefs.getBool('isAnim')!){
      Timer(Duration(milliseconds: 1500),(){
        setState(() {
          showCycle = true;
        });
      });
    }else{
      setState(() {
        showCycle = true;
      });
    }
  }

  checkStatus()async{
    List<CycleViewModel>? cycles = await _dashboardPresenter.getAllCirclesOfflineMode();
    CycleViewModel lastCycle = cycles![cycles.length-1];
    int status = lastCycle.status == 0 ? 1 : lastCycle.status!;
    _dashboardPresenter.setStatus(status);
    _dashboardPresenter.setAllCycles();
    _dashboardPresenter.setAllMotivalMessages();
    _dashboardPresenter.setTypeCalendarAndNationality();
    _dashboardPresenter.setRegister();

    if(status == 2){
      _dashboardPresenter.generateWeekPregnancyOfflineMode(cycles,pregnancyAndBreastfeedingLimitWeek);
    }else if(status == 3){
      _dashboardPresenter.generateWeekBreastfeedingOfflineMode(cycles,pregnancyAndBreastfeedingLimitWeek);
    }else{
      checkTheTodayAndEndCircle();
    }
    // _dashboardPresenter.generateBottomMessages();
    /// if(!_dashboardPresenter.isLoadingDashBoard.isClosed){
    ///   _dashboardPresenter.isLoadingDashBoard.sink.add(false);
    /// }
  }

  @override
  void dispose() {
    animationControllerScaleButton.dispose();
    _controller.dispose();
    _connectivitySubscription.cancel();
    pregnancyAndBreastfeedingLimitWeek.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = .5;
    width = MediaQuery.of(context).size.width;
    height= MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              ListView(
                children: [
                  tryNet(),
                  AnimatedCrossFade(
                      firstChild: Container(),
                      secondChild: Container(
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setWidth(80),
                              bottom: ScreenUtil().setWidth(65)
                          ),
                          color: Colors.white,
                          width: width,
                          child: StreamBuilder(
                            stream: _dashboardPresenter.statusObserve,
                            builder: (context,snapshotStatus){
                              if(snapshotStatus.data != null){
                                if(snapshotStatus.data == 2){
                                  return pregnancyCycle();
                                }else if(snapshotStatus.data == 3){
                                  return breastfeedingCycle();
                                }else{
                                  return menstruationCycle();
                                }
                              }else{
                                return Container();
                              }
                            },
                          )
                      ),
                      crossFadeState: !showCycle ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      duration: Duration(milliseconds: 900)
                  ),
                  StreamBuilder(
                    stream: _dashboardPresenter.statusObserve,
                    builder: (context,snapshotStatus){
                      if(snapshotStatus.data != null){
                        return StreamBuilder(
                          stream: _dashboardPresenter.bottomMessageOfflineModeObserve,
                          builder: (context,AsyncSnapshot<List<DashBoardMsgOfflineMode>>sugMessage){
                            if(sugMessage.data != null){
                              return Column(
                                children: [
                                  sugMessage.data!.isNotEmpty &&  sugMessage.data!.length > 0 ?
                                  BoxMessages(
                                    value:   sugMessage.data![0].text,
                                    color: Color(0xffF1F1F1),
                                    borderColor: Color(0xffCCCCCC),
                                    // link: sugMessage[0].link,
                                    id : sugMessage.data![0].id,
                                    margin: 40,
                                  )
                                      :  Container(),
                                  sugMessage.data!.isNotEmpty &&  sugMessage.data!.length > 1 ?
                                  BoxMessages(
                                    borderColor: Color(0xffCCCCCC),
                                    color: Color(0xffF1F1F1),
                                    value: sugMessage.data![1].text,
                                    // link: sugMessage[1].link,
                                    id : sugMessage.data![1].id,
                                    margin: 40,
                                  )
                                      :  Container(),
                                ],
                              );
                            }else{
                              return Container();
                            }
                          },
                        );
                      }else{
                        return Container();
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setWidth(70),
                        bottom: ScreenUtil().setWidth(50)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ItemOfflineModeButton(
                          title: 'تقویم',
                          onPress: () {
                            _dashboardPresenter.gotoCalendar(context,_calenderPresenter);
                          },
                          icon: 'assets/images/offline_calendar.svg',
                        ),
                        SizedBox(width: ScreenUtil().setWidth(40)),
                        ItemOfflineModeButton(
                          title: 'یادآور',
                          onPress: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    duration: Duration(milliseconds: 500),
                                    child: AlarmsScreen(
                                      isOfflineMode: true,
                                    )
                                )
                            );
                          },
                          icon: 'assets/images/offline_alarm.svg',
                        ),
                      ],
                    ),
                  )
                ],
              ),
              StreamBuilder(
                stream: pregnancyAndBreastfeedingLimitWeek.isShowCheckPregnancyWeekDialogObserve,
                builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog) {
                  if (snapshotIsShowDialog.data != null) {
                    if (snapshotIsShowDialog.data!) {
                      return  StreamBuilder(
                        stream: pregnancyAndBreastfeedingLimitWeek.isPregnancyDialogObserve,
                        builder: (context,AsyncSnapshot<bool>snapshotIsPregnancy){
                          if(snapshotIsPregnancy.data != null){
                            return QusDialog(
                              scaleAnim: pregnancyAndBreastfeedingLimitWeek.dialogScaleObserve,
                              onPressCancel: () {
                                // Navigator.push(
                                //     context,
                                //     PageTransition(
                                //         type: PageTransitionType.fade,
                                //         child:  PeriodDayRegisterScreen(
                                //           hasAbortion: false,
                                //         )
                                //     )
                                // );
                              },
                              value: snapshotIsPregnancy.data! ?
                              'با توجه به اتمام هفته 42 بارداری، لازمه برای استفاده از سایر خدمات ایمپو وضعیت خودت رو مشخص کنی' :
                              '25هفته از زایمانت گذشته و احتمالا پریودت شروع شده از این به بعد با فاز قاعدگی ایمپو کنارت هستیم',
                              title:'ایمپویی عزیز',
                              yesText: snapshotIsPregnancy.data! ?
                              'زایمان' : 'تکمیل اطلاعات فاز قاعدگی',
                              noText: 'ختم بارداری',
                              notCancel: true,
                              onPressYes: () {
                                // Navigator.push(
                                //     context,
                                //     PageTransition(
                                //         child: snapshotIsPregnancy.data ?
                                //         ChangeStatusScreen(
                                //         ) : PeriodDayRegisterScreen(
                                //           hasAbortion: false,
                                //         ),
                                //         type: PageTransitionType.fade)
                                // );
                              },
                              isIcon: true,
                              colors: [
                                Colors.white,
                                Colors.white
                              ],
                              topIcon: snapshotIsPregnancy.data! ?
                              'assets/images/ic_box_question.svg' :
                              'assets/images/correct_dialog.svg',
                              isLoadingButton: false,
                              isOneBtn: !snapshotIsPregnancy.data! ? true : null,
                            );
                          }else{
                            return Container();
                          }
                        },
                      );
                    } else {
                      return  Container();
                    }
                  } else {
                    return  Container();
                  }
                },
              ),
            ],
          )
      )
    );
  }

  checkTheTodayAndEndCircle()async{

    /// if(widget.calenderPresenter.getGridItem().isEmpty){
    ///   widget.calenderPresenter.loadCircleItems(widget.RegisterParamViewModel);
    /// }

    List<CycleViewModel>? circles =  await _dashboardPresenter.getAllCirclesOfflineMode();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int periodDay =  prefs.getInt('periodDay')!;
    int circleDay = prefs.getInt('circleDay')!;

    print(circles!.length);

    /// for(int i=0 ; i<circles.length-1 ; i++){
    ///     if(circles[i].periodStart == circles[i+1].periodStart){
    ///       widget.presenter.removeRecordTable('Circles', circles[i].id);
    ///   }
    ///}


    CycleViewModel lastCircle = circles[circles.length-1];

    // lastCircle.then((value){
    // print('periodStart : ${lastCircle.periodStart}');
    DateTime lastOfCycleEndCircle = DateTime.parse(lastCircle.circleEnd!);

    // print('checkkkkk');

    if(today.isAfter(lastOfCycleEndCircle)){

      DateTime startPeriod = DateTime(lastOfCycleEndCircle.year,lastOfCycleEndCircle.month,lastOfCycleEndCircle.day+1);
      DateTime endCircle = DateTime(lastOfCycleEndCircle.year,lastOfCycleEndCircle.month,lastOfCycleEndCircle.day + circleDay);
      DateTime endPeriod = DateTime(lastOfCycleEndCircle.year,lastOfCycleEndCircle.month,lastOfCycleEndCircle.day+ periodDay);


      // Circle['isSavedToServer'] = 0;
      Circle['periodStartDate'] = startPeriod.toString();
      Circle['cycleEndDate'] = endCircle.toString();
      Circle['periodEndDate'] = endPeriod.toString();
      Circle['status'] = 0;
      // Circle['before'] = lastCircle.before;
      // Circle['after'] = lastCircle.after;
      // Circle['mental'] = lastCircle.mental;
      // Circle['other'] = lastCircle.other;
      // Circle['ovu'] = lastCircle.ovu != null ? lastCircle.ovu : '';

      _dashboardPresenter.insertCycleOfflineMode(Circle);

      checkTheTodayAndEndCircle();


    }else{

      // print(circleModelForSings.before);
      insertDateToLocal(lastCircle);

    }

    // });

  }

  insertDateToLocal(circleModel)async{

//    print('periodEnd ${circleModel.periodEnd}');
//    print('periodStart ${circleModel.periodStart}');
//    print('circleEnd ${circleModel.circleEnd}');

    DateTime startCircle;
    DateTime endCircle;
    DateTime endPeriod;


    startCircle = DateTime.parse(circleModel.periodStart);
    endCircle = DateTime.parse(circleModel.circleEnd);
    endPeriod = DateTime.parse(circleModel.periodEnd);
    lastPeriod = DateTime.parse(circleModel.periodStart);


//    print(endPeriod.difference(startCircle).inDays + 1);


    if(this.mounted){
      setState(() {

        maxDays = MyDateTime().myDifferenceDays(startCircle,endCircle) + 1;

        periodDay =  MyDateTime().myDifferenceDays(startCircle,endPeriod) + 1;

        angleOfDay = (310/(maxDays-1));

        endOfPeriod = periodDay - 1.0;

        endOfCircle = maxDays - 1.0;

      });
    }


    if(this.mounted){
      generateDays(circleModel);
    }


  }

  generateDays(circleModel)async{


    periodStart = Angle.degrees(padding);

    periodEnd = Angle.degrees(angleOfDay) * endOfPeriod;

    pmsStart = Angle.degrees(((angleOfDay) * (endOfCircle - 4)) + padding.toDouble());

    pmsEnd = Angle.degrees((angleOfDay) * 4);

    if((maxDays - 18) <= periodDay){


      fertStart = Angle.degrees((angleOfDay) * (endOfPeriod + 1) + padding.toDouble());

      fertEnd = Angle.degrees((angleOfDay) * (endOfCircle - 10 - periodDay) .toDouble());

//    print('csdc${endOfCircle - 10 - endOfPeriod}');

      fertStartDays = periodDay +1;

      fertEndDays = maxDays - 10;

    }else{


      fertStart = Angle.degrees((angleOfDay) * (endOfCircle - 18) + padding.toDouble());

      fertEnd = Angle.degrees((angleOfDay) * 8 .toDouble());

      fertStartDays = maxDays - 18;

      fertEndDays = maxDays - 10;

    }



    currentToday = MyDateTime().myDifferenceDays(lastPeriod,today) + 1;

    diffDays = MyDateTime().myDifferenceDays(lastPeriod,today);

//    currentToday = 10;


    current =  Angle.degrees(((angleOfDay) * (currentToday - 1)) + padding.toDouble());

    cursor = Angle.degrees(((angleOfDay) * (currentToday - 1)) + 25.toDouble());

//      print(currentToday);

    ovumDay = Angle.degrees((angleOfDay) * (endOfCircle - 13) + padding);

    ovumDayEnd = Angle.degrees(angleOfDay);




    // GenerateDashboardAndNotifyMessages().checkConditionUserWithServer(currentToday, periodDay, maxDays, fertStartDays, fertEndDays, circleModelForSings,widget.RegisterParamViewModel);
    // print(GenerateDashboardMessages().getTimeConditionUser(currentToday,periodDay,maxDays,fertStartDays,fertEndDays) &
    // GenerateDashboardMessages().getWomanSignUser(circleModelForSings) &
    // GenerateDashboardMessages().getSexualUser(widget.RegisterParamViewModel.getSex()) &
    // GenerateDashboardMessages().getAgeUser(widget.RegisterParamViewModel));
    // print('AND');

//    print(currentToday);

    if(currentToday <= periodDay){

      dayMode = 0;
      /*  print('period');*/

    }else if(currentToday >= fertStartDays && currentToday <= fertEndDays){

      dayMode = 1;
//     print('fert');

    }else if(currentToday > maxDays - 5){

      dayMode = 2;
//     print('pms');

    }else{

      dayMode = 3;
//     print('normal');


    }
    _dashboardPresenter.generateMenstruationBottomMessages(currentToday, periodDay, maxDays, fertStartDays, fertEndDays);
    /// widget.presenter.generateSugMessagesAndNotifications(currentToday, periodDay, maxDays, fertStartDays, fertEndDays, circleModelForSings);
    /// widget.presenter.generateBottomMessage(
    ///   currentToday: currentToday,
    ///   periodDay : periodDay,
    ///   maxDays : maxDays,
    ///   fertStartDays : fertStartDays,
    ///   fertEndDays : fertEndDays,
    /// );
  }


  Widget tryNet(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(40)
          ),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              SvgPicture.asset(
                'assets/images/ic_offlineMode.svg',
                width: ScreenUtil().setWidth(80),
                height: ScreenUtil().setWidth(80),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: ScreenUtil().setWidth(40)
                ),
                child: Text(
                  'این صفحه نشان‌دهنده آخرین باری هست که آنلاین شدی. برای مشاهده وضعیت دقیق‌‌تر لازمه که آنلاین بشی',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorPallet().gray,
                    fontWeight: FontWeight.w400,
                    fontSize: ScreenUtil().setWidth(26)
                  ),
                ),
              )
            ],
          ),
        ),
        StreamBuilder(
          stream: _animations.squareScaleBackButtonObserve,
          builder: (context,AsyncSnapshot<double>snapshotScale){
            if(snapshotScale.data != null){
              return Transform.scale(
                scale: modePress == 2 ? snapshotScale.data : 1,
                child: GestureDetector(
                  onTap: ()async{
                    setState(() {
                      modePress=2;
                    });
                    await animationControllerScaleButton.reverse();
                    _dashboardPresenter.checkNet(context);
                  },
                  child:  Container(
                    width: ScreenUtil().setWidth(230),
                    margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(30)
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setWidth(7)
                    ),
                    decoration: BoxDecoration(
                        color: ColorPallet().gray.withOpacity(.15),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'تلاش مجدد',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: ScreenUtil().setSp(28),
                              color: ColorPallet().gray
                          ),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(10)),
                        SvgPicture.asset(
                          'assets/images/ic_repeat_rounded.svg',
                          width: ScreenUtil().setWidth(32),
                          height: ScreenUtil().setWidth(32),
                        ),
                      ],
                    ),
                  ),
                )
              );
            }else{
              return Container();
            }
          },
        )
      ],
    );
  }

  Widget menstruationCycle(){
    return Stack(
      alignment: Alignment.center,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: ScreenUtil().setWidth(620),
              child:  Image.asset(
                dayMode == 0 ? 'assets/gif/ghaedegiG.gif' :
                dayMode == 1 ? 'assets/gif/barvari-fG.gif' :
                dayMode == 2 ? 'assets/gif/pmsG.gif' :
                'assets/gif/rooze-adiG.gif',
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtil().setWidth(180)
              ),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    countDay(),
                    style:  TextStyle(
                      color: generateTextColor(),
                      fontSize: ScreenUtil().setSp(55),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FutureBuilder<String>(
                    future: generateSmallText(),
                    builder: (BuildContext context , AsyncSnapshot<String> snapshot){
                      return   Text(
                        snapshot.data != null ? snapshot.data! : '',
                        style:  TextStyle(
                            color: generateTextColor(),
                            fontSize: ScreenUtil().setSp(32),
                            fontWeight: FontWeight.w500
                        ),
                      );
                    },
                  ),

                ],
              ),
            )
          ],
        ),
        CustomPaint(
          painter: maxDays != 0 ?
          CircleItem(
            context: context,
            width: width,
            height: height,
            periodStart: periodStart,
            periodEnd: periodEnd,
            fertStart: fertStart,
            fertEnd: fertEnd,
            pmsStart: pmsStart,
            pmsEnd: pmsEnd,
            current: current,
            ovum: ovumDay,
            maxDays: maxDays,
            periodDay: periodDay,
            modeDays: dayMode,
//                                    ovumDayEnd : ovumDayEnd,
            currentToday: currentToday,
            dayMode : dayMode,
            fertEndDays: fertEndDays,
            fertStartDays: fertStartDays
          )
              : null,
        ),
        // Padding(
        //     padding: EdgeInsets.only(
        //         top: ScreenUtil().setWidth(300)
        //     ),
        //     child:   FutureBuilder(
        //       future: checkBtnPeriod(),
        //       builder: (context,snapshot){
        //         if(snapshot.data != null){
        //           return snapshot.data;
        //         }else{
        //           return  Container();
        //         }
        //       },
        //     )
        // )
      ],
    );
  }

  Widget pregnancyCycle(){
    return StreamBuilder(
      stream: _dashboardPresenter.pregnancyNumberObserve,
      builder: (context,AsyncSnapshot<PregnancyNumberViewModel>snapshotPregnancy){
        if(snapshotPregnancy.data != null){
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: [
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      ScaleTransition(
                        scale: _tween.animate(
                            CurvedAnimation(
                                parent: _controller,
                                curve: Curves.ease)
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(ScreenUtil().setWidth(80)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(250),
                              child: Image.asset(
                                snapshotPregnancy.data!.weekNoPregnancy! >= 43 ? 'assets/pregnancyImages/week42.jpg'
                                    : 'assets/pregnancyImages/week${snapshotPregnancy.data!.weekNoPregnancy}.jpg',
                                fit: BoxFit.cover,
                              ),
                            )
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: ScreenUtil().setWidth(150),
                          top:  ScreenUtil().setWidth(100),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            weeklyCounterBoxPregnancy(
                                'ماه ${snapshotPregnancy.data!.monthNoPregnancy! <= 9 ? NumberToTextWithM().ConvertWithM(snapshotPregnancy.data!.monthNoPregnancy!) : 'آخر'}',
                                weekNo: '${snapshotPregnancy.data!.weekNoPregnancy}'),
                            SizedBox(height: ScreenUtil().setWidth(15)),
                            weeklyCounterBoxPregnancy(snapshotPregnancy.data!.dayToDelivery != 0 ?
                            '${snapshotPregnancy.data!.dayToDelivery} روز تا زایمان' : 'نزدیک به زایمان')
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(75)),
                      child:        Image.asset(
                        'assets/pregnancyImages/subtraction.png',
                        fit: BoxFit.cover,
                      )
                  ),
                  Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(110)),
                      child: ImageSequenceAnimator(
                        "assets/pregnancyImages",  //folderName
                        "Comp",                                 //fileName
                        0,                                        //suffixStart
                        2,                                        //suffixCount
                        "png",                                    //fileFormat
                        50,
                        isLooping: true,
                        fps: 10,
                      )//frameCount
                  ),
                  Container(
                    width: ScreenUtil().setWidth(530),
                    height: ScreenUtil().setWidth(530),
                    decoration: BoxDecoration(
                      // color: Colors.black,
                        gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.0),
                              Colors.white.withOpacity(0.0),
                              Colors.white.withOpacity(0.0),
                              // Colors.white.withOpacity(0.0),

                              Colors.white.withOpacity(0.9),
                              Colors.white.withOpacity(1.0),
                            ],
                            radius: 0.75
                        ),
                        borderRadius: BorderRadius.circular(250)
                    ),
                  ),
                  UnicornOutlineButton(
                      strokeWidth: 2.5,
                      radius: 250,
                      onPressed: (){},
                      gradient: LinearGradient(
                          colors:
                          [ColorPallet().mainColor,
                            Color(0xffE878D3)
                          ]),
                      child: Container(
                        width: ScreenUtil().setWidth(535),
                        height: ScreenUtil().setWidth(535),
                      )
                  ),
                ],
              ),
              CustomPaint(
                painter: PregnancyPaint(
                    width: width,
                    currentWeek: snapshotPregnancy.data!.weekNoPregnancy,
                    maxWeeks: snapshotPregnancy.data!.weekNoPregnancy! <= 40 ? 40 : snapshotPregnancy.data!.weekNoPregnancy,
                    context: context
                ),
              ),
              // Padding(
              //     padding: EdgeInsets.only(
              //         top: ScreenUtil().setWidth(350)
              //     ),
              //     child: myStatusBtn(false)
              // )
            ],
          );
        }else{
          return Container();
        }
      },
    );
  }

  Widget weeklyCounterBoxPregnancy(String text,{String? weekNo}){
    return  Container(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(15),
          vertical: ScreenUtil().setWidth(3)
      ),
      decoration: BoxDecoration(
          color: Color(0XFFFFE8F7).withOpacity(0.7),
          borderRadius: BorderRadius.circular(10)
      ),
      child: weekNo != null ?
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              '$text (‌‌‌‌ هفته',
              style : TextStyle(
                  color: ColorPallet().black,
                  fontSize: ScreenUtil().setWidth(26),
                  fontWeight: FontWeight.w500
              )
          ),
          Text(
              ' $weekNo',
              style : TextStyle(
                  color: ColorPallet().black,
                  fontSize: ScreenUtil().setWidth(26),
                  fontWeight: FontWeight.w800
              )
          ),
          Text(
              ' )',
              style : TextStyle(
                  color: ColorPallet().black,
                  fontSize: ScreenUtil().setWidth(26),
                  fontWeight: FontWeight.w500
              )
          ),
        ],
      ) :
      Text(
          text,
          style : TextStyle(
              color: ColorPallet().black,
              fontSize: ScreenUtil().setWidth(26),
              fontWeight: FontWeight.w500
          )
      ),
    );
  }


  Widget breastfeedingCycle(){
    return Column(
      children: [
        StreamBuilder(
          stream: _dashboardPresenter.breastfeedingNumbersObserve,
          builder: (context,AsyncSnapshot<BreastfeedingNumberModel>snapshotBreastfeedingNumbers){
            if(snapshotBreastfeedingNumbers.data != null){
              return Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .center,
                children: [
                  Text(
                    'هفته ${NumberToTextWithM().ConvertWithM(snapshotBreastfeedingNumbers.data!.breastfeedingCurrentWeek)} شروع مادری',
                    style:
                    TextStyle(
                        color: ColorPallet().gray,
                        fontSize: ScreenUtil().setSp(28),
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  Text(
                    ' (ماه ${NumberToTextWithM().ConvertWithM(snapshotBreastfeedingNumbers.data!.breastfeedingCurrentMonth)})',
                    style: TextStyle(
                        color:
                        ColorPallet().black,
                        fontSize: ScreenUtil().setSp(28),
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ],
              );
            }else{
              return Container();
            }
          },
        ),
        SizedBox(height: ScreenUtil().setHeight(20)),
        Image.asset(
          'assets/images/breastfeeding_main.png',
          fit: BoxFit.cover,
        )
      ],
    );
  }

  String generateBigText(){

    switch(dayMode){

      case 0 : {

        return 'پریود';

      }


      case 1 : {

        return 'باروری بالا';

      }


      case 2 : {

        return 'دوره pms';

      }


      default: {

        return 'روز عادی';

      }

    }

  }

  Future<String> generateSmallText()async{

    if(dayMode == 0){

      int daysEndOFPeriod;

      daysEndOFPeriod = periodDay - diffDays;

      return '${NumberToTextWithM().Conver(daysEndOFPeriod)} روز تا پایان پریود';

    }else if(dayMode == 1){

      int daysStartOfPeriod;

      daysStartOfPeriod = maxDays - diffDays;

      return '$daysStartOfPeriod روز تا پریود بعدی';

    }else if(dayMode == 2){

      int daysStartOfPeriod;

      daysStartOfPeriod = maxDays - diffDays;

      return '$daysStartOfPeriod روز تا پریود بعدی';

    }else{

      return 'تا آغاز پریود بعدی';

    }

  }

  String countDay(){

    if(dayMode == 0){

      return "روز ${NumberToTextWithM().ConvertWithM(currentToday)}";

    }else if(dayMode == 1){

      if(currentToday == maxDays - 13){
        return 'روز تخمک ‌گذاری';
      }else{
        return 'دوره باروری';
      }

    }else if(dayMode == 2){

      return 'PMS';

    }else{

      return '${maxDays - diffDays}روز ';

    }

    // return "روز ${NumberToText().ConvertWithM(currentToday)} دوره";

  }

  Color generateTextColor(){
    if(dayMode == 0){

      return Color(0xffC83C99);

    }else if(dayMode == 1){

      return Color(0xff48D9DC);

    }else if(dayMode == 2){

      return Color(0xff8767C6);

    }else{

      return Color(0xffA02295);

    }
  }

  @override
  void onError(msg) {

  }

  @override
  void onSuccess(value) {
  }

}