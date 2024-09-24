
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/calender_presenter.dart';
import 'package:impo/src/architecture/presenter/dashboard_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/box_status.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/unicorn_outline_button.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/dashboard/pregnancy_numbers_model.dart';
import 'package:impo/src/models/dashboard/my_change_panel_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/home/tabs/calender/change_cycle-screen.dart';
import 'package:impo/src/screens/home/tabs/calender/change_cycle/edit_start_period_screen.dart';
import 'package:impo/src/screens/home/tabs/calender/lottie_test.dart';
import 'package:impo/src/screens/home/tabs/main/breastfeeding/setting_cycle_breastfeeding.dart';
import 'package:impo/src/screens/home/tabs/main/change_status_screen.dart';
import 'package:impo/src/screens/home/tabs/main/pregnancy/setting_cycle_bardari.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/scheduler.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../../../../firebase_analytics_helper.dart';

class MyStatusWidget extends StatefulWidget{
  final DashboardPresenter? dashboardPresenter;
  final CalenderPresenter? calenderPresenter;

  MyStatusWidget({Key? key,this.calenderPresenter,this.dashboardPresenter});

  @override
  State<StatefulWidget> createState() => MyStatusWidgetState();

}


class MyStatusWidgetState extends State<MyStatusWidget> with TickerProviderStateMixin{

  Animations _animations =  Animations();
  late AnimationController animationControllerScaleButton;
  int modePress = 0;

  @override
  void initState() {
    animationControllerScaleButton = _animations.pressButton(this);
    super.initState();
  }

  @override
  void dispose() {
    animationControllerScaleButton.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = .5;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                top: ScreenUtil().setWidth(15)
            ),
            height: ScreenUtil().setWidth(5),
            width: ScreenUtil().setWidth(100),
            decoration:  BoxDecoration(
                color: Color(0xff707070).withOpacity(0.2),
                borderRadius: BorderRadius.circular(15)
            ),
          ),
          StreamBuilder(
            stream: widget.dashboardPresenter!.statusObserve,
            builder: (context,AsyncSnapshot<int>snapshotStatus){
              if(snapshotStatus.data != null){
                if(snapshotStatus.data == 2){
                  return pregnancyItems();
                }else if(snapshotStatus.data == 3 ){
                  return breastfeedingItems();
                }else{
                  return menstruationItems();
                }
              }else{
                return Container();
              }
            },
          )
        ],
      )
    );
  }

  Widget pregnancyItems(){
    return StreamBuilder(
      stream: widget.dashboardPresenter!.pregnancyNumberObserve,
      builder: (context,AsyncSnapshot<PregnancyNumberViewModel>snapshotPregnancy){
        if(snapshotPregnancy.data != null){
          return Column(
            children: [
              SizedBox(
                height: ScreenUtil().setWidth(50),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(45)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "تغییر در وضعیت بارداری",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: ColorPallet().black,
                          fontSize: ScreenUtil().setSp(30),
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    Text(
                      snapshotPregnancy.data!.dayToDelivery != 0 ?
                      "${snapshotPregnancy.data!.dayToDelivery} روز تا زایمان" :
                      'نزدیک به زایمان',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: ColorPallet().gray.withOpacity(.5),
                          fontSize: ScreenUtil().setSp(30),
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setWidth(15),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(45)),
                child: Row(
                  mainAxisAlignment: snapshotPregnancy.data!.weekNoPregnancy! >= 20 ?
                  MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                  children: [
                    snapshotPregnancy.data!.weekNoPregnancy! >= 20 ?
                    StreamBuilder(
                      stream: _animations.squareScaleBackButtonObserve,
                      builder: (context,AsyncSnapshot<double>snapshotScale){
                        if(snapshotScale.data != null){
                          return Transform.scale(
                            scale: modePress == 2 ? snapshotScale.data : 1.0,
                            child: GestureDetector(
                              onTap: (){
                                animationControllerScaleButton.reverse();
                                if(this.mounted){
                                  setState(() {
                                    modePress =2;
                                  });
                                }
                                AnalyticsHelper().log(AnalyticsEvents.DashPgPregnancy_GivingBirth_Btn_Clk_BtmSht);
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: ChangeStatusScreen(
                                        ),
                                        type: PageTransitionType.fade)
                                );
                              },
                              child:  pregnancyBtn(
                                  Colors.transparent,
                                  "زایمان",
                                  Colors.white,
                                  [ ColorPallet().mainColor, ColorPallet().lightMainColor,]
                              ),
                            ),
                          );
                        }else{
                          return Container();
                        }
                      },
                    )
                    : Container(),
                    StreamBuilder(
                      stream: _animations.squareScaleBackButtonObserve,
                      builder: (context,AsyncSnapshot<double>snapshotScale){
                        if(snapshotScale.data != null){
                          return Transform.scale(
                            scale: modePress == 3 ? snapshotScale.data : 1.0,
                            child: GestureDetector(
                              onTap: (){
                                animationControllerScaleButton.reverse();
                                AnalyticsHelper().log(AnalyticsEvents.DashPgPregnancy_Abrt_Btn_Clk_BtmSht);
                                Navigator.pop(context);
                                widget.dashboardPresenter!.showAborationDialog();
                                if(this.mounted){
                                  setState(() {
                                    modePress =3;
                                  });
                                }
                              },
                              child: pregnancyBtn(
                                  ColorPallet().mentalMain,
                                  "ختم بارداری",
                                  ColorPallet().gray,
                                  [Colors.transparent,Colors.transparent,]
                              ),
                            ),
                          );
                        }else{
                          return Container();
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setWidth(45),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(45)),
                child: Container(
                  height: ScreenUtil().setWidth(1),
                  color: ColorPallet().gray.withOpacity(.1),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setWidth(40),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: ScreenUtil().setWidth(50),
                    right: ScreenUtil().setWidth(45),
                    left: ScreenUtil().setWidth(45),
                ),
                child: CustomButton(
                  title: 'تنظیمات',
                  onPress: () async {
                    AnalyticsHelper().log(AnalyticsEvents.DashPgPregnancy_Set_Btn_Clk_BtmSht);
                    Navigator.push(
                        context,
                        PageTransition(
                            child: SettingCycleBardari(
                              dashboardPresenter: widget.dashboardPresenter!,
                            ),
                            type: PageTransitionType.fade)
                    );
                  },
                  icon: 'assets/images/ic_setting.svg',
                  margin: 195,
                  height: ScreenUtil().setWidth(75),
                  colors: [ColorPallet().mentalHigh, ColorPallet().mentalMain],
                  borderRadius: 10.0,
                  enableButton: true,
                ),
              ),
            ],
          );
        }else{
          return Container();
        }
      },
    );
  }

  Widget menstruationItems(){
    return Column(
      children: [
        // checkAgeUser() >= 14 ?
        //     Column(
        //       children: [
        //         Padding(
        //           padding: EdgeInsets.symmetric(
        //               horizontal: ScreenUtil().setWidth(40),
        //               vertical: ScreenUtil().setWidth(55)),
        //           child: InkWell(
        //             onTap: () {
        //               AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_ImPregnant_Btn_Clk_BtmSht);
        //               widget.dashboardPresenter!.showChangeStatusDialog(1,context);
        //             },
        //             child: BoxStatus(
        //               title: "باردار شدم",
        //               marginHorizontal: 100,
        //               subTitle: "خودمراقبتی هفته به هفته بارداری",
        //               lowColor: ColorPallet().mentalHigh,
        //               highColor: ColorPallet().mentalMain,
        //               pathImage: 'assets/images/baby_state.svg',
        //             ),
        //           ),
        //         ),
        //         Divider(
        //           color: ColorPallet().gray,
        //         ),
        //       ],
        //     ) :
        //     Container(),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(30),
            ),
            child: Text(
              "تغییرات در وضعیت قاعدگی",
              textAlign: TextAlign.start,
              style: context.textTheme.bodyMedium
            ),
          ),
        ),
        StreamBuilder(
          stream: widget.dashboardPresenter!.myChangePanelObserve,
          builder: (context,AsyncSnapshot<MyChangePanelModel>snapshotMyChangePanel) {
            if (snapshotMyChangePanel.data != null) {
              if(snapshotMyChangePanel.data!.mode != 6){
                return  Padding(
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(20),
                  ),
                  child: snapshotMyChangePanel.data!.mode == 2 || snapshotMyChangePanel.data!.mode == 5 ?
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(40),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        StreamBuilder(
                          stream: _animations.squareScaleBackButtonObserve,
                          builder: (context,AsyncSnapshot<double>snapshotScale){
                            if(snapshotScale.data != null){
                              return   Transform.scale(
                                  scale: modePress == 0 ? snapshotScale.data : 1.0,
                                  child:GestureDetector(
                                    onTap: (){
                                       animationControllerScaleButton.reverse();
                                      Navigator.pop(context);
                                      if(this.mounted){
                                        setState(() {
                                          modePress =0;
                                        });
                                      }
                                      // print(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day));
                                      // _presenter.onPressBtnNotPeriod(context, widget.randomMessage);
                                       AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_NotPeriod_Btn_Clk_BtmSht);
                                      widget.dashboardPresenter!.onPressShowPeriodDialog(1, null,snapshotMyChangePanel.data!.dayMode!);
                                    },
                                    child: btnPeriod(
                                        'هنوز پریود نشدم',
                                        snapshotMyChangePanel.data!.dayMode!,
                                        snapshotMyChangePanel.data!.mode,0,
                                    ),
                                  )
                              );
                            }else{
                              return  Container();
                            }
                          },
                        ),
                        SizedBox(width: ScreenUtil().setWidth(30)),
                        StreamBuilder(
                          stream: _animations.squareScaleBackButtonObserve,
                          builder: (context,AsyncSnapshot<double>snapshotScale){
                            if(snapshotScale.data != null){
                              return  Transform.scale(
                                  scale: modePress == 1 ? snapshotScale.data : 1.0,
                                  child: GestureDetector(
                                    onTap: (){
                                       animationControllerScaleButton.reverse();
                                      Navigator.pop(context);
                                      if(this.mounted){
                                        setState(() {
                                          modePress =1;
                                        });
                                      }
                                      // _presenter.onPressBtnKhonrizi(context,register.data, widget.randomMessage,snapshotValuePeriod.data[1] == 2 ? 3 : 4);
                                      // print(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day));
                                      // widget.presenter.onPressShowPeriodDialog(mode,listCirclesItem,dayMode);
                                       if(snapshotMyChangePanel.data!.mode == 2){
                                         AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_EndPeriod_Btn_Clk_BtmSht);
                                       }else{
                                         AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_ContPeriod_Btn_Clk_BtmSht);
                                       }
                                      widget.dashboardPresenter!.onPressShowPeriodDialog(snapshotMyChangePanel.data!.mode == 2 ? 3 : 4,null,snapshotMyChangePanel.data!.dayMode!);
                                    },
                                    child: btnPeriod(
                                        snapshotMyChangePanel.data!.mode == 2 ? 'پریودم تموم شد' : 'پریودم ادامه داره',
                                        snapshotMyChangePanel.data!.dayMode!,
                                        snapshotMyChangePanel.data!.mode,1,
                                    ),
                                  )
                              );
                            }else{
                              return  Container();
                            }
                          },
                        ),
                      ],
                    ),
                  )
                      :
                  StreamBuilder(
                    stream: _animations.squareScaleBackButtonObserve,
                    builder: (context,AsyncSnapshot<double>snapshotScale){
                      if(snapshotScale.data != null){
                        return   Transform.scale(
                            scale: modePress == 0 ? snapshotScale.data : 1.0,
                            child: GestureDetector(
                              onTap: ()async{
                                await animationControllerScaleButton.reverse();
                                Navigator.pop(context);
                                if(this.mounted){
                                  setState(() {
                                    modePress =0;
                                  });
                                }
                                // print(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day));
                                // _presenter.onPressBtnNotPeriod(context, widget.randomMessage);
                                if(snapshotMyChangePanel.data!.mode == 0){
                                  AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_ImPeriod_Btn_Clk_BtmSht);
                                }else if(snapshotMyChangePanel.data!.mode == 1){
                                  AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_NotPeriod_Btn_Clk_BtmSht);
                                }else if(snapshotMyChangePanel.data!.mode == 3){
                                  AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_EndPeriod_Btn_Clk_BtmSht);
                                }else{
                                  AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_ContPeriod_Btn_Clk_BtmSht);
                                }
                                widget.dashboardPresenter!.onPressShowPeriodDialog(snapshotMyChangePanel.data!.mode, null,snapshotMyChangePanel.data!.dayMode!);
                              },
                              child:  btnPeriod(
                                  snapshotMyChangePanel.data!.mode == 0 ?
                                  'پریود شدم' : snapshotMyChangePanel.data!.mode == 1 ?
                                  'هنوز پریود نشدم' : snapshotMyChangePanel.data!.mode == 3 ?
                                  'پریودم تموم شد ' : 'پریودم ادامه داره ',
                                  snapshotMyChangePanel.data!.dayMode!,
                                  snapshotMyChangePanel.data!.mode,
                                  0,
                              ),
                            )
                        );
                      }else{
                        return  Container();
                      }
                    },
                  ),
                );
              }else{
                return Container();
              }
            } else {
              return  Container();
            }
          },
        ),
        Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(60),
            right: ScreenUtil().setWidth(45),
            left: ScreenUtil().setWidth(45),
            bottom: ScreenUtil().setWidth(50)
          ),
          child: CustomButton(
            title: 'تنظیمات',
            onPress: ()async{
              Navigator.push(
                  context,
                  PageTransition(
                      child:
                      EditStartPeriodScreen(
                        calenderPresenter: widget.calenderPresenter,
                      ),
                      // ChangeCycleScreen(
                      //   calenderPresenter: widget.calenderPresenter,
                      // ),
                      type: PageTransitionType.fade
                  )
              );
            },
            icon: 'assets/images/ic_setting.svg',
            margin: 195,
            height: ScreenUtil().setWidth(75),
            colors: [ColorPallet().mentalHigh, ColorPallet().mentalMain],
            borderRadius: 10.0,
            enableButton: true,
          ),
        ),
      ],
    );
  }

  Widget breastfeedingItems() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(45)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: ScreenUtil().setWidth(30),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                // "تغییر در وضعیت شیردهی",
                "تغییر وضعیت",
                textAlign: TextAlign.start,
                style: context.textTheme.bodyMedium,
              ),
            ),
            SizedBox(
              height: ScreenUtil().setWidth(40),
            ),
            InkWell(
              onTap: () {
                AnalyticsHelper().log(AnalyticsEvents.DashPgBrstfeed_ImPeriod_Btn_Clk_BtmSht);
                widget.dashboardPresenter!.showChangeStatusDialog(0,context);
              },
              child: BoxStatus(
                title: "پریود شدم",
                marginHorizontal: 110,
                subTitle: "تقویم قاعدگی و سلامت روان",
                lowColor: ColorPallet().lightMainColor,
                highColor: ColorPallet().mainColor,
                pathImage: 'assets/images/ghaedegi_state.svg',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(50),
                bottom: ScreenUtil().setWidth(60)
              ),
              child: Divider(
                color: ColorPallet().gray,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(50)),
              child: CustomButton(
                title: 'تنظیمات',
                onPress: () async {
                  AnalyticsHelper().log(AnalyticsEvents.DashPgBrstfeed_Set_Btn_Clk_BtmSht);
                  Navigator.push(
                      context,
                      PageTransition(
                          child: SettingCycleBreastfeeding(
                            dashboardPresenter: widget.dashboardPresenter!,
                          ),
                          type: PageTransitionType.fade));
                },
                icon: 'assets/images/ic_setting.svg',
                margin: 195,
                height: ScreenUtil().setWidth(75),
                colors: [ColorPallet().mentalHigh, ColorPallet().mentalMain],
                borderRadius: 10.0,
                enableButton: true,
              ),
            ),
          ]),
    );
  }

  Widget pregnancyBtn(Color? borderColor, String title, Color textColor,List<Color> colors) {
    return Container(
      margin: EdgeInsets.only(
        top: ScreenUtil().setWidth(30),
      ),
      padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setWidth(16),
          horizontal: ScreenUtil().setWidth(20)),
      width: ScreenUtil().setWidth(300),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
              colors: colors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight),
          border: Border.all(
              color: borderColor ?? Colors.transparent, width: 1.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                color: textColor,
                fontSize: ScreenUtil().setSp(28),
                fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }

  Widget btnPeriod(title,int dayMode,mode,index){
    return Container(
      margin: EdgeInsets.only(
          top: ScreenUtil().setWidth(30)
      ),
      padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setWidth(10),
          horizontal: ScreenUtil().setWidth(15)
      ),
      width: ScreenUtil().setWidth(300),
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        border: Border.all(
            color: dayMode == 0 ? Color(0xff9E1A1A) : dayMode == 1 ? Color(0xff0D5C60) : dayMode == 2 ? Color(0xff4f279d) : Color(0xffA02295),
            width: 1.5
        )
//                  boxShadow: [
//                    BoxShadow(
//                        color: Color(0xffFFDBF4),
//                        blurRadius: 10
//                    )
//                  ]
      ),
      child:  Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style:  context.textTheme.labelMediumProminent!.copyWith(
            color: dayMode == 0 ? Color(0xff9E1A1A) : dayMode == 1 ? Color(0xff0D5C60) : dayMode == 2 ? Color(0xff4f279d) : Color(0xffA02295),
          ),
        )
      )
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         // mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
// //           index == 1 ?
// //            Image.asset(
// //             dayMode == 0 ? "assets/images/khon_period.png" : dayMode == 1 ? "assets/images/khon_fert.png" : dayMode == 2 ? "assets/images/khon_pms.png" : "assets/images/khon_normal.png",
// //                    // fit:  BoxFit.fitWidth,
// //             width: ScreenUtil().setWidth(45),
// //             height: ScreenUtil().setWidth(45),
// //           ) :
// //            Image.asset(
// //             dayMode == 0 ? "assets/images/ghatre_period.png" : dayMode == 1 ? "assets/images/ghatre_fert.png" : dayMode == 2 ? "assets/images/ghatre_pms.png" : "assets/images/ghatre_normal.png",
// // //                    fit:  BoxFit.fitWidth,
// //             width: ScreenUtil().setWidth(45),
// //             height: ScreenUtil().setWidth(45),
// //           ),
// //            SizedBox(width: ScreenUtil().setWidth(10)),
//
//         ],
//       ),
    );
  }


  checkAgeUser(){
    RegisterParamViewModel register = widget.dashboardPresenter!.getRegisters();
    List date = register.birthDay!.replaceAll(',', '/').replaceAll(' ', '').split('/');

    Jalali birthDateTime = Jalali(
        int.parse(date[0]),
        int.parse(date[1]),
        int.parse(date[2])
    );
    DateTime now = DateTime.now();

    int diff = ((now.millisecondsSinceEpoch -
        birthDateTime.toDateTime().millisecondsSinceEpoch) ~/ 31556926000);

    return diff;
  }


}