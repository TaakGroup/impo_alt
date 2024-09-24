
import 'dart:async';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/partner_tab_presenter.dart';
import 'package:impo/src/architecture/presenter/support_presenter.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/screens/home/tabs/calender/memory/memory_game_screen.dart';
import 'package:impo/src/screens/home/tabs/expert/clinic_question_list.dart';
import 'package:impo/src/screens/home/tabs/expert/polar_history_screen.dart';
import 'package:impo/src/screens/home/tabs/partnerTab/pages/send_message_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/profile_sceen.dart';
import 'package:impo/src/screens/home/tabs/profile/supportOnline/pages/support_history_screen.dart';
import 'package:intl/intl.dart';
import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/expert_presenter.dart';
import 'package:impo/src/architecture/presenter/calender_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/stagger_animation.dart';
import 'package:impo/src/components/tab_target.dart';
import 'package:impo/src/data/local/database_provider.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/home/tabs/expert/shop_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/alarms/alarms_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../firebase_analytics_helper.dart';
import '../screens/home/tabs/expert/clinic_question_screen.dart';

class CustomAppBar extends StatefulWidget{

  final bool? messages;
  final titleMessage;
  final String? icon;
  final bool? profileTab;
  final String? titleProfileTab;
  final String? subTitleProfileTab;
  final onPressBack;
  final anim;
  final isPolar;
  final isLogin;
  final valuePolar;
  final ExpertPresenter? expertPresenter;
  final CalenderPresenter? calenderPresenter;
  final isReminder;
  final idReminderTabTarget;
  final idPolarTabTarget;
  final screenController;
  final link;
  final typeLink;
  final idMotivalMessage;
  // final isMemory;
  final isSendMessage;
  final isLogoImpo;
  final isEmptyLeftIcon;
  final isHelpExpert;
  final idProfileTabTarget;
  final idSendMessageTabTarget;
  final polarHistory;
  final pressShop;
  final PartnerTabPresenter? partnerTabPresenter;
  final historyTicket;
  final infoShareExp;
  final historySupport;
  final SupportPresenter? supportPresenter;

  CustomAppBar({Key? key,this.messages,this.icon,this.profileTab,this.titleProfileTab,this.subTitleProfileTab,this.titleMessage,
    this.onPressBack,this.anim,this.isPolar,this.isLogin,this.valuePolar,this.expertPresenter,this.isReminder,this.idPolarTabTarget,
    this.idReminderTabTarget,this.screenController,this.link,this.typeLink,this.idMotivalMessage,this.calenderPresenter,this.isSendMessage,
    this.isLogoImpo,this.isEmptyLeftIcon,this.isHelpExpert,this.idProfileTabTarget,this.idSendMessageTabTarget,
    this.polarHistory,this.pressShop,this.partnerTabPresenter,this.historyTicket,this.infoShareExp,this.historySupport,this.supportPresenter}) : super(key:key);

  @override
  State<StatefulWidget> createState() => CustomAppBarState();
}

final notReadMessage = BehaviorSubject<int>.seeded(0);

Stream<int> get notReadMessageObserve => notReadMessage.stream;

class CustomAppBarState extends State<CustomAppBar> with TickerProviderStateMixin{
  late AnimationController animationControllerScaleButton;
  Animations _animations =  Animations();


  int modePress = 0;

  late AnimationController _controller;
  Tween<double> _tween = Tween(begin: 0.75, end: 1);

  @override
  void initState() {
    animationControllerScaleButton = _animations.pressButton(this);
    _controller = AnimationController(duration: const Duration(milliseconds: 2700), vsync: this);
    _controller.repeat(reverse: true);
    // if(widget.isLogin == null)  getRegisters();
    super.initState();
  }


  Future<bool?> checkPair()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('pair') != null){
      return prefs.getBool('pair');
    }else{
      return false;
    }

  }

  @override
  void dispose() {
    animationControllerScaleButton.dispose();
    _controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    Future<String> todayDate() async{
      var register = locator<RegisterParamModel>();
      if(register.register.calendarType == 1){
        DateTime now = DateTime.now();
        final DateFormat formatter = DateFormat('dd LLL yyyy','fa');
        return formatter.format(now);

      }else{
        Jalali now = Jalali.now();
        final f = now.formatter;

        if(register.register.nationality == 'IR'){
          return "${f.d} ${f.mN}";
        }else{
          return "${f.d} ${f.mnAf}";
        }
      }
    }

    return  Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setWidth(80),
          right: ScreenUtil().setWidth(50),
          left: ScreenUtil().setWidth(50),
        ),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
             Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                 Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    widget.isHelpExpert == null ?
                    widget.anim != null ?
                    FadeIn(
                        2.0,
                        FutureBuilder(
                          future: checkPair(),
                          builder: (context,AsyncSnapshot<bool?>partner){
                            if(partner.data != null){
                              if(widget.profileTab! || !partner.data!){
                                return  StreamBuilder(
                                  stream: _animations.squareScaleBackButtonObserve,
                                  builder: (context,AsyncSnapshot<double> snapshot){
                                    if(snapshot.data != null){
                                      return Transform.scale(
                                        scale: modePress == 0 ? snapshot.data : 1.0,
                                        child:  GestureDetector(
                                          onTap: ()async{
                                            setState(() {
                                              modePress = 0;
                                            });
                                            await animationControllerScaleButton.reverse();
                                            widget.onPressBack();
                                          },
                                          child:  Container(
                                            margin: EdgeInsets.only(
                                                left: widget.profileTab! ? ScreenUtil().setWidth(20) : ScreenUtil().setWidth(30)
                                            ),
                                            height: ScreenUtil().setWidth(75),
                                            width: ScreenUtil().setWidth(75),
                                            padding: EdgeInsets.only(left: widget.messages! ? ScreenUtil().setWidth(4) : 0),
                                            decoration:  BoxDecoration(
                                                borderRadius: BorderRadius.circular(7),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Color(0xff000000).withOpacity(.15),
                                                      offset: Offset(0,3),
                                                      blurRadius: 3
                                                  )
                                                ]
                                            ),
                                            child:  Center(
                                                child:  Container(
                                                    height: widget.profileTab! ?  ScreenUtil().setWidth(45) :  ScreenUtil().setWidth(50),
                                                    width: widget.profileTab! ?  ScreenUtil().setWidth(45) :  ScreenUtil().setWidth(50),
                                                    child:   SvgPicture.asset(
                                                      widget.icon!,
                                                      width: ScreenUtil().setWidth(40),
                                                      height: ScreenUtil().setWidth(40),
                                                      color: ColorPallet().mainColor,
                                                    )
                                                )
                                            ),
                                          ),
                                        ),
                                      );
                                    }else{
                                      return  Container();
                                    }
                                  },
                                );
                              }else{
                                return Container();
                              }
                            }else{
                              return Container();
                            }
                          },
                        ),
                        'right'
                    ) :
                    FutureBuilder(
                      future: checkPair(),
                      builder: (context,AsyncSnapshot<bool?>partner){
                        if(partner.data != null){
                          if(widget.profileTab! || !partner.data! || widget.isSendMessage == null){
                            return  StreamBuilder(
                              stream: _animations.squareScaleBackButtonObserve,
                              builder: (context,AsyncSnapshot<double> snapshot){
                                if(snapshot.data != null){
                                  return Transform.scale(
                                    scale: modePress == 0 ? snapshot.data : 1.0,
                                    child:  GestureDetector(
                                      onTap: ()async{
                                        setState(() {
                                          modePress = 0;
                                        });
                                        await animationControllerScaleButton.reverse();
                                        widget.onPressBack();
                                      },
                                      child:  Container(
                                        margin: EdgeInsets.only(
                                            left: widget.profileTab! ? ScreenUtil().setWidth(20) : ScreenUtil().setWidth(30)
                                        ),
                                        height: ScreenUtil().setWidth(75),
                                        width: ScreenUtil().setWidth(75),
                                        padding: EdgeInsets.only(left: widget.messages! ? ScreenUtil().setWidth(4) : 0),
                                        decoration:  BoxDecoration(
                                            borderRadius: BorderRadius.circular(7),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color(0xff000000).withOpacity(.15),
                                                  offset: Offset(0,3),
                                                  blurRadius: 3
                                              )
                                            ]
                                        ),
                                        child:  Center(
                                            child:  Container(
                                                height: widget.profileTab! ?  ScreenUtil().setWidth(45) :  ScreenUtil().setWidth(50),
                                                width: widget.profileTab! ?  ScreenUtil().setWidth(45) :  ScreenUtil().setWidth(50),
                                                child:   SvgPicture.asset(
                                                  widget.icon!,
                                                  width: ScreenUtil().setWidth(40),
                                                  height: ScreenUtil().setWidth(40),
                                                  color: ColorPallet().mainColor,
                                                )
                                            )
                                        ),
                                      ),
                                    ),
                                  );
                                }else{
                                  return  Container();
                                }
                              },
                            );
                          }else{
                            return Container();
                          }
                        }else{
                          return Container();
                        }
                      },
                    )
                    : Container(),
                    widget.profileTab! ?
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                         Text(
                          widget.titleProfileTab!,
                          style:  context.textTheme.labelMedium
                        ),
                         Padding(
                          padding: EdgeInsets.only(
                            top: ScreenUtil().setWidth(0),
                          ),
                          child:   Text(
                            widget.subTitleProfileTab!,
                              style:  context.textTheme.bodySmall
                          ),
                        )
                      ],
                    ) :
                    widget.isHelpExpert != null ?
                    StreamBuilder(
                      stream: _animations.squareScaleBackButtonObserve,
                      builder: (context,AsyncSnapshot<double> snapshotScale){
                        if(snapshotScale.data != null){
                          return Transform.scale(
                            scale: modePress == 4 ? snapshotScale.data : 1.0,
                            child: GestureDetector(
                                onTap: ()async{
                                  AnalyticsHelper().log(AnalyticsEvents.MainClinicPg_HelpClinic_Btn_Clk);
                                  if(this.mounted){
                                    setState(() {
                                      modePress = 4;
                                    });
                                  }
                                  await animationControllerScaleButton.reverse();
                                  _launchURL('https://impo.app/impoWomenManual.html','');
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setWidth(20),
                                      horizontal: ScreenUtil().setWidth(20)
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xff909FDE).withOpacity(0.2),
                                            blurRadius: 5.0
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/ic_help.svg',
                                        fit: BoxFit.cover,
                                        color: ColorPallet().mainColor,
                                        width: ScreenUtil().setWidth(30),
                                        height: ScreenUtil().setWidth(30),
                                      ),
                                      SizedBox(width: ScreenUtil().setWidth(10)),
                                      Text(
                                        'راهنما',
                                        style: context.textTheme.labelMedium!.copyWith(
                                          color: ColorPallet().mainColor,
                                        )
                                      ),
                                    ],
                                  ),
                                )
                            ),
                          );
                        }else{
                          return Container();
                        }
                      },
                    )
                        :
                    FutureBuilder(
                          future: checkPair(),
                          builder: (context,AsyncSnapshot<bool?>partner){
                         if(partner.data != null){
                          if(partner.data! && widget.isSendMessage != null){
                            return widget.idSendMessageTabTarget != null ?
                            Row(
                              children: [
                                TabTarget(
                                  id: widget.idSendMessageTabTarget,
                                  title: 'ارسال پیام',
                                  description: 'از اینجا می‌تونی برای همدلت پیام بفرستی و حست رو بهش بگی',
                                  contentLocation: ContentLocation.below,
                                  width: MediaQuery.of(context).size.width,
                                  icon: Container(
                                    width: ScreenUtil().setWidth(190),
                                    padding:
                                    EdgeInsets.symmetric(
                                        vertical: ScreenUtil().setWidth(20),
                                        horizontal: ScreenUtil().setWidth(20)),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(5),
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20)),
                                        boxShadow: [BoxShadow(color: Color(0xff909FDE).withOpacity(0.2), blurRadius: 5.0)]),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/ic_small_send_message.svg',
                                          fit: BoxFit.cover,
                                          width: ScreenUtil().setWidth(35),
                                          height: ScreenUtil().setWidth(35),
                                          color: ColorPallet().mainColor,
                                        ),
                                        SizedBox(width: ScreenUtil().setWidth(10)),
                                        Text(
                                          'پیام',
                                          style: context.textTheme.labelMedium!.copyWith(
                                            color: ColorPallet().mainColor,
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: StreamBuilder(
                                    stream: _animations.squareScaleBackButtonObserve,
                                    builder: (context,AsyncSnapshot<double> snapshotScale) {
                                      if (snapshotScale.data != null) {
                                        return Transform.scale(
                                          scale: modePress == 4 ? snapshotScale.data : 1.0,
                                          child: GestureDetector(
                                              onTap: () async {
                                                setState(() {
                                                  modePress = 4;
                                                });
                                                AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_SendMessage_Btn_Clk);
                                                await animationControllerScaleButton.reverse();
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        type: PageTransitionType.fade,
                                                        child: SendMessageScreen()
                                                    )
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: ScreenUtil().setWidth(20),
                                                    horizontal: ScreenUtil().setWidth(20)
                                                ),
                                                // width: ScreenUtil().setWidth(190),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(20),
                                                        topRight: Radius.circular(5),
                                                        bottomLeft: Radius.circular(20),
                                                        bottomRight: Radius.circular(20)),
                                                    boxShadow: [BoxShadow(color: Color(0xff909FDE).withOpacity(0.2), blurRadius: 5.0)]),
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/images/ic_small_send_message.svg',
                                                      fit: BoxFit.cover,
                                                      width: ScreenUtil().setWidth(35),
                                                      height: ScreenUtil().setWidth(35),
                                                      color: ColorPallet().mainColor,
                                                    ),
                                                    SizedBox(width: ScreenUtil().setWidth(10)),
                                                    Text(
                                                      'پیام',
                                                        style: context.textTheme.labelMedium!.copyWith(
                                                          color: ColorPallet().mainColor,
                                                        )
                                                    ),
                                                    widget.isSendMessage != null
                                                        ? StreamBuilder(
                                                      stream: notReadMessageObserve,
                                                      builder: (context, snapshotNotRead) {
                                                        if (snapshotNotRead.data != null) {
                                                          if (snapshotNotRead.data != 0) {
                                                            return Container(
                                                                width: ScreenUtil().setWidth(45),
                                                                height: ScreenUtil().setWidth(45),
                                                                margin: EdgeInsets.only(right: ScreenUtil().setWidth(5)),
                                                                padding: EdgeInsets.all(ScreenUtil().setWidth(4)),
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape.circle, color: ColorPallet().mainColor),
                                                                child: Center(
                                                                  child: Text(
                                                                    snapshotNotRead.data.toString(),
                                                                    textAlign: TextAlign.center,
                                                                      style: context.textTheme.labelMedium!.copyWith(
                                                                        color: Colors.white,
                                                                      )
                                                                  ),
                                                                ));
                                                          } else {
                                                            return Container();
                                                          }
                                                        } else {
                                                          return Container();
                                                        }
                                                      },
                                                    )
                                                        : Container()
                                                  ],
                                                ),
                                              )),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(width: ScreenUtil().setWidth(20)),
                                StreamBuilder(
                                  stream: _animations.squareScaleBackButtonObserve,
                                  builder: (context, AsyncSnapshot<double> snapshotScale) {
                                    if (snapshotScale.data != null) {
                                      return Transform.scale(
                                        scale: modePress == 6 ? snapshotScale.data : 1.0,
                                        child: GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                modePress = 6;
                                              });
                                              AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_MemoryGame_Btn_Clk);
                                              await animationControllerScaleButton.reverse();
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType.fade,
                                                      child: MemoryGameScreen()
                                                  )
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: ScreenUtil().setWidth(20), horizontal: ScreenUtil().setWidth(20)),
                                              // width: ScreenUtil().setWidth(190),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(20),
                                                      topRight: Radius.circular(5),
                                                      bottomLeft: Radius.circular(20),
                                                      bottomRight: Radius.circular(20)),
                                                  boxShadow: [BoxShadow(color: Color(0xff909FDE).withOpacity(0.2), blurRadius: 5.0)]),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/images/ic_diary.svg',
                                                    fit: BoxFit.cover,
                                                    width: ScreenUtil().setWidth(35),
                                                    height: ScreenUtil().setWidth(35),
                                                  ),
                                                  SizedBox(width: ScreenUtil().setWidth(10)),
                                                  Text(
                                                    'خاطره‌بازی',
                                                      style: context.textTheme.labelMedium!.copyWith(
                                                        color: ColorPallet().mainColor,
                                                      )
                                                  ),
                                                ],
                                              ),
                                            )),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                )
                              ],
                            )
                                :
                            Row(
                              children: [
                                StreamBuilder(
                                  stream: _animations.squareScaleBackButtonObserve,
                                  builder: (context,AsyncSnapshot<double> snapshotScale) {
                                    if (snapshotScale.data != null) {
                                      return Transform.scale(
                                        scale: modePress == 4 ? snapshotScale.data : 1.0,
                                        child: GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                modePress = 4;
                                              });
                                              AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_SendMessage_Btn_Clk);
                                              await animationControllerScaleButton.reverse();
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType.fade,
                                                      child: SendMessageScreen()
                                                  )
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: ScreenUtil().setWidth(20), horizontal: ScreenUtil().setWidth(20)),
                                              // width: ScreenUtil().setWidth(190),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(20),
                                                      topRight: Radius.circular(5),
                                                      bottomLeft: Radius.circular(20),
                                                      bottomRight: Radius.circular(20)),
                                                  boxShadow: [BoxShadow(color: Color(0xff909FDE).withOpacity(0.2), blurRadius: 5.0)]),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/images/ic_small_send_message.svg',
                                                    fit: BoxFit.cover,
                                                    width: ScreenUtil().setWidth(35),
                                                    height: ScreenUtil().setWidth(35),
                                                    color: ColorPallet().mainColor
                                                  ),
                                                  SizedBox(width: ScreenUtil().setWidth(10)),
                                                  Text(
                                                    'پیام' ,
                                                      style: context.textTheme.labelMedium!.copyWith(
                                                        color: ColorPallet().mainColor,
                                                      )
                                                  ),
                                                  StreamBuilder(
                                                    stream: notReadMessageObserve,
                                                    builder: (context, snapshotNotRead) {
                                                      if (snapshotNotRead.data != null) {
                                                        if (snapshotNotRead.data != 0) {
                                                          return Container(
                                                              width: ScreenUtil().setWidth(45),
                                                              height: ScreenUtil().setWidth(45),
                                                              margin: EdgeInsets.only(right: ScreenUtil().setWidth(5)),
                                                              padding: EdgeInsets.all(ScreenUtil().setWidth(4)),
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape.circle, color: ColorPallet().mainColor),
                                                              child: Center(
                                                                child: Text(
                                                                  snapshotNotRead.data.toString(),
                                                                  textAlign: TextAlign.center,
                                                                    style: context.textTheme.labelMedium!.copyWith(
                                                                      color: Colors.white,
                                                                    )
                                                                ),
                                                              ));
                                                        } else {
                                                          return Container();
                                                        }
                                                      } else {
                                                        return Container();
                                                      }
                                                    },
                                                  )
                                                ],
                                              ),
                                            )),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                                SizedBox(width: ScreenUtil().setWidth(20)),
                                StreamBuilder(
                                  stream: _animations.squareScaleBackButtonObserve,
                                  builder: (context,AsyncSnapshot<double> snapshotScale) {
                                    if (snapshotScale.data != null) {
                                      return Transform.scale(
                                        scale: modePress == 6 ? snapshotScale.data : 1.0,
                                        child: GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                modePress = 6;
                                              });
                                              AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_MemoryGame_Btn_Clk);
                                              await animationControllerScaleButton.reverse();
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType.fade,
                                                      child: MemoryGameScreen()
                                                  )
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: ScreenUtil().setWidth(10), horizontal: ScreenUtil().setWidth(20)),
                                              // width: ScreenUtil().setWidth(190),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(20),
                                                      topRight: Radius.circular(5),
                                                      bottomLeft: Radius.circular(20),
                                                      bottomRight: Radius.circular(20)),
                                                  boxShadow: [BoxShadow(color: Color(0xff909FDE).withOpacity(0.2), blurRadius: 5.0)]),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/images/ic_diary.svg',
                                                    fit: BoxFit.cover,
                                                    width: ScreenUtil().setWidth(35),
                                                    height: ScreenUtil().setWidth(35),
                                                  ),
                                                  SizedBox(width: ScreenUtil().setWidth(10)),
                                                  Text(
                                                    'خاطره‌بازی',
                                                      style: context.textTheme.labelMedium!.copyWith(
                                                        color: ColorPallet().mainColor,
                                                      )
                                                  ),
                                                ],
                                              ),
                                            )),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                )
                              ],
                            );
                          }else{
                            return  Padding(
                              padding:  EdgeInsets.only(
                                top: ScreenUtil().setWidth(20)
                              ),
                              child: FutureBuilder(
                                future: todayDate(),
                                builder: (context,snapshot){
                                  return   Text(
                                    snapshot.data != null ? 'امروز ${snapshot.data}' : '',
                                      style: context.textTheme.bodyMedium!.copyWith(
                                        color: ColorPallet().mainColor,
                                      )
                                  );
                                },
                              ),
                            );
                          }
                        }else{
                          return Container();
                        }
                      },
                    )
                  ],
                ),
                widget.anim != null ?
                 FadeIn(
                    2.0,
                     Row(
                      children: <Widget>[
                        widget.isReminder != null ?
                         StreamBuilder(
                          stream: _animations.squareScaleBackButtonObserve,
                          builder: (context,AsyncSnapshot<double> snapshot){
                            if(snapshot.data != null){
                              return Transform.scale(
                                scale: modePress == 2 ? snapshot.data : 1.0,
                                child:  GestureDetector(
                                  onTap: ()async{
                                    setState(() {
                                      modePress = 2;
                                    });
                                    await animationControllerScaleButton.reverse();
                                    Timer(Duration(milliseconds: 100),(){
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType.fade,
                                              child: AlarmsScreen(
                                                isOfflineMode: false,
                                              )
                                          )
                                      );
                                    });
                                  },
                                  child:  Container(
                                    height: ScreenUtil().setWidth(75),
                                    width: ScreenUtil().setWidth(75),
                                    margin: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(30)
                                    ),
                                    padding: EdgeInsets.only(left:ScreenUtil().setWidth(4)),
                                    decoration:  BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(0xff000000).withOpacity(.15),
                                              offset: Offset(0,3),
                                              blurRadius: 3
                                          )
                                        ]
                                    ),
                                    child:  Center(
                                        child:  SvgPicture.asset(
                                          'assets/images/ic_reminder.svg',
                                          color: ColorPallet().mainColor,
                                          width: ScreenUtil().setWidth(45),
                                          height: ScreenUtil().setWidth(45),
                                        )
                                    ),
                                  ),
                                ),
                              );
                            }else{
                              return  Container();
                            }
                          },
                        )
                            :  Container(),
                        widget.isEmptyLeftIcon == null ?
                        widget.isLogoImpo != null ?
                        Container(
                          height: ScreenUtil().setWidth(70),
                          width: ScreenUtil().setWidth(70),
                          decoration:  BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xffF591D3).withOpacity(.5),
                                    offset: Offset(0,3),
                                    blurRadius: 3
                                )
                              ]
                          ),
                          child:  Image.asset(
                            'assets/images/impo_icon.png',
                            fit: BoxFit.cover,
                          ),
                        ) :
                        StreamBuilder(
                          stream: _animations.squareScaleBackButtonObserve,
                          builder: (context,AsyncSnapshot<double> snapshot){
                            if(snapshot.data != null){
                              return Transform.scale(
                                scale: modePress == 5 ? snapshot.data : 1.0,
                                child:  GestureDetector(
                                  onTap: ()async{
                                    if(widget.historyTicket != null){
                                      AnalyticsHelper().log(AnalyticsEvents.MainClinicPg_HistoryTickets_Btn_Clk);
                                    }
                                    if(widget.historySupport != null){
                                      AnalyticsHelper().log(AnalyticsEvents.SupportPg_HistorySupport_Icon_Clk);
                                    }
                                    setState(() {
                                      modePress = 5;
                                    });
                                    await animationControllerScaleButton.reverse();
                                    if(widget.partnerTabPresenter != null){
                                      Timer(Duration(milliseconds: 100),()async{
                                       await Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType.fade,
                                                child:  FeatureDiscovery(
                                                    recordStepsInSharedPreferences: true,
                                                    child:  widget.historyTicket !=   null ?
                                                    ClinicQuestionList(
                                                      currentValue: widget.valuePolar,
                                                      expertPresenter: widget.expertPresenter!,
                                                      isAllTicket: true,
                                                    ) : widget.historySupport != null ?
                                                    SupportHistoryScreen(
                                                      supportPresenter: widget.supportPresenter!,
                                                    ) :
                                                    ProfileScreen()
                                                )
                                            )
                                        );
                                      });
                                      widget.partnerTabPresenter!.initBioRhythm(context);
                                    }else{
                                      Timer(Duration(milliseconds: 100),(){
                                        if(widget.historyTicket != null){
                                          AnalyticsHelper().log(AnalyticsEvents.MainClinicPg_HistoryTickets_Btn_Clk);
                                        }
                                        if(widget.historySupport != null){
                                          AnalyticsHelper().log(AnalyticsEvents.SupportPg_HistorySupport_Icon_Clk);
                                        }
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType.fade,
                                                child:  FeatureDiscovery(
                                                    recordStepsInSharedPreferences: true,
                                                    child:   widget.historyTicket !=   null ?
                                                    ClinicQuestionList(
                                                      currentValue: widget.valuePolar,
                                                      expertPresenter: widget.expertPresenter!,
                                                      isAllTicket: true,
                                                    ): widget.historySupport != null ?
                                                    SupportHistoryScreen(
                                                      supportPresenter: widget.supportPresenter!,
                                                    ) :
                                                    ProfileScreen()
                                                )
                                            )
                                        );
                                      });
                                    }
                                  },
                                  child:  Container(
                                    height: ScreenUtil().setWidth(75),
                                    width: ScreenUtil().setWidth(75),
                                    padding: EdgeInsets.only(left:ScreenUtil().setWidth(4)),
                                    decoration:  BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color:  Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(0xff000000).withOpacity(.15),
                                              offset: Offset(0,3),
                                              blurRadius: 3
                                          )
                                        ]
                                    ),
                                    child:  Center(
                                        child: SvgPicture.asset(
                                          widget.historyTicket != null  || widget.historySupport != null?
                                           'assets/images/history_ticket.svg' :
                                          'assets/images/ic_name.svg',
                                          color: ColorPallet().mainColor,
                                          width: ScreenUtil().setWidth(45),
                                          height: ScreenUtil().setWidth(45),
                                        )
                                    ),
                                  ),
                                ),
                              );
                            }else{
                              return  Container();
                            }
                          },
                        )
                            : Container()
                      ],
                    ),
                    'left'
                ) :
                 Row(
                  children: <Widget>[
                    widget.isPolar != null && widget.valuePolar != null ?
                        widget.idPolarTabTarget != null ?
                         TabTarget(
                          id : widget.idPolarTabTarget,
                            title: 'ایمپو بانک' ,
                            description: 'برای ارتباط با مشاور پولار لازم میشه و از این قسمت می‌تونی پولار تهیه کنی' ,
                            contentLocation: ContentLocation.below,
                          icon:   Stack(
                            alignment: Alignment.centerLeft,
                            children: <Widget>[
                               Container(
                                padding: EdgeInsets.only(
                                    right: ScreenUtil().setWidth(20)
                                ),
                                width: ScreenUtil().setWidth(150),
                                height: ScreenUtil().setWidth(60),
                                decoration:  BoxDecoration(
                                  color: Color(0xffF9C500).withOpacity(.35),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child:  Text(
                                    widget.valuePolar != null ? widget.valuePolar : '0',
                                    style:  context.textTheme.labelLarge!.copyWith(
                                      color: Color(0xffB47912),
                                    )
                                  ),
                                ),
                              ),
                               Container(
                                  height: ScreenUtil().setWidth(65),
                                  width: ScreenUtil().setWidth(65),
                                  child:   Image.asset(
                                    'assets/images/ic_polar.png',
                                    fit: BoxFit.cover,
                                  )
                              )
                            ],
                          ),
                          child:  StreamBuilder(
                            stream: _animations.squareScaleBackButtonObserve,
                            builder: (context,AsyncSnapshot<double> snapshotScale){
                              if(snapshotScale.data != null){
                                return  Transform.scale(
                                    scale: modePress == 1 ? snapshotScale.data : 1.0,
                                    child:  GestureDetector(
                                      onTap: ()async{
                                        if(widget.expertPresenter != null){
                                          if(widget.pressShop == null){
                                            setState(() {
                                              modePress = 1;
                                            });
                                            await animationControllerScaleButton.reverse();
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    type: PageTransitionType.fade,
                                                    child:  PolarHistoryScreen(
                                                      expertPresenter: widget.expertPresenter!,
                                                    )
                                                )
                                                // PageTransition(
                                                //     type: PageTransitionType.fade,
                                                //     child:  ShopScreen(
                                                //       expertPresenter: widget.expertPresenter,
                                                //       fromScreen: 0,
                                                //     )
                                                // )
                                            );
                                          }
                                        }
                                      },
                                      child:  Stack(
                                        alignment: Alignment.centerLeft,
                                        children: <Widget>[
                                           Container(
                                            padding: EdgeInsets.only(
                                                right: ScreenUtil().setWidth(20)
                                            ),
                                            width: ScreenUtil().setWidth(150),
                                            height: ScreenUtil().setWidth(60),
                                            decoration:  BoxDecoration(
                                              color: Color(0xffF9C500).withOpacity(.35),
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child:  Text(
                                                widget.valuePolar != null ? widget.valuePolar : '0',
                                                  style:  context.textTheme.labelLarge!.copyWith(
                                                    color: Color(0xffB47912),
                                                  )
                                              ),
                                            ),
                                          ),
                                           Container(
                                              height: ScreenUtil().setWidth(65),
                                              width: ScreenUtil().setWidth(65),
                                              child:   Image.asset(
                                                'assets/images/ic_polar.png',
                                                fit: BoxFit.cover,
                                              )
                                          )
                                        ],
                                      ),
                                    )
                                );
                              }else{
                                return  Container();
                              }
                            },
                          )
                        )
                            :
                         StreamBuilder(
                          stream: _animations.squareScaleBackButtonObserve,
                          builder: (context,AsyncSnapshot<double> snapshotScale){
                            if(snapshotScale.data != null){
                              return  Transform.scale(
                                  scale: modePress == 1 ? snapshotScale.data : 1.0,
                                  child:  GestureDetector(
                                    onTap: ()async{
                                      if(widget.expertPresenter != null){
                                        if(widget.pressShop == null){
                                          setState(() {
                                            modePress = 1;
                                          });
                                          await animationControllerScaleButton.reverse();
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child:  PolarHistoryScreen(
                                                    expertPresenter: widget.expertPresenter!,
                                                  )
                                              )
                                              // PageTransition(
                                              //     type: PageTransitionType.fade,
                                              //     child:  ShopScreen(
                                              //       expertPresenter: widget.expertPresenter,
                                              //       fromScreen: 0,
                                              //     )
                                              // )
                                          );
                                        }
                                      }
                                    },
                                    child:  Stack(
                                      alignment: Alignment.centerLeft,
                                      children: <Widget>[
                                         Container(
                                          padding: EdgeInsets.only(
                                              right: ScreenUtil().setWidth(20)
                                          ),
                                          width: ScreenUtil().setWidth(150),
                                          height: ScreenUtil().setWidth(60),
                                          decoration:  BoxDecoration(
                                            color: Color(0xffF9C500).withOpacity(.35),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child:  Text(
                                              widget.valuePolar != null ? widget.valuePolar : '0',
                                                style:  context.textTheme.labelLarge!.copyWith(
                                                  color: Color(0xffB47912),
                                                )
                                            ),
                                          ),
                                        ),
                                         Container(
                                            height: ScreenUtil().setWidth(65),
                                            width: ScreenUtil().setWidth(65),
                                            child:   Image.asset(
                                              'assets/images/ic_polar.png',
                                              fit: BoxFit.cover,
                                            )
                                        )
                                      ],
                                    ),
                                  )
                              );
                            }else{
                              return  Container();
                            }
                          },
                        )
                        :
                     Container(),
                    widget.isReminder != null ?
                    widget.idReminderTabTarget != null ?
                     TabTarget(
                        id: widget.idReminderTabTarget,
                        title: 'یادآورهای روزانه' ,
                        description: 'از این قسمت می‌تونی یادآورهای روزانه تنظیم کنی' ,
                        contentLocation: ContentLocation.below,
                       icon:  Container
                         (
                         height: ScreenUtil().setWidth(75),
                         width: ScreenUtil().setWidth(75),
                         padding: EdgeInsets.only(left:ScreenUtil().setWidth(4)),
                         decoration:  BoxDecoration(
                             borderRadius: BorderRadius.circular(7),
                             color:  Colors.white,
                             boxShadow: [
                               BoxShadow(
                                   color: Color(0xff000000).withOpacity(.15),
                                   offset: Offset(0,3),
                                   blurRadius: 3
                               )
                             ]
                         ),
                         child:  Center(
                             child:  SvgPicture.asset(
                               'assets/images/ic_reminder.svg',
                               color: ColorPallet().mainColor,
                               width: ScreenUtil().setWidth(45),
                               height: ScreenUtil().setWidth(45),
                             )
                         ),
                       ),
                      child:  StreamBuilder(
                        stream: _animations.squareScaleBackButtonObserve,
                        builder: (context,AsyncSnapshot<double> snapshot){
                          if(snapshot.data != null){
                            return Transform.scale(
                              scale: modePress == 2 ? snapshot.data : 1.0,
                              child:  GestureDetector(
                                onTap: ()async{
                                  setState(() {
                                    modePress = 2;
                                  });
                                  await animationControllerScaleButton.reverse();
                                  Timer(Duration(milliseconds: 100),(){
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.fade,
                                            child: AlarmsScreen(
                                              isOfflineMode: false,
                                            )
                                        )
                                    );
                                  });
                                },
                                child:  Container(
                                  height: ScreenUtil().setWidth(75),
                                  width: ScreenUtil().setWidth(75),
                                  padding: EdgeInsets.only(left:ScreenUtil().setWidth(4)),
                                  decoration:  BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color:  Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xff000000).withOpacity(.15),
                                            offset: Offset(0,3),
                                            blurRadius: 3
                                        )
                                      ]
                                  ),
                                  child:  Center(
                                      child: SvgPicture.asset(
                                        'assets/images/ic_reminder.svg',
                                        color: ColorPallet().mainColor,
                                        width: ScreenUtil().setWidth(45),
                                        height: ScreenUtil().setWidth(45),
                                      )
                                  ),
                                ),
                              ),
                            );
                          }else{
                            return  Container();
                          }
                        },
                      )
                    )
                    :  StreamBuilder(
                      stream: _animations.squareScaleBackButtonObserve,
                      builder: (context,AsyncSnapshot<double> snapshot){
                        if(snapshot.data != null){
                          return Transform.scale(
                            scale: modePress == 2 ? snapshot.data : 1.0,
                            child:  GestureDetector(
                              onTap: ()async{
                                setState(() {
                                  modePress = 2;
                                });
                                await animationControllerScaleButton.reverse();
                                Timer(Duration(milliseconds: 100),(){
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.fade,
                                          child: AlarmsScreen(
                                            isOfflineMode: false,
                                          )
                                      )
                                  );
                                });
                              },
                              child:  Container(
                                height: ScreenUtil().setWidth(75),
                                width: ScreenUtil().setWidth(75),
                                padding: EdgeInsets.only(left:ScreenUtil().setWidth(4)),
                                decoration:  BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color:  Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xff000000).withOpacity(.15),
                                          offset: Offset(0,3),
                                          blurRadius: 3
                                      )
                                    ]
                                ),
                                child:  Center(
                                    child:  SvgPicture.asset(
                                      'assets/images/ic_reminder.svg',
                                      color: ColorPallet().mainColor,
                                      width: ScreenUtil().setWidth(45),
                                      height: ScreenUtil().setWidth(45),
                                    )
                                ),
                              ),
                            ),
                          );
                        }else{
                          return  Container();
                        }
                      },
                    )
                        :  Container(),
                    widget.infoShareExp != null ?
                    StreamBuilder(
                      stream: _animations.squareScaleBackButtonObserve,
                      builder: (context,AsyncSnapshot<double> snapshot){
                        if(snapshot.data != null){
                          return Transform.scale(
                            scale: modePress == 7 ? snapshot.data : 1.0,
                            child:  GestureDetector(
                              onTap: ()async{
                                setState(() {
                                  modePress = 7;
                                });
                                await animationControllerScaleButton.reverse();
                                AnalyticsHelper().log(AnalyticsEvents.ShareExpPg_Info_Btn_Clk);
                                _launchURL('https://impo.app/shareeexperience', '');
                              },
                              child:  Container(
                                height: ScreenUtil().setWidth(75),
                                width: ScreenUtil().setWidth(75),
                                padding: EdgeInsets.only(left:ScreenUtil().setWidth(4)),
                                decoration:  BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color:  Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xff000000).withOpacity(.15),
                                          offset: Offset(0,3),
                                          blurRadius: 3
                                      )
                                    ]
                                ),
                                child:  Center(
                                    child:  SvgPicture.asset(
                                      'assets/images/info_outline.svg',
                                      color: ColorPallet().mainColor,
                                      width: ScreenUtil().setWidth(45),
                                      height: ScreenUtil().setWidth(45),
                                    )
                                ),
                              ),
                            ),
                          );
                        }else{
                          return  Container();
                        }
                      },
                    )
                        : SizedBox.shrink(),
                    widget.isEmptyLeftIcon == null
                    ?  SizedBox(width: ScreenUtil().setWidth(30)) : Container(),
                    widget.isEmptyLeftIcon == null ?
                    widget.screenController == null ?
                    widget.isLogoImpo != null ?
                    Container(
                      height: ScreenUtil().setWidth(70),
                      width: ScreenUtil().setWidth(70),
                      decoration:  BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xffF591D3).withOpacity(.5),
                                offset: Offset(0,3),
                                blurRadius: 3
                            )
                          ]
                      ),
                      child:  Image.asset(
                        'assets/images/impo_icon.png',
                        fit: BoxFit.cover,
                      ),
                    ) :
                    widget.idProfileTabTarget != null ?
                    TabTarget(
                        id: widget.idProfileTabTarget,
                        title: 'کاربری' ,
                        description: 'از این قسمت می‌تونی اطلاعات کاربریت رو ببینی و در صورت نیاز تغییر بدی' ,
                        contentLocation: ContentLocation.below,
                        icon: Container(
                          height: ScreenUtil().setWidth(75),
                          width: ScreenUtil().setWidth(75),
                          padding: EdgeInsets.only(left:ScreenUtil().setWidth(4)),
                          decoration:  BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color:  Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xff000000).withOpacity(.15),
                                    offset: Offset(0,3),
                                    blurRadius: 3
                                )
                              ]
                          ),
                          child:  Center(
                              child: SvgPicture.asset(
                                widget.historyTicket != null || widget.historySupport != null ?
                                'assets/images/history_ticket.svg' :
                                'assets/images/ic_name.svg',
                                color: ColorPallet().mainColor,
                                width: ScreenUtil().setWidth(45),
                                height: ScreenUtil().setWidth(45),
                              )
                          ),
                        ),
                        child: StreamBuilder(
                          stream: _animations.squareScaleBackButtonObserve,
                          builder: (context,AsyncSnapshot<double> snapshot){
                            if(snapshot.data != null){
                              return Transform.scale(
                                scale: modePress == 5 ? snapshot.data : 1.0,
                                child:  GestureDetector(
                                  onTap: ()async{
                                    setState(() {
                                      modePress = 5;
                                    });
                                    await animationControllerScaleButton.reverse();
                                    if(widget.partnerTabPresenter != null){
                                      if(widget.historyTicket != null){
                                        AnalyticsHelper().log(AnalyticsEvents.MainClinicPg_HistoryTickets_Btn_Clk);
                                      }
                                      if(widget.historySupport != null){
                                        AnalyticsHelper().log(AnalyticsEvents.SupportPg_HistorySupport_Icon_Clk);
                                      }
                                      Timer(Duration(milliseconds: 100),()async{
                                        await Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType.fade,
                                                child:  FeatureDiscovery(
                                                    recordStepsInSharedPreferences: true,
                                                    child: widget.polarHistory != null ?
                                                    PolarHistoryScreen(
                                                      expertPresenter: widget.expertPresenter!,
                                                    ) :
                                                    widget.historyTicket !=   null ?
                                                    ClinicQuestionList(
                                                      currentValue: widget.valuePolar,
                                                      expertPresenter: widget.expertPresenter!,
                                                      isAllTicket: true,
                                                    ): widget.historySupport != null ?
                                                    SupportHistoryScreen(
                                                      supportPresenter: widget.supportPresenter!,
                                                    ) :
                                                    ProfileScreen()
                                                )
                                            )
                                        );
                                      });
                                      widget.partnerTabPresenter!.initBioRhythm(context);
                                    }else{
                                      Timer(Duration(milliseconds: 100),(){
                                        if(widget.historyTicket != null){
                                          AnalyticsHelper().log(AnalyticsEvents.MainClinicPg_HistoryTickets_Btn_Clk);
                                        }
                                        if(widget.historySupport != null){
                                          AnalyticsHelper().log(AnalyticsEvents.SupportPg_HistorySupport_Icon_Clk);
                                        }
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType.fade,
                                                child:  FeatureDiscovery(
                                                    recordStepsInSharedPreferences: true,
                                                    child: widget.polarHistory != null ?
                                                    PolarHistoryScreen(
                                                      expertPresenter: widget.expertPresenter!,
                                                    ) :
                                                    widget.historyTicket !=   null ?
                                                    ClinicQuestionList(
                                                      currentValue: widget.valuePolar,
                                                      expertPresenter: widget.expertPresenter!,
                                                      isAllTicket: true,
                                                    ): widget.historySupport != null ?
                                                    SupportHistoryScreen(
                                                      supportPresenter: widget.supportPresenter!,
                                                    ) :
                                                    ProfileScreen()
                                                )
                                            )
                                        );
                                      });
                                    }
                                  },
                                  child:  Container(
                                    height: ScreenUtil().setWidth(75),
                                    width: ScreenUtil().setWidth(75),
                                    padding: EdgeInsets.only(left:ScreenUtil().setWidth(4)),
                                    decoration:  BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        color:  Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(0xff000000).withOpacity(.15),
                                              offset: Offset(0,3),
                                              blurRadius: 3
                                          )
                                        ]
                                    ),
                                    child:  Center(
                                        child: SvgPicture.asset(
                                          widget.historyTicket != null || widget.historySupport != null ?
                                          'assets/images/history_ticket.svg' :
                                          'assets/images/ic_name.svg',
                                          color: ColorPallet().mainColor,
                                          width: ScreenUtil().setWidth(45),
                                          height: ScreenUtil().setWidth(45),
                                        )
                                    ),
                                  ),
                                ),
                              );
                            }else{
                              return  Container();
                            }
                          },
                        )
                    ) :
                    StreamBuilder(
                      stream: _animations.squareScaleBackButtonObserve,
                      builder: (context,AsyncSnapshot<double> snapshot){
                        if(snapshot.data != null){
                          return Transform.scale(
                            scale: modePress == 5 ? snapshot.data : 1.0,
                            child:  GestureDetector(
                              onTap: ()async{
                                setState(() {
                                  modePress = 5;
                                });
                                await animationControllerScaleButton.reverse();
                                if(widget.partnerTabPresenter != null){
                                  if(widget.historyTicket != null){
                                    AnalyticsHelper().log(AnalyticsEvents.MainClinicPg_HistoryTickets_Btn_Clk);
                                  }
                                  if(widget.historySupport != null){
                                    AnalyticsHelper().log(AnalyticsEvents.SupportPg_HistorySupport_Icon_Clk);
                                  }
                                  Timer(Duration(milliseconds: 100),()async{
                                    await Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.fade,
                                            child:  FeatureDiscovery(
                                                recordStepsInSharedPreferences: true,
                                                child: widget.polarHistory != null ?
                                                PolarHistoryScreen(
                                                  expertPresenter: widget.expertPresenter!,
                                                ) :
                                                widget.historyTicket !=   null ?
                                                ClinicQuestionList(
                                                  currentValue: widget.valuePolar,
                                                  expertPresenter: widget.expertPresenter!,
                                                  isAllTicket: true,
                                                ): widget.historySupport != null ?
                                                SupportHistoryScreen(
                                                  supportPresenter: widget.supportPresenter!,
                                                ) :
                                                ProfileScreen()
                                            )
                                        )
                                    );
                                  });
                                  widget.partnerTabPresenter!.initBioRhythm(context);
                                }else{
                                  if(widget.historyTicket != null){
                                    AnalyticsHelper().log(AnalyticsEvents.MainClinicPg_HistoryTickets_Btn_Clk);
                                  }
                                  if(widget.historySupport != null){
                                    AnalyticsHelper().log(AnalyticsEvents.SupportPg_HistorySupport_Icon_Clk);
                                  }
                                  Timer(Duration(milliseconds: 100),(){
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.fade,
                                            child:  FeatureDiscovery(
                                                recordStepsInSharedPreferences: true,
                                                child: widget.polarHistory != null ?
                                                PolarHistoryScreen(
                                                  expertPresenter: widget.expertPresenter!,
                                                ) :
                                                widget.historyTicket !=   null ?
                                                ClinicQuestionList(
                                                  currentValue: widget.valuePolar,
                                                  expertPresenter: widget.expertPresenter!,
                                                  isAllTicket: true,
                                                ): widget.historySupport != null ?
                                                SupportHistoryScreen(
                                                  supportPresenter: widget.supportPresenter!,
                                                ) :
                                                ProfileScreen()
                                            )
                                        )
                                    );
                                  });
                                }
                              },
                              child:  Container(
                                height: ScreenUtil().setWidth(75),
                                width: ScreenUtil().setWidth(75),
                                padding: EdgeInsets.only(left:ScreenUtil().setWidth(4)),
                                decoration:  BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color:  Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xff000000).withOpacity(.15),
                                          offset: Offset(0,3),
                                          blurRadius: 3
                                      )
                                    ]
                                ),
                                child:  Center(
                                    child: SvgPicture.asset(
                                      widget.polarHistory != null ?
                                      'assets/images/ic_history_polar.svg' :
                                      widget.historyTicket != null || widget.historySupport != null ?
                                      'assets/images/history_ticket.svg' :
                                      'assets/images/ic_name.svg',
                                      color: ColorPallet().mainColor,
                                      width: ScreenUtil().setWidth(45),
                                      height: ScreenUtil().setWidth(45),
                                    )
                                ),
                              ),
                            ),
                          );
                        }else{
                          return  Container();
                        }
                      },
                    )
                        :
                    Screenshot(
                      controller: widget.screenController,
                      child :  Container(
                        height: ScreenUtil().setWidth(70),
                        width: ScreenUtil().setWidth(70),
                        decoration:  BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xffF591D3).withOpacity(.5),
                                  offset: Offset(0,3),
                                  blurRadius: 3
                              )
                            ]
                        ),
                        child:  Image.asset(
                          'assets/images/impo_icon.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                        : Container()
                  ],
                ),
              ],
            ),
            widget.messages!  && widget.isPolar == null?
            StreamBuilder(
              stream: _animations.squareScaleBackButtonObserve,
              builder: (context,AsyncSnapshot<double> snapshot){
                if(snapshot.data != null){
                  return Transform.scale(
                    scale: modePress == 3 ? snapshot.data : 1,
                    child: GestureDetector(
                      onTap: ()async{
                        if(widget.link != null){
                          if(widget.typeLink != null){
                            if(widget.typeLink == 1 || widget.typeLink == 2){
                              if(widget.typeLink == 1){
                                if(widget.link != ''){
                                  if(widget.expertPresenter != null){
                                    setState(() {
                                      modePress = 3;
                                    });
                                    await animationControllerScaleButton.reverse();
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.fade,
                                            child:  ClinicQuestionScreen(
                                              expertPresenter: widget.expertPresenter!,
                                              bodyTicketInfo: json.decode(widget.link),
                                              // ticketId: ticketsModel.ticketId,
                                            )
                                        )
                                    );
                                  }
                                }
                              }
                              if(widget.typeLink == 2){
                                if(widget.link != ''){
                                  setState(() {
                                    modePress = 3;
                                  });
                                  await animationControllerScaleButton.reverse();
                                  _launchURL(widget.link,widget.idMotivalMessage);
                                }
                              }
                            }
                          }
                        }
                      },
                      child :  Align(
                          alignment: Alignment.centerLeft,
                          child:  Container(
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setWidth(8),
                                bottom: ScreenUtil().setWidth(13),
                                right: ScreenUtil().setWidth(40),
                                left: ScreenUtil().setWidth(40)
                            ),
                            margin: EdgeInsets.only(
                              top: ScreenUtil().setWidth(30),
//                  left: ScreenUtil().setWidth(10),
//                  right: ScreenUtil().setWidth(10)
                            ),
                            decoration:  BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20) ,
                                  bottomRight: Radius.circular(20),
                                ),
                                color: Color(0xffFFE8F7).withOpacity(.8)
                            ),
                            child:  Row(
                              children: [
                                widget.link != '' ?
                                ScaleTransition(
                                  scale: _tween.animate(CurvedAnimation(parent: _controller, curve: Curves.ease)),
                                  child:  Container(
                                    width: ScreenUtil().setWidth(45),
                                    height:  ScreenUtil().setWidth(45),
                                    padding: EdgeInsets.all( ScreenUtil().setWidth(8)),
                                    decoration: BoxDecoration(
                                      color: ColorPallet().mainColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                        'assets/images/ic_link_.png'
                                    ),
                                  ),
                                )
                                    : Container(),
                                widget.link != '' ?
                                SizedBox(width: ScreenUtil().setWidth(10)) :
                                Container(),
                                Flexible(
                                  child:  Text(
                                    widget.titleMessage,
                                    textAlign: TextAlign.start,
                                    style:  context.textTheme.bodySmall!.copyWith(
                                      color: Color(0xff575757),
                                    )
                                  ),
                                )
                              ],
                            )
                          )
                      )
                    ),
                  );
                }else{
                  return Container();
                }
              },
            )
                :  Container()
          ],
        )
    );

  }

  Future<bool> _launchURL(String url,id) async {
    if(id != null){
      if(id != ''){
        clickOnPinMessages('motival', id);
      }
    }
    String httpUrl = '';
    if(url.startsWith('http')){
      httpUrl = url;
    }else{
      httpUrl = 'https://$url';
    }
    // if (await canLaunch(httpUrl)) {
    //   await launch(httpUrl);
    // } else {
    //   throw 'Could not launch $httpUrl';
    // }
    if (!await launch(httpUrl)) throw 'Could not launch $httpUrl';
    return true;
  }

  clickOnPinMessages(String type, String id) async {
    var register = locator<RegisterParamModel>();
    Map responseBody = await Http().sendRequest(
        womanUrl, 'report/msg$type/$id', 'POST', {}, register.register.token!);
    print(responseBody);
  }

}