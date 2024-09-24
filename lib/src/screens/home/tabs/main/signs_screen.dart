

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';
import 'package:impo/src/architecture/presenter/dashboard_presenter.dart';
import 'package:impo/src/architecture/view/dashboard_view.dart';
import 'package:impo/src/components/back_button.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/dialogs/qus_dialog.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/auto_backup.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/data/messages/generate_dashboard_notify_and_messages.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/models/signsModel/sings_view_model.dart';
import 'package:impo/src/screens/home/home.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shamsi_date/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../firebase_analytics_helper.dart';

class SignsScreen extends StatefulWidget{

  final bool? shareExp;

  SignsScreen({Key? key,this.shareExp}): super(key:key);

  @override
  State<StatefulWidget> createState() => SignsScreenState();
}

class SignsScreenState extends State<SignsScreen> with TickerProviderStateMixin implements DashboardView{

  late DashboardPresenter dashboardPresenter;

  SignsScreenState(){
    dashboardPresenter = DashboardPresenter(this);
  }


  double width = 0;
  String childName = '';



  @override
  void initState() {
    dashboardPresenter.checkTypeSigns();
    dashboardPresenter.initialDialogScale(this);
    setChildName();
    super.initState();
  }


  RegisterParamViewModel getRegister(){
    var registerInfo = locator<RegisterParamModel>();
    return registerInfo.register;
  }


  setChildName(){
    if(getRegister().status == 3){
      if(getRegister().childType != 4){
        childName = getRegister().childName!;
      }else{
        childName = 'بچه ها';
      }
    }
  }


  Future<bool> _onWillPop()async{
    int status = getRegister().status!;

    if(status == 1){
      AnalyticsHelper().log(AnalyticsEvents.SignsPgPeriod_Back_NavBar_Clk);
    }else if(status == 2){
      AnalyticsHelper().log(AnalyticsEvents.SignsPgPregnancy_Back_NavBar_Clk);
    }else if(status == 3){
      AnalyticsHelper().log(AnalyticsEvents.SignsPgBrstfeed_Back_NavBar_Clk);
    }
    dashboardPresenter.backSignScreen(context);
    return Future.value(false);
  }


  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    timeDilation = 0.5;
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return  WillPopScope(
      onWillPop: _onWillPop,
      child:   Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              body: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            height: ScreenUtil().setWidth(170),
                            width: ScreenUtil().setWidth(10),
                            margin: EdgeInsets.only(
                              right: ScreenUtil().setWidth(20),
                            ),
                            decoration:  BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: ColorPallet().periodDeep
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: ScreenUtil().setWidth(90),
                                        right: ScreenUtil().setWidth(45)
                                    ),
                                    child: Text(
                                      'نشانه‌های من',
                                      style:  context.textTheme.titleSmall,
                                    ),
                                  ),
                                  CustomBackButton(
                                    onPressBack: (){
                                      int status = getRegister().status!;

                                      if(status == 1){
                                        AnalyticsHelper().log(AnalyticsEvents.SignsPgPeriod_Back_Btn_Clk);
                                      }else if(status == 2){
                                        AnalyticsHelper().log(AnalyticsEvents.SignsPgPregnancy_Back_Btn_Clk);
                                      }else if(status == 3){
                                        AnalyticsHelper().log(AnalyticsEvents.SignsPgBrstfeed_Back_Btn_Clk);
                                      }
                                      dashboardPresenter.backSignScreen(context);
                                    },
                                    angleIcon: -1.57,
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: ScreenUtil().setWidth(45),
                                    top: ScreenUtil().setWidth(20),
                                ),
                                child: Text(
                                  getRegister().signText!,
                                  style:  context.textTheme.bodyMedium,
                                )
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: ScreenUtil().setHeight(40)),
                      StreamBuilder(
                        stream: dashboardPresenter.statusObserve,
                        builder: (context,AsyncSnapshot<int>snapshotStatus){
                          if(snapshotStatus.data != null){
                            if(snapshotStatus.data == 1){
                              return menstruation();
                            }else if(snapshotStatus.data == 2){
                              return pregnancy();
                            }else if(snapshotStatus.data == 3){
                              return breastfeeding();
                            }else{
                              return Container();
                            }
                          }else{
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
              bottomNavigationBar:   Container(
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setWidth(30)
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xffD5C9FF).withOpacity(0.8),
                            blurRadius: 10.0
                        )
                      ]
                  ),
                  child: StreamBuilder(
                    stream: dashboardPresenter.statusObserve,
                    builder: (context,AsyncSnapshot<int>snapshotStatus){
                      if(snapshotStatus.data != null){
                        return  StreamBuilder(
                          stream: dashboardPresenter.isLoadingObserve,
                          builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                            if(snapshotIsLoading.data != null){
                              return CustomButton(
                                title: 'ذخیره تغییرات',
                                onPress:(){
                                  if(!snapshotIsLoading.data!){
                                    if(snapshotStatus.data == 1){
                                      AnalyticsHelper().log(AnalyticsEvents.SignsPgPeriod_SaveChanges_Btn_Clk);
                                      dashboardPresenter.saveWomanSigns(context,false,widget.shareExp!);
                                    }else if(snapshotStatus.data == 2){
                                      AnalyticsHelper().log(AnalyticsEvents.SignsPgPregnancy_SaveChanges_Btn_Clk);
                                      dashboardPresenter.saveSignsPregnancy(context,false,widget.shareExp!);
                                    }else{
                                      AnalyticsHelper().log(AnalyticsEvents.SignsPgBrstfeed_SaveChanges_Btn_Clk);
                                      dashboardPresenter.saveSignsBreastfeeding(context,false,widget.shareExp!);
                                    }
                                  }
                                },
                                margin: 200,
                                colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                                borderRadius: 10.0,
                                enableButton: true,
                                isLoadingButton: snapshotIsLoading.data,
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
                  )
              ),
            ),
            StreamBuilder(
              stream: dashboardPresenter.isShowDialogObserve,
              builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog){
                if(snapshotIsShowDialog.data != null){
                  if(snapshotIsShowDialog.data!){
                    return  StreamBuilder(
                      stream: dashboardPresenter.isLoadingButtonObserve,
                      builder: (context,snapshotIsLoadingButton){
                        if(snapshotIsLoadingButton.data != null){
                          return StreamBuilder(
                            stream: dashboardPresenter.statusObserve,
                            builder: (context,snapshotStatus){
                              if(snapshotStatus.data != null){
                                return  Scaffold(
                                    backgroundColor: Colors.transparent,
                                    body: QusDialog(
                                      scaleAnim: dashboardPresenter.dialogScaleObserve,
                                      onPressCancel:(){
                                        if(snapshotStatus.data == 1){
                                          AnalyticsHelper().log(AnalyticsEvents.SignsPgPeriod_SaveChangesDlgNo_Btn_Clk);
                                        }else if(snapshotStatus.data == 2){
                                          AnalyticsHelper().log(AnalyticsEvents.SignsPgPregnancy_SaveChangesDlgNo_Btn_Clk);
                                        }else{
                                          AnalyticsHelper().log(AnalyticsEvents.SignsPgBrstfeed_SaveChangesDlgNo_Btn_Clk);
                                        }
                                        dashboardPresenter.closeDialog(context);
                                      },
                                      value: "آیا از ذخیره تغییرات اطمینان داری؟",
                                      yesText: 'بله',
                                      noText: 'خیر',
                                      onPressYes: (){
                                        if(snapshotStatus.data == 1){
                                          AnalyticsHelper().log(AnalyticsEvents.SignsPgPeriod_SaveChangeDlgYes_Btn_Clk);
                                          dashboardPresenter.saveWomanSigns(context,true,widget.shareExp!);
                                        }else if(snapshotStatus.data == 2){
                                          AnalyticsHelper().log(AnalyticsEvents.SignsPgPregnancy_SaveChangeDlgYes_Btn_Clk);
                                          dashboardPresenter.saveSignsPregnancy(context,true,widget.shareExp!);
                                        }else{
                                          AnalyticsHelper().log(AnalyticsEvents.SignsPgBrstfeed_SaveChangeDlgYes_Btn_Clk);
                                          dashboardPresenter.saveSignsBreastfeeding(context,true,widget.shareExp!);
                                        }
                                      },
                                      isIcon: true,
                                      colors:  [
                                        Colors.white,
                                        Colors.white
                                      ],
                                      topIcon: 'assets/images/ic_box_question.svg',
                                      isLoadingButton: snapshotIsLoadingButton.data,
                                    )
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
      )
    );
  }


  Widget menstruation(){
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(65)
      ),
      child: Column(
        children: checkOrderSignsMenstruation(),
      ),
    );
  }

   List<Widget> checkOrderSignsMenstruation(){
     switch(dashboardPresenter.dayMode){
       case 0: return [
         menstruationGrouping('دوران پریود',dashboardPresenter.duringPeriodSignsObserve),
         menstruationGrouping('نشانه‌های روانی',dashboardPresenter.mentalSignsObserve),
         menstruationGrouping('قبل از قاعدگی',dashboardPresenter.beforePeriodSingsObserve),
         menstruationGrouping('دوره‌ی باروری',dashboardPresenter.ovuSignsObserve),
         menstruationGrouping('سایر نشانه ها',dashboardPresenter.otherSignsObserve),
       ];
       case 1: return [
         menstruationGrouping('دوره‌ی باروری',dashboardPresenter.ovuSignsObserve),
         menstruationGrouping('قبل از قاعدگی',dashboardPresenter.beforePeriodSingsObserve),
         menstruationGrouping('دوران پریود',dashboardPresenter.duringPeriodSignsObserve),
         menstruationGrouping('نشانه‌های روانی',dashboardPresenter.mentalSignsObserve),
         menstruationGrouping('سایر نشانه ها',dashboardPresenter.otherSignsObserve),
       ];
       case 2: return [
         menstruationGrouping('قبل از قاعدگی',dashboardPresenter.beforePeriodSingsObserve),
         menstruationGrouping('نشانه‌های روانی',dashboardPresenter.mentalSignsObserve),
         menstruationGrouping('دوران پریود',dashboardPresenter.duringPeriodSignsObserve),
         menstruationGrouping('دوره‌ی باروری',dashboardPresenter.ovuSignsObserve),
         menstruationGrouping('سایر نشانه ها',dashboardPresenter.otherSignsObserve),
       ];
       case 3: return [
         menstruationGrouping('نشانه‌های روانی',dashboardPresenter.mentalSignsObserve),
         menstruationGrouping('دوران پریود',dashboardPresenter.duringPeriodSignsObserve),
         menstruationGrouping('دوره‌ی باروری',dashboardPresenter.ovuSignsObserve),
         menstruationGrouping('قبل از قاعدگی',dashboardPresenter.beforePeriodSingsObserve),
         menstruationGrouping('سایر نشانه ها',dashboardPresenter.otherSignsObserve),
       ];
       default : return[
         menstruationGrouping('نشانه‌های روانی',dashboardPresenter.mentalSignsObserve),
         menstruationGrouping('دوران پریود',dashboardPresenter.duringPeriodSignsObserve),
         menstruationGrouping('دوره‌ی باروری',dashboardPresenter.ovuSignsObserve),
         menstruationGrouping('قبل از قاعدگی',dashboardPresenter.beforePeriodSingsObserve),
         menstruationGrouping('سایر نشانه ها',dashboardPresenter.otherSignsObserve),
       ];
     }
   }

  Widget menstruationGrouping(String title,Stream<List<SignsViewModel>> signsObserve){
    return Column(
      children: [
        separator(width,title),
        StreamBuilder(
          stream: signsObserve,
          builder: (context,AsyncSnapshot<List<SignsViewModel>>snapshotSings) {
            if (snapshotSings.data != null) {
              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: .65),
                itemCount:
                snapshotSings.data!.length,
                itemBuilder: (context, index) {
                  return menstruationItems(
                      snapshotSings.data!,
                      index,context);
                },
              );
            } else {
              return Container();
            }
          },
        ),
        SizedBox(height: ScreenUtil().setHeight(20)),
      ],
    );
  }

  Widget menstruationItems(List<SignsViewModel>item,index,BuildContext context){
    return  GestureDetector(
      onTap: ()async{
        if(item[index].isSelected!){
          AnalyticsHelper().log(AnalyticsEvents.SignsPgPeriod_RemoveSign_Item_Clk,parameters: {'index' : index});
        }else{
          AnalyticsHelper().log(AnalyticsEvents.SignsPgPeriod_AddSign_Item_Clk,parameters: {'index' : index});
        }
       await  dashboardPresenter.onPressWomanSigns(item, index);
      },
      child:   Column(
        children: <Widget>[
          Container(
              width: ScreenUtil().setWidth(120),
              height: ScreenUtil().setWidth(120),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        item[index].isSelected != null
                            ? item[index].isSelected!
                            ? item[index].icon!
                            : item[index].unSelectIcon!
                            : "",
                        fit: BoxFit.cover,
                        width: ScreenUtil().setWidth(120),
                        height: ScreenUtil().setWidth(120),
                      ),
                      item[index].isSelected != null ?
                      !item[index].isSelected!  ?
                       Container(
                         width: ScreenUtil().setWidth(120),
                         height: ScreenUtil().setWidth(120),
                         decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           color: Colors.white.withOpacity(0.7)
                         ),
                       ) : SizedBox.shrink() : SizedBox.shrink()
                    ],
                  ),
                  item[index].isLoading!
                      ? Container(
                      width: ScreenUtil().setWidth(120),
                      height: ScreenUtil().setWidth(120),
                      decoration: BoxDecoration(
                          color: ColorPallet().gray.withOpacity(0.5),
                          shape: BoxShape.circle),
                      child: Center(
                          child: LoadingViewScreen(
                            color: Colors.white,
                            width: ScreenUtil().setWidth(35),
                            lineWidth: ScreenUtil().setWidth(5),
                          )))
                      : Container()
                ],
              )
          ),
           SizedBox(height: ScreenUtil().setHeight(10)),
           Text(
            item[index].title!,
            textAlign: TextAlign.center,
            style:  context.textTheme.labelSmall!.copyWith(
              fontWeight: FontWeight.w500
            ),
          )
        ],
      ),
    );
  }

  Widget pregnancy(){
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(80)
      ),
      child: Column(
        children: [
          // separator(width, 'جنسيت جنين'),
          // StreamBuilder(
          //   stream: dashboardPresenter.fetalSexObserve,
          //   builder: (context,AsyncSnapshot<List<SignsViewModel>>snapshotFetalSex){
          //     if(snapshotFetalSex.data != null){
          //       return ListView.builder(
          //         shrinkWrap: true,
          //         physics: NeverScrollableScrollPhysics(),
          //         itemCount: snapshotFetalSex.data.length,
          //         itemBuilder: (context,index){
          //           return pregnancyAndBreastfeedingItems(
          //               snapshotFetalSex.data,
          //               index,
          //               true
          //           );
          //         },
          //       );
          //     }else{
          //       return Container();
          //     }
          //   },
          // ),
          // SizedBox(height: ScreenUtil().setHeight(20)),
          separator(width, 'نشانه های جسمانی'),
          StreamBuilder(
            stream: dashboardPresenter.physicalSignsObserve,
            builder: (context,AsyncSnapshot<List<SignsViewModel>>snapshotPhysicalSigns){
              if(snapshotPhysicalSigns.data != null){
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshotPhysicalSigns.data!.length,
                  itemBuilder: (context,index){
                    return pregnancyAndBreastfeedingItems(
                        snapshotPhysicalSigns.data!,
                        index,
                        true
                    );
                  },
                );
              }else{
                return Container();
              }
            },
          ),
          SizedBox(height: ScreenUtil().setHeight(20)),
          separator(width, 'نشانه های جسمانی بارداری'),
          StreamBuilder(
            stream: dashboardPresenter.pregnancyPhysicalSignsObserve,
            builder: (context,AsyncSnapshot<List<SignsViewModel>>snapshotPregnancyPhysicalSigns){
              if(snapshotPregnancyPhysicalSigns.data != null){
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshotPregnancyPhysicalSigns.data!.length,
                  itemBuilder: (context,index){
                    return pregnancyAndBreastfeedingItems(
                        snapshotPregnancyPhysicalSigns.data!,
                        index,
                        true
                    );
                  },
                );
              }else{
                return Container();
              }
            },
          ),
          SizedBox(height: ScreenUtil().setHeight(20)),
          separator(width, 'نشانه های گوارشی بارداری'),
          StreamBuilder(
            stream: dashboardPresenter.pregnancyGastrointestinalSignObserve,
            builder: (context,AsyncSnapshot<List<SignsViewModel>>snapshotPregnancyGastrointestinalSign){
              if(snapshotPregnancyGastrointestinalSign.data != null){
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshotPregnancyGastrointestinalSign.data!.length,
                  itemBuilder: (context,index){
                    return pregnancyAndBreastfeedingItems(
                        snapshotPregnancyGastrointestinalSign.data!,
                        index,
                        true
                    );
                  },
                );
              }else{
                return Container();
              }
            },
          ),
          SizedBox(height: ScreenUtil().setHeight(20)),
          separator(width, 'سایر نشانه ها'),
          StreamBuilder(
            stream: dashboardPresenter.pregnancyPsychologySignsObserve,
            builder: (context,AsyncSnapshot<List<SignsViewModel>>snapshotPregnancyPsychologySigns){
              if(snapshotPregnancyPsychologySigns.data != null){
                return ListView.builder(
                  itemCount: snapshotPregnancyPsychologySigns.data!.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index){
                    return pregnancyAndBreastfeedingItems(
                        snapshotPregnancyPsychologySigns.data!,
                        index,
                        true
                    );
                  },
                );
              }else{
                return Container();
              }
            },
          ),
          SizedBox(height: ScreenUtil().setHeight(20)),
        ],
      ),
    );
  }

  Widget breastfeeding(){
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(80)
      ),
      child: Column(
        children: [
          separator(width, 'نشانه های نوزاد'),
          StreamBuilder(
            stream: dashboardPresenter.breastfeedingBabySignsObserve,
            builder: (context,AsyncSnapshot<List<SignsViewModel>>snapshotBabySigns){
              if(snapshotBabySigns.data != null){
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshotBabySigns.data!.length,
                  itemBuilder: (context,index){
                    return pregnancyAndBreastfeedingItems(
                        snapshotBabySigns.data!,
                        index,
                        false
                    );
                  },
                );
              }else{
                return Container();
              }
            },
          ),
          SizedBox(height: ScreenUtil().setHeight(20)),
          separator(width, 'نشانه های جسمانی'),
          StreamBuilder(
            stream: dashboardPresenter.breastfeedingPhysicalSignsObserve,
            builder: (context,AsyncSnapshot<List<SignsViewModel>>snapshotBreastfeedingPhysicalSigns){
              if(snapshotBreastfeedingPhysicalSigns.data != null){
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshotBreastfeedingPhysicalSigns.data!.length,
                  itemBuilder: (context,index){
                    return pregnancyAndBreastfeedingItems(
                        snapshotBreastfeedingPhysicalSigns.data!,
                        index,
                        false
                    );
                  },
                );
              }else{
                return Container();
              }
            },
          ),
          SizedBox(height: ScreenUtil().setHeight(20)),
          separator(width, 'نشانه های شیردهی مادر'),
          StreamBuilder(
            stream: dashboardPresenter.breastfeedingMotherSignsObserve,
            builder: (context,AsyncSnapshot<List<SignsViewModel>>snapshotBreastfeedingMotherSigns){
              if(snapshotBreastfeedingMotherSigns.data != null){
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshotBreastfeedingMotherSigns.data!.length,
                  itemBuilder: (context,index){
                    return pregnancyAndBreastfeedingItems(
                        snapshotBreastfeedingMotherSigns.data!,
                        index,
                        false
                    );
                  },
                );
              }else{
                return Container();
              }
            },
          ),
          SizedBox(height: ScreenUtil().setHeight(20)),
          separator(width, 'سایر نشانه ها'),
          StreamBuilder(
            stream: dashboardPresenter.breastfeedingPsychologySignsObserve,
            builder: (context,AsyncSnapshot<List<SignsViewModel>>snapshotBreastfeedingPsySign){
              if(snapshotBreastfeedingPsySign.data != null){
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshotBreastfeedingPsySign.data!.length,
                  itemBuilder: (context,index){
                    return pregnancyAndBreastfeedingItems(
                        snapshotBreastfeedingPsySign.data!,
                        index,
                        false
                    );
                  },
                );
              }else{
                return Container();
              }
            },
          ),
          SizedBox(height: ScreenUtil().setHeight(20)),
        ],
      ),
    );
  }

  Widget pregnancyAndBreastfeedingItems(List<SignsViewModel> items,int index,bool isPregnancy){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          items[index].title!,
          style: context.textTheme.bodyMedium!.copyWith(
            color: ColorPallet().gray,
          ),
        ),
        CupertinoSwitch(
          value: items[index].isSelected!,
          trackColor: ColorPallet().gray.withOpacity(0.5),
          activeColor: ColorPallet().mentalMain,
          onChanged: (bool value)async{
            if(isPregnancy){

              if(items[index].isSelected!){
                AnalyticsHelper().log(AnalyticsEvents.SignsPgPregnancy_RemoveSign_Item_Clk,parameters: {'index' : index});
              }else{
                AnalyticsHelper().log(AnalyticsEvents.SignsPgPregnancy_AddSign_Item_Clk,parameters: {'index' : index});
              }
              dashboardPresenter.onPressPregnancySigns(items,index);

            }else{

              if(items[index].isSelected!){
                AnalyticsHelper().log(AnalyticsEvents.SignsPgBrstfeed_RemoveSign_Item_Clk,parameters: {'index' : index});
              }else{
                AnalyticsHelper().log(AnalyticsEvents.SignsPgBrstfeed_AddSign_Item_Clk,parameters: {'index' : index});
              }
              dashboardPresenter.onPressBreastfeedingSigns(items,index);

            }
          },
        )
      ],
    );
  }
  Widget separator(width,title){
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
            child:  Container(
              height: ScreenUtil().setWidth(3),
              color: ColorPallet().gray.withOpacity(0.6),
            )
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(20)
          ),
          child: Text(
            title,
            style: context.textTheme.labelMediumProminent,
          ),
        ),
        Flexible(
            child:  Container(
              height: ScreenUtil().setWidth(3),
              color:ColorPallet().gray.withOpacity(0.6),
            )
        )
      ],
    );
  }

  @override
  void onError(msg) {
  }

  @override
  void onSuccess(value) {
  }

}