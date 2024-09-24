

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/packages/flutter_material_pickers-3.6.0/helpers/show_scroll_picker.dart';
import 'package:impo/src/architecture/presenter/profile_presenter.dart';
import 'package:impo/src/architecture/view/profile_view.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import '../../../../firebase_analytics_helper.dart';

class ChangeCirclesValue extends StatefulWidget{
  final modeChange;

  ChangeCirclesValue({Key? key,this.modeChange}):super(key:key);

  @override
  State<StatefulWidget> createState() => ChangeCirclesValueState();

}

class ChangeCirclesValueState extends State<ChangeCirclesValue> with TickerProviderStateMixin implements ProfileView{

  late ProfilePresenter _presenter;

  ChangeCirclesValueState(){
    _presenter = ProfilePresenter(this);
  }

  late AnimationController animationControllerScaleButton;

  Animations _animations =  Animations();

  int indexDays  = 0;

  List<String> circleDays = [];

  List<String> dayPereoids = ['2 روز','3 روز','4 روز','5 روز','6 روز','7 روز','8 روز','9 روز','10 روز'];

  bool isApi19 = false;

  String selectedCircleDay = '';
  String selectedPeriodDay = '';

  // DataBaseProvider db =  DataBaseProvider();

  @override
  void initState() {
    if(widget.modeChange == 0){
      AnalyticsHelper().enableEventsList([AnalyticsEvents.ChangeCycleValuePg_CyclesLength_Picker_Scr]);
      generateCircleDays();
    }else{
      AnalyticsHelper().enableEventsList([AnalyticsEvents.ChangePeriodValuePg_PeriodLength_Picker_Scr]);
      generatePeriodDays();
    }

    animationControllerScaleButton = _animations.pressButton(this);

    super.initState();
  }

  Future<int> checkAndroidVersion()async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if(androidInfo.version.sdkInt <= 19){
      setState(() {
        isApi19 = true;
      });
    }else{
      setState(() {
        isApi19 = false;
      });
    }
    return androidInfo.version.sdkInt;
  }

  generateCircleDays(){

    for(int i=1 ; i < 42 ; i++){
      circleDays.add('${i+19} روز ');
//      int days = int.parse(circleDays[i].toString().replaceAll('روز', ''));
//      if(days == widget.RegisterParamViewModel.circleDay){
//        indexDays = days - 20;
//      }
    }

    var registerInfo = locator<RegisterParamModel>();
    RegisterParamViewModel register = registerInfo.register;

    for(int i=0 ; i<circleDays.length ; i++){
      int days = int.parse(circleDays[i].toString().replaceAll('روز', ''));
      if(days == register.circleDay){
        indexDays = days - 20;
        if(register.periodDay == 6){
          indexDays = days - 21;
        }else if((register.periodDay ) == 7){
          indexDays = days - 22;
        }else if(register.periodDay == 8){
          indexDays = days - 23;
        }else if(register.periodDay == 9){
          indexDays = days - 24;
        }else if(register.periodDay == 10){
          indexDays = days - 25;
        }
      }
    }

    if(register.periodDay == 6){
      circleDays.removeRange(0,1);
    }else if((register.periodDay ) == 7){
      circleDays.removeRange(0, 2);
    }else if(register.periodDay == 8){
      circleDays.removeRange(0, 3);
    }else if(register.periodDay == 9){
      circleDays.removeRange(0, 4);
    }else if(register.periodDay == 10){
      circleDays.removeRange(0, 5);
    }
    print(indexDays);
    if(indexDays >= 0){
      selectedCircleDay = circleDays[indexDays];
    }

  }

  generatePeriodDays(){

    var registerInfo = locator<RegisterParamModel>();
    RegisterParamViewModel register = registerInfo.register;

    for(int i= register.circleDay! ; i < 25 ; i++){
      dayPereoids.removeAt(dayPereoids.length-1);
    }

    for(int i=0 ; i<dayPereoids.length ; i++){
      int days = int.parse(dayPereoids[i].toString().replaceAll('روز', ''));
      if(days == register.periodDay){
        indexDays = days-2;
      }
    }
    print(indexDays);
    if(indexDays >= 0){
      selectedPeriodDay = dayPereoids[indexDays];
    }
  }

  // int _currentValue = 0;

  Future<bool> _onWillPop()async{
    if(widget.modeChange == 0){
      AnalyticsHelper().log(AnalyticsEvents.ChangeCycleValuePg_Back_NavBar_Clk);
    }else{
      AnalyticsHelper().log(AnalyticsEvents.ChangePeriodValuePg_Back_NavBar_Clk);
    }
    Navigator.pop(context);
    // Navigator.pushReplacement(
    //     context,
    //     PageTransition(
    //         type: PageTransitionType.fade,
    //         duration: Duration(milliseconds: 500),
    //         child:  FeatureDiscovery(
    //             recordStepsInSharedPreferences: true,
    //             child: ProfileScreen()
    //         )
    //     )
    // );
    return Future.value(false);
  }

  var registerInfo = locator<RegisterParamModel>();

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = 0.5;
    return  WillPopScope(
        onWillPop: _onWillPop,
        child:  Directionality(
          textDirection: TextDirection.rtl,
          child:  Scaffold(
            backgroundColor: Colors.white,
            body:  Stack(
//          mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                 Align(
                  alignment: Alignment.topCenter,
                  child:  Padding(
                    padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(80)),
                    child:  CustomAppBar(
                      messages: false,
                      profileTab: true,
                      isEmptyLeftIcon: true,
                      icon: 'assets/images/ic_arrow_back.svg',
                      titleProfileTab: 'صفحه قبل',
                      subTitleProfileTab: widget.modeChange == 0 ? "تغییر طول کل دوره" : "تغییر طول پریود",
                      onPressBack: (){
                        if(widget.modeChange == 0){
                          AnalyticsHelper().log(AnalyticsEvents.ChangeCycleValuePg_Back_Btn_Clk);
                        }else{
                          AnalyticsHelper().log(AnalyticsEvents.ChangePeriodValuePg_Back_Btn_Clk);
                        }
                        Navigator.pop(context);
                        // Navigator.pushReplacement(
                        //     context,
                        //     PageTransition(
                        //         type: PageTransitionType.fade,
                        //         duration: Duration(milliseconds: 500),
                        //         child:  FeatureDiscovery(
                        //             recordStepsInSharedPreferences: true,
                        //             child: ProfileScreen()
                        //         )
                        //     )
                        // );
                      },
                    ),
                  ),
                ),
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: ScreenUtil().setWidth(100)
                      ),
                      child:  widget.modeChange == 0 ?
                      Column(
                        children: [
                          Text(
                            '${registerInfo.register.name} جان، طول دوره پریودت رو انتخاب کن',
                            textAlign: TextAlign.center,
                            style: context.textTheme.labelLargeProminent!.copyWith(
                              color: ColorPallet().gray,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setWidth(8)),
                          Text(
                            'از شروع یک پریود تا شروع پریود بعدیت چند روز طول می‌کشه؟',
                            textAlign: TextAlign.center,
                            style:  context.textTheme.bodySmall!.copyWith(
                              color: Color(0xff707070),
                            ),
                          ),
                        ],
                      ) :
                      Text(
                        'معمولا پریودت چند روز طول میکشه ؟',
                        textAlign: TextAlign.center,
                        style: context.textTheme.labelLargeProminent!.copyWith(
                          color: ColorPallet().gray,
                        ),
                      ),
                    ),
                    Platform.isAndroid ?
                     FutureBuilder(
                      future: checkAndroidVersion(),
                      builder: (context,AsyncSnapshot<int>snapshot){
                        if(snapshot.data != null){
                          if(snapshot.data! <= 19){
                            return   CustomButton(
                              title: widget.modeChange == 0 ? selectedCircleDay : selectedPeriodDay,
                              center: true,
                              onPress: (){
                                showMaterialScrollPicker(
                                  context: context,
                                  showDivider: false,
                                  title: widget.modeChange == 0 ? 'طول کل دوره' : 'طول پریود',
                                  confirmText: 'انتخاب',
                                  cancelText: 'لغو',
                                  items: widget.modeChange == 0 ? circleDays : dayPereoids,
                                  selectedItem: widget.modeChange == 0 ? selectedCircleDay : selectedPeriodDay,
                                  onChanged: (String value){
                                    setState(() {
                                      if(widget.modeChange == 0){
                                        selectedCircleDay = value;
                                      }else{
                                        selectedPeriodDay = value;
                                      }
                                    });
                                  },
                                );
                              },
                              enableButton: true,
                            );
                          }else{
                            return   Container(
                                alignment: Alignment.center,
                                height: ScreenUtil().setWidth(200),
                                child:  Center(
                                  child: Theme(
                                    data: ThemeData(
                                        cupertinoOverrideTheme: CupertinoThemeData(
                                            textTheme: CupertinoTextThemeData(
                                              pickerTextStyle: TextStyle(color: ColorPallet().mainColor),
                                            )
                                        )
                                    ),
                                    child:  CupertinoPicker(
                                        scrollController: FixedExtentScrollController(initialItem:indexDays),
                                        itemExtent: ScreenUtil().setWidth(100),
                                        onSelectedItemChanged: (index){
                                          if(widget.modeChange == 0){
                                            AnalyticsHelper().log(AnalyticsEvents.ChangeCycleValuePg_CyclesLength_Picker_Scr,remainEventActive: false);
                                          }else{
                                            AnalyticsHelper().log(AnalyticsEvents.ChangePeriodValuePg_PeriodLength_Picker_Scr,remainEventActive: false);
                                          }
                                          setState(() {
                                            indexDays = index;
                                          });
                                        },
                                        children: widget.modeChange == 0 ?
                                        List.generate(circleDays.length, (index){
                                          return  Center(
                                            child:  Text(
                                              circleDays[index],
                                              style:  context.textTheme.bodyLarge!.copyWith(
                                                  color: ColorPallet().mainColor
                                              ),
                                            ),
                                          );
                                        }) : List.generate(dayPereoids.length, (index){
                                          return  Center(
                                            child:  Text(
                                              dayPereoids[index],
                                              style:  context.textTheme.bodyLarge!.copyWith(
                                                  color: ColorPallet().mainColor
                                              ),
                                            ),
                                          );
                                        })
                                    ),
                                  )

                                )
                            );
                          }
                        }else{
                          return  Container();
                        }
                      },
                    )
                        :
                     Container(
                        alignment: Alignment.center,
                        height: ScreenUtil().setWidth(200),
                        child:  Center(
                          child: Theme(
                            data: ThemeData(
                                cupertinoOverrideTheme: CupertinoThemeData(
                                    textTheme: CupertinoTextThemeData(
                                      pickerTextStyle: TextStyle(color: ColorPallet().mainColor),
                                    )
                                )
                            ),
                            child:  CupertinoPicker(

                                scrollController: FixedExtentScrollController(initialItem:indexDays),
                                itemExtent: ScreenUtil().setWidth(100),
                                onSelectedItemChanged: (index){
                                  if(widget.modeChange == 0){
                                    AnalyticsHelper().log(AnalyticsEvents.ChangeCycleValuePg_CyclesLength_Picker_Scr,remainEventActive: false);
                                  }else{
                                    AnalyticsHelper().log(AnalyticsEvents.ChangePeriodValuePg_PeriodLength_Picker_Scr,remainEventActive: false);
                                  }
                                  setState(() {
                                    indexDays = index;
                                  });
                                },
                                children: widget.modeChange == 0 ?
                                List.generate(circleDays.length, (index){
                                  return  Center(
                                    child:  Text(
                                      circleDays[index],
                                      style:  context.textTheme.bodyLarge!.copyWith(
                                          color: ColorPallet().mainColor
                                      ),
                                    ),
                                  );
                                }) : List.generate(dayPereoids.length, (index){
                                  return  Center(
                                    child:  Text(
                                      dayPereoids[index],
                                      style:  context.textTheme.bodyLarge!.copyWith(
                                          color: ColorPallet().mainColor
                                      ),
                                    ),
                                  );
                                })
                            ),
                          )

                        )
                    ),
//                HorizantalPicker(
//                  minValue: 0,
//                  maxValue: 50,
//                  divisions: 50,
//                  suffix: "",
//                  showCursor: false,
//                  backgroundColor: Colors.white,
//                  activeItemTextColor: Colors.black,
//                  passiveItemsTextColor: Colors.black.withOpacity(.3),
//                  onChanged: (value) {},
//                ),
//                 NumberPicker.integer(
//                    listViewWidth: MediaQuery.of(context).size.width,
//                    scrollDirection: Axis.horizontal,
//                    initialValue: _currentValue,
//                    minValue: 0,
//                    maxValue: 100,
//                    onChanged: (Value) =>
//                        setState(() => _currentValue = Value)),
                     Padding(
                      padding: EdgeInsets.only(
                          top: ScreenUtil().setWidth(100)
                      ),
                      child: StreamBuilder(
                        stream: _presenter.isLoadingObserve,
                        builder: (context,snapshotIsLoading){
                          if(snapshotIsLoading.data != null){
                            return CustomButton(
                              title: 'ویرایش',
                              onPress: ()async{
                                if(widget.modeChange == 0){
                                  AnalyticsHelper().log(AnalyticsEvents.ChangeCycleValuePg_Edit_Btn_Clk);
                                  if(isApi19){
                                    await _presenter.onPressChangeCircleDays(context,selectedCircleDay);
                                  }else{
                                    await _presenter.onPressChangeCircleDays(context,circleDays[indexDays]);
                                  }
                                }else{
                                  AnalyticsHelper().log(AnalyticsEvents.ChangePeriodValuePg_Edit_Btn_Clk);
                                  if(isApi19){
                                    await _presenter.onPressChangePeriodDays(context,selectedPeriodDay);
                                  }else{
                                    await _presenter.onPressChangePeriodDays(context,dayPereoids[indexDays]);
                                  }
                                }
                                /// await _presenter.removeTable('SugMessages');
                                /// updateLocalNotification();
                                /// AutoBackup().setCycleInfoAndCycleCalender();
                              },
                              colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                              enableButton: true,
                              isLoadingButton: snapshotIsLoading.data,
                            );
                          }else{
                            return Container();
                          }
                        },
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );

  }

  /// updateLocalNotification(){
  ///   GenerateDashboardAndNotifyMessages().checkForNotificationMessage();
  /// }

  @override
  void onError(msg) {

  }

  @override
  void onSuccess(msg){

  }

}