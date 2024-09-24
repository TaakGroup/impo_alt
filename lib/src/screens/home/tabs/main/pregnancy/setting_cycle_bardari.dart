
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/dashboard_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/dialogs/qus_dialog.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/components/base_bottom_sheet.dart';
import 'package:impo/src/screens/home/tabs/main/pregnancy/widget/setting_pregnancy_date.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:intl/intl.dart' as INTL;

import '../../../../../firebase_analytics_helper.dart';


class SettingCycleBardari extends StatefulWidget {
  final DashboardPresenter? dashboardPresenter;

  SettingCycleBardari({Key? key, this.dashboardPresenter}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SettingCycleBardariState();
}


class SettingCycleBardariState extends State<SettingCycleBardari> with TickerProviderStateMixin {

  Animations animations = Animations();
  late AnimationController animationControllerScaleButtons;
  int modePress =0;
  List<String> yesOrNo = ["داشتم", "نداشتم"];

  @override
  void initState() {
    widget.dashboardPresenter!.getDefaultSettingBardari();
    animationControllerScaleButtons = animations.pressButton(this);
    widget.dashboardPresenter!.initialDialogScale(this);
    super.initState();
  }


  String format1(Date d) {
    RegisterParamViewModel register = widget.dashboardPresenter!.getRegisters();
    final f = d.formatter;
    if(register.calendarType == 0){
      if(register.nationality == 'IR'){
        return "${f.d} ${f.mN} ${f.yyyy}";
      }else{
        return "${f.d} ${f.mnAf} ${f.yyyy}";
      }
    }else{
      final INTL.DateFormat formatter = INTL.DateFormat('dd LLL yyyy','fa');
      return formatter.format(d.toDateTime());
    }
  }

  @override
  void dispose() {
    animationControllerScaleButtons.dispose();
    super.dispose();
  }


  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.SetBardariPg_Back_NavBar_Clk);
    widget.dashboardPresenter!.backSettingScreens(context);
    return Future.value(false);
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
                Column(
                  children: [
                    CustomAppBar(
                      messages: false,
                      profileTab: true,
                      icon: 'assets/images/ic_arrow_back.svg',
                      titleProfileTab: 'صفحه قبل',
                      subTitleProfileTab: 'صفحه اصلی',
                      onPressBack: (){
                        AnalyticsHelper().log(AnalyticsEvents.SetBardariPg_Back_Btn_Clk);
                        widget.dashboardPresenter!.backSettingScreens(context);
                      },
                    ),
                    Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(50)
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: ScreenUtil().setWidth(20),
                                        bottom: ScreenUtil().setWidth(15)
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: ScreenUtil().setWidth(20),
                                              left: ScreenUtil().setWidth(320),
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/images/baby_setting.svg',
                                              width: ScreenUtil().setWidth(110),
                                              height: ScreenUtil().setWidth(110),
                                            ),
                                          ),
                                          Text(
                                            'تنظیمات بارداری',
                                            textAlign: TextAlign.center,
                                            style: context.textTheme.headlineSmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'برای اینکه بهتر بتونیم کمکت کنیم لازمه که اطلاعات زیر رو با دقت کامل کنی',
                                    textAlign: TextAlign.center,
                                    style: context.textTheme.bodyMedium!.copyWith(
                                      color: ColorPallet().gray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setWidth(20)),
                            StreamBuilder(
                              stream: widget.dashboardPresenter!.pregnancyDateSelectedObserve,
                              builder: (context,AsyncSnapshot<Jalali>snapshotPregnancyDateSelected){
                                if(snapshotPregnancyDateSelected.data != null){
                                  return StreamBuilder(
                                    stream: widget.dashboardPresenter!.isDeliveryPregnancySelectedObserve,
                                    builder: (context,snapshotIsDelivery){
                                      if(snapshotIsDelivery.data != null){
                                        return item(
                                            // snapshotIsDelivery.data
                                            //     ? "تاریخ زایمان"
                                            //     : "اولین روز آخرین پریود",
                                            "هفته بارداری",
                                            "برای اینکه مشخص بشه در کدوم هفته بارداری هستی لازمه تاریخ روز زایمان یا اولین روز آخرین قاعدگیت رو مشخص کنی",
                                            "",
                                            format1(snapshotPregnancyDateSelected.data!),
                                            0
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
                            ),
                            SizedBox(height: ScreenUtil().setWidth(50)),
                            StreamBuilder(
                              stream: widget.dashboardPresenter!.pregnancyNoSelectedObserve,
                              builder: (context,AsyncSnapshot<int>snapshotPregnancyNoSelected){
                                if(snapshotPregnancyNoSelected.data != null){
                                  return item(
                                      'سابقه بارداری',
                                      "آیا تا بحال سابقه زایمان داشتی؟",
                                      "آیا تا بحال سابقه زایمان داشتی؟",
                                      yesOrNo[snapshotPregnancyNoSelected.data!],
                                      1
                                  );
                                }else{
                                  return Container();
                                }
                              },
                            ),
                            SizedBox(height: ScreenUtil().setWidth(50)),
                            StreamBuilder(
                              stream: widget.dashboardPresenter!.pregnancyAborationSelectedObserve,
                              builder: (context,AsyncSnapshot<int>snapshotPregnancyAborationSelected){
                                if(snapshotPregnancyAborationSelected.data != null){
                                  return item(
                                      'سابقه سقط',
                                      "آیا تا بحال سابقه سقط داشتی؟",
                                      "آیا تا بحال سابقه سقط داشتی؟",
                                      yesOrNo[snapshotPregnancyAborationSelected.data!],
                                      2
                                  );
                                }else{
                                  return Container();
                                }
                              },
                            ),
                            SizedBox(height: ScreenUtil().setWidth(80)),
                            StreamBuilder(
                              stream: widget.dashboardPresenter!.isLoadingObserve,
                              builder: (context,snapshotIsLoading){
                                if(snapshotIsLoading.data != null){
                                  return CustomButton(
                                    title: 'تایید و ذخیره',
                                    onPress: (){
                                      AnalyticsHelper().log(
                                          AnalyticsEvents.SetBardariPg_SaveAndAccept_Btn_Clk,
                                          parameters: {
                                            'isDeliveryDate' : widget.dashboardPresenter!.isDeliveryPregnancySelected.stream.value,
                                            'pregnancyDate': widget.dashboardPresenter!.pregnancyDateSelected.stream.value.toDateTime().toString(),
                                            'pregnancyNo' : widget.dashboardPresenter!. pregnancyNoSelected.stream.value + 1,
                                            'hasAboration' : widget.dashboardPresenter!.pregnancyAborationSelected.stream.value + 1
                                          }
                                      );
                                      widget.dashboardPresenter!.acceptSettingPregnancy(context);
                                    },
                                    colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                                    borderRadius: 20.0,
                                    enableButton: true,
                                    isLoadingButton: snapshotIsLoading.data,
                                    margin: 210,
                                  );
                                }else{
                                  return Container();
                                }
                              },
                            ),
                            SizedBox(height: ScreenUtil().setWidth(50)),
                          ],
                        )
                    )
                  ],
                ),
                StreamBuilder(
                  stream: widget.dashboardPresenter!.isShowDialogObserve,
                  builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog){
                    if(snapshotIsShowDialog.data != null){
                      if(snapshotIsShowDialog.data!){
                        return  StreamBuilder(
                          stream: widget.dashboardPresenter!.isLoadingButtonObserve,
                          builder: (context,snapshotIsLoadingButton){
                            if(snapshotIsLoadingButton.data != null){
                              return QusDialog(
                                scaleAnim: widget.dashboardPresenter!.dialogScaleObserve,
                                onPressCancel:(){
                                  AnalyticsHelper().log(AnalyticsEvents.SetBardariPg_SaveChangesDlgNo_Btn_Clk);
                                  widget.dashboardPresenter!.closeDialog(context);
                                },
                                value: "آیا از ذخیره تغییرات اطمینان داری؟",
                                yesText: 'بله',
                                noText: 'خیر',
                                onPressYes: (){
                                  AnalyticsHelper().log(
                                      AnalyticsEvents.SetBardariPg_SaveChangeDlgYes_Btn_Clk,
                                      parameters: {
                                        'isDeliveryDate' : widget.dashboardPresenter!.isDeliveryPregnancySelected.stream.value,
                                        'pregnancyDate': widget.dashboardPresenter!.pregnancyDateSelected.stream.value.toDateTime().toString(),
                                        'pregnancyNo' : widget.dashboardPresenter!. pregnancyNoSelected.stream.value + 1,
                                        'hasAboration' : widget.dashboardPresenter!.pregnancyAborationSelected.stream.value + 1
                                      }
                                  );
                                  widget.dashboardPresenter!.acceptSettingPregnancy(context);
                                },
                                isIcon: true,
                                colors:  [
                                  Colors.white,
                                  Colors.white
                                ],
                                topIcon: 'assets/images/ic_box_question.svg',
                                isLoadingButton: snapshotIsLoadingButton.data,
                              );
                            }else{
                              return Container();
                            }
                          },
                        );
                      }else{
                        return  Container();
                      }
                    }else{
                      return  Container();
                    }
                  },
                ),
              ],
            )
        ),
      )
    );
  }

  Widget item(String title,String description,String bottomSheetTitle,value,index){
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(50)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: context.textTheme.labelLargeProminent,
            ),
            Text(
              description,
              style: context.textTheme.bodySmall!.copyWith(
                color: ColorPallet().gray,
              ),
            ),
            StreamBuilder(
              stream: animations.squareScaleBackButtonObserve,
              builder: (context,AsyncSnapshot<double>snapshotScale){
                if(snapshotScale.data != null){
                  return Transform.scale(
                    scale: modePress == index ? snapshotScale.data : 1.0,
                    child: GestureDetector(
                        onTap: ()async{
                          if(this.mounted){
                            setState(() {
                              modePress = index;
                            });
                          }
                          if(index == 0){
                            AnalyticsHelper().log(AnalyticsEvents.SetBardariPg_PregnancyWeek_Btn_Clk);
                          }else if(index == 1){
                            AnalyticsHelper().enableEventsList([AnalyticsEvents.SetBardariPg_HisPrgcList_Picker_Scr_BtmSht]);
                            AnalyticsHelper().log(AnalyticsEvents.SetBardariPg_HistoryOfPregnancy_Btn_Clk);
                          }else{
                            AnalyticsHelper().enableEventsList([AnalyticsEvents.SetBardariPg_HisAbrList_Picker_Scr_BtmSht]);
                            AnalyticsHelper().log(AnalyticsEvents.SetBardariPg_HistoryOfAbortion_Btn_Clk);
                          }
                          animationControllerScaleButtons.reverse();
                          showSettingBardariBottomSheet(context,bottomSheetTitle);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: ScreenUtil().setWidth(25)
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setWidth(20),
                              horizontal: ScreenUtil().setWidth(30)
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow:[
                                BoxShadow(
                                    color: Color(0xff6E95FF).withOpacity(0.2),
                                    blurRadius: 5.0
                                )
                              ]
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                value,
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: ColorPallet().mainColor,
                                ),
                              ),
                              RotatedBox(
                                quarterTurns: 3,
                                child: SvgPicture.asset(
                                  'assets/images/ic_arrow_back.svg',
                                  width: ScreenUtil().setWidth(40),
                                  height: ScreenUtil().setWidth(40),
                                  colorFilter: ColorFilter.mode(
                                    ColorPallet().mainColor,
                                    BlendMode.srcIn
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                    ),
                  );
                }else{
                  return Container();
                }
              },
            )
          ],
        )
    );
  }

   showSettingBardariBottomSheet(BuildContext context,String title) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        context: context,
        builder: (context) {
          return BaseBottomSheet(
              onPress: (){
                if(modePress == 0){
                  AnalyticsHelper().log(AnalyticsEvents.SetBardariPg_AcptPrgcWk_Btn_Clk_BtmSht);
                }else if(modePress == 1){
                  AnalyticsHelper().log(AnalyticsEvents.SetBardariPg_AcptHisPrgc_Btn_Clk_BtmSht);
                }else{
                  AnalyticsHelper().log(AnalyticsEvents.SetBardariPg_AcptHisAbr_Btn_Clk_BtmSht);
                }
                Navigator.pop(context);
              },
              title: title,
              content: modePress == 0
                  ? SettingPregnancyDate(dashboardPresenter: widget.dashboardPresenter!,)
                  :
                  modePress == 1 ?
                      StreamBuilder(
                        stream: widget.dashboardPresenter!.pregnancyNoSelectedObserve,
                        builder: (context,AsyncSnapshot<int>snapshotPregnancyNoSelected){
                          if(snapshotPregnancyNoSelected.data != null){
                            return pregnancyNoAndAborationContent(snapshotPregnancyNoSelected.data!, context);
                          }else{
                            return Container();
                          }
                        },
                      ) :
                  StreamBuilder(
                    stream: widget.dashboardPresenter!.pregnancyAborationSelectedObserve,
                    builder: (context,AsyncSnapshot<int>snapshotPregnancyAborationSelected){
                      if(snapshotPregnancyAborationSelected.data != null){
                        return pregnancyNoAndAborationContent(snapshotPregnancyAborationSelected.data!, context);
                      }else{
                        return Container();
                      }
                    },
                  )
          );
        });
  }


  pregnancyNoAndAborationContent(int selectedIndex,BuildContext context) {
    return Container(
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
                      scrollController: FixedExtentScrollController(
                        initialItem: selectedIndex
                      ),
                      itemExtent: ScreenUtil().setWidth(110),
                      onSelectedItemChanged: (index) {
                        if(modePress == 1){
                          AnalyticsHelper().log(AnalyticsEvents.SetBardariPg_HisPrgcList_Picker_Scr_BtmSht,remainEventActive:false );
                          widget.dashboardPresenter!.onChangePregnancyNo(index);
                        }else if(modePress == 2){
                          AnalyticsHelper().log(AnalyticsEvents.SetBardariPg_HisAbrList_Picker_Scr_BtmSht,remainEventActive:false );
                          widget.dashboardPresenter!.onChangePregnancyAboration(index);
                        }
                        // setState(() {
                        //   modePress == 0
                        //       ? indexDays = index
                        //       : modePress == 1
                        //       ? indexDays = index
                        //       : indexYesOrNo = index;
                        // });
                      },
                      children: List.generate(
                          yesOrNo.length, (index) {
                        return Center(
                          child: Text(
                            yesOrNo[index],
                            style: context.textTheme.bodyMedium!.copyWith(
                                color: ColorPallet().mainColor
                            ),
                          ),
                        );
                      })),
                ))));
  }





}
