
import 'dart:async';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/dashboard_presenter.dart';
import 'package:impo/src/architecture/presenter/profile_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/dialogs/exit_dialog.dart';
import 'package:impo/src/components/dialogs/qus_dialog.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/messages/generate_dashboard_notify_and_messages.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/profile/item_my_impo_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/home/home.dart';
import 'package:impo/src/screens/home/tabs/profile/change_calendar_type_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/change_circles_value.dart';
import 'package:impo/src/screens/home/tabs/profile/edit_profile.dart';
import 'package:impo/src/screens/home/tabs/profile/enter_face_code_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/password_screen.dart';
import 'package:impo/src/screens/LoginAndRegister/enter_pass_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/profile_sceen.dart';
import 'package:impo/src/screens/subscribe/choose_subscription_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:impo/src/data/local/database_provider.dart';

import '../../../../firebase_analytics_helper.dart';

class MyImpoScreen extends StatefulWidget{

  final ProfilePresenter? presenter;
  MyImpoScreen({Key? key,this.presenter}):super(key:key);

  @override
  State<StatefulWidget> createState() => MyImpoScreenState();
}

class MyImpoScreenState extends State<MyImpoScreen> with TickerProviderStateMixin{

  Animations _animations =  Animations();
  late AnimationController animationControllerScaleButtons;
  String? pass;
  bool isNotify = false;
  double opacity = 1.0;
  // bool interfaceVisibility = false;
  int modePress = 0;
  ExitDialog exitDialog =  ExitDialog();

  @override
  void initState() {
    initLocalNotify();
    animationControllerScaleButtons = _animations.pressButton(this);
    exitDialog.initialDialogScale(this);
    getPass();
    widget.presenter!.initialDialogScale(this);
    super.initState();
  }

  getPass()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // if(prefs.getBool('interfaceVisibility') != null){
    //   interfaceVisibility = prefs.getBool('interfaceVisibility');
    // }
    pass = prefs.getString('pass');
  }

  initLocalNotify()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   setState(() {
      isNotify = prefs.getBool('isLocalNotify')!;
   });
  }

  @override
  void dispose() {
    animationControllerScaleButtons.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.MyImpoPg_Back_NavBar_Clk);
    Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child:  FeatureDiscovery(
                recordStepsInSharedPreferences: true,
                child: ProfileScreen()
            )
        )
    );
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return  WillPopScope(
      onWillPop: _onWillPop,
      child:  Directionality(
        textDirection: TextDirection.rtl,
        child:  Scaffold(
          backgroundColor: Colors.white,
          body:  Stack(
            children: <Widget>[
               Column(
                children: <Widget>[
                   CustomAppBar(
                    messages: false,
                    profileTab: true,
                    icon: 'assets/images/ic_arrow_back.svg',
                    titleProfileTab: 'صفحه قبل',
                    subTitleProfileTab: 'من و ایمپو',
                     isEmptyLeftIcon: true,
                    onPressBack: (){
                      AnalyticsHelper().log(AnalyticsEvents.MyImpoPg_Back_Btn_Clk);
                      _onWillPop();
                    },
                  ),
                   Padding(
                    padding:  EdgeInsets.only(
                        top: ScreenUtil().setWidth(30)
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(320),
                            ),
                            child: SvgPicture.asset(
                              'assets/images/ic_big_myimpo.svg',
                              width: ScreenUtil().setWidth(180),
                              height: ScreenUtil().setWidth(180),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: ScreenUtil().setWidth(20),
                            ),
                            child: Text(
                              'من و ایمپو',
                              style:  context.textTheme.headlineMedium!.copyWith(
                                color: ColorPallet().gray,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                   Expanded(
                     child: ListView.builder(
                       padding: EdgeInsets.only(
                           top: ScreenUtil().setWidth(50),
                           bottom: ScreenUtil().setWidth(40),
                       ),
                       itemCount: itemsMyImpo.length,
                       // physics: NeverScrollableScrollPhysics(),
                       // shrinkWrap: true,
                       itemBuilder: (context,index){
                         // if(index == 2){
                         //   if(interfaceVisibility){
                         //     return boxItems(itemsMyImpo[index].title, itemsMyImpo[index].icon,index);
                         //   }else{
                         //     return  Container();
                         //   }
                         // } else
                           if(index == itemsMyImpo.length -1){
                           return Column(
                             children: [
                               boxItems(itemsMyImpo[index].title, itemsMyImpo[index].icon,index),
                               StreamBuilder(
                                 stream: _animations.squareScaleBackButtonObserve,
                                 builder: (context,AsyncSnapshot<double>snapshotScale){
                                   if(snapshotScale.data != null){
                                     return Transform.scale(
                                       scale: modePress == 1 ? snapshotScale.data : 1.0,
                                       child: GestureDetector(
                                         onTap: ()async{
                                           AnalyticsHelper().log(AnalyticsEvents.MyImpoPg_Logout_Btn_Clk);
                                           if(this.mounted){
                                             setState(() {
                                               modePress = 1;
                                             });
                                           }
                                           await animationControllerScaleButtons.reverse();
                                           exitDialog.onPressShowDialog();},
                                         child: Container(
                                           width: MediaQuery.of(context).size.width/1.8,
                                           margin: EdgeInsets.only(
                                               top: ScreenUtil().setWidth(50)
                                           ),
                                           padding: EdgeInsets.symmetric(
                                             vertical: ScreenUtil().setHeight(20),
                                           ),
                                           decoration: BoxDecoration(
                                               color: Colors.white,
                                               borderRadius: BorderRadius.circular(15),
                                               boxShadow: [
                                                 BoxShadow(
                                                     color: Color(0xff989898).withOpacity(0.2),
                                                     blurRadius: 5.0
                                                 )
                                               ]
                                           ),
                                           child: Row(
                                             mainAxisAlignment: MainAxisAlignment.center,
                                             children: [
                                               SvgPicture.asset(
                                                 'assets/images/ic_logout.svg',
                                                 width: ScreenUtil().setWidth(45),
                                                 height: ScreenUtil().setWidth(45),
                                               ),
                                               SizedBox(width: ScreenUtil().setWidth(20)),
                                               Text(
                                                 'خروج از حساب کاربری',
                                                 style: context.textTheme.labelLarge!.copyWith(
                                                   color: ColorPallet().gray.withOpacity(0.7),
                                                 ),
                                               )
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
                             ],
                           );
                         } else{
                           if(index == 4 || index== 5){
                             return widget.presenter!.getRegister().status == 1 ?
                              boxItems(itemsMyImpo[index].title, itemsMyImpo[index].icon,index) :
                             SizedBox.shrink();
                           }else{
                             return boxItems(itemsMyImpo[index].title, itemsMyImpo[index].icon,index);
                           }
                         }
                       },
                     ),
                   )
                ],
              ),
               StreamBuilder(
                stream: widget.presenter!.isShowNotifyDialogObserve,
                builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog){
                  if(snapshotIsShowDialog.data != null){
                    if(snapshotIsShowDialog.data!){
                      return  QusDialog(
                        scaleAnim: widget.presenter!.dialogScaleObserve,
                        onPressCancel: (){
                          AnalyticsHelper().log(AnalyticsEvents.MyImpoPg_OffNotifyNoDlg_Btn_Clk);
                          widget.presenter!.onPressCancelNotifyDialog();
                        },
                        value: "ایمپویی عزیز\nآیا از غیر فعال کردن اعلان هات\nاطمینان داری",
                        yesText: 'بله مطمئنم',
                        noText: 'نه',
                        onPressYes: ()async{
                          AnalyticsHelper().log(AnalyticsEvents.MyImpoPg_OffNotifyYesDlg_Btn_Clk);
                           await widget.presenter!.onPressYesLocalNotifyDialog();
                          changeStateNotify(false);
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
              ),
               StreamBuilder(
                stream: exitDialog.isShowExitDialogObserve,
                builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog) {
                  if (snapshotIsShowDialog.data != null) {
                    if (snapshotIsShowDialog.data!) {
                      return  QusDialog(
                        scaleAnim: exitDialog.dialogScaleObserve,
                        onPressCancel: (){
                          AnalyticsHelper().log(AnalyticsEvents.MyImpoPg_LogoutNoDlg_Btn_Clk);
                          exitDialog.cancelDialog();
                        },
                        value: 'آیا مطمئنی می‌خوای از حساب کاربریت خارج بشی؟',
                        yesText: 'بله مطمئنم',
                        noText: 'نه!',
                        onPressYes: () {
                          AnalyticsHelper().log(AnalyticsEvents.MyImpoPg_LogoutYesDlg_Btn_Clk);
                          exitDialog.acceptDialog(context: context, isDialog: true);
                        },
                        isIcon: true,
                        colors: [
                          Colors.white,
                          Colors.white
                        ],
                        topIcon: 'assets/images/ic_box_question.svg',
                        isLoadingButton: false,
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
        ),
      )
    );
  }

  Widget boxItems(title , icon,index){

    return  StreamBuilder(
      stream: _animations.squareScaleBackButtonObserve,
      builder: (context,AsyncSnapshot<double>snapshotScale){
        if(snapshotScale.data != null){
          return  Transform.scale(
              scale: itemsMyImpo[index].selected! && modePress == 0  ? snapshotScale.data : 1.0,
              child:  GestureDetector(
                onTap: ()async{
                  switch(index){
                    case 0: AnalyticsHelper().log(AnalyticsEvents.MyImpoPg_Account_Btn_Clk);
                    break;
                    case 1:  AnalyticsHelper().log(AnalyticsEvents.MyImpoPg_Pass_Btn_Clk);
                    break;
                    case 2:AnalyticsHelper().log(AnalyticsEvents.MyImpoPg_CalendarTp_Btn_Clk);
                    break;
                    case 4:AnalyticsHelper().log(AnalyticsEvents.MyImpoPg_PeriodLength_Btn_Clk);
                    break;
                    case 5:AnalyticsHelper().log(AnalyticsEvents.MyImpoPg_CycleLength_Btn_Clk);
                    break;
                    case 6:AnalyticsHelper().log(AnalyticsEvents.MyImpoPg_Sub_Btn_Clk);
                    break;
                  }
                  if(this.mounted){
                    setState(() {
                      modePress = 0;
                    });
                  }
                  if(index != 3){
                    getPass();
                    animationControllerScaleButtons.reverse();
                    setState(() {

                      for(int i=0 ; i <itemsMyImpo.length; i++){
                        if(itemsMyImpo[i].selected!){
                          itemsMyImpo[i].selected = false;
                        }
                      }

                      itemsMyImpo[index].selected = !itemsMyImpo[index].selected!;
                      Timer(Duration(milliseconds: 100),()async{
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 500),
                                child: index == 0 ?
                                EditProfile(
                                  presenter: widget.presenter,
                                )
                                    : index == 1 ?
                                pass == null ?
                                PasswordScreen(

                                ) :
                                EnterPassScreen(
                                  splash: false,
                                  offlineModel: false,
                                ) : index == 2 ?
                                  ChangeCalendarTypeScreen(
                                    presenter: widget.presenter,
                                  ) : index == 4 ?
                                ChangeCirclesValue(
                                  modeChange: 0,
                                ) : index == 5 ?
                                ChangeCirclesValue(
                                  modeChange: 1,
                                ) : ChooseSubscriptionPage(
                                  isSub: widget.presenter!.getProfileAllData().hasSubscritbion!,
                                )
                            )
                        );
                      });

                    });
                  }
                },
                child:  Container(
                    height: ScreenUtil().setHeight(100),
                    padding: EdgeInsets.only(
                        left: index == 3 ? ScreenUtil().setWidth(0) : ScreenUtil().setWidth(30),
                        right: ScreenUtil().setWidth(30),
                        top: ScreenUtil().setWidth(15),
                        bottom: ScreenUtil().setWidth(15)
                    ),
                    margin: EdgeInsets.only(
                        bottom: ScreenUtil().setWidth(30),
                        right: ScreenUtil().setWidth(60),
                        left: ScreenUtil().setWidth(60)
                    ),
                    decoration:  BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: ColorPallet().gray.withOpacity(.25),
                            width: 1
                        ),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child:  Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              index != 6 ?
                              title :
                              widget.presenter!.getProfileAllData().subButtonText,
                              style: context.textTheme.bodySmall,
                            ),
                            index != 3 ?
                            SvgPicture.asset(
                              icon,
                              width: ScreenUtil().setWidth(50),
                              height: ScreenUtil().setWidth(50),
                              // color: index == 2 ? ColorPallet().gray.withOpacity(0.28) : null
                            )
                                :  Container()
                          ],
                        ),
                        index == 3 ?
                        Opacity(
                            opacity: opacity,
                            child:  Transform.scale(
                                scale: ScreenUtil().setWidth(1.25),
                                child:  CupertinoSwitch(
                                  value: isNotify,
                                  trackColor: ColorPallet().gray.withOpacity(0.5),
                                  activeColor: ColorPallet().mainColor,
                                  onChanged: (bool value)async{
                                    if(!value){
                                      AnalyticsHelper().log(AnalyticsEvents.MyImpoPg_TurnOffNotify_Switch_Clk);
                                      widget.presenter!.showLocalNotifyDialog();
                                    }else{
                                      AnalyticsHelper().log(AnalyticsEvents.MyImpoPg_TurnOnNotify_Switch_Clk);
                                      changeStateNotify(value);
                                    }
                                  },
                                )
                            )
                        )
                            :  Container()
                      ],
                    )
                ),
              )
          );
        }else{
          return  Container();
        }
      },
    );

  }

  changeStateNotify(bool value)async{
    setState(() {
      opacity = 0.5;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLocalNotify', value);
        await GenerateDashboardAndNotifyMessages().checkForNotificationMessage();
          setState(() {
            isNotify = value;
            opacity = 1.0;
          });

  }


}