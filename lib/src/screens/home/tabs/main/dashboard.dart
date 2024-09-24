import 'dart:async';
import 'dart:convert';
import 'package:impo/main.dart';
import 'package:impo/src/models/advertise_model.dart';
import 'package:impo/src/screens/home/tabs/expert/clinic_question_screen.dart';
import 'package:social/chat_application.dart';
import 'package:social/features/messenger/controller/messenger_controller.dart';
import 'package:social/social_application.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/widgets/snackbar/custom_snack_bar.dart';
import 'package:impo/src/screens/home/tabs/main/widget/reporting_widget.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:intl/intl.dart' as intl;
import 'package:angles/angles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_sequence_animator/image_sequence_animator.dart';
import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';
import 'package:impo/src/architecture/presenter/dashboard_presenter.dart';
import 'package:impo/src/architecture/view/dashboard_view.dart';
import 'package:impo/src/components/DateTime/my_datetime.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/box_messages.dart';
import 'package:impo/src/components/canvas/circle_item.dart';
import 'package:impo/src/components/canvas/pregnancy_paint.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/dialogs/ok_dialog.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:impo/src/components/number_to_text_withM.dart';
import 'package:impo/src/components/tab_target.dart';
import 'package:impo/src/components/unicorn_outline_button.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/models/breastfeeding/breastfeeding_number_model.dart';
import 'package:impo/src/models/dashboard/pregnancy_numbers_model.dart';
import 'package:impo/src/models/dashboard/dashboard_messages_and_notify_model.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/dashboard/help_dashboard_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/home/tabs/main/sharing_experience/sharing_experience_screen.dart';
import 'package:impo/src/screens/home/tabs/main/widget/list_story_widget.dart';
import 'package:impo/src/screens/home/tabs/main/widget/my_bioRythm_widget.dart';
import 'package:impo/src/singleton/payload.dart';
import 'package:impo/src/screens/home/home.dart';
import 'package:impo/src/screens/home/tabs/main/signs_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:impo/src/architecture/presenter/calender_presenter.dart';
import 'package:social/core/app/constants/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../packages/featureDiscovery/src/widgets/ensure_visible.dart';
import '../../../../architecture/presenter/expert_presenter.dart';
import '../../../../data/locator.dart';
import '../../../../firebase_analytics_helper.dart';

class DashBoard extends StatefulWidget {
  final DashboardPresenter? presenter;
  final featureId;
  final myChangesFeature;
  final reminderFeature;
  final profileFeature;
  final CalenderPresenter? calenderPresenter;
  final ExpertPresenter? expertPresenter;

  DashBoard(
      {Key? key,
      this.presenter,
      this.featureId,
      this.myChangesFeature,
      this.calenderPresenter,
      this.reminderFeature,
      this.profileFeature,
      this.expertPresenter})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => DashBoardState();
}

class DashBoardState extends State<DashBoard> with TickerProviderStateMixin implements DashboardView {
  late AnimationController animationControllerScaleButton;
  late AnimationController animationControllerBoxHelp;
  int modePress = 0;
  late ScrollController scrollController;

  bool isAnim = false;

//  DashBoardState(){
//    widget.presenter! = DashboardPresenter(this);
//  }

//  CircleModel circleModel;

  Map<String, dynamic> circles = {};

  late CycleViewModel circleModelForSings;

  late int periodDay, dayMode, fertStartDays, fertEndDays;
  int currentToday = 0;
  int maxDays = 0;
  int diffDays = 0;
  double padding = 25.0 - 90;
  late double angleOfDay, endOfPeriod, endOfCircle;
  late Jalali now;
  late DateTime lastPeriod;

  late Angle periodStart, periodEnd, fertStart, fertEnd, ovumDay, pmsStart, pmsEnd, current, ovumDayEnd, cursor;

//  double radius;
  double width = 0;
  double height = 0;
  DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  Map<String, dynamic> Circle = {};
  bool showCycle = false;
  Animations _animations = Animations();
  late AnimationController _controller;
  Tween<double> _tween = Tween(begin: 0.9, end: 0.93);
  GlobalKey<EnsureVisibleState> myChangesEnsureVisible = GlobalKey<EnsureVisibleState>();
  GlobalKey<EnsureVisibleState> signsEnsureVisible = GlobalKey<EnsureVisibleState>();

  // List sugMessage = [];
  late bool showExperience;

  @override
  void initState() {
    triggerAnalytics();
    getShowExperience();
    widget.presenter!.getAdvertise();
    checkIsAnim();
    widget.presenter!.initialDialogScale(this);
    animationControllerBoxHelp = _animations.initialBoxHelp(this);
    animationControllerScaleButton = _animations.pressButton(this);
    scrollController = ScrollController();
    scrollController.addListener(handleScrollPress);
    if (Payload.getGlobal().getPayload() != null && Payload.getGlobal().getPayload() != '') {
      widget.presenter!.checkPayloadNotify(Payload.getGlobal().getPayload());
    }
    widget.presenter!.checkIsExitReminderPad();
    checkStatus();
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 6000), vsync: this);
    _controller.repeat(reverse: true);
  }

  getShowExperience() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showExperience = prefs.getBool('showExperience')!;
  }

  triggerAnalytics() {
    RegisterParamViewModel register = widget.presenter!.getRegisters();
    if (register.status == 2) {
      AnalyticsHelper().enableEventsList([AnalyticsEvents.DashPgPregnancy_EndScrollBio_Pg_Scr]);
    } else if (register.status == 3) {
      AnalyticsHelper().enableEventsList([AnalyticsEvents.DashPgBrstfeed_EndScrollBio_Pg_Scr]);
    } else {
      AnalyticsHelper().enableEventsList([AnalyticsEvents.DashPgPeriod_EndScrollBio_Pg_Scr]);
    }
  }

  handleScrollPress() {
    if (scrollController.position.pixels >= (scrollController.position.maxScrollExtent / 2.5)) {
      RegisterParamViewModel register = widget.presenter!.getRegisters();
      if (register.status == 2) {
        AnalyticsHelper().log(AnalyticsEvents.DashPgPregnancy_EndScrollBio_Pg_Scr, remainEventActive: false);
      } else if (register.status == 3) {
        AnalyticsHelper().log(AnalyticsEvents.DashPgBrstfeed_EndScrollBio_Pg_Scr, remainEventActive: false);
      } else {
        AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_EndScrollBio_Pg_Scr, remainEventActive: false);
      }
    }
  }

  checkStatus() {
    RegisterParamViewModel register = widget.presenter!.getRegisters();
    widget.presenter!.setStatus(register.status!);
    if (register.status == 2) {
      AnalyticsHelper().log(AnalyticsEvents.DashPgPregnancy_Self_Pg_Load);
      widget.presenter!.generateWeekPregnancy();
    } else if (register.status == 3) {
      AnalyticsHelper().log(AnalyticsEvents.DashPgBrstfeed_Self_Pg_Load);
      widget.presenter!.generateWeekBreastfeeding();
    } else {
      AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_Self_Pg_Load);
      checkTheTodayAndEndCircle();
    }
    if (!widget.presenter!.isLoadingDashBoard.isClosed) {
      widget.presenter!.isLoadingDashBoard.sink.add(false);
    }
  }

  RegisterParamViewModel getRegister() {
    return widget.presenter!.getRegisters();
  }

  checkIsAnim() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isAnim')!) {
      if (this.mounted) {
        setState(() {
          isAnim = true;
        });
      }
      prefs.setBool('isAnim', false);
    } else {
      if (this.mounted) {
        setState(() {
          isAnim = false;
        });
      }
    }
    if (isAnim) {
      Timer(Duration(milliseconds: 1500), () {
        setState(() {
          showCycle = true;
        });
      });
    } else {
      setState(() {
        showCycle = true;
      });
    }
  }

  clickOnBanner(String id) async {
    var register = locator<RegisterParamModel>();
    Map<String, dynamic> responseBody = await Http().sendRequest(womanUrl, 'report/msgmotival/$id', 'POST', {}, register.register.token!);
    print(responseBody);
  }

  Future<bool> _launchURL(String url,String? id) async {
    if(id != null){
      if(id != ''){
        clickOnBanner(id);
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

  onPressHelp() async {
    scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.ease);
    AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_Help_Btn_Clk);
    Timer(Duration(milliseconds: 100), () async {
      if (animationControllerBoxHelp.isCompleted) {
        await animationControllerBoxHelp.reverse();
      } else {
        await animationControllerBoxHelp.forward();
      }
    });
  }

  @override
  void dispose() {
    animationControllerScaleButton.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = .5;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                GestureDetector(
                  onPanDown: (s) {
                    if (animationControllerBoxHelp.isCompleted) {
                      Timer(Duration(milliseconds: 170), () {
                        onPressHelp();
                      });
                    }
                  },
                  child: StreamBuilder(
                    stream: widget.presenter!.sugBottomMessagesObserve,
                    builder: (context, AsyncSnapshot<List<DashBoardMessageAndNotifyViewModel>> snapshotSugMesasge) {
                      if (snapshotSugMesasge.data != null) {
                        return ListView(controller: scrollController, padding: EdgeInsets.zero, children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(15)),
                              child: CustomAppBar(
                                messages: false,
                                profileTab: false,
                                // titleMessage: snapshotSugMesasge.data.isNotEmpty ?  snapshotSugMesasge.data.length == 3 ? snapshotSugMesasge.data[2].text : snapshotSugMesasge.data.length == 2 ? snapshotSugMesasge.data[1].text : snapshotSugMesasge.data.length == 1 ? snapshotSugMesasge.data[0].text : '' : '',
                                onPressBack: () {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          settings: RouteSettings(name: "/Page1"),
                                          type: PageTransitionType.topToBottom,
                                          child: FeatureDiscovery(
                                              recordStepsInSharedPreferences: true,
                                              child: Home(
                                                indexTab: 0,
                                                register: true,
                                                isChangeStatus: false,
                                              ))));
                                },
                                icon: 'assets/images/ic_event_calendar.svg',
                                anim: isAnim ? true : null,
                                isReminder: true,
                                // idMotivalMessage: snapshotSugMesasge.data.isNotEmpty ?  snapshotSugMesasge.data.length == 3 ? snapshotSugMesasge.data[2].strId : snapshotSugMesasge.data.length == 2 ? snapshotSugMesasge.data[1].strId : snapshotSugMesasge.data.length == 1 ? snapshotSugMesasge.data[0].strId : '' : '',
                                // link: snapshotSugMesasge.data.isNotEmpty ?  snapshotSugMesasge.data.length == 3 ? snapshotSugMesasge.data[2].link : snapshotSugMesasge.data.length == 2 ? snapshotSugMesasge.data[1].link : snapshotSugMesasge.data.length == 1 ? snapshotSugMesasge.data[0].link : '' : '',
                                calenderPresenter: widget.calenderPresenter,
                                idReminderTabTarget: widget.reminderFeature,
                                idProfileTabTarget: widget.profileFeature,
                                // isSendMessage: true,
                                // isMemory: true,
                              )),
                          // snapshotSugMesasge.data.length != 0 ?
                          StreamBuilder(
                            stream: widget.presenter!.isLoadingDashBoardObserve,
                            builder: (context, AsyncSnapshot<bool> snapshotIsLoading) {
                              if (snapshotIsLoading.data != null) {
                                if (!snapshotIsLoading.data!) {
                                  return Column(
                                    children: [
                                      StreamBuilder(
                                        stream: widget.presenter!.advertis,
                                        builder: (context,AsyncSnapshot<AdvertiseViewModel>snapshotAdv){
                                          if(snapshotAdv.data != null){
                                            return   AnimatedCrossFade(
                                                firstChild: Container(),
                                                secondChild: Container(
                                                    padding: EdgeInsets.only(
                                                      right: ScreenUtil().setWidth(50),
                                                      left: ScreenUtil().setWidth(50),
                                                      bottom: ScreenUtil().setWidth(40),
                                                      top: ScreenUtil().setWidth(10),
                                                    ),
                                                    color: Colors.transparent,
                                                    width: width,
                                                    child: Stack(
                                                      alignment: Alignment.center,
                                                      children: [
                                                        Container(
                                                          height: ScreenUtil().setWidth(160),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(10),
                                                            child: FadeInImage.assetNetwork(
                                                              fit: BoxFit.cover,
                                                              placeholder: 'assets/images/place_holder_adv.png' ,
                                                              image: snapshotAdv.data!.image,
                                                            ),
                                                            // Image.network(
                                                            //   '$mediaUrl/file/${snapshotAdv.data.image}',
                                                            // ),
                                                          ),
                                                        ),
                                                        Material(
                                                          color: Colors.transparent,
                                                          child: InkWell(
                                                              borderRadius: BorderRadius.circular(10),
                                                              onTap: (){
                                                                if(snapshotAdv.data!.typeLink == 1 || snapshotAdv.data!.typeLink == 2){
                                                                  RegisterParamViewModel register = widget.presenter!.getRegisters();
                                                                  if(register.status == 2){
                                                                    AnalyticsHelper().log(AnalyticsEvents.DashPgPregnancy_AdvBanner_Banner_Clk);
                                                                  }else if(register.status == 3){
                                                                    AnalyticsHelper().log(AnalyticsEvents.DashPgBrstfeed_AdvBanner_Banner_Clk);
                                                                  }else{
                                                                    AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_AdvBanner_Banner_Clk);
                                                                  }
                                                                  if(snapshotAdv.data!.typeLink == 1){
                                                                    Navigator.push(
                                                                        context,
                                                                        PageTransition(
                                                                            type: PageTransitionType.fade,
                                                                            child:  ClinicQuestionScreen(
                                                                              expertPresenter: widget.expertPresenter,
                                                                              bodyTicketInfo: json.decode(snapshotAdv.data!.link),
                                                                              // ticketId: ticketsModel.ticketId,
                                                                            )
                                                                        )
                                                                    );
                                                                  }
                                                                  if(snapshotAdv.data!.typeLink == 2){
                                                                    if(snapshotAdv.data!.link != ''){
                                                                      Timer(Duration(milliseconds: 300),(){
                                                                        _launchURL(snapshotAdv.data!.link,snapshotAdv.data!.id);
                                                                      });
                                                                    }
                                                                  }
                                                                }
                                                              },
                                                              child: Container(
                                                                height: ScreenUtil().setWidth(145),
                                                              )
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              FittedBox(
                                                                child: Text(
                                                                  snapshotAdv.data!.text1,
                                                                  style: context.textTheme.bodySmall,
                                                                ),
                                                              ),
                                                              FittedBox(
                                                                child: Text(
                                                                  '${snapshotAdv.data!.text2}',
                                                                  style: context.textTheme.titleSmall,
                                                                ),
                                                              ),
                                                               FittedBox(
                                                                 child: Text(
                                                                  snapshotAdv.data!.text3,
                                                                  style: context.textTheme.bodySmall,
                                                                     ),
                                                               ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  // Ink.image(
                                                  //   image: NetworkImage(
                                                  //     '$mediaUrl/file/${snapshotAdv.data.image}',
                                                  //   ),
                                                  //   fit: BoxFit.cover,
                                                  //   child: InkWell(
                                                  //     onTap: (){
                                                  //       print('dsds');
                                                  //     },
                                                  //   ),
                                                  // )
                                                ),
                                                crossFadeState: !showCycle ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                                duration: Duration(milliseconds: 400)
                                            );
                                          }else{
                                            return Container();
                                          }
                                        },
                                      ),
                                      AnimatedCrossFade(
                                          firstChild: Container(),
                                          secondChild: Container(
                                              padding: EdgeInsets.only(top: ScreenUtil().setWidth(15), bottom: ScreenUtil().setWidth(65)),
                                              color: Colors.white,
                                              width: width,
                                              child: StreamBuilder(
                                                stream: widget.presenter!.statusObserve,
                                                builder: (context, snapshotStatus) {
                                                  if (snapshotStatus.data != null) {
                                                    if (snapshotStatus.data == 2) {
                                                      return pregnancyCycle();
                                                    } else if (snapshotStatus.data == 3) {
                                                      return breastfeedingCycle();
                                                    } else {
                                                      return menstruationCycle();
                                                    }
                                                  } else {
                                                    return Container();
                                                  }
                                                },
                                              )),
                                          crossFadeState: !showCycle ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                          duration: Duration(milliseconds: 900)),
                                      Padding(
                                        padding: EdgeInsets.only(top: 0),
                                        child: bottomScreen(snapshotSugMesasge.data!),
                                      )
                                    ],
                                  );
                                } else {
                                  return Padding(
                                      padding: EdgeInsets.only(top: height / 2 - ScreenUtil().setWidth(80)),
                                      child: LoadingViewScreen(
                                        color: ColorPallet().mainColor,
                                      ));
                                }
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ]);
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                Payload.getGlobal().getPayload() != null && Payload.getGlobal().getPayload() != ''
                    ? StreamBuilder(
                        stream: widget.presenter!.isShowNotifyDialogObserve,
                        builder: (context, AsyncSnapshot<bool> snapshotNotifyDialog) {
                          if (snapshotNotifyDialog.data != null) {
                            if (snapshotNotifyDialog.data!) {
                              return OkDialog(
                                  scaleAnim: widget.presenter!.dialogScaleObserve,
                                  okText: '${Payload.getGlobal().getPayload().toString().split('*')[2]}',
                                  value:
                                      '${Payload.getGlobal().getPayload().toString().split('*')[0]}\n${Payload.getGlobal().getPayload().toString().split('*')[1]}',
                                  onPressOk: () {
                                    widget.presenter!.onPressCancelNotifyDialog();
                                  },
                                  onPressClose: () {
                                    widget.presenter!.onPressCancelNotifyDialog();
                                  },
                                  colors: [Colors.white, Colors.white],
                                  topIcon: 'assets/images/ic_box_question.svg',
                                  isExpert: false,
                                  isLoadingButton: false);
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        },
                      )
                    : Container(),
                // FlatButton(
                //     child: const Text('Record Error'),
                //     onPressed: ()async{
                //       List<DashBoardAndNotifyMessagesParentLocalModel> parentMessages = await widget.presenter!.getParentDashBoardMessages();
                //       List<DashBoardAndNotifyMessagesLocalModel> messages = await widget.presenter!.getDashBoardMessages();
                //       for(int i=0 ; i<parentMessages.length ; i++){
                //         print(parentMessages[i].id);
                //       }
                //       for(int i=0 ; i<messages.length ; i++ ){
                //         print(messages[i].parentId);
                //         print(messages[i].text);
                //       }
                //     }),
//             StreamBuilder(
//              stream: widget.presenter!.isShowDialogObserve,
//              builder: (context,snapshotIsShowDialog){
//                if(snapshotIsShowDialog.data != null){
//                  if(snapshotIsShowDialog.data){
//                    return  QusDialog(
//                      scaleAnim: widget.presenter!.dialogScaleObserve,
//                      onPressCancel: (){
//
//                      },
////                      selectedCircle: _presenter.selectedCircle,
////                      randomMessage: widget.randomMessage,
////                      RegisterParamViewModel: widget.RegisterParamViewModel,
//                    );
//                  }else{
//                    return  Container();
//                  }
//                }else{
//                  return  Container();
//                }
//              },
//            )
              ],
            )),
      ),
    );
  }

  Widget bottomScreen(List<DashBoardMessageAndNotifyViewModel> sugMessage) {
    return Stack(
      children: [
        Padding(
            padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(40)),
            child: Column(
              children: [
                getRegister().status == 1
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            helpCycle(
                                Container(
                                  width: ScreenUtil().setWidth(30),
                                  height: ScreenUtil().setWidth(30),
                                  decoration: BoxDecoration(
                                    color: ColorPallet().mainColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                'دوره پریود',
                                0),
                            helpCycle(
                                Container(
                                  width: ScreenUtil().setWidth(30),
                                  height: ScreenUtil().setWidth(30),
                                  decoration: BoxDecoration(
                                    color: ColorPallet().fertDeep,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                'دوره باروری',
                                1),
                            helpCycle(
                                Container(
                                  padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
                                  width: ScreenUtil().setWidth(30),
                                  height: ScreenUtil().setWidth(30),
                                  decoration: BoxDecoration(
                                    color: ColorPallet().fertDeep,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xff0a7b7f),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                'روز تخمک‌گذاری',
                                2),
                            helpCycle(
                                Container(
                                  width: ScreenUtil().setWidth(30),
                                  height: ScreenUtil().setWidth(30),
                                  decoration: BoxDecoration(
                                    color: ColorPallet().normalDeep,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                'روز عادی',
                                3),
                            helpCycle(
                                Container(
                                  width: ScreenUtil().setWidth(30),
                                  height: ScreenUtil().setWidth(30),
                                  decoration: BoxDecoration(color: ColorPallet().pmsDeep, borderRadius: BorderRadius.circular(20)),
                                ),
                                'PMS',
                                4),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
                getRegister().status == 1 ? SizedBox(height: ScreenUtil().setHeight(30)) : SizedBox.shrink(),
                Padding(
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(15),
                    right: ScreenUtil().setWidth(40),
                    left: ScreenUtil().setWidth(40),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder(
                        stream: _animations.squareScaleBackButtonObserve,
                        builder: (context, AsyncSnapshot<double> snapshotScale) {
                          if (snapshotScale.data != null) {
                            return Align(
                              alignment: Alignment.centerRight,
                              child: Transform.scale(
                                  scale: modePress == 0 ? snapshotScale.data : 1,
                                  child: GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          modePress = 0;
                                        });
                                        await animationControllerScaleButton.reverse();
                                        RegisterParamViewModel register = widget.presenter!.getRegisters();
                                        if (register.status == 2) {
                                          AnalyticsHelper().log(AnalyticsEvents.DashPgPregnancy_Signs_Btn_Clk);
                                        } else if (register.status == 3) {
                                          AnalyticsHelper().log(AnalyticsEvents.DashPgBrstfeed_Signs_Btn_Clk);
                                        } else {
                                          AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_Signs_Btn_Clk);
                                        }
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType.bottomToTop,
                                                child: SignsScreen(shareExp: false
                                                    // dashboardPresenter: widget.presenter!,
                                                    )));
                                      },
                                      child: TabTarget(
                                          id: widget.featureId,
                                          contentLocation: ContentLocation.above,
                                          title: 'نشانه ها',
                                          onOpen: () {
                                            WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
                                              signsEnsureVisible.currentState!.ensureVisible();

                                              /// return true;
                                            });
                                          },
                                          width: 3.5,
                                          height: 2.6,
                                          description: getRegister().status == 3
                                              ? 'تو این قسمت هم یک چک لیست کوتاه از نشانه های پس از زایمان هست که کافیه تکمیلش کنی تا بتونیم اطلاعات جالبتر و مفیدتری بهت بدیم'
                                              : getRegister().status == 2
                                                  ? 'تو این قسمت یک چک لیست از نشانه های دوران بارداری هست که کافیه تکمیلش کنی تا بتونیم اطلاعات جالبتر و مفیدتری بهت بدیم'
                                                  : 'تو این قسمت هم یک چک لیست کوتاه هست که کافیه تکمیلش کنی تا بتونیم اطلاعات جالبتر و مفیدتری بهت بدیم',
                                          icon: Container(
                                            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(17)),
                                            height: ScreenUtil().setWidth(70),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30),
                                                border: Border.all(color: ColorPallet().mainColor)),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.add,
                                                  color: ColorPallet().mainColor,
                                                ),
                                                Text(
                                                  'نشانه‌های من',
                                                  style: context.textTheme.labelMediumProminent!.copyWith(
                                                    color: ColorPallet().mainColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          child: EnsureVisible(
                                              key: signsEnsureVisible,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(17)),
                                                height: ScreenUtil().setWidth(70),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    border: Border.all(color: ColorPallet().mainColor)),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.add,
                                                      color: ColorPallet().mainColor,
                                                    ),
                                                    Text(
                                                      'نشانه‌های من',
                                                      style: context.textTheme.labelMediumProminent!.copyWith(
                                                        color: ColorPallet().mainColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ))))),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      Row(
                        children: [
                          showExperience
                              ? StreamBuilder(
                                  stream: _animations.squareScaleBackButtonObserve,
                                  builder: (context, AsyncSnapshot<double> snapshotScale) {
                                    if (snapshotScale.data != null) {
                                      return Align(
                                        alignment: Alignment.centerLeft,
                                        child: Transform.scale(
                                            scale: modePress == 5 ? snapshotScale.data : 1,
                                            child: GestureDetector(
                                                onTap: () async {
                                                  setState(() {
                                                    modePress = 5;
                                                  });
                                                  await animationControllerScaleButton.reverse();
                                                  RegisterParamViewModel register = widget.presenter!.getRegisters();
                                                  if (register.status == 2) {
                                                    AnalyticsHelper().log(AnalyticsEvents.DashPgPregnancy_ShareExp_Btn_Clk);
                                                  } else if (register.status == 3) {
                                                    AnalyticsHelper().log(AnalyticsEvents.DashPgBrstfeed_ShareExp_Btn_Clk);
                                                  } else {
                                                    AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_ShareExp_Btn_Clk);
                                                  }


                                                  Navigator.push(
                                                    context,
                                                    PageTransition(
                                                      type: PageTransitionType.bottomToTop,
                                                      child: ShareExperienceApp(
                                                        token: register.token!,
                                                        baseUrl: womanUrl,
                                                        baseMediaUrl: mediaUrl,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(17)),
                                                    height: ScreenUtil().setWidth(70),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(30),
                                                        border: Border.all(color: ColorPallet().mainColor)),
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset('assets/images/edit_share.svg'),
                                                        SizedBox(width: ScreenUtil().setWidth(10)),
                                                        Text(
                                                          'اشتراک تجربه',
                                                          style: context.textTheme.labelMediumProminent!.copyWith(
                                                            color: ColorPallet().mainColor,
                                                          ),
                                                        )
                                                      ],
                                                    )))),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                )
                              : SizedBox.shrink()
                        ],
                      )
                    ],
                  ),
                ),
                widget.presenter!.getStories().items.length != 0
                    ? Column(
                        children: [
                          SizedBox(height: ScreenUtil().setWidth(40)),
                          ListStoryWidget(
                            dashboardPresenter: widget.presenter!,
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
                StreamBuilder(
                  stream: widget.presenter!.statusObserve,
                  builder: (context, snapshotStatus) {
                    if (snapshotStatus.data != null) {
                      return Column(
                        children: [
                          sugMessage.isNotEmpty && sugMessage.length > 0
                              ? BoxMessages(
                                  value: sugMessage.isNotEmpty
                                      ? getRegister().status == 3
                                          ? sugMessage[0]
                                              .text!
                                              .replaceAll('%Child%', getRegister().childName != null ? getRegister().childName! : '')
                                          : sugMessage[0].text
                                      : '',
                                  color: snapshotStatus.data == 1
                                      ? dayMode == 0
                                          ? Color(0xffFFE8F7).withOpacity(.5)
                                          : dayMode == 1
                                              ? Color(0xffF2FEFF)
                                              : dayMode == 2
                                                  ? Color(0xffF9F7FF)
                                                  : Color(0xfffbfbff)
                                      : Color(0xffFFE8F7),
                                  borderColor: snapshotStatus.data == 1
                                      ? dayMode == 0
                                          ? ColorPallet().mainColor
                                          : dayMode == 1
                                              ? Color(0xff34E2E6)
                                              : dayMode == 2
                                                  ? Color(0xff8A6BC6)
                                                  : Color(0xff72a8e7)
                                      : ColorPallet().mainColor,
                                  link: sugMessage[0].link,
                                  id: sugMessage[0].id,
                                  typeLink: sugMessage[0].typeLink,
                                  margin: 40,
                                  expertPresenter: widget.expertPresenter,
                                  pressAnalytics: () {
                                    RegisterParamViewModel register = widget.presenter!.getRegisters();
                                    if (register.status == 2) {
                                      AnalyticsHelper().log(AnalyticsEvents.DashPgPregnancy_HintMessage1_Btn_Clk);
                                    } else if (register.status == 3) {
                                      AnalyticsHelper().log(AnalyticsEvents.DashPgBrstfeed_HintMessage1_Btn_Clk);
                                    } else {
                                      AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_HintMessage1_Btn_Clk);
                                    }
                                  },
                                )
                              : Container(),
                          sugMessage.isNotEmpty && sugMessage.length > 1
                              ? BoxMessages(
                                  borderColor: snapshotStatus.data == 1
                                      ? dayMode == 0
                                          ? ColorPallet().mainColor
                                          : dayMode == 1
                                              ? Color(0xff34E2E6)
                                              : dayMode == 2
                                                  ? Color(0xff8A6BC6)
                                                  : Color(0xff72a8e7)
                                      : ColorPallet().mainColor,
                                  color: snapshotStatus.data == 1
                                      ? dayMode == 0
                                          ? Color(0xffFFE8F7).withOpacity(.5)
                                          : dayMode == 1
                                              ? Color(0xffF2FEFF)
                                              : dayMode == 2
                                                  ? Color(0xffF9F7FF)
                                                  : Color(0xfffbfbff)
                                      : Color(0xffFFE8F7),
                                  value: sugMessage.isNotEmpty
                                      ? getRegister().status == 3
                                          ? sugMessage[1]
                                              .text!
                                              .replaceAll('%Child%', getRegister().childName != null ? getRegister().childName! : '')
                                          : sugMessage[1].text
                                      : '',
                                  link: sugMessage[1].link,
                                  id: sugMessage[1].id,
                                  typeLink: sugMessage[1].typeLink,
                                  margin: 40,
                                  expertPresenter: widget.expertPresenter,
                                  pressAnalytics: () {
                                    RegisterParamViewModel register = widget.presenter!.getRegisters();
                                    if (register.status == 2) {
                                      AnalyticsHelper().log(AnalyticsEvents.DashPgPregnancy_HintMessage2_Btn_Clk);
                                    } else if (register.status == 3) {
                                      AnalyticsHelper().log(AnalyticsEvents.DashPgBrstfeed_HintMessage2_Btn_Clk);
                                    } else {
                                      AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_HintMessage2_Btn_Clk);
                                    }
                                  },
                                )
                              : Container(),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                widget.presenter!.getBioRyhthms().visibility
                    ? Padding(
                        padding: EdgeInsets.only(top: ScreenUtil().setWidth(40)),
                        child: Divider(
                          color: Color(0xffEFEFEF),
                          thickness: ScreenUtil().setWidth(8),
                        ),
                      )
                    : SizedBox.shrink(),
                widget.presenter!.getBioRyhthms().visibility
                    ? MyBioRythmWidget(dashboardPresenter: widget.presenter!)
                    : SizedBox(height: ScreenUtil().setWidth(50)),
                widget.presenter!.getRegisters().status == 1 && widget.presenter!.getAllPeriodCircles().length >= 3
                    ? Column(
                        children: [
                          Divider(
                            color: Color(0xffEFEFEF),
                            thickness: ScreenUtil().setWidth(8),
                          ),
                          ReportingWidget(
                            dashboardPresenter: widget.presenter!,
                          ),
                          SizedBox(height: ScreenUtil().setWidth(50)),
                        ],
                      )
                    : SizedBox.shrink()
              ],
            )),
//         Padding(
//           padding:EdgeInsets.only(
//               top: ScreenUtil().setWidth(80),
//               right: ScreenUtil().setWidth(420),
//               left : ScreenUtil().setWidth(40)
//           ),
//           child:  GestureDetector(
//               onTap: (){},
//               child:  StreamBuilder(
//                 stream: _animations.squareScaleBoxHelpObserve,
//                 builder: (context,AsyncSnapshot<double>snapshot){
//                   if(snapshot.data != null){
//                     return   AnimatedBuilder(
//                       animation: animationControllerBoxHelp,
//                       child:   Container(
//                           alignment: Alignment.topLeft,
//                           padding: EdgeInsets.only(
//                               top: ScreenUtil().setWidth(30),
//                               right: ScreenUtil().setWidth(25)
//                           ),
//                           decoration:  BoxDecoration(
//                               color: Colors.white,
//                               border: Border.all(
//                                 color: Color(0xffFFCDEC),
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                     color: Color(0xffFFE2F4).withOpacity(.8),
//                                     blurRadius: 3
//                                 )
//                               ],
//                               borderRadius: BorderRadius.circular(25)
//                           ),
//                           child:  Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: List.generate(helpDashboardBox.length, (index){
//                                 return itemHelp(helpDashboardBox[index].title, helpDashboardBox[index].colors!, index == 1 ? true : false,index);
//                               })
// //                                    <Widget>[
// //                                      itemHelp('دوره ی قاعدگی', [ColorPallet().periodDeep,ColorPallet().periodLight],false),
// //                                      itemHelp('دوره ی باروری', [ColorPallet().fertDeep,ColorPallet().fertLight],true),
// //                                      itemHelp('دوره pms', [ColorPallet().pmsDeep,ColorPallet().pmsLight],false),
// //                                      itemHelp('دیگر روز ها', [ColorPallet().normalDeep,ColorPallet().normalLight],false),
// //                                    ],
//                           )
//                       ),
//                       builder: (BuildContext context, Widget? child) {
//                         return  Transform.scale(
//                           scale: snapshot.data,
//                           alignment: Alignment.topLeft,
//                           child: child,
//                         );
//                       },
//                     );
//                   }else{
//                     return  Container();
//                   }
//                 },
//               )
//           ),
//         ),
      ],
    );
  }

  checkTheTodayAndEndCircle() async {
    /// if(widget.calenderPresenter.getGridItem().isEmpty){
    ///   widget.calenderPresenter.loadCircleItems(widget.RegisterParamViewModel);
    /// }

    List<CycleViewModel> circles = widget.presenter!.getAllCirlse();
    RegisterParamViewModel register = widget.presenter!.getRegisters();

    print(circles.length);

    /// for(int i=0 ; i<circles.length-1 ; i++){
    ///     if(circles[i].periodStart == circles[i+1].periodStart){
    ///       widget.presenter!.removeRecordTable('Circles', circles[i].id);
    ///   }
    ///}

    CycleViewModel lastCircle = circles[circles.length - 1];

    // lastCircle.then((value){
    // print('periodStart : ${lastCircle.periodStart}');
    DateTime lastOfCycleEndCircle = DateTime.parse(lastCircle.circleEnd!);

    // print('checkkkkk');

    if (today.isAfter(lastOfCycleEndCircle)) {
      DateTime startPeriod = DateTime(lastOfCycleEndCircle.year, lastOfCycleEndCircle.month, lastOfCycleEndCircle.day + 1);
      DateTime endCircle = DateTime(lastOfCycleEndCircle.year, lastOfCycleEndCircle.month, lastOfCycleEndCircle.day + register.circleDay!);
      DateTime endPeriod = DateTime(lastOfCycleEndCircle.year, lastOfCycleEndCircle.month, lastOfCycleEndCircle.day + register.periodDay!);

      Circle['isSavedToServer'] = 0;
      Circle['periodStartDate'] = startPeriod.toString();
      Circle['cycleEndDate'] = endCircle.toString();
      Circle['periodEndDate'] = endPeriod.toString();
      Circle['status'] = 0;
      Circle['before'] = lastCircle.before;
      Circle['after'] = lastCircle.after;
      Circle['mental'] = lastCircle.mental;
      Circle['other'] = lastCircle.other;
      Circle['ovu'] = lastCircle.ovu != null ? lastCircle.ovu : '';

      widget.presenter!.insertCircleToLocal(Circle, context);

      checkTheTodayAndEndCircle();
    } else {
      if (this.mounted) {
        setState(() {
          circleModelForSings = lastCircle;
        });
      }
      // print(circleModelForSings.before);
      insertDateToLocal(lastCircle);
    }

    // });
  }

  insertDateToLocal(circleModel) async {
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

    if (this.mounted) {
      setState(() {
        maxDays = MyDateTime().myDifferenceDays(startCircle, endCircle) + 1;

        periodDay = MyDateTime().myDifferenceDays(startCircle, endPeriod) + 1;

        angleOfDay = (310 / (maxDays - 1));

        endOfPeriod = periodDay - 1.0;

        endOfCircle = maxDays - 1.0;
      });
    }

    if (this.mounted) {
      generateDays(circleModel);
    }
  }

  generateDays(circleModel) async {
    periodStart = Angle.degrees(padding);

    periodEnd = Angle.degrees(angleOfDay) * endOfPeriod;

    pmsStart = Angle.degrees(((angleOfDay) * (endOfCircle - 4)) + padding.toDouble());

    pmsEnd = Angle.degrees((angleOfDay) * 4);

    if ((maxDays - 18) <= periodDay) {
      fertStart = Angle.degrees((angleOfDay) * (endOfPeriod + 1) + padding.toDouble());

      fertEnd = Angle.degrees((angleOfDay) * (endOfCircle - 10 - periodDay).toDouble());

//    print('csdc${endOfCircle - 10 - endOfPeriod}');

      fertStartDays = periodDay + 1;

      fertEndDays = maxDays - 10;
    } else {
      fertStart = Angle.degrees((angleOfDay) * (endOfCircle - 18) + padding.toDouble());

      fertEnd = Angle.degrees((angleOfDay) * 8.toDouble());

      fertStartDays = maxDays - 18;

      fertEndDays = maxDays - 10;
    }

    currentToday = MyDateTime().myDifferenceDays(lastPeriod, today) + 1;

    diffDays = MyDateTime().myDifferenceDays(lastPeriod, today);

//    currentToday = 10;

    current = Angle.degrees(((angleOfDay) * (currentToday - 1)) + padding.toDouble());

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

    if (currentToday <= periodDay) {
      dayMode = 0;
      /*  print('period');*/
    } else if (currentToday >= fertStartDays && currentToday <= fertEndDays) {
      dayMode = 1;
//     print('fert');
    } else if (currentToday > maxDays - 5) {
      dayMode = 2;
//     print('pms');
    } else {
      dayMode = 3;
//     print('normal');
    }

    /// widget.presenter!.generateSugMessagesAndNotifications(currentToday, periodDay, maxDays, fertStartDays, fertEndDays, circleModelForSings);
    widget.presenter!.generateBottomMessage(
      currentToday: currentToday,
      periodDay: periodDay,
      maxDays: maxDays,
      fertStartDays: fertStartDays,
      fertEndDays: fertEndDays,
    );
  }

  String generateBigText() {
    switch (dayMode) {
      case 0:
        {
          return 'پریود';
        }

      // break;

      case 1:
        {
          return 'باروری بالا';
        }

      // break;

      case 2:
        {
          return 'دوره pms';
        }

      // break;

      default:
        {
          return 'روز عادی';
        }
    }
  }

  Future<String> generateSmallText() async {
    CycleViewModel lastCycle = widget.presenter!.getAllCirlse()[widget.presenter!.getAllCirlse().length - 1];
    DateTime startPeriod = DateTime.parse(lastCycle.periodStart!);
    DateTime endCycle = DateTime.parse(lastCycle.circleEnd!);

    int maxDay = MyDateTime().myDifferenceDays(startPeriod, endCycle) + 1;

    if (dayMode == 2) {
      int daysStartOfPeriod;

      daysStartOfPeriod = maxDays - diffDays;

      return '$daysStartOfPeriod روز تا پریود بعدی';
    } else {
      return 'روز $currentToday از دوره $maxDay روزه';
    }

    // if(dayMode == 0){
    //
    //   int daysEndOFPeriod;
    //
    //   daysEndOFPeriod = periodDay - diffDays;
    //
    //   return '${NumberToTextWithM().Conver(daysEndOFPeriod)} روز تا پایان پریود';
    //
    // }else if(dayMode == 1){
    //
    //   int daysStartOfPeriod;
    //
    //   daysStartOfPeriod = maxDays - diffDays;
    //
    //   return '$daysStartOfPeriod روز تا پریود بعدی';
    //
    // }else if(dayMode == 2){
    //
    //   int daysStartOfPeriod;
    //
    //   daysStartOfPeriod = maxDays - diffDays;
    //
    //   return '$daysStartOfPeriod روز تا پریود بعدی';
    //
    // }else{
    //
    //   return 'تا آغاز پریود بعدی';
    //
    // }
  }

  String countDay() {
    if (dayMode == 0) {
      return "روز ${NumberToTextWithM().ConvertWithM(currentToday)} پریود";
    } else if (dayMode == 1) {
      if (currentToday == maxDays - 13) {
        return 'روز تخمک ‌گذاری';
      } else {
        return 'دوره باروری';
      }
    } else if (dayMode == 2) {
      return 'PMS';
    } else {
      if (currentToday < (maxDays - 13)) {
        return '${fertStartDays - currentToday} روز تا شروع باروری';
      } else {
        return '${maxDays - currentToday + 1} روز تا شروع پریود';
      }

      // return '${maxDays - diffDays}روز ';
    }

    // return "روز ${NumberToText().ConvertWithM(currentToday)} دوره";
  }

  List<Color> colorsSigns() {
    List<Color> colors = [];

    colors = [
      Color(0xffC33091),
      Color(0xffED89CB),
    ];
    if (widget.presenter!.status.stream.value == 1) {
      if (dayMode == 0) {
        colors = [
          Color(0xffC33091),
          Color(0xffFFA3E0),
        ];
      } else if (dayMode == 1) {
        colors = [
          Color(0xff20DFE4),
          Color(0xffFFA3E0),
        ];
      } else if (dayMode == 2) {
        colors = [
          Color(0xffA684EB),
          Color(0xffC4A9FA),
        ];
      } else {
        colors = [
          Color(0xffEB83D7),
          Color(0xffFFB9F1),
        ];
      }
    } else {
      return colors = [ColorPallet().mainColor, ColorPallet().midwifeLight];
    }
    return colors;
  }

  Color generateTextColor() {
    if (dayMode == 0) {
      return Color(0xffC83C99);
    } else if (dayMode == 1) {
      return Color(0xff48D9DC);
    } else if (dayMode == 2) {
      return Color(0xff8767C6);
    } else {
      return Color(0xff476cd4);
    }
  }

  // Widget itemHelp(title,List<Color>colors,isFert,index){
  //
  //   return
  //    StreamBuilder(
  //     stream: _animations.squareScaleBackButtonObserve,
  //     builder: (context,AsyncSnapshot<double>snapshotScale){
  //       if(snapshotScale.data != null){
  //         return  Transform.scale(
  //           scale: modePress == 4 && helpDashboardBox[index].selected ? snapshotScale.data : 1.0,
  //           child:  GestureDetector(
  //             onTap: (){
  //               animationControllerScaleButton.reverse();
  //               setState(() {
  //                 modePress =4;
  //               });
  //               for(int i=0 ; i<helpDashboardBox.length ; i++){
  //                 helpDashboardBox[i].selected = false;
  //                 helpDashboards[i].selected = false;
  //               }
  //               setState(() {
  //                 helpDashboardBox[index].selected = !helpDashboardBox[index].selected;
  //                 helpDashboards[index].selected = !helpDashboards[index].selected;
  //               });
  //                 widget.presenter!.showHelpDialog();
  //             },
  //             child: isFert ?  Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: [
  //                  Padding(
  //                     padding: EdgeInsets.only(
  //                         bottom: ScreenUtil().setWidth(2)
  //                     ),
  //                     child:  Row(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       children: <Widget>[
  //                         smallCircleHelp(
  //                             colors,
  //                             32
  //                         ),
  //                          SizedBox(width: ScreenUtil().setWidth(30)),
  //                          Text(
  //                           title,
  //                           style:  TextStyle(
  //                               color: Color(0xff6E6E6E),
  //                               fontSize: ScreenUtil().setSp(28)
  //                           ),
  //                         ),
  //                       ],
  //                     )
  //                 ),
  //                  Padding(
  //                     padding: EdgeInsets.only(
  //                         bottom: ScreenUtil().setWidth(15),
  //                         right: ScreenUtil().setWidth(7)
  //                     ),
  //                     child:  Row(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       children: <Widget>[
  //                          Container(
  //                           height: ScreenUtil().setWidth(15),
  //                           width: ScreenUtil().setWidth(15),
  //                           decoration:  BoxDecoration(
  //                               shape: BoxShape.circle,
  //                               color: Colors.white,
  //                               border: Border.all(color: ColorPallet().fertDeep,width: .5),
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   color: ColorPallet().fertDeep.withOpacity(.8),
  //                                   blurRadius: 2
  //                                 )
  //                               ]
  //                           ),
  //                         ),
  //                          SizedBox(width: ScreenUtil().setWidth(30)),
  //                          Text(
  //                           'روز تخمک گذاری',
  //                           style:  TextStyle(
  //                               color: Color(0xff6E6E6E),
  //                               fontSize: ScreenUtil().setSp(22)
  //                           ),
  //                         ),
  //                       ],
  //                     )
  //                 )
  //               ],
  //             ) :
  //              Padding(
  //                 padding: EdgeInsets.only(
  //                     bottom: ScreenUtil().setWidth(15)
  //                 ),
  //                 child:  Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   children: <Widget>[
  //                     smallCircleHelp(
  //                         colors,
  //                         32,
  //                       index: index
  //
  //                     ),
  //                      SizedBox(width: ScreenUtil().setWidth(30)),
  //                      Text(
  //                       title,
  //                       style:  TextStyle(
  //                           color: Color(0xff6E6E6E),
  //                           fontSize: ScreenUtil().setSp(28)
  //                       ),
  //                     ),
  //                   ],
  //                 )
  //             )
  //           ),
  //         );
  //       }else{
  //         return  Container();
  //       }
  //     },
  //   );
  //
  // }

  Future<Widget> checkBtnPeriod() async {
    List<CycleViewModel> periodCycles = [];
    List<CycleViewModel> reverseCycles = widget.presenter!.getAllCirlse().reversed.toList();
    for (int i = 0; i < reverseCycles.length; i++) {
      if (reverseCycles[i].status == 0) {
        periodCycles.add(reverseCycles[i]);
      } else {
        break;
      }
    }
    List<CycleViewModel> listCirclesItem = periodCycles.reversed.toList();
    if (currentToday > 10) {
      return btnPeriod(0, listCirclesItem);
    } else {
      if (currentToday <= 10 && listCirclesItem.length == 1 && currentToday != 1 && currentToday != 2) {
        if (currentToday <= periodDay) {
          return btnPeriod(3, listCirclesItem);
        } else {
          if (currentToday <= maxPeriodDay(maxDays)) {
            return btnPeriod(4, listCirclesItem);
          } else {
            return btnPeriod(6, listCirclesItem);
          }
        }
      } else if (currentToday <= 10 && listCirclesItem.length > 1) {
        // return btnPeriod('هنوز پریود نشدم',1,listCirclesItem);
        if (currentToday == 1 || currentToday == 2) {
          return btnPeriod(1, listCirclesItem);
        } else {
          if (currentToday <= periodDay) {
            return btnPeriod(2, listCirclesItem);
          } else {
            if (currentToday <= maxPeriodDay(maxDays)) {
              return btnPeriod(5, listCirclesItem);
            } else {
              return btnPeriod(1, listCirclesItem);
            }
          }
        }
      } else {
        return btnPeriod(6, listCirclesItem);
      }
    }
    // return  Container();
  }

  int maxPeriodDay(int circleDay) {
    int maxiumuDay = 10;
    if (circleDay < 25) {
      maxiumuDay = maxiumuDay - (25 - circleDay);
    }
    return maxiumuDay;
  }

  Widget btnPeriod(mode, List<CycleViewModel> listCirclesItem) {
    return myStatusBtn(false, onPress: () {
      widget.presenter!.periodMyChangePanel(mode, listCirclesItem, dayMode);
    });
  }

  Widget myStatusBtn(bool isBreastfeeding, {onPress}) {
    return TabTarget(
        id: widget.myChangesFeature,
        contentLocation: ContentLocation.above,
        title: getRegister().status == 1 ? 'ویرایش چرخه' : 'تغییرات من',
        width: 3.7,
        height: 2.6,
        onOpen: () {
          WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
            myChangesEnsureVisible.currentState!.ensureVisible();

            /// return true;
          });
        },
        description: getRegister().status == 3
            ? 'از این قسمت می‌تونی شروع پریودت رو ثبت کنی یا هفته‌های پس از زایمان رو تغییر بدی'
            : getRegister().status == 2
                ? 'از این قسمت می‌تونی زایمان یا ختم بارداری رو اعلام کنی یا براساس تاریخ آخرین پریود یا زایمان، هفته‌ی بارداریت رو تصحیح کنی'
                : 'از این قسمت می‌تونی تغییراتی رو که توی تاریخ پریودت به وجود میاد، ثبت کنی',
        icon: isBreastfeeding
            ? Container(
                width: ScreenUtil().setWidth(260),
                padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(12),
                    bottom: ScreenUtil().setWidth(12),
                    right: ScreenUtil().setWidth(20),
                    left: ScreenUtil().setWidth(32)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      colors: [ColorPallet().mentalHigh, ColorPallet().mentalMain],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/border_color.svg',
                      colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(12)),
                    Text(
                      'تغییرات من',
                      style: context.textTheme.labelLarge!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ))
            : Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(30),
                ),
                width: getRegister().status == 2 ? ScreenUtil().setWidth(270) : ScreenUtil().setWidth(292),
                padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(5),
                    bottom: ScreenUtil().setWidth(5),
                    right: ScreenUtil().setWidth(20),
                    left: ScreenUtil().setWidth(32)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      'assets/images/border_color.svg',
                      colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    ),
                    Text(
                      getRegister().status == 1 ? 'ویرایش چرخه' : 'تغییرات من',
                      style: context.textTheme.labelLargeProminent,
                    )
                  ],
                )),
        child: EnsureVisible(
          key: myChangesEnsureVisible,
          child: StreamBuilder(
            stream: _animations.squareScaleBackButtonObserve,
            builder: (context, AsyncSnapshot<double> snapshotScale) {
              if (snapshotScale.data != null) {
                return Transform.scale(
                  scale: modePress == 2 ? snapshotScale.data : 1,
                  child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          modePress = 2;
                        });
                        await animationControllerScaleButton.reverse();

                        RegisterParamViewModel register = widget.presenter!.getRegisters();
                        if (register.status == 2) {
                          AnalyticsHelper().log(AnalyticsEvents.DashPgPregnancy_MyChange_Btn_Clk);
                        } else if (register.status == 3) {
                          AnalyticsHelper().log(AnalyticsEvents.DashPgBrstfeed_MyChange_Btn_Clk);
                        } else {
                          AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_MyChange_Btn_Clk);
                        }

                        widget.presenter!.showMyStatusPanel(context, widget.presenter!, widget.calenderPresenter!);
                        onPress != null ? onPress() : () {};
                      },
                      child: isBreastfeeding
                          ? Container(
                              width: ScreenUtil().setWidth(260),
                              padding: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(12),
                                  bottom: ScreenUtil().setWidth(12),
                                  right: ScreenUtil().setWidth(20),
                                  left: ScreenUtil().setWidth(32)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                    colors: [ColorPallet().mentalHigh, ColorPallet().mentalMain],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/border_color.svg',
                                    colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(12)),
                                  Text(
                                    'تغییرات من',
                                    style: context.textTheme.labelLarge!.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ))
                          : Container(
                              margin: EdgeInsets.only(
                                top: ScreenUtil().setWidth(30),
                              ),
                              width: getRegister().status == 2 ? ScreenUtil().setWidth(270) : ScreenUtil().setWidth(292),
                              padding: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(5),
                                  bottom: ScreenUtil().setWidth(5),
                                  right: ScreenUtil().setWidth(20),
                                  left: ScreenUtil().setWidth(32)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/border_color.svg',
                                    colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                                  ),
                                  Text(
                                    getRegister().status == 1 ? 'ویرایش چرخه' : 'تغییرات من',
                                    style: context.textTheme.labelLargeProminent,
                                  )
                                ],
                              ))),
                );
              } else {
                return Container();
              }
            },
          ),
        ));
  }

  Widget smallCircleHelp(List<Color> colors, size, {int index = 10}) {
    return index == 3
        ? Container(
            height: ScreenUtil().setWidth(size),
            width: ScreenUtil().setWidth(size),
            decoration: BoxDecoration(
                border: Border.all(color: ColorPallet().mainColor, width: .5),
                boxShadow: [BoxShadow(color: ColorPallet().mainColor.withOpacity(.8), blurRadius: 2)],
                shape: BoxShape.circle,
                color: Colors.white
//          gradient:  LinearGradient(
//            colors: colors
//          )
                ))
        : Container(
            height: ScreenUtil().setWidth(size),
            width: ScreenUtil().setWidth(size),
            decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: colors)),
          );
  }

  Widget helpCycle(Widget child, String text, index) {
    return GestureDetector(
        onTap: () {
          for (int i = 0; i < helpDashboardBox.length; i++) {
            helpDashboardBox[i].selected = false;
            helpDashboards[i].selected = false;
          }
          setState(() {
            helpDashboardBox[index].selected = !helpDashboardBox[index].selected;
            helpDashboards[index].selected = !helpDashboards[index].selected;
          });
          widget.presenter!.showHelpDialog();
        },
        child: Row(
          children: [
            child,
            SizedBox(width: ScreenUtil().setWidth(5)),
            Text(text,
                style: context.textTheme.labelSmall!.copyWith(
                  color: Color(0xff1C1B1E),
                  fontWeight: FontWeight.w500,
                ))
          ],
        ));
  }

  Widget menstruationCycle() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(80)),
          width: ScreenUtil().setWidth(400),
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20), vertical: ScreenUtil().setWidth(10)),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xffFFEDF9))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'چرخه فعلی ',
                style: context.textTheme.labelMediumProminent!.copyWith(
                  color: Color(0xff4B454D),
                ),
              ),
              Text(
                '${getStartDateTimeLastCycle()} تا ${getEndDateTimeLastCycle()}',
                style: context.textTheme.bodySmall!.copyWith(
                  color: Color(0xff4B454D),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(30)),
        Stack(
          alignment: Alignment.center,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: ScreenUtil().setWidth(620),
                  child: Image.asset(
                    dayMode == 0
                        ? 'assets/gif/ghaedegiG.gif'
                        : dayMode == 1
                            ? 'assets/gif/barvari-fG.gif'
                            : dayMode == 2
                                ? 'assets/gif/pmsG.gif'
                                : 'assets/gif/rooze-adiG_1.gif',
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(180)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        countDay(),
                        style: context.textTheme.headlineSmall!.copyWith(
                          color: generateTextColor(),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setWidth(8)),
                      FutureBuilder<String>(
                        future: generateSmallText(),
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          return Text(
                            snapshot.data != null ? snapshot.data! : '',
                            style: context.textTheme.bodyLarge!.copyWith(
                              color: generateTextColor(),
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
              painter: maxDays != 0
                  ? CircleItem(
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
                      dayMode: dayMode,
                      fertEndDays: fertEndDays,
                      fertStartDays: fertStartDays)
                  : null,
            ),
            Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setWidth(280)),
                child: FutureBuilder(
                  future: checkBtnPeriod(),
                  builder: (context, AsyncSnapshot<Widget> snapshot) {
                    if (snapshot.data != null) {
                      return snapshot.data!;
                    } else {
                      return Container();
                    }
                  },
                ))
          ],
        )
      ],
    );
  }

  String getStartDateTimeLastCycle() {
    CycleViewModel lastCycle = widget.presenter!.getAllCirlse()[widget.presenter!.getAllCirlse().length - 1];
    DateTime startPeriod = DateTime.parse(lastCycle.periodStart!);
    if (getRegister().calendarType == 1) {
      final intl.DateFormat formatter = intl.DateFormat('dd LLL', 'fa');
      return formatter.format(startPeriod);
    } else {
      return MyDateTime().getShamsiCycle(Jalali.fromDateTime(startPeriod), getRegister());
    }
  }

  String getEndDateTimeLastCycle() {
    CycleViewModel lastCycle = widget.presenter!.getAllCirlse()[widget.presenter!.getAllCirlse().length - 1];
    DateTime endCycle = DateTime.parse(lastCycle.circleEnd!);
    if (getRegister().calendarType == 1) {
      final intl.DateFormat formatter = intl.DateFormat('dd LLL', 'fa');
      return formatter.format(endCycle);
    } else {
      return MyDateTime().getShamsiCycle(Jalali.fromDateTime(endCycle), getRegister());
    }
  }

  Widget pregnancyCycle() {
    return StreamBuilder(
      stream: widget.presenter!.pregnancyNumberObserve,
      builder: (context, AsyncSnapshot<PregnancyNumberViewModel> snapshotPregnancy) {
        if (snapshotPregnancy.data != null) {
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
                        scale: _tween.animate(CurvedAnimation(parent: _controller, curve: Curves.ease)),
                        child: Padding(
                            padding: EdgeInsets.all(ScreenUtil().setWidth(80)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(250),
                              child: Image.asset(
                                snapshotPregnancy.data!.weekNoPregnancy! >= 43
                                    ? 'assets/pregnancyImages/week42.jpg'
                                    : 'assets/pregnancyImages/week${snapshotPregnancy.data!.weekNoPregnancy}.jpg',
                                fit: BoxFit.cover,
                              ),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: ScreenUtil().setWidth(150),
                          top: ScreenUtil().setWidth(100),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            weeklyCounterBoxPregnancy(
                                'ماه ${snapshotPregnancy.data!.monthNoPregnancy! <= 9 ? NumberToTextWithM().ConvertWithM(snapshotPregnancy.data!.monthNoPregnancy!) : 'آخر'}',
                                weekNo: '${snapshotPregnancy.data!.weekNoPregnancy}'),
                            SizedBox(height: ScreenUtil().setWidth(15)),
                            weeklyCounterBoxPregnancy(snapshotPregnancy.data!.dayToDelivery != 0
                                ? '${snapshotPregnancy.data!.dayToDelivery} روز تا زایمان'
                                : 'نزدیک به زایمان')
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(75)),
                      child: Image.asset(
                        'assets/pregnancyImages/subtraction.png',
                        fit: BoxFit.cover,
                      )),
                  Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(110)),
                      child: ImageSequenceAnimator(
                        "assets/pregnancyImages", //folderName
                        "Comp", //fileName
                        0, //suffixStart
                        2, //suffixCount
                        "png", //fileFormat
                        50,
                        isLooping: true,
                        fps: 10,
                      ) //frameCount
                      ),
                  Container(
                    width: ScreenUtil().setWidth(530),
                    height: ScreenUtil().setWidth(530),
                    decoration: BoxDecoration(
                        // color: Colors.black,
                        gradient: RadialGradient(colors: [
                          Colors.white.withOpacity(0.0),
                          Colors.white.withOpacity(0.0),
                          Colors.white.withOpacity(0.0),
                          // Colors.white.withOpacity(0.0),

                          Colors.white.withOpacity(0.9),
                          Colors.white.withOpacity(1.0),
                        ], radius: 0.75),
                        borderRadius: BorderRadius.circular(250)),
                  ),
                  UnicornOutlineButton(
                      strokeWidth: 2.5,
                      radius: 250,
                      onPressed: () {},
                      gradient: LinearGradient(colors: [ColorPallet().mainColor, Color(0xffE878D3)]),
                      child: Container(
                        width: ScreenUtil().setWidth(535),
                        height: ScreenUtil().setWidth(535),
                      )),
                ],
              ),
              CustomPaint(
                painter: PregnancyPaint(
                    width: width,
                    currentWeek: snapshotPregnancy.data!.weekNoPregnancy,
                    maxWeeks: snapshotPregnancy.data!.weekNoPregnancy! <= 40 ? 40 : snapshotPregnancy.data!.weekNoPregnancy,
                    context: context),
              ),
              Padding(padding: EdgeInsets.only(top: ScreenUtil().setWidth(330)), child: myStatusBtn(false))
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget weeklyCounterBoxPregnancy(String text, {String? weekNo}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15), vertical: ScreenUtil().setWidth(3)),
      decoration: BoxDecoration(color: Color(0XFFFFE8F7).withOpacity(0.7), borderRadius: BorderRadius.circular(10)),
      child: weekNo != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$text (‌‌‌‌ هفته', style: context.textTheme.bodyMedium),
                Text(' $weekNo', style: context.textTheme.bodyMedium),
                Text(' )', style: context.textTheme.bodyMedium),
              ],
            )
          : Text(text, style: context.textTheme.bodyMedium),
    );
  }

  Widget breastfeedingCycle() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            StreamBuilder(
              stream: widget.presenter!.breastfeedingNumbersObserve,
              builder: (context, AsyncSnapshot<BreastfeedingNumberModel> snapshotBreastfeedingNumbers) {
                if (snapshotBreastfeedingNumbers.data != null) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'هفته ${NumberToTextWithM().ConvertWithM(snapshotBreastfeedingNumbers.data!.breastfeedingCurrentWeek)} شروع مادری',
                        style: context.textTheme.bodyMedium,
                      ),
                      Text(
                        ' (ماه ${NumberToTextWithM().ConvertWithM(snapshotBreastfeedingNumbers.data!.breastfeedingCurrentMonth)})',
                        style: context.textTheme.bodyMedium,
                      ),
                    ],
                  );
                } else {
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
        ),
        Padding(padding: EdgeInsets.only(top: ScreenUtil().setWidth(500)), child: myStatusBtn(true))
      ],
    );
  }

  @override
  void onError(msg) {}

  @override
  void onSuccess(msg) {}
}
