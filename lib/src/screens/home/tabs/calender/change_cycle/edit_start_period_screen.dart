import 'package:get/get.dart';
import 'package:impo/src/screens/home/tabs/calender/change_cycle/edit_end_period_screen.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:intl/intl.dart' as INTL;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/calender_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shamsi_date/shamsi_date.dart';

class EditStartPeriodScreen extends StatefulWidget{
  final CalenderPresenter? calenderPresenter;

  EditStartPeriodScreen({Key? key,this.calenderPresenter}):super(key:key);

  @override
  State<StatefulWidget> createState() => EditStartPeriodScreenState();
}

class EditStartPeriodScreenState extends State<EditStartPeriodScreen> with TickerProviderStateMixin{

  List<String> days = [];

  List<String> daysForSaves = [];

  late AnimationController animationControllerScaleSendButton;


  Animations _animations =  Animations();

  int indexDays = 1 ;

  late String selectedLastPeriodDay;


  @override
  void initState() {
    ///AnalyticsHelper().enableEventsList([AnalyticsEvents.LastPeriodRegPg_LastPeriodList_Picker_Scr]);
    widget.calenderPresenter!.initChangeCycleScreen();
    animationControllerScaleSendButton = _animations.pressButton(this);
    _animations.shakeError(this);
    generateDatePeriods();
    super.initState();
  }


  generateDatePeriods(){


    DateTime now = DateTime.now();


    for(int i=0 ; i<60 ; i++){
      DateTime yesterday =  DateTime(now.year,now.month,now.day - i);
      if(widget.calenderPresenter!.getRegister().calendarType == 1){
        final INTL.DateFormat formatter = INTL.DateFormat('dd LLL yyyy','fa');
        days.add(formatter.format(yesterday));

      }else{
        days.add(format1(Jalali.fromDateTime(yesterday)));
      }
      daysForSaves.add(yesterday.toString());
    }

    // if(widget.phoneOrEmail == null)getSelectedDefaultLastPeriodDay();

    DateTime startPeriod = DateTime.parse(widget.calenderPresenter!.getLastCircles().periodStart!);
    for(int i=0 ; i<daysForSaves.length ; i++){
      DateTime datetime = DateTime.parse(daysForSaves[i]);
      if(datetime.year == startPeriod.year && datetime.month == startPeriod.month &&
          datetime.day == startPeriod.day){
          indexDays = i;
      }
    }

    setState((){
      selectedLastPeriodDay = days[indexDays];
    });

  }


  String format1(Date d) {
    final f = d.formatter;

    Jalali now = Jalali.now();

    if(widget.calenderPresenter!.getRegister().nationality == 'IR'){
      if(d == now){

        return 'امروز  ${f.d}  ${f.mN}';

      }else if(d == now.addDays(-1)){

        return 'دیروز  ${f.d}  ${f.mN}';

      }else{

        return '${f.wN}  ${f.d}  ${f.mN}';

      }
    }else{
      if(d == now){

        return 'امروز  ${f.d}  ${f.mnAf}';

      }else if(d == now.addDays(-1)){

        return 'دیروز  ${f.d}  ${f.mnAf}';

      }else{

        return '${f.wN}  ${f.d}  ${f.mnAf}';

      }
    }


  }

  @override
  void dispose() {
    _animations.animationControllerShakeError.dispose();
    super.dispose();
  }


  Future<bool> _onWillPop()async{
    ///AnalyticsHelper().log(AnalyticsEvents.LastPeriodRegPg_Back_NavBar_Clk);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.5;
    ///ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return  WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
          textDirection: TextDirection.rtl,
          child:  Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              body:  SingleChildScrollView(
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CustomAppBar(
                      messages: false,
                      profileTab: true,
                      icon: 'assets/images/ic_arrow_back.svg',
                      titleProfileTab: 'صفحه قبل',
                      subTitleProfileTab: 'ویرایش چرخه',
                      onPressBack: () {
                        ///AnalyticsHelper().log(AnalyticsEvents.LastPeriodRegPg_Back_Btn_Clk);
                        Navigator.pop(context);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setWidth(100),
                        bottom: ScreenUtil().setWidth(100),
                        right: ScreenUtil().setWidth(50),
                        left: ScreenUtil().setWidth(50),
                      ),
                      child:   Text(
                        '${widget.calenderPresenter!.getRegister().name} جان\n آخرین باری که پریود شدی چه روزی بوده؟',
                        textAlign: TextAlign.center,
                        style:  context.textTheme.labelLargeProminent!.copyWith(
                          color: ColorPallet().gray,
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(85)),
                    Container(
                        alignment: Alignment.center,
                        height: ScreenUtil().setWidth(200),
                        child:  Center(
                            child:  NotificationListener<OverscrollIndicatorNotification>(
                                onNotification: (overscroll){
                                  overscroll.disallowIndicator();
                                  return true;
                                },
                                child: Theme(
                                  data: ThemeData(
                                      cupertinoOverrideTheme: CupertinoThemeData(
                                          textTheme: CupertinoTextThemeData(
                                            pickerTextStyle: context.textTheme.bodyMedium!.copyWith(
                                                color: ColorPallet().mainColor
                                            ),
                                          )
                                      )
                                  ),
                                  child:  CupertinoPicker(
                                      scrollController: FixedExtentScrollController(initialItem:indexDays),
                                      itemExtent: ScreenUtil().setWidth(110),
                                      onSelectedItemChanged: (index){
                                        ///AnalyticsHelper().log(AnalyticsEvents.LastPeriodRegPg_LastPeriodList_Picker_Scr,remainEventActive: false);
                                        indexDays = index;
                                        widget.calenderPresenter!.onChangedCurrentStartCycle(
                                            widget.calenderPresenter!.getRegister().calendarType == 1 ?
                                            DateTime.parse(daysForSaves[index]) :
                                            Jalali.fromDateTime(DateTime.parse(daysForSaves[index])),
                                            widget.calenderPresenter!.getRegister().calendarType == 1 ? true : false
                                        );
                                      },
                                      children: List.generate(days.length, (index){
                                        return  Center(
                                          child:  Text(
                                            days[index],
                                            style:  context.textTheme.bodyMedium!.copyWith(
                                              color: ColorPallet().mainColor
                                            ),
                                          ),
                                        );
                                      })
                                  ),
                                )
                            )
                        )
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child:  Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setWidth(15)
                        ),
                        child: AnimatedBuilder(
                            animation: _animations.animationShakeError,
                            builder: (buildContext, child) {
                              if (_animations.animationShakeError.value < 0.0) print('${_animations.animationShakeError.value + 8.0}');
                              return  StreamBuilder(
                                stream: _animations.isShowErrorObserve,
                                builder: (context,AsyncSnapshot<bool> snapshot){
                                  if(snapshot.data != null){
                                    if(snapshot.data!){
                                      return  StreamBuilder(
                                          stream: _animations.errorTextObserve,
                                          builder: (context,AsyncSnapshot<String>snapshot){
                                            return Container(
                                                margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(65)),
                                                padding: EdgeInsets.only(left: _animations.animationShakeError.value + 4.0, right: 4.0 -_animations.animationShakeError.value),
                                                child: Text(
                                                  snapshot.data != null ? snapshot.data! : '',
                                                  style: context.textTheme.bodySmall!.copyWith(
                                                    color: Color(0xffEE5858),
                                                  ),
                                                )
                                            );
                                          }
                                      );
                                    }else {
                                      return  Opacity(
                                        opacity: 0.0,
                                        child:  Container(
                                          child:  Text(''),
                                        ),
                                      );
                                    }
                                  }else{
                                    return  Opacity(
                                      opacity: 0.0,
                                      child:  Container(
                                        child:  Text(''),
                                      ),
                                    );
                                  }
                                },
                              );
                            }),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child:  StreamBuilder(
                        stream: widget.calenderPresenter!.isLoadingObserve,
                        builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                          if(snapshotIsLoading.data != null){
                            if(!snapshotIsLoading.data!){
                              return  Padding(
                                  padding: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(80),

                                  ),
                                  child:  StreamBuilder(
                                    stream: widget.calenderPresenter!.isLoadingObserve,
                                    builder: (context,snapshotIsLoading){
                                      if(snapshotIsLoading.data != null){
                                        return CustomButton(
                                          title: 'ادامه',
                                          onPress: (){
                                             nextPage(daysForSaves[indexDays]);
                                          },
                                          colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                                          borderRadius: 10.0,
                                          enableButton: true,
                                          margin: 220,
                                          isLoadingButton: snapshotIsLoading.data,
                                        );
                                      }else{
                                        return Container();
                                      }
                                    },
                                  )
                              );
                            }else{
                              return  Padding(
                                padding: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(100),
                                    bottom: ScreenUtil().setWidth(30)
                                ),
                                child:  LoadingViewScreen(
                                    color: ColorPallet().mainColor
                                ),
                              );
                            }
                          }else{
                            return  Container();
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
          )
      ),
    );
  }

  nextPage(String startPeriod){
    Navigator.push(
        context,
        PageTransition(
            child: EditEndPeriodScreen(
              calenderPresenter: widget.calenderPresenter,
              startPeriod: startPeriod,
            ),
            type: PageTransitionType.fade
        )
    );
  }

}