import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/register_presenter.dart';
import 'package:impo/src/architecture/view/register_view.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import '../../../firebase_analytics_helper.dart';
import '../../../models/register/register_parameters_model.dart';

class TypeBirthRegisterScreen extends StatefulWidget {
  @override
  State<TypeBirthRegisterScreen> createState() => TypeBirthRegisterScreenState();
}

class TypeBirthRegisterScreenState extends State<TypeBirthRegisterScreen> with TickerProviderStateMixin implements RegisterView {
  late RegisterPresenter _presenter;
  Animations _animations =  Animations();

  TypeBirthRegisterScreenState() {
    _presenter = RegisterPresenter(this);
  }

  List<String> yesOrNo = ["طبیعی", "سزارین"];

  int indexType = 0;

  @override
  void initState() {
    AnalyticsHelper().enableEventsList([AnalyticsEvents.TpBirthRegPg_TpBirthList_Picker_Scr]);
    _animations.shakeError(this);
    super.initState();
  }

  @override
  void dispose() {
    _animations.animationControllerShakeError.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.TpBirthRegPg_Back_NavBar_Clk);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    CustomAppBar(
                      messages: false,
                      profileTab: true,
                      icon: 'assets/images/ic_arrow_back.svg',
                      titleProfileTab: 'صفحه قبل',
                      subTitleProfileTab: '',
                      onPressBack: () {
                        AnalyticsHelper().log(AnalyticsEvents.TpBirthRegPg_Back_Btn_Clk);
                        Navigator.pop(context);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setWidth(180),
                        right: ScreenUtil().setWidth(50),
                        left: ScreenUtil().setWidth(50),
                      ),
                      child: Text(
                        'لطفا نوع زایمانت رو انتخاب کن',
                        textAlign: TextAlign.center,
                        style: context.textTheme.labelLargeProminent!.copyWith(
                            color: ColorPallet().gray
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(45)),
                    Container(
                        alignment: Alignment.center,
                        height: ScreenUtil().setWidth(350),
                        child: Center(
                            child: NotificationListener<OverscrollIndicatorNotification>(
                                onNotification: (overscroll) {
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
                                  child: CupertinoPicker(
                                      scrollController: FixedExtentScrollController(initialItem: 0),
                                      itemExtent: ScreenUtil().setWidth(110),
                                      onSelectedItemChanged: (index) {
                                        AnalyticsHelper().log(AnalyticsEvents.TpBirthRegPg_TpBirthList_Picker_Scr,remainEventActive:false );
                                        setState(() {
                                          indexType = index;
                                        });
                                      },
                                      children: List.generate(yesOrNo.length, (index) {
                                        return Center(
                                          child: Text(
                                            yesOrNo[index],
                                            style: context.textTheme.bodyMedium!.copyWith(
                                              color: ColorPallet().mainColor
                                            ),
                                          ),
                                        );
                                      })),
                                )))),
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
                                                  style:   context.textTheme.bodySmall!.copyWith(
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
                    SizedBox(
                      height: ScreenUtil().setWidth(40),
                    ),
                    Align(
                      child: Padding(
                        padding: EdgeInsets.only(top: ScreenUtil().setWidth(0)),
                        child: StreamBuilder(
                          stream: _presenter.isLoadingObserve,
                          builder: (context,snapshotIsLoading){
                            if(snapshotIsLoading.data != null){
                              return CustomButton(
                                title: 'تایید',
                                onPress: accept,
                                colors: [ColorPallet().mentalHigh, ColorPallet().mentalMain],
                                borderRadius: 10.0,
                                enableButton: true,
                                isLoadingButton: snapshotIsLoading.data,
                              );
                            }else{
                              return Container();
                            }
                          },
                        )
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  accept() {
    int typeBirth = 0;
    var registerInfo = locator<RegisterParamModel>();

    if (yesOrNo[indexType] == 'طبیعی') typeBirth = 1;

    if (yesOrNo[indexType] == 'سزارین') typeBirth = 2;

    registerInfo.setChildBirthType(typeBirth);
    AnalyticsHelper().log(AnalyticsEvents.TpBirthRegPg_Accept_Btn_Clk);
    _presenter.requestChangeStatus(3,_animations,context,false);
    // _presenter.enterLactation(context);
  }

  @override
  void onError(msg) {}

  @override
  void onSuccess(value) {}
}
