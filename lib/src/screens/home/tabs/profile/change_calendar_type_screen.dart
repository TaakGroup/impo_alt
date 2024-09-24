
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/profile_presenter.dart';
import 'package:impo/src/architecture/view/profile_view.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import '../../../../firebase_analytics_helper.dart';

class ChangeCalendarTypeScreen extends StatefulWidget{
  final ProfilePresenter? presenter;
  ChangeCalendarTypeScreen({Key? key,this.presenter}):super(key:key);
  @override
  State<StatefulWidget> createState() => ChangeCalendarTypeScreenState();

}

class ChangeCalendarTypeScreenState extends State<ChangeCalendarTypeScreen> implements ProfileView{

  late ProfilePresenter _presenter;

  ChangeCalendarTypeScreenState(){
    _presenter = ProfilePresenter(this);
  }

  List<String> types = ['شمسی','میلادی'];
  late int indexList;

  @override
  void initState() {
    AnalyticsHelper().enableEventsList([AnalyticsEvents.ChangeCalendarTpPg_ClndTpList_Picker_Scr]);
    super.initState();
  }

  Future<int> initCalendarTypes()async{
    RegisterParamViewModel register  =  _presenter.getRegister();
    if(register.calendarType == 1){
      indexList = 1;
    }else{
      indexList = 0;
    }
    return indexList;
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.ChangeCalendarTpPg_Back_NavBar_Clk);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = 0.5;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
               Padding(
                padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(80)),
                child:  CustomAppBar(
                  messages: false,
                  profileTab: true,
                  isEmptyLeftIcon: true,
                  icon: 'assets/images/ic_arrow_back.svg',
                  titleProfileTab: 'صفحه قبل',
                  subTitleProfileTab: 'نوع تقویم',
                  onPressBack: (){
                    AnalyticsHelper().log(AnalyticsEvents.ChangeCalendarTpPg_Back_Btn_Clk);
                    Navigator.pop(context);
                  },
                ),
              ),
              Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(320),
                              ),
                              child: SvgPicture.asset(
                                'assets/images/ic_big_calendar-type.svg',
                                width: ScreenUtil().setWidth(180),
                                height: ScreenUtil().setWidth(180),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: ScreenUtil().setWidth(20),
                              ),
                              child: Text(
                                'نوع تقویم',
                                style:  context.textTheme.headlineMedium!.copyWith(
                                  color: ColorPallet().gray,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(
                            top: ScreenUtil().setWidth(50)
                        ),
                        child: Text(
                          'ایمپویی عزیز\nلطفا نوع تقویم خودتو انتخاب کن',
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodyLarge!.copyWith(
                            color: ColorPallet().gray,
                          ),
                        ),
                      ),
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(50),
                            bottom: ScreenUtil().setWidth(100),
                          ),
                          height: ScreenUtil().setWidth(220),
                          child:  Center(
                              child:  NotificationListener<OverscrollIndicatorNotification>(
                                  onNotification: (overscroll){
                                    overscroll.disallowIndicator();
                                    return true;
                                  },
                                  child: FutureBuilder(
                                    future: initCalendarTypes(),
                                    builder: (context,AsyncSnapshot<int>snapshot){
                                      if(snapshot.data != null){
                                        return   CupertinoPicker(
                                            scrollController: FixedExtentScrollController(initialItem:snapshot.data!),
                                            itemExtent: ScreenUtil().setWidth(100),
                                            onSelectedItemChanged: (index){
                                              AnalyticsHelper().log(AnalyticsEvents.ChangeCalendarTpPg_ClndTpList_Picker_Scr,remainEventActive: false);
                                              indexList = index;
                                            },
                                            children: List.generate(types.length, (index){
                                              return  Center(
                                                child:  Text(
                                                  types[index],
                                                  style:  context.textTheme.bodyMedium!.copyWith(
                                                      color: ColorPallet().mainColor
                                                  ),
                                                ),
                                              );
                                            })
                                        );
                                      }else{
                                        return Container();
                                      }
                                    },
                                  )
                              )
                          )
                      ),
                      StreamBuilder(
                        stream: _presenter.isLoadingObserve,
                        builder: (context,snapshotIsLoading){
                          if(snapshotIsLoading.data != null){
                            return  CustomButton(
                              title: 'ثبت ویرایش',
                              onPress: changeCalendarType,
                              enableButton: true,
                              isLoadingButton: snapshotIsLoading.data,
                              colors: [
                                ColorPallet().mentalHigh,ColorPallet().mentalMain
                              ],
                            );
                          }else{
                            return Container();
                          }
                        },
                      )
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  changeCalendarType()async{
    var registerInfo = locator<RegisterParamModel>();
    RegisterParamViewModel register = registerInfo.register;

    Map<String,dynamic> generalInfo = {
      'name' : register.name,
      'periodDay' : register.periodDay,
      'circleDay' :  register.circleDay,
      'lastPeriod' : register.lastPeriod,
      'birthDay' : register.birthDay,
      'typeSex' :  register.sex,
      'nationality' : register.nationality,
      'token' :   register.token,
      'calendarType' : indexList,
      'periodStatus' : register.periodStatus,
    };
    AnalyticsHelper().log(AnalyticsEvents.ChangeCalendarTpPg_Edit_Btn_Clk);
    await _presenter.setGeneralInfo(generalInfo,context,widget.presenter!,true);
  }



  @override
  void onError(msg) {
  }

  @override
  void onSuccess(value) {
  }

}