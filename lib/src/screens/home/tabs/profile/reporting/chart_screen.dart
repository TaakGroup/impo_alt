import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/reporting_presenter.dart';
import 'package:impo/src/architecture/presenter/expert_presenter.dart';
import 'package:impo/src/architecture/view/reporting_view.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/reporting/chart_comparison_model.dart';
import 'package:impo/src/models/reporting/chart_timing_model.dart';
import 'package:impo/src/screens/home/tabs/profile/reporting/compare_canvas.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:impo/src/models/reporting/history_eras_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:impo/src/screens/home/tabs/profile/reporting/reporting_screen.dart';
import 'package:impo/src/components/number_to_text.dart';
import '../../../../../components/clinic_box.dart';
import '../../../../../firebase_analytics_helper.dart';
import '../../../../../models/expert/info.dart';


class ChartScreen extends StatefulWidget{
  final limit;
  final HistoryErasModel? historyEra;
  final ExpertPresenter? expertPresenter;
  final name;
  final InfoAdviceTypes? infoAdviceTypes;
  ChartScreen({Key? key,this.limit,this.historyEra,this.expertPresenter,this.name,this.infoAdviceTypes}):super(key:key);

  @override
  State<StatefulWidget> createState() => ChartScreenState();
}

class ChartScreenState extends State<ChartScreen> with TickerProviderStateMixin implements ReportingView{

  late ReportingPresenter _presenter;
  late AnimationController animationControllerScaleButtons;
  Animations _animations =  Animations();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ChartScreenState(){
    _presenter = ReportingPresenter(this);
  }

  late ScrollController controller;
  // int _counter = 0;
  // Uint8List _imageFile;

  int modePress = 0;

  //Create an instance of ScreenshotController
  final doc = pw.Document();
  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.ChartPg_Self_Pg_Load);
    animationControllerScaleButtons = _animations.pressButton(this);
    _presenter.initChart(widget.limit,widget.historyEra);
    controller =  ScrollController();
    super.initState();
  }

  // double maxChartCompare = 550.0;
  // double heightMonths = 98.0;
  // double paddingCircleDayAndPeriodDay = 10.0;
  //
  // double maxChartTiming = 600.0;
  // double leftMarginChatTiming = 7;
  // // double marginHorizontalChartTiming = 80.0;
  // double marginTopChartTiming = 50.0;


  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.ChartPg_Back_NavBar_Clk);
    Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: ReportingScreen(
              name: widget.name,
              expertPresenter: widget.expertPresenter!,
            )
        )
    );
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = 0.5;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    // var heightChartTimingCanvas = height/4.5;
    var heightChartCompareCanvas = height/1.85;
    // double pTodayChartTimingCanvas = ScreenUtil().setWidth(15);
    // double pTodayChartCompareCanvas = ScreenUtil().setWidth(10);
    // double marginLeftCircleDayChartTimingCanvas = ScreenUtil().setWidth(30);
    return WillPopScope(
      onWillPop: _onWillPop,
      child :  Directionality(
        textDirection: TextDirection.ltr,
        child:  Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body:  Column(
            children: <Widget>[
              Directionality(
                textDirection: TextDirection.rtl,
                child :  CustomAppBar(
                  messages: false,
                  profileTab: true,
                  icon: 'assets/images/ic_arrow_back.svg',
                  titleProfileTab: 'صفحه قبل',
                  subTitleProfileTab: 'گزارش ${NumberToText().Convert(widget.limit)} دوره',
                  onPressBack: (){
                    AnalyticsHelper().log(AnalyticsEvents.ChartPg_Back_Btn_Clk);
                    _onWillPop();
                    // widget.exitDialog.onPressShowDialog();
                  },
                  screenController: _presenter.screenshotControllerImpoLogo,
                ),
              ),
               Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                     Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setWidth(30),
                            right: ScreenUtil().setWidth(60)
                        ),
                        child:  Text(
                          'نمودار مقایسه‌ای',
                          textAlign: TextAlign.right,
                          style:  context.textTheme.labelLargeProminent,
                        )
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(20),
                        right: ScreenUtil().setWidth(50),
                        left: width/4.5,
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical : ScreenUtil().setWidth(15),
                          horizontal: ScreenUtil().setWidth(30)
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xfffbfbfb),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'راهنما :',
                              style: context.textTheme.labelMediumProminent!.copyWith(
                                color: ColorPallet().gray,
                              ),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(15),),
                            Row(
                              children: [
                                Container(
                                  height: ScreenUtil().setWidth(20),
                                  width: ScreenUtil().setWidth(20),
                                  decoration: BoxDecoration(
                                      color: ColorPallet().mainColor,
                                      shape: BoxShape.circle
                                  ),
                                ),
                                SizedBox(width: ScreenUtil().setWidth(10),),
                                Text(
                                  'طول دوره',
                                  style:context.textTheme.labelMediumProminent!.copyWith(
                                    color: ColorPallet().mainColor,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(width: ScreenUtil().setWidth(40)),
                            Row(
                              children: [
                                Container(
                                  height: ScreenUtil().setWidth(20),
                                  width: ScreenUtil().setWidth(20),
                                  decoration: BoxDecoration(
                                      color: Color(0xffFFA3E0),
                                      shape: BoxShape.circle
                                  ),
                                ),
                                SizedBox(width: ScreenUtil().setWidth(10),),
                                Text(
                                  'طول پریود',
                                  style: context.textTheme.labelMediumProminent!.copyWith(
                                    color: Color(0xffFFA3E0),
                                 ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ),
                    SizedBox(height: ScreenUtil().setHeight(40)),
                     StreamBuilder(
                      stream: _presenter.circlesCompareObserve,
                      builder: (context,AsyncSnapshot<ChartComparisonModel>snapshotCirclesCompare){
                        if(snapshotCirclesCompare.data != null){
                          return  Container(
                              child:   SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child:  Screenshot(
                                    controller: _presenter.screenshotControllerCompareChart,
                                    child: CustomPaint(
                                        size:  Size(
                                            ScreenUtil().setWidth(300)+(ScreenUtil().setWidth(180)*snapshotCirclesCompare.data!.circles.length)
                                            ,heightChartCompareCanvas
                                        ),
                                        painter: CompareCanvas(
                                          chartComparison: snapshotCirclesCompare.data!,
                                          context: context
                                        )
                                    ),
                                  )
                              )
                          );
                        }else{
                          return  Container();
                        }
                      },
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(30),
                    ),
                    Divider(
                      color: Color(0xfff3f3f3),
                    ),
                     Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setWidth(40),
                            right: ScreenUtil().setWidth(60)
                        ),
                        child: Text(
                          'جدول گزارش‌ قاعدگی',
                          textAlign: TextAlign.right,
                          style:  context.textTheme.labelLargeProminent,
                        )
                    ),
                   Align(
                     alignment: Alignment.center,
                     child:  Container(
                         margin: EdgeInsets.only(
                           top: ScreenUtil().setWidth(20),
                           // right: ScreenUtil().setWidth(50),
                           // left: width/3.5,
                         ),
                         padding: EdgeInsets.symmetric(
                             vertical : ScreenUtil().setWidth(15),
                             horizontal: ScreenUtil().setWidth(30)
                         ),
                         decoration: BoxDecoration(
                             color: Color(0xfffbfbfb),
                             borderRadius: BorderRadius.circular(10)
                         ),
                         child:Text(
                           'جدول زیر گزارشی از تاریخ شروع و پایان پریود\nو طول دوره‌های شماست',
                           textAlign: TextAlign.center,
                           style: context.textTheme.bodyMedium!.copyWith(
                             color: ColorPallet().gray,
                           ),
                         )
                     ),
                   ),
                   Align(
                     alignment: Alignment.centerLeft,
                     child:   StreamBuilder(
                       stream: _presenter.circlesTimingObserve,
                       builder: (context,AsyncSnapshot<ChartTimingModel>snapshotCirclesTiming){
                         if(snapshotCirclesTiming.data != null){
                           return  Padding(
                               padding: EdgeInsets.only(
                                   top: ScreenUtil().setWidth(30)
                               ),
                               child:  Container(
                                   child:   SingleChildScrollView(
                                       scrollDirection: Axis.horizontal,
                                       child:  Screenshot(
                                           controller: _presenter.screenshotControllerTimingChart,
                                           child: Directionality(
                                               textDirection:  TextDirection.ltr,
                                               child : Stack(
                                                 children: [
                                                   Row(
                                                     crossAxisAlignment:CrossAxisAlignment.start,
                                                     children: List.generate(snapshotCirclesTiming.data!.circles.length, (index){
                                                       return Row(
                                                         crossAxisAlignment:CrossAxisAlignment.start,
                                                         children: [
                                                           index == 0 ?
                                                           Container(
                                                             height: ScreenUtil().setWidth(300),
                                                             margin: EdgeInsets.only(
                                                                 right: ScreenUtil().setWidth(20)
                                                             ),
                                                             padding: EdgeInsets.symmetric(
                                                               vertical: ScreenUtil().setWidth(20),
                                                               horizontal: ScreenUtil().setWidth(32),
                                                             ),
                                                             decoration: BoxDecoration(
                                                                 borderRadius: BorderRadius.only(
                                                                     topRight: Radius.circular(10),
                                                                     bottomRight: Radius.circular(10)
                                                                 ),
                                                                 color: Color(0xfff4f4f4)
                                                             ),
                                                             child: Column(
                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                               children: [
                                                                 Container(
                                                                   padding: EdgeInsets.symmetric(
                                                                       horizontal: ScreenUtil().setWidth(20),
                                                                       vertical: ScreenUtil().setWidth(20)
                                                                   ),
                                                                   decoration: BoxDecoration(
                                                                       borderRadius: BorderRadius.circular(10),
                                                                       color: Color(0xfff4f4f4)
                                                                   ),
                                                                 ),
                                                                 Text(
                                                                   'تاریخ شروع پریود',
                                                                   textAlign: TextAlign.center,
                                                                   style: context.textTheme.bodyMedium,
                                                                 ),
                                                                 Text(
                                                                   'تاریخ پایان پریود',
                                                                   textAlign: TextAlign.center,
                                                                   style: context.textTheme.bodyMedium,
                                                                 ),
                                                                 Text(
                                                                   'طول کل دوره',
                                                                   textAlign: TextAlign.center,
                                                                   style: context.textTheme.bodyMedium,
                                                                 ),
                                                               ],
                                                             ),
                                                           ) : Container(),
                                                           Container(
                                                               padding: EdgeInsets.only(
                                                                 // vertical: ScreenUtil().setWidth(20),
                                                                 left: ScreenUtil().setWidth(10),
                                                                 right: ScreenUtil().setWidth(10),
                                                                 bottom: ScreenUtil().setWidth(15),
                                                               ),
                                                               height: ScreenUtil().setWidth(300),
                                                               child: Column(
                                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                 children: [
                                                                   Container(
                                                                     padding: EdgeInsets.symmetric(
                                                                         horizontal: ScreenUtil().setWidth(20),
                                                                         vertical: ScreenUtil().setWidth(20)
                                                                     ),
                                                                     decoration: BoxDecoration(
                                                                         borderRadius: BorderRadius.circular(10),
                                                                         color: Color(0xfff4f4f4)
                                                                     ),
                                                                     child:Text(
                                                                       snapshotCirclesTiming.data!.circles[index].months!,
                                                                       style: context.textTheme.bodyMedium,
                                                                     ),
                                                                   ),
                                                                   Text(
                                                                     snapshotCirclesTiming.data!.circles[index].startPeriodDate!,
                                                                     style: context.textTheme.labelMedium!.copyWith(
                                                                       color: ColorPallet().mainColor
                                                                     ),
                                                                   ),
                                                                   Text(
                                                                     snapshotCirclesTiming.data!.circles[index].endPeriodDate!,
                                                                     style: context.textTheme.labelMedium!.copyWith(
                                                                         color: ColorPallet().mainColor
                                                                     ),
                                                                   ),
                                                                   Text(
                                                                     snapshotCirclesTiming.data!.circles[index].circleDay.toString(),
                                                                     style: context.textTheme.labelMedium!.copyWith(
                                                                         color: ColorPallet().mainColor
                                                                     ),
                                                                   )
                                                                 ],
                                                               )
                                                           )
                                                         ],
                                                       );
                                                     }),
                                                   ),
                                                   Container(
                                                     width: (snapshotCirclesTiming.data!.circles.length * ScreenUtil().setWidth(210)) + ScreenUtil().setWidth(240),
                                                     height: ScreenUtil().setWidth(1),
                                                     color: Colors.grey.withOpacity(0.5),
                                                     margin: EdgeInsets.only(
                                                       top: ScreenUtil().setWidth(300)/2 + ScreenUtil().setWidth(10) ,
                                                     ),
                                                   ),
                                                   Container(
                                                     width: (snapshotCirclesTiming.data!.circles.length * ScreenUtil().setWidth(210)) + ScreenUtil().setWidth(240),
                                                     height: ScreenUtil().setWidth(1),
                                                     color: Colors.grey.withOpacity(0.5),
                                                     margin: EdgeInsets.only(
                                                       top: ScreenUtil().setWidth(300)/1.35 + ScreenUtil().setWidth(10),
                                                     ),
                                                   )
                                                 ],
                                               )
                                           )
                                       )
                                   )
                               )
                           );
                         }else{
                           return  Container();
                         }
                       },
                     ),
                   ),
                    //  StreamBuilder(
                    //   stream: _presenter.circlesTimingObserve,
                    //   builder: (context,AsyncSnapshot<ChartTimingModel>snapshotCirclesTiming){
                    //     if(snapshotCirclesTiming.data != null){
                    //       return  Padding(
                    //           padding: EdgeInsets.only(
                    //               top: ScreenUtil().setWidth(30)
                    //           ),
                    //           child:  Container(
                    //               child:   SingleChildScrollView(
                    //                   scrollDirection: Axis.horizontal,
                    //                   child:  Screenshot(
                    //                     controller: screenshotControllerTimingChart,
                    //                     child:  Padding(
                    //                       padding: EdgeInsets.only(
                    //                           top: ScreenUtil().setWidth(40)
                    //                       ),
                    //                       child:  CustomPaint(
                    //                           size:  Size(
                    //                               snapshotCirclesTiming.data.totalDays*pTodayChartTimingCanvas+(marginLeftCircleDayChartTimingCanvas*(widget.limit+1)) + ScreenUtil().setWidth(70)
                    //                               ,heightChartTimingCanvas
                    //                           ),
                    //                           painter: TimingCanvas(
                    //                             chartTimingModel: snapshotCirclesTiming.data,
                    //                           )
                    //                       ),
                    //                     ),
                    //                   )
                    //               )
                    //           )
                    //       );
                    //     }else{
                    //       return  Container();
                    //     }
                    //   },
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          StreamBuilder(
                            stream: _presenter.isLoadingPdfObserve,
                            builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                              if(snapshotIsLoading.data != null){
                                return  StreamBuilder(
                                  stream: _animations.squareScaleBackButtonObserve,
                                  builder: (context,AsyncSnapshot<double>snapshotScale){
                                    if(snapshotScale.data != null){
                                      return Transform.scale(
                                          scale: modePress == 0 ? snapshotScale.data : 1.0,
                                          child:  GestureDetector(
                                              onTap: ()async{
                                                if(!snapshotIsLoading.data!){
                                                  if(this.mounted){
                                                    setState(() {
                                                      modePress = 0;
                                                    });
                                                  }
                                                  await animationControllerScaleButtons.reverse();
                                                  AnalyticsHelper().log(AnalyticsEvents.ChartPg_ViewPDF_Btn_Clk);
                                                  _presenter.getPdf(_scaffoldKey.currentContext,widget.limit,false);
                                                }
                                              },
                                              child: Opacity(
                                                opacity: !snapshotIsLoading.data! ? 1.0 : 0.5,
                                                child:  Container(
                                                    height: ScreenUtil().setWidth(70),
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: ScreenUtil().setWidth(30),
                                                    ),
                                                    margin: EdgeInsets.only(
                                                      top: ScreenUtil().setWidth(50),
                                                      bottom: ScreenUtil().setWidth(30),
                                                      // right: ScreenUtil().setWidth(250),
                                                      // left: ScreenUtil().setWidth(250),
                                                    ),
                                                    decoration:  BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        color: Colors.white,
                                                      border: Border.all(
                                                        color: ColorPallet().mainColor
                                                      )
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Container(
                                                            height: ScreenUtil().setWidth(32),
                                                            width: ScreenUtil().setWidth(32),
                                                            child: SvgPicture.asset(
                                                              'assets/images/ic_pdf.svg',
                                                              fit: BoxFit.cover,
                                                            )
                                                        ),
                                                        SizedBox(width: ScreenUtil().setWidth(15)),
                                                        Text(
                                                          'PDF مشاهده',
                                                          style: context.textTheme.labelMedium!.copyWith(
                                                              color: ColorPallet().mainColor
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                ),
                                              )
                                          )
                                      );
                                    }else{
                                      return  Container();
                                    }
                                  },
                                );
                              }else{
                                return Container();
                              }
                            },
                          ),
                          SizedBox(width : ScreenUtil().setWidth(20)),
                          StreamBuilder(
                            stream: _presenter.isLoadingPdfObserve,
                            builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                              if(snapshotIsLoading.data != null){
                                return  StreamBuilder(
                                  stream: _animations.squareScaleBackButtonObserve,
                                  builder: (context,AsyncSnapshot<double>snapshotScale){
                                    if(snapshotScale.data != null){
                                      return Transform.scale(
                                          scale: modePress == 1  ? snapshotScale.data : 1.0,
                                          child:  GestureDetector(
                                            onTap: ()async{
                                              if(!snapshotIsLoading.data!){
                                                if(this.mounted){
                                                  setState(() {
                                                    modePress = 1;
                                                  });
                                                }
                                                await animationControllerScaleButtons.reverse();
                                                AnalyticsHelper().log(AnalyticsEvents.ChartPg_SharePDF_Btn_Clk);
                                                _presenter.getPdf(_scaffoldKey.currentContext,widget.limit,true);
                                              }
                                            },
                                            child : Opacity(
                                              opacity: !snapshotIsLoading.data! ? 1.0 : 0.5,
                                              child:  Container(
                                                  height: ScreenUtil().setWidth(70),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: ScreenUtil().setWidth(30),
                                                  ),
                                                  margin: EdgeInsets.only(
                                                    top: ScreenUtil().setWidth(50),
                                                    bottom: ScreenUtil().setWidth(30),
                                                    // right: ScreenUtil().setWidth(250),
                                                    // left: ScreenUtil().setWidth(250),
                                                  ),
                                                  decoration:  BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      color: ColorPallet().mainColor,
                                                  ),
                                                  child:   Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                       Container(
                                                          height: ScreenUtil().setWidth(32),
                                                          width: ScreenUtil().setWidth(32),
                                                          child: SvgPicture.asset(
                                                            'assets/images/ic_share.svg',
                                                            fit: BoxFit.fitHeight,
                                                          )
                                                      ),
                                                      SizedBox(width: ScreenUtil().setWidth(15)),
                                                       Text(
                                                        'PDF اشتراک‌گذاری',
                                                         style: context.textTheme.labelMedium!.copyWith(
                                                             color: Colors.white
                                                         ),
                                                      )
                                                    ],
                                                  )
                                              ),
                                            )
                                          )
                                      );
                                    }else{
                                      return  Container();
                                    }
                                  },
                                );
                              }else{
                                return Container();
                              }
                            },
                          )
                        ],
                      )
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: ClinicBox(
                        infoAdviceTypes: widget.infoAdviceTypes,
                        onPress: (){
                          AnalyticsHelper().log(AnalyticsEvents.ChartPg_AskNowDoctor_Btn_Clk);
                          widget.expertPresenter!.onPressExpertAdvice(
                            context,
                            widget.infoAdviceTypes!,
                            widget.expertPresenter,
                            widget.infoAdviceTypes!.id,
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }


  // double setHeightCircleDayChart(ChartComparisonModel chartComparisonModel,index){
  //
  //   if(chartComparisonModel.circles[index].circleDay == chartComparisonModel.largestCircleDay){
  //     return maxChartCompare;
  //   }else{
  //     return (maxChartCompare*chartComparisonModel.circles[index].circleDay) / chartComparisonModel.largestCircleDay;
  //   }
  // }
  //
  // setHeightPeriodDayChart(ChartComparisonModel chartComparisonModel,index){
  //   return (maxChartCompare*chartComparisonModel.circles[index].periodDay) / chartComparisonModel.largestCircleDay;
  // }
  //
  // double setPaddingCircleDaySeparatorLine(ChartComparisonModel chartComparisonModel){
  //   return (maxChartCompare*chartComparisonModel.circleDayRegister/chartComparisonModel.largestCircleDay) + heightMonths;
  // }
  //
  // double setPaddingPeriodDaySeparatorLine(ChartComparisonModel chartComparisonModel){
  //   return (maxChartCompare*chartComparisonModel.periodDayRegister/chartComparisonModel.largestCircleDay) + heightMonths + paddingCircleDayAndPeriodDay;
  // }
  //
  // double setWidthCircleDayChart(ChartTimingModel chartTimingModel,index){
  //
  //   if(chartTimingModel.circles[index].circleDay == chartTimingModel.largestCircleDay){
  //     return maxChartTiming;
  //   }else{
  //     return (maxChartTiming*chartTimingModel.circles[index].circleDay) / chartTimingModel.largestCircleDay;
  //   }
  // }
  //
  // setWidthPeriodDayChart(ChartTimingModel chartTimingModel,index){
  //   return (maxChartTiming*chartTimingModel.circles[index].periodDay) / chartTimingModel.largestCircleDay;
  // }


  @override
  void onError(msg) {

  }

  @override
  void onSuccess(msg){

  }

}