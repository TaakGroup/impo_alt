import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/dashboard_presenter.dart';
import 'package:impo/src/components/base_bottom_sheet.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/dialogs/qus_dialog.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/home/tabs/main/breastfeeding/widget/child_birth_date_content.dart';
import 'package:impo/src/screens/home/tabs/main/breastfeeding/widget/child_type_and_name_content.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:intl/intl.dart' as INTL;

import '../../../../../components/animations.dart';
import '../../../../../firebase_analytics_helper.dart';


class SettingCycleBreastfeeding extends StatefulWidget {
  final DashboardPresenter? dashboardPresenter;

  SettingCycleBreastfeeding({Key? key, this.dashboardPresenter}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SettingCycleBreastfeedingState();
}

class SettingCycleBreastfeedingState extends State<SettingCycleBreastfeeding> with TickerProviderStateMixin {
  Animations animations = Animations();
  late AnimationController animationControllerScaleButtons;
  late AnimationController controller;

  int modePress = 0;
  List<String> yesOrNo = ["طبیعی", "سزارین"];
  @override
  void initState() {
    widget.dashboardPresenter!.getDefaultSettingLactation();
    animationControllerScaleButtons = animations.pressButton(this);
    widget.dashboardPresenter!.initialDialogScale(this);
    controller = BottomSheet.createAnimationController(this);
    controller.duration = Duration(seconds: 1);
    animations.shakeError(this);
    super.initState();
  }

  String format1(Date d) {
    RegisterParamViewModel register = widget.dashboardPresenter!.getRegisters();
    final f = d.formatter;
    if (register.calendarType == 0) {
      if (register.nationality == 'IR') {
        return "${f.d} ${f.mN} ${f.yyyy}";
      } else {
        return "${f.d} ${f.mnAf} ${f.yyyy}";
      }
    } else {
      final INTL.DateFormat formatter = INTL.DateFormat('dd LLL yyyy', 'fa');
      return formatter.format(d.toDateTime());
    }
  }

  @override
  void dispose() {
    animationControllerScaleButtons.dispose();
    controller.dispose();
    animations.animationControllerShakeError.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    AnalyticsHelper().log(AnalyticsEvents.SetBrstfeedPg_Back_NavBar_Clk);
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
                        onPressBack: () {
                          AnalyticsHelper().log(AnalyticsEvents.SetBrstfeedPg_Back_Btn_Clk);
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
                                          bottom: ScreenUtil().setWidth(15)),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: ScreenUtil().setWidth(20),
                                                left: ScreenUtil().setWidth(270),
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/images/breastfeeding_setting.svg',
                                                width: ScreenUtil().setWidth(160),
                                                height: ScreenUtil().setWidth(160),
                                              ),
                                            ),
                                            Text(
                                              // "تنظیمات دوره شیردهی",
                                              "تنظیمات",
                                              textAlign: TextAlign.center,
                                              style:context.textTheme.headlineSmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setWidth(16)
                                      ),
                                      child: Text(
                                        'برای اینکه بهتر بتونیم در دوران پس از زایمان و تا قبل از شروع مجدد قاعدگی، کمکت کنیم لازمه اطلاعات زیر رو تکمیل کنی',
                                        textAlign: TextAlign.center,
                                        style: context.textTheme.bodyMedium!.copyWith(
                                          color: ColorPallet().gray,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: ScreenUtil().setWidth(20)),
                                  ],
                                ),
                              ),
                              StreamBuilder(
                                stream: widget.dashboardPresenter!
                                    .childBirthDateSelectedObserve,
                                builder: (context, AsyncSnapshot<Jalali>snapshotchildBirthDateSelected) {
                                  if (snapshotchildBirthDateSelected.data != null) {
                                    return item(
                                        "تاریخ زایمان",
                                        "با انتخاب تاریخ زایمانت، بهتر می‌تونیم بهت کمک کنیم",
                                        "تاریخ زایمان",
                                        format1(
                                            snapshotchildBirthDateSelected.data!),
                                        0);
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                              SizedBox(height: ScreenUtil().setWidth(50)),
                              StreamBuilder(
                                stream: widget.dashboardPresenter!.childTypeSelectedObserve,
                                builder: (context,
                                    AsyncSnapshot<int> snapshotChildTypeSelected) {
                                  if (snapshotChildTypeSelected.data != null) {
                                    return item(
                                        'جنسیت',
                                        "جنسیت کوچولوی قشنگت رو انتخاب کن",
                                        "جنسیت کوچولوی قشنگت رو انتخاب کن",
                                        widget.dashboardPresenter!.specificationBabyModel[snapshotChildTypeSelected.data!]
                                            .title,
                                        1);
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                              SizedBox(height: ScreenUtil().setWidth(50)),
                              StreamBuilder(
                                stream: widget.dashboardPresenter!
                                    .childBirthTypeSelectedObserve,
                                builder: (context, AsyncSnapshot<int>snapshotChildBirthTypeSelected) {
                                  if (snapshotChildBirthTypeSelected.data != null) {
                                    return item(
                                        'نوع زایمان',
                                        "با انتخاب نوع زایمانت، بهتر می‌تونیم بهت کمک کنیم",
                                        "نوع زایمان",
                                        yesOrNo[snapshotChildBirthTypeSelected.data!],
                                        2);
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                              SizedBox(height: ScreenUtil().setWidth(80)),
                              StreamBuilder(
                                stream: widget.dashboardPresenter!.isLoadingObserve,
                                builder: (context, snapshotIsLoading) {
                                  if (snapshotIsLoading.data != null) {
                                    return CustomButton(
                                      title: 'تایید و ذخیره',
                                      onPress: () {
                                        widget.dashboardPresenter!
                                            .validation(context, animations)
                                            ? widget.dashboardPresenter!
                                            .acceptSettingBreastfeeding(
                                            context, animations,false)
                                            : showSettingLactationBottomSheet(
                                            context, "مشخصات بچه؟", 1);
                                      },
                                      colors: [
                                        ColorPallet().mentalHigh,
                                        ColorPallet().mentalMain
                                      ],
                                      borderRadius: 20.0,
                                      enableButton: true,
                                      isLoadingButton: snapshotIsLoading.data,
                                      margin: 210,
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                              SizedBox(height: ScreenUtil().setWidth(50)),
                            ],
                          ))
                    ],
                  ),
                  StreamBuilder(
                    stream: widget.dashboardPresenter!.isShowDialogObserve,
                    builder: (context, AsyncSnapshot<bool>snapshotIsShowDialog) {
                      if (snapshotIsShowDialog.data != null) {
                        if (snapshotIsShowDialog.data!) {
                          return StreamBuilder(
                            stream: widget.dashboardPresenter!.isLoadingButtonObserve,
                            builder: (context, snapshotIsLoadingButton) {
                              if (snapshotIsLoadingButton.data != null) {
                                return QusDialog(
                                  scaleAnim: widget.dashboardPresenter!.dialogScaleObserve,
                                  onPressCancel: () {
                                    AnalyticsHelper().log(AnalyticsEvents.SetBrstfeedPg_SaveChangesDlgNo_Btn_Clk);
                                    widget.dashboardPresenter!.closeDialog(context);
                                  },
                                  value: "آیا از ذخیره تغییرات اطمینان داری؟",
                                  yesText: 'بله',
                                  noText: 'خیر',
                                  onPressYes: () {
                                    widget.dashboardPresenter!
                                        .validation(context, animations)
                                        ? widget.dashboardPresenter!
                                        .acceptSettingBreastfeeding(
                                        context, animations,true)
                                        : showSettingLactationBottomSheet(
                                        context, "مشخصات بچه؟", 1);
                                  },
                                  isIcon: true,
                                  colors: [Colors.white, Colors.white],
                                  topIcon: 'assets/images/ic_box_question.svg',
                                  isLoadingButton: snapshotIsLoadingButton.data,
                                );
                              } else {
                                return Container();
                              }
                            },
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              )
          ),
        ));
  }

  Widget item(String title, String description, String bottomSheetTitle, value, index) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)),
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
              builder: (context,AsyncSnapshot<double>snapshotScale) {
                if (snapshotScale.data != null) {
                  return Transform.scale(
                    scale: modePress == index ? snapshotScale.data : 1.0,
                    child: GestureDetector(
                        onTap: () async {
                          if (this.mounted) {
                            setState(() {
                              modePress = index;
                            });
                          }
                          animationControllerScaleButtons.reverse();
                          modePress == 1
                              ? Future.delayed(Duration(microseconds: 1), () {
                            widget.dashboardPresenter!
                                .validation(context, animations);
                          }).then((_) {
                            showSettingLactationBottomSheet(
                                context, bottomSheetTitle, modePress);
                          })
                              : showSettingLactationBottomSheet(
                              context, bottomSheetTitle, modePress);
                          if(index == 0){
                            AnalyticsHelper().log(AnalyticsEvents.SetBrstfeedPg_DateOfBirth_Btn_Clk);
                          }else if(index == 1){
                            AnalyticsHelper().log(AnalyticsEvents.SetBrstfeedPg_GenderOfTheBaby_Btn_Clk);
                          }else{
                            AnalyticsHelper().enableEventsList([AnalyticsEvents.SetBrstfeedPg_TpDlvrList_Picker_Scr_BtmSht]);
                            AnalyticsHelper().log(AnalyticsEvents.SetBrstfeedPg_TpDelivery_Btn_Clk);
                          }
                        },
                        child: Container(
                          margin:
                          EdgeInsets.only(top: ScreenUtil().setWidth(25)),
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setWidth(20),
                              horizontal: ScreenUtil().setWidth(30)),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xff6E95FF).withOpacity(0.2),
                                    blurRadius: 5.0)
                              ]),
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
                        )),
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        ));
  }

  showSettingLactationBottomSheet(
      BuildContext context, String title, modePress) {
    showModalBottomSheet(
        isScrollControlled: true,
        transitionAnimationController: controller,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        context: context,
        builder: (context) {
          return Container(
            padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom +15),
            // height: modePress == 1 ? ScreenUtil().setWidth(700) : null,
            child: BaseBottomSheet(
                onPress: () {
                  if(modePress == 0){
                    AnalyticsHelper().log(AnalyticsEvents.SetBrstfeedPg_AcptDateOfBirth_Btn_Clk_BtmSht);
                  }else if(modePress == 1){
                    AnalyticsHelper().log(AnalyticsEvents.SetBrstfeedPg_AcptGenderBaby_Btn_Clk_BtmSht);
                  }else{
                    AnalyticsHelper().log(AnalyticsEvents.SetBrstfeedPg_AcptTpDlvr_Btn_Clk_BtmSht);
                  }
                  Navigator.pop(context);
                },
                title: title,
                content: modePress == 0
                    ? ChildBirthDateContent(
                  dashboardPresenter: widget.dashboardPresenter!,
                )
                    : modePress == 1
                    ? ChildTypeAndNameContent(
                  dashboardPresenter: widget.dashboardPresenter!,
                  animations: animations,
                )
                    : StreamBuilder(
                  stream: widget.dashboardPresenter!
                      .childBirthTypeSelectedObserve,
                  builder: (context,AsyncSnapshot<int>snapshotChildBirthTypeSelected) {
                    if (snapshotChildBirthTypeSelected.data != null) {
                      return childBirthTypeContent(snapshotChildBirthTypeSelected.data!,
                          context);
                    } else {
                      return Container();
                    }
                  },
                )),
          );
        });
  }

  childBirthTypeContent(int selectedIndex, BuildContext context) {
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
                          initialItem: selectedIndex),
                      itemExtent: ScreenUtil().setWidth(110),
                      onSelectedItemChanged: (index) {
                        AnalyticsHelper().log(AnalyticsEvents.SetBrstfeedPg_TpDlvrList_Picker_Scr_BtmSht,remainEventActive: false);
                        widget.dashboardPresenter!.onChangeChildBirthType(index);
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
                ))));
  }
}
