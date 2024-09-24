// import 'dart:async';
// import 'package:impo/packages/date_picker_time_line-1.2.3/date_picker_timeline.dart';
// import 'package:impo/packages/date_picker_time_line-1.2.3/date_picker_widget_en.dart' as En;
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:impo/src/architecture/presenter/calender_presenter.dart';
// import 'package:impo/src/components/animations.dart';
// import 'package:impo/src/components/colors.dart';
// import 'package:impo/src/components/custom_appbar.dart';
// import 'package:impo/src/components/custom_button.dart';
// import 'package:impo/src/data/locator.dart';
// import 'package:impo/src/models/register/register_parameters_model.dart';
// import 'package:impo/src/models/signsModel/button_animation.dart';
// import 'package:intl/intl.dart' as INTL;
// import 'package:shamsi_date/shamsi_date.dart';
// import '../../../../firebase_analytics_helper.dart';
//
// class ChangeCycleScreen extends StatefulWidget{
//   final CalenderPresenter? calenderPresenter;
//
//   ChangeCycleScreen({Key? key,this.calenderPresenter}):super(key:key);
//
//   @override
//   State<StatefulWidget> createState() => ChangeCycleScreenState();
//
// }
//
// class ChangeCycleScreenState extends State<ChangeCycleScreen> with TickerProviderStateMixin{
//
//   Animations animations = Animations();
//   late AnimationController animationControllerScaleButtons;
//   int modePress =0;
//   List<DateTime> startsCircle = [];
//   List<DateTime> endPeriod = [];
//   List<DateTime> endCircle = [];
//   late DatePickerController _startCircleDatePickerController;
//   late DatePickerController _endPeriodDatePickerController;
//   late DatePickerController _endCircleDatePickerController;
//
//   late En.DatePickerController _mildayStartCircleDatePickerController;
//   late En.DatePickerController _mildayEndPeriodDatePickerController;
//   late En.DatePickerController _mildayEndCircleDatePickerController;
//
//   @override
//   void initState() {
//     animationControllerScaleButtons = animations.pressButton(this);
//     widget.calenderPresenter!.initChangeCycleScreen();
//     _startCircleDatePickerController = DatePickerController();
//     _endPeriodDatePickerController = DatePickerController();
//      _endCircleDatePickerController = DatePickerController();
//
//     _mildayStartCircleDatePickerController = En.DatePickerController();
//     _mildayEndPeriodDatePickerController = En.DatePickerController();
//     _mildayEndCircleDatePickerController = En.DatePickerController();
//
//     ButtonAnimation.getGlobal()!.setAnim(animations.initialBottomButton(this));
//     super.initState();
//   }
//
//
//
//   String format1(Date d) {
//     var registerInfo =locator<RegisterParamModel>();
//     final f = d.formatter;
//     if(registerInfo.register.calendarType == 0){
//       if(registerInfo.register.nationality == 'IR'){
//         return "${f.d} ${f.mN} ${f.yyyy}";
//       }else{
//         return "${f.d} ${f.mnAf} ${f.yyyy}";
//       }
//     }else{
//       final INTL.DateFormat formatter = INTL.DateFormat('dd LLL yyyy','fa');
//       return formatter.format(d.toDateTime());
//     }
//   }
//
//   bool checkMiladyDate(){
//     var registerInfo =locator<RegisterParamModel>();
//     if(registerInfo.register.calendarType == 0 ){
//       return false;
//     }else{
//       return true;
//     }
//   }
//
//   Future<bool> _onWillPop()async{
//     AnalyticsHelper().log(AnalyticsEvents.ChangeCyclePgPeriod_Back_NavBar_Clk);
//     return Future.value(true);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           body: Stack(
//             children: [
//               Column(
//                 children: [
//                   CustomAppBar(
//                     messages: false,
//                     profileTab: true,
//                     icon: 'assets/images/ic_arrow_back.svg',
//                     titleProfileTab: 'صفحه قبل',
//                     subTitleProfileTab: 'تنظیمات',
//                     onPressBack: (){
//                       AnalyticsHelper().log(AnalyticsEvents.ChangeCyclePgPeriod_Back_Btn_Clk);
//                       Navigator.pop(context);
//                     },
//                   ),
//                   Expanded(
//                       child: ListView(
//                         padding: EdgeInsets.zero,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(
//                                 top: ScreenUtil().setWidth(20),
//                                 bottom: ScreenUtil().setWidth(15)
//                             ),
//                             child: Align(
//                               alignment: Alignment.center,
//                               child: Stack(
//                                 alignment: Alignment.bottomCenter,
//                                 children: [
//                                   Padding(
//                                     padding: EdgeInsets.only(
//                                       top: ScreenUtil().setWidth(20),
//                                       left: ScreenUtil().setWidth(320),
//                                     ),
//                                     child: SvgPicture.asset(
//                                       'assets/images/ic_big_change_cycle.svg',
//                                       width: ScreenUtil().setWidth(110),
//                                       height: ScreenUtil().setWidth(110),
//                                     ),
//                                   ),
//                                   Text(
//                                     'تغییر دوره فعلی',
//                                     textAlign: TextAlign.center,
//                                     style:  TextStyle(
//                                         color: ColorPallet().black,
//                                         fontSize: ScreenUtil().setSp(44),
//                                         fontWeight: FontWeight.w800
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           // Text(
//                           //   'اینجا می‌تونیم یه توضیحات در مورد تغییر دوره بزاریم',
//                           //   textAlign: TextAlign.center,
//                           //   style: TextStyle(
//                           //       color: ColorPallet().gray,
//                           //       fontSize: ScreenUtil().setSp(30),
//                           //       fontWeight: FontWeight.w500
//                           //   ),
//                           // ),
//                           SizedBox(height: ScreenUtil().setWidth(20)),
//                           StreamBuilder(
//                             stream: widget.calenderPresenter!.startCycleSelectedObserve,
//                             builder: (context,AsyncSnapshot<Jalali>snapshotStartCycleSelected){
//                               if(snapshotStartCycleSelected.data != null){
//                                 return item(
//                                     'شروع دوره و پریود',
//                                     'آخرین بار کی پریود شدی؟ لازمه که تاریخ پایان پریود و طول دوره ات رو هم انتخاب کنی تا محاسبات به درستی انجام بشه!',
//                                     format1(snapshotStartCycleSelected.data!),
//                                     0
//                                 );
//                               }else{
//                                 return Container();
//                               }
//                             },
//                           ),
//                           SizedBox(height: ScreenUtil().setWidth(50)),
//                           StreamBuilder(
//                             stream: widget.calenderPresenter!.endPeriodSelectedObserve,
//                             builder: (context,AsyncSnapshot<Jalali>snapshotEndPeriodSelected){
//                               if(snapshotEndPeriodSelected.data != null){
//                                 return item(
//                                     'اتمام پریود',
//                                     'پریودت کی تموم میشه؟',
//                                     format1(snapshotEndPeriodSelected.data!),
//                                     1
//                                 );
//                               }else{
//                                 return Container();
//                               }
//                             },
//                           ),
//                           SizedBox(height: ScreenUtil().setWidth(50)),
//                           StreamBuilder(
//                             stream: widget.calenderPresenter!.endCycleSelectedObserve,
//                             builder: (context,AsyncSnapshot<Jalali>snapshotEndCycleSelected){
//                               if(snapshotEndCycleSelected.data != null){
//                                 return item(
//                                     'اتمام دوره',
//                                     'طول دوره ات چند روزه؟ طول دوره از شروع یه پریود تا شروع پریود بعدی، محاسبه میشه.',
//                                     format1(snapshotEndCycleSelected.data!),
//                                     2
//                                 );
//                               }else{
//                                 return Container();
//                               }
//                             },
//                           ),
//                           SizedBox(height: ScreenUtil().setWidth(80)),
//                           StreamBuilder(
//                             stream: widget.calenderPresenter!.isLoadingObserve,
//                             builder: (context,snapshotIsLoading){
//                               if(snapshotIsLoading.data != null){
//                                 return CustomButton(
//                                   title: 'تایید و ذخیره',
//                                   onPress: (){
//                                     AnalyticsHelper().log(
//                                         AnalyticsEvents.ChangeCyclePgPeriod_SaveAndAccept_Btn_Clk,
//                                       parameters: {
//                                           'lastPeriod' : widget.calenderPresenter!.startCycleSelected.stream.value.toString(),
//                                            'endPeirod' : widget.calenderPresenter!.endPeriodSelected.stream.value.toString(),
//                                            'endCycle' : widget.calenderPresenter!.endCycleSelected.stream.value.toString()
//                                       }
//                                     );
//                                     widget.calenderPresenter!.acceptChangeCycle(context);
//                                   },
//                                   colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
//                                   borderRadius: 20.0,
//                                   enableButton: true,
//                                   isLoadingButton: snapshotIsLoading.data,
//                                   margin: 210,
//                                 );
//                               }else{
//                                 return Container();
//                               }
//                             },
//                           ),
//                           SizedBox(height: ScreenUtil().setWidth(50)),
//                         ],
//                       )
//                   )
//                 ],
//               ),
//               Stack(
//                 alignment: Alignment.bottomCenter,
//                 children: <Widget>[
//                   StreamBuilder(
//                     stream: ButtonAnimation.getGlobal()!.isShowBoxDateTimeObserve,
//                     builder: (context,AsyncSnapshot<bool>snapshot){
//                       if(snapshot.data != null){
//                         return  AnimatedCrossFade(
//                           firstChild:  Container(),
//                           secondChild:  GestureDetector(
//                             onTap: ()async{
//                               await ButtonAnimation.getGlobal()!.getAnim().reverse();
//                               ButtonAnimation.getGlobal()!.setIsShowBoxDateTime(true);
//                             },
//                             child:  Container(
//                               color: Colors.black.withOpacity(.4),
// //                height: MediaQuery.of(context).size.height,
// //                width: MediaQuery.of(context).size.width,
//                             ),
//                           ),
//                           duration: Duration(milliseconds: 400),
//                           crossFadeState: snapshot.data! ? CrossFadeState.showFirst : CrossFadeState.showSecond,
//                         );
//                       }else{
//                         return  Container();
//                       }
//                     },
//                   ),
//                   SlideTransition(
//                     position: animations.buttonAnimationBottom,
//                     child:  Container(
//                         height: modePress == 0 ? MediaQuery.of(context).size.height/4 : MediaQuery.of(context).size.height/4,
//                         width: MediaQuery.of(context).size.width,
// //              height: MediaQuery.of(context).size.height/5,
//                         padding: EdgeInsets.only(
//                             top: ScreenUtil().setWidth(20),
//                             right: ScreenUtil().setWidth(20),
//                             left: ScreenUtil().setWidth(20)
//                         ),
// //                  height: MediaQuery.of(context).size.height/6,
//                         decoration:  BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.only(
//                                 topRight: Radius.circular(30),
//                                 topLeft: Radius.circular(30)
//                             )
//                         ),
//                         child:  Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Text('       '),
//                                 Text(
//                                   modePress == 0 ? 'شروع دوره و پریود' : modePress == 1 ? 'اتمام پریود' : 'اتمام دوره',
//                                   style:  TextStyle(
//                                       color: ColorPallet().mainColor,
//                                       fontSize: ScreenUtil().setSp(38)
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: ()async{
//                                     await ButtonAnimation.getGlobal()!.getAnim().reverse();
//                                     ButtonAnimation.getGlobal()!.setIsShowBoxDateTime(true);
//                                   },
//                                   child:   Icon(
//                                     Icons.keyboard_arrow_down,
//                                     color: Colors.black,
//                                   ),
//                                 )
//                               ],
//                             ),
//                             StreamBuilder(
//                               stream: ButtonAnimation.getGlobal()!.isShowBoxDateTimeObserve,
//                               builder: (context,AsyncSnapshot<bool>snapshot){
//                                 if(snapshot.data != null){
//                                   if(!snapshot.data!){
//                                     return modePress == 0 ?
//                                     StreamBuilder(
//                                       stream: widget.calenderPresenter!.startCycleSelectedObserve,
//                                       builder: (context,AsyncSnapshot<Jalali>snapshotStartCycleSelected){
//                                         if(snapshotStartCycleSelected.data != null){
//                                           if(checkMiladyDate()){
//                                             return En.DatePickerEn(
//                                               startsCircle[startsCircle.length-1],
//                                               initialSelectedDate: snapshotStartCycleSelected.data!.toDateTime(),
//                                               height: ScreenUtil().setHeight(230),
//                                               width: ScreenUtil().setWidth(130),
//                                               controller: _mildayStartCircleDatePickerController,
//                                               selectionColor: Color(0xffffd7f1),
//                                               daysCount: startsCircle.length,
//                                               selectedTextColor: ColorPallet().mainColor,
//                                               dateTextStyle: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: ScreenUtil().setSp(50),
//                                                   fontWeight: FontWeight.w500
//                                               ),
//                                               dayTextStyle: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: ScreenUtil().setSp(20),
//                                                   fontWeight: FontWeight.w400
//                                               ),
//                                               monthTextStyle: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: ScreenUtil().setSp(20),
//                                                   fontWeight: FontWeight.w400
//                                               ),
//                                               locale: 'fa',
//                                               onDateChange: (date) {
//                                                 print(date);
//                                                 widget.calenderPresenter!.onChangedCurrentStartCycle(date,true);
//                                                 // onPressDateTimeCalender(date);
//                                               },
//                                             );
//                                           }else{
//                                             var registerInfo = locator<RegisterParamModel>();
//                                             return DatePicker(
//                                               Jalali.fromDateTime(startsCircle[startsCircle.length-1]),
//                                               initialSelectedDate: snapshotStartCycleSelected.data,
//                                               height: ScreenUtil().setHeight(230),
//                                               width: ScreenUtil().setWidth(130),
//                                               controller: _startCircleDatePickerController,
//                                               selectionColor: Color(0xffffd7f1),
//                                               daysCount: startsCircle.length,
//                                               selectedTextColor: ColorPallet().mainColor,
//                                               dateTextStyle: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: ScreenUtil().setSp(50),
//                                                   fontWeight: FontWeight.w500
//                                               ),
//                                               dayTextStyle: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: ScreenUtil().setSp(20),
//                                                   fontWeight: FontWeight.w400
//                                               ),
//                                               monthTextStyle: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: ScreenUtil().setSp(20),
//                                                   fontWeight: FontWeight.w400
//                                               ),
//                                               locale: registerInfo.register.nationality == 'IR' ? 'fa' : 'af',
//                                               onDateChange: (date) {
//                                                 print(date);
//                                                 widget.calenderPresenter!.onChangedCurrentStartCycle(date,false);
//                                                 // onPressDateTimeCalender(date);
//                                               },
//                                             );
//                                           }
//                                         }else{
//                                           return Container();
//                                         }
//                                       },
//                                     )
//                                         : modePress == 1 ?
//                                     StreamBuilder(
//                                       stream: widget.calenderPresenter!.endPeriodSelectedObserve,
//                                       builder: (context,AsyncSnapshot<Jalali>snapshotEndPeriodSelected){
//                                         if(snapshotEndPeriodSelected.data != null){
//                                           if(checkMiladyDate()){
//                                             return En.DatePickerEn(
//                                               endPeriod[endPeriod.length-1],
//                                               initialSelectedDate: snapshotEndPeriodSelected.data!.toDateTime(),
//                                               height: ScreenUtil().setHeight(230),
//                                               width: ScreenUtil().setWidth(130),
//                                               controller: _mildayEndPeriodDatePickerController,
//                                               selectionColor: Color(0xffffd7f1),
//                                               daysCount: endPeriod.length,
//                                               selectedTextColor: ColorPallet().mainColor,
//                                               dateTextStyle: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: ScreenUtil().setSp(50),
//                                                   fontWeight: FontWeight.w500
//                                               ),
//                                               dayTextStyle: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: ScreenUtil().setSp(20),
//                                                   fontWeight: FontWeight.w400
//                                               ),
//                                               monthTextStyle: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: ScreenUtil().setSp(20),
//                                                   fontWeight: FontWeight.w400
//                                               ),
//                                               locale: 'fa',
//                                               onDateChange: (date) {
//                                                 widget.calenderPresenter!.onChangedCurrentEndPeriod(date,true);
//                                                 // onPressDateTimeCalender(date);
//                                               },
//                                             );
//                                           }else{
//                                             var registerInfo = locator<RegisterParamModel>();
//                                             return DatePicker(
//                                               Jalali.fromDateTime(endPeriod[endPeriod.length-1]),
//                                               initialSelectedDate: snapshotEndPeriodSelected.data ,
//                                               height: ScreenUtil().setHeight(230),
//                                               width: ScreenUtil().setWidth(130),
//                                               controller: _endPeriodDatePickerController,
//                                               selectionColor: Color(0xffffd7f1),
//                                               daysCount: endPeriod.length,
//                                               selectedTextColor: ColorPallet().mainColor,
//                                               dateTextStyle: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: ScreenUtil().setSp(50),
//                                                   fontWeight: FontWeight.w500
//                                               ),
//                                               dayTextStyle: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: ScreenUtil().setSp(20),
//                                                   fontWeight: FontWeight.w400
//                                               ),
//                                               monthTextStyle: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: ScreenUtil().setSp(20),
//                                                   fontWeight: FontWeight.w400
//                                               ),
//                                               locale: registerInfo.register.nationality == 'IR' ? 'fa' : 'af',
//                                               onDateChange: (date) {
//                                                 widget.calenderPresenter!.onChangedCurrentEndPeriod(date,false);
//                                                 // onPressDateTimeCalender(date);
//                                               },
//                                             );
//                                           }
//                                         }else{
//                                           return Container();
//                                         }
//                                       },
//                                     )
//                                         :
//                                     StreamBuilder(
//                                       stream: widget.calenderPresenter!.endCycleSelectedObserve,
//                                       builder: (context,AsyncSnapshot<Jalali>snapshotEndCycleSelected){
//                                         if(snapshotEndCycleSelected.data != null){
//                                           if(checkMiladyDate()){
//                                             return En.DatePickerEn(
//                                               endCircle[endCircle.length-1],
//                                               initialSelectedDate: snapshotEndCycleSelected.data!.toDateTime(),
//                                               height: ScreenUtil().setHeight(230),
//                                               width: ScreenUtil().setWidth(130),
//                                               controller: _mildayEndCircleDatePickerController,
//                                               selectionColor: Color(0xffffd7f1),
//                                               daysCount: endCircle.length,
//                                               selectedTextColor: ColorPallet().mainColor,
//                                               dateTextStyle: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: ScreenUtil().setSp(50),
//                                                   fontWeight: FontWeight.w500
//                                               ),
//                                               dayTextStyle: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: ScreenUtil().setSp(20),
//                                                   fontWeight: FontWeight.w400
//                                               ),
//                                               monthTextStyle: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: ScreenUtil().setSp(20),
//                                                   fontWeight: FontWeight.w400
//                                               ),
//                                               locale: 'fa',
//                                               onDateChange: (date) {
//                                                 widget.calenderPresenter!.onChangedCurrentEndCycle(date,true);
//                                                 // onPressDateTimeCalender(date);
//                                               },
//                                             );
//                                           }else{
//                                             var registerInfo = locator<RegisterParamModel>();
//                                             return DatePicker(
//                                               Jalali.fromDateTime(endCircle[endCircle.length-1]),
//                                               initialSelectedDate: snapshotEndCycleSelected.data ,
//                                               height: ScreenUtil().setHeight(230),
//                                               width: ScreenUtil().setWidth(130),
//                                               controller: _endCircleDatePickerController,
//                                               selectionColor: Color(0xffffd7f1),
//                                               daysCount: endCircle.length,
//                                               selectedTextColor: ColorPallet().mainColor,
//                                               dateTextStyle: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: ScreenUtil().setSp(50),
//                                                   fontWeight: FontWeight.w500
//                                               ),
//                                               dayTextStyle: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: ScreenUtil().setSp(20),
//                                                   fontWeight: FontWeight.w400
//                                               ),
//                                               monthTextStyle: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: ScreenUtil().setSp(20),
//                                                   fontWeight: FontWeight.w400
//                                               ),
//                                               locale: registerInfo.register.nationality == 'IR' ? 'fa' : 'af',
//                                               onDateChange: (date) {
//                                                 widget.calenderPresenter!.onChangedCurrentEndCycle(date,false);
//                                                 // onPressDateTimeCalender(date);
//                                               },
//                                             );
//                                           }
//                                         }else{
//                                           return Container();
//                                         }
//                                       },
//                                     )
//                                     ;
//                                   }else{
//                                     return  Container();
//                                   }
//                                 }else{
//                                   return  Container();
//                                 }
//                               },
//                             )
//                           ],
//                         )
//                     ),
//                   ),
// //             RaisedButton(
// //              onPressed: (){checkDates();},
// //              color: Colors.red,
// //              child:  Container(
// //                height: 100,
// //                width: 100,
// //                color: Colors.red,
// //              ),
// //            )
//                 ],
//               )
//             ],
//           )
//         ),
//       ),
//     );
//   }
//
//
//   Widget item(String title,String description,value,index){
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: ScreenUtil().setWidth(50)
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//                 color: ColorPallet().black,
//                 fontWeight: FontWeight.w700,
//                 fontSize: ScreenUtil().setSp(32)
//             ),
//           ),
//           Text(
//             description,
//             style: TextStyle(
//                 color: ColorPallet().gray,
//                 fontWeight: FontWeight.w400,
//                 fontSize: ScreenUtil().setSp(28)
//             ),
//           ),
//           StreamBuilder(
//             stream: widget.calenderPresenter!.selectedCycleDayObserve,
//             builder: (context,snapshotCycleDay){
//               if(snapshotCycleDay.data != null){
//                 return StreamBuilder(
//                   stream: widget.calenderPresenter!.selectedPeriodDayObserve,
//                   builder: (context,snapshotPeriodDay){
//                     if(snapshotPeriodDay.data != null){
//                       return StreamBuilder(
//                         stream: animations.squareScaleBackButtonObserve,
//                         builder: (context,AsyncSnapshot<double>snapshotScale){
//                           if(snapshotScale.data != null){
//                             return Transform.scale(
//                               scale: modePress == index ? snapshotScale.data : 1.0,
//                               child: GestureDetector(
//                                   onTap: ()async{
//                                     if(this.mounted){
//                                       setState(() {
//                                         modePress = index;
//                                       });
//                                     }
//                                     if(index == 0){
//                                       AnalyticsHelper().log(AnalyticsEvents.ChangeCyclePgPeriod_StartPeriod_Btn_Clk);
//                                     }else if(index == 1){
//                                       AnalyticsHelper().log(AnalyticsEvents.ChangeCyclePgPeriod_EndPeriod_Btn_Clk);
//                                     }else{
//                                       AnalyticsHelper().log(AnalyticsEvents.ChangeCyclePgPeriod_EndCycle_Btn_Clk);
//                                     }
//                                     animationControllerScaleButtons.reverse();
//                                     onPressChangeCircle(index);
//                                   },
//                                   child: Container(
//                                     margin: EdgeInsets.only(
//                                         top: ScreenUtil().setWidth(25)
//                                     ),
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: ScreenUtil().setWidth(20),
//                                         horizontal: ScreenUtil().setWidth(30)
//                                     ),
//                                     decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(12),
//                                         boxShadow:[
//                                           BoxShadow(
//                                               color: Color(0xff6E95FF).withOpacity(0.2),
//                                               blurRadius: 5.0
//                                           )
//                                         ]
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           index == 1 ? '$value (${snapshotPeriodDay.data}روز)' :
//                                           index == 2 ? '$value (${snapshotCycleDay.data}روز)'  :
//                                           value,
//                                           style: TextStyle(
//                                               color: ColorPallet().mainColor,
//                                               fontWeight: FontWeight.w500,
//                                               fontSize: ScreenUtil().setSp(32)
//                                           ),
//                                         ),
//                                         RotatedBox(
//                                           quarterTurns: 3,
//                                           child: SvgPicture.asset(
//                                             'assets/images/ic_arrow_back.svg',
//                                             width: ScreenUtil().setWidth(40),
//                                             height: ScreenUtil().setWidth(40),
//                                             colorFilter: ColorFilter.mode(
//                                                 ColorPallet().mainColor,
//                                                 BlendMode.srcIn
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   )
//                               ),
//                             );
//                           }else{
//                             return Container();
//                           }
//                         },
//                       );
//                     }else{
//                       return Container();
//                     }
//                   },
//                 );
//               }else{
//                 return Container();
//               }
//             },
//           )
//         ],
//       )
//     );
//   }
//
//   onPressChangeCircle(mode)async{
//     Timer(Duration(milliseconds: 10),()async{
//       setState(() {
//         modePress = mode;
//         // print(modePress);
//       });
//       ButtonAnimation.getGlobal()!.setIsShowBoxDateTime(false);
//       await animationControllerScaleButtons.reverse();
//       await ButtonAnimation.getGlobal()!.getAnim().forward();
//         Timer(Duration(milliseconds: 10),(){
//           if(modePress == 0){
//             checkMiladyDate() ? _mildayStartCircleDatePickerController.animateToSelection() :_startCircleDatePickerController.animateToSelection();
//           }else if(modePress == 1){
//             checkMiladyDate() ? _mildayEndPeriodDatePickerController.animateToSelection() : _endPeriodDatePickerController.animateToSelection();
//           }else{
//             checkMiladyDate() ? _mildayEndCircleDatePickerController.animateToSelection() : _endCircleDatePickerController.animateToSelection();
//           }
//         });
//     });
//
//     if(mode == 0){
//       generateStatCirclesDays();
//     }else if(mode == 1){
//       generateEndPeriodDays();
//     }else{
//       generateEndCirclesDays();
//     }
//
//   }
//
//   generateStatCirclesDays(){
//     startsCircle.clear();
//     DateTime now = DateTime.now();
//
//     for(int i=0 ; i<60 ; i++){
//       DateTime yesterday =  DateTime(now.year,now.month,now.day - i);
//       startsCircle.add(yesterday);
//       // print(yesterday);
//     }
//     print(startsCircle[startsCircle.length-1]);
//   }
//
//   generateEndPeriodDays(){
//     endPeriod.clear();
//     DateTime now = DateTime.now();
//     DateTime afterTenDay = DateTime(now.year,now.month,now.day+10);
//     for(int i=0 ; i<68 ; i++){
//       DateTime yesterday =  DateTime(afterTenDay.year,afterTenDay.month,afterTenDay.day - i);
//       endPeriod.add(yesterday);
//     }
//
//   }
//
//   generateEndCirclesDays(){
//     endCircle.clear();
//     DateTime now = DateTime.now();
//     DateTime afterSixtyDay = DateTime(now.year,now.month,now.day+59);
//
//     for(int i=0 ; i<60 ; i++){
//       DateTime yesterday =  DateTime(afterSixtyDay.year,afterSixtyDay.month,afterSixtyDay.day - i);
//       endCircle.add(yesterday);
//     }
//
//   }
//
//
// }