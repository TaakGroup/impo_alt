import 'dart:async';
import 'dart:convert';
import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/daily_message_presenter.dart';
import 'package:impo/src/architecture/presenter/partner_tab_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/box_messages.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/expert_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/models/advertise_model.dart';
import 'package:impo/src/models/challenge/get_challenge_model.dart';
import 'package:impo/src/models/partnerBioRhythm/partner_biorhythm_view_model.dart';
import 'package:impo/src/screens/home/tabs/partnerTab/widgets/header_partner_widget.dart';
import 'package:impo/src/screens/home/tabs/partnerTab/widgets/no_partner_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../architecture/presenter/expert_presenter.dart';
import '../../../../../data/locator.dart';
import '../../../../../firebase_analytics_helper.dart';
import '../../../../../models/register/register_parameters_model.dart';
import '../../expert/clinic_question_screen.dart';

class PartnerTabScreen extends StatefulWidget {
  final PartnerTabPresenter? partnerTabPresenter;
  final ExpertPresenter? expertPresenter;


  PartnerTabScreen({Key? key,this.partnerTabPresenter,this.expertPresenter}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PartnerTabScreenState();
}

class PartnerTabScreenState extends State<PartnerTabScreen> with WidgetsBindingObserver , TickerProviderStateMixin {

  late DailyMessagePresenter _dailyMessagePresenter;
  //
  PartnerTabScreenState(){
    _dailyMessagePresenter = DailyMessagePresenter();
  }

  late AnimationController animationControllerScaleButton;
  Animations _animations = Animations();

  static const String feature601 = 'feature601'
  ,feature602 = 'feature602',
      feature603 = 'feature603';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FeatureDiscovery.discoverFeatures(
        context,
        const <String>{
          feature601,
          feature602,
          feature603,
        },
      );
    });
    widget.partnerTabPresenter!.getAdvertise();
    animationControllerScaleButton = _animations.pressButton(this);
    widget.partnerTabPresenter!.initialDialogScale(this);
    widget.partnerTabPresenter!.getManInfo(context,false);
    initFireBase();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // init();
  }

  initFireBase(){
    FirebaseMessaging.onMessage.listen((event) {
      debugPrint("onMessage: ${event.data}");
      if(event.data['type'] != null){
        String type = event.data['type'];
        if(type == '50'){
          widget.partnerTabPresenter!.getRequest(false,context);
        }else if(type == '51'){
          widget.partnerTabPresenter!.getManInfo(context,true);
        }else if(type == '52'){
          widget.partnerTabPresenter!.getRequest(false,context);
        }
      }
    });
  }

  // double widthChart = 0;
  //
  // init() {
  //   Timer(Duration(milliseconds: 100), () {
  //     setState(() {
  //       widthChart = MediaQuery.of(context).size.width;
  //     });
  //   });
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // if(state == AppLifecycleState.paused){
    // _presenter.cancelTimer();
    // }else if(state == AppLifecycleState.resumed){
    //   _presenter.getPair(context);
    // }
    if(state == AppLifecycleState.resumed){
      if(!widget.partnerTabPresenter!.exitPartner.stream.value){
        widget.partnerTabPresenter!.getManInfo(context,true);
      }
    }
  }

  @override
  void dispose() {
    animationControllerScaleButton.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }



  clickOnBanner(String id) async {
    var register = locator<RegisterParamModel>();
    Map responseBody = await Http().sendRequest(
        womanUrl, 'report/msgmotival/$id', 'POST', {}, register.register.token!);
    print(responseBody);
  }


  Future<bool> _launchURL(String url,String? id) async {
    if(id != null){
      if(id != ''){
        clickOnBanner(id);
      }
    }
    String httpUrl = '';
    if (url.startsWith('http')) {
      httpUrl = url;
    } else {
      httpUrl = 'https://$url';
    }
    // if (await canLaunch(httpUrl)) {
    //   await launch(httpUrl);
    // } else {
    //   throw 'Could not launch $httpUrl';
    // }
    if (!await launchUrl(Uri.parse(httpUrl))) throw 'Could not launch $httpUrl';
    return true;
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = .5;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark ,
            statusBarBrightness:  Brightness.light,
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              StreamBuilder(
                stream: widget.partnerTabPresenter!.isLoadingObserve,
                builder: (context,AsyncSnapshot<bool>snapshotIsLoading) {
                  if (snapshotIsLoading.data != null) {
                    if (!snapshotIsLoading.data!) {
                      return StreamBuilder(
                        stream: widget.partnerTabPresenter!.exitPartnerObserve,
                        builder: (context,AsyncSnapshot<bool>snapshotExitPartner) {
                          if (snapshotExitPartner.data != null) {
                            if (snapshotExitPartner.data!) {
                              return Column(
                                children: [
                                  snapshotExitPartner.data! ?
                                  StreamBuilder(
                                      stream: widget.partnerTabPresenter!.challengeObserve,
                                      builder: (context,AsyncSnapshot<GetChallengeModel>getChallenge){
                                        if(getChallenge.data != null){
                                          return HeaderPartnerWidget(
                                            challenge: getChallenge.data,
                                            dailyMessagePresenter: _dailyMessagePresenter,
                                            partnerTabPresenter: widget.partnerTabPresenter,
                                          );
                                        }else{
                                          return Container();
                                        }
                                      }
                                  ) :
                                  SizedBox.shrink(),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: ScreenUtil().setWidth(50),
                                      right: ScreenUtil().setWidth(50),
                                      left: ScreenUtil().setWidth(50),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
                                              child: Text(
                                                'حال همدلت',
                                                style: context.textTheme.headlineSmall,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_Whatisabiorhythm_Text_Clk);
                                                widget.partnerTabPresenter!.bioritmShowDialog();
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    height: ScreenUtil().setWidth(45),
                                                    width: ScreenUtil().setWidth(45),
                                                    child: SvgPicture.asset('assets/images/info_outline.svg'),
                                                  ),
                                                  SizedBox(width: ScreenUtil().setWidth(15)),
                                                  Text(
                                                    'بیوریتم چیست؟',
                                                    style: context.textTheme.bodyMedium,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(18), vertical: ScreenUtil().setWidth(0)),
                                          // height: MediaQuery.of(context).size.height/3.1,
                                          margin: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [BoxShadow(color: Color(0xff909FDE).withOpacity(0.3), blurRadius: 8.0)],
                                              borderRadius: BorderRadius.circular(15)),
                                          child: Column(
                                            children: [
                                              StreamBuilder(
                                                stream: widget.partnerTabPresenter!.bioRhythmsObserve,
                                                builder: (context, AsyncSnapshot<List<PartnerBioRhythmViewModel>> snapshotBiorhythms) {
                                                  if (snapshotBiorhythms.data != null) {
                                                    if (snapshotBiorhythms.data!.length != 0) {
                                                      return Container(
                                                          height: ScreenUtil().setWidth(160),
                                                          padding: EdgeInsets.symmetric(
                                                            horizontal: ScreenUtil().setWidth(30),
                                                          ),
                                                          margin: EdgeInsets.only(top: ScreenUtil().setWidth(24)),
                                                          width: MediaQuery.of(context).size.width,
                                                          decoration: BoxDecoration(
                                                            color: ColorPallet().backColor.withOpacity(.1),
                                                            border: Border.all(
                                                                color: snapshotBiorhythms.data![0].isSelected
                                                                    ? ColorPallet().powerHigh
                                                                    : snapshotBiorhythms.data![1].isSelected
                                                                    ? ColorPallet().emotionalHigh
                                                                    : ColorPallet().mentalHigh),
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                          child: StreamBuilder(
                                                            stream: widget.partnerTabPresenter!.messageRandomBioObserve,
                                                            builder: (context, snapshotMessageBio) {
                                                              if (snapshotMessageBio.data != null) {
                                                                return Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      '${snapshotMessageBio.data}',
                                                                      textAlign: TextAlign.start,
                                                                      style: context.textTheme.bodySmall,
                                                                    ),
                                                                  ],
                                                                );
                                                              } else {
                                                                return Container();
                                                              }
                                                            },
                                                          ));
                                                    } else {
                                                      return Container();
                                                    }
                                                  } else {
                                                    return Container();
                                                  }
                                                },
                                              ),
                                              StreamBuilder(
                                                stream: widget.partnerTabPresenter!.bioRhythmsObserve,
                                                builder: (context, AsyncSnapshot<List<PartnerBioRhythmViewModel>> snapshotBioRhythms) {
                                                  if (snapshotBioRhythms.data != null) {
                                                    if (snapshotBioRhythms.data!.length != 0) {
                                                      var Percent = snapshotBioRhythms.data;
                                                      return Container(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            SizedBox(
                                                              height: ScreenUtil().setHeight(20),
                                                            ),
                                                            snapshotBioRhythms.data![0].mainPersent == 50 ||
                                                                snapshotBioRhythms.data![1].mainPersent == 50 ||
                                                                snapshotBioRhythms.data![2].mainPersent == 50
                                                                ? GestureDetector(
                                                              onTap: () {
                                                                AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_Whatisacriticalday_Text_Clk);
                                                                widget.partnerTabPresenter!.ceriticalShowDialog();
                                                              },
                                                              child: Padding(
                                                                padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                                                                child: Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                  children: [
                                                                    SizedBox(
                                                                      height: ScreenUtil().setWidth(45),
                                                                      width: ScreenUtil().setWidth(45),
                                                                      child: SvgPicture.asset('assets/images/info_outline.svg'),
                                                                    ),
                                                                    SizedBox(width: ScreenUtil().setWidth(15)),
                                                                    Container(
                                                                      child: Text(
                                                                        'روز بحرانی چیست؟',
                                                                        style: context.textTheme.bodyMedium,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                                :

                                                            /// hidden
                                                            Container(),
                                                            SizedBox(
                                                              height: ScreenUtil().setHeight(40),
                                                            ),
                                                            Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: List.generate(
                                                                  snapshotBioRhythms.data!.length,
                                                                      (index) => Padding(
                                                                      padding: EdgeInsets.only(
                                                                        bottom: ScreenUtil().setWidth(30),
                                                                      ),
                                                                      child: GestureDetector(
                                                                        onTap: () {
                                                                          widget.partnerTabPresenter!.onPressItemBio(index);
                                                                        },
                                                                        child: Stack(
                                                                          children: [
                                                                            Container(
                                                                              // color: Colors.red,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Container(
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                      boxShadow: [
                                                                                        BoxShadow(
                                                                                          color: Colors.grey.withOpacity(0.18),
                                                                                          //color of shadow
                                                                                          spreadRadius: 4,
                                                                                          //spread radius
                                                                                          blurRadius: 8,
                                                                                          // blur radius
                                                                                          offset: Offset(1, 1),
                                                                                        ),
                                                                                      ],
                                                                                      gradient: LinearGradient(
                                                                                          colors: !snapshotBioRhythms.data![index].isSelected
                                                                                              ? [
                                                                                            Colors.white,
                                                                                            Colors.white,
                                                                                          ]
                                                                                              : snapshotBioRhythms.data![index].gradientIcon!),
                                                                                    ),
                                                                                    child: Center(
                                                                                      child: SvgPicture.asset(
                                                                                        snapshotBioRhythms.data![index].isSelected
                                                                                            ? snapshotBioRhythms.data![index].icon!
                                                                                            : snapshotBioRhythms.data![index].deactiveIcon!,
                                                                                        colorFilter: snapshotBioRhythms.data![index].isSelected ?
                                                                                        ColorFilter.mode(
                                                                                            Colors.white,
                                                                                            BlendMode.srcIn
                                                                                        ) : null,
                                                                                        // color: snapshotBioRhythms.data![index].isSelected
                                                                                        //     ? Colors.white
                                                                                        //     : null,
                                                                                        width: index == 0
                                                                                            ? ScreenUtil().setWidth(54)
                                                                                            : ScreenUtil().setWidth(48),
                                                                                        height: index == 0
                                                                                            ? ScreenUtil().setWidth(54)
                                                                                            : ScreenUtil().setWidth(48),
                                                                                      ),
                                                                                    ),
                                                                                    width: ScreenUtil().setWidth(83),
                                                                                    height: ScreenUtil().setWidth(83),
                                                                                  ),
                                                                                  SizedBox(width: ScreenUtil().setWidth(4)),
                                                                                  Flexible(
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        color: ColorPallet().backColoropacity,
                                                                                        borderRadius: BorderRadius.circular(10),
                                                                                      ),
                                                                                      child: Padding(
                                                                                          padding: EdgeInsets.symmetric(
                                                                                            horizontal: ScreenUtil().setWidth(10),
                                                                                            vertical: ScreenUtil().setWidth(10),
                                                                                          ),
                                                                                          child: snapshotBioRhythms.data![index].mainPersent! <= 20
                                                                                              ? Stack(
                                                                                            children: [
                                                                                              Row(
                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                                children: [
                                                                                                  FDottedLine(
                                                                                                    color: ColorPallet().dottedBorder
                                                                                                        .withOpacity(.6),
                                                                                                    width: MediaQuery.of(context).size.width /
                                                                                                        2.1 -
                                                                                                        (Percent![index].percent!),
                                                                                                    strokeWidth: .45,
                                                                                                    dottedLength: 6.0,
                                                                                                    space: 3.0,
                                                                                                  ),
                                                                                                  Container(
                                                                                                    margin: EdgeInsets.only(
                                                                                                        right: ScreenUtil().setWidth(0)),
                                                                                                    width: Percent[index].percent,
                                                                                                    height: ScreenUtil().setWidth(65),
                                                                                                    decoration: BoxDecoration(
                                                                                                      borderRadius: BorderRadius.circular(8),
                                                                                                      gradient: LinearGradient(
                                                                                                          colors: snapshotBioRhythms
                                                                                                              .data![index].isSelected
                                                                                                              ? snapshotBioRhythms
                                                                                                              .data![index].gradientColors!
                                                                                                              : [
                                                                                                            snapshotBioRhythms
                                                                                                                .data![index].mainColor!,
                                                                                                            snapshotBioRhythms
                                                                                                                .data![index].mainColor!
                                                                                                          ]),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              Positioned(
                                                                                                top: ScreenUtil().setWidth(10),
                                                                                                // left: ScreenUtil().setWidth(1),
                                                                                                left: snapshotBioRhythms
                                                                                                    .data![index].mainPersent ==
                                                                                                    0
                                                                                                    ? (0 -
                                                                                                    ((0 * Percent[index].mainPersent!) /
                                                                                                        100))
                                                                                                    : 199 -
                                                                                                    (199 -
                                                                                                        ((Percent[index].mainPersent! *
                                                                                                            199) /
                                                                                                            100)),
                                                                                                child: Align(
                                                                                                  // alignment: Alignment.center,
                                                                                                  child: Container(
                                                                                                    // width:ScreenUtil().setWidth(100),

                                                                                                    // height: ScreenUtil().setWidth(30),
                                                                                                    color: ColorPallet().backColoropacity,
                                                                                                    child: Padding(
                                                                                                      padding: EdgeInsets.only(
                                                                                                          right: ScreenUtil().setWidth(15),
                                                                                                          left: ScreenUtil().setWidth(8)),
                                                                                                      child: Text(
                                                                                                        '${snapshotBioRhythms.data![index].viewPercent}%',
                                                                                                        textAlign: TextAlign.center,
                                                                                                        style: context.textTheme.labelLarge!.copyWith(
                                                                                                          color: snapshotBioRhythms
                                                                                                              .data![index].isSelected
                                                                                                              ? ColorPallet().black
                                                                                                              : ColorPallet()
                                                                                                              .gray
                                                                                                              .withOpacity(.5),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          )
                                                                                              : snapshotBioRhythms.data![index].mainPersent == 50
                                                                                              ? Container(
                                                                                            width: MediaQuery.of(context).size.width / 2.12,
                                                                                            height: ScreenUtil().setWidth(65),
                                                                                            decoration: BoxDecoration(
                                                                                              color: Colors.transparent,
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                            ),
                                                                                            padding: EdgeInsets.symmetric(
                                                                                              horizontal: ScreenUtil().setWidth(10),
                                                                                              vertical: ScreenUtil().setWidth(10),
                                                                                            ),
                                                                                            child: Row(
                                                                                              mainAxisSize: MainAxisSize.min,
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              children: [
                                                                                                SvgPicture.asset(
                                                                                                  "assets/images/Danger.svg",
                                                                                                  colorFilter: snapshotBioRhythms.data![index].isSelected ?
                                                                                                  null :
                                                                                                  ColorFilter.mode(
                                                                                                      ColorPallet().gray.withOpacity(.5),
                                                                                                      BlendMode.srcIn
                                                                                                  ),
                                                                                                  // color: snapshotBioRhythms
                                                                                                  //     .data![index].isSelected
                                                                                                  //     ? null
                                                                                                  //     : ColorPallet().gray.withOpacity(.5),
                                                                                                  width: ScreenUtil().setWidth(40),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  width: ScreenUtil().setWidth(16),
                                                                                                ),
                                                                                                Text("روز بحرانی",
                                                                                                    textAlign: TextAlign.center,
                                                                                                    style: context.textTheme.bodyMedium!.copyWith(
                                                                                                      color: snapshotBioRhythms
                                                                                                          .data![index].isSelected
                                                                                                          ? ColorPallet().black
                                                                                                          : ColorPallet()
                                                                                                          .gray
                                                                                                          .withOpacity(.5),
                                                                                                    )
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          )
                                                                                              : Row(
                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                            children: [
                                                                                              FDottedLine(
                                                                                                color: ColorPallet()
                                                                                                    .dottedBorder
                                                                                                    .withOpacity(.6),
                                                                                                width: MediaQuery.of(context).size.width /
                                                                                                    2.1 -
                                                                                                    (Percent![index].percent!),
                                                                                                strokeWidth: .45,
                                                                                                dottedLength: 6.0,
                                                                                                space: 3.0,
                                                                                              ),
                                                                                              Container(
                                                                                                  margin: EdgeInsets.only(
                                                                                                      right: ScreenUtil().setWidth(0)),
                                                                                                  width:
                                                                                                  // ScreenUtil().setWidth(200),
                                                                                                  Percent[index].percent,
                                                                                                  height: ScreenUtil().setWidth(65),
                                                                                                  decoration: BoxDecoration(
                                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                                    gradient: LinearGradient(
                                                                                                        colors: snapshotBioRhythms
                                                                                                            .data![index].isSelected
                                                                                                            ? snapshotBioRhythms
                                                                                                            .data![index].gradientColors!
                                                                                                            : [
                                                                                                          snapshotBioRhythms
                                                                                                              .data![index].mainColor!,
                                                                                                          snapshotBioRhythms
                                                                                                              .data![index].mainColor!
                                                                                                        ]),
                                                                                                  ),
                                                                                                  child: Align(
                                                                                                    alignment: Alignment.centerRight,
                                                                                                    child: Padding(
                                                                                                      padding: EdgeInsets.only(
                                                                                                          right: ScreenUtil().setWidth(15)),
                                                                                                      child: Text(
                                                                                                        '${snapshotBioRhythms.data![index].viewPercent}%',
                                                                                                        textAlign: TextAlign.start,
                                                                                                        style: context.textTheme.labelLarge!.copyWith(
                                                                                                          color: snapshotBioRhythms
                                                                                                              .data![index].isSelected
                                                                                                              ? Colors.white
                                                                                                              : ColorPallet()
                                                                                                              .gray
                                                                                                              .withOpacity(.5),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  )),
                                                                                            ],
                                                                                          )),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    width: ScreenUtil().setWidth(102),
                                                                                    child: Text(
                                                                                      snapshotBioRhythms.data![index].title!,
                                                                                      textAlign: TextAlign.center,
                                                                                      style: context.textTheme.bodySmall!.copyWith(
                                                                                        color: snapshotBioRhythms.data![index].isSelected
                                                                                            ? ColorPallet().black
                                                                                            : ColorPallet().gray.withOpacity(.5),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )),
                                                                )),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                    return Container();
                                                  } else {
                                                    return Container();
                                                  }
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                        StreamBuilder(
                                          stream: widget.partnerTabPresenter!.messageListObserve,
                                          builder: (context, AsyncSnapshot<List<String>> snapshotMessageList) {
                                            if (snapshotMessageList.data != null) {
                                              if (snapshotMessageList.data!.length != 0) {
                                                return Column(
                                                  children: List.generate(snapshotMessageList.data!.length, (index) {
                                                    return BoxMessages(
                                                        value: snapshotMessageList.data![index],
                                                        color: Color(0xffECEDFF),
                                                        borderColor: Color(0xff565AA7),
                                                        pressAnalytics: (){
                                                          if(index == 0){
                                                            AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_HintMessage1_Btn_Clk);
                                                          }else{
                                                            AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_HintMessage2_Btn_Clk);
                                                          }
                                                        },
                                                        margin: 0);
                                                  }),
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
                                          stream: widget.partnerTabPresenter!.advertis,
                                          builder: (context, AsyncSnapshot<AdvertiseViewModel> snapshotAdv) {
                                            if (snapshotAdv.data != null) {
                                              return Padding(
                                                  padding: EdgeInsets.only(
                                                    top: ScreenUtil().setWidth(20),
                                                    bottom: ScreenUtil().setWidth(10),
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
                                                                AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_PartnerAdvBanner_Banner_Clk);
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
                                                            )),
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
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                        SizedBox(height: ScreenUtil().setHeight(60))
                                      ],
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return NoPartnerWidget(
                                partnerTabPresenter: widget.partnerTabPresenter,
                              );
                            }
                          } else {
                            return Container();
                          }
                        },
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height/3
                        ),
                        child: StreamBuilder(
                          stream: widget.partnerTabPresenter!.tryButtonErrorObserve,
                          builder: (context,AsyncSnapshot<bool>snapshotTryButton) {
                            if (snapshotTryButton.data != null) {
                              if (snapshotTryButton.data!) {
                                return Padding(
                                    padding: EdgeInsets.only(
                                        right: ScreenUtil().setWidth(80),
                                        left: ScreenUtil().setWidth(80),
                                        top: ScreenUtil().setWidth(200)
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        StreamBuilder(
                                          stream: widget.partnerTabPresenter!.valueErrorObserve,
                                          builder: (context,AsyncSnapshot<String>snapshotValueError) {
                                            if (snapshotValueError.data != null) {
                                              return Text(
                                                snapshotValueError.data!,
                                                textAlign: TextAlign.center,
                                                  style:  context.textTheme.bodyMedium!.copyWith(
                                                    color: Color(0xff707070),
                                                  )
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: ScreenUtil().setWidth(32)
                                            ),
                                            child: ExpertButton(
                                              title: 'تلاش مجدد',
                                              onPress: () {
                                                widget.partnerTabPresenter!.getManInfo(context,false);
                                              },
                                              enableButton: true,
                                              isLoading: false,
                                            ))
                                      ],
                                    ));
                              } else {
                                return Center(
                                  child: LoadingViewScreen(color: ColorPallet().mainColor),
                                );
                              }
                            } else {
                              return Container();
                            }
                          },
                        ),
                      );
                    }
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}
