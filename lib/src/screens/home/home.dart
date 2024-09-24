
import 'dart:async';
import 'dart:convert';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/packages/bottom_navigation/animated_bottom_navigation_bar.dart';
import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/daily_message_presenter.dart';
import 'package:impo/src/architecture/presenter/partner_tab_presenter.dart';
import 'package:impo/src/architecture/presenter/calender_presenter.dart';
import 'package:impo/src/architecture/presenter/dashboard_presenter.dart';
import 'package:impo/src/architecture/presenter/expert_presenter.dart';
import 'package:impo/src/architecture/presenter/profile_presenter.dart';
import 'package:impo/src/architecture/presenter/register_presenter.dart';
import 'package:impo/src/architecture/presenter/sharing_experience_presenter.dart';
import 'package:impo/src/architecture/presenter/support_presenter.dart';
import 'package:impo/src/architecture/view/partner_tab_view.dart';
import 'package:impo/src/architecture/view/calender_view.dart';
import 'package:impo/src/architecture/view/dashboard_view.dart';
import 'package:impo/src/architecture/view/expert_view.dart';
import 'package:impo/src/architecture/view/profile_view.dart';
import 'package:impo/src/architecture/view/register_view.dart';
import 'package:impo/src/architecture/view/sharing_experience_view.dart';
import 'package:impo/src/architecture/view/support_view.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/dialogs/aboration_dialog.dart';
import 'package:impo/src/components/dialogs/bioritm_dialog.dart';
import 'package:impo/src/components/dialogs/breasfeeding_dialog.dart';
import 'package:impo/src/components/dialogs/check_version_dialog.dart';
import 'package:impo/src/components/dialogs/exit_app_dialog.dart';
import 'package:impo/src/components/dialogs/help_dialog.dart';
import 'package:impo/src/components/dialogs/ok_dialog.dart';
import 'package:impo/src/components/dialogs/pregnancyand_breastfeeding_limit_week.dart';
import 'package:impo/src/components/dialogs/qus_dialog.dart';
import 'package:impo/src/components/dialogs/rate_store_dialog.dart';
import 'package:impo/src/components/tab_target.dart';
import 'package:impo/src/components/dialogs/check_reporting_dialog.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/bottom_banner_model.dart';
import 'package:impo/src/models/dashboard/my_change_panel_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/LoginAndRegister/menstruationRegister/periodDay_register_screen.dart';
import 'package:impo/src/screens/home/tabs/calender/note_screen.dart';
import 'package:impo/src/screens/home/tabs/expert/chat_screen.dart';
import 'package:impo/src/screens/home/tabs/main/sharing_experience/comment_share_exp_screen.dart';
import 'package:impo/src/screens/home/tabs/main/sharing_experience/sharing_experience_screen.dart';
import 'package:impo/src/screens/home/tabs/main/signs_screen.dart';
import 'package:impo/src/screens/home/tabs/partnerTab/pages/archive_daily_message_screen.dart';
import 'package:impo/src/screens/home/tabs/partnerTab/pages/daily_message_screen.dart';
import 'package:impo/src/screens/home/tabs/partnerTab/pages/partner_tab_screen.dart';
import 'package:impo/src/screens/home/tabs/calender/calender.dart';
import 'package:impo/src/screens/home/tabs/calender/calender_en.dart';
import 'package:impo/src/screens/home/tabs/calender/memory/memory_game_screen.dart';
import 'package:impo/src/screens/home/tabs/expert/clinic_question_screen.dart';
import 'package:impo/src/screens/home/tabs/expert/main_clinic_screen.dart';
import 'package:impo/src/screens/home/tabs/main/dashboard.dart';
import 'package:impo/src/screens/home/tabs/main/change_status_screen.dart';
import 'package:impo/src/screens/home/tabs/partnerTab/pages/send_message_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/alarms/alarms_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/enter_face_code_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/partner/change_distance_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/partner/partner_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/reporting/reporting_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/supportOnline/pages/chat_support_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/supportOnline/pages/support_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/update_screen.dart';
import 'package:impo/src/screens/home/tabs/social/social_screen.dart';
import 'package:impo/src/screens/subscribe/choose_subscription_page.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:page_transition/page_transition.dart';
import 'package:impo/src/singleton/payload.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:social/chat_application.dart';
import 'package:social/core/app/constants/app_routes.dart';
import 'package:social/social_application.dart';
import 'package:uni_links/uni_links.dart';


import '../../components/dialogs/certical_dialog.dart';
import '../../firebase_analytics_helper.dart';
import '../splash_screen.dart';
import 'tabs/main/sharing_experience/topic_share_exp_screen.dart';

int? currentIndex;
class Home extends StatefulWidget{

  final indexTab;
  final register;
  final showBreastfeedingDialog;
  final isChangeStatus;
  final womansubscribtion;
  final isShowSnackBar; /// forPartnerScreen
  /// final isLogin;
  /// final checkMessageNotRead;

  Home({Key? key,this.indexTab,this.register,this.showBreastfeedingDialog,
    this.isChangeStatus,this.isShowSnackBar,this.womansubscribtion}):super(key:key);

  @override
  State<StatefulWidget> createState() => HomeState();

}

class HomeState extends State<Home> with TickerProviderStateMixin implements DashboardView ,RegisterView, CalenderView , ExpertView , PartnerTabView , ProfileView , SharingExperienceView , SupportView {


  // static const String feature1 = 'feature1',
  //     feature2 = 'feature2',
  //     feature3 = 'feature3',
  //     feature4 = 'feature4',
  //     feature5 = 'feature5',
  //     feature6 = 'feature6',
  //     feature601 = 'feature601',
  //     feature602 = 'feature602';

  static const String feature1 = 'feature1',
      feature6 = 'feature6',
      feature603 = 'feature603',
      feature601 = 'feature601',
      feature602 = 'feature602';

  List<String> feature = [
    'feature2',
    'feature3',
    'feature4',
    'feature5',
  ];

  late DashboardPresenter _presenter;

  late RegisterPresenter _registerPresenter;

  late CalenderPresenter _calenderPresenter;

  late ExpertPresenter _expertPresenter;

  late PartnerTabPresenter _partnerTabPresenter;

  late ProfilePresenter _profilePresenter;

  late SharingExperiencePresenter _sharingExperiencePresenter;

  late SupportPresenter _supportPresenter;

  late DailyMessagePresenter _dailyMessagePresenter;


  Animations _animations =  Animations();
  late AnimationController animationControllerScaleButton;

  List<String> iconSelected = [
    'assets/images/calendar_selected.svg',
    'assets/images/expert_selected.svg',
    'assets/images/partner_selected.svg',
    'assets/images/blog_selected.svg',
  ];
  List<String> iconUnselected = [
    'assets/images/calendar_unselected.svg',
    'assets/images/expert_unselected.svg',
    'assets/images/partner_unselected.svg',
    'assets/images/blog_unselected.svg'
  ];

  List<String> title = ["تقویم", "کلینیک", "همدل", "مقالات"];


  List<String> periodDescription = [
    'دوست خوبم این صفحه تقویمته که می‌تونی به اطلاعات دوره های قبل و بعدت هم دسترسی داشته باشی',
    'اینجا می‌تونی سوالاتت رو از مشاوران ایمپو بپرسی',
    'از اینجا می‌تونی اطلاعات بیوریتم همدلت رو ببینی و همدلانه کنارش باشی',
    'اینجا جایی هست که می‌تونی به مقاله های سایت ایمپو با موضوعات مختلف و به روز، دسترسی پیدا کنی'
  ];

  List<String> pregnancyDescription = [
    'دوست خوبم این صفحه ی تقویمته که می‌تونی به اطلاعات هفته های بارداریت دسترسی داشته باشی',
    'اینجا می‌تونی سوالاتت رو از مشاوران ایمپو بپرسی',
    'از اینجا می‌تونی اطلاعات بیوریتم همدلت رو ببینی و همدلانه کنارش باشی',
    'اینجا جایی هست که می‌تونی به مقاله های سایت ایمپو با موضوعات مختلف و به روز، دسترسی پیدا کنی'
  ];

  List<String> breastfeedingDescription = [
    'دوست خوبم این صفحه ی تقویمته که می‌تونی به اطلاعات هفته های پس از زایمان دسترسی داشته باشی',
    'اینجا می‌تونی سوالاتت رو از مشاوران ایمپو بپرسی',
    'از اینجا می‌تونی اطلاعات بیوریتم همدلت رو ببینی و همدلانه کنارش باشی',
    'اینجا جایی هست که می‌تونی به مقاله های سایت ایمپو با موضوعات مختلف و به روز، دسترسی پیدا کنی'
  ];

  HomeState() {
    _presenter = DashboardPresenter(this);
    _registerPresenter = RegisterPresenter(this);
    _calenderPresenter = CalenderPresenter(this);
    _expertPresenter = ExpertPresenter(this);
    _partnerTabPresenter = PartnerTabPresenter(this);
    _profilePresenter = ProfilePresenter(this);
    _sharingExperiencePresenter = SharingExperiencePresenter(this);
    _supportPresenter = SupportPresenter(this);
    _dailyMessagePresenter = DailyMessagePresenter();
  }


  int modePress = 0;

  // TabController _tabController;

  CheckVersionDialog checkVersionDialog =  CheckVersionDialog();
  PregnancyAndBreastfeedingLimitWeek pregnancyAndBreastfeedingLimitWeek = PregnancyAndBreastfeedingLimitWeek();
  BreastfeedingDialog breastfeedingDialog = BreastfeedingDialog();
  // ExitDialog exitDialog =  ExitDialog();
  ExitAppDialog exitAppDialog =  ExitAppDialog();
  CheckReportingDialog checkReportingDialog =  CheckReportingDialog();
  RateStore rateStore = RateStore();
  /// MessageNotReadDialog _messageNotReadDialog =  MessageNotReadDialog();

  // DataBaseProvider db =  DataBaseProvider();


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  double tabSize = ScreenUtil().setWidth(40);

  double tabMarginIcon = ScreenUtil().setWidth(7);

  late PageController controller;


  // List<RegisterParamViewModel> registerModel;

  // Future<Null> initUniLinks() async {
  //   uriLinkStream.listen((Uri uri)async{
  //     Map res = uri.queryParameters;
  //     String type = res['type'] != null ? res['type'] : '';
  //     String drId = res['DrId'] != null ? res['DrId'] : '';
  //
  //     if(type != ''){
  //       print('type');
  //       print(type);
  //       print(drId);
  //       Payload.getGlobal().setPayload('type*$type*$drId*');
  //       runApp(
  //           GetMaterialApp(
  //             title: 'Impo',
  //             debugShowCheckedModeBanner: false,
  //             builder: (context, child) =>
  //                 MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child),
  //             theme: ThemeData(
  //               fontFamily: 'IRANYekan',
  //               primarySwatch: Colors.pink,
  //               visualDensity: VisualDensity.adaptivePlatformDensity,
  //             ),
  //             home: SplashScreen(
  //               localPass: true,
  //               index: 2,
  //             ),
  //           )
  //       );
  //     }
  //
  //   }, onError: (err) {
  //
  //   });
  //
  // }

  var bottomBannerInfo = locator<BottomBannerModel>();

  late BottomBannerViewModel bottomBanner;

  double heightOffBottomBanner = 0.0;

  @override
  void initState() {
    // initUniLinks();
    getRegister();
    checkBottomBanner();
    if(Payload.getGlobal().getPayload() != null && Payload.getGlobal().getPayload() != ''){
      checkPayLoad(Payload.getGlobal().getPayload()!);
    }else{
      initTabController(widget.indexTab);
    }
    animationControllerScaleButton = _animations.pressButton(this);
    _presenter.initPanelController();
    // _tabController.addListener(_handleTabSelection);
    // controller.addListener(_handleTabSelection);
    exitAppDialog.initialDialogScale(this);
    checkVersionDialog.initialDialogScale(this);
    checkReportingDialog.initialDialogScale(this);
    /// rateStore.initialDialogScale(this);
    pregnancyAndBreastfeedingLimitWeek.initialDialogScale(this);
    if(widget.showBreastfeedingDialog != null){
      breastfeedingDialog.initialDialogScale(this);
      breastfeedingDialog.showBreastfeedingDialog();
    }
    if(widget.isShowSnackBar != null){
      WidgetsBinding.instance.addPostFrameCallback((_){
       Timer(Duration(milliseconds: 500),(){
         _partnerTabPresenter.showToast("درخواست شما با موفقیت ارسال شد",_scaffoldKey.currentContext);
       });
        // _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Your message here..")));
      });
    }
    /// _messageNotReadDialog.initialDialogScale(this);
    /// if(widget.checkMessageNotRead != null)   _messageNotReadDialog.login(widget.isLogin, context,_calenderPresenter);
    if (widget.register == null && widget.indexTab == 4 && getRegister().status == 1) {
       checkReportingDialog.checkReporting(_presenter);
    }
    if(widget.register == null && widget.indexTab == 4){
      checkVersionDialog.checkVersion();
      /// rateStore.checkShowComment();
    }
    if(getRegister().status == 2) pregnancyAndBreastfeedingLimitWeek.checkPregnancyWeek();
    if(getRegister().status == 3) pregnancyAndBreastfeedingLimitWeek.checkBreastfeeding();
    Timer(Duration(seconds: 1), () {
      if(widget.isChangeStatus != null){
        if(widget.isChangeStatus){
          FeatureDiscovery.clearPreferences(context,<String>{
            'feature1',
            'feature2',
            'feature6',
            'feature603',
            'feature102',
          });
        }
      }
      if(getRegister().status == 3 && widget.isChangeStatus){

      }else{
        initTabTarget();
      }
    });
    super.initState();
  }

  checkBottomBanner(){
    bottomBanner = bottomBannerInfo.bottomBanner;
    if(bottomBanner.visible){
      heightOffBottomBanner = 100.0;
    }else{
      heightOffBottomBanner = 0.0;
    }
  }

  initTabTarget(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      FeatureDiscovery.discoverFeatures(
        context,
        <String>{
          // feature1,
          // feature2,
          // feature3,
          // feature4,
          // feature5,
          // feature6,
          // feature601,
          // feature602
          feature1,
          feature[0],
          feature[2],
          feature[1],
          feature[3],
          feature6,
          feature603,
          feature601,
          feature602,
        },
      );
    });
  }

  RegisterParamViewModel getRegister()  {
    // DataBaseProvider db =  DataBaseProvider();
    RegisterParamViewModel registerModel =  _presenter.getRegisters();
    return registerModel;
  }

  checkPayLoad(String payload){
    if(widget.indexTab == 0){
      if(getRegister().calendarType == 1){
        AnalyticsHelper().log(AnalyticsEvents.CalendarMiladiPg_Self_Pg_Load);
      }else{
        AnalyticsHelper().log(AnalyticsEvents.CalendarJalaliPg_Self_Pg_Load);
      }
    }else if(widget.indexTab == 1){
      AnalyticsHelper().log(AnalyticsEvents.MainClinicPg_Self_Pg_Load);
    }else if(widget.indexTab == 2){
      AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_Self_Pg_Load);
    }else if(widget.indexTab == 3){
      AnalyticsHelper().log(AnalyticsEvents.BlogPg_Self_Pg_Load);
    }
    if(payload.split('*')[0] == 'type'){
      int type = int.parse(payload.split('*')[1]);
      String drIdOrChatId = '';
      String topicId = '';
      String experienceId = '';
      String ticketId = '';
      String categoryId = '';
      if(type == 72){
        if(payload.split('*')[2] != ''){
          topicId = payload.split('*')[2];
        }
        if(payload.split('*')[3] != ''){
          experienceId = payload.split('*')[3];
        }
      }else if(type == 20 || type == 121){
        if(payload.split('*')[2] != ''){
          ticketId = payload.split('*')[2];
        }
        if(payload.split('*')[3] != ''){
          categoryId = payload.split('*')[3];
        }
      }else{
        if(payload.split('*')[2] != ''){
          drIdOrChatId = payload.split('*')[2];
        }
      }
      if(type == 1){
        initTabController(0);
      }else if(type == 2){
        initTabController(1);
      }else if(type == 3 || type == 40){
        initTabController(3);
      }else if(type == 4){
        initTabController(widget.indexTab);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child:  PartnerScreen(
                  )
              )
          );
        });
      }else if(type == 5){
        initTabController(widget.indexTab);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child:  ReportingScreen(
                    expertPresenter: _expertPresenter,
                    name: getRegister().name,
                  )
              )
          );
        });
      }else if(type == 6){
        initTabController(widget.indexTab);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child:  SignsScreen(
                    shareExp: false,
                  )
              )
          );
        });
      }else if(type == 7){
        initTabController(0);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child:  NoteScreen(
                    calenderPresenter: _calenderPresenter,
                    mode: 0,
                    isTwoBack: false,
                    isOfflineMode: false,
                  )
              )
          );
        });
      }else if(type == 8){
        initTabController(widget.indexTab);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child:  EnterFaceCodeScreen()
              )
          );
        });
      } else if(type == 9){
        initTabController(1);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child:  ChatScreen(
                    expertPresenter: _expertPresenter,
                    chatId: drIdOrChatId,
                    fromMainExpert: false,
                    fromActiveClini: false,
                  )
              )
          );
        });
      }
      else if(type == 30){
        initTabController(2);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child:  SendMessageScreen(
                  )
              )
          );
        });
      }else if(type == 90){
        initTabController(2);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child:  MemoryGameScreen()
              )
          );
        });
      }else if(type >= 200 && type <= 400){
        initTabController(1);
        WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child:  ClinicQuestionScreen(
                  expertPresenter: _expertPresenter,
                  bodyTicketInfo: {'type' : type,'DrId' : drIdOrChatId},
                  // ticketId: ticketsModel.ticketId,
                )
            )
         );
        });
      }else if(type == 50 || type == 51 || type == 52){
        initTabController(2);
      }else if(type == 10){
        initTabController(widget.indexTab);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child:  ChooseSubscriptionPage(isSub: widget.womansubscribtion != null ? widget.womansubscribtion : false)
              )
          );
        });
      }else if(type == 11){
        initTabController(widget.indexTab);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: UpdateScreen(
                    presenter: _profilePresenter,
                  )
              )
          );
        });
      } else if(type == 72){
        initTabController(widget.indexTab);
        if(topicId != ''){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.push(context,
                PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child:  ShareExperienceApp(
                      token: getRegister().token!,
                      baseUrl: womanUrl,
                      baseMediaUrl: mediaUrl,
                      initialRoute: InitialRout(id: topicId,route: AppRoutes.topic),
                    )
                    // TopicShareExpScreen(
                    //   topicId: topicId,
                    //   sharingExperiencePresenter: _sharingExperiencePresenter,
                    //   fromNotify: true,
                    // )
                )
            );
          });
        }else if(experienceId != ''){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.push(context,
                PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: ShareExperienceApp(
                      token: getRegister().token!,
                      baseUrl: womanUrl,
                      baseMediaUrl: mediaUrl,
                      initialRoute: InitialRout(id: experienceId,route: AppRoutes.comment),
                    ),
                    // CommentShareExpScreen(
                    //   shareId: experienceId,
                    //   sharingExperiencePresenter: _sharingExperiencePresenter,
                    //   indexShareExp: null,
                    //   isSelf: false,
                    //   fromNotify: true,
                    // )
                )
            );
          });
        }else{
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.push(context,
                PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child:  ShareExperienceApp(
                      token: getRegister().token!,
                      baseUrl: womanUrl,
                      baseMediaUrl: mediaUrl,
                    ),
                    // SharingExperienceScreen(
                    //   fromNotify: true,
                    // )
                )
            );
          });
        }

      }else if(type == 20){
        initTabController(widget.indexTab);
        if(ticketId != ''){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.push(context,
                PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child:  ChatSupportScreen(
                      supportPresenter: _supportPresenter,
                      chatId: ticketId,
                      fromNotify: true,
                      // dashboardPresenter: widget.presenter,
                    )
                )
            );
          });
        }else{
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.push(
                context,
                PageTransition(
                    child: SupportScreen(
                      categoryId: categoryId,
                      fromNotify: true,
                    ),
                    type: PageTransitionType.fade
                )
            );
          });
        }
      }else if(type == 120){
        initTabController(2);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: DailyMessageScreen(
                    dailyMessagePresenter: _dailyMessagePresenter,
                    partnerTabPresenter: _partnerTabPresenter,
                  )
              )
          );
        });
      }else if(type == 121){
        initTabController(2);
        if(ticketId != ''){
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: ChatApp(
                      back: (bool hasPartnerFromChat){
                        if(hasPartnerFromChat){
                          Navigator.pop(context);
                        }else{
                          _partnerTabPresenter.getManInfo(context,false);
                          Navigator.pop(context);
                        }
                      },
                      baseUrl: womanUrl,
                      baseMediaUrl: mediaUrl,
                      token: getRegister().token!,
                      id: ticketId,
                    )
                )
            );
          });
        }
      }else if(type == 122){
        initTabController(2);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: ArchiveDailyMessageScreen(
                    dailyMessagePresenter: _dailyMessagePresenter,
                    partnerTabPresenter: _partnerTabPresenter,
                  )
              )
          );
        });
      }else if(type == 123){
        initTabController(widget.indexTab);
        WidgetsBinding.instance.addPostFrameCallback((_) {
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
      } else{
        initTabController(widget.indexTab);
      }
    }else{
      initTabController(widget.indexTab);
    }
  }


  initTabController(index){
    controller =  PageController(initialPage: index,keepPage: false);
   setState(() {
     currentIndex = index;
   });

    print('currentIndex : $currentIndex');
  }

  // _handleTabSelection() {
  //
  //
  //   print('currentIndex : $currentIndex');
  // }

  @override
  void dispose() {
    checkVersionDialog.dispose();
    rateStore.dispose();
    checkReportingDialog.dispose();
    animationControllerScaleButton.dispose();
    pregnancyAndBreastfeedingLimitWeek.dispose();
    breastfeedingDialog.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (currentIndex== 0) {
      if (!_calenderPresenter.isShowDeleteNoteDialog.stream.value &&
          !_calenderPresenter.isShowDialog.stream.value) {
        // exitAppDialog.onPressShowDialog();
        setState(() {
          currentIndex = 4;
        });
          controller.jumpToPage(1);
      } else {
        return Future.value(true);
      }
    } else if (currentIndex  == 4) {
      if (pregnancyAndBreastfeedingLimitWeek.isShowCheckPregnancyWeekDialog.stream.value) {

      } else {
        exitAppDialog.onPressShowDialog();
        return Future.value(false);
      }
    } else {
      // exitAppDialog.onPressShowDialog();
      setState(() {
        currentIndex = 4;
      });
      controller.jumpToPage(1);
      return Future.value(false);
    }
    return Future.value(false);
  }

  // updateLocalNotification() async {
  //   // DataBaseProvider db =  DataBaseProvider();
  //   RegisterParamViewModel RegisterParamViewModel = await _presenter.getRegisters();
  //   List<CircleModel> circles = await _presenter.getAllCirlse();
  //   GenerateDashboardAndNotifyMessages().checkForNotificationMessage(circles[circles.length - 1], RegisterParamViewModel);
  //   GenerateDashboardAndNotifyMessages().close();
  // }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = .5;
    return  WillPopScope(
      onWillPop: _onWillPop,
      child:  Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Scaffold(
              key: _scaffoldKey,
              // floatingActionButton: Transform.scale(
              //   scale: 0.9,
              //   child: FloatingActionButton(
              //     elevation: 2,
              //     focusElevation: 4,
              //     // mini: true,
              //     backgroundColor: Colors.white,
              //     child: Padding(
              //         padding: EdgeInsets.all(ScreenUtil().setWidth(13)),
              //         child:  TabTarget(
              //           id: feature1,
              //           contentLocation: ContentLocation.above,
              //           icon:
              //           getRegister().status==1?
              //           SvgPicture.asset('assets/images/main_selected.svg'): getRegister().status == 2 ?
              //           SvgPicture.asset('assets/images/baby_selected.svg') :
              //           SvgPicture.asset('assets/images/breastfeeding_selected.svg'),
              //           title: 'صفحه اصلی',
              //           description:
              //           getRegister().status == 3 ?
              //           'به ایمپو خوش اومدی. این صفحه اصلی ایمپو هست. در این قسمت می‌تونی وضعیت فعلی خودت رو در دوران پس از زایمان ببینی' :
              //           getRegister().status == 2 ?
              //           'به ایمپو خوش اومدی. اینجا صفحه اصلی ایمپو هست. در این قسمت می‌تونی وضعیت فعلی بارداریت رو ببینی' :
              //           'به ایمپو خوش اومدی، اینجا صفحه اصلی ایمپو هست، در این قسمت می‌تونی وضعیت فعلی سیکلت رو ببینی',
              //           child: SvgPicture.asset(
              //             currentIndex == 4
              //                 ? getRegister().status==1? 'assets/images/main_selected.svg': getRegister().status == 2 ?
              //                 "assets/images/baby_selected.svg" :
              //                 'assets/images/breastfeeding_selected.svg'
              //
              //                 :getRegister().status==1? 'assets/images/main_unselected.svg': getRegister().status == 2 ?
              //                 'assets/images/baby_unselected.svg' :
              //                  'assets/images/breastfeeding_unselected.svg',
              //             // height:getRegister().status==1? ScreenUtil().setWidth(40):ScreenUtil().setWidth(120),
              //             // width: getRegister().status==1? ScreenUtil().setWidth(40):ScreenUtil().setWidth(120),
              //             // fit: BoxFit.cover,
              //
              //           ),
              //         )
              //     ),
              //     onPressed: () {
              //       setState(() {
              //         currentIndex = 4;
              //       });
              //       controller.jumpToPage(1);
              //     },
              //   ),
              // ),
              floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
              bottomSheet: SizedBox(
                height: ScreenUtil().setWidth(110 + heightOffBottomBanner),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        AnimatedBottomNavigationBar.builder(
                          height: ScreenUtil().setWidth(110),
                          itemCount: 4,
                          tabBuilder: (int index, bool isActive) {
                            return _tabItems(
                                title[index],
                                getRegister().status == 3 ?
                                breastfeedingDescription[index] :
                                getRegister().status == 2 ?
                                pregnancyDescription[index] :
                                periodDescription[index],
                                iconSelected[index],
                                iconUnselected[index],
                                index);
                          },
                          notchMargin: 6,
                          // backgroundColor: Colors.red,
                          activeIndex: currentIndex!,
                          splashSpeedInMilliseconds: 1,
                          notchSmoothness: NotchSmoothness.sharpEdge,
                          gapLocation: GapLocation.center,
                          leftCornerRadius: 5,
                          rightCornerRadius: 5,
                          onTap: (index) {
                            if(index == 0){
                              if(getRegister().calendarType == 1){
                                AnalyticsHelper().log(AnalyticsEvents.CalendarMiladiPg_Self_Pg_Load);
                              }else{
                                AnalyticsHelper().log(AnalyticsEvents.CalendarJalaliPg_Self_Pg_Load);
                              }
                            }else if(index == 1){
                              AnalyticsHelper().log(AnalyticsEvents.MainClinicPg_Self_Pg_Load);
                            }else if(index == 2){
                              AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_Self_Pg_Load);
                            }else if(index == 3){
                              AnalyticsHelper().log(AnalyticsEvents.BlogPg_Self_Pg_Load);
                            }
                            setState(() {
                              currentIndex = index;
                            });
                            if(currentIndex != 4){
                              controller.jumpToPage(currentIndex!);
                            }else{
                              controller.jumpToPage(1);
                            }
                            // setState(() {
                            //   currentIndex = index;
                            // });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              currentIndex = 4;
                            });
                            controller.jumpToPage(1);
                          },
                          child: Container(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Text(
                              "صفحه اصلی",
                              maxLines: 1,
                              style: context.textTheme.labelSmallProminent!.copyWith(
                                color: currentIndex == 4
                                    ? ColorPallet().mainColor
                                    : ColorPallet().gray,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    bottomBannerInfo.bottomBanner.visible ?
                    GestureDetector(
                      onTap: (){
                        checkPayLoad(bottomBanner.link != '' ? 'link*${bottomBanner.link}*' :
                        bottomBanner.type == 72 ? 'type*${bottomBanner.type}*${bottomBanner.topicId}*${bottomBanner.experienceId}*' :
                        bottomBanner.type == 20 ? 'type*${bottomBanner.type}*${bottomBanner.ticketId}*${bottomBanner.categoryId}*' :
                        bottomBanner.type != 0 && bottomBanner.type != 72 && bottomBanner.type != 20 ? 'type*${bottomBanner.type}*${bottomBanner.drId}*' :
                        '*${bottomBanner.text}*تایید');
                      },
                      child: Container(
                        height: ScreenUtil().setWidth(heightOffBottomBanner),
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            // center: Alignment(-0.8, -0.6),
                            colors: [
                              Color(0xffFF77D1),
                              Color(0xffD83EA4)
                            ],
                            radius: 1.0,
                          ),
                        ),
                        child:  Padding(
                            padding:  EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(20)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/bell.png',
                                    ),
                                    SizedBox(width: ScreenUtil().setWidth(10)),
                                    Text(
                                      bottomBanner.text,
                                      style: context.textTheme.labelMedium!.copyWith(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: ScreenUtil().setWidth(30),
                                )
                              ],
                            )
                        ),
                      ),
                    )
                        : SizedBox.shrink()
                  ],
                ),
              ),
              body:  Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(100 + heightOffBottomBanner)),
                      child:  Stack(
                        children: [
                          PageView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: controller,
                            children: <Widget>[
                              FeatureDiscovery(
                                recordStepsInSharedPreferences: true,
                                child: getRegister().calendarType ==
                                    1
                                    ? CalenderEn(
                                  calenderPresenter: _calenderPresenter,
                                  isOfflineMode: false,
                                  expertPresenter: _expertPresenter,
                                )
                                    : Calender(
                                  calenderPresenter : _calenderPresenter,
                                  isOfflineMode: false,
                                  expertPresenter: _expertPresenter,
                                ),
                              ),
                              FeatureDiscovery(
                                recordStepsInSharedPreferences: true,
                                child: MainClinicScreen(
                                  expertPresenter: _expertPresenter,
                                  context: context,
                                ),
                              ),
                              PartnerTabScreen(
                                partnerTabPresenter: _partnerTabPresenter,
                                expertPresenter: _expertPresenter,
                              ),
                              SocialScreen(
                                expertPresenter: _expertPresenter,
                              ),
                              //     : DashBoard(
                              //   presenter: _presenter,
                              //   featureId: feature6,
                              //   reminderFeature: feature601,
                              //   profileFeature: feature602,
                              //   calenderPresenter:
                              //   _calenderPresenter,
                              // )
                            ],
                          ),
                          currentIndex == 4 ?
                          DashBoard(
                            presenter: _presenter,
                            featureId: feature6,
                            myChangesFeature: feature603,
                            reminderFeature: feature601,
                            profileFeature: feature602,
                            calenderPresenter: _calenderPresenter,
                            expertPresenter: _expertPresenter,
                          ) : Container(
                            width: 0,
                            height: 0,
                          )
                        ],
                      )
                  ),
                ],
              ),
              backgroundColor: Colors.white,
            ),
            Material(
              type: MaterialType.transparency,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: ScreenUtil().setWidth(60 + heightOffBottomBanner)
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Transform.scale(
                        scale: 0.9,
                        child: FloatingActionButton(
                          elevation: 2,
                          focusElevation: 4,
                          // mini: true,
                          backgroundColor: Colors.white,
                          child: Padding(
                              padding: EdgeInsets.all(ScreenUtil().setWidth(13)),
                              child:  TabTarget(
                                id: feature1,
                                contentLocation: ContentLocation.above,
                                icon:
                                getRegister().status==1?
                                SvgPicture.asset('assets/images/main_selected.svg'): getRegister().status == 2 ?
                                SvgPicture.asset('assets/images/baby_selected.svg') :
                                SvgPicture.asset('assets/images/breastfeeding_selected.svg'),
                                title: 'صفحه اصلی',
                                description:
                                getRegister().status == 3 ?
                                'به ایمپو خوش اومدی. این صفحه اصلی ایمپو هست. در این قسمت می‌تونی وضعیت فعلی خودت رو در دوران پس از زایمان ببینی' :
                                getRegister().status == 2 ?
                                'به ایمپو خوش اومدی. اینجا صفحه اصلی ایمپو هست. در این قسمت می‌تونی وضعیت فعلی بارداریت رو ببینی' :
                                'به ایمپو خوش اومدی، اینجا صفحه اصلی ایمپو هست، در این قسمت می‌تونی وضعیت فعلی سیکلت رو ببینی',
                                child: SvgPicture.asset(
                                  currentIndex == 4
                                      ? getRegister().status==1? 'assets/images/main_selected.svg': getRegister().status == 2 ?
                                  "assets/images/baby_selected.svg" :
                                  'assets/images/breastfeeding_selected.svg'

                                      :getRegister().status==1? 'assets/images/main_unselected.svg': getRegister().status == 2 ?
                                  'assets/images/baby_unselected.svg' :
                                  'assets/images/breastfeeding_unselected.svg',
                                  // height:getRegister().status==1? ScreenUtil().setWidth(40):ScreenUtil().setWidth(120),
                                  // width: getRegister().status==1? ScreenUtil().setWidth(40):ScreenUtil().setWidth(120),
                                  // fit: BoxFit.cover,

                                ),
                              )
                          ),
                          onPressed: () {
                            setState(() {
                              currentIndex = 4;
                            });
                            controller.jumpToPage(1);
                          },
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder(
                    stream: _presenter.isShowPeriodDialogObserve,
                    builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog) {
                      if (snapshotIsShowDialog.data != null) {
                        if (snapshotIsShowDialog.data!) {
                          return  StreamBuilder(
                            stream: _presenter.myChangeDialogObserve,
                            builder: (context,AsyncSnapshot<MyChangePanelModel>snapshotMyChangePanel) {
                              if (snapshotMyChangePanel.data != null) {
                                return StreamBuilder(
                                  stream: _presenter.isLoadingObserve,
                                  builder: (context,snapshotIsLoading){
                                    if(snapshotIsLoading.data != null){
                                      return QusDialog(
                                        scaleAnim: _presenter.dialogScaleObserve,
                                        onPressCancel: (){
                                          if(snapshotMyChangePanel.data!.mode == 0){
                                            AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_ImPeriodNoDlg_Btn_Clk_BtmSht);
                                          }else if(snapshotMyChangePanel.data!.mode == 1){
                                            AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_NotPeriodNoDlg_Btn_Clk_BtmSht);
                                          }else if(snapshotMyChangePanel.data!.mode == 3){
                                            AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_EndPeriodNoDlg_Btn_Clk_BtmSht);
                                          }else{
                                            AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_ContPeriodNoDlg_Btn_Clk_BtmSht);
                                          }
                                          _presenter.onPressCancelPeriodDialog();
                                        },
                                        value: snapshotMyChangePanel.data!.title,
                                        yesText: 'بله مطمئنم',
                                        noText: 'نه!',
                                        onPressYes: () async {
                                          if(snapshotMyChangePanel.data!.mode == 0){
                                            AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_ImPeriodYesDlg_Btn_Clk_BtmSht);
                                          }else if(snapshotMyChangePanel.data!.mode == 1){
                                            AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_NotPeriodYesDlg_Btn_Clk_BtmSht);
                                          }else if(snapshotMyChangePanel.data!.mode == 3){
                                            AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_EndPeriodYesDlg_Btn_Clk_BtmSht);
                                          }else{
                                            AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_ContPeriodYesDlg_Btn_Clk_BtmSht);
                                          }
                                          snapshotMyChangePanel.data!.mode == 0 ?
                                          _presenter.onPressBtnImPeriod(context)
                                              : snapshotMyChangePanel.data!.mode == 1
                                              ?  _presenter.onPressBtnNotPeriod(context)
                                              :  _presenter.onPressBtnKhonrizi(context,snapshotMyChangePanel.data!.mode);
                                          /// await _presenter.removeTable('SugMessages');
                                          /// AutoBackup().setCycleInfoAndCycleCalender();
                                        },
                                        colors: [
                                          Colors.white,
                                          Colors.white
                                        ],
                                        topIcon: 'assets/images/ic_box_question.svg',
                                        isIcon: true,
                                        isLoadingButton: snapshotIsLoading.data,
                                      );
                                    }else{
                                      return Container();
                                    }
                                  },
                                );
                              } else {
                                return  Container();
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
                  StreamBuilder(
                    stream: _presenter.isShowChangeStatusDialogObserve,
                    builder: (context,AsyncSnapshot<bool>snapshotChangeStatusDialog) {
                      if (snapshotChangeStatusDialog.data != null) {
                        if (snapshotChangeStatusDialog.data!) {
                          return  StreamBuilder(
                            stream: _presenter.typeChangeStatusDialogObserve,
                            builder: (context,snapshotTypeChangeStatus){
                              if(snapshotTypeChangeStatus.data != null){
                                return QusDialog(
                                  scaleAnim: _presenter.dialogScaleObserve,
                                  onPressCancel: (){
                                    if(snapshotTypeChangeStatus.data == 0){
                                      AnalyticsHelper().log(AnalyticsEvents.DashPgBrstfeed_ImPeriodNoDlg_Btn_Clk_BtmSht);
                                    }else{
                                      AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_ImPregnantNoDlg_Btn_Clk_BtmSht);
                                    }
                                    _presenter.onPressCancelChangeStatusDialog();
                                  },
                                  title: '${getRegister().name} جان',
                                  value: snapshotTypeChangeStatus.data == 0 ?
                                  'آیا برای ورود به فاز قاعدگی اطمینان داری؟' :
                                  'مطمئنی می‌خوای از فاز قاعدگی خارج بشی و از فاز بارداری استفاده کنی؟' ,
                                  yesText: snapshotTypeChangeStatus.data == 0 ? 'آره' :
                                  'آره باردار شدم',
                                  noText: snapshotTypeChangeStatus.data == 0 ? 'نه' :
                                  'نه',

                                  onPressYes: () async {
                                    _presenter.onPressCancelChangeStatusDialog();
                                    if(snapshotTypeChangeStatus.data == 0){
                                      AnalyticsHelper().log(AnalyticsEvents.DashPgBrstfeed_ImPeriodYesDlg_Btn_Clk_BtmSht);
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType.fade,
                                              child:  PeriodDayRegisterScreen(
                                                hasAbortion: false,
                                              )
                                          )
                                      );
                                    }else{
                                      AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_ImPregnantYesDlg_Btn_Clk_BtmSht);
                                      Navigator.push(context,
                                          PageTransition(
                                              settings: RouteSettings(name: "/Page1"),
                                              type: PageTransitionType.topToBottom,
                                              child:  ChangeStatusScreen()
                                          )
                                      );
                                    }
                                  },
                                  colors: [
                                    Colors.white,
                                    Colors.white
                                  ],
                                  topIcon: 'assets/images/ic_box_question.svg',
                                  isIcon: true,
                                  isLoadingButton: false,
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
                  StreamBuilder(
                    stream: _presenter.isAborationDialogObserve,
                    builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog) {
                      if (snapshotIsShowDialog.data != null) {
                        if (snapshotIsShowDialog.data!) {
                          return AborationDialog(
                            scaleAnim: _presenter.dialogScaleObserve,
                            onPressCancel: (){
                              AnalyticsHelper().log(AnalyticsEvents.DashPgPregnancy_AbrtNoDlg_Btn_Clk_BtmSht);
                              _presenter.aborationCancelDialog();
                            },
                            title: Text(
                              '${getRegister().name} جان',
                              style: context.textTheme.labelLargeProminent,
                            ),
                            onPressYes: () {
                              AnalyticsHelper().log(AnalyticsEvents.DashPgPregnancy_AbrtYesDlg_Btn_Clk_BtmSht);
                              _presenter.enterMenstruation(context,_registerPresenter);
                            },
                            isIcon: true,
                            colors: [Colors.white, Colors.white],
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    },
                  ),
                  StreamBuilder(
                    stream: _calenderPresenter.isShowCanDrawOverlaysDialogObserve,
                    builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog) {
                      if (snapshotIsShowDialog.data != null) {
                        if (snapshotIsShowDialog.data!) {
                          return  QusDialog(
                            scaleAnim: _calenderPresenter.dialogScaleObserve,
                            onPressCancel: _calenderPresenter
                                .onPressCancelOverlayDialog,
                            value: "برای نمایش بهتر یاد‌آور‌ها، لازمه که به ایمپو مجوز نمایش بدی",
                            yesText: 'اجازه میدم',
                            noText: 'نه!',
                            onPressYes: _calenderPresenter
                                .onPressYesOverlayDialog,
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
                  // StreamBuilder(
                  //   stream: _presenter.isShowHelpDialogObserve,
                  //   builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog) {
                  //     if (snapshotIsShowDialog.data != null) {
                  //       if (snapshotIsShowDialog.data!) {
                  //         return  HelpDialog(
                  //           scaleAnim: _presenter.dialogScaleObserve,
                  //           value: "برای نمایش بهتر یاد‌آور‌ها، لازمه که به ایمپو مجوز نمایش بدی",
                  //           okText: 'آهان',
                  //           onPressOk: _presenter.onPressOkHelpDialog,
                  //           colors: [
                  //             ColorPallet().fertDeep,
                  //             ColorPallet().fertLight,
                  //           ],
                  //         );
                  //       } else {
                  //         return  Container();
                  //       }
                  //     } else {
                  //       return  Container();
                  //     }
                  //   },
                  // ),
                  StreamBuilder(
                    stream: _presenter.iisShowErrorDialogObserve,
                    builder: (context,AsyncSnapshot<bool>snapshotDialogScale) {
                      if (snapshotDialogScale.data != null) {
                        if (snapshotDialogScale.data!) {
                          return  StreamBuilder(
                            stream: _presenter.valueDialogErrorObserve,
                            builder: (context, snapshotValueError) {
                              if (snapshotValueError.data != null) {
                                return  OkDialog(
                                  scaleAnim: _presenter.dialogScaleObserve,
                                  okText: 'تایید',
                                  value: snapshotValueError.data,
                                  onPressOk: () {
                                    _presenter.onPressOkErrorDialog();
                                  },
                                  colors: [
                                    Colors.white,
                                    Colors.white
                                  ],
                                  topIcon: 'assets/images/ic_box_question.svg',
                                  onPressClose: () {
                                    _presenter.onPressOkErrorDialog();
                                  },
                                  isExpert: false,
                                  isLoadingButton: false,
                                );
                              } else {
                                return  Container();
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
                  StreamBuilder(
                      stream: _partnerTabPresenter.isShowRejectPartnerDialogObserve,
                      builder: (context,AsyncSnapshot<bool>snapshotRejectPartnerDialog) {
                        if (snapshotRejectPartnerDialog.data != null) {
                          if (snapshotRejectPartnerDialog.data!) {
                            return  StreamBuilder(
                              stream: _partnerTabPresenter.isLoadingButtonObserve,
                              builder: (context,snapshotIsLoadingButton){
                                if(snapshotIsLoadingButton.data != null){
                                  return QusDialog(
                                    scaleAnim: _partnerTabPresenter.dialogScaleObserve,
                                    onPressCancel: (){
                                      if(_partnerTabPresenter.selectedPartner.isRecv){
                                        AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_RejectPartnerNoDlg_Btn_Clk);
                                      }else{
                                        AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_CancelPartnerNoDlg_Btn_Clk);
                                      }
                                      _partnerTabPresenter.rejectPartnerCancelDialog();
                                    },
                                    value: _partnerTabPresenter.selectedPartner.isRecv ?
                                    "آیا از رد کردن درخواست همدلیت مطمئنی؟" : "از لغو درخواست همدلیت مطمئنی؟",
                                    yesText: 'آره',
                                    noText: 'نه!',
                                    onPressYes: (){
                                      if(_partnerTabPresenter.selectedPartner.isRecv){
                                        AnalyticsHelper().log(
                                            AnalyticsEvents.PartnerTabPg_RejectPartnerYesDlg_Btn_Clk,
                                            parameters: {'id' : _partnerTabPresenter.selectedPartner.id}
                                        );
                                      }else{
                                        AnalyticsHelper().log(
                                            AnalyticsEvents.PartnerTabPg_CancelPartnerYesDlg_Btn_Clk,
                                            parameters: {'id' : _partnerTabPresenter.selectedPartner.id}
                                        );
                                      }
                                      _partnerTabPresenter.rejectPartner(context);
                                    },
                                    isIcon: true,
                                    colors: [
                                      Colors.white,
                                      Colors.white
                                    ],
                                    topIcon: 'assets/images/ic_box_question.svg',
                                    isLoadingButton: snapshotIsLoadingButton.data,
                                  );
                                }else{
                                  return Container();
                                }
                              },
                            );
                          }
                        }
                        return Container();
                      }),
                  StreamBuilder(
                      stream: _partnerTabPresenter.isShowCeriticalDialogObserve,
                      builder: (context,AsyncSnapshot<bool>snapshotCerticalDialog) {
                        if (snapshotCerticalDialog.data != null) {
                          if (snapshotCerticalDialog.data!) {
                            return CerticalDialog(
                              title: "روز بحرانی چیست؟",
                              scaleAnim: _partnerTabPresenter.dialogScaleObserve,
                              okText: 'فهمیدم',
                              value:
                              "در روزهای بحرانی، توانایی‌های مرتبط با هر سیکل، حالتی متزلزل و ناپایدار دارن. روزهای بحرانی روزهای تغییر وضع دادن هستن. پیشنهاد می‌شه که در این روزها بیشتر مراقب همدلت باشی به این خاطر که سیستم جسمی، عاطفی یا ذهنیش در یه وضعیت بی‌ثبات قرار می‌گیره.",
                              onPressOk: () {
                                _partnerTabPresenter.ceritialCancelDialog();
                              },
                              colors: [Colors.white, Colors.white],
                              onPressClose: () {
                                _partnerTabPresenter.ceritialCancelDialog();
                              },
                              topIcon: 'assets/images/certical_dialog.svg',
                              isExpert: true,
                            );
                          }
                        }
                        return Container();
                      }),
                  StreamBuilder(
                    stream: _partnerTabPresenter.isShowBioritmDialogObserve,
                    builder: (context,AsyncSnapshot<bool> snapshotIsShowDialog) {
                      if (snapshotIsShowDialog.data != null) {
                        if (snapshotIsShowDialog.data!) {
                          return  BioritmDialog(
                            scaleAnim: _partnerTabPresenter.dialogScaleObserve,
                            onPressOk: () {
                              _partnerTabPresenter.bioritmCancelDialog();
                            },
                            backgroundColor: Colors.white,
                            onPressClose: () {
                              _partnerTabPresenter.bioritmCancelDialog();
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
                  StreamBuilder(
                    stream: exitAppDialog.isShowExitDialogObserve,
                    builder: (context,AsyncSnapshot<bool> snapshotIsShowDialog) {
                      if (snapshotIsShowDialog.data != null) {
                        if (snapshotIsShowDialog.data!) {
                          return  QusDialog(
                            scaleAnim: exitAppDialog.dialogScaleObserve,
                            onPressCancel: exitAppDialog.cancelDialog,
                            value: '\nمطمئنی می‌خوای از ایمپو خارج بشی؟\n',
                            yesText: 'آره برمیگردم',
                            noText: 'نه',
                            onPressYes: () {
                              exitAppDialog.acceptDialog(context);
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
                  ///  StreamBuilder(
                  ///   stream: _messageNotReadDialog.isShowMsgNotReadDialogObserve,
                  ///   builder: (context, snapshotIsShowDialog) {
                  ///     if (snapshotIsShowDialog.data != null) {
                  ///       if (snapshotIsShowDialog.data) {
                  ///         return  StreamBuilder(
                  ///           stream: _messageNotReadDialog
                  ///               .valueMsgNotReadDialogObserve,
                  ///           builder: (context, snapshotValue) {
                  ///             if (snapshotValue.data != null) {
                  ///               return  QusDialog(
                  ///                 scaleAnim: _messageNotReadDialog
                  ///                     .dialogScaleObserve,
                  ///                 onPressCancel: () {
                  ///                     _messageNotReadDialog.cancelUpdate();
                  ///                 },
                  ///                 value: snapshotValue.data,
                  ///                 yesText: 'آره میخونم',
                  ///                 noText: 'نه بعدا',
                  ///                 onPressYes: () {
                  ///                  _messageNotReadDialog.acceptUpdate(_calenderPresenter,_scaffoldKey.currentContext);
                  ///                },
                  ///                 isIcon: true,
                  ///                 colors: [
                  ///                   Colors.white,
                  ///                   Colors.white
                  ///                ],
                  ///                topIcon: 'assets/images/ic_box_question.svg',
                  ///                 isLoadingButton: false,
                  ///                 size: ScreenUtil().setWidth(130),
                  ///                 alignIcon: Alignment.center,
                  ///              );
                  ///            } else {
                  ///               return  Container();
                  ///             }
                  ///           },
                  ///        );
                  ///       } else {
                  ///         return  Container();
                  ///       }
                  ///     } else {
                  ///       return  Container();
                  ///     }
                  ///   },
                  /// ),
                  StreamBuilder(
                    stream: checkReportingDialog.isShowCheckReportingDialog,
                    builder: (context,AsyncSnapshot<bool> snapshotIsShowDialog) {
                      if (snapshotIsShowDialog.data != null) {
                        if (snapshotIsShowDialog.data!) {
                          return  StreamBuilder(
                            stream: checkReportingDialog.valueCheckUpdateDialogObserve,
                            builder: (context, snapshotValue) {
                              if (snapshotValue.data != null) {
                                return   QusDialog(
                                  scaleAnim: checkReportingDialog.dialogScaleObserve,
                                  onPressCancel: () {
                                    AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_CheckReportingNoDlg_Btn_Clk);
                                    checkReportingDialog.cancel();
                                  },
                                  value: snapshotValue.data,
                                  yesText: 'الان',
                                  noText: 'بعدا',
                                  onPressYes: () {
                                    AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_CheckReportingYesDlg_Btn_Clk);
                                    checkReportingDialog.accept(context,_expertPresenter,getRegister().name);
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
                  StreamBuilder(
                    stream: breastfeedingDialog.isShowBreastfeedingDialogObserve,
                    builder: (context,AsyncSnapshot<bool> snapshotIsShowDialog) {
                      if (snapshotIsShowDialog.data != null) {
                        if (snapshotIsShowDialog.data!) {
                          return  OkDialog(
                            scaleAnim: breastfeedingDialog.dialogScaleObserve,
                            okText: 'چه خوب 😍',
                            value: "با شروع مادری، نهایتا 6 ماه بعد از زایمان و تا شروع مجدد قاعدگیت، ایمپو در کنارت خواهد بود تا به آرومی و سلامت این روزهای قشنگ رو بگذرونی 😍",
                            onPressOk: () {
                              AnalyticsHelper().log(AnalyticsEvents.DashPgBrstfeed_BrstfeedOkDlg_Btn_Clk);
                              breastfeedingDialog.cancel();
                              initTabTarget();
                            },
                            title: '${getRegister().name} جان',
                            colors: [
                              Colors.white,
                              Colors.white
                            ],
                            topIcon: 'assets/images/correct_dialog.svg',
                            onPressClose: () {
                              AnalyticsHelper().log(AnalyticsEvents.DashPgBrstfeed_BrstfeedOkDlg_Btn_Clk);
                              breastfeedingDialog.cancel();
                              initTabTarget();
                            },
                            isExpert: true,
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
                  StreamBuilder(
                    stream: pregnancyAndBreastfeedingLimitWeek.isShowCheckPregnancyWeekDialogObserve,
                    builder: (context,AsyncSnapshot<bool> snapshotIsShowDialog) {
                      if (snapshotIsShowDialog.data != null) {
                        if (snapshotIsShowDialog.data!) {
                          return  StreamBuilder(
                            stream: pregnancyAndBreastfeedingLimitWeek.isPregnancyDialogObserve,
                            builder: (context,AsyncSnapshot<bool> snapshotIsPregnancy){
                              if(snapshotIsPregnancy.data != null){
                                return QusDialog(
                                  scaleAnim: pregnancyAndBreastfeedingLimitWeek.dialogScaleObserve,
                                  onPressCancel: () {
                                    AnalyticsHelper().log(AnalyticsEvents.DashPgPregnancy_PrgcLtWkAbrt_Btn_Clk_Dlg);
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.fade,
                                            child:  PeriodDayRegisterScreen(
                                              hasAbortion: false,
                                            )
                                        )
                                    );
                                  },
                                  value: snapshotIsPregnancy.data! ?
                                  'با توجه به اتمام هفته 42 بارداری، لازمه برای استفاده از سایر خدمات ایمپو وضعیت خودت رو مشخص کنی' :
                                  '25هفته از زایمانت گذشته و احتمالا پریودت شروع شده از این به بعد با فاز قاعدگی ایمپو کنارت هستیم',
                                  title: '${getRegister().name} جان',
                                  yesText: snapshotIsPregnancy.data! ?
                                  'زایمان' : 'تکمیل اطلاعات فاز قاعدگی',
                                  noText: 'ختم بارداری',
                                  notCancel: true,
                                  onPressYes: () {
                                    if(snapshotIsPregnancy.data!){
                                      AnalyticsHelper().log(AnalyticsEvents.DashPgPregnancy_PrgcLtWkChBirth_Btn_Clk_Dlg);
                                    }else{
                                      AnalyticsHelper().log(AnalyticsEvents.DashPgBrstfeed_CompletePeriodFaz_Btn_Clk_Dlg);
                                    }
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: snapshotIsPregnancy.data! ?
                                            ChangeStatusScreen(
                                            ) : PeriodDayRegisterScreen(
                                              hasAbortion: false,
                                            ),
                                            type: PageTransitionType.fade)
                                    );
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
                  StreamBuilder(
                    stream: rateStore.isShowCheckReportingDialog,
                    builder: (context,AsyncSnapshot<bool> snapshotIsShowDialog) {
                      if (snapshotIsShowDialog.data != null) {
                        if (snapshotIsShowDialog.data!) {
                          return RateStoreDialog(
                            scaleAnim: rateStore.dialogScaleObserve,
                            title: '${getRegister().name} جان',
                            onPressNo: () {
                              AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_RateStoreNoDlg_Btn_Clk);
                              rateStore.cancel();
                            },
                            onPressYes: () {
                              AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_RateStoreYesDlg_Btn_Clk);
                              rateStore.accept(context,_expertPresenter,getRegister().name);
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
                  widget.register == null ?
                  StreamBuilder(
                    stream: checkVersionDialog.isShowCheckUpdateDialogObserve,
                    builder: (context,AsyncSnapshot<bool> snapshotIsShowDialog) {
                      if (snapshotIsShowDialog.data != null) {
                        if (snapshotIsShowDialog.data!) {
                          return  StreamBuilder(
                            stream: checkVersionDialog
                                .valueCheckUpdateDialogObserve,
                            builder: (context,AsyncSnapshot<List> snapshotValue) {
                              if (snapshotValue.data != null) {
                                return  QusDialog(
                                  scaleAnim: checkVersionDialog
                                      .dialogScaleObserve,
                                  onPressCancel: () {
                                    if (!snapshotValue.data![2]) {
                                      checkVersionDialog.cancelUpdate();
                                    }
                                  },
                                  value: snapshotValue.data![0],
                                  yesText: 'بزن بریم',
                                  noText: 'بعدا',
                                  onPressYes: () {
                                    checkVersionDialog.acceptUpdate(
                                        snapshotValue.data![1]);
                                  },
                                  isIcon: true,
                                  isOneBtn: snapshotValue.data![2] ? true : null,
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
                            },
                          );
                        } else {
                          return  Container();
                        }
                      } else {
                        return  Container();
                      }
                    },
                  )
                      :  Container(),
                ],
              ),
            )
          ],
        )
      ),
    );
  }


  _tabItems(String title, String description, String icon_selected,
      String icon_unselected, int index) {
    return TabTarget(
        id: feature[index],
        contentLocation: ContentLocation.trivial,
        icon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon_selected,
              height: tabSize,
              width: tabSize,
            ),
            Text(
              title,
              style: context.textTheme.labelSmallProminent!.copyWith(
                color: ColorPallet().mainColor
              ),
            )
          ],
        ),
        title: title,
        description: description,
        child: Column(
          children: [
            SizedBox(
              height: ScreenUtil().setWidth(20),
            ),
            SizedBox(
              height: tabSize,
              width: tabSize,
              child: SvgPicture.asset(
                currentIndex == index ? icon_selected : icon_unselected,
              ),
            ),
            Text(
              title,
              style: context.textTheme.labelSmallProminent!.copyWith(
                color: currentIndex == index
                    ? ColorPallet().mainColor
                    : ColorPallet().gray,
              ),
            )
          ],
        ));
  }

  @override
  void onError(msg) {
  }

  @override
  void onSuccess(msg) {

  }

}