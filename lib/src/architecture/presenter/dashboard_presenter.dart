


import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';
import 'package:impo/src/architecture/model/dashboard_model.dart';
import 'package:impo/src/architecture/presenter/calender_presenter.dart';
import 'package:impo/src/architecture/presenter/register_presenter.dart';
import 'package:impo/src/architecture/view/dashboard_view.dart';
import 'package:impo/src/components/DateTime/my_datetime.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/item_birth_or_cycle.dart';
import 'package:impo/src/core/app/view/widgets/snackbar/custom_snack_bar.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/data/local/save_data_offline_mode.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/bioRhythm/bio_model.dart';
import 'package:impo/src/models/bioRhythm/biorhythm_view_model.dart';
import 'package:impo/src/models/breastfeeding/breastfeeding_number_model.dart';
import 'package:impo/src/models/register/circles_send_server_model.dart';
import 'package:impo/src/models/dashboard/pregnancy_numbers_model.dart';
import 'package:impo/src/models/dashboard/dashboard_messages_and_notify_model.dart';
import 'package:impo/src/models/advertise_model.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/dashboard/my_change_panel_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/models/signsModel/breastfeeding_signs_model.dart';
import 'package:impo/src/models/signsModel/pregnancy_signs_model.dart';
import 'package:impo/src/models/signsModel/sings_view_model.dart';
import 'package:impo/src/models/story_model.dart';
import 'package:impo/src/screens/LoginAndRegister/menstruationRegister/periodDay_register_screen.dart';
import 'package:impo/src/screens/home/home.dart';
import 'package:impo/src/screens/home/tabs/main/sharing_experience/sharing_experience_screen.dart';
import 'package:impo/src/singleton/payload.dart';
import 'package:impo/src/screens/LoginAndRegister/identity/login_screen.dart';
import 'package:impo/src/screens/LoginAndRegister/identity/verify_code_screen.dart';
import 'package:impo/src/screens/home/blank_screen.dart';
import 'package:impo/src/data/messages/generate_dashboard_notify_and_messages.dart';
import 'package:impo/src/screens/home/tabs/main/widget/my_status_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:impo/src/models/calender/alarm_model.dart';
import '../../components/colors.dart';
import '../../firebase_analytics_helper.dart';



List<DashBoardMessageAndNotifyViewModel> bottomMessageDashboard = [];



class DashboardPresenter{

  late DashboardView _dashboardView;

  late DashboardModel _dashboardModel = new DashboardModel();

  late AnimationController animationControllerDialog;
  late PanelController panelController;

  List before = [];
  List after = [];
  List ovu = [];
  List mental = [];
  List other = [];

  int indexAlarmsLessServerId = 0;
  int indexAlarmsWithServerId = 0;
  int indexRemoveAlarmCalender = 0;

  int indexReminderLessServerId = 0;
  int indexReminderWithServerId = 0;
  int indexRemoveReminder = 0;
  late Animation<Offset> downAnimationBox1;
  late AnimationController downAnimationControllerBox1;
  late Animation<Offset> downAnimationBox2;
  late AnimationController downAnimationControllerBox2;

  bool isChangeDialogSign = false;
  bool isChangeDialogSettingScreens = false;
  int dayMode = 3;

  DashboardPresenter(DashboardView view){

    this._dashboardView = view;

  }

  late CycleViewModel lastCircle;

  late CycleViewModel oneOfLastCircle;

  ///  نشانه های فاز قاعدپی///
  List<SignsViewModel> _beforePeriodSings = [
    SignsViewModel(
        title: 'دل درد',
        isSelected: false,
        icon: 'assets/images/deldard_darperiod_1.png',
        unSelectIcon: 'assets/images/deldard_darperiod_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'سر درد',
        isSelected: false,
        icon: 'assets/images/sardard_ghablazghedegi_1.png',
        unSelectIcon: 'assets/images/sardard_ghablazghedegi_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'حساسیت و درد سینه',
        isSelected: false,
        icon: 'assets/images/dardesine_ghablazghaedegi_1.png',
        unSelectIcon: 'assets/images/dardesine_ghablazghaedegi_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'کوفتگی',
        isSelected: false,
        icon: 'assets/images/kooftegibadan_ghablazghaedegi_1.png',
        unSelectIcon: 'assets/images/kooftegibadan_ghablazghaedegi_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'ریزش مو',
        isSelected: false,
        icon: 'assets/images/rizeshmo_ghablazghedegi_1.png',
        unSelectIcon: 'assets/images/rizeshmo_ghablazghedegi_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'پرخوری ',
        isSelected: false,
        icon: 'assets/images/porkhori_ghablazghedegi_1.png',
        unSelectIcon: 'assets/images/porkhori_ghablazghedegi_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'بی‌اشتهایی',
        isSelected: false,
        icon: 'assets/images/bieshteha_ghablazghedegi_1.png',
        unSelectIcon: 'assets/images/bieshteha_ghablazghedegi_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'لرز',
        isSelected: false,
        icon: 'assets/images/larz_ghablazghedegi_1.png',
        unSelectIcon: 'assets/images/larz_ghablazghedegi_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'گرگرفتگی',
        isSelected: false,
        icon: 'assets/images/gor_ghablazghedegi_1.png',
        unSelectIcon: 'assets/images/gor_ghablazghedegi_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'افزایش میل جنسی',
        isSelected: false,
        icon: 'assets/images/highsexi_ghablazghedegi_1.png',
        unSelectIcon: 'assets/images/highsexi_ghablazghedegi_0.png',
        isLoading: false),
  ];

  List<SignsViewModel> _duringPeriodSigns = [
    SignsViewModel(
        title: 'دل درد',
        isSelected: false,
        icon: 'assets/images/deldard_darperiod_1.png',
        unSelectIcon: 'assets/images/deldard_darperiod_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'کمر درد',
        isSelected: false,
        icon: 'assets/images/kamardard_darperiod_1.png',
        unSelectIcon: 'assets/images/kamardard_darperiod_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'جوش صورت',
        isSelected: false,
        icon: 'assets/images/jooshsoorat_darperiod_1.png',
        unSelectIcon: 'assets/images/jooshsoorat_darperiod_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'نفخ',
        isSelected: false,
        icon: 'assets/images/nafkh_darperiod_1.png',
        unSelectIcon: 'assets/images/nafkh_darperiod_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'اسهال',
        isSelected: false,
        icon: 'assets/images/eshal_darperiod_1.png',
        unSelectIcon: 'assets/images/eshal_darperiod_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'یبوست',
        isSelected: false,
        icon: 'assets/images/uboosat_darperiod_1.png',
        unSelectIcon: 'assets/images/uboosat_darperiod_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'پر خوابی یا اختلال خواب',
        isSelected: false,
        icon: 'assets/images/ekhtelalekhab_darperiod_1.png',
        unSelectIcon: 'assets/images/ekhtelalekhab_darperiod_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'حساسیت لثه و دندان',
        isSelected: false,
        icon: 'assets/images/dandan_ovu_1.png',
        unSelectIcon: 'assets/images/dandan_ovu_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'پادرد ',
        isSelected: false,
        icon: 'assets/images/padard_ghablazghedegi_1.png',
        unSelectIcon: 'assets/images/padard_ghablazghedegi_0.png',
        isLoading: false),
  ];
  List<SignsViewModel> _ovuSigns = [
    SignsViewModel(
        title: 'دل درد',
        isSelected: false,
        icon: 'assets/images/deldard_ovu_1.png',
        unSelectIcon: 'assets/images/deldard_ovu_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'لکه‌بینی',
        isSelected: false,
        icon: 'assets/images/lakebini_ovu_1.png',
        unSelectIcon: 'assets/images/lakebini_ovu_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'نوسان خلق',
        isSelected: false,
        icon: 'assets/images/navasanekholgh_ovu_1.png',
        unSelectIcon: 'assets/images/navasanekholgh_ovu_0.png',
        isLoading: false),
  ];

  List<SignsViewModel> _mentalSigns = [
    SignsViewModel(
        title: 'نوسان خلق',
        isSelected: false,
        icon: 'assets/images/navasanekholgh_sayer_1.png',
        unSelectIcon: 'assets/images/navasanekholgh_sayer_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'اضطراب',
        isSelected: false,
        icon: 'assets/images/azterab_sayer_1.png',
        unSelectIcon: 'assets/images/azterab_sayer_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'افسردگی و تجربه یأس',
        isSelected: false,
        icon: 'assets/images/afsordegi_sayer_1.png',
        unSelectIcon: 'assets/images/afsordegi_sayer_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'افت تاب آوری',
        isSelected: false,
        icon: 'assets/images/oftetabavari_sayer_1.png',
        unSelectIcon: 'assets/images/oftetabavari_sayer_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'خشم و پرخاشگری',
        isSelected: false,
        icon: 'assets/images/khashm_sayer_1.png',
        unSelectIcon: 'assets/images/khashm_sayer_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'میل به تنهایی',
        isSelected: false,
        icon: 'assets/images/meylbtanhaee_sayer_1.png',
        unSelectIcon: 'assets/images/meylbtanhaee_sayer_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'کاهش میل جنسی',
        isSelected: false,
        icon: 'assets/images/kaheshemeylejenc_sayer_1.png',
        unSelectIcon: 'assets/images/kaheshemeylejenc_sayer_0.png',
        isLoading: false),
  ];

  List<SignsViewModel> _otherSigns = [
    SignsViewModel(
        title: 'مصرف داروهای افسردگی و اضطراب',
        isSelected: false,
        icon: 'assets/images/darooafsordegi_sayer_1.png',
        unSelectIcon: 'assets/images/darooafsordegi_sayer_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'مصرف قرص‌های پیشگیری از بارداری',
        isSelected: false,
        icon: 'assets/images/ghorsebardari_sayer_1.png',
        unSelectIcon: 'assets/images/ghorsebardari_sayer_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'علانم شروع یائسگی',
        isSelected: false,
        icon: 'assets/images/nadikibyaesegi_asyer_1.png',
        unSelectIcon: 'assets/images/nadikibyaesegi_asyer_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'تنبلی تخمدان',
        isSelected: false,
        icon: 'assets/images/tanbalitokhmdan_sayer_1.png',
        unSelectIcon: 'assets/images/tanbalitokhmdan_sayer_0.png',
        isLoading: false),
    SignsViewModel(
        title: 'واژینیسموس',
        isSelected: false,
        icon: 'assets/images/vaginismus_sayer_1.png',
        unSelectIcon: 'assets/images/vaginismus_sayer_0.png',
        isLoading: false)
  ];
  ///  نشانه های فاز قاعدپی///

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  ///  نشانه های فاز بارداری///
  // List<SignsViewModel> _fetalSex = [
  //   SignsViewModel(
  //     title: 'دختر',
  //     isSelected: false,
  //     isLoading: false
  //   ),
  //   SignsViewModel(
  //       title: 'پسر',
  //       isSelected: false,
  //       isLoading: false
  //   ),
  //   SignsViewModel(
  //       title: 'دوقلو يا بيشتر',
  //       isSelected: false,
  //       isLoading: false
  //   ),
  // ];


  List<SignsViewModel> _physicalSigns = [
    SignsViewModel(
        title: 'ديابت',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'چربی',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'فشار خون',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'بيماری قلبی',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'حساسیت غذایی',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'حساسیت دارویی',
        isSelected: false,
        isLoading: false
    ),
  ];


  List<SignsViewModel> _pregnancyPhysicalSigns = [
    SignsViewModel(
        title: 'پر خوابی',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'کم خوابی',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'لكه بينی',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'تكرر ادرار',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'خستگی',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'اضافه وزن زياد',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'خارش پوست',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'گرگرفتگی',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'درد لگن',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'ورم پا',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'استراحت مطلق',
        isSelected: false,
        isLoading: false
    ),
  ];


  List<SignsViewModel> _pregnancyGastrointestinalSigns = [
    SignsViewModel(
        title: 'تهوع صبحگاهی',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'مسمومیت حاملگی',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'یبوست',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'هموروئيد',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'سوزش معده',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'پرخوری',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'دیابت بارداری',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'بی‌اشتهایی',
        isSelected: false,
        isLoading: false
    ),
    // SignsViewModel(
    //     title: 'پرخوری',
    //     isSelected: false,
    //     isLoading: false
    // ),
  ];


  List<SignsViewModel> _pregnancyPsychologySigns = [
    SignsViewModel(
        title: 'بي ميلي جنسی',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'اضطراب',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'افسردگی',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'احساس تنهايی',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'نوسان خلق',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'مشكلات زناشويی',
        isSelected: false,
        isLoading: false
    ),
  ];
  ///  نشانه های فاز بارداری///
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  /// نشانه های فاز شروع مادری///
  List<SignsViewModel> _breastfeedingBabySigns = [
    SignsViewModel(
        title: 'زردي نوزاد',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'كوليك',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'نفخ',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'كمبود وزن',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'حساسيت به پوشك',
        isSelected: false,
        isLoading: false
    ),
  ];

  List<SignsViewModel> _breastfeedingPhysicalSigns = [
    SignsViewModel(
        title: 'ترك پوستی',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'يبوست',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'هموروئيد',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'پرخوری',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'بي اشتهايی',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'كمر درد',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'اختلال خواب',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'ريزش مو',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'لكه های پوستی صورت',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'ضعف بدنی',
        isSelected: false,
        isLoading: false
    ),
  ];

  List<SignsViewModel> _breastfeedingMotherSigns = [
    SignsViewModel(
        title: 'تغذيه با شير مادر',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'تغذيه كمكی',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'حجم كم شیر',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'سفت شدن سينه',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'التهاب و زخم سينه',
        isSelected: false,
        isLoading: false
    ),
  ];

  List<SignsViewModel> _breastfeedingPsychologySigns = [
    SignsViewModel(
        title: 'افسردگی پس از زايمان',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'اضطراب',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'پرخاشگری',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'بي ميلی جنسی',
        isSelected: false,
        isLoading: false
    ),
    SignsViewModel(
        title: 'مشغول به كار',
        isSelected: false,
        isLoading: false
    ),
  ];

  List<ItemsToggle> specificationBabyModel = [
    ItemsToggle(title: "دختر", selected: false),
    ItemsToggle(title: "پسر", selected: false),
    ItemsToggle(title: "دوقلو یا بیشتر", selected: false),
  ];

  List<ItemsToggle> itemsBirthOrcycle = [
    ItemsToggle(
        title: "تاریخ زایمان",

        // icon: 'assets/images/ic_call.svg',
        selected: false),
    ItemsToggle(
        title: "اولین روز آخرین پریود",

        // icon: 'assets/images/ic_email.svg',
        selected: true),
  ];


  final isShowPeriodDialog = BehaviorSubject<bool>.seeded(false);
  final isShowExitDialog = BehaviorSubject<bool>.seeded(false);
  final dialogScale = BehaviorSubject<double>.seeded(0.0);
  // final valuePeriodDialog = BehaviorSubject<List>.seeded([]);
  final myChangePanel = BehaviorSubject<MyChangePanelModel>();
  final myChangeDialog = BehaviorSubject<MyChangePanelModel>();
  final isLoading = BehaviorSubject<bool>.seeded(false);
  final isLoadingDashBoard = BehaviorSubject<bool>.seeded(false);
  final isShowBackupDialog = BehaviorSubject<bool>.seeded(false);
  final isShowErrorDialog = BehaviorSubject<bool>.seeded(false);
  final valueDialogError = BehaviorSubject<String>.seeded('');
  final dateBackup = BehaviorSubject<String>.seeded('');
  final isShowNotifyDialog = BehaviorSubject<bool>.seeded(false);
  final isShowHelpDialog = BehaviorSubject<bool>.seeded(false);
  final isShowRegisterStatusDialog = BehaviorSubject<bool>.seeded(false);
  final isShowPeriodPanel = BehaviorSubject<bool>.seeded(false);
  final advertis = BehaviorSubject<AdvertiseViewModel>();
  final sugTopMessage = BehaviorSubject<DashBoardMessageAndNotifyViewModel>();
  final sugBottomMessages = BehaviorSubject<List<DashBoardMessageAndNotifyViewModel>>.seeded([]);
  final beforePeriodSings = BehaviorSubject<List<SignsViewModel>>.seeded([]);
  final duringPeriodSigns = BehaviorSubject<List<SignsViewModel>>.seeded([]);
  final mentalSigns = BehaviorSubject<List<SignsViewModel>>.seeded([]);
  final otherSigns = BehaviorSubject<List<SignsViewModel>>.seeded([]);
  final ovuSigns = BehaviorSubject<List<SignsViewModel>>.seeded([]);
  final pregnancyNumber = BehaviorSubject<PregnancyNumberViewModel>();
  final status = BehaviorSubject<int>.seeded(0);
  final fetalSex = BehaviorSubject<List<SignsViewModel>>.seeded([]);
  final physicalSigns = BehaviorSubject<List<SignsViewModel>>.seeded([]);
  final pregnancyPhysicalSigns = BehaviorSubject<List<SignsViewModel>>.seeded([]);
  final pregnancyGastrointestinalSign = BehaviorSubject<List<SignsViewModel>>.seeded([]);
  final pregnancyPsychologySigns  = BehaviorSubject<List<SignsViewModel>>.seeded([]);
  final isShowDialog = BehaviorSubject<bool>.seeded(false);
  final isLoadingButton = BehaviorSubject<bool>.seeded(false);
  final pregnancyDateSelected = BehaviorSubject<Jalali>();
  final pregnancyNoSelected = BehaviorSubject<int>.seeded(0);
  final pregnancyAborationSelected = BehaviorSubject<int>.seeded(0);
  final isDeliveryPregnancySelected = BehaviorSubject<bool>.seeded(false);
  final isShowChangeStatusDialog = BehaviorSubject<bool>.seeded(false);
  final typeChangeStatusDialog = BehaviorSubject<int>.seeded(0); /// 0 : period , 1 : pregnancy
  final isAborationDialog = BehaviorSubject<bool>.seeded(false);
  final childBirthDateSelected = BehaviorSubject<Jalali>();
  final childTypeSelected = BehaviorSubject<int>.seeded(0);
  final childNameSelected = BehaviorSubject<String>.seeded('');
  final childBirthTypeSelected = BehaviorSubject<int>.seeded(0);
  final breastfeedingBabySigns = BehaviorSubject<List<SignsViewModel>>.seeded([]);
  final breastfeedingPhysicalSigns = BehaviorSubject<List<SignsViewModel>>.seeded([]);
  final breastfeedingMotherSigns = BehaviorSubject<List<SignsViewModel>>.seeded([]);
  final breastfeedingPsychologySigns = BehaviorSubject<List<SignsViewModel>>.seeded([]);
  final breastfeedingNumbers = BehaviorSubject<BreastfeedingNumberModel>();
  final bioRhythms = BehaviorSubject<List<BioRhythmViewModel>>.seeded([]);
  final messageRandomBio = BehaviorSubject<BioRhythmMessagesModel>();
  final name = BehaviorSubject<String>.seeded('');
//  final isShowDialog = BehaviorSubject<bool>.seeded(false);
//  final valueCheckUpdateDialog = BehaviorSubject<List>.seeded([]);



  Stream<bool> get isShowPeriodDialogObserve => isShowPeriodDialog.stream;
  Stream<bool> get isShowExitDialogObserve => isShowExitDialog.stream;
  Stream<double> get dialogScaleObserve => dialogScale.stream;
  Stream<MyChangePanelModel> get myChangeDialogObserve => myChangeDialog.stream;
  Stream<MyChangePanelModel> get myChangePanelObserve => myChangePanel.stream;
  Stream<bool> get isLoadingObserve => isLoading.stream;
  Stream<bool> get isLoadingDashBoardObserve => isLoadingDashBoard.stream;
  Stream<bool> get isShowBackupDialogObserve => isShowBackupDialog.stream;
  Stream<bool> get iisShowErrorDialogObserve => isShowErrorDialog.stream;
  Stream<String> get valueDialogErrorObserve => valueDialogError.stream;
  Stream<String> get dateBackupObserve => dateBackup.stream;
  Stream<bool> get isShowNotifyDialogObserve => isShowNotifyDialog.stream;
  Stream<bool> get isShowHelpDialogObserve => isShowHelpDialog.stream;
  Stream<bool> get isShowRegisterStatusDialogObserve => isShowRegisterStatusDialog.stream;
  Stream<bool> get isShowPeriodPanelObserve => isShowPeriodPanel.stream;
  Stream<AdvertiseViewModel> get advertisObserve => advertis.stream;
  Stream<DashBoardMessageAndNotifyViewModel> get sugTopMessageObserve => sugTopMessage.stream;
  Stream<List<DashBoardMessageAndNotifyViewModel>> get sugBottomMessagesObserve => sugBottomMessages.stream;
  Stream<List<SignsViewModel>> get beforePeriodSingsObserve => beforePeriodSings.stream;
  Stream<List<SignsViewModel>> get duringPeriodSignsObserve => duringPeriodSigns.stream;
  Stream<List<SignsViewModel>> get mentalSignsObserve => mentalSigns.stream;
  Stream<List<SignsViewModel>> get otherSignsObserve => otherSigns.stream;
  Stream<List<SignsViewModel>> get ovuSignsObserve => ovuSigns.stream;
  Stream<PregnancyNumberViewModel> get pregnancyNumberObserve => pregnancyNumber.stream;
  Stream<int> get statusObserve => status.stream;
  Stream<List<SignsViewModel>> get fetalSexObserve=> fetalSex.stream;
  Stream<List<SignsViewModel>> get physicalSignsObserve=> physicalSigns.stream;
  Stream<List<SignsViewModel>> get pregnancyPhysicalSignsObserve=> pregnancyPhysicalSigns.stream;
  Stream<List<SignsViewModel>> get pregnancyGastrointestinalSignObserve=> pregnancyGastrointestinalSign.stream;
  Stream<List<SignsViewModel>> get pregnancyPsychologySignsObserve=> pregnancyPsychologySigns.stream;
  Stream<bool> get isShowDialogObserve => isShowDialog.stream;
  Stream<bool> get isLoadingButtonObserve => isLoadingButton.stream;
  Stream<Jalali> get pregnancyDateSelectedObserve => pregnancyDateSelected.stream;
  Stream<int> get pregnancyNoSelectedObserve => pregnancyNoSelected.stream;
  Stream<int> get pregnancyAborationSelectedObserve => pregnancyAborationSelected.stream;
  Stream<bool> get isDeliveryPregnancySelectedObserve => isDeliveryPregnancySelected.stream;
  Stream<bool> get isShowChangeStatusDialogObserve => isShowChangeStatusDialog.stream;
  Stream<int> get typeChangeStatusDialogObserve => typeChangeStatusDialog.stream;
  Stream<bool> get isAborationDialogObserve => isAborationDialog.stream;
  Stream<Jalali> get childBirthDateSelectedObserve => childBirthDateSelected.stream;
  Stream<int> get childTypeSelectedObserve => childTypeSelected.stream;
  Stream<String> get childNameSelectedObserve => childNameSelected.stream;
  Stream<int> get childBirthTypeSelectedObserve => childBirthTypeSelected.stream;
  Stream<List<SignsViewModel>> get breastfeedingBabySignsObserve => breastfeedingBabySigns.stream;
  Stream<List<SignsViewModel>> get breastfeedingPhysicalSignsObserve => breastfeedingPhysicalSigns.stream;
  Stream<List<SignsViewModel>> get breastfeedingMotherSignsObserve => breastfeedingMotherSigns.stream;
  Stream<List<SignsViewModel>> get breastfeedingPsychologySignsObserve => breastfeedingPsychologySigns.stream;
  Stream<BreastfeedingNumberModel> get breastfeedingNumbersObserve => breastfeedingNumbers.stream;
  Stream<List<BioRhythmViewModel>> get bioRhythmsObserve => bioRhythms.stream;
  Stream<BioRhythmMessagesModel> get messageRandomBioObserve => messageRandomBio.stream;
  Stream<String> get nameObserve => name.stream;


  late TextEditingController childNameController;
  late List<DashBoardMessageAndNotifyViewModel> listMessages = [];
  late List<CycleViewModel> defaultCycles = [];
  late CycleViewModel defaultLastCycle;


  /// Future<List<DashBoardAndNotifyMessagesParentLocalModel>>getParentDashBoardMessages()async{
  ///   List<DashBoardAndNotifyMessagesParentLocalModel> parentDashBoardMessages = await _dashboardModel.getParentDashBoardMessages();
  ///   return parentDashBoardMessages;
  /// }
  ///
  /// Future<List<DashBoardAndNotifyMessagesLocalModel>>getDashBoardMessages()async{
  ///   List<DashBoardAndNotifyMessagesLocalModel> dashBoardMessages = await _dashboardModel.getDashBoardMessages();
  ///   return dashBoardMessages;
  /// }


  initPanelController(){
    MyChangePanelModel _myChangeModel = MyChangePanelModel();
    _myChangeModel.setMode(6);
    // _myChangeModel.setDayMode(0);
    // _myChangeModel.setTitle('');
    if(!myChangePanel.isClosed){
      myChangePanel.sink.add(_myChangeModel);
    }
    panelController =  PanelController();
  }

  // showNotifyInstagram()async{
  //     var androidChannel = AndroidNotificationDetails(
  //       'instagram30' , 'channel_name' , 'channel_description',
  //       importance: Importance.Max,
  //       priority: Priority.Max,
  //       vibrationPattern: Int64List(1000),
  //       largeIcon: DrawableResourceAndroidBitmap('impo_icon'),
  //       icon: "not_icon",
  //       playSound: false,
  //       styleInformation: BigTextStyleInformation(''),
  //     );
  //
  //     var iosChannel = IOSNotificationDetails(
  //       presentSound: false,
  //     );
  //
  //     NotificationDetails platformChannel = NotificationDetails(androidChannel,iosChannel);
  //     await NotificationInit.getGlobal().getNotify().show(
  //         9999,
  //         "پشتیبان گیری",
  //         "ایمپویی عزیز همین الان از صفحه پروفایل، فرآیند پشتیبان گیری رو تکمیل کنید.و لطفاً بعد از تکمیل پشتیبان گیری، بطور منظم هر هفته گزینه پشتیبان گیری رو به روز کنید.",
  //         platformChannel,
  //         payload: 'normal'
  //     );
  // }

  // getAdsFromServer()async{
  //   if(!isLoadingDashBoard.isClosed){
  //     isLoadingDashBoard.sink.add(true);
  //   }
  //   var advertiseInfo = locator<AdvertiseModel>();
  //   if(advertiseInfo.advertises.isEmpty){
  //     RegisterParamViewModel register =  getRegisters();
  //     Map<String,dynamic> responseBody = await Http().sendRequest(
  //         womanUrl,
  //         'info/advertise',
  //         'GET',
  //         {
  //         },
  //         register.token
  //     );
  //     // print(responseBody);
  //     if(responseBody != null){
  //       var advertiseInfo = locator<AdvertiseModel>();
  //       if(responseBody['advertise'].length != 0){
  //         responseBody['advertise'].forEach((item){
  //           advertiseInfo.addAdvertise(item);
  //         });
  //         getAdvertise();
  //       }
  //     }
  //   }else{
  //     getAdvertise();
  //   }
  // }

  getAdvertise(){
    var advertiseInfo = locator<AdvertiseModel>();
    List<AdvertiseViewModel> allAds = advertiseInfo.advertises;
    List<AdvertiseViewModel> dashboardUpAds = [];
    AdvertiseViewModel? showAds;
    if(allAds.length != 0){
     for(int i=0 ; i<allAds.length ; i++){
       if(allAds[i].place == 0){
         dashboardUpAds.add(allAds[i]);
       }
     }
     if(dashboardUpAds.isNotEmpty){
       if(dashboardUpAds.length > 1){
         final _random =  Random();
         showAds = dashboardUpAds[_random.nextInt(dashboardUpAds.length)];

       }else{
         showAds = dashboardUpAds[0];
       }
     }

    }
    if(!advertis.isClosed && showAds != null){
      advertis.sink.add(showAds);
    }
  }

  checkPayloadNotify(payLoad){
    if(payLoad.toString().split('*')[0] != 'type'){
      Timer(Duration(milliseconds: 50),()async{
        animationControllerDialog.forward();
        isShowNotifyDialog.sink.add(true);
      });
    }
  }

  onPressCancelNotifyDialog()async{
    await animationControllerDialog.reverse();
    if(!isShowNotifyDialog.isClosed) {
      isShowNotifyDialog.sink.add(false);
    }
    Payload.getGlobal().setPayload('');
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

  List<CycleViewModel> getAllCirlse(){
    List<CycleViewModel> circles =  _dashboardModel.getAllCircles();
    return circles;
  }


//   checkDailyReminders()async{
//    List<DailyReminders> dailyReminders = await _dashboardModel.getDailyReminders();
//   // print('serverID${dailyReminders[24].serverId}');
//    if(dailyReminders == null){
//
//      for(int i=1 ; i<25 ; i++){
//        _dashboardModel.insertDailyRemindersToLocal(
//            {
//              'id' : i ,
//              'title' : 'لیوان $i',
//              'time' : "08:00",
//              'isSound' : 1,
//              'mode' : i == 1 ? 1 : 0,
//              'dayWeek' : '',
//              'isChange' : 0
//            }
//        );
//      }
//
//      for(int i=101 ; i<125 ; i++){
//        _dashboardModel.insertDailyRemindersToLocal(
//            {
//              'id' : i,
//              'title' : 'وقت یادگیری ${i-100}',
//              'time' : "18:00",
//              'isSound' : 1,
//              'mode' : i == 101 ? 1 : 0,
//              'dayWeek' : '',
//              'isChange' : 0
//            }
//        );
//      }
//
//      for(int i=201 ; i<225 ; i++){
//        _dashboardModel.insertDailyRemindersToLocal(
//            {
//              'id' : i,
//              'title' : 'قرص ${i-200}',
//              'time' : "08:00",
//              'isSound' : 1,
//              'mode' : i == 201 ? 1 : 0,
//              'dayWeek' : '',
//              'isChange' : 0
//            }
//        );
//      }
//
//      for(int i=301 ; i<325 ; i++){
//        _dashboardModel.insertDailyRemindersToLocal(
//            {
//              'id' : i,
//              'title' : 'میوه ${i-300}',
//              'time' : "11:00",
//              'isSound' : 1,
//              'mode' : i == 301 ? 1 : 0,
//              'dayWeek' : '',
//              'isChange' : 0
//            }
//        );
//      }
//
//      for(int i=401 ; i<425 ; i++){
//        _dashboardModel.insertDailyRemindersToLocal(
//            {
//              'id' : i,
//              'title' : 'زنگ ورزش ${i-400}',
//              'time' : "06:00",
//              'isSound' : 1,
//              'mode' : i == 401 ? 1 : 0,
//              'dayWeek' : '',
//              'isChange' : 0
//            }
//        );
//      }
//
//      for(int i=501 ; i<525 ; i++){
//        _dashboardModel.insertDailyRemindersToLocal(
//            {
//              'id' : i,
//              'title' : 'خوب بخوابی ${i-500}',
//              'time' : "23:00",
//              'isSound' : 1,
//              'mode' : i == 501 ? 1 : 0,
//              'dayWeek' : '',
//              'isChange' : 0
//            }
//        );
//      }
//
//      for(int i=601 ; i<625 ; i++){
//        _dashboardModel.insertDailyRemindersToLocal(
//            {
//              'id' : i,
//              'title' : 'بدون گوشی ${i-600}',
//              'time' : "12:00",
//              'isSound' : 1,
//              'mode' : i == 601 ? 1 : 0,
//              'dayWeek' : '',
//              'isChange' : 0
//            }
//        );
//      }
// //     for(int i = 0 ; i < 7 ; i++){
// //       _dashboardModel.insertDailyRemindersToLocal(
// //         {
// //           'title' : i == 0 ? 'نوشیدن آب' : i == 1 ? 'یادآور مطالعه' : i == 2 ? 'یادآور دارو' : i == 3 ? 'یادآور میوه' : i == 4 ? 'یادآور ورزش' : i == 5 ? 'یادآور خواب' : 'استفاده از موبایل',
// //           'time' : TimeOfDay.fromDateTime(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,12,00)).format(context).replaceAll('TimeOfDay', '').replaceAll('(', '').replaceAll(')', ''),
// //           'isSound' : 0,
// //           'isActive' : 0,
// //         }
// //       );
// //     }
//    }else{
//
//    }
//   }

  // getAlarm()async{
  //   List<DailyReminders> dailyReminders = await _dashboardModel.getDailyReminders();
  //
  //   print(dailyReminders[0].id);
  //   print(dailyReminders[0].mode);
  //   print(dailyReminders[130].title);
  //   print(dailyReminders[10].time);
  //
  // }


  void insertCircleToLocal(dynamic map,context){
    _dashboardModel.insertCircleToLocal(map);
    setCycleCalendar(context,updateBio: false);
  }


  RegisterParamViewModel getRegisters(){
    RegisterParamViewModel registerModel =  _dashboardModel.getRegisters();
    return registerModel;
  }


  checkTypeSigns(){
    isChangeDialogSign = false;
    int _status = _dashboardModel.getRegisters().status!;
    if(!status.isClosed){
      status.sink.add(_status);
    }
    if(_status == 1){
      generateModePeriodDays();
      initialSelectedSigns();
    }else if(_status == 2){
      initialSelectedPregnancySigns();
    }else if(_status == 3){
      initialSelectedBreastfeedingSigns();
    }
  }

  generateModePeriodDays()async{
    var cycleInfo = locator<CycleModel>();
    CycleViewModel circleModel = cycleInfo.cycle[cycleInfo.cycle.length - 1];
    int fertStartDays , fertEndDays;
    int currentToday = 0;
    DateTime today = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);

    DateTime startCircle = DateTime.parse(circleModel.periodStart!);
    DateTime endCircle = DateTime.parse(circleModel.circleEnd!);
    DateTime endPeriod = DateTime.parse(circleModel.periodEnd!);

    int  maxDays = MyDateTime().myDifferenceDays(startCircle,endCircle) + 1;

    int periodDay =  MyDateTime().myDifferenceDays(startCircle,endPeriod) + 1;

    if((maxDays - 18) <= periodDay){

      fertStartDays = periodDay +1;

      fertEndDays = maxDays - 10;

    }else{

      fertStartDays = maxDays - 18;

      fertEndDays = maxDays - 10;

    }


    currentToday = MyDateTime().myDifferenceDays(startCircle,today) + 1;


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
  }

  initialSelectedSigns(){
    var cycleInfo = locator<CycleModel>();
    CycleViewModel circleModel = cycleInfo.cycle[cycleInfo.cycle.length - 1];
     before = circleModel.before != '' ? json.decode(circleModel.before!) : [];
     after = circleModel.after != '' ? json.decode(circleModel.after!) : [];
     // ovu = circleModel.ovu != '' ? json.decode(circleModel.ovu) : [];
     ovu = circleModel.ovu != null ? circleModel.ovu != '' ? json.decode(circleModel.ovu!) : [] : [];
     mental = circleModel.mental != '' ? json.decode(circleModel.mental!) : [];
     other = circleModel.other != '' ? json.decode(circleModel.other!) : [];
    for (int i = 0; i < before.length; i++)
    {
      switch (before[i])
      {
        case 0:
          _beforePeriodSings[0].isSelected = true;
          break;
        case 1:
          _beforePeriodSings[1].isSelected = true;
          break;
        case 2:
          _beforePeriodSings[2].isSelected = true;
          break;
        case 3:
          _beforePeriodSings[3].isSelected = true;
          break;
        case 4:
          _beforePeriodSings[4].isSelected = true;
          break;
        case 5:
          _beforePeriodSings[5].isSelected = true;
          break;
        case 6:
          _beforePeriodSings[6].isSelected = true;
          break;
        case 7:
          _beforePeriodSings[7].isSelected = true;
          break;
        case 8:
          _beforePeriodSings[8].isSelected = true;
          break;
        case 9:
          _beforePeriodSings[9].isSelected = true;
          break;
      }
    }

    for (int i = 0; i < after.length; i++)
    {
      switch (after[i])
      {
        case 0:
          _duringPeriodSigns[0].isSelected = true;
          break;
        case 1:
          _duringPeriodSigns[1].isSelected = true;
          break;
        case 2:
          _duringPeriodSigns[2].isSelected = true;
          break;
        case 3:
          _duringPeriodSigns[3].isSelected = true;
          break;
        case 4:
          _duringPeriodSigns[4].isSelected = true;
          break;
        case 5:
          _duringPeriodSigns[5].isSelected = true;
          break;
        case 6:
          _duringPeriodSigns[6].isSelected = true;
          break;
        case 7:
          _duringPeriodSigns[7].isSelected = true;
          break;
        case 8:
          _duringPeriodSigns[8].isSelected = true;
          break;
      }
    }

     for (int i = 0; i < ovu.length; i++)
     {
       switch (ovu[i])
       {
         case 0:
           _ovuSigns[0].isSelected = true;
           break;
         case 1:
           _ovuSigns[1].isSelected = true;
           break;
         case 2:
           _ovuSigns[2].isSelected = true;
           break;
       }
     }

    for (int i = 0; i < mental.length; i++)
    {
      switch (mental[i])
      {
        case 0:
          _mentalSigns[0].isSelected = true;
          break;
        case 1:
          _mentalSigns[1].isSelected = true;
          break;
        case 2:
          _mentalSigns[2].isSelected = true;
          break;
        case 3:
          _mentalSigns[3].isSelected = true;
          break;
        case 4:
          _mentalSigns[4].isSelected = true;
          break;
        case 5:
          _mentalSigns[5].isSelected = true;
          break;
        case 6:
          _mentalSigns[6].isSelected = true;
          break;
      }
    }

    for (int i = 0; i < other.length; i++)
    {
      switch (other[i])
      {
        case 0:
          _otherSigns[0].isSelected = true;
          break;
        case 1:
          _otherSigns[1].isSelected = true;
          break;
        case 2:
          _otherSigns[2].isSelected = true;
          break;
        case 3:
          _otherSigns[3].isSelected = true;
          break;
        case 4:
          _otherSigns[4].isSelected = true;
          break;
      }
    }
    if (!beforePeriodSings.isClosed) {
      beforePeriodSings.sink.add(_beforePeriodSings);
    }

    if (!duringPeriodSigns.isClosed) {
      duringPeriodSigns.sink.add(_duringPeriodSigns);
    }
    if (!ovuSigns.isClosed) {
      ovuSigns.sink.add(_ovuSigns);
    }

    if (!mentalSigns.isClosed) {
      mentalSigns.sink.add(_mentalSigns);
    }

    if (!otherSigns.isClosed) {
      otherSigns.sink.add(_otherSigns);
    }
  }
  onPressWomanSigns(List<SignsViewModel> items,int index){
    isChangeDialogSign = true;
    if(items == _beforePeriodSings){
      _beforePeriodSings[index].isSelected = ! _beforePeriodSings[index].isSelected!;
    }else if(items == _duringPeriodSigns){
      _duringPeriodSigns[index].isSelected = ! _duringPeriodSigns[index].isSelected!;
    }else if(items == _ovuSigns){
      _ovuSigns[index].isSelected = ! _ovuSigns[index].isSelected!;
    }else if(items == _mentalSigns){
      _mentalSigns[index].isSelected = ! _mentalSigns[index].isSelected!;
    }else if(items == _otherSigns){
      _otherSigns[index].isSelected = ! _otherSigns[index].isSelected!;
    }
    if (!beforePeriodSings.isClosed) {
      beforePeriodSings.sink.add(_beforePeriodSings);
    }

    if (!duringPeriodSigns.isClosed) {
      duringPeriodSigns.sink.add(_duringPeriodSigns);
    }
    if (!ovuSigns.isClosed) {
      ovuSigns.sink.add(_ovuSigns);
    }

    if (!mentalSigns.isClosed) {
      mentalSigns.sink.add(_mentalSigns);
    }

    if (!otherSigns.isClosed) {
      otherSigns.sink.add(_otherSigns);
    }

  }
  saveWomanSigns(context,bool isDialog,bool shareExp){
    List<int> _beforePeriodSingsIndex = [];
    List<int> _duringPeriodSignsIndex = [];
    List<int> _ovuSignsIndex = [];
    List<int> _mentalSignsIndex = [];
    List<int> _otherSignsIndex = [];
    for(int i=0 ; i<_beforePeriodSings.length ; i++){
      if(_beforePeriodSings[i].isSelected!){
        _beforePeriodSingsIndex.add(i);
      }
    }
    for(int i=0 ; i<_duringPeriodSigns.length ; i++){
      if(_duringPeriodSigns[i].isSelected!){
        _duringPeriodSignsIndex.add(i);
      }
    }
    for(int i=0 ; i<_ovuSigns.length ; i++){
      if(_ovuSigns[i].isSelected!){
        _ovuSignsIndex.add(i);
      }
    }
    for(int i=0 ; i<_mentalSigns.length ; i++){
      if(_mentalSigns[i].isSelected!){
        _mentalSignsIndex.add(i);
      }
    }
    for(int i=0 ; i<_otherSigns.length ; i++){
      if(_otherSigns[i].isSelected!){
        _otherSignsIndex.add(i);
      }
    }

    CycleViewModel cycleViewModel = CycleViewModel(
      before: _beforePeriodSingsIndex.toString(),
      after: _duringPeriodSignsIndex.toString(),
      ovu: _ovuSignsIndex.toString(),
      mental: _mentalSignsIndex.toString(),
      other: _otherSignsIndex.toString()
    );

    int sign = GenerateDashboardAndNotifyMessages().getWomanSignUser(cycleViewModel);
    setCheckList(sign,context,isDialog,shareExp,cycleViewModel: cycleViewModel);
  }


   initialSelectedPregnancySigns(){
    PregnancySignsViewModel pregnancySigns = _dashboardModel.getPregnancySigns();
    // print(pregnancySigns.physicalPregnancy);

    // for(int i=0 ; i<3 ; i++){
    //   if(pregnancySigns.fetalSex.contains(i)){
    //       _fetalSex[i].isSelected = true;
    //   }
    // }
    for(int i=0 ; i<6; i++){
      if(pregnancySigns.physical!.contains(i)){
        _physicalSigns[i].isSelected = true;
      }
    }
    for(int i=0 ; i<11; i++){
      if(pregnancySigns.physicalPregnancy!.contains(i)){
        _pregnancyPhysicalSigns[i].isSelected = true;
      }
    }
    for(int i=0 ; i<8; i++){
      if(pregnancySigns.gastrointestinalPregnancy!.contains(i)){
        _pregnancyGastrointestinalSigns[i].isSelected = true;
      }
    }
    for(int i=0 ; i<6 ; i++){
      if(pregnancySigns.psychologyPregnancy!.contains(i)){
        _pregnancyPsychologySigns[i].isSelected = true;
      }
    }

    syncPregnancySingsWithView();

   }
   onPressPregnancySigns(List<SignsViewModel> items,int index){
     isChangeDialogSign = true;
    // if(items == _fetalSex){
    //   _fetalSex[index].isSelected = ! _fetalSex[index].isSelected;
    // }else
      if(items == _physicalSigns){
      _physicalSigns[index].isSelected = ! _physicalSigns[index].isSelected!;
    }else if(items == _pregnancyPhysicalSigns){
      _pregnancyPhysicalSigns[index].isSelected = ! _pregnancyPhysicalSigns[index].isSelected!;
    }else if(items == _pregnancyGastrointestinalSigns){
      _pregnancyGastrointestinalSigns[index].isSelected = ! _pregnancyGastrointestinalSigns[index].isSelected!;
    }else if(items == _pregnancyPsychologySigns){
      _pregnancyPsychologySigns[index].isSelected = ! _pregnancyPsychologySigns[index].isSelected!;
    }
    syncPregnancySingsWithView();

   }
   saveSignsPregnancy(context,bool isDialog,bool shareExp){
    List<int> _fetalSexIndex = [];
    List<int> _physicalSignsIndex = [];
    List<int> _pregnancyPhysicalSignsIndex = [];
    List<int> _pregnancyGastrointestinalSignsIndex = [];
    List<int> _pregnancyPsychologySignsIndex = [];
    // for(int i=0 ; i<_fetalSex.length ; i++){
    //   if(_fetalSex[i].isSelected){
    //     _fetalSexIndex.add(i);
    //   }
    // }
    for(int i=0 ; i<_physicalSigns.length ; i++){
      if(_physicalSigns[i].isSelected!){
        _physicalSignsIndex.add(i);
      }
    }
    for(int i=0 ; i<_pregnancyPhysicalSigns.length ; i++){
      if(_pregnancyPhysicalSigns[i].isSelected!){
        _pregnancyPhysicalSignsIndex.add(i);
      }
    }
    for(int i=0 ; i<_pregnancyGastrointestinalSigns.length ; i++){
      if(_pregnancyGastrointestinalSigns[i].isSelected!){
        _pregnancyGastrointestinalSignsIndex.add(i);
      }
    }
    for(int i=0 ; i<_pregnancyPsychologySigns.length ; i++){
      if(_pregnancyPsychologySigns[i].isSelected!){
        _pregnancyPsychologySignsIndex.add(i);
      }
    }

    PregnancySignsViewModel pregnancySignsViewModel = PregnancySignsViewModel(
        fetalSex: _fetalSexIndex,
        physical: _physicalSignsIndex,
        physicalPregnancy: _pregnancyPhysicalSignsIndex,
        gastrointestinalPregnancy: _pregnancyGastrointestinalSignsIndex,
        psychologyPregnancy: _pregnancyPsychologySignsIndex
    );
    int sign = GenerateDashboardAndNotifyMessages().getPregnancyWomanSignUser(pregnancySignsViewModel: pregnancySignsViewModel);
    setCheckList(sign,context,isDialog,shareExp,pregnancySignsViewModel: pregnancySignsViewModel);
   }
   syncPregnancySingsWithView(){
     // if(!fetalSex.isClosed){
     //   fetalSex.sink.add(_fetalSex);
     // }
     if(!physicalSigns.isClosed){
       physicalSigns.sink.add(_physicalSigns);
     }
     if(!pregnancyPhysicalSigns.isClosed){
       pregnancyPhysicalSigns.sink.add(_pregnancyPhysicalSigns);
     }
     if(!pregnancyGastrointestinalSign.isClosed){
       pregnancyGastrointestinalSign.sink.add(_pregnancyGastrointestinalSigns);
     }
     if(!pregnancyPsychologySigns.isClosed){
       pregnancyPsychologySigns.sink.add(_pregnancyPsychologySigns);
     }
   }


  initialSelectedBreastfeedingSigns(){
    BreastfeedingSignsViewModel breastfeedingSigns = _dashboardModel.getBreastfeedingSigns();

    for(int i=0 ; i<5 ; i++){
      if(breastfeedingSigns.babySigns!.contains(i)){
        _breastfeedingBabySigns[i].isSelected = true;
      }
    }
    for(int i=0 ; i<10 ; i++){
      if(breastfeedingSigns.physical!.contains(i)){
        _breastfeedingPhysicalSigns[i].isSelected = true;
      }
    }
    for(int i=0 ; i<5 ; i++){
      if(breastfeedingSigns.breastfeedingMother!.contains(i)){
        _breastfeedingMotherSigns[i].isSelected = true;
      }
    }
    for(int i=0 ; i<5 ; i++){
      if(breastfeedingSigns.psychology!.contains(i)){
        _breastfeedingPsychologySigns[i].isSelected = true;
      }
    }
    syncBreastfeedingSingsWithView();

  }
  onPressBreastfeedingSigns(List<SignsViewModel> items,int index){
    isChangeDialogSign = true;
    if(items == _breastfeedingBabySigns){
      _breastfeedingBabySigns[index].isSelected = ! _breastfeedingBabySigns[index].isSelected!;
    }else if(items == _breastfeedingPhysicalSigns){
      _breastfeedingPhysicalSigns[index].isSelected = ! _breastfeedingPhysicalSigns[index].isSelected!;
    }else if(items == _breastfeedingMotherSigns){
      _breastfeedingMotherSigns[index].isSelected = ! _breastfeedingMotherSigns[index].isSelected!;
    }else if(items == _breastfeedingPsychologySigns){
      _breastfeedingPsychologySigns[index].isSelected = ! _breastfeedingPsychologySigns[index].isSelected!;
    }
    syncBreastfeedingSingsWithView();

  }
  saveSignsBreastfeeding(context,bool isDialog,bool shareExp){
    List<int> _breastfeedingBabySignsIndex = [];
    List<int> _breastfeedingPhysicalSignsIndex = [];
    List<int> _breastfeedingMotherSignsIndex = [];
    List<int> _breastfeedingPsychologySignsIndex = [];

    for(int i=0 ; i<_breastfeedingBabySigns.length ; i++){
      if(_breastfeedingBabySigns[i].isSelected!){
        _breastfeedingBabySignsIndex.add(i);
      }
    }
    for(int i=0 ; i<_breastfeedingPhysicalSigns.length ; i++){
      if(_breastfeedingPhysicalSigns[i].isSelected!){
        _breastfeedingPhysicalSignsIndex.add(i);
      }
    }
    for(int i=0 ; i<_breastfeedingMotherSigns.length ; i++){
      if(_breastfeedingMotherSigns[i].isSelected!){
        _breastfeedingMotherSignsIndex.add(i);
      }
    }
    for(int i=0 ; i<_breastfeedingPsychologySigns.length ; i++){
      if(_breastfeedingPsychologySigns[i].isSelected!){
        _breastfeedingPsychologySignsIndex.add(i);
      }
    }


    BreastfeedingSignsViewModel breastfeedingSignsViewModel = BreastfeedingSignsViewModel(
        babySigns: _breastfeedingBabySignsIndex,
        physical: _breastfeedingPhysicalSignsIndex,
        breastfeedingMother: _breastfeedingMotherSignsIndex,
        psychology: _breastfeedingPsychologySignsIndex
    );
    int sign = GenerateDashboardAndNotifyMessages().getBreastfeedingWomanSignUser(breastfeedingSignsViewModel: breastfeedingSignsViewModel);
    setCheckList(sign,context,isDialog,shareExp,breastfeedingSignsViewModel: breastfeedingSignsViewModel);
  }
  syncBreastfeedingSingsWithView(){
    if(!breastfeedingBabySigns.isClosed){
      breastfeedingBabySigns.sink.add(_breastfeedingBabySigns);
    }
    if(!breastfeedingPhysicalSigns.isClosed){
      breastfeedingPhysicalSigns.sink.add(_breastfeedingPhysicalSigns);
    }
    if(!breastfeedingMotherSigns.isClosed){
      breastfeedingMotherSigns.sink.add(_breastfeedingMotherSigns);
    }
    if(!breastfeedingPsychologySigns.isClosed){
      breastfeedingPsychologySigns.sink.add(_breastfeedingPsychologySigns);
    }
  }

  Future<bool> setCheckList(int sign,context,bool isDialog,bool shareExp,
      {CycleViewModel? cycleViewModel,
        PregnancySignsViewModel? pregnancySignsViewModel,
        BreastfeedingSignsViewModel? breastfeedingSignsViewModel}) async {
    if(isDialog){
      if(!isLoadingButton.isClosed){
        isLoadingButton.sink.add(true);
      }
    }else{
      if(!isLoading.isClosed){
        isLoading.sink.add(true);
      }
    }
    // print('signnnn : $sign');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print('${prefs.getString('infoController')}');
    var registerInfo = locator<RegisterParamModel>();
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        '${prefs.getString('infoController')}/checkList',
        'POST',
        {
          "sign": sign
        },
        registerInfo.register.token!);
    // print('setCheckList : $responseBody');

    if (responseBody != null) {
      if (responseBody['isValid']) {
        bottomMessageDashboard.clear();
         await GenerateDashboardAndNotifyMessages().checkForNotificationMessage();
        if(registerInfo.register.status == 1){
          updateWomanSigns(cycleViewModel!);
        }else if(registerInfo.register.status == 2){
          updatePregnancySigns(pregnancySignsViewModel!);
        }else if(registerInfo.register.status == 3){
          updateBreastfeedingSigns(breastfeedingSignsViewModel!);
        }
         isChangeDialogSign = false;
        if(isDialog){
          if(!isLoadingButton.isClosed){
            isLoadingButton.sink.add(false);
          }
        }else{
          if(!isLoading.isClosed){
            isLoading.sink.add(false);
          }
        }
        // if(isDialog){
          gotoHome(context,shareExp);
        // }else{
        //   showToast(context, 'تغییرات با موفقیت ذخیره شد');
        // }
      } else {
        if(isDialog){
          if(!isLoadingButton.isClosed){
            isLoadingButton.sink.add(false);
          }
        }else{
          if(!isLoading.isClosed){
            isLoading.sink.add(false);
          }
        }
        showToast(context, 'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
      }
    } else {
      if(isDialog){
        if(!isLoadingButton.isClosed){
          isLoadingButton.sink.add(false);
        }
      }else{
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }
      }
      showToast(context, 'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }

    return true;
  }

  updateWomanSigns(CycleViewModel cycleViewModel){
    var cycleInfo = locator<CycleModel>();
    cycleInfo.updateCycle(
        cycleInfo.cycle.length - 1,
        CycleViewModel.fromJson({
          'periodStartDate': cycleInfo.cycle[cycleInfo.cycle.length-1].periodStart,
          'periodEndDate': cycleInfo.cycle[cycleInfo.cycle.length-1].periodEnd,
          'cycleEndDate': cycleInfo.cycle[cycleInfo.cycle.length-1].circleEnd,
          'status' : 0,
          'before': cycleViewModel.before,
          'after': cycleViewModel.after,
          'ovu': cycleViewModel.ovu,
          'mental': cycleViewModel.mental,
          'other': cycleViewModel.other
        }));
  }

  updatePregnancySigns(PregnancySignsViewModel pregnancySignsViewModel){
    var pregnancySignInfo = locator<PregnancySignsModel>();
    pregnancySignInfo.setFetalSex(pregnancySignsViewModel.fetalSex!);
    pregnancySignInfo.setPhysical(pregnancySignsViewModel.physical!);
    pregnancySignInfo.setPhysicalPregnancy(pregnancySignsViewModel.physicalPregnancy!);
    pregnancySignInfo.setGastrointestinalPregnancy(pregnancySignsViewModel.gastrointestinalPregnancy!);
    pregnancySignInfo.setPsychologyPregnancy(pregnancySignsViewModel.psychologyPregnancy!);

  }

  updateBreastfeedingSigns(BreastfeedingSignsViewModel breastfeedingSignsViewModel){
    var breastfeedingSignInfo = locator<BreastfeedingSignsModel>();
    breastfeedingSignInfo.setBabySigns(breastfeedingSignsViewModel.babySigns!);
    breastfeedingSignInfo.setPhysical(breastfeedingSignsViewModel.physical!);
    breastfeedingSignInfo.setBreastfeedingMother(breastfeedingSignsViewModel.breastfeedingMother!);
    breastfeedingSignInfo.setPsychology(breastfeedingSignsViewModel.psychology!);

  }

  backSignScreen(context){
    if(isChangeDialogSign){
      showDialog();
    }else{
      Navigator.pop(context);
    }
  }

  showDialog(){
      Timer(Duration(milliseconds: 50),()async{
        animationControllerDialog.forward();
        isShowDialog.sink.add(true);
      });
  }

  closeDialog(context)async{
    await animationControllerDialog.reverse();
    if(!isShowDialog.isClosed) {
      isShowDialog.sink.add(false);
    }
    Navigator.pop(context);
  }

  gotoHome(context,bool shareExp){
    if(shareExp){
      Navigator.pop(context);
    }else{
      Navigator.pushReplacement(context,
          PageTransition(
              settings: RouteSettings(name: "/Page1"),
              type: PageTransitionType.topToBottom,
              child:  FeatureDiscovery(
                  recordStepsInSharedPreferences: true,
                  child: Home(
                    indexTab: 4,
                    register: true,
                    isChangeStatus: false,
                  )
              )
          )
      );
    }
  }

  // Future<bool> onPressSigns(List item,index)async{
  //
  //
  //   if(item == beforePeriodSings){
  //
  //       if(!before.contains(index)){
  //         before.add(index);
  //       }else{
  //         before.remove(index);
  //       }
  //
  //     String strBefore = before.toString();
  //    // print(strBefore);
  //
  //     await _dashboardModel.updateSingns(
  //       {
  //         'before' : strBefore
  //       }
  //     );
  //
  //
  //
  //   }
  //
  //
  //   if(item == duringPeriodSigns){
  //     if(!after.contains(index)){
  //       after.add(index);
  //     }else{
  //       after.remove(index);
  //     }
  //
  //     String strAfter = after.toString();
  //    // print(strAfter);
  //
  //     await _dashboardModel.updateSingns(
  //         {
  //           'after' : strAfter
  //         }
  //     );
  //
  //   }
  //
  //   if(item == ovuSigns){
  //     if(!ovu.contains(index)){
  //       ovu.add(index);
  //     }else{
  //       ovu.remove(index);
  //     }
  //
  //     String strOvu = ovu.toString();
  //     // print(strAfter);
  //
  //     await _dashboardModel.updateSingns(
  //         {
  //           'ovu' : strOvu
  //         }
  //     );
  //
  //   }
  //
  //
  //   if(item == mentalSigns){
  //     if(!mental.contains(index)){
  //       mental.add(index);
  //     }else{
  //       mental.remove(index);
  //     }
  //     String strMental = mental.toString();
  //    // print(strMental);
  //
  //     await _dashboardModel.updateSingns(
  //         {
  //           'mental' : strMental
  //         }
  //     );
  //
  //   }
  //
  //
  //
  //   if(item == otherSigns){
  //     if(!other.contains(index)){
  //       other.add(index);
  //     }else{
  //       other.remove(index);
  //     }
  //
  //     String strOther = other.toString();
  //     // print(strOther);
  //
  //     await _dashboardModel.updateSingns(
  //         {
  //           'other' : strOther
  //         }
  //     );
  //
  //   }
  //
  //   return true;
  //
  // }



  showMyStatusPanel(context,DashboardPresenter dashboardPresenter,CalenderPresenter calenderPresenter){
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        context: context,
        builder: (context) {
          return MyStatusWidget(
            calenderPresenter: calenderPresenter,
            dashboardPresenter: dashboardPresenter,
          );
        });
   // panelController.open();
  }


  periodMyChangePanel(mode,listCirclesItem,int dayMode)async{
    DateTime now =DateTime.now();
    if(listCirclesItem != null){
      lastCircle = listCirclesItem[listCirclesItem.length-1];
      if(listCirclesItem.length > 1){
        oneOfLastCircle = listCirclesItem[listCirclesItem.length-2];
      }
    }
    if(mode == 2 || mode == 5){
      MyChangePanelModel _myChangeModel = MyChangePanelModel();
      if(mode == 2){
        _myChangeModel.setTitle('ایمپویی عزیز،\n آیا مطمئنی که زودتر از موعد\n پریودت تموم شد ؟');
        _myChangeModel.setMode(mode);
        _myChangeModel.setDayMode(dayMode);
        myChangePanel.sink.add(_myChangeModel);
        // valuePeriodDialog.sink.add(_vlaue);
      }else if(mode == 5){
        _myChangeModel.setTitle('ایمپویی عزیز،\n آیا مطمئنی که هنوز پریود هستی؟');
        _myChangeModel.setMode(mode);
        _myChangeModel.setDayMode(dayMode);
        myChangePanel.sink.add(_myChangeModel);
        // valuePeriodDialog.sink.add(_vlaue);
      }
      // if(!isShowPeriodPanel.isClosed){
      //   isShowPeriodPanel.sink.add(true);
      // }
      // panelController.open();
    }else{
      // Timer(Duration(milliseconds: 50),()async{
      //   animationControllerDialog.forward();
      //   isShowPeriodDialog.sink.add(true);
      // });
      MyChangePanelModel _myChangeModel = MyChangePanelModel();
      if(mode == 0){
        _myChangeModel.setTitle('ایمپویی عزیز،\n آیا مطمئنی پریود شدی؟');
        _myChangeModel.setMode(mode);
        _myChangeModel.setDayMode(dayMode);
        myChangePanel.sink.add(_myChangeModel);
      }else if(mode == 1){
//      int countCurrent = DateGenerator.GetDaysBetween(mLocalData.getAllCircleRealm().get(mLocalData.getAllCircleRealm().size() -2).getPeriodStartDate(),DateGenerator.GetCurrentDate()) + 1;
        int countCurrent = (MyDateTime().myDifferenceDays(DateTime.parse(oneOfLastCircle.getPeriodStart()),DateTime(now.year,now.month,now.day))) + 1;
        // print(oneOfLastCircle.getPeriodStart());
        _myChangeModel.setTitle('ایمپویی عزیز،\n آیا مطمئنی که بعد از $countCurrent روز\n هنوز پریود نشدی؟');
        _myChangeModel.setMode(mode);
        _myChangeModel.setDayMode(dayMode);
        myChangePanel.sink.add(_myChangeModel);
      }else if(mode == 3){
        _myChangeModel.setTitle('ایمپویی عزیز،\n آیا مطمئنی که زودتر از موعد\n پریودت تموم شد ؟');
        _myChangeModel.setMode(mode);
        _myChangeModel.setDayMode(dayMode);
        myChangePanel.sink.add(_myChangeModel);
      }else if(mode == 4){
        _myChangeModel.setTitle('ایمپویی عزیز،\n آیا مطمئنی که هنوز پریود هستی؟');
        _myChangeModel.setMode(mode);
        _myChangeModel.setDayMode(dayMode);
        myChangePanel.sink.add(_myChangeModel);
      }else{
      }
    }
  }
  onPressShowPeriodDialog(mode,listCirclesItem,int dayMode)async{
    Timer(Duration(milliseconds: 50),()async{
      animationControllerDialog.forward();
      isShowPeriodDialog.sink.add(true);
    });
    DateTime now =DateTime.now();
    if(listCirclesItem != null){
      lastCircle = listCirclesItem[listCirclesItem.length-1];
      if(listCirclesItem.length > 1){
        oneOfLastCircle = listCirclesItem[listCirclesItem.length-2];
      }
    }
    if(mode == 2 || mode == 5){
      MyChangePanelModel _myChangeModel = MyChangePanelModel();
      if(mode == 2){
        _myChangeModel.setTitle('ایمپویی عزیز،\n آیا مطمئنی که زودتر از موعد\n پریودت تموم شد ؟');
        _myChangeModel.setMode(mode);
        _myChangeModel.setDayMode(dayMode);
        myChangePanel.sink.add(_myChangeModel);
        myChangeDialog.sink.add(_myChangeModel);
        // valuePeriodDialog.sink.add(_vlaue);
      }else if(mode == 5){
        _myChangeModel.setTitle('ایمپویی عزیز،\n آیا مطمئنی که هنوز پریود هستی؟');
        _myChangeModel.setMode(mode);
        _myChangeModel.setDayMode(dayMode);
        myChangeDialog.sink.add(_myChangeModel);
        myChangePanel.sink.add(_myChangeModel);
        // valuePeriodDialog.sink.add(_vlaue);
      }
      if(!isShowPeriodPanel.isClosed){
        isShowPeriodPanel.sink.add(true);
      }
      // panelController.open();
    }else{
      Timer(Duration(milliseconds: 50),()async{
        animationControllerDialog.forward();
        isShowPeriodDialog.sink.add(true);
      });
      MyChangePanelModel _myChangeModel = MyChangePanelModel();
      if(mode == 0){
        _myChangeModel.setTitle('ایمپویی عزیز،\n آیا مطمئنی پریود شدی؟');
        _myChangeModel.setMode(mode);
        _myChangeModel.setDayMode(dayMode);
        myChangeDialog.sink.add(_myChangeModel);
      }else if(mode == 1){
//      int countCurrent = DateGenerator.GetDaysBetween(mLocalData.getAllCircleRealm().get(mLocalData.getAllCircleRealm().size() -2).getPeriodStartDate(),DateGenerator.GetCurrentDate()) + 1;
        int countCurrent = (MyDateTime().myDifferenceDays(DateTime.parse(oneOfLastCircle.getPeriodStart()),DateTime(now.year,now.month,now.day))) + 1;
        // print(oneOfLastCircle.getPeriodStart());
        _myChangeModel.setTitle('ایمپویی عزیز،\n آیا مطمئنی که بعد از $countCurrent روز\n هنوز پریود نشدی؟');
        _myChangeModel.setMode(mode);
        _myChangeModel.setDayMode(dayMode);
        myChangeDialog.sink.add(_myChangeModel);
      }else if(mode == 3){
        _myChangeModel.setTitle('ایمپویی عزیز،\n آیا مطمئنی که زودتر از موعد\n پریودت تموم شد ؟');
        _myChangeModel.setMode(mode);
        _myChangeModel.setDayMode(dayMode);
        myChangeDialog.sink.add(_myChangeModel);
      }else if(mode == 4){
        _myChangeModel.setTitle('ایمپویی عزیز،\n آیا مطمئنی که هنوز پریود هستی؟');
        _myChangeModel.setMode(mode);
        _myChangeModel.setDayMode(dayMode);
        myChangeDialog.sink.add(_myChangeModel);
      }
    }

  }

  onPressCancelPanelPeriod(){
    if(!isShowPeriodPanel.isClosed){
      isShowPeriodPanel.sink.add(false);
    }
  }

  onPressCancelPeriodDialog()async{
    await animationControllerDialog.reverse();
    if(!isShowPeriodDialog.isClosed){
      isShowPeriodDialog.sink.add(false);
    }
  }

  onPressBtnImPeriod(context)  {
    if (!isLoading.isClosed) {
      isLoading.sink.add(true);
    }
    var cycleInfo = locator<CycleModel>();
    setDefaultCycle();

    CycleViewModel lastCycle = cycleInfo.cycle[cycleInfo.cycle.length - 1];
    DateTime today = DateTime.now();
    DateTime yesterDay = DateTime(today.year, today.month, today.day - 1);

    cycleInfo.updateCycle(
        cycleInfo.cycle.length - 1,
        CycleViewModel.fromJson({
          'periodStartDate': lastCycle.periodStart,
          'periodEndDate': lastCycle.periodEnd,
          'cycleEndDate': yesterDay.toString(),
          'status' : 0,
          'before': lastCycle.before,
          'after': lastCycle.after,
          'mental': lastCycle.mental,
          'other': lastCycle.other
        }));
    // await _dashboardModel.updateCircle(
    //     {
    //       'isSavedToServer' : 0,
    //       'circleEnd' : yesterDay.toString()
    //     },
    //     lastCircle.id
    // );

    setCycleCalendar(context, typeSendNotifyForPartner : 1);
  }

  onPressBtnNotPeriod(context) {
    if (!isLoading.isClosed) {
      isLoading.sink.add(true);
    }
    var cycleInfo = locator<CycleModel>();
    setDefaultCycle();

    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    // await _dashboardModel.removeLastCircles('Circles', circles[circles.length-1].getId());
    cycleInfo.removeCycle(cycleInfo.cycle.length - 1);

    List<CycleViewModel> newCircles = cycleInfo.cycle;
    cycleInfo.updateCycle(
        newCircles.length - 1,
        CycleViewModel.fromJson({
          'periodStartDate': newCircles[newCircles.length - 1].periodStart,
          'periodEndDate': newCircles[newCircles.length - 1].periodEnd,
          'cycleEndDate': today.toString(),
          'status' : 0,
          'before': newCircles[newCircles.length - 1].before,
          'after': newCircles[newCircles.length - 1].after,
          'mental': newCircles[newCircles.length - 1].mental,
          'other': newCircles[newCircles.length - 1].other
        }));

    // await _dashboardModel.updateCircle(
    //     {
    //       'isSavedToServer' : 0,
    //       'circleEnd' : today.toString()
    //     },
    //     newLastCircles[newLastCircles.length-1].id
    // );

    setCycleCalendar(context, typeSendNotifyForPartner : 0);
  }

  onPressBtnKhonrizi(context, mode) {
    if (!isLoading.isClosed) {
      isLoading.sink.add(true);
    }
    var cycleInfo = locator<CycleModel>();
    CycleViewModel lastCycle = cycleInfo.cycle[cycleInfo.cycle.length - 1];
    setDefaultCycle();

    DateTime now = DateTime.now();

    cycleInfo.updateCycle(
        cycleInfo.cycle.length - 1,
        CycleViewModel.fromJson({
          'periodStartDate': lastCycle.periodStart,
          'periodEndDate': mode == 4
              ? DateTime(now.year, now.month, now.day).toString()
              : DateTime(now.year, now.month, now.day - 1).toString(),
          'cycleEndDate': lastCycle.circleEnd.toString(),
          'status' : 0,
          'before': lastCycle.before,
          'after': lastCycle.after,
          'mental': lastCycle.mental,
          'other': lastCycle.other
        }));

    // await _dashboardModel.updateCircle(
    //     {
    //       'isSavedToServer' : 0,
    //       'periodEnd' : mode == 4 ? DateTime(now.year,now.month,now.day).toString() : DateTime(now.year,now.month,now.day - 1).toString()
    //     },
    //     lastCircle.id
    // );
    setCycleCalendar(context, typeSendNotifyForPartner : 10);
  }

  Future<bool> setCycleCalendar(context,{int? typeSendNotifyForPartner,bool updateBio  = true}) async {
    var registerInfo = locator<RegisterParamModel>();
    var cycleInfo = locator<CycleModel>();
    CirclesSendServerMode circlesSendServerMode = CirclesSendServerMode();

    if (cycleInfo.cycle.length != 0) {
      circlesSendServerMode = CirclesSendServerMode.fromJson(cycleInfo.cycle);
    }
    // print(circlesSendServerMode.cycleInfos);
    // print('aaaa');
    if (circlesSendServerMode.cycleInfos != null) {
      if (circlesSendServerMode.cycleInfos!.length != 0) {
        Map<String,dynamic>? responseBody = await Http().sendRequest(
            womanUrl,
            'info/setcycleCalender',
            'POST',
            {"cycles": circlesSendServerMode.cycleInfos},
            registerInfo.register.token!);

        //print('setCycleCalender : $responseBody');
        if (responseBody != null) {
          if (responseBody['isValid']) {
            await GenerateDashboardAndNotifyMessages().checkForNotificationMessage();
            SaveDataOfflineMode().saveCycles();
            if(updateBio){
              await updateBioRhythm(responseBody);
            }
            await updateAdvertise(responseBody);
            if(typeSendNotifyForPartner != null){
              if (typeSendNotifyForPartner == 10) {
                isChangeDialogSettingScreens = false;
                bottomMessageDashboard.clear();
                if (!isLoading.isClosed) {
                  isLoading.sink.add(false);
                }
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: BlankScreen(
                          indexTab: 4,
                        )));
              } else {
                sendNotifyCycle(typeSendNotifyForPartner,context);
              }
            }
          } else {
            if(typeSendNotifyForPartner != null){
              returnToDefaultCycle();
              if (!isLoading.isClosed) {
                isLoading.sink.add(false);
              }
              showToast(context, 'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
            }
          }
        } else {
          if(typeSendNotifyForPartner != null){
            returnToDefaultCycle();
            if (!isLoading.isClosed) {
              isLoading.sink.add(false);
            }
            showToast(context, 'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
          }
        }
      } else {
        if(typeSendNotifyForPartner != null){
          returnToDefaultCycle();
          if (!isLoading.isClosed) {
            isLoading.sink.add(false);
          }
          showToast(context, 'امکان تغییر دوره وجود ندارد');
        }
      }
    } else {
      if(typeSendNotifyForPartner != null){
        returnToDefaultCycle();
        if (!isLoading.isClosed) {
          isLoading.sink.add(false);
        }
        showToast(context, 'امکان تغییر دوره وجود ندارد');
      }
    }

    return true;
  }

  Future<bool> updateBioRhythm(bioRythm)async{
     BioViewModel bioRhythmModel;
    // List<BioRhythmMessagesModel> biorhythmMessages = [];
    // print('aaaaaaaaaaaaaaaaaaaa');
    // print(bioRythm['bioRythm']);
    //bioRhythm
    bioRhythmModel =  BioViewModel.fromJson(bioRythm['bioRythm']);


    if(bioRhythmModel != null){

      _dashboardModel.addAllBio(bioRythm['bioRythm']);
    }


    allRandomMessages.clear();
    viewBioRhythms.clear();
    return true;
  }

  Future<bool> updateAdvertise(advertise)async{
    var advertiseInfo = locator<AdvertiseModel>();
    advertiseInfo.advertises.clear();
    if(advertise['advertise']['advertise'].length != 0){
      advertise['advertise']['advertise'].forEach((item){
        advertiseInfo.addAdvertise(item);
      });
    }
    return true;
  }

  sendNotifyCycle(type, context) async {
    var registerInfo = locator<RegisterParamModel>();
    Map<String,dynamic>? responseBody = await Http().sendRequest(womanUrl, 'info/notifycycle',
        'POST', {'type': type}, registerInfo.register.token!);
    // print('notifycycle :$responseBody');
    if (responseBody != null) {
      if (responseBody['valid']) {
        if (!isLoading.isClosed) {
          isLoading.sink.add(false);
        }
        bottomMessageDashboard.clear();
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: BlankScreen(
                  indexTab: 4,
                )));
      } else {
        returnToDefaultCycle();
        if (!isLoading.isClosed) {
          isLoading.sink.add(false);
        }
        showToast(context,
            'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
      }
    } else {
      returnToDefaultCycle();
      if (!isLoading.isClosed) {
        isLoading.sink.add(false);
      }
      showToast(context,
          'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }
  }

  setDefaultCycle(){
    defaultCycles.clear();
    var cycleInfo = locator<CycleModel>();
    for (int i = 0; i < cycleInfo.cycle.length; i++) {
      defaultCycles.add(CycleViewModel.fromJson({
        'periodStartDate': cycleInfo.cycle[i].periodStart,
        'periodEndDate': cycleInfo.cycle[i].periodEnd,
        'cycleEndDate': cycleInfo.cycle[i].circleEnd,
        'status' : cycleInfo.cycle[i].status,
        'before': cycleInfo.cycle[i].before,
        'after': cycleInfo.cycle[i].after,
        'mental': cycleInfo.cycle[i].mental,
        'other': cycleInfo.cycle[i].other,
        'ovu' : cycleInfo.cycle[i].ovu
      }));
    }
  }

  returnToDefaultCycle() {
    var cycleInfo = locator<CycleModel>();
    // print(cycleInfo.cycle.length);
    cycleInfo.removeAllCycles();
    for (int i = 0; i < defaultCycles.length; i++) {
      cycleInfo.addCycle({
        'periodStartDate': defaultCycles[i].periodStart,
        'periodEndDate': defaultCycles[i].periodEnd,
        'cycleEndDate': defaultCycles[i].circleEnd,
        'status' : defaultCycles[i].status,
        'before': defaultCycles[i].before,
        'after': defaultCycles[i].after,
        'mental': defaultCycles[i].mental,
        'other': defaultCycles[i].other
      });
    }
  }


  // pregnancyMyChangePanel(){
  //
  // }
  //
  // breastfeedingMyChangePanel(){
  //
  // }

  onPressCancelChangeStatusDialog()async{
    await animationControllerDialog.reverse();
    if(!isShowChangeStatusDialog.isClosed){
      isShowChangeStatusDialog.sink.add(false);
    }
  }

  showChangeStatusDialog(int type,context){
    /// 0 : period , 1 : pregnancy
    if(!typeChangeStatusDialog.isClosed){
      typeChangeStatusDialog.sink.add(type);
    }
    Navigator.pop(context);
    Timer(Duration(milliseconds: 50),()async{
      animationControllerDialog.forward();
      isShowChangeStatusDialog.sink.add(true);
    });
  }


  onPressCancelIsRegisterDialog(String value,context,Animations animations,randomMessage)async{
    verifyUser(value, context, animations, randomMessage);
    await animationControllerDialog.reverse();
    if(!isShowRegisterStatusDialog.isClosed){
      isShowRegisterStatusDialog.sink.add(false);
    }

  }

  onPressYesIsRegisterDialog(String value,context)async{
    await animationControllerDialog.reverse();
    if(!isShowRegisterStatusDialog.isClosed){
      isShowRegisterStatusDialog.sink.add(false);
    }
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: new LoginScreen(
              phoneOrEmail: value,
            )
        )
    );
  }

  verifyUser(String value,context,Animations animations,randomMessage)async{
    String phoneModel = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(Platform.isAndroid){
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      phoneModel = androidInfo.model;
    }else{
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      phoneModel = iosInfo.model;
    }
    animations.isErrorShow.sink.add(false);
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        identityUrl,
        'customerAccount/register',
        'PUT',
        {
          "identity" : value,
          "deviceToken" : prefs.getString("deviceToken"),
          "phoneModel" : phoneModel
        },
        ''
    );

    // print(responseBody);

    if(responseBody != null){
      if(responseBody.isNotEmpty){
        if(responseBody['result']){
          if(!isLoading.isClosed){
            isLoading.sink.add(false);
          }

          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                  child:  VerifyCodeScreen(
                    phoneOrEmail: value,
                  )
              )
          );

        }else{

          animations.showShakeError('فرمت وارد شده صحیح نمی باشد');
          if(!isLoading.isClosed){
            isLoading.sink.add(false);
          }

        }
      }else{
        animations.showShakeError('فرمت وارد شده صحیح نمی باشد');
        if(!isLoading.isClosed){
          isLoading.sink.add(false);
        }
      }
    }else{

      animations.showShakeError('خطا در برقراری اتصال، اینترنت خود را بررسی کنید');
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }

    }



  }



  showBackupDialog(){
    Timer(Duration(milliseconds: 50),()async{
      animationControllerDialog.forward();
      isShowBackupDialog.sink.add(true);
    });
  }

  onPressOkBackupDialog()async{
    await animationControllerDialog.reverse();
    if(!isShowBackupDialog.isClosed){
      isShowBackupDialog.sink.add(false);
    }
  }

  onPressOkErrorDialog()async{
    await animationControllerDialog.reverse();
    if(!isShowErrorDialog.isClosed){
      isShowErrorDialog.sink.add(false);
    }
  }


  showHelpDialog()async{
    Timer(Duration(milliseconds: 50),()async{
      animationControllerDialog.forward();
      isShowHelpDialog.sink.add(true);
    });
  }

  onPressOkHelpDialog()async{
    await animationControllerDialog.reverse();
    if(!isShowHelpDialog.isClosed){
      isShowHelpDialog.sink.add(false);
    }
  }

  // generateTopMessage() {
  //   if (topMessage.text == null) {
  //     final _random = new Random();
  //     var allDashboardMessageInfo = locator<AllDashBoardMessageAndNotifyModel>();
  //     topMessage = allDashboardMessageInfo.motivalMessages[
  //     _random.nextInt(allDashboardMessageInfo.motivalMessages.length - 1)];
  //   }
  //   if (!sugTopMessage.isClosed) {
  //     sugTopMessage.sink.add(topMessage);
  //   }
  // }

  generateBottomMessage({currentToday, periodDay, maxDays, fertStartDays, fertEndDays,currentWeekPregnancy}) {
    if (bottomMessageDashboard.isEmpty) {
      var registerInfo = locator<RegisterParamModel>();
      bottomMessageDashboard = GenerateDashboardAndNotifyMessages().getTwoSug(
          currentToday : currentToday,
          periodDay : periodDay,
          maxDays : maxDays,
          fertStartDays : fertStartDays,
          fertEndDays : fertEndDays,
          currentWeekPregnancy: currentWeekPregnancy
      );
      if (bottomMessageDashboard != null) {
        for (int i = 0; i < bottomMessageDashboard.length; i++) {
          // print(bottomMessageDashboard[i].text);
          if(bottomMessageDashboard[i].text!.contains("ایمپویی عزیز")  ||
              bottomMessageDashboard[i].text!.contains("دوست خوبم") ||
              bottomMessageDashboard[i].text!.contains(registerInfo.register.name!) ||
              bottomMessageDashboard[i].text!.contains("${registerInfo.register.name} جان")
          ){

          }else{
            bottomMessageDashboard[i].text = '${randomNameGET(registerInfo.register.name)} ${bottomMessageDashboard[i].text}';
          }
          // if(registerInfo.register.status == 3){
          //   bottomMessageDashboard[i].text =  bottomMessageDashboard[i].text.replaceAll('%Child%',registerInfo.register.childName);
          // }
        }
      }
    }
    if(bottomMessageDashboard.isNotEmpty){
      if (!sugBottomMessages.isClosed) {
        sugBottomMessages.sink.add(bottomMessageDashboard);
      }
    }
    // var allDashboardMessageInfo =  locator<AllDashBoardMessageAndNotifyModel>();
    // for(int i=0 ; i<allDashboardMessageInfo.parentDashboardMessages.length ; i++){
    //   for(int j=0 ; j<allDashboardMessageInfo.parentDashboardMessages[i].dashboardMessages.length ; j++){
    //     allDashboardMessageInfo.parentDashboardMessages[i].dashboardMessages[j].text =
    //         _textSelect(str, name)
    //   }
    // }
  }

  // String _textSelect(String str,String name) {
  //   str = str.replaceAll("ایمپویی عزیز","");
  //   str = str.replaceAll("دوست خوبم","");
  //   str = str.replaceAll(name,"");
  //   str = str.replaceAll("$name جان", "");
  //   return str;
  // }
  
  String randomNameGET(name) {
    List<String> names = [];
    names.add("ایمپویی عزیز");
    names.add("دوست خوبم");
    names.add(name);
    names.add("$name جان");
    return names[new Random().nextInt(4)];
  }


  // Future<bool> generateSugMessagesAndNotifications(currentToday, periodDay, maxDays, fertStartDays, fertEndDays, circleModelForSings)async{
  //   if(sugMessage.stream.value.isEmpty){
  //
  //     List<SugMessagesLocalModel> sugLocal = await _dashboardModel.getSugLocal();
  //       if(sugLocal == null){
  //          Messages().generateDashBoardAndNotifyMessages(circleModelForSings, RegisterParamViewModel);
  //         List<MotivalListModel> motival = await _dashboardModel.getMotival();
  //         listMessages =  await GenerateDashboardAndNotifyMessages().getTwoSug(currentToday, periodDay, maxDays, fertStartDays, fertEndDays, circleModelForSings);
  //         for(int i=0 ; i<listMessages.length ; i++){
  //           listMessages[i].text = '${SugGenerator().randomNameGET(RegisterParamViewModel.name)} ${listMessages[i].text}';
  //         }
  //         // GenerateDashboardAndNotifyMessages().checkForNotificationMessage(currentToday, periodDay, maxDays, fertStartDays, fertEndDays, circleModelForSings, RegisterParamViewModel);
  //         if(motival != null){
  //           final _random = new Random();
  //           List<MotivalListModel>reverseMotival = motival.reversed.toList();
  //           for(int i=0 ; i<reverseMotival.length ; i++){
  //             // print('isPin : ${reverseMotival[i].isPin}');
  //             if(reverseMotival[i].isPin == 1){
  //               listMessages.add(
  //                   DashBoardAndNotifyMessagesLocalModel.fromJson(
  //                       {
  //                         'id' : 0,
  //                         'parentId' : 0,
  //                         'strId' : reverseMotival[i].serverId,
  //                         'text' : reverseMotival[i].text,
  //                         'isPin' :  reverseMotival[i].isPin,
  //                         'link' :  reverseMotival[i].link
  //                       },
  //                       false
  //                   )
  //               );
  //               break;
  //             }
  //           }
  //           // print('listMesssage : ${listMessages.length}');
  //           if(listMessages.length == 2){
  //             int randomIndex = _random.nextInt(motival.length);
  //             listMessages.add(
  //                 DashBoardAndNotifyMessagesLocalModel.fromJson(
  //                     {
  //                       'id' : 0,
  //                       'parentId' : 0,
  //                       'strId' : motival[randomIndex].serverId,
  //                       'text' : motival[randomIndex].text,
  //                       'isPin' :  0,
  //                       'link' :  motival[randomIndex].link
  //                     },
  //                     false
  //                 )
  //                 // motival[_random.nextInt(motival.length)].text
  //             );
  //           }
  //         }else{
  //           listMessages.add(
  //               DashBoardAndNotifyMessagesLocalModel.fromJson(
  //                   {
  //                     'id' : 0,
  //                     'parentId' : 0,
  //                     'strId' : '',
  //                     'text' : randomMessage,
  //                     'isPin' :  0,
  //                     'link' :  ''
  //                   },
  //                   false
  //               )
  //             // motival[_random.nextInt(motival.length)].text
  //           );
  //         }
  //         sugMessage.sink.add(listMessages);
  //         setRandomMessage();
  //
  //         for(int i=0 ; i<listMessages.length ; i++){
  //           await _dashboardModel.insertSugMessagesToLocal(
  //               {
  //                 'text' : listMessages[i].text,
  //                 'serverId' : listMessages[i].strId,
  //                 'isPin' : listMessages[i].isPin,
  //                 'link' : listMessages[i].link,
  //               }
  //           );
  //         }
  //       }else{
  //
  //         for(int i=0 ; i<sugLocal.length ; i++){
  //           listMessages.add(
  //               DashBoardAndNotifyMessagesLocalModel.fromJson(
  //                   {
  //                     'id' : 0,
  //                     'parentId' : 0,
  //                     'strId' : sugLocal[i].serverId,
  //                     'text' : sugLocal[i].text,
  //                     'isPin' :  sugLocal[i].isPin,
  //                     'link' :  sugLocal[i].link
  //                   },
  //                   false
  //               )
  //           );
  //         }
  //
  //         // listMessages.add(sugLocal[0].text);
  //         // listMessages.add(sugLocal[1].text);
  //         // listMessages.add(sugLocal[2].text);
  //
  //         sugMessage.sink.add(listMessages);
  //         setRandomMessage();
  //
  //       }
  //
  //     }
  //    // downAnimationControllerBox1.forward();
  //   return true;
  //
  // }

  showLocalNotifyDialog()async{
    Timer(Duration(milliseconds: 50),()async{
      animationControllerDialog.forward();
      isShowNotifyDialog.sink.add(true);
    });
  }

 Future<bool> onPressYesLocalNotifyDialog()async{
    await animationControllerDialog.reverse();
    if(!isShowNotifyDialog.isClosed) {
      isShowNotifyDialog.sink.add(false);
    }
    return true;
  }

  onPressCancelLocalNotifyDialog()async{
    await animationControllerDialog.reverse();
    if(!isShowNotifyDialog.isClosed) {
      isShowNotifyDialog.sink.add(false);
    }
  }

  checkIsExitReminderPad()async{
    List<DailyRemindersViewModel>? dailyReminders = await _dashboardModel.getDailyReminders();
    if(dailyReminders != null) {
      if (dailyReminders.length == 168) {
        for (int i = 701; i < 725; i++) {
          await _dashboardModel.insertToLocal(
              {
                'id': i,
                'title': 'تعویض ${i - 700}',
                'time': "21:00",
                'isSound': 1,
                'mode': i == 701 ? 1 : 0,
                'dayWeek': '',
                'isChange': 0
              },
              'DailyReminders'
          );
        }
      }
    }
  }

  setStatus(int st){
    if(!status.isClosed){
      status.sink.add(st);
    }
  }

  generateWeekPregnancy(){
    PregnancyNumberViewModel pregnancyNumberViewModel = _dashboardModel.getPregnancyNumber();
    generateBottomMessage(currentWeekPregnancy: pregnancyNumberViewModel.weekNoPregnancy);
    // print(pregnancyNumberViewModel.dayToDelivery);
    if(!pregnancyNumber.isClosed){
      pregnancyNumber.sink.add(pregnancyNumberViewModel);
    }
  }


  getDefaultSettingBardari(){
    isChangeDialogSettingScreens = false;
    RegisterParamViewModel register = _dashboardModel.getRegisters();
    DateTime _pregnancyDate = register.pregnancyDate!;
    if(!isDeliveryPregnancySelected.isClosed){
      isDeliveryPregnancySelected.sink.add(register.isDeliveryDate!);
    }
     if(register.isDeliveryDate!){
       itemsBirthOrcycle[0].selected = true;
       itemsBirthOrcycle[1].selected = false;
     }else{
       itemsBirthOrcycle[0].selected = false;
       itemsBirthOrcycle[1].selected = true;
     }


    if (!pregnancyDateSelected.isClosed) {
      pregnancyDateSelected.sink.add(Jalali.fromDateTime(_pregnancyDate));
    }
    if(!pregnancyNoSelected.isClosed){
      pregnancyNoSelected.sink.add(register.pregnancyNo! - 1);
    }
    if(!pregnancyAborationSelected.isClosed){
      pregnancyAborationSelected.sink.add(register.hasAboration! - 1);
    }
  }

  changeIsDeliveryPregnancy(bool value){
    isChangeDialogSettingScreens = true;
    if(!isDeliveryPregnancySelected.isClosed){
      isDeliveryPregnancySelected.sink.add(value);
    }
  }

  onChangePregnancyDate(date){
    print(date);
    print(date.runtimeType);
    RegisterParamViewModel register = _dashboardModel.getRegisters();
    isChangeDialogSettingScreens = true;
    if (!pregnancyDateSelected.isClosed) {
      pregnancyDateSelected.sink.add(
        register.calendarType == 1 ?
         Jalali.fromDateTime(date) :
         date
      );
    }
  }


  onChangePregnancyNo(int index){
    isChangeDialogSettingScreens = true;
    if(!pregnancyNoSelected.isClosed){
      pregnancyNoSelected.sink.add(index);
    }
  }

  onChangePregnancyAboration(int index){
    isChangeDialogSettingScreens = true;
    if(!pregnancyAborationSelected.isClosed){
      pregnancyAborationSelected.sink.add(index);
    }
  }

  acceptSettingPregnancy(context) async {
    setDefaultCycle();
    if (!isLoading.isClosed) {
      isLoading.sink.add(true);
    }
    RegisterParamViewModel register = _dashboardModel.getRegisters();

    String pregnancyDateForSend = pregnancyDateSelected.stream.value.toDateTime().toString();

    // print(isDeliveryPregnancySelected.stream.value);
    // print(pregnancyDateForSend);
    // print(pregnancyNoSelected.stream.value + 1);
    // print(pregnancyAborationSelected.stream.value + 1);


    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'pregnancyInfo/pregnancy',
        'POST',
        {
          "isDeliveryDate": isDeliveryPregnancySelected.stream.value,
          "pregnancyDate": pregnancyDateForSend,
          "hasAboration": pregnancyAborationSelected.stream.value + 1,
          "pregnancyNo": pregnancyNoSelected.stream.value + 1
        },
        register.token!
    );

    if (responseBody != null) {
      if (responseBody["isValid"]) {
        _dashboardModel.registerInfo.setPregnancyDate(pregnancyDateSelected.stream.value.toDateTime());
        _dashboardModel.registerInfo.setIsDeliveryDate(isDeliveryPregnancySelected.stream.value);
        _dashboardModel.registerInfo.setPregnancyNo(pregnancyNoSelected.stream.value + 1);
        _dashboardModel.registerInfo.setHasAboration(pregnancyAborationSelected.stream.value + 1);
        // isChangeDialogSettingScreens = false;
        // await GenerateDashboardAndNotifyMessages().checkForNotificationMessage();
        // if (!isLoading.isClosed) {
        //   isLoading.sink.add(false);
        // }
        // gotoHome(context);

        generatePregnancyAndBreastfeedingAfterChangeCycle(context);

        // registerInfo.setPregnancyDate(miladyDate.toString());
        //
        // registerInfo.setIsDeliveryDate(moodPress == 0 ? true : false);
        // registerInfo.setPregnancyNo(typeNumberPregnancy);
        // registerInfo.setHasAboration(typeAboration);
        //
        // if (!settingPregnancy.isClosed) {
        //   settingPregnancy.sink.add(registerInfo.register);
        // }
        //
        // if (!isChangeDialog.isClosed) {
        //   isChangeDialog.sink.add(false);
        // }
        // getSettingPregnancy(context);

      }else{
        if (!isLoading.isClosed) {
          isLoading.sink.add(false);
        }
        showToast(context, 'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
      }
    }else{
      if (!isLoading.isClosed) {
        isLoading.sink.add(false);
      }
      showToast(context, 'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }
  }

  backSettingScreens(context){
    if(isChangeDialogSettingScreens){
      showDialog();
    }else{
     Navigator.pop(context);
    }
  }

  showAborationDialog(){
    Timer(Duration(milliseconds: 50),()async{
      animationControllerDialog.forward();
      isAborationDialog.sink.add(true);
    });
  }

  aborationCancelDialog()async{
    await animationControllerDialog.reverse();
    if (!isAborationDialog.isClosed) {
      isAborationDialog.sink.add(false);
    }
  }

  enterMenstruation(context,RegisterPresenter registerPresenter){
    aborationCancelDialog();
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child:  PeriodDayRegisterScreen(
              hasAbortion: true,
            )
        )
    );
    // List<CycleViewModel> cycles = _dashboardModel.getAllCircles();
    // PregnancyNumberViewModel pregnancyNumberViewModel = _dashboardModel.getPregnancyNumber();
    // CycleViewModel _lastCycle;
    // int maxDays = 0;
    // if(cycles.isNotEmpty){
    //   _lastCycle = cycles[cycles.length-1];
    //   DateTime periodStart = DateTime.parse(_lastCycle.periodStart);
    //   DateTime circleEnd = DateTime.parse(_lastCycle.circleEnd);
    //   maxDays = MyDateTime().myDifferenceDays(periodStart, circleEnd) + 1;
    //   print(pregnancyNumberViewModel.weekNoPregnancy * 7);
    //   print(maxDays);
    //   if((pregnancyNumberViewModel.weekNoPregnancy * 7) > maxDays){
    //     Navigator.push(
    //         context,
    //         PageTransition(
    //             type: PageTransitionType.fade,
    //             child:  PeriodDayRegisterScreen(
    //             )
    //         )
    //     );
    //   }else{
    //     registerPresenter.requestChangeStatus(1,animations,context);
    //   }
    // }else{
    //   registerPresenter.requestChangeStatus(1,animations,context);
    // }
  }



  generateWeekBreastfeeding(){
    RegisterParamViewModel register = _dashboardModel.getRegisters();
    if(!breastfeedingNumbers.isClosed){
      breastfeedingNumbers.sink.add(
        BreastfeedingNumberModel(
          breastfeedingCurrentWeek: register.breastfeedingNumberModel!.breastfeedingCurrentWeek,
          breastfeedingCurrentMonth: register.breastfeedingNumberModel!.breastfeedingCurrentMonth
        )
      );
    }
    generateBottomMessage();
  }

  getDefaultSettingLactation() {
    isChangeDialogSettingScreens = false;
    RegisterParamViewModel register = _dashboardModel.getRegisters();
    DateTime _childBirthDate = register.childBirthDate!;

    for(int i=0 ; i<specificationBabyModel.length ; i++){
      specificationBabyModel[i].selected = false;
    }
    if (register.childType == 1) {
      specificationBabyModel[0].selected = true;
    } else if (register.childType == 2) {
      specificationBabyModel[1].selected = true;
    } else {
      specificationBabyModel[2].selected = true;
    }

    if (!childBirthDateSelected.isClosed) {
      childBirthDateSelected.sink.add(Jalali.fromDateTime(_childBirthDate));
    }
    if (!childNameSelected.isClosed) {
      childNameSelected.sink.add(register.childName!);
    }
    childNameController = TextEditingController(text: register.childName);

    if (!childTypeSelected.isClosed) {
      childTypeSelected.sink.add(
          register.childType == 1 || register.childType == 2
              ? register.childType! - 1
              : 2);
    }
    if (!childBirthTypeSelected.isClosed) {
      childBirthTypeSelected.sink.add(register.childBirthType! - 1);
    }
  }

  bool validation(context, animations) {
    // if (!isChangeDialogLactation.isClosed) {
    //   isChangeDialogLactation.sink.add(false);
    // }

    if (childTypeSelected.stream.value == 0 ||
        childTypeSelected.stream.value == 1) {
      if (childNameSelected.stream.value == "") {
        animations.showShakeError('اسم فرزندت رو وارد نکردی!');
        return false;
      } else {
        animations.showShakeError('');

        return true;
      }
    } else {
      animations.showShakeError('');
      return true;
    }
  }

  onChangeChildName(value) {
    isChangeDialogSettingScreens = true;
    if (!childNameSelected.isClosed) {
      childNameSelected.sink.add(value);
    }
  }

  onChangeChildType(int value) {
    isChangeDialogSettingScreens = true;

    if (!childTypeSelected.isClosed) {
      childTypeSelected.sink.add(value);
    }
    childNameController.clear();
    if (!childNameSelected.isClosed) {
      childNameSelected.sink.add('');
    }
  }

  onChangeChildBirthType(int index) {
    isChangeDialogSettingScreens = true;
    if (!childBirthTypeSelected.isClosed) {
      childBirthTypeSelected.sink.add(index);
    }
  }

  onChangeChildBirthDateDate(date) {
    RegisterParamViewModel register = _dashboardModel.getRegisters();
    isChangeDialogSettingScreens = true;
    if (!childBirthDateSelected.isClosed) {
      childBirthDateSelected.sink.add(
        register.calendarType == 1 ?
            Jalali.fromDateTime(date) :
            date
      );
    }
  }

  acceptSettingBreastfeeding(context, animation,bool isDialog) async {
    // if (!isChangeDialogLactation.isClosed) {
    //   isChangeDialogLactation.sink.add(false);
    // }
    setDefaultCycle();
    if (!isLoading.isClosed) {
      isLoading.sink.add(true);
    }

    RegisterParamViewModel register = _dashboardModel.getRegisters();

    String pregnancyDateForSend = childBirthDateSelected.stream.value.toDateTime().toString();

    AnalyticsHelper().log(
        isDialog ? AnalyticsEvents.SetBrstfeedPg_SaveChangeDlgYes_Btn_Clk :
        AnalyticsEvents.SetBrstfeedPg_SaveAndAccept_Btn_Clk,
        parameters: {
          "childBirthDate": pregnancyDateForSend,
          "childBirthType": childBirthTypeSelected.stream.value + 1,
          "childType": childTypeSelected.stream.value == 2
              ? 4
              : childTypeSelected.stream.value + 1,
          "childName": childNameSelected.stream.value,
        }
    );

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'breastfeedingInfo/breastfeeding',
        'POST',
        {
          "childBirthDate": pregnancyDateForSend,
          "childBirthType": childBirthTypeSelected.stream.value + 1,
          "childType": childTypeSelected.stream.value == 2
              ? 4
              : childTypeSelected.stream.value + 1,
          "childName": childNameSelected.stream.value,
        },
        register.token!);

    if (responseBody != null) {
      if (responseBody["isValid"]) {

        // if (!isLoading.isClosed) {
        //   isLoading.sink.add(false);
        // }
        // showToast(context, 'تغییرات با موفقیت ذخیره شد');
        // isChangeDialogSettingScreens = false;
       // animation.showShakeError('');

        _dashboardModel.registerInfo.setChildBirthDate(childBirthDateSelected.stream.value.toDateTime());
        _dashboardModel.registerInfo.setChildBirthType(childBirthTypeSelected.stream.value + 1);
        _dashboardModel.registerInfo.setChildType(
            childTypeSelected.stream.value == 2
                ? 4
                : childTypeSelected.stream.value + 1);
        _dashboardModel.registerInfo.setChildName(childNameSelected.stream.value);

        generatePregnancyAndBreastfeedingAfterChangeCycle(context);
      } else {
        if (!isLoading.isClosed) {
          isLoading.sink.add(false);
        }
        showToast(context,
            'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
      }
    } else {
      if (!isLoading.isClosed) {
        isLoading.sink.add(false);
      }
      showToast(context,
          'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }
  }

  generatePregnancyAndBreastfeedingAfterChangeCycle(context){
    RegisterParamViewModel register = _dashboardModel.getRegisters();
    if(register.status == 2){
      GenerateDashboardAndNotifyMessages().generateWeekPregnancy(false);
    }else if(register.status == 3){
      GenerateDashboardAndNotifyMessages().generateWeekPregnancy(false);
      GenerateDashboardAndNotifyMessages().generateWeekBreastfeeding(false);
    }
    var pregnancyNumberInfo = locator<PregnancyNumberModel>();
    var cycleInfo = locator<CycleModel>();


    DateTime lastPeriod = pregnancyNumberInfo.pregnancyNumbers.lastPeriod!;
    DateTime? childBirthDate = register.childBirthDate;
    List<CycleViewModel> reverseCycles = cycleInfo.cycle.reversed.toList();

    for(int i=0 ; i<reverseCycles.length ; i++){
      if(reverseCycles[i].status == 2 || reverseCycles[i].status == 3){
        cycleInfo.removeCycle(cycleInfo.cycle.length - 1);
      }else{
        break;
      }
    }

    List<int> counterRemoves = [];
    if (cycleInfo.cycle != null) {
      for (int i = 0; i < cycleInfo.cycle.length; i++) {
        // print(circlesItem[i].circleEnd);
        if (
        lastPeriod.isBefore(DateTime.parse(cycleInfo.cycle [i].circleEnd!))) {
          // print('11111111');
          counterRemoves.add(i);
        }
      }
    }
    // print(circlesItem.length);
    if (counterRemoves.length != 0) {
      // circlesItem.removeRange(counterRemoves[0], counterRemoves[counterRemoves.length-1]+1);
      cycleInfo.removeRangeCycle(counterRemoves[0], counterRemoves[counterRemoves.length - 1] + 1);
    }
    // print(circlesItem.length);

    for (int i = 0; i < 40; i++) {
      DateTime circleEnd = DateTime(lastPeriod.year, lastPeriod.month, lastPeriod.day + (i * 7) + 6);
      if (register.status == 3 && circleEnd.isAfter(childBirthDate!)) {
        circleEnd = childBirthDate;
      }
      // circlesItem.add(
      //     CycleViewModel(
      //       periodStart: DateTime(lastPeriod.year,lastPeriod.month,lastPeriod.day+(i*7)).toString(),
      //       circleEnd: circleEnd.toString(),
      //     )
      // );
      cycleInfo.addCycle(
          {
            'periodStartDate': DateTime(lastPeriod.year, lastPeriod.month, lastPeriod.day + (i * 7)).toString(),
            'periodEndDate' : DateTime(lastPeriod.year, lastPeriod.month, lastPeriod.day + (i * 7) + 3).toString(),
            'cycleEndDate': circleEnd.toString(),
            'status': 2
          }
      );
      if (circleEnd == childBirthDate) {
        break;
      }
    }

    if (register.status == 3) {
      DateTime startDate = DateTime(childBirthDate!.year, childBirthDate.month, childBirthDate.day + 1);
      for (int i = 0; i < 25; i++) {
        cycleInfo.addCycle(
            {
              'periodStartDate': DateTime(startDate.year, startDate.month, startDate.day + (i * 7)).toString(),
              'periodEndDate' : DateTime(startDate.year, startDate.month, startDate.day + (i * 7) + 3).toString(),
              'cycleEndDate': DateTime(startDate.year, startDate.month, startDate.day + (i * 7) + 6).toString(),
              'status': 3
            }
        );
      }
    }
    setCycleCalendar(context,typeSendNotifyForPartner: 10,updateBio: false);
  }

  initBioRhythm(BuildContext context)  {
    if (viewBioRhythms.isEmpty) {
      viewBioRhythms.clear();
      if (!bioRhythms.isClosed) {
        bioRhythms.sink.add(viewBioRhythms);
      }
      BioViewModel dbBioRhythms =  _dashboardModel.getBioRyhthms();
      viewBioRhythms.add(BioRhythmViewModel(
          title: 'جسمانی',
          mainColor: ColorPallet().powerHigh,
          mainPersent: dbBioRhythms.bodyPercent,
          gradientColors: [ColorPallet().powerHigh, ColorPallet().powerMain],
          gradientIcon: [ColorPallet().powerMain, ColorPallet().powerHigh],
          icon: 'assets/images/ic_power_active.svg',
          deactiveIcon: 'assets/images/ic_power.svg',
          percent:  MediaQuery.of(context).size.width /2 - ( MediaQuery.of(context).size.width /2 - ((dbBioRhythms.bodyPercent *  MediaQuery.of(context).size.width /2) / 100)),
          viewPercent: '${dbBioRhythms.bodyPercent}',
          isSelected: false));
      viewBioRhythms.add(BioRhythmViewModel(
          title: 'احساسی',
          mainPersent: dbBioRhythms.emotionalPercent,
          mainColor: ColorPallet().emotionalHigh,
          gradientColors: [
            ColorPallet().emotionalHigh,
            ColorPallet().emotionalMain
          ],
          gradientIcon: [
            ColorPallet().emotionalMain,
            ColorPallet().emotionalHigh,
          ],
          icon: 'assets/images/ic_emotional_active.svg',
          deactiveIcon: 'assets/images/ic_emotional.svg',
          percent:
          MediaQuery.of(context).size.width /2 - ( MediaQuery.of(context).size.width /2 - ((dbBioRhythms.emotionalPercent *  MediaQuery.of(context).size.width /2) / 100)),
          viewPercent: '${dbBioRhythms.emotionalPercent}',
          isSelected: false));
      viewBioRhythms.add(BioRhythmViewModel(
          title: 'ذهنی   ',
          mainColor: ColorPallet().mentalHigh,
          mainPersent: dbBioRhythms.cognitivePercent,
          gradientColors: [ColorPallet().mentalHigh, ColorPallet().mentalMain],
          gradientIcon: [ColorPallet().mentalMain, ColorPallet().mentalHigh],
          icon: 'assets/images/ic_mental_active.svg',
          deactiveIcon: 'assets/images/ic_mental.svg',
          percent:
          MediaQuery.of(context).size.width /2 - ( MediaQuery.of(context).size.width /2 - ((dbBioRhythms.cognitivePercent *  MediaQuery.of(context).size.width /2) / 100)),
          viewPercent: '${dbBioRhythms.cognitivePercent}',
          isSelected: false));
      List<double> percents = [];
      for (int i = 0; i < viewBioRhythms.length; i++) {
        percents.add(double.parse(viewBioRhythms[i].viewPercent!));
      }

      // double bigPercent = percents.reduce(max);
      //
      // for (int i = 0; i < viewBioRhythms.length; i++) {
      //   if (bigPercent == double.parse(viewBioRhythms[i].viewPercent)) {
      //     viewBioRhythms[i].isSelected = true;
      //     break;
      //   }
      // }

      int random = Random().nextInt(viewBioRhythms.length);

      viewBioRhythms[random].isSelected = true;

    }

    if (!bioRhythms.isClosed) {
      bioRhythms.sink.add(viewBioRhythms);
    }

    initRandomMessages();
  }

  String getName()  {
    String name;
    RegisterParamViewModel   registerParametersModel =  _dashboardModel.getRegisters();
    name = registerParametersModel.name!;
    return name;
  }

  BioViewModel getBioRyhthms(){
    return _dashboardModel.getBioRyhthms();
  }


  initRandomMessages() async {
    final _random = Random();
    String name =  getName();
    BioViewModel bioRhythms =  _dashboardModel.getBioRyhthms();
    List<BioRhythmMessagesModel> powerMessages = bioRhythms.bodyMessage;
    List<BioRhythmMessagesModel> emotionalMessages = bioRhythms.emotionalMessage;
    List<BioRhythmMessagesModel> mentalMessages = bioRhythms.cognitiveMessage;


    if (allRandomMessages.isEmpty) {
      if (powerMessages.isNotEmpty) {
        allRandomMessages.add(BioRhythmMessagesModel(
            username: '${randomNameGET(name)}',
            text:
            '${powerMessages[_random.nextInt(powerMessages.length)].text}',
            type: powerMessages[_random.nextInt(powerMessages.length)].type));
      } else {
        allRandomMessages.add(BioRhythmMessagesModel(type: 0, text: ''));
      }

      if (emotionalMessages.isNotEmpty) {
        allRandomMessages.add(BioRhythmMessagesModel(
            username: '${randomNameGET(name)}',
            text:
            '${emotionalMessages[_random.nextInt(emotionalMessages.length)].text}',
            type: emotionalMessages[_random.nextInt(emotionalMessages.length)]
                .type));
      } else {
        allRandomMessages.add(BioRhythmMessagesModel(type: 1, text: ''));
      }

      if (mentalMessages.isNotEmpty) {
        allRandomMessages.add(BioRhythmMessagesModel(
            username: '${randomNameGET(name)}',
            text:
            '${mentalMessages[_random.nextInt(mentalMessages.length)].text}',
            type: mentalMessages[_random.nextInt(mentalMessages.length)].type));
      } else {
        allRandomMessages.add(BioRhythmMessagesModel(type: 2, text: ''));
      }
    }

    for (int i = 0; i < viewBioRhythms.length; i++) {
      if (viewBioRhythms[i].isSelected!) {
        if (!messageRandomBio.isClosed) {
          messageRandomBio.sink.add(allRandomMessages[i]);
        }
      }
    }
  }

  onPressItemBio(index) {
    if(index == 0){
      switch(getRegisters().status){
        case 1: AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_Body_Item_Clk);
        break;
        case 2: AnalyticsHelper().log(AnalyticsEvents.DashPgPregnancy_Body_Item_Clk);
        break;
        case 3: AnalyticsHelper().log(AnalyticsEvents.DashPgBrstfeed_Body_Item_Clk);
        break;
      }
    }else if(index == 1){
      switch(getRegisters().status){
        case 1: AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_Emotional_Item_Clk);
        break;
        case 2: AnalyticsHelper().log(AnalyticsEvents.DashPgPregnancy_Emotional_Item_Clk);
        break;
        case 3: AnalyticsHelper().log(AnalyticsEvents.DashPgBrstfeed_Emotional_Item_Clk);
        break;
      }
    }else{
      switch(getRegisters().status){
        case 1: AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_Mental_Item_Clk);
        break;
        case 2: AnalyticsHelper().log(AnalyticsEvents.DashPgPregnancy_Mental_Item_Clk);
        break;
        case 3: AnalyticsHelper().log(AnalyticsEvents.DashPgBrstfeed_Mental_Item_Clk);
        break;
      }
    }

    for (int i = 0; i < viewBioRhythms.length; i++) {
      viewBioRhythms[i].isSelected = false;
    }
    viewBioRhythms[index].isSelected = true;

    if (!bioRhythms.isClosed) {
      bioRhythms.sink.add(viewBioRhythms);
    }

    if (allRandomMessages.isNotEmpty) {
      for (int i = 0; i < allRandomMessages.length; i++) {
        if (!messageRandomBio.isClosed) {
          messageRandomBio.sink.add(allRandomMessages[index]);
        }
      }
    }
  }

  StoryViewModel getStories(){
    return _dashboardModel.getStories();
  }

  List<CycleViewModel> getAllPeriodCircles(){
    return _dashboardModel.getAllPeriodCircles();
  }

  showToast(context, message) {
    //Fluttertoast.showToast(msg:message,toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM);
    CustomSnackBar.show(context, message);
  }

  dispose(){
    isShowPeriodDialog.close();
    dialogScale.close();
    isShowExitDialog.close();
    isLoading.close();
    isShowBackupDialog.close();
    isShowErrorDialog.close();
    valueDialogError.close();
    dateBackup.close();
    isShowNotifyDialog.close();
    isShowHelpDialog.close();
    isShowRegisterStatusDialog.close();
    isShowPeriodPanel.close();
    myChangePanel.close();
    myChangeDialog.close();
    advertis.close();
    sugTopMessage.close();
    sugBottomMessages.close();
    beforePeriodSings.close();
    duringPeriodSigns.close();
    mentalSigns.close();
    otherSigns.close();
    ovuSigns.close();
    pregnancyNumber.close();
    status.close();
    fetalSex.close();
    physicalSigns.close();
    pregnancyPhysicalSigns.close();
    pregnancyGastrointestinalSign.close();
    pregnancyPsychologySigns.close();
    isShowDialog.close();
    isLoadingButton.close();
    pregnancyDateSelected.close();
    pregnancyNoSelected.close();
    pregnancyAborationSelected.close();
    isDeliveryPregnancySelected.close();
    isShowChangeStatusDialog.close();
    isAborationDialog.close();
    typeChangeStatusDialog.close();
    childBirthDateSelected.close();
    childNameSelected.close();
    childTypeSelected.close();
    childBirthTypeSelected.close();
    breastfeedingBabySigns.close();
    breastfeedingPhysicalSigns.close();
    breastfeedingMotherSigns.close();
    breastfeedingPsychologySigns.close();
    isLoadingDashBoard.close();
    breastfeedingNumbers.close();
    bioRhythms.close();
    messageRandomBio.close();
    name.close();
//    valueCheckUpdateDialog.close();
  }

}