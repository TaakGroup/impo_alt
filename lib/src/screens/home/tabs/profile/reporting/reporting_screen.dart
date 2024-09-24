import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/expert_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/home/tabs/profile/profile_sceen.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:page_transition/page_transition.dart';
import 'package:impo/src/architecture/presenter/reporting_presenter.dart';
import 'package:impo/src/architecture/view/reporting_view.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../../../../firebase_analytics_helper.dart';
import '../../expert/polar_history_screen.dart';
import 'chart_screen.dart';
import 'package:impo/src/models/reporting/report_era_model.dart';
import 'package:impo/src/architecture/presenter/expert_presenter.dart';
import 'package:impo/src/components/dialogs/qus_dialog.dart';
import 'package:impo/src/models/reporting/history_eras_model.dart';
import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';

class ReportingScreen extends StatefulWidget{
  final ExpertPresenter? expertPresenter;
  final name;

  ReportingScreen({Key? key , this.expertPresenter,this.name}):super(key:key);

  @override
  State<StatefulWidget> createState() => ReportingScreenState();
}



class ReportingScreenState extends State<ReportingScreen> with TickerProviderStateMixin implements ReportingView{

  late ReportingPresenter _presenter;


  ReportingScreenState(){
    _presenter = ReportingPresenter(this);
  }


  late AnimationController animationController;
  Animations _animations =  Animations();

  List<Color> textColorItems = [
    Color(0xffFF67CB),
    Color(0xffFF67CB),
    Color(0xff9076C4),
    Color(0xffD776DD),
  ];

  List<Color> backgroundColorItems = [
    Color(0xffFFE6F7),
    Color(0xffFFE6F7),
    Color(0xffEDE4FF),
    Color(0xffFDE2FF),
  ];

  List<String> iconsHistory = [
    'assets/images/wave_article_1.png',
    'assets/images/wave_article_1.png',
    'assets/images/wave_article_2.png',
    'assets/images/wave_article_3.png',
    'assets/images/wave_article_4.png',
    'assets/images/wave_article_5.png',
    'assets/images/wave_article_6.png',
  ];

  @override
  void initState() {
    animationController = _animations.pressButton(this);
    // widget.expertPresenter.checkNet(false);
    _presenter.getInfoPolar(this);
    // _presenter.initPanelController();
    _presenter.initialDialogScale(this);
    super.initState();
  }

  RegisterParamViewModel getRegister(){
    return widget.expertPresenter!.getRegister();
  }
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // Future<int> getLengthAllCircles()async{
  //   DataBaseProvider db  =  DataBaseProvider();
  //   List<CircleModel> circles = await db.getAllCirclesItem();
  //   return circles.length;
  // }


  @override
  void dispose() {
    _animations.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.ReportingPg_Back_NavBar_Clk);
    Navigator.pushReplacement(
        _scaffoldKey.currentContext!,
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
    //// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = 0.5;
    return WillPopScope(
        onWillPop: _onWillPop,
        child:  Directionality(
          textDirection: TextDirection.rtl,
          child:  Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              body:  StreamBuilder(
                stream: _presenter.isLoadingCafeBazarObserve,
                builder: (context,AsyncSnapshot<bool>snapshotIsLoadingCafeBazar){
                  if(snapshotIsLoadingCafeBazar.data != null){
                    return Stack(
                      children: [
                        StreamBuilder(
                          stream: _presenter.isLoadingObserve,
                          builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                            if(snapshotIsLoading.data != null){
                              if(!snapshotIsLoading.data!){
                                return StreamBuilder(
                                  stream: _presenter.reportEarObserve,
                                  builder: (context,AsyncSnapshot<ReportEraModel>snapshotReportEra){
                                    if(snapshotReportEra.data != null){
                                      return StreamBuilder(
                                        stream: _presenter.reportHistoryObserve,
                                        builder: (context,AsyncSnapshot<ReportHistory>snapshotReportHistory){
                                          if(snapshotReportHistory.data != null){
                                            return  Container(
                                              child:   DefaultTabController(
                                                  length: 2, // length of tabs
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: <Widget>[
                                                        StreamBuilder(
                                                          stream: _presenter.infoAdviceObserve,
                                                          builder: (context,snapshotInfo){
                                                            return   CustomAppBar(
                                                              messages: false,
                                                              profileTab: true,
                                                              isEmptyLeftIcon: true,
                                                              icon: 'assets/images/ic_arrow_back.svg',
                                                              titleProfileTab: 'صفحه قبل',
                                                              subTitleProfileTab: 'گزارش‌ قاعدگی',
                                                              // isPolar: snapshotInfo.data != null ? true : null,
                                                              // valuePolar:   snapshotInfo.data != null && snapshotInfo.data.types.length != 0 ? snapshotInfo.data.currentValue.toString() : null,
                                                              onPressBack: (){
                                                                AnalyticsHelper().log(AnalyticsEvents.ReportingPg_Back_Btn_Clk);
                                                                _onWillPop();
                                                                // widget.exitDialog.onPressShowDialog();
                                                              },
                                                              expertPresenter: widget.expertPresenter,
                                                            );
                                                          },
                                                        ),
                                                        Flexible(
                                                            child:   Column(
                                                              children: [
                                                                Container(
                                                                  margin: EdgeInsets.only(
                                                                      top: ScreenUtil().setWidth(30)
                                                                  ),
                                                                  child: TabBar(
                                                                    controller: _presenter.tabController,
                                                                    labelColor: ColorPallet().mainColor,
                                                                    unselectedLabelColor: ColorPallet().gray,
                                                                    indicatorColor: ColorPallet().mainColor,
                                                                    labelStyle: context.textTheme.bodyMedium,
                                                                    tabs: [
                                                                      Tab(text: 'گزارش‌ قاعدگی'),
                                                                      Tab(text: 'تاریخچه گزارش‌ها'),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Flexible(
                                                                    child:  Padding(
                                                                        padding: EdgeInsets.only(
                                                                            top: ScreenUtil().setWidth(60)
                                                                        ),
                                                                        child:  TabBarView(
                                                                            physics: NeverScrollableScrollPhysics(),
                                                                            controller: _presenter.tabController,
                                                                            children: <Widget>[
                                                                              reportingTab(snapshotReportEra.data!),
                                                                              historyReportingTab(snapshotReportHistory.data!)
                                                                            ]
                                                                        )
                                                                    )
                                                                )
                                                              ],
                                                            )
                                                        )
                                                      ]
                                                  )
                                              ),
                                            );
                                          }else{
                                            return Container();
                                          }
                                        },
                                      );
                                    }else{
                                      return Container();
                                    }
                                  },
                                );
                              }else{
                                return  Center(
                                    child:  StreamBuilder(
                                      stream: _presenter.tryButtonErrorObserve,
                                      builder: (context,AsyncSnapshot<bool>snapshotTryButton){
                                        if(snapshotTryButton.data != null){
                                          if(snapshotTryButton.data!){
                                            return  Padding(
                                                padding: EdgeInsets.only(
                                                    right: ScreenUtil().setWidth(80),
                                                    left: ScreenUtil().setWidth(80),
                                                  top: ScreenUtil().setWidth(200),
                                                ),
                                                child:  Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    StreamBuilder(
                                                      stream: _presenter.valueErrorObserve,
                                                      builder: (context,AsyncSnapshot<String>snapshotValueError){
                                                        if(snapshotValueError.data != null){
                                                          return   Text(
                                                            snapshotValueError.data!,
                                                            textAlign: TextAlign.center,
                                                              style:  context.textTheme.bodyMedium!.copyWith(
                                                                color: Color(0xff707070),
                                                              )
                                                          );
                                                        }else{
                                                          return  Container();
                                                        }
                                                      },
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(
                                                            top: ScreenUtil().setWidth(32)
                                                        ),
                                                        child:    ExpertButton(
                                                          title: 'تلاش مجدد',
                                                          onPress: (){
                                                            _presenter.getEra(this);
                                                          },
                                                          enableButton: true,
                                                          isLoading: false,
                                                        )
                                                    )
                                                  ],
                                                )
                                            );
                                          }else{
                                            return  LoadingViewScreen(
                                                color: ColorPallet().mainColor
                                            );
                                          }
                                        }else{
                                          return  Container();
                                        }
                                      },
                                    )
                                );
                              }
                            }else{
                              return Container();
                            }
                          },
                        ),
                        // SlidingUpPanel(
                        //   controller: _presenter.panelController,
                        //   backdropEnabled: true,
                        //   minHeight: 0,
                        //   backdropColor: Colors.black,
                        //   maxHeight: MediaQuery.of(context).size.height /3.25,
                        //   borderRadius: BorderRadius.only(
                        //       topLeft: Radius.circular(30),
                        //       topRight: Radius.circular(30)
                        //   ),
                        //   panel:  Column(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: <Widget>[
                        //       Container(
                        //         margin: EdgeInsets.only(
                        //             top: ScreenUtil().setWidth(15)
                        //         ),
                        //         height: ScreenUtil().setWidth(5),
                        //         width: ScreenUtil().setWidth(100),
                        //         decoration:  BoxDecoration(
                        //             color: Color(0xff707070).withOpacity(0.2),
                        //             borderRadius: BorderRadius.circular(15)
                        //         ),
                        //       ),
                        //       Flexible(
                        //           child: notPolarPanel()
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        StreamBuilder(
                          stream: _presenter.isShowExitDialogObserve,
                          builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog) {
                            if (snapshotIsShowDialog.data != null) {
                              if (snapshotIsShowDialog.data!) {
                                return  StreamBuilder(
                                  stream: _presenter.selectedEarForBuyObserve,
                                  builder: (context,AsyncSnapshot<EraList>snapshotSelectedEra){
                                    if(snapshotSelectedEra.data != null){
                                      return StreamBuilder(
                                        stream: _presenter.isLoadingButtonObserve,
                                        builder: (context,snapshotIsLoading){
                                          if(snapshotIsLoading.data != null){
                                            return  QusDialog(
                                              scaleAnim: _presenter.dialogScaleObserve,
                                              onPressCancel: _presenter.cancelDialog,
                                              value: 'ایمپویی عزیز\nبرای این ${snapshotSelectedEra.data!.text}،\n${snapshotSelectedEra.data!.polar} تا پولار ازت کم میشه\nمی‌خوای ادامه بدی؟',
                                              yesText: 'بله مطمئنم',
                                              noText: 'نه!',
                                              onPressYes: () {
                                                _presenter.acceptDialog(
                                                    context: context, isDialog: true,expertPresenter: widget.expertPresenter);
                                              },
                                              isIcon: true,
                                              colors: [
                                                Colors.white,
                                                Colors.white,
                                              ],
                                              topIcon: 'assets/images/ic_box_question.svg',
                                              isLoadingButton: snapshotIsLoading.data,
                                            );
                                          }else{
                                            return Container();
                                          }
                                        },
                                      );
                                    }else{
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
                        snapshotIsLoadingCafeBazar.data! ?
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.black.withOpacity(0.8),
                          child: Center(
                              child: Container(
                                padding: EdgeInsets.all(ScreenUtil().setWidth(7)),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child:  LoadingViewScreen(
                                    color: ColorPallet().mainColor
                                ),
                              )
                          ),
                        ) : Container()
                      ],
                    );
                  }else{
                    return Container();
                  }
                },
              )
          ),
        )
    );
  }

  reportingTab(ReportEraModel reportEraModel){
    return Column(
      children: [
        Expanded(
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(380),
                        ),
                        child: SvgPicture.asset(
                          'assets/images/ic_big_reporting.svg',
                          width: ScreenUtil().setWidth(110),
                          height: ScreenUtil().setWidth(110),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: ScreenUtil().setWidth(20),
                        ),
                        child: Text(
                          'گزارش‌ قاعدگی',
                          style:  context.textTheme.headlineSmall!.copyWith(
                            color: ColorPallet().gray,
                          )
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      right: ScreenUtil().setWidth(40),
                      left: ScreenUtil().setWidth(40),
                      top: ScreenUtil().setWidth(40),
                      bottom: ScreenUtil().setWidth(50)
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(20),
                    vertical: ScreenUtil().setWidth(15),
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xffFD9FDD).withOpacity(0.25),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child:   Text(
                    reportEraModel.titleText,
                    textAlign: TextAlign.center,
                    style:  context.textTheme.bodyMedium!.copyWith(
                      color: ColorPallet().mainColor,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(16)
                  ),
                  child: Text(
                    reportEraModel.eraList.length != 0 ? 'انتخاب گزارش جدید بر اساس دوره' : 'برای گزارش‌گیری باید حداقل سه دوره قاعدگی پیاپی رو با ایمپو گذرونده باشی',
                    textAlign: TextAlign.center,
                    style:  context.textTheme.labelMediumProminent!.copyWith(
                      color: ColorPallet().gray,
                    ),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                          top: ScreenUtil().setWidth(40),
                          left: ScreenUtil().setWidth(20),
                          right: ScreenUtil().setWidth(20)
                      ),
                      itemCount: reportEraModel.eraList.length,
                      itemBuilder: (context,index){
                        return itemSelectedCircle(reportEraModel.eraList,index);
                      },
                    )
                )
              ],
            )
        )
      ],
    );
  }

  historyReportingTab(ReportHistory reportHistory){
    return  Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child:  Column(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(500),
                      ),
                      child: SvgPicture.asset(
                        'assets/images/ic_big_historyReporting.svg',
                        width: ScreenUtil().setWidth(140),
                        height: ScreenUtil().setWidth(140),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil().setWidth(20),
                      ),
                      child: Text(
                        'تاریخچه ‌ گزارش‌های شما',
                        style:  context.textTheme.headlineSmall!.copyWith(
                          color: ColorPallet().gray,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(30)),
              Expanded(
                  child: reportHistory.eras.length != 0 ?
                      SingleChildScrollView(
                        child:  ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: reportHistory.eras.length,
                          itemBuilder: (context,index){
                            return itemsHistoryEras(reportHistory,index);
                          },
                        ),
                      )
                      : Center(
                      child: Text(
                        'هنوز هیچ گزارشی وجود ندارد',
                        style:  context.textTheme.bodyMedium!.copyWith(
                          color: Color(0xff707070),
                        ),
                      )
                  )
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget itemSelectedCircle(List<EraList> reportingCircle,index){
    return  StreamBuilder(
      stream: _animations.squareScaleBackButtonObserve,
      builder: (context,AsyncSnapshot<double>snapshotScale){
        if(snapshotScale.data != null){
          return  Transform.scale(
            scale:  reportingCircle[index].isSelected? snapshotScale.data : 1.0,
            child:   GestureDetector(
              onTap: ()async{
                for(int i=0 ; i<reportingCircle.length ; i++){
                  if(this.mounted){
                    setState(() {
                      reportingCircle[i].isSelected = false;
                    });
                  }
                }
                animationController.reverse();
                if(this.mounted){
                  setState(() {
                    reportingCircle[index].isSelected = ! reportingCircle[index].isSelected;
                  });
                }
                AnalyticsHelper().log(
                    AnalyticsEvents.ReportingPg_ReportingList_Item_Clk,
                    parameters: {
                      'id' : reportingCircle[index].id
                    }
                );
                // _presenter.onPressReportForBuy(reportingCircle[index]);
                // _presenter.payCafeBazar(reportingCircle[index], context,widget.randomMessage,widget.expertPresenter);
                //_presenter.payMyket(reportingCircle[index],context,widget.randomMessage, widget.expertPresenter);

                _presenter.payReportCafeBazarAndMykey(reportingCircle[index],context,widget.expertPresenter);
              },
              child:  Container(
                  margin: EdgeInsets.only(
                      bottom: ScreenUtil().setWidth(30),
                      left: ScreenUtil().setWidth(60),
                      right: ScreenUtil().setWidth(60)
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setWidth(20),
                      horizontal: ScreenUtil().setWidth(20)
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xff909FDE).withOpacity(0.25),
                            blurRadius: 10.0
                        )
                      ]
                  ),
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            reportingCircle[index].text,
                            style:  context.textTheme.bodyMedium,
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(
                                // vertical: ScreenUtil().setWidth(5),
                                  horizontal: ScreenUtil().setWidth(40)
                              ),
                              decoration:  BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        ColorPallet().mentalHigh,
                                        ColorPallet().mentalMain,
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight
                                  ),
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child:  Center(
                                child:  Text(
                                  'ورود',
                                  style:  context.textTheme.labelLarge!.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                    ],
                  )
              ),
            ),
          );
        }else{
          return  Container();
        }
      },
    );
  }

  Widget itemsHistoryEras(ReportHistory reportHistory,index){
    return  StreamBuilder(
      stream: _animations.squareScaleBackButtonObserve,
      builder: (context,AsyncSnapshot<double>snapshotScale){
        if(snapshotScale.data != null){
          return  Transform.scale(
            scale:  reportHistory.eras[index].isSelected? snapshotScale.data : 1.0,
            child:   GestureDetector(
                onTap: ()async{
                  for(int i=0 ; i<reportHistory.eras.length ; i++){
                    if(this.mounted){
                      setState(() {
                        reportHistory.eras[i].isSelected = false;
                      });
                    }
                  }
                  await animationController.reverse();
                  if(this.mounted){
                    setState(() {
                      reportHistory.eras[index].isSelected = ! reportHistory.eras[index].isSelected;
                    });
                  }
                  AnalyticsHelper().log(AnalyticsEvents.ReportingPg_HistoryReportingList_Item_Clk);
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child:  ChartScreen(
                            limit: reportHistory.eras[index].eras.length,
                            historyEra : reportHistory.eras[index],
                            expertPresenter: widget.expertPresenter,
                            name: widget.name,
                            infoAdviceTypes: reportHistory.clinic,
                          )
                      )
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      right: ScreenUtil().setWidth(50),
                      left: ScreenUtil().setWidth(50),
                      top: ScreenUtil().setWidth(50),
                      bottom: index == reportHistory.eras.length -1 ? ScreenUtil().setWidth(50) : 0
                  ),
                  child: Container(
                      padding: EdgeInsets.only(
                        right: ScreenUtil().setWidth(25),
                        left: ScreenUtil().setWidth(10),
                        top: ScreenUtil().setWidth(40),
                        bottom: ScreenUtil().setWidth(20),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xffDBDBDB).withOpacity(0.4),
                              blurRadius: 5.0
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  reportHistory.eras[index].title,
                                  style: context.textTheme.bodyMedium!.copyWith(
                                    color: ColorPallet().mainColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height:ScreenUtil().setHeight(35)),
                          Text(
                            reportHistory.eras[index].description,
                            style: context.textTheme.labelMediumProminent!.copyWith(
                              color: ColorPallet().gray,
                            ),
                          ),
                          SizedBox(height:ScreenUtil().setHeight(35)),
                          Row(
                            children: [
                              Text(
                                'تاریخ تهیه گزارش :',
                                style:  context.textTheme.bodySmall!.copyWith(
                                  color: ColorPallet().gray.withOpacity(0.5),
                                ),
                              ),
                              Text(
                                reportHistory.eras[index].createDate,
                                style:  context.textTheme.bodySmall!.copyWith(
                                  color: ColorPallet().gray.withOpacity(0.5),
                                ),
                              ),
                              Text(
                                '   ساعت ',
                                style:  context.textTheme.bodySmall!.copyWith(
                                  color: ColorPallet().gray.withOpacity(0.5),
                                ),
                              ),
                              Text(
                                reportHistory.eras[index].createTime,
                                style:  context.textTheme.bodySmall!.copyWith(
                                  color: ColorPallet().gray.withOpacity(0.5),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                  ),
                )
            ),
          );
        }else{
          return  Container();
        }
      },
    );
  }

  // Widget notPolarPanel(){
  //   return   Column(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: <Widget>[
  //       Padding(
  //         padding: EdgeInsets.only(
  //             top: ScreenUtil().setWidth(35)
  //         ),
  //         child:  Text(
  //           '${widget.name} جان\nموجودی پولار شما کافی نیست\nجهت افزایش موجودی پولار وارد ایمپو بانک شوید',
  //           textAlign: TextAlign.center,
  //           style:  TextStyle(
  //               color: Color(0xff707070),
  //               fontWeight: FontWeight.w500,
  //               fontSize: ScreenUtil().setSp(34),
  //               height: ScreenUtil().setWidth(3)
  //           ),
  //         ),
  //       ),
  //       Padding(
  //           padding: EdgeInsets.symmetric(
  //               vertical: ScreenUtil().setWidth(20)
  //           ),
  //           child:   ExpertButton(
  //             title: 'ورود به ایمپو بانک',
  //             onPress: (){
  //               _presenter.panelController.close();
  //               Navigator.push(
  //                   context,
  //                   PageTransition(
  //                       type: PageTransitionType.fade,
  //                       child:  PolarHistoryScreen(
  //                         expertPresenter: widget.expertPresenter,
  //                       )
  //                   )
  //                   // PageTransition(
  //                   //     type: PageTransitionType.fade,
  //                   //     child:  ShopScreen(
  //                   //       expertPresenter: widget.expertPresenter,
  //                   //       fromScreen: 2,
  //                   //       name: widget.name,
  //                   //     )
  //                   // )
  //               );
  //             },
  //             enableButton: true,
  //             isLoading: false,
  //           )
  //       )
  //     ],
  //   );
  // }


  @override
  void onError(msg) {
  }

  @override
  void onSuccess(value) {
  }

}

// class ReportingCircle{
//  final String title;
//  final price;
//  bool isSelected = false;
//   int totalCircle = 0;
//
//   ReportingCircle({this.title,this.price,this.isSelected,this.totalCircle});
// }

// List<ReportingCircle> reportingCircles = [
//
//    ReportingCircle(title: 'گزارش تمام دوره ها',price: '30 پولار',isSelected: false,totalCircle: 0),
//    ReportingCircle(title: 'گزارش سه دوره',price: '5 پولار',isSelected: false,totalCircle: 3),
//    ReportingCircle(title: 'گزارش شش دوره',price: '10 پولار',isSelected: false,totalCircle: 6),
//    ReportingCircle(title: 'گزارش دوازده دوره',price: '15 پولار',isSelected: false,totalCircle: 12)
//
// ];
