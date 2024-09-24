

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/profile_presenter.dart';
import 'package:impo/src/architecture/view/profile_view.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/dialogs/qus_dialog.dart';
import 'package:impo/src/components/text_field_area.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/calender/alarm_model.dart';
import 'package:impo/src/models/dailyReminders/sub_main_list_reminders_model.dart';
import 'package:impo/src/screens/home/tabs/profile/alarms/list_alarms_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../firebase_analytics_helper.dart';

class AddAlarmScreen extends StatefulWidget{

  final indexAlarm;
  final mode;
  final DailyRemindersViewModel? dailyReminders;
  final ProfilePresenter? presenter;
  final isOfflineMode;

  AddAlarmScreen({Key? key,this.indexAlarm,this.dailyReminders,this.mode,this.presenter,this.isOfflineMode}):super(key:key);

  @override
  State<StatefulWidget> createState() => AddAlarmScreenState();
}

class AddAlarmScreenState extends State<AddAlarmScreen> with TickerProviderStateMixin implements ProfileView{

//  ProfilePresenter _presenter;
//
//  AddAlarmScreenState(){
//    _presenter = ProfilePresenter(this);
//  }

  late AnimationController animationControllerScaleButtons;
  Animations _animations =  Animations();

  int modePress =0;

  late String title;

  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.AddAlarmPg_Self_Pg_Load);
    // print(widget.indexAlarm);
    animationControllerScaleButtons = _animations.pressButton(this);
//    initDefaultValue();
    widget.presenter!.initDefaultValueForAddReminder(widget.mode,widget.indexAlarm,widget.dailyReminders);
    widget.presenter!.initialDialogScale(this);
    super.initState();
  }

  initDefaultValue(){
//    if(widget.mode == 1){
//      titleController =  TextEditingController(text: widget.title);
//      time = widget.time;
//
//    }else{
//      titleController =  TextEditingController();
//    }
  }

  @override
  void dispose() {
    animationControllerScaleButtons.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop()async{

//    Navigator.pushReplacement(
////      context,
////      PageTransition(
////        type: PageTransitionType.leftToRight,
////        child:  ListAlarmsScreen(
////          indexAlarm: widget.indexAlarm,
////          presenter: widget.presenter!,
////        )
////      )
////    );
    AnalyticsHelper().log(AnalyticsEvents.AddAlarmPg_Back_NavBar_Clk);
    Navigator.pop(context);
    Timer(Duration(milliseconds: 100),(){
      widget.presenter!.initListReminders(widget.indexAlarm);
    });

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = 0.5;
    return  WillPopScope(
      onWillPop: _onWillPop,
      child:  Directionality(
        textDirection: TextDirection.rtl,
        child:  Scaffold(
            backgroundColor: Colors.white,
            body:  Stack(
              children: [
                 StreamBuilder(
                  stream: widget.presenter!.selectedReminderObserve,
                  builder: (context,AsyncSnapshot<DailyRemindersViewModel>snapshotSelectedReminder){
                    if(snapshotSelectedReminder.data != null){
                      return  SingleChildScrollView(
                        child:  Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Padding(
                              padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(35)),
                              child:  CustomAppBar(
                                messages: false,
                                profileTab: true,
                                icon: 'assets/images/ic_arrow_back.svg',
                                titleProfileTab: 'صفحه قبل',
                                subTitleProfileTab: subMainReminders[widget.indexAlarm].title,
                                isEmptyLeftIcon: widget.isOfflineMode ? true : null,
                                onPressBack: (){
                                  AnalyticsHelper().log(AnalyticsEvents.AddAlarmPg_Back_Btn_Clk);
                                  Navigator.pop(context);
                                  Timer(Duration(milliseconds: 100),(){
                                    widget.presenter!.initListReminders(widget.indexAlarm);
                                  });
//                            Navigator.pushReplacement(
//                                context,
//                                PageTransition(
//                                    type: PageTransitionType.leftToRight,
//                                    child:  ListAlarmsScreen(
//                                      indexAlarm: widget.indexAlarm,
//                                      presenter: widget.presenter!,
//                                    )
//                                )
//                            );
                                },
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(0)
                                ),
                                child:  Theme(
                                  data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: ColorPallet().mainColor,
                                        background: Colors.green,
                                        onBackground: Colors.black,
                                        onPrimary: Colors.white,
                                        secondary: Colors.amber,
                                        onSecondary: Colors.amber,
                                      )
                                  ),
                                  child:  Builder(
                                      builder: (context){
                                        return  StreamBuilder(
                                          stream: _animations.squareScaleBackButtonObserve,
                                          builder: (context,AsyncSnapshot<double>snapshotScale){
                                            if(snapshotScale.data != null){
                                              return  Transform.scale(
                                                scale: modePress == 2 ? snapshotScale.data : 1.0,
                                                child:  GestureDetector(
                                                  onTap: ()async{
                                                    animationControllerScaleButtons.reverse();
                                                    setState(() {
                                                      modePress = 2;
                                                    });
                                                    AnalyticsHelper().log(AnalyticsEvents.AddAlarmPg_ShowDatePicker_Text_Clk);
                                                    Timer(Duration(milliseconds: 100),(){
                                                      widget.presenter!.selectDate(context);
                                                    });
                                                  },
                                                  child:  Text(
                                                    snapshotSelectedReminder.data!.time!,
                                                    textAlign: TextAlign.center,
                                                    style:  context.textTheme.headlineMedium!.copyWith(
                                                      color: ColorPallet().mainColor,
                                                      fontSize: 48
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }else{
                                              return  Container();
                                            }
                                          },
                                        );
                                      }
                                  ),
                                )
                            ),
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(30),
                                    right: ScreenUtil().setWidth(90),
                                    left: ScreenUtil().setWidth(90),
                                  ),
                                  height: ScreenUtil().setHeight(2),
                                  color: ColorPallet().gray.withOpacity(.15),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        right: ScreenUtil().setWidth(90),
                                        left: ScreenUtil().setWidth(90)
                                    ),
                                    child:  Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                          subMainReminders[widget.indexAlarm].icon!,
                                          width: ScreenUtil().setWidth(120),
                                          height: ScreenUtil().setWidth(120),
                                        ),
                                        Flexible(
                                            child:  Padding(
                                              padding: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                                              child:  Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: ScreenUtil().setWidth(50),
                                                        bottom: ScreenUtil().setWidth(20),
                                                        right: ScreenUtil().setWidth(5)
                                                    ),
                                                    child:  Text(
                                                      'عنوان یادآور',
                                                      style:  context.textTheme.bodyMedium!.copyWith(
                                                        color: ColorPallet().gray,
                                                      ),
                                                    ),
                                                  ),
                                                  TextFieldArea(
                                                    label: '',
                                                    isEmail: true,
                                                    textController: widget.presenter!.titleController,
                                                    readOnly: false,
                                                    editBox: false,
                                                    bottomMargin: 0,
                                                    topMargin: 0,
                                                    obscureText: false,
                                                    keyboardType:  TextInputType.text,
                                                    notFlex: true,
                                                    inputReminder: true,
                                                    maxLength: 15,
                                                    onChanged: (value){
                                                      setState(() {
                                                        title = value;
                                                      });
                                                      widget.presenter!.onChangedTile(value);
                                                    },
                                                    textColor: ColorPallet().black,
                                                  ),
                                                ],
                                              ),
                                            )
                                        ),
                                      ],
                                    )
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(70),
                                    right: ScreenUtil().setWidth(90),
                                    left: ScreenUtil().setWidth(90),
                                  ),
                                  height: ScreenUtil().setHeight(2),
                                  color: ColorPallet().gray.withOpacity(.15),
                                ),
                              ],
                            ),
                            Platform.isAndroid ?
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: ScreenUtil().setWidth(90),
                                      left: ScreenUtil().setWidth(90),
                                      top: ScreenUtil().setWidth(50)
                                  ),
                                  child:   Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/ic_repeat.svg',
                                        width: ScreenUtil().setWidth(45),
                                        height: ScreenUtil().setWidth(45),
                                      ),
                                      SizedBox(width: ScreenUtil().setWidth(10)),
                                      Text(
                                        'تکرار یادآور',
                                        style:  context.textTheme.labelLarge!.copyWith(
                                          color: ColorPallet().gray,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                      right: ScreenUtil().setWidth(90),
                                      left: ScreenUtil().setWidth(90),
                                      top: ScreenUtil().setWidth(40),
                                    ),
                                    child:  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: List.generate(widget.presenter!.daysWeek.length, (index) {
                                        return  StreamBuilder(
                                          stream: _animations.squareScaleBackButtonObserve,
                                          builder: (context,AsyncSnapshot<double>snapshotScale){
                                            if(snapshotScale.data != null){
                                              return  Transform.scale(
                                                scale: modePress ==0 && widget.presenter!.daysWeek[index].onPress! ? snapshotScale.data : 1.0,
                                                child:  GestureDetector(
                                                    onTap: (){
                                                      animationControllerScaleButtons.reverse();
                                                      setState(() {
                                                        modePress =0;
                                                      });
                                                      AnalyticsHelper().log(
                                                          AnalyticsEvents.AddAlarmPg_WeekList_Item_Clk,
                                                          parameters: {
                                                            'index' : index
                                                          }
                                                      );
                                                      widget.presenter!.changeDayWeek(index);
                                                    },
                                                    child:  Container(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: ScreenUtil().setWidth(20)
                                                      ),
                                                      color: Colors.white,
                                                      child:  Column(
                                                        children: [
                                                          Text(
                                                            widget.presenter!.daysWeek[index].title!,
                                                            style:  context.textTheme.bodySmall!.copyWith(
                                                              color: widget.presenter!.daysWeek[index].selected! ? ColorPallet().mainColor : ColorPallet().gray,
                                                            ),
                                                          ),
                                                          widget.presenter!.daysWeek[index].selected! ?
                                                          Container(
                                                            margin: EdgeInsets.only(
                                                                top: ScreenUtil().setWidth(30)
                                                            ),
                                                            height: ScreenUtil().setWidth(15),
                                                            width: ScreenUtil().setWidth(15),
                                                            decoration:  BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: ColorPallet().mainColor
                                                            ),
                                                          ) :  Container(
                                                            height: ScreenUtil().setWidth(15),
                                                            width: ScreenUtil().setWidth(15),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),
                                              );
                                            }else{
                                              return  Container(
                                              );
                                            }
                                          },
                                        );
                                      }),
                                    )
                                ),
                              ],
                            ) :  Container(),
                            Padding(
                             padding: EdgeInsets.only(
                               top: ScreenUtil().setWidth(100)
                             ),
                             child:   Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                  StreamBuilder(
                                   stream: _animations.squareScaleBackButtonObserve,
                                   builder: (context,AsyncSnapshot<double>snapshotScale){
                                     if(snapshotScale.data != null){
                                       return  Transform.scale(
                                         scale: modePress == 1 ? snapshotScale.data : 1.0,
                                         child:  GestureDetector(
                                           onTap: (){
                                             animationControllerScaleButtons.reverse();
                                             setState(() {
                                               modePress =1;
                                             });
//                              print(snapshotSelectedReminder.data.title);
//                                             print('SAVE');
                                             AnalyticsHelper().log(AnalyticsEvents.AddAlarmPg_SaveAlarm_Btn_Clk);
                                             widget.presenter!.onPressSaveReminder(context,widget.indexAlarm, snapshotSelectedReminder.data!.mode,widget.presenter!,widget.isOfflineMode);
                                           },
                                           child:  Container(
                                             margin: EdgeInsets.only(
                                                 bottom: ScreenUtil().setWidth(100)
                                             ),
                                             width: MediaQuery.of(context).size.width/3.5,
                                             padding: EdgeInsets.symmetric(
                                                 vertical: ScreenUtil().setWidth(10),
                                                 horizontal: ScreenUtil().setWidth(20)
                                             ),
                                             decoration:  BoxDecoration(
                                                 gradient: LinearGradient(
                                                   colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain]
                                                 ),
                                                 borderRadius: BorderRadius.circular(20)
                                             ),
                                             child:  Center(
                                               child:  Text(
                                                 'ذخیره یادآور',
                                                 style:  context.textTheme.labelLarge!.copyWith(
                                                   color: Colors.white,
                                                 ),
                                               ),
                                             ),
                                           ),
                                         ),
                                       );
                                     }else{
                                       return  Container();
                                     }
                                   },
                                 ),
                                 widget.mode != 0 ?
                                  StreamBuilder(
                                   stream: widget.presenter!.listRemindersObserve,
                                   builder: (context,AsyncSnapshot<List<DailyRemindersViewModel>>snapshotListReminders){
                                     if(snapshotListReminders.data != null){
                                       if(snapshotListReminders.data!.length > 1){
                                         return  Row(
                                           children: [
                                              SizedBox(width: ScreenUtil().setWidth(30)),
                                              StreamBuilder(
                                               stream: _animations.squareScaleBackButtonObserve,
                                               builder: (context,AsyncSnapshot<double>snapshotScale){
                                                 if(snapshotScale.data != null){
                                                   return  Transform.scale(
                                                     scale: modePress == 3 ? snapshotScale.data : 1.0,
                                                     child:  GestureDetector(
                                                       onTap: (){
                                                         animationControllerScaleButtons.reverse();
                                                         setState(() {
                                                           modePress =3;
                                                         });
                                                         AnalyticsHelper().log(AnalyticsEvents.AddAlarmPg_RemoveAlarm_Btn_Clk);
                                                         widget.presenter!.showDeleteReminderDialog();
                                                       },
                                                       child:  Container(
                                                         margin: EdgeInsets.only(
                                                           bottom: ScreenUtil().setWidth(100),
                                                         ),
                                                         width: MediaQuery.of(context).size.width/3.5,
                                                         padding: EdgeInsets.symmetric(
                                                             vertical: ScreenUtil().setWidth(10),
                                                             horizontal: ScreenUtil().setWidth(20)
                                                         ),
                                                         decoration:  BoxDecoration(
                                                             color: Color(0xffEBEBEB),
                                                             borderRadius: BorderRadius.circular(20)
                                                         ),
                                                         child:  Center(
                                                           child:  Text(
                                                             'حذف یادآور',
                                                             style:  context.textTheme.bodyMedium!.copyWith(
                                                               color: ColorPallet().gray,
                                                             ),
                                                           ),
                                                         ),
                                                       ),
                                                     ),
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
                                     }else{
                                       return  Container();
                                     }
                                   },
                                 )
                                     :  Container()
                               ],
                             )
                           )
                          ],
                        )
                      );
                    }else{
                      return  Container();
                    }
                  },
                ),
                 StreamBuilder(
                  stream: widget.presenter!.isShowDeleteReminderDialogObserve,
                  builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog){
                    if(snapshotIsShowDialog.data != null){
                      if(snapshotIsShowDialog.data!){
                        return  QusDialog(
                          scaleAnim: widget.presenter!.dialogScaleObserve,
                          onPressCancel: (){
                            AnalyticsHelper().log(AnalyticsEvents.AddAlarmPg_RemoveAlarmNoDlg_Btn_Clk);
                            widget.presenter!.onPressCancelDeleteReminderDialog();
                          },
                          value: "می‌خوای این یادآور حذف کنی؟",
                          yesText: 'آره!',
                          noText: 'نه',
                          onPressYes: (){
                            AnalyticsHelper().log(AnalyticsEvents.AddAlarmPg_RemoveAlarmYesDlg_Btn_Clk);
                            widget.presenter!.deleteReminder(true,context);
                          },
                          isIcon: true,
                            colors:  [
                              Colors.white,
                              Colors.white,
                            ],
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
              ],
            )
        ),
      )
    );
  }





  @override
  void onError(msg) {
  }

  @override
  void onSuccess(value) {
  }

}

class DayWeek {

  String? title;
  String? index;
   bool? selected;
   bool? onPress;

  DayWeek({this.title,this.index,this.selected,this.onPress});

}