import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:impo/src/architecture/presenter/support_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/expert_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/widgets/snackbar/custom_snack_bar.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/firebase_analytics_helper.dart';
import 'package:impo/src/models/expert/upload_file_model.dart';
import 'package:impo/src/models/support/support_chat_model.dart';
import 'package:impo/src/models/support/support_ticket_model.dart';
import 'package:impo/src/screens/home/tabs/calender/photo_page_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/supportOnline/pages/support_rate_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/supportOnline/pages/support_screen.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ChatSupportScreen extends StatefulWidget{
  final SupportPresenter? supportPresenter;
  final String? chatId;
  final bool? fromNotify;

  ChatSupportScreen({Key? key,this.supportPresenter,this.chatId,this.fromNotify}):super(key:key);

  @override
  State<StatefulWidget> createState() => ChatSupportScreenState();
}

class ChatSupportScreenState extends State<ChatSupportScreen> with TickerProviderStateMixin{

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ScrollController _scrollController;
  bool isScroll = false;
  late PanelController panelController;
  late String _localPath;
  late SupportChatModel selectedchatModel;
  late TextEditingController controller;
  Animations animations =  Animations();
  late AnimationController animationControllerScaleSendButton;
  int modePress = 0;

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.ChatSupportPg_Back_NavBar_Clk);
    // if(widget.fromNotify!){
      Navigator.pushReplacement(
          context,
          PageTransition(
              child: SupportScreen(
                categoryId: '',
                fromNotify: false,
              ),
              type: PageTransitionType.fade
          )
      );
      return Future.value(false);
    // }else{
    //   return Future.value(true);
    // }
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


  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.ChatSupportPg_Self_Pg_Load);
    widget.supportPresenter!.clearFiles();
    widget.supportPresenter!.getTicket(widget.chatId!,this);
    panelController =  PanelController();
    _scrollController = ScrollController();
    animationControllerScaleSendButton = animations.pressButton(this);
    controller =  TextEditingController();
    initDownloadFile();
    super.initState();
  }

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
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
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
                        child:  CustomAppBar(
                          messages: false,
                          profileTab: true,
                          isEmptyLeftIcon: true,
                          subTitleProfileTab: "پشتیبانی",
                          titleProfileTab: 'صفحه قبل',
                          icon: 'assets/images/ic_arrow_back.svg',
                          onPressBack: (){
                           AnalyticsHelper().log(AnalyticsEvents.ChatSupportPg_Back_Btn_Clk);
                           // if(widget.fromNotify!){
                             Navigator.pushReplacement(
                                 context,
                                 PageTransition(
                                     child: SupportScreen(
                                       categoryId: '',
                                       fromNotify: false,
                                     ),
                                     type: PageTransitionType.fade
                                 )
                             );
                           // }else{
                           //   Navigator.pop(context);
                           // }
                          },
                        )
                    ),
                    Expanded(
                      child:  StreamBuilder(
                        stream: widget.supportPresenter!.isLoadingObserve,
                        builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                          if(snapshotIsLoading.data != null){
                            if(!snapshotIsLoading.data!){
                              return  StreamBuilder(
                                stream: widget.supportPresenter!.supportTicketObserve,
                                builder: (context,AsyncSnapshot<SupportTicketModel>snapShotTicket){
                                  if(snapShotTicket.data != null){
                                    return  NotificationListener<OverscrollIndicatorNotification>(
                                        onNotification: (overscroll) {
                                          overscroll.disallowIndicator();
                                          return true;
                                        },
                                        child:  ListView.builder(
                                          controller: _scrollController,
                                          itemCount: snapShotTicket.data!.items.length,
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context,index){
                                            endOfScroll();
                                            return  Column(
                                              children: <Widget>[
                                                snapShotTicket.data!.items[index].sendByUser ?
                                                fileWidget(snapShotTicket.data!,index)
                                                    : snapShotTicket.data!.items[index].fileName != null ?
                                                fileWidget(snapShotTicket.data!,index) :
                                                voiceWidget(snapShotTicket.data!, index),
                                                index == snapShotTicket.data!.items.length - 1 ?
                                                Column(
                                                  children: <Widget>[
                                                    snapShotTicket.data!.status == 1 && snapShotTicket.data!.isRate ?
                                                    boxBottomRate(snapShotTicket.data!)
                                                        : SizedBox.shrink(),
                                                    StreamBuilder(
                                                      stream: widget.supportPresenter!.uploadFilesObserve,
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
                                    stream: widget.supportPresenter!.tryButtonErrorObserve,
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
                                                    stream: widget.supportPresenter!.valueErrorObserve,
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
                                                          widget.supportPresenter!.getTicket(widget.chatId!,this);
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
                      stream: widget.supportPresenter!.supportTicketObserve,
                      builder: (context,AsyncSnapshot<SupportTicketModel>snapshotTicket){
                        if(snapshotTicket.data != null){
                          if(snapshotTicket.data!.items.length != 0){
                            return  Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                StreamBuilder(
                                  stream: widget.supportPresenter!.uploadFilesObserve,
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
                                                          widget.supportPresenter!.cancelUpload(snapshotUploadFiles.data![index].fileName.path,snapshotUploadFiles.data![index].fileNameForSend);
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
                                                              style:  context.textTheme.bodyMedium,
                                                            ),
                                                            SizedBox(height: ScreenUtil().setHeight(10)),
                                                            snapshotUploadFiles.data![index].stateUpload == 0 ?
                                                            ClipRRect(
                                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                child:  Directionality(
                                                                    textDirection: TextDirection.ltr,
                                                                    child:  StreamBuilder(
                                                                      stream: widget.supportPresenter!.sendValuePercentUploadFileObserve,
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
                                                        child:  SvgPicture.asset(
                                                          'assets/images/ic_pdf.svg',
                                                        ),
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
                  maxHeight:  MediaQuery.of(context).size.height / 5,
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
              ],
            )
        ),
      ),
    );
  }

  Widget fileWidget(SupportTicketModel supportTicketModel,int index){
    return GestureDetector(
      onTap: (){
        _checkPermissionsStorage().then((hasGranted) {
          if(hasGranted){
            onPressDownloadFile(supportTicketModel.items[index],false,index);
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
            !supportTicketModel.items[index].sendByUser ?
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
              padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
              width: ScreenUtil().setWidth(80),
              height: ScreenUtil().setWidth(80),
              decoration:  BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffEDECFF),
              ),
              child: SvgPicture.asset(
                  'assets/images/ic_profile_support.svg'
              ),
            )
                : Container(),
            Flexible(
              child:  Container(
                  margin: EdgeInsets.only(
                    right: supportTicketModel.items[index].sendByUser  ? ScreenUtil().setWidth(MediaQuery.of(context).size.width/4.5): ScreenUtil().setWidth(20),
                    left: supportTicketModel.items[index].sendByUser ? ScreenUtil().setWidth(10) : ScreenUtil().setWidth(MediaQuery.of(context).size.width/4.5),
                    top: ScreenUtil().setWidth(30),
                  ),
                  padding: EdgeInsets.only(
                      left: supportTicketModel.items[index].fileName != '' ? ScreenUtil().setWidth(10) : ScreenUtil().setWidth(20),
                      right: supportTicketModel.items[index].fileName != '' ? ScreenUtil().setWidth(10) : ScreenUtil().setWidth(20)
                  ),
                  decoration:  BoxDecoration(
                      color: supportTicketModel.items[index].sendByUser ? Color(0xffECEDFF) : Color(0xffFFF4F1),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15)
                      )
                  ),
                  child:  Padding(
                      padding: EdgeInsets.only(
                          top: supportTicketModel.items[index].fileName != '' ? ScreenUtil().setWidth(10) : ScreenUtil().setWidth(20),
                          bottom: ScreenUtil().setWidth(10)
                      ),
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          supportTicketModel.items[index].fileName != '' ?
                          supportTicketModel.items[index].fileName!.contains('.jpeg') || supportTicketModel.items[index].fileName!.contains('.gif') ||
                              supportTicketModel.items[index].fileName!.contains('.jpg') || supportTicketModel.items[index].fileName!.contains('.jfif') ||
                              supportTicketModel.items[index].fileName!.contains('.png') || supportTicketModel.items[index].fileName!.contains('.svg') ?
                          Padding(
                            padding:  EdgeInsets.only(
                                top: ScreenUtil().setWidth(15),
                                bottom: ScreenUtil().setWidth(20),
                                right: ScreenUtil().setWidth(10)
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child:  FancyShimmerImage(
                                  imageUrl: '$womanUrl/support/file/${supportTicketModel.items[index].fileName}',
                                  boxFit: BoxFit.cover,
                                  // width:  ScreenUtil().setWidth(300),
                                  // alignment: Alignment.bottomRight,
                                )
                              // Image.network(
                              //   '$womanUrl/support/file/${supportTicketModel.items[index].fileName}',
                              //   fit: BoxFit.cover,
                              //
                              // ),
                            ),
                          )  :
                          Stack(
                            alignment: Alignment.bottomRight,
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
                                      Text(
                                        supportTicketModel.items[index].fileName!,
                                        style: context.textTheme.bodySmall,
                                      ),
                                      SizedBox(height: ScreenUtil().setHeight(10)),
                                      supportTicketModel.items[index].progress != 100 ?
                                      LinearPercentIndicator(
                                        lineHeight: ScreenUtil().setWidth(13),
                                        width: MediaQuery.of(context).size.width / 1.95,
                                        padding: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(10),
                                            right: ScreenUtil().setWidth(100)
                                        ),
                                        percent: supportTicketModel.items[index].progress == -1 ? 0 : supportTicketModel.items[index].progress/100.0,
                                        progressColor: ColorPallet().mainColor,
                                        backgroundColor: ColorPallet().mentalHigh.withOpacity(0.2),
                                      ) : Container(width: 0,height: 0,),
                                      SizedBox(height: ScreenUtil().setHeight(10)),
                                    ],
                                  )
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: ScreenUtil().setWidth(20),
                                    right: ScreenUtil().setWidth(10)
                                ),
                                child: Container(
                                  height: ScreenUtil().setWidth(60),
                                  width: ScreenUtil().setWidth(60),
                                  padding: EdgeInsets.all(ScreenUtil().setWidth(7)),
                                  decoration:  BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child:  SvgPicture.asset(
                                    supportTicketModel.items[index].progress == 0 ? 'assets/images/ic_download.svg'
                                        :    supportTicketModel.items[index].progress == 100 ? 'assets/images/ic_box_correct.svg'
                                        : 'assets/images/ic_close.svg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          )
                              :  Container(),
                          Padding(
                            padding: EdgeInsets.only(
                              right: ScreenUtil().setWidth(12)
                            ),
                            child: Text(
                              supportTicketModel.items[index].text != '' ?
                              supportTicketModel.items[index].text :
                              supportTicketModel.items[index].fileName != null ?
                              supportTicketModel.items[index].fileName!.contains('.jpeg') || supportTicketModel.items[index].fileName!.contains('.gif') ||
                                  supportTicketModel.items[index].fileName!.contains('.jpg') || supportTicketModel.items[index].fileName!.contains('.jfif') ||
                                  supportTicketModel.items[index].fileName!.contains('.png') || supportTicketModel.items[index].fileName!.contains('.svg') ? 'تصویر' :
                              'فایل' : 'فایل',
                              style:  context.textTheme.bodyMedium,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(30)),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(5)
                              ),
                              child:  Text(
                                '${supportTicketModel.items[index].time} ${supportTicketModel.items[index].date}',
                                style:  context.textTheme.bodySmall,
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
      ),
    );
  }

  Widget voiceWidget(SupportTicketModel supportTicketModel,int index){
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
            padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
            width: ScreenUtil().setWidth(80),
            height: ScreenUtil().setWidth(80),
            decoration:  BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffEDECFF),
                image:  DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                        'assets/images/ic_profile_support.svg'
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
                        supportTicketModel.items[index].fileName != null ?
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
                                        value: supportTicketModel.items[index].valueVoice/100,
                                        // progressColor: ColorPallet().mainColor,
                                        onChanged: (value){
                                          print(value);
                                          double seek = ((value * supportTicketModel.items[index].totalVoice.inMilliseconds)/1);
                                          supportTicketModel.items[index].audioPlayer.seek(
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
                               //       value: supportTicketModel.items[index].valueVoice/100,
                               //       progressColor: ColorPallet().mainColor,
                               //       onProgressChanged: (value){
                               //         print(value);
                               //         double seek = ((value * supportTicketModel.items[index].totalVoice.inMilliseconds)/1);
                               //         supportTicketModel.items[index].audioPlayer.seek(
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
                                          onPressDownloadFile(supportTicketModel.items[index],true,index);
                                      //   }
                                      // });
                                    },
                                    iconSize: ScreenUtil().setWidth(50),
                                    icon: AnimatedIcon(
                                      icon:AnimatedIcons.play_pause,
                                      progress: supportTicketModel.items[index].animationController,
                                      color:  ColorPallet().mainColor,
                                    ),
                                  ),
                                  supportTicketModel.items[index].isLoading && supportTicketModel.items[index].valueVoice == 0 ?
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
                        supportTicketModel.items[index].fileName == null ?
                        Text(
                          supportTicketModel.items[index].text.toString(),
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
                              '${supportTicketModel.items[index].time} ${supportTicketModel.items[index].date}',
                              style:  context.textTheme.bodySmall,
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

  Widget boxBottomRate(SupportTicketModel supportTicketModel){
    return  Container(
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
                      initialRating: supportTicketModel.rate,
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
            supportTicketModel.rateDescription != '' ?
            SizedBox(height: ScreenUtil().setHeight(20)) :  Container(),
            supportTicketModel.rateDescription != '' ?
            Text(
                supportTicketModel.rateDescription,
                style:  context.textTheme.bodySmall!.copyWith(
                  color:  ColorPallet().gray,
                )
            ) :  Container()
          ],
        )
    );
  }

  Widget boxSendMessage(){
    return  StreamBuilder(
      stream: widget.supportPresenter!.supportTicketObserve,
      builder: (context,AsyncSnapshot<SupportTicketModel>snapshotChats){
        if(snapshotChats.data != null){
          if(snapshotChats.data!.items.length != 0){
            if(snapshotChats.data!.status == 1 && !snapshotChats.data!.isRate){
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
                                   ///AnalyticsHelper().log(AnalyticsEvents.ChatPg_RegComment_Btn_Clk);
                                   Navigator.pushReplacement(
                                       context,
                                       PageTransition(
                                           type: PageTransitionType.bottomToTop,
                                           child: SupportRateScreen(
                                             supportPresenter: widget.supportPresenter!,
                                             chatId: widget.chatId!,
                                           )
                                       )
                                   );
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
                          right:snapshotChats.data!.status == 0 ? ScreenUtil().setWidth(20) : ScreenUtil().setWidth(50),
                          left: snapshotChats.data!.status == 0 ? ScreenUtil().setWidth(20) : ScreenUtil().setWidth(50),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setWidth(20)
                        ),
                        decoration:  BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: snapshotChats.data!.status == 0 ?
                              ColorPallet().gray.withOpacity(0.0) : ColorPallet().gray.withOpacity(0.4),
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: snapshotChats.data!.status == 0 ?
                                  Color(0xff5F9BDF).withOpacity(0.35) : Colors.white,
                                  blurRadius: 7.0
                              )
                            ]
                        ),
                        child: snapshotChats.data!.status == 0 ?
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
                                  widget.supportPresenter!.onChangeTextTicket(value);
                                },
                                style:  context.textTheme.bodyMedium,
                                maxLength: 2000,
                                maxLines: 4,
                                controller: controller,
                                decoration:  InputDecoration(
                                  isDense: true,
                                  counterText: '',
                                  border: InputBorder.none,
                                  hintText: 'متن خود را در این قسمت بنویسید',
                                  hintStyle:  context.textTheme.bodyMedium!.copyWith(
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
                                          stream: widget.supportPresenter!.uploadFilesObserve,
                                          builder: (context,AsyncSnapshot<List<UploadFileModel>>snapshotUploadFiles){
                                            if(snapshotUploadFiles.data != null){
                                              return  StreamBuilder(
                                                stream: widget.supportPresenter!.controllerTextChatObserve,
                                                builder: (context,snapshotTextController){
                                                  if(snapshotTextController.data != null){
                                                    return  GestureDetector(
                                                        onTap: ()async{
                                                          if(snapshotUploadFiles.data!.length != 0 || snapshotTextController.data != ''){
                                                            if(this.mounted){
                                                              setState(() {
                                                                modePress = 0;
                                                              });
                                                            }
                                                            AnalyticsHelper().log(AnalyticsEvents.ChatSupportPg_SendSupport_Btn_Clk);
                                                            await animationControllerScaleSendButton.reverse();
                                                            widget.supportPresenter!.onPressSendMessage(controller,widget.chatId!,context,this,widget.supportPresenter);
                                                          }
                                                        },
                                                        child:  StreamBuilder(
                                                          stream: widget.supportPresenter!.isLoadingButtonObserve,
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
                                                                      snapshotUploadFiles.data!.length != 0 || snapshotTextController.data != '' ? ColorPallet().mainColor : ColorPallet().mainColor.withOpacity(0.3),
                                                                      BlendMode.srcIn
                                                                    ),
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
                              stream: widget.supportPresenter!.uploadFilesObserve,
                              builder: (context,AsyncSnapshot<List<UploadFileModel>>snapshotUploadFiles){
                                if(snapshotUploadFiles.data != null){
                                  return   GestureDetector(
                                    onTap: (){
                                      if(snapshotUploadFiles.data!.length == 0){
                                        AnalyticsHelper().log(AnalyticsEvents.ChatSupportPg_Attach_Btn_Clk);
                                        panelController.open();
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
                                        fit: BoxFit.fitHeight,
                                        colorFilter: ColorFilter.mode(
                                          snapshotUploadFiles.data!.length == 0 ? ColorPallet().mainColor : ColorPallet().mainColor.withOpacity(0.3),
                                          BlendMode.srcIn
                                        ),
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
                            'تیکت بسته شده است',
                            style:  context.textTheme.bodyMedium,
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
                          AnalyticsHelper().log(AnalyticsEvents.ChatSupportPg_CameraAttach_Btn_Clk);
                          panelController.close();
                          widget.supportPresenter!.getFileImage(1,true,text: controller.text,chatId: widget.chatId!);
                        }
                    ),
                  ),
                  Flexible(
                    child: itemAttach(
                        'assets/images/ic_gallery.svg',
                        'گالری',
                            (){
                          AnalyticsHelper().log(AnalyticsEvents.ChatSupportPg_GalleryAttach_Btn_Clk);
                          panelController.close();
                          widget.supportPresenter!.getFileImage(0,true,text: controller.text,chatId: widget.chatId!);
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
                    AnalyticsHelper().log(AnalyticsEvents.ChatSupportPg_DocumentAttack_Btn_Clk);
                    panelController.close();
                    widget.supportPresenter!.getFileImage(2,true,text: controller.text,chatId: widget.chatId!);
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

  onPressDownloadFile(SupportChatModel chats,isVoice,index)async{
    // print('http://192.168.1.105:11200/file/${chats.media}');
    if(isVoice){
      selectedchatModel = chats;
      if(!chats.isPlaying){
        if(this.mounted){
          setState(() {
            chats.isLoading = true;
          });
        }
        if(chats.localFilePath == ''){
          await _loadFile('$womanUrl/support/file/${chats.fileName}',chats);
        }
        // print(chats.localFilePath);
        chats.audioPlayer.play(
            chats.localFilePath == '' ? UrlSource('$womanUrl/support/file/${chats.fileName}') : DeviceFileSource(chats.localFilePath)
            // ,stayAwake: true,
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
        if(chats.fileName!.contains('.jpeg') || chats.fileName!.contains('.gif') ||
            chats.fileName!.contains('.jpg') || chats.fileName!.contains('.jfif') ||
            chats.fileName!.contains('.png') || chats.fileName!.contains('.svg') ){
          /// AnalyticsHelper().log(
          ///     AnalyticsEvents.ChatPg_ShowImage_Btn_Clk,
          ///     parameters: {
          ///       'media' : chats.media
          ///     }
          /// );
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: PhotoPageScreen(
                      photo: '${await widget.supportPresenter!.getAppDirectory()}/${chats.fileName}',
                      network: false,
                  )
              )
          );
        }else{
          /// AnalyticsHelper().log(
          ///     AnalyticsEvents.ChatPg_ShowFile_Btn_Clk,
          ///     parameters: {
          ///       'media' : chats.media
          ///     }
          /// );
          openFile('${await widget.supportPresenter!.getAppDirectory()}/${chats.fileName}');
        }
      }else{
        if(chats.fileName!.contains('.jpeg') || chats.fileName!.contains('.gif') ||
            chats.fileName!.contains('.jpg') || chats.fileName!.contains('.jfif') ||
            chats.fileName!.contains('.png') || chats.fileName!.contains('.svg') ){
          /// AnalyticsHelper().log(
          ///     AnalyticsEvents.ChatPg_DownloadImage_Btn_Clk,
          ///     parameters: {
          ///       'media' : chats.media
          ///     }
          /// );
        }else{
          /// AnalyticsHelper().log(
          ///     AnalyticsEvents.ChatPg_DownloadFile_Btn_Clk,
          ///     parameters: {
          ///       'media' : chats.media
          ///     }
          /// );
        }
        widget.supportPresenter!.download2(chats,index);
      }
    }
  }

  Future _loadFile(kUrl1,SupportChatModel chats) async {
    try{
      final dir = await getApplicationDocumentsDirectory();
      // print(dir.path);
      final file = File('${dir.path}/${chats.fileName}');

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

  openFile(url) async {
    print(url);
    try{
      await OpenFile.open(url);
    }catch(e){
      //Fluttertoast.showToast(msg:'برنامه ای برای باز کردن این فایل ندارید',toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.BOTTOM);
      CustomSnackBar.show(context,'برنامه ای برای باز کردن این فایل ندارید');
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

}