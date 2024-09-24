import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/dashboard_presenter.dart';
import 'package:impo/src/components/calender.dart';
import 'package:impo/src/components/colors.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:shamsi_date/extensions.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../../../../../firebase_analytics_helper.dart';


class SettingPregnancyDate extends StatefulWidget {

  final DashboardPresenter? dashboardPresenter;


  const SettingPregnancyDate({Key? key, this.dashboardPresenter}) : super(key: key);

  @override
  State<SettingPregnancyDate> createState() => SettingPregnancyDateState();
}

class SettingPregnancyDateState extends State<SettingPregnancyDate>   {


  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  int modePress = 0;


  late Calender calender;

  RegisterParamViewModel getRegister(){
    return widget.dashboardPresenter!.getRegisters();
  }

  @override
  Widget build(BuildContext context) {
   /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: StreamBuilder(
        stream: widget.dashboardPresenter!.isDeliveryPregnancySelectedObserve,
        builder: (context,AsyncSnapshot<bool>snapshotisDelivery){
          if(snapshotisDelivery.data != null){
            return Column(
              children: [
                !isLoading ?
                Container(
                  // height: ScreenUtil().setHeight(120),
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(30),
                        vertical: ScreenUtil().setWidth(30)),
                    child: Text(
                      snapshotisDelivery.data! ?
                      'هفته بارداری براساس تاریخ زایمان' :
                      'هفته بارداری براساس تاریخ اولین روز آخرین پریود',
                      style: context.textTheme.bodyMedium!.copyWith(
                        color: ColorPallet().gray,
                      ),
                    )) :  Container(
                  height: ScreenUtil().setHeight(120),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(30)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Transform.scale(
                        scale: 1.0,
                        child: _itemsBirthOrcycle(
                          0,
                        ),
                      ),
                      Container(
                        child: Text(
                          "یا",
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: ColorPallet().gray,
                          ),
                        ),
                      ),
                      Transform.scale(
                        scale: 1.0,
                        child: _itemsBirthOrcycle(1),
                      ),
                    ],
                  ),
                ),
                !isLoading ?
                StreamBuilder(
                  stream: widget.dashboardPresenter!.pregnancyDateSelectedObserve,
                  builder: (context,AsyncSnapshot<Jalali>snapshotPregnancyDateSelected){
                    if(snapshotPregnancyDateSelected.data != null){
                      return  Container(
                          height: ScreenUtil().setWidth(350),
                          child: calender =  Calender(
                            isBirthDate: false,
                            dateTime: snapshotPregnancyDateSelected.data,
                            // typeCalendar: snapshotisDelivery.data ? 1 : 2,
                            maxDate: snapshotisDelivery.data! ?
                            Jalali.fromDateTime( DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day + 279
                            )
                            ) : Jalali.fromDateTime(
                                DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day
                                )
                            ),
                            minDate: snapshotisDelivery.data! ?
                            Jalali.fromDateTime(  DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day
                            )) : Jalali.fromDateTime(
                                DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day - 279
                                )
                            ),
                            onChange: (){
                              widget.dashboardPresenter!.onChangePregnancyDate(calender.getDateTime());
                            },
                          )
                      );
                    }else{
                      return Container( height: ScreenUtil().setWidth(350),);
                    }
                  },
                )
                    :
                Container(
                  height: ScreenUtil().setWidth(350),
                ),
              ],
            );
          }else{
            return Container();
          }
        },
      )
    );
  }

   DateTime getDateTime(int _typeValue){
    if(_typeValue == 0){
      return   DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day + 1);
    }else{
     return DateTime.now();
    }
  }

 Jalali getJalaliDateTime(int _typeValue){
    if(_typeValue == 0){
      return Jalali.fromDateTime(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day + 1));
    }else{
      return Jalali.now();
    }
  }

  _itemsBirthOrcycle(int _typeValue) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          modePress = _typeValue;
          isLoading = true;
        });
        widget.dashboardPresenter!.changeIsDeliveryPregnancy(_typeValue == 0 ? true : false);
        widget.dashboardPresenter!.onChangePregnancyDate(
          // getRegister().calendarType == 1 ?
          // getDateTime(_typeValue) : getJalaliDateTime(_typeValue)
            getRegister().calendarType == 1 ?
            DateTime.now() : Jalali.now()
        );
        setState(() {
          for (int i = 0; i < widget.dashboardPresenter!.itemsBirthOrcycle.length; i++) {
            widget.dashboardPresenter!.itemsBirthOrcycle[i].selected = false;
          }
          widget.dashboardPresenter!.itemsBirthOrcycle[_typeValue].selected =
          !widget.dashboardPresenter!.itemsBirthOrcycle[_typeValue].selected!;
        });
        Timer(Duration(milliseconds: 30),(){
          setState(() {
            isLoading = false;
          });
        });
        if(_typeValue == 0){
          AnalyticsHelper().log(AnalyticsEvents.SetBardariPg_DateOfBirth_Btn_Clk_BtmSht);
        }else{
          AnalyticsHelper().log(AnalyticsEvents.SetBardariPg_LastPeriod_Btn_Clk_BtmSht);
        }
      },
      child: Container(
        width: ScreenUtil().setWidth(290),
        height: ScreenUtil().setWidth(66),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
              color: !widget.dashboardPresenter!.itemsBirthOrcycle[_typeValue].selected!
                  ? ColorPallet().mentalMain
                  : Colors.white),
          gradient: LinearGradient(
              colors: widget.dashboardPresenter!.itemsBirthOrcycle[_typeValue].selected!
                  ? [
                ColorPallet().mentalHigh,
                ColorPallet().mentalMain,
              ]
                  : [Colors.white, Colors.white]),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(10),
              vertical: ScreenUtil().setWidth(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  widget.dashboardPresenter!.itemsBirthOrcycle[_typeValue].title!,
                  textAlign: TextAlign.center,
                  style: context.textTheme.labelMedium!.copyWith(
                    color: widget.dashboardPresenter!.itemsBirthOrcycle[_typeValue].selected!
                        ? Colors.white
                        : ColorPallet().mentalMain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



}
