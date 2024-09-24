
import 'dart:async';
import 'dart:convert';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/main.dart';
import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/profile_presenter.dart';
import 'package:impo/src/architecture/view/expert_view.dart';
import 'package:impo/src/architecture/view/profile_view.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/dialogs/qus_dialog.dart';
import 'package:impo/src/components/tab_target.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/models/profile/about_ic.dart';
import 'package:impo/src/models/advertise_model.dart';
import 'package:impo/src/models/profile/box_change_circles_model.dart';
import 'package:impo/src/models/profile/item_profile_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/home/home.dart';
import 'package:impo/src/screens/home/tabs/main/change_status_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/about_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/enter_face_code_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/partner/partner_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/contact_impo_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/supportOnline/pages/support_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/update_screen.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:impo/src/screens/home/tabs/profile/my_impo_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/reporting/reporting_screen.dart';
import 'package:impo/src/architecture/presenter/expert_presenter.dart';
import '../../../../data/locator.dart';
import '../../../../firebase_analytics_helper.dart';
import '../../../subscribe/choose_subscription_page.dart';
import '../expert/clinic_question_screen.dart';


class ProfileScreen extends  StatefulWidget{

  @override
  State<StatefulWidget> createState() => ProfileScreenState();

}

class ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin implements ProfileView,ExpertView{


 late ProfilePresenter _profilePresenter;
 late ExpertPresenter _expertPresenter;

 ProfileScreenState(){
   _profilePresenter = ProfilePresenter(this);
   _expertPresenter = ExpertPresenter(this);
 }

  double width = 0;
  double height = 0;

  late AnimationController animationControllerScaleButtons;
  

  Animations _animations =  Animations();
  late RegisterParamViewModel registerModel;
  List<BoxChangeCirclesModel>? listBoxChangeCircles;

  bool showDialogBackup = false;
  late String pass;
  bool isBackup = false;
  late String phoneOrEmail;
  late String password;
  // int typeValue;
  late String dateNow;
  int modePress = 0;
 int diffEndTime = 1;


  static const String
      // feature7 = 'feature7',
      // feature8 = 'feature8',
      feature9 = 'feature9',
      // feature10 = 'feature10',
      feature101 = 'feature101',
      feature102 = 'feature102',
      feature103 = 'feature103';

  bool womansubscribtion = false;

  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.ProfilePg_Self_Pg_Load);
    _profilePresenter.initialDialogScale(this);
    initTabTarget();
    generateSubEndTime();
    _profilePresenter.getAdvertise();
    animationControllerScaleButtons = _animations.pressButton(this);
    getRegisterParams();
    // getPass();
    super.initState();
  }

 generateSubEndTime()async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   setState(() {
     diffEndTime = prefs.getInt('endTimeWomanSubscribe')!;
     womansubscribtion = prefs.getBool('womansubscribtion')!;
   });
 }

  initTabTarget(){
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(getRegisters().status == 1){
        FeatureDiscovery.discoverFeatures(
          context,
          const <String>{
            // feature7,
            // feature8,
            feature9,
            // feature10,
            feature101,
            feature102,
            feature103
          },
        );
      }else{
        FeatureDiscovery.discoverFeatures(
          context,
          const <String>{
            feature9,
            // feature10,
            feature101,
            feature102,
            feature103
          },
        );
      }
    });
  }


  // checkShowDialogBackup()async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if(prefs.getBool("showDialogBackup") != null){
  //     if(prefs.getBool("showDialogBackup")){
  //       showDialogBackup = prefs.getBool("showDialogBackup");
  //       widget.presenter.showBackupDialog();
  //       widget.presenter.initialDialogScale(this);
  //       prefs.setBool('showDialogBackup', false);
  //     }
  //   }
  // }

  // getPass()async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //  pass = prefs.getString('pass');
  // }

  RegisterParamViewModel getRegisters(){
    RegisterParamViewModel registerModel =   _profilePresenter.getRegister();
    return registerModel;
  }

    getRegisterParams()async{
    // DataBaseProvider db  =  DataBaseProvider();
     registerModel =  getRegisters();
     if(registerModel.status == 1){
       setState(() {
         listBoxChangeCircles = [

           BoxChangeCirclesModel(
               title: 'طول دوره',
               number: 0,
               selected: false
           ),
           BoxChangeCirclesModel(
               title: 'طول پریود',
               number: 0,
               selected: false
           )

         ];
       });
     }
  }


  @override
  void dispose() {
    animationControllerScaleButtons.dispose();
    super.dispose();
  }

 Future<bool> onWillPop() async {
   AnalyticsHelper().log(AnalyticsEvents.ProfilePg_Back_NavBar_Clk);
   if(womansubscribtion){
     if(_profilePresenter.isShowPregnancyDialog.stream.value){
       _profilePresenter.cancelPregnancyDialog();
     }else{
       Navigator.pushReplacement(
           context,
           MaterialPageRoute(
               settings: RouteSettings(name: "/Page1"),
               builder: (context) => FeatureDiscovery(
                   recordStepsInSharedPreferences: true,
                   child: Home(
                     indexTab: currentIndex,
                     register: true,
                     isChangeStatus: false,
                     // isLogin: false,
                   )
               )
           )
       );
     }
   }else{
     Navigator.pushReplacement(
         context,
         PageTransition(
             type: PageTransitionType.fade,
             child:  ChooseSubscriptionPage(
               isSub: false,
             )
         )
     );
   }
   // Navigator.of(context).popUntil(ModalRoute.withName("/Page1"));
   return Future.value(false);
 }



  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = 0.5;
    width = MediaQuery.of(context).size.width;
    height= MediaQuery.of(context).size.height;
    return  WillPopScope(
      onWillPop: onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child:  Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowIndicator();
                  return true;
                },
                child:    ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(40)),
                      child:  CustomAppBar(
                        messages: false,
                        profileTab: true,
                        icon: 'assets/images/ic_arrow_back.svg',
                        titleProfileTab: 'صفحه قبل',
                        subTitleProfileTab: 'کاربری',
                        onPressBack: (){
                          AnalyticsHelper().log(AnalyticsEvents.ProfilePg_Back_Btn_Clk);
                          onWillPop();
                          // widget.exitDialog.onPressShowDialog();
                        },
                        isLogoImpo: true,
                        // idReminderTabTarget: feature10,
                      ),
                    ),
                    header(),
                    SizedBox(height: ScreenUtil().setHeight(30)),
                    ListView.builder(
                      itemCount: dummyData.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context,index){
                        if(!womansubscribtion){
                          if(index != 1 && index != 2 && index != 3){
                            return  boxItems(dummyData[index].title, dummyData[index].icon,index);
                          }else{
                            return SizedBox.shrink();
                          }
                        }else{
                          if(getRegisters().status != 1 && index == 2){
                            return SizedBox.shrink();
                          }else{
                            return boxItems(dummyData[index].title, dummyData[index].icon,index);
                          }
                        }
                      },
                    ),
                    StreamBuilder(
                      stream: _profilePresenter.advertis,
                      builder: (context,AsyncSnapshot<AdvertiseViewModel>snapshotAdv){
                        if(snapshotAdv.data != null){
                          return  Padding(
                              padding: EdgeInsets.only(
                                top: ScreenUtil().setWidth(20),
                                right: ScreenUtil().setWidth(50),
                                left: ScreenUtil().setWidth(50),
                                bottom: ScreenUtil().setWidth(40),
                              ),
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
                                        image:'$mediaUrl/file/${snapshotAdv.data!.image}',
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
                                        // splashColor: Colors.lightGreenAccent,
                                        onTap: (){
                                          if(snapshotAdv.data!.typeLink == 1 || snapshotAdv.data!.typeLink == 2){
                                            AnalyticsHelper().log(AnalyticsEvents.ProfilePg_AdvBanner_Banner_Clk);
                                            if(snapshotAdv.data!.typeLink == 1){
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType.fade,
                                                      child:  ClinicQuestionScreen(
                                                        expertPresenter: _expertPresenter,
                                                        bodyTicketInfo: json.decode(snapshotAdv.data!.link),
                                                        // ticketId: ticketsModel.ticketId,
                                                      )
                                                  )
                                              );
                                            }
                                            if(snapshotAdv.data!.typeLink == 2){
                                              if(snapshotAdv.data!.link != ''){
                                                Timer(Duration(milliseconds: 300),(){
                                                  _launchURLAdv(snapshotAdv.data!.link,snapshotAdv.data!.id);
                                                });
                                              }
                                            }
                                          }
                                        },
                                        child: Container(
                                          height: ScreenUtil().setWidth(145),
                                        )
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
                          );
                        }else{
                          return Container();
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(50),
                          // top: ScreenUtil().setWidth(30),
                          bottom: ScreenUtil().setWidth(30)
                      ),
                      child:   Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: List.generate(aboutIcons.length, (index) {
                            return itemAbout(index);
                          })
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(50)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FutureBuilder(
                          future: getProfile(),
                          builder: (context,snapshot){
                            if(snapshot.data != null){
                              return Text(
                                'کاربری شما: ${snapshot.data}',
                                style: context.textTheme.labelSmall!.copyWith(
                                  color: Color(0xffA8A8A8),
                                ),
                              );
                            }else{
                              return Container();
                            }
                          },
                        ),
                        FutureBuilder(
                          future: getVersion(),
                          builder: (context,snapshot){
                            if(snapshot.data != null){
                              return  Text(
                                'نسخه (myket)${snapshot.data}',
                                /// myket , cafeBazaar , direct , drt , googlePlay
                                style: context.textTheme.labelSmall!.copyWith(
                                  color: Color(0xffA8A8A8),
                                ),
                              );
                            }else{
                              return  Container();
                            }
                          },
                        )
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                  ],
                ),
              ),
              StreamBuilder(
                stream: _profilePresenter.isShowPregnancyDialogObserve,
                builder: (context,AsyncSnapshot<bool>snapshotPregnancyDialog) {
                  if (snapshotPregnancyDialog.data != null) {
                    if (snapshotPregnancyDialog.data!) {
                      return   QusDialog(
                        scaleAnim: _profilePresenter.dialogScaleObserve,
                        onPressCancel: (){
                          _profilePresenter.cancelPregnancyDialog();
                        },
                        title: '${_profilePresenter.getRegister().name} جان',
                        value: 'مطمئنی می‌خوای از فاز قاعدگی خارج بشی و از فاز بارداری استفاده کنی؟' ,
                        yesText: 'آره باردار شدم',
                        noText: 'نه',
                        onPressYes: () async {
                          _profilePresenter.cancelPregnancyDialog();
                            AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_ImPregnantYesDlg_Btn_Clk_BtmSht);
                            Navigator.push(context,
                                PageTransition(
                                    settings: RouteSettings(name: "/Page1"),
                                    type: PageTransitionType.topToBottom,
                                    child:  ChangeStatusScreen()
                                )
                            );
                        },
                        colors: [
                          Colors.white,
                          Colors.white
                        ],
                        topIcon: 'assets/images/ic_box_question.svg',
                        isIcon: true,
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
          ),
        ),
      )
    );
  }

 Future<String> getVersion()async {
   PackageInfo packageInfo = await PackageInfo.fromPlatform();
   String version = packageInfo.version;
   return version;
 }

 Future<String?> getProfile()async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   return prefs.getString('userName');
 }

   clickOnBanner(String id) async {
   var register = locator<RegisterParamModel>();
   Map responseBody = await Http().sendRequest(
       womanUrl, 'report/msgmotival/$id', 'POST', {}, register.register.token!);
   print(responseBody);
 }


 Future<bool> _launchURLAdv(String url,String? id) async {
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
   if (!await launchUrl(Uri.parse(httpUrl))) throw 'Could not launch $httpUrl';
   // if (await canLaunch(httpUrl)) {
   //   await launch(httpUrl);
   // } else {
   //   throw 'Could not launch $httpUrl';
   // }
   return true;
 }



 Future<bool> _launchURL(String url) async {
   String httpUrl = '';
   if(url.startsWith('http')){
     httpUrl = url;
   }else{
     httpUrl = 'https://$url';
   }
   if (!await launchUrl(Uri.parse(httpUrl))) throw 'Could not launch $httpUrl';
   // if (await canLaunch(httpUrl)) {
   //   await launch(httpUrl);
   // } else {
   //   throw 'Could not launch $httpUrl';
   // }
   return true;
 }

 header(){
    return SizedBox(
      height: ScreenUtil().setWidth(350),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(25),
            ),
            height: ScreenUtil().setWidth(300),
            color: Color(0xffFEF4FC),
            child:   Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/profile_user.svg',
                  ),
                  SizedBox(height: ScreenUtil().setWidth(20)),
                  Text(
                    _profilePresenter.getProfileAllData().name!,
                    style: context.textTheme.bodyMedium,
                  ),
                  Text(
                    _profilePresenter.getProfileAllData().userName!,
                    style: context.textTheme.bodySmall,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width - ScreenUtil().setWidth(60),
              margin: EdgeInsets.only(
                top: ScreenUtil().setWidth(30),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(20),
                  vertical: ScreenUtil().setWidth(20)
              ),
              decoration: BoxDecoration(
                  color: Color(0xffBE4695),
                  borderRadius: BorderRadius.circular(12)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _profilePresenter.getProfileAllData().subText!,
                    style: context.textTheme.labelSmall!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  CustomButton(
                    title:  _profilePresenter.getProfileAllData().subButtonText,
                    height: ScreenUtil().setWidth(60),
                    onPress: (){
                      AnalyticsHelper().log(AnalyticsEvents.ProfilePg_Subscribe_Btn_Clk);
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child:  ChooseSubscriptionPage(
                                isSub:  _profilePresenter.getProfileAllData().hasSubscritbion!,
                              )
                          )
                      );
                    },
                    margin: 0,
                    textColor: ColorPallet().mainColor,
                    colors: [Colors.white,Colors.white],
                    borderRadius: 16.0,
                    enableButton: true,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
 }

 itemAbout(index){
   return  StreamBuilder(
     stream: _animations.squareScaleBackButtonObserve,
     builder: (context,AsyncSnapshot<double>snapshotScale){
       if(snapshotScale.data != null){
         return  Transform.scale(
           scale: modePress == 1 && aboutIcons[index].isSelected ? snapshotScale.data : 1.0,
           child:  GestureDetector(
             onTap: (){
               print(index);
               switch(index){
                 case 0: AnalyticsHelper().log(AnalyticsEvents.ProfilePg_Browser_Icon_Clk);
                 break;
                 case 1:  AnalyticsHelper().log(AnalyticsEvents.ProfilePg_Telegram_Icon_Clk);
                 break;
                 case 2: AnalyticsHelper().log(AnalyticsEvents.ProfilePg_Twitter_Icon_Clk);
                 break;
                 case 3:AnalyticsHelper().log(AnalyticsEvents.ProfilePg_Instagram_Icon_Clk);
                 break;
               }
               setState(() {
                 modePress = 1;
               });
               animationControllerScaleButtons.reverse();

               for(int i=0 ; i<aboutIcons.length ; i++){
                 aboutIcons[i].isSelected = false;
               }

               aboutIcons[index].isSelected = !aboutIcons[index].isSelected;

               _launchURL(aboutIcons[index].url!);
             },
             child:  Container(
               height: ScreenUtil().setWidth(50),
               width: ScreenUtil().setWidth(50),
               margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15)),
               child:  SvgPicture.asset(
                 aboutIcons[index].icon!,
                 fit: BoxFit.fitWidth,
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



  Widget boxItems(title , icon,index){

    return  StreamBuilder(
      stream: _animations.squareScaleBackButtonObserve,
      builder: (context,AsyncSnapshot<double>snapshotScale){
        if(snapshotScale.data != null){
          return  Transform.scale(
            scale: dummyData[index].selected! && modePress == 0  ? snapshotScale.data != null ? snapshotScale.data : 0.7 : 1.0,
            child:  GestureDetector(
              onTap: ()async{
                // getPass();
                switch(index){
                  case 0: AnalyticsHelper().log(AnalyticsEvents.ProfilePg_MyImpoItem_Btn_Clk);
                  break;
                  case 1:  AnalyticsHelper().log(AnalyticsEvents.ProfilePg_ReportingItem_Btn_Clk);
                  break;
                  case 2: AnalyticsHelper().log(AnalyticsEvents.ProfilePg_Pregnancy_Btn_Clk);
                  break;
                  case 3: AnalyticsHelper().log(AnalyticsEvents.ProfilePg_PartnerItem_Btn_Clk);
                  break;
                  case 4:  AnalyticsHelper().log(AnalyticsEvents.ProfilePg_EnterFaceCode_Btn_Clk);
                  break;
                  case 5:  AnalyticsHelper().log(AnalyticsEvents.ProfilePg_Support_Btn_Clk);
                  break;
                  case 6:  AnalyticsHelper().log(AnalyticsEvents.ProfilePg_ContactImpo_Btn_Clk);
                  break;
                  case 7:  AnalyticsHelper().log(AnalyticsEvents.ProfilePg_AboutItem_Btn_Clk);
                  break;
                  case 8:  AnalyticsHelper().log(AnalyticsEvents.ProfilePg_Update_Btn_Clk);
                  break;
                  /// case 8:  AnalyticsHelper().log(AnalyticsEvents.ProfilePg_SendRate_Btn_Clk);
                  /// break;
                }
                setState(() {
                  modePress = 0;
                });
                  animationControllerScaleButtons.reverse();
                setState(() {

                  if(listBoxChangeCircles != null){
                    for(int i=0 ; i<listBoxChangeCircles!.length ; i++){

                      listBoxChangeCircles![i].selected = false;

                    }
                  }

                  for(int i=0 ; i <dummyData.length; i++){
                    if(dummyData[i].selected!){
                      dummyData[i].selected = false;
                    }
                  }

                  dummyData[index].selected = !dummyData[index].selected!;
                  if(index != 2){
                    Timer(Duration(milliseconds: 100),()async{
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              duration: Duration(milliseconds: 500),
                              child: index == 0 ?
                              MyImpoScreen(
                                presenter: _profilePresenter,
                              )  :
                               index == 1 ?
                               ReportingScreen(
                                 name: registerModel.name,
                                 expertPresenter: _expertPresenter,
                               ) :
                               index == 3 ?
                              PartnerScreen()
                                  : index == 4 ?
                              EnterFaceCodeScreen()
                                  : index == 5 ?
                               SupportScreen(
                                 categoryId: '',
                                 fromNotify: false,
                               )
                                  : index == 6 ?
                              ContactImpoScreen() :
                              index == 7 ?
                              AboutScreen() :
                              UpdateScreen(
                                presenter: _profilePresenter,
                              )
                          )
                      );
                      // }
                    });
                   }else{
                    _profilePresenter.showPregnancyDialog();
                   }

                });
              },
                // 'اینجا می‌تونی وضعیت همدلت رو ببینی و تغییر بدی و نوع رابطه ت رو باهاش مشخص کنی'
              child: index == 0?
                  tabTargetItems(title, icon,'از اینجا می‌تونی اطلاعات کاربری، رمز قفل و وضعیت نوتیفای رو تصحیح کنی', feature9,index) :
              index == 1 ?
              tabTargetItems(title, icon,getRegisters().status == 3 ?
              'از این قسمت می‌تونی گزارش دوره های قبلی پریودت رو ببینی. توجه داشته باش که در دوران پس از زایمان امکان گرفتن گزارش وجود نداره' :
              getRegisters().status == 2 ?
              'از این قسمت می‌تونی گزارش دوره های قبلی پریودت رو ببینی. توجه داشته باش که در دوران بارداری امکان گرفتن گزارش وجود نداره' :
              'از این قسمت می‌تونی برای دیدن و گزارش‌گیری دوره‌ های قبلی پریودت استفاده کنی', feature101,index) :
                   index == 3 ?
                   tabTargetItems(title, icon,'اینجا می‌تونی وضعیت همدلت رو ببینی و تغییر بدی و نوع رابطه ت رو باهاش مشخص کنی', feature102,index) :
                   index == 6 ?
                   tabTargetItems(title, icon,'از اینجا می‌تونی در تلگرام با ما در ارتباط باشی', feature103,index)
                  : Container(
                  padding: EdgeInsets.only(
                    right: ScreenUtil().setWidth(10),
                    left: ScreenUtil().setWidth(10),
                    bottom: ScreenUtil().setWidth(15),
                  ),
                  margin: EdgeInsets.only(
                      bottom: ScreenUtil().setWidth(50),
                      right: ScreenUtil().setWidth(60),
                      left: ScreenUtil().setWidth(60)
                  ),
                  decoration:  BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(
                            color: ColorPallet().gray.withOpacity(0.5),
                            width: ScreenUtil().setWidth(1)
                        )
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: <Widget>[
                          index == 2 || index == 4 || index == 5  || index == 8 || index == 9 ?
                          Image.asset(
                            icon,
                            width: ScreenUtil().setWidth(50),
                            height: ScreenUtil().setWidth(50),
                          ) :
                          SvgPicture.asset(
                            icon,
                            width: ScreenUtil().setWidth(50),
                            height: ScreenUtil().setWidth(50),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(20)),
                          Text(
                            title,
                            style: context.textTheme.labelLarge,
                          ),
                        ],
                      ),
                      SvgPicture.asset(
                        'assets/images/ic_arrow_back.svg',
                        width: ScreenUtil().setWidth(30),
                        height: ScreenUtil().setWidth(30),
                        colorFilter: ColorFilter.mode(
                          ColorPallet().black,
                          BlendMode.srcIn
                        ),
                      )
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

 Widget tabTargetItems(title,icon,description,featureId,index){
   return Container(
       padding: EdgeInsets.only(
         right: ScreenUtil().setWidth(10),
         left: ScreenUtil().setWidth(10),
         bottom: ScreenUtil().setWidth(15),
       ),
       margin: EdgeInsets.only(
           bottom: ScreenUtil().setWidth(50),
           right: ScreenUtil().setWidth(60),
           left: ScreenUtil().setWidth(60)
       ),
       decoration:  BoxDecoration(
         color: Colors.white,
         border: Border(
             bottom: BorderSide(
                 color: ColorPallet().gray.withOpacity(0.5),
                 width: ScreenUtil().setWidth(1)
             )
         ),
       ),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Row(
             children: <Widget>[
               TabTarget(
                 title: title,
                 description: description,
                 contentLocation: index == 0 ? ContentLocation.below : ContentLocation.above,
                 id: featureId,
                 icon:  index == 2 || index == 4 || index == 5 || index == 8 || index == 9   ?
                 Image.asset(
                   icon,
                   width: ScreenUtil().setWidth(70),
                   height: ScreenUtil().setWidth(70),
                 ) :
                 SvgPicture.asset(
                   icon,
                   // width: index == 2 ? ScreenUtil().setWidth(47) : index == 0 ? ScreenUtil().setWidth(42) :  ScreenUtil().setWidth(40),
                   // height: index == 2 ? ScreenUtil().setWidth(47) : index == 0 ? ScreenUtil().setWidth(42) :  ScreenUtil().setWidth(40),
                   width: ScreenUtil().setWidth(70),
                   height: ScreenUtil().setWidth(70),
                 ),
                 child: index == 2 || index == 4 || index == 5 || index == 8 || index == 9 ?
                 Image.asset(
                   icon,
                   width: ScreenUtil().setWidth(50),
                   height: ScreenUtil().setWidth(50),
                 ) :
                 SvgPicture.asset(
                   icon,
                   // width: index == 2 ? ScreenUtil().setWidth(47) : index == 0 ? ScreenUtil().setWidth(42) :  ScreenUtil().setWidth(40),
                   // height: index == 2 ? ScreenUtil().setWidth(47) : index == 0 ? ScreenUtil().setWidth(42) :  ScreenUtil().setWidth(40),
                   width: ScreenUtil().setWidth(50),
                   height: ScreenUtil().setWidth(50),
                 ),
               ),
               SizedBox(width: ScreenUtil().setWidth(20)),
               Text(
                 title,
                 textAlign: TextAlign.justify,
                 style: context.textTheme.labelLarge,
               ),
             ],
           ),
           SvgPicture.asset(
             'assets/images/ic_arrow_back.svg',
             width: ScreenUtil().setWidth(30),
             height: ScreenUtil().setWidth(30),
             colorFilter: ColorFilter.mode(
               ColorPallet().black,
               BlendMode.srcIn
             ),
           )
         ],
       )
   );
 }

 sendRate()async{
    if(typeStore == 1){
      await commentCafe();
    }else if(typeStore ==2){
      await commentMyket();
    }
 }

 commentCafe()async{
   final AndroidIntent intent = AndroidIntent(
     action: 'android.intent.action.EDIT',
     package: 'ir.duck.impo',
     data: 'bazaar://details?id=ir.duck.impo', // replace com.example.app with your applicationId
   );
   await intent.launch();
 }

 commentMyket()async{
   final AndroidIntent intent = AndroidIntent(
     action: 'action_view',
     package: 'ir.duck.impo',
     data: 'myket://comment?id=ir.duck.impo', // replace com.example.app with your applicationId
   );
   await intent.launch();
 }

  @override
  void onError(msg) {
  }

  @override
  void onSuccess(msg){

  }

}