

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/profile_presenter.dart';
import 'package:impo/src/architecture/view/profile_view.dart';
import 'package:impo/src/components/action_manage_overlay.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/dialogs/qus_dialog.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/calender/alarm_model.dart';
import 'package:impo/src/models/dailyReminders/sub_main_list_reminders_model.dart';
import 'package:impo/src/screens/home/tabs/profile/alarms/add_alarm_screen.dart';
import 'package:impo/src/singleton/notification_init.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../firebase_analytics_helper.dart';

class ListAlarmsScreen extends StatefulWidget{

  final int? indexAlarm;
  final ProfilePresenter? presenter;
  final isShowCanDrawOverLayerDialog;
  final isTwoBack;
  final isOfflineMode;

  ListAlarmsScreen({Key? key,this.indexAlarm,this.presenter,this.isShowCanDrawOverLayerDialog,this.isTwoBack,this.isOfflineMode}):super(key:key);

  @override
  State<StatefulWidget> createState() => ListAlarmsScreenState();
}

class ListAlarmsScreenState extends State<ListAlarmsScreen> with TickerProviderStateMixin implements ProfileView{

//  ProfilePresenter _presenter;
//
//  ListAlarmsScreenState(){
//    _presenter = ProfilePresenter(this);
//  }


  late AnimationController animationControllerScaleButtons;
  Animations _animations =  Animations();
  int modePress =0;

  List<String> days =  ['ش','ی','د','س','چ','پ','ج'];

  List<int> indexDays =  [0,1,2,3,4,5,6];

  @override
  void initState() {
    animationControllerScaleButtons = _animations.pressButton(this);
    widget.presenter!.initListReminders(widget.indexAlarm!);
    widget.presenter!.initialDialogScale(this);
    checkShowCanDrawDialog();
    super.initState();
  }

  Future<bool> checkCanDrawOverlays()async{
    if(Platform.isIOS){
      return true;
    }else{
      return await ActionManageOverlay.canDrawOverlays;
    }
  }

  checkShowCanDrawDialog()async{
    if(!await checkCanDrawOverlays() && widget.isShowCanDrawOverLayerDialog){
    widget.presenter!.showCanDrawOverlaysDialog();
    }
  }

//  @override
//  void dispose() {
//    _scrollController.dispose();
//    super.dispose();
//  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.ListAlarmsPg_Back_NavBar_Clk);
    if(widget.isTwoBack){
      Navigator.pop(context);
      Navigator.pop(context);
    }else{
      Navigator.pop(context);
    }

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
                 Column(
                  children: [
                     Padding(
                      padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(35)),
                      child:  CustomAppBar(
                        messages: false,
                        profileTab: true,
                        icon: 'assets/images/ic_arrow_back.svg',
                        titleProfileTab: 'صفحه قبل',
                        subTitleProfileTab: 'یادآور',
                        isEmptyLeftIcon: widget.isOfflineMode ? true : null,
                        onPressBack: (){
                          AnalyticsHelper().log(AnalyticsEvents.ListAlarmsPg_Back_Btn_Clk);
                          if(widget.isTwoBack){
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }else{
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    SvgPicture.asset(
                      subMainReminders[widget.indexAlarm!].icon!,
                      width: ScreenUtil().setWidth(160),
                      height: ScreenUtil().setWidth(160),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                    Text(
                      subMainReminders[widget.indexAlarm!].title!,
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleMedium,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setWidth(35),right: ScreenUtil().setWidth(50),left: ScreenUtil().setWidth(50)),
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(20)
                      ),
                      decoration:  BoxDecoration(
                          color: Color(0xffFFA5FC).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child:  Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
                            child:  SvgPicture.asset(
                              'assets/images/ic_tip_alarm.svg',
                              width: ScreenUtil().setWidth(45),
                              height: ScreenUtil().setWidth(45),
                            ),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(20),),
                          Flexible(
                              child:  Padding(
                                padding: EdgeInsets.only(top: ScreenUtil().setWidth(15),bottom:ScreenUtil().setWidth(15)),
                                child:  Text(
                                  subMainReminders[widget.indexAlarm!].subTitle!,
                                  style:  context.textTheme.bodyMedium,
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                     Expanded(
                        child:   Directionality(
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
                                    child:   StreamBuilder(
                                      stream: widget.presenter!.listRemindersObserve,
                                      builder: (context,AsyncSnapshot<List<DailyRemindersViewModel>>snapshotListReminders){
                                        if(snapshotListReminders.data != null){
                                          if(snapshotListReminders.data!.length != 0){
                                            return  FadingEdgeScrollView.fromScrollView(
                                              // shouldDisposeScrollController: true,
                                              gradientFractionOnEnd: 1,
                                              gradientFractionOnStart: 1,
                                              child:  ListView.separated(
                                                controller: ScrollController(),
                                                padding: EdgeInsets.only(top: ScreenUtil().setWidth(50),right: ScreenUtil().setWidth(60),left: ScreenUtil().setWidth(40),bottom: ScreenUtil().setWidth(30)),
                                                itemCount: snapshotListReminders.data!.length,
                                                separatorBuilder: (context,index){
                                                  return  Container(
                                                    height: ScreenUtil().setHeight(1),
                                                    margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(30)),
                                                    color: Colors.grey,
                                                  );
                                                },
                                                itemBuilder: (context,index){
                                                  return  Directionality(
                                                      textDirection: TextDirection.rtl,
                                                      child:  Padding(
                                                          padding: index == snapshotListReminders.data!.length-1 ? EdgeInsets.only(bottom: ScreenUtil().setWidth(200)) : EdgeInsets.only(bottom: 0) ,
                                                          child:   Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              StreamBuilder(
                                                                  stream: _animations.squareScaleBackButtonObserve,
                                                                  builder: (context,AsyncSnapshot<double>snapshotScale){
                                                                    if(snapshotScale.data != null){
                                                                      return  Transform.scale(
                                                                          scale: snapshotListReminders.data![index].isSelected && modePress == 3 ? snapshotScale.data : 1.0,
                                                                          child:  GestureDetector(
                                                                            onTap: (){
                                                                              animationControllerScaleButtons.reverse();

                                                                              for(int i=0 ; i<snapshotListReminders.data!.length ; i++){
                                                                                snapshotListReminders.data![i].isSelected = false;
                                                                              }

                                                                              setState(() {
                                                                                modePress =3;
                                                                                snapshotListReminders.data![index].isSelected = !snapshotListReminders.data![index].isSelected;
                                                                              });
                                                                              Timer(Duration(milliseconds: 100),(){
                                                                                AnalyticsHelper().log(
                                                                                    AnalyticsEvents.ListAlarmsPg_AlarmsList_Item_Clk,
                                                                                    parameters: {
                                                                                      'id' : snapshotListReminders.data![index].id
                                                                                    }
                                                                                );
                                                                                Navigator.push(
                                                                                    context,
                                                                                    PageTransition(
                                                                                        type: PageTransitionType.fade,
                                                                                        child:  AddAlarmScreen(
                                                                                          indexAlarm: widget.indexAlarm,
                                                                                          mode: 1,
                                                                                          dailyReminders: snapshotListReminders.data![index],
                                                                                          presenter: widget.presenter!,
                                                                                          isOfflineMode: widget.isOfflineMode,
                                                                                        )
                                                                                    )
                                                                                );
                                                                              });
                                                                            },
                                                                            child:  Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  snapshotListReminders.data![index].title!,
                                                                                  style:  context.textTheme.bodyMedium!.copyWith(
                                                                                    color: ColorPallet().mainColor,
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  snapshotListReminders.data![index].time!,
                                                                                  style:  context.textTheme.titleSmall!.copyWith(
                                                                                    color: ColorPallet().mainColor,
                                                                                  ),
                                                                                ),
                                                                                Platform.isAndroid ?
                                                                                Row(
                                                                                  children: List.generate(days.length, (i) {
                                                                                    return  Padding(
                                                                                      padding: EdgeInsets.symmetric(
                                                                                          horizontal: ScreenUtil().setWidth(5)
                                                                                      ),
                                                                                      child:  Text(
                                                                                        days[i],
                                                                                        style:  context.textTheme.bodySmall!.copyWith(
                                                                                          color: snapshotListReminders.data![index].dayWeek != '' ? json.decode(snapshotListReminders.data![index].dayWeek!).contains(indexDays[i]) ? ColorPallet().gray : ColorPallet().mainColor : ColorPallet().mainColor,
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  }),
                                                                                ) :  Container()
                                                                              ],
                                                                            ),
                                                                          )
                                                                      );
                                                                    }else{
                                                                      return  Container();
                                                                    }
                                                                  }
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      snapshotListReminders.data!.length > 1 ?
                                                                      StreamBuilder(
                                                                        stream: _animations.squareScaleBackButtonObserve,
                                                                        builder: (context,AsyncSnapshot<double>snapshotScale){
                                                                          if(snapshotScale.data != null){
                                                                            return  Transform.scale(
                                                                              scale: snapshotListReminders.data![index].isSelected && modePress ==0 ? snapshotScale.data : 1.0,
                                                                              child:   GestureDetector(
                                                                                onTap: (){
                                                                                  animationControllerScaleButtons.reverse();

                                                                                  for(int i=0 ; i<snapshotListReminders.data!.length ; i++){
                                                                                    snapshotListReminders.data![i].isSelected = false;
                                                                                  }
                                                                                  setState(() {
                                                                                    modePress =0;
                                                                                    snapshotListReminders.data![index].isSelected = !snapshotListReminders.data![index].isSelected;
                                                                                  });
                                                                                  AnalyticsHelper().log(
                                                                                      AnalyticsEvents.ListAlarmsPg_RemoveAlarm_Btn_Clk,
                                                                                      parameters: {
                                                                                        'id' : snapshotListReminders.data![index].id
                                                                                      }
                                                                                  );
                                                                                  widget.presenter!.showDeleteReminderDialog();
                                                                                  widget.presenter!.setSelectedReminderInList(snapshotListReminders.data![index]);
                                                                                },
                                                                                child:  Container(
                                                                                    padding: EdgeInsets.symmetric(
                                                                                        horizontal: ScreenUtil().setWidth(30),
                                                                                        vertical: ScreenUtil().setWidth(7)
                                                                                    ),
                                                                                    decoration:  BoxDecoration(
                                                                                        color: Colors.transparent,
                                                                                        borderRadius: BorderRadius.circular(35),
                                                                                        border: Border.all(color: Color(0xffE70000),width: .5)
                                                                                    ),
                                                                                    child:  Container(
                                                                                      height: ScreenUtil().setWidth(35),
                                                                                      width: ScreenUtil().setWidth(35),
                                                                                      child:  SvgPicture.asset(
                                                                                        'assets/images/ic_delete_note.svg',
                                                                                        fit: BoxFit.fitHeight,
                                                                                      ),
                                                                                    )
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }else{
                                                                            return  Container();
                                                                          }
                                                                        },
                                                                      )
                                                                          :  Container(),
                                                                      snapshotListReminders.data![index].mode == 2 ?
                                                                      GestureDetector(
                                                                        onTap: ()async{
                                                                          setState(() {
                                                                            snapshotListReminders.data![index].isSound == 1 ? snapshotListReminders.data![index].isSound = 0 : snapshotListReminders.data![index].isSound = 1;
                                                                          });
                                                                          if(snapshotListReminders.data![index].isSound == 1){
                                                                            AnalyticsHelper().log(
                                                                                AnalyticsEvents.ListAlarmsPg_TurnOnTheSoundAlarm_Btn_Clk,
                                                                                parameters: {
                                                                                  'id' : snapshotListReminders.data![index].id
                                                                                }
                                                                            );
                                                                          }else if(snapshotListReminders.data![index].isSound == 0){
                                                                            AnalyticsHelper().log(
                                                                                AnalyticsEvents.ListAlarmsPg_TurnOffTheSoundAlarm_Btn_Clk,
                                                                                parameters: {
                                                                                  'id' : snapshotListReminders.data![index].id
                                                                                }
                                                                            );
                                                                          }
                                                                          widget.presenter!.setSelectedReminderInList(snapshotListReminders.data![index]);
                                                                          await widget.presenter!.setAlarm(widget.indexAlarm,snapshotListReminders.data![index].mode);
                                                                        },
                                                                        child:  Container(
                                                                            padding: EdgeInsets.symmetric(
                                                                                horizontal: ScreenUtil().setWidth(30),
                                                                                vertical: ScreenUtil().setWidth(7)
                                                                            ),
                                                                            margin: EdgeInsets.only(
                                                                                right: ScreenUtil().setWidth(30)
                                                                            ),
                                                                            decoration:  BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(35),
                                                                                border: Border.all(
                                                                                    color:  snapshotListReminders.data![index].isSound == 1 ?  ColorPallet().mainColor : ColorPallet().gray,
                                                                                    width: 1.5
                                                                                )
                                                                            ),
                                                                            child:  Container(
                                                                              height: ScreenUtil().setWidth(35),
                                                                              width: ScreenUtil().setWidth(35),
                                                                              child:   SvgPicture.asset(
                                                                                snapshotListReminders.data![index].isSound == 1 ? 'assets/images/volume_up.svg' : 'assets/images/volume_off.svg',
                                                                                fit: BoxFit.fitHeight,
                                                                                colorFilter: ColorFilter.mode(
                                                                                  snapshotListReminders.data![index].isSound == 1 ? ColorPallet().mainColor  : Color(0xff9D9D9D) ,
                                                                                  BlendMode.srcIn
                                                                                ),
                                                                              ),
                                                                            )
                                                                        ),
                                                                      )
                                                                          :  Container(),
                                                                      Transform.scale(
                                                                          scale: ScreenUtil().setWidth(1.55),
                                                                          child:  CupertinoSwitch(
                                                                            value: snapshotListReminders.data![index].mode == 2 ? true : false,
                                                                            trackColor: Color(0XFF707070),
                                                                            activeColor: ColorPallet().mainColor,
                                                                            onChanged: (bool value)async{
                                                                              widget.presenter!.setSelectedReminderInList(snapshotListReminders.data![index]);
                                                                              if(!await checkCanDrawOverlays() && snapshotListReminders.data![index].mode == 1){
                                                                                widget.presenter!.showCanDrawOverlaysDialog();
                                                                              }
                                                                              setState(() {
                                                                                value == true ? snapshotListReminders.data![index].mode = 2 : snapshotListReminders.data![index].mode = 1;
                                                                              });
                                                                              if(snapshotListReminders.data![index].mode == 1){
                                                                                if(Platform.isIOS){
                                                                                  await NotificationInit.getGlobal().getNotify().cancel(snapshotListReminders.data![index].id!);
                                                                                }else{
                                                                                  await AndroidAlarmManager.cancel(snapshotListReminders.data![index].id!);
                                                                                }
                                                                                widget.presenter!.updateDb(snapshotListReminders.data![index].mode);
                                                                              }else{
                                                                                await widget.presenter!.setAlarm(widget.indexAlarm,snapshotListReminders.data![index].mode);
                                                                              }
                                                                              if(value){
                                                                                AnalyticsHelper().log(
                                                                                    AnalyticsEvents.ListAlarmsPg_TurnOnTheAlarm_Switch_Clk,
                                                                                    parameters: {
                                                                                      'id' : snapshotListReminders.data![index].id
                                                                                    }
                                                                                );
                                                                              }else{
                                                                                AnalyticsHelper().log(
                                                                                    AnalyticsEvents.ListAlarmsPg_TurnOffTheAlarm_Switch_Clk,
                                                                                    parameters: {
                                                                                      'id' : snapshotListReminders.data![index].id
                                                                                    }
                                                                                );
                                                                              }
                                                                            },
                                                                          )
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                      )
                                                  );
                                                },
                                              ),
                                            );
                                          }else{
                                            return  Container(
                                              child:  Center(
                                                child:  Text(
                                                  'هیج یادآوری تنظیم نشده است',
                                                  style: context.textTheme.bodyMedium,
                                                ),
                                              ),
                                            );
                                          }
                                        }else{
                                          return  Container();
                                        }
                                      },
                                    )
                                )
                            ),
                          ),
                        )
                    ),
//                 Container(
//                  height: ScreenUtil().setWidth(110),
//                  width: ScreenUtil().setWidth(110),
//                )
                  ],
                ),
                 Align(
                  alignment: Alignment.bottomCenter,
                  child:  StreamBuilder(
                    stream: widget.presenter!.listRemindersObserve,
                    builder: (context,AsyncSnapshot<List<DailyRemindersViewModel>>snapshotListReminders){
                      if(snapshotListReminders.data != null){
                        if(snapshotListReminders.data!.length < 24){
                          return  StreamBuilder(
                            stream: _animations.squareScaleBackButtonObserve,
                            builder: (context,AsyncSnapshot<double>snapshotScale){
                              if(snapshotScale.data != null){
                                return  Transform.scale(
                                  scale:  modePress == 1 ? snapshotScale.data : 1,
                                  child:  GestureDetector(
                                      onTap: ()async{
                                        animationControllerScaleButtons.reverse();
                                        setState(() {
                                          modePress =1;
                                        });
                                        Timer(Duration(milliseconds: 100),(){
                                          AnalyticsHelper().log(AnalyticsEvents.ListAlarmsPg_AddAlarm_Btn_Clk);
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child:  AddAlarmScreen(
                                                    indexAlarm: widget.indexAlarm,
                                                    mode: 0,
                                                    presenter: widget.presenter!,
                                                    isOfflineMode: widget.isOfflineMode,
                                                  )
                                              )
                                          );
                                        });
                                      },
                                      child:  Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: ScreenUtil().setWidth(30)
                                        ),
                                        height: ScreenUtil().setWidth(110),
                                        width: ScreenUtil().setWidth(110),
                                        decoration:  BoxDecoration(
                                            color: ColorPallet().periodDeep,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color(0xffF9C4E7),
                                                  blurRadius: 5
                                              )
                                            ]
                                        ),
                                        child:  Center(
                                          child:  Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: ScreenUtil().setWidth(80),
                                          ),
                                        ),
                                      )
                                  ),
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
                ),
                 StreamBuilder(
                  stream: widget.presenter!.isShowDeleteReminderDialogObserve,
                  builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog){
                    if(snapshotIsShowDialog.data != null){
                      if(snapshotIsShowDialog.data!){
                        return  QusDialog(
                          scaleAnim: widget.presenter!.dialogScaleObserve,
                          onPressCancel: (){
                            AnalyticsHelper().log(AnalyticsEvents.ListAlarmsPg_RemoveAlarmNoDlg_Btn_Clk);
                            widget.presenter!.onPressCancelDeleteReminderDialog();
                          },
                          value: "می‌خوای این یادآور حذف کنی؟",
                          yesText: 'آره!',
                          noText: 'نه',
                          onPressYes: (){
                            AnalyticsHelper().log(AnalyticsEvents.ListAlarmsPg_RemoveAlarmYesDlg_Btn_Clk);
                            widget.presenter!.deleteReminder(false,context);
                          },
                          isIcon: true,
                            colors:  [
                              Colors.white,
                              Colors.white
                            ],
                          topIcon: 'assets/images/ic_delete_dialog.svg',
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
                 StreamBuilder(
                  stream: widget.presenter!.isShowCanDrawOverlaysDialogObserve,
                  builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog){
                    if(snapshotIsShowDialog.data != null){
                      if(snapshotIsShowDialog.data!){
                        return  QusDialog(
                          scaleAnim: widget.presenter!.dialogScaleObserve,
                          onPressCancel: ()async{
                            await widget.presenter!.animationControllerDialog.reverse();
                            if(!widget.presenter!.isShowCanDrawOverlaysDialog.isClosed){
                              widget.presenter!.isShowCanDrawOverlaysDialog.sink.add(false);
                            }
                            AnalyticsHelper().log(AnalyticsEvents.ListAlarmsPg_NoPermAlarm_Btn_Clk_Dlg);
                          },
                          value: "برای نمایش بهتر یاد‌آور‌ها، لازمه که به ایمپو مجوز نمایش بدی",
                          yesText: 'اجازه میدم',
                          noText: 'نه!',
                          onPressYes: ()async{
                            await ActionManageOverlay.goToSettingPermissionOverlay();
                            await widget.presenter!.animationControllerDialog.reverse();
                            if(!widget.presenter!.isShowCanDrawOverlaysDialog.isClosed){
                              widget.presenter!.isShowCanDrawOverlaysDialog.sink.add(false);
                            }
                            AnalyticsHelper().log(AnalyticsEvents.ListAlarmsPg_IAllowPermAlarm_Btn_Clk_Dlg);
                          },
                          isIcon: true,
                          colors:  [
                            Colors.white,
                            Colors.white
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
                )
              ],
            )
        ),
      ),
    );
  }

  @override
  void onError(msg) {

  }

  @override
  void onSuccess(value) {

  }

}