

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/calender_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/calender/grid_item.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:intl/intl.dart';

import '../firebase_analytics_helper.dart';

class CustomDateTimePicker extends StatefulWidget{
  final CalenderPresenter? calenderPresenter;

  CustomDateTimePicker({Key? key ,this.calenderPresenter}):super(key:key);

  @override
  State<StatefulWidget> createState() => CustomDateTimePickerState();

}

class CustomDateTimePickerState extends State<CustomDateTimePicker> with TickerProviderStateMixin{
  //
  // List<String> min = [];
  // List<String> hour = [];
  List<String> days = [];
  List<DateTime> dateTimeDays = [];
  late List<GirdItem> grids;

  int dayIndex = 0;
  // int minIndex = 0;
  // int hourIndex = 0;
  Animations _animations = new Animations();
  late AnimationController animationControllerScaleButtons;
  int modePress = 0;

  @override
  void initState(){
    // initTime();
    initDate();
    animationControllerScaleButtons = _animations.pressButton(this);
    super.initState();
  }


  shamsiFormat(Jalali dateTime){
    var registerInfo = locator<RegisterParamModel>();
    Jalali now = Jalali.now();
    final f = dateTime.formatter;

    if(registerInfo.register.nationality == 'IR'){
      if(now.year == dateTime.year && now.month == dateTime.month && now.day == dateTime.day){
        return 'امروز';
      }else{
        if(now.year == dateTime.year){
          return "${f.wN} ${f.d} ${f.mN}";
        }else{
          return "${f.wN} ${f.d} ${f.mN} ${f.yyyy}";
        }
      }
    }else{
      if(now.year == dateTime.year && now.month == dateTime.month && now.day == dateTime.day){
        return 'امروز';
      }else{
        if(now.year == dateTime.year){
          return "${f.wN} ${f.d} ${f.mnAf}";
        }else{
          return "${f.wN} ${f.d} ${f.mnAf} ${f.yyyy}";
        }
      }
    }
  }

  miladiFormat(dateTime){
    final DateFormat formatterWithYear = DateFormat('EEEE d LLL yyyy','fa');
    final DateFormat formatter = DateFormat('EEEE d LLL','fa');
    DateTime now = DateTime.now();
    if(now.year == dateTime.year && now.month == dateTime.month && now.day == dateTime.day){
      return 'امروز';
    }else{
      if(now.year == dateTime.year){
        return formatter.format(dateTime);
      }else{
        return formatterWithYear.format(dateTime);
      }
    }
  }

  // initTime(){
  //   DateTime now = DateTime.now();
  //   for(int i=0 ; i<60 ; i ++){
  //     if(i.toString().length == 1){
  //       min.add('0$i');
  //     }else{
  //       min.add('$i');
  //     }
  //   }
  //   for(int i=0 ; i<24 ; i++){
  //     if(i.toString().length == 1){
  //       hour.add('0$i');
  //     }else{
  //       hour.add('$i');
  //     }
  //   }
  //   for(int i=0 ; i<min.length ; i++){
  //     if(now.minute == int.parse(min[i])){
  //       minIndex = i;
  //     }
  //   }
  //   for(int i=0 ; i<hour.length ; i++){
  //     if(now.hour == int.parse(hour[i])){
  //       hourIndex = i;
  //     }
  //   }
  // }

  initDate()async{
    var registerInfo = locator<RegisterParamModel>();
    grids = widget.calenderPresenter!.getGridItem();
    for(int i=0 ; i<grids.length ; i++){
      for(int j=0 ; j<grids[i].cells.length ; j++){
        if(!grids[i].cells[j].isNotInMonth()){
          if(registerInfo.register.calendarType == 1){
            days.add(miladiFormat(grids[i].cells[j].dateTime));
            dateTimeDays.add(grids[i].cells[j].dateTime!);
          }else{
            days.add(shamsiFormat(Jalali.fromDateTime(grids[i].cells[j].dateTime!)));
            dateTimeDays.add(grids[i].cells[j].dateTime!);
          }
        }
      }
    }
    for(int i=0 ; i<days.length ; i++){
      if(dateTimeDays[i] == widget.calenderPresenter!.dateAddNote){
        dayIndex = i;
      }
    }
  }

  @override
  void dispose() {
    animationControllerScaleButtons.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(40)
          ),
          child: Column(
            children: [
              Container(
                width: ScreenUtil().setWidth(80),
                height: ScreenUtil().setWidth(80),
                child: new Image.asset(
                  'assets/images/ic_clock.png',
                  fit: BoxFit.fitHeight,
                  color: Color(0xff707070),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              Text(
                'تاریخ',
                style: context.textTheme.titleMedium!.copyWith(
                  color: Color(0xff707070),
                ),
              )
            ],
          ),
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(
                right: ScreenUtil().setWidth(30),
                left: ScreenUtil().setWidth(30),
                top: ScreenUtil().setWidth(52),
              bottom: ScreenUtil().setWidth(55),
            ),
            child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                    initialItem:dayIndex
                ),
                itemExtent: ScreenUtil().setWidth(110),
                onSelectedItemChanged: (index){
                  setState(() {
                    dayIndex = index;
                  });
                },
                children: List.generate(days.length, (index){
                  return  Center(
                    child:  Text(
                      days[index].toString(),
                      style:  context.textTheme.bodyMedium!.copyWith(
                        color: ColorPallet().mainColor,
                      ),
                    ),
                  );
                }
                )
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            bottom: ScreenUtil().setWidth(50),
            right:  ScreenUtil().setWidth(140),
            left:  ScreenUtil().setWidth(140),
          ),
          child:  Row(
            children: [
              Flexible(
                child:   new StreamBuilder(
                  stream: _animations.squareScaleBackButtonObserve,
                  builder: (context,AsyncSnapshot<double> snapshotScale){
                    if(snapshotScale.data != null){
                      return Transform.scale(
                          scale: modePress == 0 ? snapshotScale.data : 1,
                          child: new GestureDetector(
                            onTap: ()async{
                              AnalyticsHelper().log(
                                  AnalyticsEvents.NotePg_SetTheDateYesBtmSht_Btn_Clk,
                                  parameters: {
                                    'date' : dateTimeDays[dayIndex].toString()
                                  }
                              );
                              setState(() {
                                modePress = 0;
                              });
                              await animationControllerScaleButtons.reverse();
                              acceptDateTime();
                            },
                            child:new Container(
                                alignment: Alignment.center,
                                height: ScreenUtil().setWidth(70),
                                padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(15),
                                ),
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    gradient: new LinearGradient(
                                        colors: [
                                          Color(0xffFFA3E0),
                                          Color(0xffC33091),
                                        ],
                                        begin: Alignment.centerRight,
                                        end: Alignment.centerLeft
                                    )
                                ),
                                child:  new Text(
                                  'تایید',
                                  style: context.textTheme.labelLarge!.copyWith(
                                    color: Colors.white,
                                  ),
                                )
                            ),
                          )
                      );
                    }else{
                      return new Container();
                    }
                  },
                ),
              ),
              SizedBox(width: ScreenUtil().setWidth(50)),
              Flexible(
                child: new StreamBuilder(
                  stream: _animations.squareScaleBackButtonObserve,
                  builder: (context,AsyncSnapshot<double> snapshotScale){
                    if(snapshotScale.data != null){
                      return Transform.scale(
                          scale: modePress == 1 ? snapshotScale.data : 1,
                          child: new GestureDetector(
                            onTap: ()async{
                              AnalyticsHelper().log(AnalyticsEvents.NotePg_SetTheDateNoBtmSht_Btn_Clk);
                              setState(() {
                                modePress = 1;
                              });
                              await animationControllerScaleButtons.reverse();
                              widget.calenderPresenter!.closeDateTimePicker(context);
                            },
                            child:new Container(
                              alignment: Alignment.center,
                              height: ScreenUtil().setWidth(70),
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(20),
                              ),
                              decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Color(0xffEBEBEB)
                              ),
                              child: new Text(
                                'بیخیال',
                                style: context.textTheme.labelLarge!.copyWith(
                                  color: Color(0xff707070),
                                ),
                              ),
                            ),
                          )
                      );
                    }else{
                      return new Container();
                    }
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  acceptDateTime(){
    // TimeOfDay _time = TimeOfDay(hour: int.parse(hour[hourIndex]), minute: int.parse(min[minIndex]));
    grids = widget.calenderPresenter!.getGridItem();
    for(int i=0 ; i<grids.length ; i++){
      for(int j=0 ; j<grids[i].cells.length ; j++){
        if(
        dateTimeDays[dayIndex].year == grids[i].cells[j].dateTime!.year &&
        dateTimeDays[dayIndex].month == grids[i].cells[j].dateTime!.month &&
        dateTimeDays[dayIndex].day == grids[i].cells[j].dateTime!.day
        ){
          widget.calenderPresenter!.changeText(grids[i].cells, j, i);
        }
      }
    }
    widget.calenderPresenter!.setDateTime(dateTimeDays[dayIndex],context);
  }

}