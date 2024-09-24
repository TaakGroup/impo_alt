

import 'dart:io';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/expert_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:impo/src/components/tab_target.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/expert/clinic_type_model.dart';
import 'package:impo/src/models/expert/info.dart';
import 'package:impo/src/models/expert/upload_file_model.dart';
import 'package:impo/src/screens/home/tabs/expert/clinic_payment_screen.dart';
import 'package:impo/src/screens/home/tabs/expert/doctor_list_screen.dart';
import 'package:impo/src/screens/home/tabs/expert/clinic_question_list.dart';
import 'package:impo/src/screens/home/tabs/expert/item_doctor_widget.dart';
import 'package:impo/src/screens/home/tabs/expert/profile_doctor_screen.dart';
import 'package:impo/src/screens/home/tabs/expert/shop_screen.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:impo/src/architecture/presenter/expert_presenter.dart';
import 'package:impo/src/architecture/view/expert_view.dart';
import 'package:impo/src/components/dialogs/ok_dialog.dart';

import '../../../../components/animations.dart';
import '../../../../components/custom_button.dart';
import '../../../../data/http.dart';
import '../../../../firebase_analytics_helper.dart';
import '../../../../models/expert/ticket_info_model.dart';
import '../../home.dart';

class ClinicQuestionScreen extends StatefulWidget {
  final ExpertPresenter? expertPresenter;
  final bodyTicketInfo;
  final ticketId;
  ClinicQuestionScreen({Key? key,this.expertPresenter,this.bodyTicketInfo,this.ticketId}):super(key:key);
  @override
  State<StatefulWidget> createState() => ClinicQuestionScreenState();
}

class ClinicQuestionScreenState extends State<ClinicQuestionScreen>with TickerProviderStateMixin implements ExpertView{

  Animations _animations =  Animations();
  late PanelController panelController;
  int modePanel  = 0;
  // static const String feature15 = 'feature15';
  @override
  void initState(){
    widget.expertPresenter!.clinicController =  TextEditingController(text: widget.expertPresenter!.controllerTextTicket.stream.value);
    widget.expertPresenter!.getTicketInfo(context,widget.expertPresenter!,widget.bodyTicketInfo);
    widget.expertPresenter!.focusNode = FocusNode();
    panelController =  PanelController();
    widget.expertPresenter!.initialDialogScale(this);
    widget.expertPresenter!.clearUploadFile();
    _animations.shakeError(this);
    widget.expertPresenter!.initUniLinks(_animations,3,context,widget.expertPresenter!,widget.expertPresenter!.getName());
    widget.expertPresenter!.initUniLinks(_animations,3,context,widget.expertPresenter!,widget.expertPresenter!.getName());
    super.initState();
  }


  Future<bool> _onWillPop()async{
    // if(panelController.isPanelOpen){
    //   panelController.close();
    // }else{
    //   Navigator.push(
    //       context,
    //       PageTransition(
    //           settings: RouteSettings(name: "/Page1"),
    //           type: PageTransitionType.fade,
    //           child: FeatureDiscovery(
    //               recordStepsInSharedPreferences: true,
    //               child: Home(
    //                 indexTab: 1,
    //                 isChangeStatus: false,
    //               )
    //           )
    //       )
    //   );
    // }
    AnalyticsHelper().log(AnalyticsEvents.ClinicQuestionPg_Back_NavBar_Clk);
    return Future.value(true);
  }

  @override
  void dispose() {
    widget.expertPresenter!.cancelUniLinkSub();
    super.dispose();
  }

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
                body:   Stack(
                  children: <Widget>[
                    StreamBuilder(
                      stream: widget.expertPresenter!.isLoadingObserve,
                      builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                        if(snapshotIsLoading.data != null){
                          if(!snapshotIsLoading.data!){
                            return StreamBuilder(
                              stream: widget.expertPresenter!.ticketInfoObserve,
                              builder: (context,AsyncSnapshot<TicketInfoAdviceModel>snapshotTicketInfo){
                                if(snapshotTicketInfo.data != null){
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child:    ListView(
                                          padding: EdgeInsets.zero,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
                                              child:  CustomAppBar(
                                                messages: true,
                                                profileTab: true,
                                                subTitleProfileTab: "کلینیک",
                                                valuePolar: snapshotTicketInfo.data!.currentValue.toString(),
                                                titleProfileTab: 'صفحه قبل',
                                                icon: 'assets/images/ic_arrow_back.svg',
                                                isPolar: true,
                                                onPressBack: (){
                                                  AnalyticsHelper().log(AnalyticsEvents.ClinicQuestionList_Back_Btn_Clk);
                                                  Navigator.pop(context);
                                                },
                                                expertPresenter: widget.expertPresenter!,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: ScreenUtil().setWidth(30)
                                              ),
                                              child: Text(
                                                snapshotTicketInfo.data!.info.pdpDescription,
                                                textAlign: TextAlign.center,
                                                style: context.textTheme.labelLargeProminent
                                              ),
                                            ),
                                            SizedBox(height: ScreenUtil().setWidth(20)),
                                            // pdpBox(snapshotTicketInfo.data),
                                            doctorBox(snapshotTicketInfo.data!),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: ScreenUtil().setWidth(25),
                                                  bottom: ScreenUtil().setWidth(10)
                                              ),
                                              child: Divider(
                                                color: Color(0xffF8F8F8),
                                                thickness: 4,
                                              ),
                                            ),
                                            StreamBuilder(
                                              stream: widget.expertPresenter!.selectedDoctorObserve,
                                              builder: (context,AsyncSnapshot<DoctorInfoModel>snapshotSelectedDoctorInfo){
                                                if(snapshotSelectedDoctorInfo.data != null){
                                                  return snapshotSelectedDoctorInfo.data!.hasPrescription ?
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: ScreenUtil().setWidth(30)
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                snapshotSelectedDoctorInfo.data!.prescriptionText,
                                                                style: context.textTheme.labelSmall,
                                                              ),
                                                            ),
                                                            // SizedBox(width: ScreenUtil().setWidth(20)),
                                                            Image.asset(
                                                                'assets/images/prescription.png',
                                                                fit: BoxFit.cover,
                                                                width: ScreenUtil().setWidth(80),
                                                                height: ScreenUtil().setWidth(80),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(height: ScreenUtil().setWidth(20)),
                                                      ],
                                                    ),
                                                  ) : SizedBox.shrink();
                                                }else{
                                                  return Container();
                                                }
                                              },
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: ScreenUtil().setWidth(30)
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    snapshotTicketInfo.data!.info.info,
                                                    style: context.textTheme.labelMedium
                                                  ),
                                                  Container(
                                                      alignment: Alignment.center,
                                                      margin: EdgeInsets.only(
                                                        top: ScreenUtil().setWidth(20),
                                                      ),
                                                      padding: EdgeInsets.only(
                                                        top: ScreenUtil().setWidth(16),
                                                        bottom: ScreenUtil().setWidth(20),
                                                        left: ScreenUtil().setWidth(20),
                                                        right: ScreenUtil().setWidth(30),
                                                      ),
                                                      decoration:  BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(16),
                                                          border: Border.all(
                                                              color: ColorPallet().mainColor,
                                                              width: 1
                                                          )
                                                      ),
                                                      child: Theme(
                                                        data: Theme.of(context).copyWith(
                                                          textSelectionTheme: TextSelectionThemeData(
                                                              selectionColor: Color(0xffaaaaaa),
                                                              cursorColor: ColorPallet().mainColor
                                                          ),
                                                        ),
                                                        child:  TextFormField(
                                                          autofocus: false,
                                                          focusNode: widget.expertPresenter!.focusNode,
                                                          onChanged: (value){
                                                            widget.expertPresenter!.onChangeTextTicket(value);
                                                          },
                                                          style:  context.textTheme.bodySmall,
                                                          controller: widget.expertPresenter!.clinicController,
                                                          maxLines: 4,
                                                          maxLength: 2000,
                                                          decoration:  InputDecoration(
                                                            isDense: true,
                                                            counterText: '',
                                                            border: InputBorder.none,
                                                            hintText: snapshotTicketInfo.data!.info.infoHelper,
                                                            hintStyle:  context.textTheme.bodySmall!.copyWith(
                                                              color: Colors.grey[600],
                                                            ),
                                                            contentPadding:  EdgeInsets.only(
                                                              right: ScreenUtil().setWidth(0),
                                                              left: ScreenUtil().setWidth(35),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                  ),
                                                  Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        top: ScreenUtil().setWidth(5),
                                                        right: ScreenUtil().setWidth(10)
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
                                                                              padding: EdgeInsets.only(left: _animations.animationShakeError.value + 4.0, right: 4.0 -_animations.animationShakeError.value),
                                                                              child: Text(
                                                                                snapshot.data != null ? snapshot.data! : '',
                                                                                style:  context.textTheme.labelSmall!.copyWith(
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
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(

                                                  bottom: ScreenUtil().setWidth(10)
                                              ),
                                              child: Divider(
                                                color: Color(0xffF8F8F8),
                                                thickness: 4,
                                              ),
                                            ),
                                            StreamBuilder(
                                              stream: widget.expertPresenter!.uploadFilesObserve,
                                              builder: (context,AsyncSnapshot<List<UploadFileModel>>snapshotUploadFiles){
                                                if(snapshotUploadFiles.data != null){
                                                  if(snapshotUploadFiles.data!.length != 0){
                                                    return   ListView.builder(
                                                      shrinkWrap: true,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      padding: EdgeInsets.only(
                                                        bottom: ScreenUtil().setWidth(20),
                                                        top: ScreenUtil().setWidth(10),
                                                      ),
                                                      itemCount: snapshotUploadFiles.data!.length,
                                                      itemBuilder: (context,index){
                                                        return  Container(
                                                          margin: EdgeInsets.symmetric(
                                                              horizontal: ScreenUtil().setWidth(30)
                                                          ),
                                                          padding: EdgeInsets.only(
                                                              left: ScreenUtil().setWidth(20),
                                                              top: ScreenUtil().setWidth(10),
                                                              bottom: ScreenUtil().setWidth(25)
                                                          ),
                                                          decoration:  BoxDecoration(
                                                              border: Border.all(
                                                                color: Color(0xff707070).withOpacity(0.2),
                                                              ),
                                                              borderRadius: BorderRadius.circular(10)
                                                          ),
                                                          child:  Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              Flexible(
                                                                  child: GestureDetector(
                                                                    onTap: (){
                                                                      widget.expertPresenter!.cancelUpload(snapshotUploadFiles.data![index].fileName.path,snapshotUploadFiles.data![index].fileNameForSend);
                                                                    },
                                                                    child:   Container(
                                                                      width: ScreenUtil().setWidth(80),
                                                                      height: ScreenUtil().setWidth(80),
                                                                      margin: EdgeInsets.only(
                                                                        right: ScreenUtil().setWidth(30),
                                                                        left: ScreenUtil().setWidth(30),
                                                                      ),
                                                                      padding: EdgeInsets.all(ScreenUtil().setWidth(3)),
                                                                      decoration:  BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(15),
                                                                          color: Colors.white,
                                                                          border: Border.all(
                                                                              color: snapshotUploadFiles.data![index].stateUpload == 0 ?
                                                                              ColorPallet().gray : Color(0xffFF8192),
                                                                              width: ScreenUtil().setWidth(2)
                                                                          ),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                                color:  snapshotUploadFiles.data![index].stateUpload == 0 ?
                                                                                Color(0xff5F9BDF).withOpacity(0.25) : Color(0xffFF8192).withOpacity(0.25),
                                                                                blurRadius: 5.0
                                                                            )
                                                                          ]
                                                                      ),
                                                                      child: Center(
                                                                          child:  Container(
                                                                              child:  Padding(
                                                                                  padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                                                                                  child:  SvgPicture.asset(
                                                                                    snapshotUploadFiles.data![index].stateUpload == 0 ?
                                                                                    'assets/images/ic_close.svg' :
                                                                                    'assets/images/ic_delete_forever.svg' ,
                                                                                  )
                                                                              )
                                                                          )
                                                                      ),
                                                                    ),
                                                                  )
                                                              ),
                                                              Flexible(
                                                                flex: 3,
                                                                child:  Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                  children: <Widget>[
                                                                    Text(
                                                                      snapshotUploadFiles.data![index].name,
                                                                      textDirection: TextDirection.ltr,
                                                                      style: context.textTheme.bodyMedium,
                                                                    ),
                                                                    SizedBox(height: ScreenUtil().setHeight(10)),
                                                                    snapshotUploadFiles.data![index].stateUpload == 0 ?
                                                                    ClipRRect(
                                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                        child:  Directionality(
                                                                            textDirection: TextDirection.ltr,
                                                                            child:  StreamBuilder(
                                                                              stream: widget.expertPresenter!.sendValuePercentUploadFileObserve,
                                                                              builder: (context,AsyncSnapshot<double>snapshotPercentUpload){
                                                                                if(snapshotPercentUpload.data != null){
                                                                                  return  LinearPercentIndicator(
                                                                                    padding: EdgeInsets.zero,
                                                                                    width: MediaQuery.of(context).size.width / 1.95,
                                                                                    lineHeight: ScreenUtil().setWidth(17),
                                                                                    percent: snapshotPercentUpload.data!/100,
                                                                                    backgroundColor: Color(0xffececec),
                                                                                    progressColor:  ColorPallet().mainColor,
                                                                                  );
                                                                                }else{
                                                                                  return  Container();
                                                                                }
                                                                              },
                                                                            )
                                                                        )
                                                                    ) :  Container()
                                                                  ],
                                                                ),
                                                              ),
                                                              Flexible(
                                                                child: snapshotUploadFiles.data![index].type == 0 ?
                                                                Container(
                                                                  height: ScreenUtil().setWidth(100),
                                                                  width:  ScreenUtil().setWidth(100),
                                                                  margin: EdgeInsets.only(
                                                                      right: ScreenUtil().setWidth(20)
                                                                  ),
                                                                  decoration:  BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      border: Border.all(
                                                                          color: Color(0xff707070).withOpacity(0.2),
                                                                          width: ScreenUtil().setWidth(2)
                                                                      ),
                                                                      image:  DecorationImage(
                                                                          fit: BoxFit.cover,
                                                                          image: FileImage(
                                                                            File(snapshotUploadFiles.data![index].fileName.path),
                                                                          )
                                                                      )
                                                                  ),
//                                                  )
                                                                ) :
                                                                Container(
                                                                  height: ScreenUtil().setWidth(100),
                                                                  width:  ScreenUtil().setWidth(100),
                                                                  margin: EdgeInsets.only(
                                                                      right: ScreenUtil().setWidth(20)
                                                                  ),
                                                                  decoration:  BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      image:  DecorationImage(
                                                                          fit: BoxFit.fitHeight,
                                                                          image: AssetImage(
                                                                            'assets/images/ic_pdf.png',
                                                                          )
                                                                      )
                                                                  ),
//                                                  )
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }else{
                                                    return sendFileBox(snapshotTicketInfo.data!);
                                                  }
                                                }else{
                                                  return  Container();
                                                }
                                              },
                                            ),
                                            SizedBox(height: ScreenUtil().setWidth(50),),
                                            // doctorBox(snapshotTicketInfo.data.info.dr[0]),
                                          ],
                                        ),
                                      ),
                                      nextButton(snapshotTicketInfo.data!)
                                    ],
                                  );
                                }else{
                                  return Container();
                                }
                              },
                            );
                          }else{
                            return  Center(
                                child:  StreamBuilder(
                                  stream: widget.expertPresenter!.tryButtonErrorObserve,
                                  builder: (context,AsyncSnapshot<bool>snapshotTryButton){
                                    if(snapshotTryButton.data != null){
                                      if(snapshotTryButton.data!){
                                        return  Padding(
                                            padding: EdgeInsets.only(
                                                right: ScreenUtil().setWidth(80),
                                                left: ScreenUtil().setWidth(80),
                                                top: ScreenUtil().setWidth(200)
                                            ),
                                            child:  Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                StreamBuilder(
                                                  stream: widget.expertPresenter!.valueErrorObserve,
                                                  builder: (context,AsyncSnapshot<String>snapshotValueError){
                                                    if(snapshotValueError.data != null){
                                                      return   Text(
                                                        snapshotValueError.data!,
                                                        textAlign: TextAlign.center,
                                                          style:  context.textTheme.bodyMedium!.copyWith(
                                                            color: Color(0xff707070),
                                                          )
                                                      );
                                                    }else{
                                                      return  Container();
                                                    }
                                                  },
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: ScreenUtil().setWidth(32)
                                                    ),
                                                    child:    ExpertButton(
                                                      title: 'تلاش مجدد',
                                                      onPress: (){
                                                        widget.expertPresenter!.getTicketInfo(context,widget.expertPresenter!,widget.bodyTicketInfo);
                                                      },
                                                      enableButton: true,
                                                      isLoading: false,
                                                    )
                                                )
                                              ],
                                            )
                                        );
                                      }else{
                                        return  LoadingViewScreen(
                                            color: ColorPallet().mainColor
                                        );
                                      }
                                    }else{
                                      return  Container();
                                    }
                                  },
                                )
                            );
                          }
                        }else{
                          return Container();
                        }
                      },
                    ),
                    SlidingUpPanel(
                      controller: panelController,
                      backdropEnabled: true,
                      minHeight: 0,
                      backdropColor: Colors.black,
                      maxHeight: MediaQuery.of(context).size.height / 5,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)
                      ),
                      panel:  Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setWidth(15)
                            ),
                            height: ScreenUtil().setWidth(5),
                            width: ScreenUtil().setWidth(100),
                            decoration:  BoxDecoration(
                                color: Color(0xff707070).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15)
                            ),
                          ),
                          Flexible(
                              child: attachPanel()
                          ),
                        ],
                      ),
                    ),
                    // StreamBuilder(
                    //   stream: widget.expertPresenter!.isShowDialogObserve,
                    //   builder: (context,snapshotDialogScale){
                    //     if(snapshotDialogScale.data != null){
                    //       if(snapshotDialogScale.data){
                    //         return  StreamBuilder(
                    //           stream: widget.expertPresenter!.textDialogObserve,
                    //           builder: (context,AsyncSnapshot<String>snapshotTextDialog){
                    //             if(snapshotTextDialog.data != null){
                    //               if(snapshotTextDialog.data != ''){
                    //                 return  StreamBuilder(
                    //                   stream: widget.expertPresenter!.isLoadingButtonObserve,
                    //                   builder: (context,snapshotIsLoading){
                    //                     if(snapshotIsLoading.data != null){
                    //                       return  OkDialog(
                    //                         scaleAnim: widget.expertPresenter!.dialogScaleObserve,
                    //                         okText: snapshotTextDialog.data.split('/')[0],
                    //                         title: '${widget.expertPresenter!.getName()} عزیز',
                    //                         value: snapshotTextDialog.data.split('/')[1],
                    //                         onPressOk: (){
                    //                           if(snapshotTextDialog.data.split('/')[1].startsWith('م')){
                    //                             // widget.expertPresenter!.onPressOkSuccessfulDialog(context,widget.expertPresenter!,widget.randomMessage);
                    //                            widget.expertPresenter!.createTicket(context,widget.expertPresenter!);
                    //                           }else{
                    //                             widget.expertPresenter!.onPressYesDialog();
                    //                           }
                    //                         },
                    //                         onPressClose: (){
                    //                           widget.expertPresenter!.onPressYesDialog();
                    //                         },
                    //                         colors: [Colors.white,Colors.white],
                    //                         topIcon: 'assets/images/ic_box_question.svg',
                    //                         isExpert: true,
                    //                         isLoadingButton: snapshotIsLoading.data,
                    //                       );
                    //                     }else{
                    //                       return  Container();
                    //                     }
                    //                   },
                    //                 );
                    //               }else{
                    //                 return  Container();
                    //               }
                    //             }else{
                    //               return  Container();
                    //             }
                    //           },
                    //         );
                    //       }else{
                    //         return  Container();
                    //       }
                    //     }else{
                    //       return  Container();
                    //     }
                    //   },
                    // ),
                  ],
                )
            )
        )
    );
  }

  Widget attachPanel(){
    return  Padding(
        padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(30),
            left: ScreenUtil().setWidth(50),
            right: ScreenUtil().setWidth(50)
        ),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: itemAttach(
                        'assets/images/ic_camera.svg',
                        'دوربین',
                            (){
                          panelController.close();
                          widget.expertPresenter!.getFileImage(1,false);
                        }
                    ),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(50)),
                  Flexible(
                    child: itemAttach(
                        'assets/images/ic_gallery.svg',
                        'گالری',
                            (){
                          panelController.close();
                          widget.expertPresenter!.getFileImage(0,false);
                        }
                    ),
                  ),
                ],
              ),
            ),
            itemAttach(
                'assets/images/ic_document.svg',
                'اسناد شما',
                    (){
                  panelController.close();
                  widget.expertPresenter!.getFileImage(2,false);
                }
            ),
          ],
        )
    );
  }

  Widget itemAttach(String icon,String title,onPress){
    return  Column(
      children: <Widget>[
        Container(
            height: ScreenUtil().setWidth(110),
            width: ScreenUtil().setWidth(110),
            decoration:  BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xff5F9BDF).withOpacity(0.25),
                      blurRadius: 5.0
                  )
                ]
            ),
            child:  Material(
              color: Colors.transparent,
              child:  InkWell(
                splashColor: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(50),
                onTap: (){
                  onPress();
                },
                child:  Center(
                    child:  Container(
                      height: ScreenUtil().setWidth(50),
                      width: ScreenUtil().setWidth(50),
                      child:  SvgPicture.asset(
                        icon,

                      ),
                    )
                ),
              ),
            )
        ),
        SizedBox(height: ScreenUtil().setWidth(15)),
        Text(
          title,
          style: context.textTheme.bodySmall,
        )
      ],
    );
  }

  Widget doctorBox(TicketInfoAdviceModel ticketInfo){
    return ticketInfo.info.dr.length > 0 ?
    Column(
      children: [
        SizedBox(height: ScreenUtil().setWidth(24)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'متخصص فعال',
                style: context.textTheme.labelLargeProminent
              ),
              ticketInfo.info.dr.length > 1 ?
              OutlinedButton(
                onPressed: (){
                  AnalyticsHelper().log(AnalyticsEvents.ClinicQuestionPg_ChangeDoctor_Btn_Clk);
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child:  DoctorListScreen(
                            expertPresenter: widget.expertPresenter!,
                          )
                      )
                  );
                },
                style: ButtonStyle(
                  side: MaterialStateProperty.all(BorderSide(
                    color: ColorPallet().mentalMain,
                  ),
                  ),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  )
                  ),
                ),
                child:  Text(
                  'تغییر متخصص',
                  style:  context.textTheme.labelMedium!.copyWith(
                    color: ColorPallet().mentalMain,
                  )
                ),
              )
                  : Container()
            ],
          ),
        ),
        SizedBox(height: ScreenUtil().setWidth(16)),
        StreamBuilder(
          stream: widget.expertPresenter!.selectedDoctorObserve,
          builder: (context,AsyncSnapshot<DoctorInfoModel>snapshotSelectedDoctorInfo){
            if(snapshotSelectedDoctorInfo.data != null){
              return ItemDoctorWidget(
                  doctorInfo: snapshotSelectedDoctorInfo.data!,
                  press: (){
                    AnalyticsHelper().log(AnalyticsEvents.ClinicQuestionPg_DoctorProfile_Btn_Clk);
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child:  ProfileDoctorScreen(
                              expertPresenter: widget.expertPresenter!,
                            )
                        )
                    );
                  },
              );
            }else{
              return Container();
            }
          },
        )
      ],
    ) : Container();
  }

  Widget sendFileBox(TicketInfoAdviceModel ticketInfo){
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(30)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'اگر آزمایش یا گزارشی داری می‌تونی اضافه کنی.',
            style: context.textTheme.labelSmall
          ),
          OutlinedButton(
            onPressed: (){
              AnalyticsHelper().log(AnalyticsEvents.ClinicQuestionPg_AttachFile_Btn_Clk);
              panelController.open();
            },
            style: ButtonStyle(
              side: MaterialStateProperty.all(BorderSide(
                color: Color(0xffE9E9E9),
              ),
              ),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              )
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.add,
                  color: Color(0xff8925D1),
                  size: ScreenUtil().setWidth(30),
                ),
                Text(
                  'اضافه کردن',
                  style:  context.textTheme.labelMedium!.copyWith(
                    color: Color(0xff8925D1),
                  )
                ),
              ],
            )
          )
        ],
      ),
    );
  }

  Widget nextButton(TicketInfoAdviceModel ticketInfo){
    return   StreamBuilder(
      stream: widget.expertPresenter!.isLoadingButtonObserve,
      builder: (context,snapshotIsLoading){
        if(snapshotIsLoading.data != null){
          return  Padding(
            padding: EdgeInsets.only(
                bottom: ScreenUtil().setWidth(30)
            ),
            child: CustomButton(
              title: 'مرحله بعد',
              margin: 30,
              // height: ScreenUtil().setWidth(50),
              colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
              enableButton: true,
              isLoadingButton: snapshotIsLoading.data,
              onPress: (){

                widget.expertPresenter!.nextPressClinicQuestion(context,widget.expertPresenter!,widget.ticketId,ticketInfo,_animations);
                ///AnalyticsHelper().log(AnalyticsEvents.ClinicQuestionPg_SendQuestion_Btn_Clk);
                /// widget.expertPresenter!.pressPayForCreateTicket(context,
                ///     widget.expertPresenter!,widget.ticketId,_animations);
              },
            ),
          );
        }else{
          return Container();
        }
      },
    );
  }



  @override
  void onError(msg) {
  }

  @override
  void onSuccess(msg){
  }


}