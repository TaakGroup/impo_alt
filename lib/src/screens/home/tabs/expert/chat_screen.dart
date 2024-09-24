import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:impo/src/architecture/presenter/expert_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/dialogs/ok_dialog.dart';
import 'package:impo/src/components/dialogs/qus_dialog.dart';
import 'package:impo/src/components/expert_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/widgets/snackbar/custom_snack_bar.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/models/expert/chat_ticket_model.dart';
import 'package:impo/src/models/expert/info.dart';
import 'package:impo/src/models/expert/upload_file_model.dart';
import 'package:impo/src/screens/home/tabs/calender/photo_page_screen.dart';
import 'package:impo/src/screens/home/tabs/expert/rate_screen.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../../../../packages/featureDiscovery/src/foundation/feature_discovery.dart';
import '../../../../firebase_analytics_helper.dart';
import '../../home.dart';

class ChatScreen extends StatefulWidget{
  final ExpertPresenter? expertPresenter;
  final chatId;
  final fromRateScreen;
  final fromMainExpert;
  final fromActiveClini;
  ChatScreen({Key? key,this.expertPresenter,this.chatId,this.fromRateScreen,this.fromMainExpert,this.fromActiveClini}):super(key:key);

  @override
  State<StatefulWidget> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin{

  Animations animations =  Animations();
  late TextEditingController controller;
  // TextEditingController rateValueController;
  late AnimationController animationControllerScaleSendButton;
  late PanelController panelController;
  late String _localPath;
  int modePanel  = 0;
  late ScrollController _scrollController;
  bool isScroll = false;
  late ChatsModel selectedchatModel;
  int modePress = 0;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // AudioPlayer audioPlayer = AudioPlayer();



  @override
  void initState() {
    super.initState();
    AnalyticsHelper().log(AnalyticsEvents.ChatPg_Self_Pg_Load);
    panelController =  PanelController();
    _scrollController = ScrollController();
    // FlutterDownloader.registerCallback(downloadCallback);
    widget.expertPresenter!.getInfoPolar(false,chatId: widget.chatId,thiss: this);
    widget.expertPresenter!.initialDialogScale(this);
    if(widget.fromRateScreen != null){
      WidgetsBinding.instance.addPostFrameCallback((_){
        widget.expertPresenter!.showToast("نظر شما با موفقیت ثبت شد",_scaffoldKey.currentContext);
        // _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Your message here..")));
      });
    }
    animationControllerScaleSendButton = animations.pressButton(this);
    controller =  TextEditingController();
    // rateValueController =  TextEditingController();
    initDownloadFile();
    // bindBackgroundIsolate();
    // if(widget.expertPresenter!.chats.stream.value.chats.length == 1){
    //   WidgetsBinding.instance.addPostFrameCallback((_) => endOfScroll());
    // }
    // endOfScroll();

  }

  endOfScroll(){
    if(!isScroll){
      Timer(Duration(milliseconds: 500),(){
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      });
      // if(this.mounted){
      //   setState(() {
          isScroll = true;
      //   });
      // }
    }
  }

  // static void downloadCallback(
  //     String id, DownloadTaskStatus status, int progress) {
  //   // if (debug) {
  //   //   print(
  //   //       'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
  //   // }
  //   final SendPort send =
  //   IsolateNameServer.lookupPortByName('downloader_send_port');
  //   send.send([id, status, progress]);
  // }
  //
  // void bindBackgroundIsolate() {
  //   bool isSuccess = IsolateNameServer.registerPortWithName(
  //       _port.sendPort, 'downloader_send_port');
  //   // print('isSuccess : ${isSuccess}');
  //   if (!isSuccess) {
  //     unbindBackgroundIsolate();
  //     bindBackgroundIsolate();
  //     return;
  //   }
  //   _port.listen((dynamic data) {
  //
  //     String id = data[0];
  //     DownloadTaskStatus status = data[1];
  //     int progress = data[2];
  //
  //     widget.expertPresenter!.listenPort(id, status, progress);
  //
  //   });
  // }

  // void unbindBackgroundIsolate() {
  //   // print('disssssssss');
  //   IsolateNameServer.removePortNameMapping('downloader_send_port');
  // }


  Future<bool> _checkPermissionAudio() async {
      final status = await Permission.audio.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.audio.request();
        print(result);
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    return false;
  }

  getAndroidVersion()async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt;
  }

  Future<bool> _checkPermissionsStorage() async {
    final status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      var result;
      if(await getAndroidVersion() >= 33){
         result = await Permission.manageExternalStorage.request();
      }else{
         result = await Permission.storage.request();
      }
      print(result);
      if (result == PermissionStatus.granted) {
        return true;
      }else if(result == PermissionStatus.permanentlyDenied){
        openAppSettings();
      }
    } else {
      return true;
    }
    return false;
  }


  @override
  void dispose() {
   // unbindBackgroundIsolate();
    for(int i=0 ; i<widget.expertPresenter!.chats.stream.value.chats.length ; i++){
      widget.expertPresenter!.chats.stream.value.chats[i].animationController.dispose();
    }
   _scrollController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.ChatPg_Back_NavBar_Clk);
    if(panelController.isPanelOpen){
      panelController.close();
    }else{
      // Navigator.pop(context);
      Navigator.push(
          context,
          PageTransition(
              settings: RouteSettings(name: "/Page1"),
              type: PageTransitionType.fade,
              child: FeatureDiscovery(
                  recordStepsInSharedPreferences: true,
                  child: Home(
                    indexTab: 1,
                    isChangeStatus: false,
                  )
              )
          )
      );
      // if(selectedchatModel != null){
      //   await selectedchatModel.audioPlayer.pause();
      // }
      // widget.fromMainExpert ?
      //     widget.fromActiveClini ?
      //     Navigator.pushReplacement(
      //         context,
      //         PageTransition(
      //             type: PageTransitionType.fade,
      //             child: ActiveClinicScreen(
      //               expertPresenter: widget.expertPresenter!,
      //               randomMessage: widget.randomMessage,
      //             )
      //         )
      //     ) :
      //     Navigator.pushReplacement(
      //         context,
      //         PageTransition(
      //             settings: RouteSettings(name: "/Page1"),
      //             type: PageTransitionType.fade,
      //             child: FeatureDiscovery(
      //                 recordStepsInSharedPreferences: true,
      //                 child: Home(
      //                   indexTab: 1,
      //                   isChangeStatus: false,
      //                 )
      //             )
      //         )
      //     )
      //     : Navigator.push(
      //     context,
      //     PageTransition(
      //         type: PageTransitionType.fade,
      //         child: ExpertQuestionList(
      //           expertPresenter: widget.expertPresenter!,
      //           randomMessage: widget.randomMessage,
      //           currentValue: widget.expertPresenter!.infoAdvice.stream.value.currentValue.toString(),
      //         )
      //     )
      // );
    }
    return Future.value(false);
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
            key: _scaffoldKey,
            resizeToAvoidBottomInset: true,
            // resizeToAvoidBottomPadding: true,
            backgroundColor: Colors.white,
            body: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(20)),
                        child:  StreamBuilder(
                          stream: widget.expertPresenter!.infoAdviceObserve,
                          builder: (context,AsyncSnapshot<InfoAdviceModel>snapshotInfo){
                            if(snapshotInfo.data != null){
                              return  CustomAppBar(
                                messages: true,
                                profileTab: true,
                                subTitleProfileTab: "کلینیک",
                                valuePolar: snapshotInfo.data!.currentValue.toString(),
                                titleProfileTab: 'صفحه قبل',
                                icon: 'assets/images/ic_arrow_back.svg',
                                isPolar: true,
                                onPressBack: (){
                                  AnalyticsHelper().log(AnalyticsEvents.ChatPg_Back_Btn_Clk);
                                  _onWillPop();
                                },
                                expertPresenter: widget.expertPresenter!,
                              );
                            }else{
                              return  Container();
                            }
                          },
                        )
                    ),
                    Expanded(
                      child:  StreamBuilder(
                        stream: widget.expertPresenter!.isLoadingObserve,
                        builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                          if(snapshotIsLoading.data != null){
                            if(!snapshotIsLoading.data!){
                              return  StreamBuilder(
                                stream: widget.expertPresenter!.chatsObserve,
                                builder: (context,AsyncSnapshot<ChatTicketModel>snapShotChats){
                                  if(snapShotChats.data != null){
                                      return  NotificationListener<OverscrollIndicatorNotification>(
                                          onNotification: (overscroll) {
                                            overscroll.disallowIndicator();
                                            return true;
                                          },
                                          child:  ListView.builder(
                                            controller: _scrollController,
                                            itemCount: snapShotChats.data!.chats.length,
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (context,index){
                                              endOfScroll();
                                              return  Column(
                                                children: <Widget>[
                                                  index == 0 && snapShotChats.data!.drValid ?
                                                  Column(
                                                    children: <Widget>[
                                                      Container(
                                                        height: ScreenUtil().setWidth(200),
                                                        width: ScreenUtil().setWidth(200),
                                                        decoration:  BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            border: Border.all(
                                                                color: Color(0xffF2F2F2),
                                                                width: ScreenUtil().setWidth(2)
                                                            ),
                                                            image:  DecorationImage(
                                                              fit: BoxFit.cover,
                                                                image: NetworkImage(
                                                                  '$mediaUrl/file/${snapShotChats.data!.drImage}',
                                                                )
                                                            )
                                                        ),
                                                      ),
                                                      SizedBox(height: ScreenUtil().setHeight(20)),
                                                      Text(
                                                        snapShotChats.data!.drName,
                                                        style:  context.textTheme.labelLargeProminent!.copyWith(
                                                          color: ColorPallet().mainColor,
                                                        ),
                                                      ),
                                                      SizedBox(height: ScreenUtil().setHeight(10)),
                                                      Text(
                                                        snapShotChats.data!.drAcadimicCertificate,
                                                        style:  context.textTheme.bodySmall!.copyWith(
                                                          color: ColorPallet().gray,
                                                        ),
                                                      ),
                                                    ],
                                                  ) :
                                                   Container(),
                                                  snapShotChats.data!.chats[index].sideType == 0 ?
                                                  fileWidget(snapShotChats.data!,index)
                                                      : isVoice(snapShotChats.data!.chats[index].media!) ?
                                                  voiceWidget(snapShotChats.data!, index) :
                                                  fileWidget(snapShotChats.data!,index),
                                                  index == snapShotChats.data!.chats.length - 1 ?
                                                  Column(
                                                    children: <Widget>[
                                                      snapShotChats.data!.state == 3 && snapShotChats.data!.isRate ?
                                                      boxBottomRate(snapShotChats.data!)
                                                          : buttonRemoveTicket(50, 260, 260),
                                                      StreamBuilder(
                                                        stream: widget.expertPresenter!.uploadFilesObserve,
                                                        builder: (context,AsyncSnapshot<List<UploadFileModel>>snapshotUploadFiles){
                                                          if(snapshotUploadFiles.data != null){
                                                            if(snapshotUploadFiles.data!.length == 0){
                                                              return   SizedBox(height: ScreenUtil().setHeight(160));
                                                            }else{
                                                              return   SizedBox(height: ScreenUtil().setHeight(300));
                                                            }
                                                          }else{
                                                            return  Container();
                                                          }
                                                        },
                                                      )
                                                    ],
                                                  ) :  Container()
                                                ],
                                              );
                                            },
                                          )
                                      );
                                    // }
                                  }else{
                                    return  Container();
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
                                                 top: ScreenUtil().setWidth(200),
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
                                                          widget.expertPresenter!.getInfoPolar(false,chatId: widget.chatId,thiss: this);
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
                            return  Container();
                          }
                        },
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                  ],
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child:  StreamBuilder(
                      stream: widget.expertPresenter!.chatsObserve,
                      builder: (context,AsyncSnapshot<ChatTicketModel>snapshotChats){
                        if(snapshotChats.data != null){
                          if(snapshotChats.data!.chats.length != 0){
                            return  Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                StreamBuilder(
                                  stream: widget.expertPresenter!.uploadFilesObserve,
                                  builder: (context,AsyncSnapshot<List<UploadFileModel>>snapshotUploadFiles){
                                    if(snapshotUploadFiles.data != null){
                                      if(snapshotUploadFiles.data!.length != 0){
                                        return   NotificationListener<OverscrollIndicatorNotification>(
                                            onNotification: (overscroll) {
                                              overscroll.disallowIndicator();
                                              return true;
                                            },
                                            child:  ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: snapshotUploadFiles.data!.length,
                                              itemBuilder: (context,index){
                                                return  Container(
                                                  margin: EdgeInsets.only(
                                                      left: ScreenUtil().setWidth(25),
                                                      right: ScreenUtil().setWidth(25)
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      top: ScreenUtil().setWidth(25),
                                                      bottom: ScreenUtil().setWidth(25),
                                                      right: ScreenUtil().setWidth(15),
                                                      left: ScreenUtil().setWidth(15)
                                                  ),
                                                  decoration:  BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(10),
                                                        topRight: Radius.circular(10),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Color(0xff5F9BDF).withOpacity(0.35),
                                                            blurRadius: 7.0
                                                        )
                                                      ]
                                                  ),
                                                  child:  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: (){
                                                          widget.expertPresenter!.cancelUpload(snapshotUploadFiles.data![index].fileName.path,snapshotUploadFiles.data![index].fileNameForSend);
                                                        },
                                                        child: Container(
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
                                                          child:  Center(
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
                                                      ),
                                                      Flexible(
                                                        flex: 4,
                                                        child:  Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: <Widget>[
                                                            Text(
                                                              snapshotUploadFiles.data![index].name,
                                                              textDirection: TextDirection.ltr,
                                                              style:  context.textTheme.bodySmall,
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
                                                                            progressColor: ColorPallet().mainColor,
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
                                                      snapshotUploadFiles.data![index].type == 0 ?
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
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                        );
                                      }else{
                                        return  Container();
                                      }
                                    }else{
                                      return  Container();
                                    }
                                  },
                                ),
                                boxSendMessage()
                              ],
                            );
                          }else{
                            return  Container();
                          }
                        }else{
                          return  Container();
                        }
                      },
                    )
                ),
                SlidingUpPanel(
                  controller: panelController,
                  backdropEnabled: true,
                  minHeight: 0,
                  backdropColor: Colors.black,
                  maxHeight: modePanel == 0 ? MediaQuery.of(context).size.height / 5 : MediaQuery.of(context).size.height / 1.5,
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
                          child:
                          // modePanel == 0 ? attachPanel() : sendRate()
                            attachPanel()
                      ),
                    ],
                  ),
                ),
                StreamBuilder(
                  stream: widget.expertPresenter!.isShowRemoveTicketDialogObserve,
                  builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog){
                    if(snapshotIsShowDialog.data != null){
                      if(snapshotIsShowDialog.data!){
                        return StreamBuilder(
                          stream: widget.expertPresenter!.isLoadingButtonObserve,
                          builder: (context,snapshotIsLoadingButton){
                            if(snapshotIsLoadingButton.data != null){
                              return  QusDialog(
                                scaleAnim: widget.expertPresenter!.dialogScaleObserve,
                                onPressCancel: (){
                                  AnalyticsHelper().log(AnalyticsEvents.ChatPg_RemoveTicketNoDlg_Btn_Clk);
                                  widget.expertPresenter!.onPressCancelRemoveTicketDialog();
                                },
                                value: "می‌خوای این تیکت رو حذف کنی؟",
                                yesText: 'آره!',
                                noText: 'نه',
                                onPressYes: (){
                                  AnalyticsHelper().log(AnalyticsEvents.ChatPg_RemoveTicketYesDlg_Btn_Clk);
                                  widget.expertPresenter!.deleteTicket(widget.chatId,
                                      context,widget.expertPresenter!,
                                      widget.expertPresenter!.infoAdvice.stream.value.currentValue.toString(),widget.fromMainExpert,widget.fromActiveClini);
                                },
                                isIcon: true,
                                colors: [Colors.white,Colors.white],
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
                StreamBuilder(
                  stream: widget.expertPresenter!.isShowDialogObserve,
                  builder: (context,AsyncSnapshot<bool>snapshotDialogScale){
                    if(snapshotDialogScale.data != null){
                      if(snapshotDialogScale.data!){
                        return  StreamBuilder(
                          stream: widget.expertPresenter!.textDialogObserve,
                          builder: (context,AsyncSnapshot<String>snapshotTextDialog){
                            if(snapshotTextDialog.data != null && snapshotTextDialog.data != ''){
                              return   OkDialog(
                                scaleAnim: widget.expertPresenter!.dialogScaleObserve,
                                okText: snapshotTextDialog.data!.split('/')[0],
                                title: '${widget.expertPresenter!.getName()} جان',
                                value: snapshotTextDialog.data!.split('/')[1],
                                onPressOk: (){
                                  if(snapshotTextDialog.data!.split('/')[0] == 'تایید'){
                                    widget.expertPresenter!.onPressOkSuccessfulDialogInChatScreen(context,widget.expertPresenter!,widget.chatId,widget.fromMainExpert,widget.fromActiveClini);
                                  }else{
                                    widget.expertPresenter!.onPressYesDialog();
                                  }
                                },
                                onPressClose: (){
                                  if(snapshotTextDialog.data!.split('/')[0] == 'تایید'){
                                    widget.expertPresenter!.onPressOkSuccessfulDialogInChatScreen(context,widget.expertPresenter!,widget.chatId,widget.fromMainExpert,widget.fromActiveClini);
                                  }else{
                                    widget.expertPresenter!.onPressYesDialog();
                                  }
                                },
                                colors: [Colors.white,Colors.white],
                                topIcon: 'assets/images/ic_box_question.svg',
                                isExpert: true,
                              );
                            }else{
                              return  Container();
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
      ),
    );
  }

  Widget fileWidget(ChatTicketModel chatTicketModel,int index){
    return GestureDetector(
      onTap: (){
        _checkPermissionsStorage().then((hasGranted) {
          if(hasGranted){
            onPressDownloadFile(chatTicketModel.chats[index],false,index);
          }
        });
      },
      child: Padding(
        padding: EdgeInsets.only(
            right: ScreenUtil().setWidth(30),
            left: ScreenUtil().setWidth(30),
            top: ScreenUtil().setWidth(25)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            chatTicketModel.chats[index].sideType == 1 ?
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
              width: ScreenUtil().setWidth(80),
              height: ScreenUtil().setWidth(80),
              decoration:  BoxDecoration(
                  shape: BoxShape.circle,
                  image:  DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          '$mediaUrl/file/${chatTicketModel.drImage}'
                      )
                  )
              ),
            ) : Container(),
            Flexible(
              child:  Container(
                  margin: EdgeInsets.only(
                    right: chatTicketModel.chats[index].sideType == 0 ? ScreenUtil().setWidth(MediaQuery.of(context).size.width/4.5): ScreenUtil().setWidth(20),
                    left: chatTicketModel.chats[index].sideType == 0 ? ScreenUtil().setWidth(10) : ScreenUtil().setWidth(MediaQuery.of(context).size.width/4.5),
                    top: ScreenUtil().setWidth(30),
                  ),
                  padding: EdgeInsets.only(
                      left: chatTicketModel.chats[index].media != '' ? ScreenUtil().setWidth(10) : ScreenUtil().setWidth(20),
                      right: chatTicketModel.chats[index].media != '' ? ScreenUtil().setWidth(10) : ScreenUtil().setWidth(20)
                  ),
                  decoration:  BoxDecoration(
                      color: chatTicketModel.chats[index].sideType == 0 ? Color(0xffECEDFF) : Color(0xffFFF4F1),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15)
                      )
                  ),
                  child:  Padding(
                      padding: EdgeInsets.only(
                          top: chatTicketModel.chats[index].media != '' ? ScreenUtil().setWidth(10) : ScreenUtil().setWidth(20),
                          bottom: ScreenUtil().setWidth(10)
                      ),
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          chatTicketModel.chats[index].media != '' ?
                          Container(
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(
                                        bottom: ScreenUtil().setWidth(15)
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: ScreenUtil().setWidth(10),
                                        horizontal: ScreenUtil().setWidth(10)
                                    ),
                                    decoration:  BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        topLeft: Radius.circular(3),
                                        bottomLeft:  Radius.circular(10),
                                        bottomRight:  Radius.circular(10),
                                      ),
                                    ),
                                    child:  Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding:  EdgeInsets.only(
                                            right: ScreenUtil().setWidth(60)
                                          ),
                                          child: Text(
                                            chatTicketModel.chats[index].media!,
                                            style:  context.textTheme.bodySmall,
                                          ),
                                        ),
                                        SizedBox(height: ScreenUtil().setHeight(10)),
                                        chatTicketModel.chats[index].progress != 100 ?
                                        LinearPercentIndicator(
                                          lineHeight: ScreenUtil().setWidth(13),
                                          width: MediaQuery.of(context).size.width / 1.95,
                                          padding: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(10),
                                              right: ScreenUtil().setWidth(100)
                                          ),
                                          percent: chatTicketModel.chats[index].progress == -1 ? 0 : chatTicketModel.chats[index].progress/100.0,
                                          progressColor: ColorPallet().mainColor,
                                          backgroundColor: ColorPallet().mentalHigh.withOpacity(0.2),
                                        ) : Container(width: 0,height: 0,),
                                        SizedBox(height: ScreenUtil().setHeight(10)),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              ' KB ',
                                              style:  context.textTheme.labelSmall,
                                            ),
                                            Text(
                                              '${chatTicketModel.chats[index].fileSize}',
                                              style:  context.textTheme.labelSmall,
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: ScreenUtil().setWidth(50),
                                      right: ScreenUtil().setWidth(10),

                                  ),
                                  child: Container(
                                    height: ScreenUtil().setWidth(60),
                                    width: ScreenUtil().setWidth(60),
                                    padding: EdgeInsets.all(ScreenUtil().setWidth(7)),
                                    decoration:  BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child:  SvgPicture.asset(
                                      chatTicketModel.chats[index].progress == 0 ? 'assets/images/ic_download.svg'
                                          :    chatTicketModel.chats[index].progress == 100 ? 'assets/images/ic_box_correct.svg'
                                          : 'assets/images/ic_close.svg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                              :  Container(),
                          Text(
                            chatTicketModel.chats[index].text != '' ?
                            chatTicketModel.chats[index].text :
                            chatTicketModel.chats[index].media != null ?
                            chatTicketModel.chats[index].media!.contains('.jpeg') || chatTicketModel.chats[index].media!.contains('.gif') ||
                                chatTicketModel.chats[index].media!.contains('.jpg') || chatTicketModel.chats[index].media!.contains('.jfif') ||
                                chatTicketModel.chats[index].media!.contains('.png') || chatTicketModel.chats[index].media!.contains('.svg') ? 'تصویر' :
                            'فایل' : 'فایل',
                            style:  context.textTheme.bodyMedium,
                          ),
                          SizedBox(height: ScreenUtil().setHeight(30)),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(5)
                              ),
                              child:  Text(
                                '${chatTicketModel.chats[index].time} ${chatTicketModel.chats[index].date}',
                                style:  context.textTheme.labelSmall!.copyWith(
                                  color: ColorPallet().gray,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                  )
              ),
            ),
            chatTicketModel.chats[index].sideType == 0 ?
            Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
              child:  SvgPicture.asset(
                'assets/images/ic_expert_profile.svg',
                colorFilter: ColorFilter.mode(
                  Color(0xff7C73E6).withOpacity(0.5),
                  BlendMode.srcIn
                ),
              ),
            ) : Container()
          ],
        ),
      ),
    );
  }

  Widget voiceWidget(ChatTicketModel chatTicketModel,int index){
    return Padding(
      padding: EdgeInsets.only(
          right: ScreenUtil().setWidth(30),
          left: ScreenUtil().setWidth(30),
          top: ScreenUtil().setWidth(15)
      ),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
            width: ScreenUtil().setWidth(80),
            height: ScreenUtil().setWidth(80),
            decoration:  BoxDecoration(
                shape: BoxShape.circle,
                image:  DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        '$mediaUrl/file/${chatTicketModel.drImage}'
                    )
                )
            ),
          ),
          Flexible(
            child:  Container(
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(MediaQuery.of(context).size.width/4.5),
                  right: ScreenUtil().setWidth(20),
                  top: ScreenUtil().setWidth(30),
                ),
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    right: ScreenUtil().setWidth(20)
                ),
                decoration:  BoxDecoration(
                    color: Color(0xffFFF4F1),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        topLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)
                    )
                ),
                child:  Padding(
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setWidth(20),
                        bottom: ScreenUtil().setWidth(10)
                    ),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        chatTicketModel.chats[index].media != null ?
                        Container(
                          child:   Row(
                            children: <Widget>[
                              Flexible(
                                  child:  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: SliderTheme(
                                      data: SliderThemeData(
                                          thumbShape: RoundSliderThumbShape(
                                              enabledThumbRadius: ScreenUtil().setWidth(14)
                                          )
                                      ),
                                      child: Slider(
                                        activeColor: ColorPallet().mainColor,
                                        inactiveColor: ColorPallet().mainColor.withOpacity(0.2),
                                        // barColor: Colors.white,
                                        value: chatTicketModel.chats[index].valueVoice/100,
                                        // progressColor: ColorPallet().mainColor,
                                        onChanged: (value){
                                          print(value);
                                          double seek = ((value * chatTicketModel.chats[index].totalVoice.inMilliseconds)/1);
                                          chatTicketModel.chats[index].audioPlayer.seek(
                                              Duration(milliseconds: seek.toInt())
                                          );
                                        },
                                      ),
                                    ),
                                  )
                              ),
                               // Flexible(
                               //     child:  SeekBar(
                               //       barColor: Colors.white,
                               //       value: chatTicketModel.chats[index].valueVoice/100,
                               //       progressColor: ColorPallet().mainColor,
                               //       onProgressChanged: (value){
                               //         print(value);
                               //         double seek = ((value * chatTicketModel.chats[index].totalVoice.inMilliseconds)/1);
                               //         chatTicketModel.chats[index].audioPlayer.seek(
                               //             Duration(milliseconds: seek.toInt())
                               //         );
                               //       },
                               //     )
                               // ),
                              Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Container(
                                    height: ScreenUtil().setWidth(60),
                                    width: ScreenUtil().setWidth(60),
                                    decoration:  BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: ColorPallet().mainColor.withOpacity(0.2),
                                            width: ScreenUtil().setWidth(3)
                                        )
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: (){
                                      // _checkPermissionAudio().then((hasGranted) {
                                      //   if(hasGranted){
                                          onPressDownloadFile(chatTicketModel.chats[index],true,index);
                                      //   }
                                      // });
                                    },
                                    iconSize: ScreenUtil().setWidth(50),
                                    icon: AnimatedIcon(
                                      icon:AnimatedIcons.play_pause,
                                      progress: chatTicketModel.chats[index].animationController,
                                      color:  ColorPallet().mainColor,
                                    ),
                                  ),
                                  chatTicketModel.chats[index].isLoading && chatTicketModel.chats[index].valueVoice == 0 ?
                                  LoadingViewScreen(
                                    color:  ColorPallet().mainColor ,
                                    lineWidth: ScreenUtil().setWidth(4),
                                  )
                                      :  Container()
                                ],
                              )
                            ],
                          ),
                        )
                            :  Container(),
                        chatTicketModel.chats[index].media == null ?
                        Text(
                          chatTicketModel.chats[index].text.toString(),
                          style:  context.textTheme.bodyMedium,
                        ) :  Container(),
                        SizedBox(height: ScreenUtil().setHeight(30)),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(5)
                            ),
                            child:  Text(
                              '${chatTicketModel.chats[index].time} ${chatTicketModel.chats[index].date}',
                              style:  context.textTheme.labelSmall!.copyWith(
                                color: ColorPallet().gray,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                )
            ),
          ),
        ],
      ),
    );
  }

  Widget boxSendMessage(){
    return  StreamBuilder(
      stream: widget.expertPresenter!.chatsObserve,
      builder: (context,AsyncSnapshot<ChatTicketModel>snapshotChats){
        if(snapshotChats.data != null){
          if(snapshotChats.data!.chats.length != 0){
            if(snapshotChats.data!.state == 3 && !snapshotChats.data!.isRate){
              return  Padding(
                  padding: EdgeInsets.only(
                      bottom: ScreenUtil().setWidth(40),
                      right: ScreenUtil().setWidth(80),
                      left: ScreenUtil().setWidth(80),
                  ),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // buttonRemoveTicket(0,0,0),
                      StreamBuilder(
                        stream: animations.squareScaleBackButtonObserve,
                        builder: (context,AsyncSnapshot<double>snapshotScale){
                          if(snapshotScale.data != null){
                            return  Transform.scale(
                              scale: modePress == 2 ? snapshotScale.data : 1.0,
                              child:  GestureDetector(
                                onTap: ()async{
                                  AnalyticsHelper().log(AnalyticsEvents.ChatPg_RegComment_Btn_Clk);
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.bottomToTop,
                                          child:  RateScreen(
                                            expertPresenter: widget.expertPresenter!,
                                            chatId: widget.chatId,
                                            fromMainExpert: widget.fromMainExpert,
                                            fromActiveClini: widget.fromActiveClini,
                                          )
                                      )
                                  );
                                  // if(this.mounted){
                                  //   setState(() {
                                  //     modePress = 2;
                                  //   });
                                  // }
                                  // await animationControllerScaleSendButton.reverse();
                                  // panelController.open();
                                  // setState(() {
                                  //   modePanel=1;
                                  // });
                                  // widget.expertPresenter!.clearTextRate();
                                },
                                child:  Container(
                                    height: ScreenUtil().setWidth(85),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setWidth(80)
                                    ),
                                    decoration:  BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                                        ),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Center(
                                        child:  Text(
                                          'ثبت نظر',
                                          style: context.textTheme.labelLarge!.copyWith(
                                            color: Colors.white,
                                          ),
                                        )
                                    )
                                ),
                              ),
                            );
                          }else{
                            return  Container();
                          }
                        },

                      )
                    ],
                  )
              );
            } else{
              return  Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.only(
                      bottom: ScreenUtil().setWidth(20)
                  ),
                  height: MediaQuery.of(context).size.height/12,
                  child:  Center(
                    child:  Container(
                      // height: ScreenUtil().setWidth(80),
                        margin: EdgeInsets.only(
                          right:snapshotChats.data!.state == 2 ? ScreenUtil().setWidth(20) : ScreenUtil().setWidth(50),
                          left: snapshotChats.data!.state == 2 ? ScreenUtil().setWidth(20) : ScreenUtil().setWidth(50),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setWidth(20)
                        ),
                        decoration:  BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: snapshotChats.data!.state == 2 ?
                              ColorPallet().gray.withOpacity(0.0) : ColorPallet().gray.withOpacity(0.4),
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: snapshotChats.data!.state == 2 ?
                                  Color(0xff5F9BDF).withOpacity(0.35) : Colors.white,
                                  blurRadius: 7.0
                              )
                            ]
                        ),
                        child: snapshotChats.data!.state == 2 ?
                        Stack(
                          alignment: Alignment.centerLeft,
                          children: <Widget>[
                            Theme(
                              data: Theme.of(context).copyWith(
                                textSelectionTheme: TextSelectionThemeData(
                                    selectionColor: Color(0xffaaaaaa),
                                    cursorColor: ColorPallet().mainColor
                                ),
                              ),
                              child:  TextFormField(
                                autofocus: false,
                                onChanged: (value){
                                  widget.expertPresenter!.onChangeTextTicket(value);
                                },
                                style:  context.textTheme.bodySmall!.copyWith(
                                  color: ColorPallet().gray,
                                ),
                                maxLength: 2000,
                                maxLines: 4,
                                controller: controller,
                                decoration:  InputDecoration(
                                  isDense: true,
                                  counterText: '',
                                  border: InputBorder.none,
                                  hintText: 'متن خود را در این قسمت بنویسید',
                                  hintStyle:  context.textTheme.bodySmall!.copyWith(
                                    color: ColorPallet().gray,
                                  ),
                                  contentPadding:  EdgeInsets.only(
                                      right: ScreenUtil().setWidth(90),
                                      left: ScreenUtil().setWidth(60),
                                      top: ScreenUtil().setWidth(8)
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child:  StreamBuilder(
                                stream: animations.squareScaleBackButtonObserve,
                                builder: (context,AsyncSnapshot<double>snapshot){
                                  if(snapshot.data != null){
                                    return  Transform.scale(
                                        scale: modePress == 0 ? snapshot.data : 1.0 ,
                                        child:  StreamBuilder(
                                          stream: widget.expertPresenter!.uploadFilesObserve,
                                          builder: (context,AsyncSnapshot<List<UploadFileModel>>snapshotUploadFiles){
                                            if(snapshotUploadFiles.data != null){
                                              return  StreamBuilder(
                                                stream: widget.expertPresenter!.controllerTextTicket,
                                                builder: (context,snapshotTextController){
                                                  if(snapshotTextController.data != null){
                                                    return  StreamBuilder(
                                                      stream: widget.expertPresenter!.isLoadingUploadObserve,
                                                      builder: (context,AsyncSnapshot<bool>snapshotIsloadingUpload){
                                                        if(snapshotIsloadingUpload.data != null){
                                                          return GestureDetector(
                                                              onTap: ()async{
                                                                if(!snapshotIsloadingUpload.data!){
                                                                  if(snapshotUploadFiles .data!.length != 0 || snapshotTextController.data != ''){
                                                                    if(this.mounted){
                                                                      setState(() {
                                                                        modePress = 0;
                                                                      });
                                                                    }
                                                                    AnalyticsHelper().log(AnalyticsEvents.ChatPg_SendMessage_Btn_Clk);
                                                                    await animationControllerScaleSendButton.reverse();
                                                                    widget.expertPresenter!.onPressSendMessage(controller.text,widget.chatId);
                                                                  }
                                                                }
                                                              },
                                                              child:  StreamBuilder(
                                                                stream: widget.expertPresenter!.isLoadingButtonObserve,
                                                                builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                                                                  if(snapshotIsLoading.data != null){
                                                                    if(!snapshotIsLoading.data!){
                                                                      return  Container(
                                                                        height: ScreenUtil().setWidth(60),
                                                                        width: ScreenUtil().setWidth(60),
                                                                        margin: EdgeInsets.only(
                                                                            right: ScreenUtil().setWidth(15)
                                                                        ),
                                                                        child:  SvgPicture.asset(
                                                                          'assets/images/ic_expert_send.svg',
                                                                          fit: BoxFit.cover,
                                                                          colorFilter: ColorFilter.mode(
                                                                            !snapshotIsloadingUpload.data! ?
                                                                            snapshotUploadFiles.data!.length != 0 || snapshotTextController.data != '' ? ColorPallet().mainColor : ColorPallet().mainColor.withOpacity(0.3)
                                                                                : ColorPallet().mainColor.withOpacity(0.3),
                                                                            BlendMode.srcIn
                                                                          ),
                                                                          // color: !snapshotIsloadingUpload.data ?
                                                                          // snapshotUploadFiles.data.length != 0 || snapshotTextController.data != '' ? ColorPallet().mainColor : ColorPallet().mainColor.withOpacity(0.3)
                                                                          // : ColorPallet().mainColor.withOpacity(0.3),
                                                                        ),
                                                                      );
                                                                    }else{
                                                                      return LoadingViewScreen(
                                                                          color: ColorPallet().mainColor
                                                                      );
                                                                    }
                                                                  }else{
                                                                    return  Container();
                                                                  }
                                                                },
                                                              )
                                                          );
                                                        }else{
                                                          return Container();
                                                        }
                                                      },
                                                    );
                                                  }else{
                                                    return  Container();
                                                  }
                                                },
                                              );
                                            }else{
                                              return  Container();
                                            }
                                          },
                                        )
                                    );
                                  }else{
                                    return  Container();
                                  }
                                },
                              ),
                            ),
                            StreamBuilder(
                              stream: widget.expertPresenter!.uploadFilesObserve,
                              builder: (context,AsyncSnapshot<List<UploadFileModel>>snapshotUploadFiles){
                                if(snapshotUploadFiles.data != null){
                                  return   GestureDetector(
                                    onTap: (){
                                      if(snapshotUploadFiles.data!.length == 0){
                                        AnalyticsHelper().log(AnalyticsEvents.ChatPg_Attach_Btn_Clk);
                                        panelController.open();
                                        setState(() {
                                          modePanel=0;
                                        });
                                      }
                                    },
                                    child:   Container(
                                      margin: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(15)
                                      ),
                                      height: ScreenUtil().setWidth(45),
                                      width: ScreenUtil().setWidth(45),
                                      child:   SvgPicture.asset(
                                        'assets/images/ic_attach.svg',
                                        colorFilter: ColorFilter.mode(
                                            snapshotUploadFiles.data!.length == 0 ? ColorPallet().mainColor : ColorPallet().mainColor.withOpacity(0.3),
                                          BlendMode.srcIn
                                        ),
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  );
                                }else{
                                  return  Container();
                                }
                              },
                            )
                          ],
                        )
                            :
                        Center(
                          child:  Text(
                            snapshotChats.data!.state == 0 ? 'در حال بررسی توسط مشاور' :
                            snapshotChats.data!.state == 4 ? 'تیکت رد شده است' :
                            'تیکت بسته شده است',
                            style:  context.textTheme.bodyMedium!.copyWith(
                              color: ColorPallet().gray.withOpacity(0.5),
                            ),
                          ),
                        )
                    ),
                  )
              );
            }
          }else{
            return  Container();
          }
        }else{
          return  Container();
        }
      },
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: itemAttach(
                        'assets/images/ic_camera.svg',
                        'دوربین',
                            (){
                          AnalyticsHelper().log(AnalyticsEvents.ChatPg_CameraAttach_Btn_Clk);
                          panelController.close();
                          widget.expertPresenter!.getFileImage(1,true,text: controller.text,chatId: widget.chatId);
                        }
                    ),
                  ),
                  Flexible(
                    child: itemAttach(
                        'assets/images/ic_gallery.svg',
                        'گالری',
                            (){
                              AnalyticsHelper().log(AnalyticsEvents.ChatPg_GalleryAttach_Btn_Clk);
                          panelController.close();
                          widget.expertPresenter!.getFileImage(0,true,text: controller.text,chatId: widget.chatId);
                        }
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: itemAttach(
                  'assets/images/ic_document.svg',
                  'اسناد شما',
                      (){
                        AnalyticsHelper().log(AnalyticsEvents.ChatPg_DocumentAttack_Btn_Clk);
                    panelController.close();
                    widget.expertPresenter!.getFileImage(2,true,text: controller.text,chatId: widget.chatId);
                  }
              ),
            )
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
          style:  context.textTheme.bodySmall,
        )
      ],
    );
  }



  Future _loadFile(kUrl1,ChatsModel chats) async {
    try{
      final dir = await getApplicationDocumentsDirectory();
      // print(dir.path);
      final file = File('${dir.path}/${chats.media}');

      if (await file.exists()) {
        // setState(() {
        chats.localFilePath = file.path;
        // });
      }else{
        final bytes = await readBytes(Uri.parse(kUrl1));
        await file.writeAsBytes(bytes);
        chats.localFilePath = file.path;
      }
    }catch(e){
      CustomSnackBar.show(context,'لطفا اتصال اینترنت خود را بررسی کنید');
      if(this.mounted){
        setState(() {
          chats.isLoading = false;
        });
      }
      if(this.mounted){
        setState(() {
          chats.isPlaying = false;
          chats.isPlaying
              ? chats.animationController.forward()
              : chats.animationController.reverse();
        });
      }
    }
  }


  onPressDownloadFile(ChatsModel chats,isVoice,index)async{
    // print('http://192.168.1.105:11200/file/${chats.media}');
    if(isVoice){
      selectedchatModel = chats;
      if(!chats.isPlaying){
        if(this.mounted){
          setState(() {
            chats.isLoading = true;
          });
        }
        // print('$mediaUrl/file/${chats.media}');
        if(chats.localFilePath == ''){
          await _loadFile('$mediaUrl/file/${chats.media}',chats);
        }
        // print(chats.localFilePath);
        chats.audioPlayer.play(
            chats.localFilePath == '' ? UrlSource('$mediaUrl/file/${chats.media}') : DeviceFileSource(chats.localFilePath),
            // stayAwake: true,
            // isLocal: chats.localFilePath == ''? false : true
        ).timeout(Duration(seconds: 12));
        chats.audioPlayer.onPositionChanged.listen((p) {
          // print('Current position: ${p.runtimeType}');
          if(this.mounted){
            setState(() {
              chats.valueVoice = ((100.0*p.inMilliseconds)/chats.totalVoice.inMilliseconds);
            });
          }
          if(this.mounted){
            setState(() {
              chats.isPlaying = true;
              chats.isPlaying
                  ? chats.animationController.forward()
                  : chats.animationController.reverse();
            });
          }
        });
        chats.audioPlayer.onDurationChanged.listen((Duration d) {
          chats.totalVoice = d;
        });
      }else{
        if(this.mounted){
          setState(() {
            chats.isPlaying = false;
            chats.isPlaying
                ? chats.animationController.forward()
                : chats.animationController.reverse();
          });
        }
        chats.audioPlayer.pause();
      }
      chats.audioPlayer.onLog.listen((event){
        debugPrint('eroeoroerorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
        CustomSnackBar.show(context,'لطفا اتصال اینترنت خود را بررسی کنید');
        if(this.mounted){
          setState(() {
            chats.isLoading = false;
          });
        }
        if(this.mounted){
          setState(() {
            chats.isPlaying = false;
            chats.isPlaying
                ? chats.animationController.forward()
                : chats.animationController.reverse();
          });
        }
      });
      chats.audioPlayer.onPlayerComplete.listen((event) {
        if(this.mounted){
          setState(() {
            chats.isLoading = false;
          });
        }
        if(this.mounted){
          setState(() {
            chats.isPlaying = false;
            chats.animationController.reverse();
            chats.valueVoice =0;
          });
        }
      });
    }else{
      if(chats.progress  == 100){
        if(chats.media!.contains('.jpeg') || chats.media!.contains('.gif') ||
            chats.media!.contains('.jpg') || chats.media!.contains('.jfif') ||
            chats.media!.contains('.png') || chats.media!.contains('.svg') ){
          AnalyticsHelper().log(
              AnalyticsEvents.ChatPg_ShowImage_Btn_Clk,
              parameters: {
                'media' : chats.media
              }
          );
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: PhotoPageScreen(
                      photo: '${await widget.expertPresenter!.getAppDirectory()}/${chats.media}',
                      network: false,
                  )
              )
          );
        }else{
          AnalyticsHelper().log(
              AnalyticsEvents.ChatPg_ShowFile_Btn_Clk,
              parameters: {
                'media' : chats.media
              }
          );
          openFile('${await widget.expertPresenter!.getAppDirectory()}/${chats.media}');
        }
      }else{
        if(chats.media!.contains('.jpeg') || chats.media!.contains('.gif') ||
            chats.media!.contains('.jpg') || chats.media!.contains('.jfif') ||
            chats.media!.contains('.png') || chats.media!.contains('.svg') ){
          AnalyticsHelper().log(
              AnalyticsEvents.ChatPg_DownloadImage_Btn_Clk,
              parameters: {
                'media' : chats.media
              }
          );
        }else{
          AnalyticsHelper().log(
              AnalyticsEvents.ChatPg_DownloadFile_Btn_Clk,
              parameters: {
                'media' : chats.media
              }
          );
        }
        widget.expertPresenter!.download2(chats,index);
        // if(chats.status != DownloadTaskStatus.running){
        //   if(chats.status == DownloadTaskStatus.undefined){
        //     print(_localPath);
        //     chats.taskId  = await FlutterDownloader.enqueue(
        //       url: '$mediaUrl/file/${chats.media}',
        //       savedDir: _localPath,
        //       showNotification: false, // show download progress in status bar (for Android)
        //       openFileFromNotification: true, // click on notification to open downloaded file (for Android)
        //     );
        //   }else if(chats.status == DownloadTaskStatus.complete){
        //     await FlutterDownloader.open(taskId: chats.taskId);
        //   }else if(chats.status == DownloadTaskStatus.failed){
        //     await FlutterDownloader.retry(taskId: chats.taskId);
        //   }
        // }
      }
    }
  }

  openFile(url) async {
    print(url);
    try{
      await OpenFile.open(url);
    }catch(e){
      print('eeee : $e');
      //Fluttertoast.showToast(msg:'برنامه ای برای باز کردن این فایل ندارید',toastLength: Toast.LENGTH_LONG);
      CustomSnackBar.show(context, 'برنامه ای برای باز کردن این فایل ندارید');
    }
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory!.path;
  }

  initDownloadFile()async{

    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    // print(_localPath);
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }


  }

  Widget boxBottomRate(ChatTicketModel chatTicketModel){
    return  Column(
      children: [
        Container(
            margin: EdgeInsets.only(
                top: ScreenUtil().setWidth(50),
                right: ScreenUtil().setWidth(80),
                left: ScreenUtil().setWidth(80),
                bottom: ScreenUtil().setWidth(50)
            ),
            padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setWidth(20),
                horizontal: ScreenUtil().setWidth(20)
            ),
            decoration:  BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color:  ColorPallet().gray.withOpacity(0.3),
                  width: ScreenUtil().setWidth(2)
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child:  Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      // 'امتیاز شما به راهنما',
                      'امتیاز',
                        style:  context.textTheme.bodyMedium,
                    ),
                    Directionality(
                        textDirection: TextDirection.ltr,
                        child: RatingBar.builder(
                          initialRating: chatTicketModel.rate,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          ignoreGestures: true,
                          itemCount: 5,
                          itemSize: ScreenUtil().setWidth(28),
                          itemPadding: EdgeInsets.symmetric(horizontal:ScreenUtil().setWidth(2)),
                          itemBuilder: (context, _) => SvgPicture.asset(
                              'assets/images/ic_star.svg',
                                colorFilter: ColorFilter.mode(
                                    ColorPallet().mainColor,
                                  BlendMode.srcIn
                                ),
                          ),
                          unratedColor: ColorPallet().mainColor.withOpacity(0.35),
                          onRatingUpdate: (rating) {
                            debugPrint(rating.toString());
                          },
                        )
                    )
                  ],
                ),
                chatTicketModel.description != '' ?
                SizedBox(height: ScreenUtil().setHeight(20)) :  Container(),
                chatTicketModel.description != '' ?
                Text(
                    chatTicketModel.description,
                    style:  context.textTheme.bodySmall!.copyWith(
                      color:  ColorPallet().gray,
                    )
                ) :  Container()
              ],
            )
        ),
        buttonRemoveTicket(0, 260, 260)
      ],
    );
  }

  Widget buttonRemoveTicket(topMargin,leftMargin,rightMargin){
    return StreamBuilder(
      stream: animations.squareScaleBackButtonObserve,
      builder: (context,AsyncSnapshot<double>snapshotScale){
          if(snapshotScale.data != null){
             return Transform.scale(
              scale: modePress == 1 ? snapshotScale.data : 1.0,
              child: GestureDetector(
                onTap: ()async{
                  AnalyticsHelper().log(AnalyticsEvents.ChatPg_RemoveTicket_Btn_Clk);
                  if(this.mounted){
                    setState(() {
                      modePress = 1;
                    });
                  }
                  await animationControllerScaleSendButton.reverse();
                  widget.expertPresenter!.showRemoveTicketDialog();
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setWidth(topMargin),
                    right: ScreenUtil().setWidth(leftMargin) ,
                    left: ScreenUtil().setWidth(rightMargin),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setWidth(10),
                    horizontal: ScreenUtil().setWidth(15)
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: ColorPallet().gray.withOpacity(0.4)
                      )
                  ),
                  child: Center(
                    child: Text(
                      'حذف تیکت',
                      style: context.textTheme.labelLarge!.copyWith(
                        color: ColorPallet().gray.withOpacity(0.8),
                      ),
                    ),
                  )
                ),
              ),
            );
          }else{
            return Container();
          }
      },
    );
  }

  bool isVoice(String file){
    if(
        file.contains('.mp4a') ||
        file.contains('.mpga') ||
        file.contains('.mp2') ||
        file.contains('.mp2a') ||
        file.contains('.mp3') ||
        file.contains('.m2a') ||
        file.contains('.m3a') ||
        file.contains('.wav') ||
        file.contains('weba') ||
        file.contains('.aac') ||
        file.contains('.oga') ||
        file.contains('.spx')
    ){
      return true;
    }else{
      return false;
    }
  }

}
