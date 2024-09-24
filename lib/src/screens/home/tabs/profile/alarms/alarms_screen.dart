

import 'dart:async';
import 'dart:io';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' as time;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/profile_presenter.dart';
import 'package:impo/src/architecture/view/profile_view.dart';
import 'package:impo/src/components/action_manage_overlay.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/dialogs/qus_dialog.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/dailyReminders/main_list_reminders_model.dart';
import 'package:impo/src/screens/home/tabs/profile/alarms/help_alarms.dart';
import 'package:impo/src/screens/home/tabs/profile/alarms/list_alarms_screen.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../firebase_analytics_helper.dart';


class AlarmsScreen extends StatefulWidget{

  final isOfflineMode;

  AlarmsScreen({Key? key,this.isOfflineMode}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AlarmsScreenState();

}

class AlarmsScreenState extends State<AlarmsScreen> with TickerProviderStateMixin implements ProfileView{


  late ProfilePresenter _presenter;

  AlarmsScreenState(){
    _presenter = ProfilePresenter(this);
  }

  late AnimationController animationControllerDialog;
  ScrollController _scrollController =  ScrollController();
  late AnimationController animationControllerScaleButtons;
  Animations _animations =  Animations();

  final isShowCanDrawOverlaysDialog = BehaviorSubject<bool>.seeded(false);
  final dialogScale = BehaviorSubject<double>.seeded(0.0);

  Stream<bool> get isShowCanDrawOverlaysDialogObserve => isShowCanDrawOverlaysDialog.stream;
  Stream<double> get dialogScaleObserve => dialogScale.stream;
//
//  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
//    _initLocalNotifications();
//    getAllDailyReminders();
    AnalyticsHelper().log(AnalyticsEvents.AlarmsPg_Self_Pg_Load);
    _presenter.initSetLengthActiveReminders();
    initialDialogScale(this);
    animationControllerScaleButtons = _animations.pressButton(this);
    super.initState();
  }



  Future<bool> checkCanDrawOverlays()async{
    if(Platform.isIOS){
      return true;
    }else{
      return await ActionManageOverlay.canDrawOverlays;
    }
  }

  initialDialogScale(_this){
    animationControllerDialog = AnimationController(
        vsync: _this,
        lowerBound: 0.0,
        upperBound: 1,
        duration: Duration(milliseconds: 250));
    animationControllerDialog.addListener(() {
      dialogScale.sink.add(animationControllerDialog.value);
    });
  }

//  List<DailyReminders> dialy = [];
//
//  getAllDailyReminders()async{
//    List<DailyReminders> _list = await db.getAllDailyReminders();
////    print(_list[0].time);
//   setState(() {
//     dialy = _list;
//   });
//  }

  @override
  void dispose() {
    isShowCanDrawOverlaysDialog.close();
    dialogScale.close();
    super.dispose();
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.AlarmsPg_Back_NavBar_Clk);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    time.timeDilation = 0.5;
    return  WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child:  Scaffold(
            backgroundColor: Colors.white,
            body:  Stack(
              children: <Widget>[
                 Column(
                  children: <Widget>[
                     Padding(
                      padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(40)),
                      child:  CustomAppBar(
                        messages: false,
                        profileTab: true,
                        isEmptyLeftIcon: widget.isOfflineMode ? true : null,
                        icon: 'assets/images/ic_arrow_back.svg',
                        titleProfileTab: 'صفحه قبل',
                        subTitleProfileTab: 'یادآورهای روزانه',
                        onPressBack: (){
                          AnalyticsHelper().log(AnalyticsEvents.AlarmsPg_Back_Btn_Clk);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child:  Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(360),
                            ),
                            child: SvgPicture.asset(
                              'assets/images/ic_alarm.svg',
                              width: ScreenUtil().setWidth(150),
                              height: ScreenUtil().setWidth(150),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: ScreenUtil().setWidth(20),
                            ),
                            child: Text(
                              'یادآورهای روزانه',
                              style:  context.textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(30)
                      ),
                      child: Text(
                        'با استفاده از این یادآورها قراره بیشتر مراقب خودمون باشیم',
                        textAlign: TextAlign.center,
                        style:  context.textTheme.bodyMedium!.copyWith(
                          color: Color(0xff707070),
                        ),
                      ),
                    ),
                     Expanded(
                        child:    Directionality(
                          textDirection: TextDirection.ltr,
                          child:  Theme(
                            data: Theme.of(context).copyWith(
                                highlightColor: Color(0xfff7b3e9)
                            ),
                            child:  Scrollbar(
                                child:  NotificationListener<OverscrollIndicatorNotification>(
                                  onNotification: (overscroll) {
                                    overscroll.disallowIndicator();
                                    return true;
                                  },
                                  child:   FadingEdgeScrollView.fromScrollView(
                                    // shouldDisposeScrollController: true,
                                    gradientFractionOnEnd: .9,
                                    gradientFractionOnStart: .9,
                                    child:  ListView.separated(
                                      controller: _scrollController,
                                      padding: EdgeInsets.only(top: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(50),left: ScreenUtil().setWidth(50),bottom: ScreenUtil().setWidth(30)),
                                      itemCount: mainReminders.length,
                                      separatorBuilder: (context,index){
                                        return Container(
                                          height: ScreenUtil().setHeight(1),
                                          margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(30)),
                                          color: Colors.grey.withOpacity(0.25),
                                        );
                                      },
                                      itemBuilder: (context,index){
                                        return  StreamBuilder(
                                          stream: _presenter.isLoadingObserve,
                                          builder: (context,AsyncSnapshot<bool>snapshotLoading){
                                            if(snapshotLoading.data != null){
                                              if(snapshotLoading.data!){
                                                return  StreamBuilder(
                                                  stream: _presenter.lengthActiveRemindersObserve,
                                                  builder: (context,AsyncSnapshot<List<int>>snapshotLengthActiveReminders){
                                                    if(snapshotLengthActiveReminders.data != null){
                                                      return Column(
                                                        children: [
                                                          index == 0 && snapshotLengthActiveReminders.data.toString() != '[0, 0, 0, 0, 0, 0, 0, 0]' ?
                                                              Padding(
                                                                padding: EdgeInsets.only(
                                                                  bottom: ScreenUtil().setWidth(50)
                                                                ),
                                                                child: CustomButton(
                                                                  title: 'مشکلی در دریافت یادآورها دارم',
                                                                  onPress: (){
                                                                    AnalyticsHelper().log(AnalyticsEvents.AlarmsPg_IProblemReceivingReminder_Btn_Clk);
                                                                    Navigator.push(
                                                                        context,
                                                                        PageTransition(
                                                                            type: PageTransitionType.fade,
                                                                            child: HelpAlarms(
                                                                              isOfflineMode: widget.isOfflineMode,
                                                                            )
                                                                        )
                                                                    );
                                                                  },
                                                                  margin: 50,
                                                                  colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                                                                  enableButton: true,
                                                                )
                                                                // FlatButton(
                                                                //   color: ColorPallet().mainColor,
                                                                //   onPressed: (){
                                                                //     Navigator.push(
                                                                //       context,
                                                                //       PageTransition(
                                                                //         type: PageTransitionType.fade,
                                                                //         child: HelpAlarms()
                                                                //       )
                                                                //     );
                                                                //   },
                                                                //   child: Text(
                                                                //       'مشکلی در دریافت یادآورها دارم',
                                                                //       style: TextStyle(
                                                                //         color: Colors.white,
                                                                //         fontSize: ScreenUtil().setSp(28)
                                                                //       ),
                                                                //   ),
                                                                // )
                                                              )
                                                          : Container(),
                                                           StreamBuilder(
                                                            stream: _animations.squareScaleBackButtonObserve,
                                                            builder: (context,AsyncSnapshot<double>snapshotScale){
                                                              if(snapshotScale.data != null){
                                                                return  Transform.scale(
                                                                    scale: mainReminders[index].selected! ? snapshotScale.data : 1,
                                                                    child:   GestureDetector(
                                                                        onTap: ()async{
                                                                          animationControllerScaleButtons.reverse();
                                                                          for(int i=0;i<mainReminders.length;i++){
                                                                            mainReminders[i].selected = false;
                                                                          }
                                                                          mainReminders[index].selected = !mainReminders[index].selected!;
                                                                          Timer(Duration(milliseconds: 100),(){
                                                                            AnalyticsHelper().log(
                                                                                AnalyticsEvents.AlarmsPg_AlarmsList_Item_Clk,
                                                                                parameters: {
                                                                                  'index' : index.toString()
                                                                                }
                                                                            );
                                                                            Navigator.push(
                                                                                context,
                                                                                PageTransition(
                                                                                    type: PageTransitionType.fade,
                                                                                    child:  ListAlarmsScreen(
                                                                                      indexAlarm: index,
                                                                                      presenter: _presenter,
                                                                                      isShowCanDrawOverLayerDialog: false,
                                                                                      isTwoBack: false,
                                                                                      isOfflineMode: widget.isOfflineMode,
                                                                                    )
                                                                                )
                                                                            );
                                                                          });
                                                                        },
                                                                        child: Directionality(
                                                                            textDirection: TextDirection.rtl,
                                                                            child:  Container(
                                                                              height: ScreenUtil().setWidth(80),
                                                                              color: Colors.white,
                                                                              child:  Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: <Widget>[
                                                                                  Flexible(
                                                                                    flex: 3,
                                                                                    child: Stack(
                                                                                      alignment: Alignment.centerRight,
                                                                                      children: [
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Flexible(
                                                                                              child: Align(
                                                                                                alignment: Alignment.center,
                                                                                                child: SvgPicture.asset(
                                                                                                  mainReminders[index].icon!,
                                                                                                  width: ScreenUtil().setWidth(60),
                                                                                                  height: ScreenUtil().setWidth(60),
                                                                                                  colorFilter: widget.isOfflineMode ?
                                                                                                  ColorFilter.mode(
                                                                                                    Color(0xffE2E2E2),
                                                                                                    BlendMode.srcIn
                                                                                                  ) : null
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Flexible(
                                                                                              flex: 5,
                                                                                              child: Container(),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                        Padding(
                                                                                          padding:  EdgeInsets.only(
                                                                                            right: ScreenUtil().setWidth(110)
                                                                                          ),
                                                                                          child: Text(
                                                                                            mainReminders[index].title!,
                                                                                            textAlign: TextAlign.right,
                                                                                            style:  context.textTheme.bodySmall,
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    )
                                                                                  ),
                                                                                  Flexible(
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        snapshotLengthActiveReminders.data![index] != 0 ?
                                                                                        Container(
                                                                                          height: ScreenUtil().setWidth(48),
                                                                                          width: ScreenUtil().setWidth(48),
                                                                                          margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
                                                                                          decoration:  BoxDecoration(
                                                                                              shape: BoxShape.circle,
                                                                                              color: ColorPallet().mainColor
                                                                                          ),
                                                                                          child:  Center(
                                                                                            child:  Text(
                                                                                              snapshotLengthActiveReminders.data![index].toString(),
                                                                                              style:  context.textTheme.labelMediumProminent!.copyWith(
                                                                                                color: Colors.white,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        )
                                                                                            :  Container(),
                                                                                        SvgPicture.asset(
                                                                                          'assets/images/ic_arrow_back.svg',
                                                                                          width: ScreenUtil().setWidth(35),
                                                                                          height: ScreenUtil().setWidth(35),
                                                                                          colorFilter: ColorFilter.mode(
                                                                                              ColorPallet().black,
                                                                                            BlendMode.srcIn
                                                                                          ),
                                                                                          // fit: BoxFit.cover,
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            )
                                                                        )
                                                                    )
                                                                );
                                                              }else{
                                                                return  Container();
                                                              }
                                                            },
                                                          )
                                                        ],
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
                                        );
                                      },
                                    ),
                                  ),
                                )
                            ),
                          ),
                        )
                    )
                  ],
                ),
                 StreamBuilder(
                  stream: isShowCanDrawOverlaysDialogObserve,
                  builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog){
                    if(snapshotIsShowDialog.data != null){
                      if(snapshotIsShowDialog.data!){
                        return  QusDialog(
                          scaleAnim: dialogScaleObserve,
                          onPressCancel: ()async{
                            await animationControllerDialog.reverse();
                            if(!isShowCanDrawOverlaysDialog.isClosed){
                              isShowCanDrawOverlaysDialog.sink.add(false);
                            }
                          },
                          value: "برای نمایش بهتر یاد‌آور‌ها، لازمه که به ایمپو مجوز نمایش بدی",
                          yesText: 'اجازه میدم',
                          noText: 'نه!',
                          onPressYes: ()async{
                            await ActionManageOverlay.goToSettingPermissionOverlay();
                            await animationControllerDialog.reverse();
                            if(!isShowCanDrawOverlaysDialog.isClosed){
                              isShowCanDrawOverlaysDialog.sink.add(false);
                            }
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
                )
              ],
            )
        ),
      ),
    );
  }

//  Future<Null> _selectDate(BuildContext context,index) async {
//    TimeOfDay time = await showTimePicker(
//      context: context,
//      initialTime: TimeOfDay.now(),
//      helpText: '',
//      cancelText: 'لغو',
//     confirmText: 'تایید'
//    );
//    setState(() {
//      if(time != null) dialy[index].time = time.format(context);
//     });
//    setAlarm(index);
////    if (picked != null && picked != selectedDate)
////      setState(() {
////        selectedDate = picked;
////      });
//  }
//
//  setAlarm(index)async{
////
////  SharedPreferences prefs = await SharedPreferences.getInstance();
//
////    print(int.parse(dialy[index].time.substring(0,2)));
////    print(int.parse(dialy[index].time.substring(3,5)));
//
//
//    if(Platform.isIOS){
//
//      var androidChannel = AndroidNotificationDetails(
//        'reminders$index' , 'channel_name' , 'channel_description',
//        importance: Importance.Max,
//        priority: Priority.Max,
//        vibrationPattern: Int64List(1000),
//        largeIcon: DrawableResourceAndroidBitmap('impo_icon'),
//        icon: 'impo_icon' ,
//        playSound:  dialy[index].isSound == 1 ? true : false,
//        sound:  index == 0 ? RawResourceAndroidNotificationSound('sound_water') : index == 1 ? RawResourceAndroidNotificationSound('sound_study') : index == 2 ?
//        RawResourceAndroidNotificationSound('sound_drug') : index == 3 ? RawResourceAndroidNotificationSound('sound_fruit')
//            : index == 4 ? RawResourceAndroidNotificationSound('sound_sport') : index == 5 ? RawResourceAndroidNotificationSound('sound_sleep') : RawResourceAndroidNotificationSound('sound_other') ,
//        styleInformation: BigTextStyleInformation(''),
//      );
//
//      var iosChannel = IOSNotificationDetails(
//        presentSound: dialy[index].isSound == 1 ? true : false,
//        sound: index == 0 ? 'sound_water.aiff' : index == 1 ? 'sound_study.aiff' : index == 2 ?
//        'sound_drug.aiff' : index == 3 ? 'sound_fruit.aiff' : index == 4 ? 'sound_sport.aiff' : index == 5 ? 'sound_sleep.aiff' : 'sound_other.aiff' ,
//      );
//
//      NotificationDetails platformChannel = NotificationDetails(androidChannel,iosChannel);
//
//      await NotificationInit.getGlobal().getNotify().showDailyAtTime(
//        int.parse('1$index'),
//        dialy[index].title,
//        index == 0 ? 'ایمپویی عزیز نوشیدن آب کافی، مهم تر از چیزیه که فکرشو کنی!' :
//        index == 1 ? "دوست خوبم امروز قراره چه کتابی بخونی؟" :
//        index == 2 ? "ایمپویی عزیز وقتشه که داروهاتو بخوری" :
//        index == 3 ? "دوست خوبم امروز میوه خوردی؟" :
//        index == 4 ?  "وقت ورزشه!" :
//        index == 5 ? "ایمپویی عزیز خواب به موقع و کافی رو دست کم نگیر" :
//        "ایمپویی جان امروز چند ساعت با گوشیت وقت گذروندی؟ " ,
//        Time(
//            int.parse(dialy[index].time.substring(0,2)),
//            int.parse(dialy[index].time.substring(3,5)),
//            0
//        ),
//        platformChannel,
//        payload: index == 0 ? '${dialy[index].title}/ایمپویی عزیز نوشیدن آب کافی، مهم تر از چیزیه که فکرشو کنی!/ممنون از یادآوریت' :
//        index == 1 ? "${dialy[index].title}/دوست خوبم امروز قراره چه کتابی بخونی؟/این کتاب من کجاس؟" :
//        index == 2 ? "${dialy[index].title}/ایمپویی عزیز وقتشه که داروهاتو بخوری/ممنون از یادآوریت" :
//        index == 3 ? "${dialy[index].title}/دوست خوبم امروز میوه خوردی؟/ممنون از یادآوریت" :
//        index == 4 ?  "${dialy[index].title}/وقت ورزشه!/لباس ورزشی منو ندیدی؟" :
//        index == 5 ? "${dialy[index].title}/ایمپویی عزیز خواب به موقع و کافی رو دست کم نگیر/رفتم بخوابم!" :
//        "${dialy[index].title}/ایمپویی جان امروز چند ساعت با گوشیت وقت گذروندی؟/حواسم هست" ,
//      );
//
//    }else{
//
//      DateTime dateTimeForAlarmAndroid;
//      DateTime now = DateTime.now();
//      DateTime timeSelected = DateTime(
//          DateTime.now().year,
//          DateTime.now().month,
//          DateTime.now().day,
//          int.parse(dialy[index].time.substring(0,2)),
//          int.parse(dialy[index].time.substring(3,5)),
//          0
//      );
//
//      if(timeSelected.isAfter(now)){
//        dateTimeForAlarmAndroid =  DateTime(
//            DateTime.now().year,
//            DateTime.now().month,
//            DateTime.now().day,
//            int.parse(dialy[index].time.substring(0,2)),
//            int.parse(dialy[index].time.substring(3,5)),
//            0
//        );
//      }else{
//        dateTimeForAlarmAndroid =  DateTime(
//            DateTime.now().year,
//            DateTime.now().month,
//            DateTime.now().day + 1,
//            int.parse(dialy[index].time.substring(0,2)),
//            int.parse(dialy[index].time.substring(3,5)),
//            0
//        );
//
//      }
//
////      prefs.setInt('index', index);
////      prefs.setInt('isSound', dialy[index].isSound);
//
//      AndroidAlarmManager.oneShotAt(
//          dateTimeForAlarmAndroid,
//          int.parse('1$index'),
//        callbackAlarmReminders,
//          wakeup: true,
//          exact: true,
//          rescheduleOnReboot: true,
//          allowWhileIdle: true,
//          sound: dialy[index].isSound,
//      );
//
//    }
//
//
//
////    updateDb(index);
//
//
//  }

  @override
  void onError(msg) {

  }

  @override
  void onSuccess(value) {

  }
//
//  updateDb(index){
////    print('update');
////    print(dialy[index].isActive);
//    db.updateTables(
//      'DailyReminders',
//        {
//          'title' : dialy[index].title,
//          'time' : dialy[index].time,
//          'isSound' : dialy[index].isSound,
//          'isActive' : dialy[index].isActive,
//        },
//      dialy[index].id
//    );
//
//    Timer(Duration(seconds: 2),()async{
//      List<DailyReminders> l = await db.getAllDailyReminders();
////      print(l[0].isActive);
//    });
//
//  }

}

//                           ListView.separated(
//                            shrinkWrap: true,
//                            padding: EdgeInsets.only(top: ScreenUtil().setWidth(50),right: ScreenUtil().setWidth(50),left: ScreenUtil().setWidth(50)),
//                            physics: NeverScrollableScrollPhysics(),
//                            itemCount: dialy.length,
//                            separatorBuilder: (context,index){
//                              return  Container(
//                                height: ScreenUtil().setHeight(1),
//                                margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(10)),
//                                color: Colors.grey,
//                              );
//                            },
//                            itemBuilder: (context,index){
//                              return  Row(
//                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                children: <Widget>[
//                                   Text(
//                                    dialy[index].title,
//                                    style:  TextStyle(
//                                        fontSize: ScreenUtil().setSp(30)
//                                    ),
//                                  ),
//                                   Row(
//                                    children: <Widget>[
//                                      dialy[index].isActive == 1 ?
//                                       Row(
//                                        children: <Widget>[
//                                           GestureDetector(
//                                            onTap: ()async{
//                                              setState(() {
//                                                dialy[index].isSound == 1 ? dialy[index].isSound = 0 : dialy[index].isSound = 1;
//                                              });
//                                              setAlarm(index);
//                                            },
//                                            child:  Container(
//                                                height: ScreenUtil().setWidth(50),
//                                                width: ScreenUtil().setWidth(80),
//                                                padding: EdgeInsets.all(ScreenUtil().setWidth(7)),
//                                                decoration:  BoxDecoration(
//                                                    borderRadius: BorderRadius.circular(7),
//                                                    border: Border.all(
//                                                        color:  dialy[index].isSound == 1 ?  ColorPallet().mainColor : Color(0xff707070),
//                                                        width: .5
//                                                    )
//                                                ),
//                                                child:  Image.asset(
//                                                  dialy[index].isSound == 1 ? 'assets/images/volume_up.png' : 'assets/images/volume_off.png',
//                                                  fit: BoxFit.fitHeight,
//                                                  color: dialy[index].isSound == 1 ? ColorPallet().mainColor  : Color(0xff9D9D9D) ,
//                                                )
//                                            ),
//                                          ),
//                                           SizedBox(width: ScreenUtil().setWidth(30)),
//                                           Theme(
//                                            data: Theme.of(context).copyWith(
//
//                                              colorScheme: ColorScheme.light(
//                                                primary: ColorPallet().mainColor,
//                                                background: Colors.green,
//                                                onBackground: Colors.black,
//                                                onPrimary: Colors.white,
//                                                secondary: Colors.amber,
//                                                onSecondary: Colors.amber,
//                                              )
//                                            ),
//                                            child:  Builder(
//                                              builder: (context) =>  GestureDetector(
//                                                onTap: ()async{
//                                                  _selectDate(context, index);
//                                                },
//                                                child:  Container(
//                                                    height: ScreenUtil().setWidth(50),
//                                                    width: ScreenUtil().setWidth(120),
//                                                    decoration:  BoxDecoration(
//                                                        borderRadius: BorderRadius.circular(7),
//                                                        border: Border.all(
//                                                            color:  Color(0xff707070),
//                                                            width: .5
//                                                        )
//                                                    ),
//                                                    child:  Center(
//                                                        child:   Text(
//                                                          dialy[index].time,
//                                                        )
//                                                    )
//                                                ),
//                                              ),
//                                            ),
//                                          )
//                                        ],
//                                      ) :  Container(),
//                                      Transform.scale(
//                                          scale: .7,
//                                          child:  CupertinoSwitch(
//                                            value: dialy[index].isActive == 1 ? true : false,
//                                            activeColor: ColorPallet().mainColor,
//                                            onChanged: (bool value)async{
//                                                if(!await checkCanDrawOverlays() && dialy[index].isActive == 0){
//                                                  Timer(Duration(milliseconds: 50),()async{
//                                                    animationControllerDialog.forward();
//                                                    if(!isShowCanDrawOverlaysDialog.isClosed){
//                                                      isShowCanDrawOverlaysDialog.sink.add(true);
//                                                    }
//                                                  });
//                                                }
//                                                setState(() {
//                                                  value == true ? dialy[index].isActive = 1 : dialy[index].isActive = 0;
//                                                });
//                                                if(dialy[index].isActive == 0){
//                                                  if(Platform.isIOS){
//                                                    await NotificationInit.getGlobal().getNotify().cancel(int.parse('1$index'));
//                                                  }else{
//                                                    await AndroidAlarmManager.cancel(int.parse('1$index'));
//                                                  }
//                                                  updateDb(index);
//                                                }else{
//                                                  setAlarm(index);
//                                                }
//                                            },
//                                          )
//                                      )
//                                    ],
//                                  )
//                                ],
//                              );
//                            },
//                          )