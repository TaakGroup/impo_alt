import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/support_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:get/get.dart';
import 'package:impo/src/firebase_analytics_helper.dart';
import 'package:impo/src/models/expert/upload_file_model.dart';
import 'package:impo/src/models/support/category_items_model.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SendSupportScreen extends StatefulWidget{
  final SupportPresenter? supportPresenter;

  SendSupportScreen({Key? key,this.supportPresenter}):super(key:key);

  @override
  State<StatefulWidget> createState() => SendSupportScreenState();
}

class SendSupportScreenState extends State<SendSupportScreen> with TickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Animations animations = Animations();
  late AnimationController animationControllerScaleButton;
  var focusNode = FocusNode();
  int modePress = 0;
  late CategoryItemsModel selectCategory;

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.SendSupportPg_Back_NavBar_Clk);
    Navigator.pop(context);
    return Future.value(false);
  }

  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.SendSupportPg_Self_Pg_Load);
    widget.supportPresenter!.initPanelController();
    widget.supportPresenter!.clearFiles();
    focusNode.requestFocus();
    animationControllerScaleButton = animations.pressButton(this);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              bottom: ScreenUtil().setWidth(15)
                          ),
                          child: CustomAppBar(
                            messages: false,
                            profileTab: true,
                            isEmptyLeftIcon: true,
                            icon: 'assets/images/ic_arrow_back.svg',
                            titleProfileTab: 'صفحه قبل',
                            subTitleProfileTab: 'پشتیبانی',
                            onPressBack: (){
                              AnalyticsHelper().log(AnalyticsEvents.SendSupportPg_Back_Btn_Clk);
                              Navigator.pop(context);
                            },
                          )
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(30)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: ScreenUtil().setWidth(16)),
                            Text(
                              'ارتباط با پشتیبانی',
                              style: context.textTheme.labelMediumProminent,
                            ),
                            SizedBox(height: ScreenUtil().setWidth(8)),
                            Text(
                              '${widget.supportPresenter!.getRegisters().name} جان، سوال یا مشکلت رو اینجا بنویس تا پشتیبان‌های ایمپو در اولین فرصت بهت پاسخ بدن',
                              style: context.textTheme.bodySmall!.copyWith(
                                color: Color(0xff494949),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(20),
                                  vertical: ScreenUtil().setWidth(15)
                              ),
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(15)
                              ),
                              decoration: BoxDecoration(
                                  color: Color(0xffF9F9F9),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                      bottomLeft: Radius.circular(12)
                                  )
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                      textSelectionTheme: TextSelectionThemeData(
                                          selectionColor: Color(0xffaaaaaa),
                                          cursorColor: ColorPallet().mainColor
                                      ),
                                    ),
                                    child:  TextFormField(
                                      autofocus: false,
                                      focusNode: focusNode,
                                      onChanged: (value){
                                        widget.supportPresenter!.onChangeTextField(value,context);
                                      },
                                      style:  context.textTheme.bodyMedium,
                                      maxLength: 300,
                                      maxLines: 4,
                                      decoration:  InputDecoration(
                                        isDense: true,
                                        counterText: '',
                                        border: InputBorder.none,
                                        hintText: 'مشکلت رو اینجا مطرح کن',
                                        hintStyle:  context.textTheme.bodyMedium!.copyWith(
                                          color: ColorPallet().gray,
                                        ),
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: ScreenUtil().setHeight(20)),
                                  StreamBuilder(
                                    stream: widget.supportPresenter!.uploadFilesObserve,
                                    builder: (context,AsyncSnapshot<List<UploadFileModel>>snapshotUploadFiles){
                                      if(snapshotUploadFiles.data != null){
                                        if(snapshotUploadFiles.data!.length == 0){
                                          return Padding(
                                            padding:  EdgeInsets.only(
                                                left: ScreenUtil().setWidth(50)
                                            ),
                                            child: CustomButton(
                                              onPress: (){
                                                AnalyticsHelper().log(AnalyticsEvents.SendSupportPg_FileUpload_Btn_Clk);
                                                widget.supportPresenter!.openSlidingPanel();
                                                setState(() {
                                                  modePress = 0;
                                                });
                                              },
                                              height: ScreenUtil().setWidth(80),
                                              // height: ScreenUtil().setWidth(200),
                                              margin: 0,
                                              colors: [Colors.transparent,Colors.transparent],
                                              borderColor: Color(0xffCBCBCB),
                                              child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/images/add_photo.svg',
                                                      width: ScreenUtil().setWidth(45),
                                                      height: ScreenUtil().setWidth(45),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Text(
                                                      'از اینجا می‌تونی عکس یا فایل اضافه کنی',
                                                      textAlign: TextAlign.center,
                                                      style:  context.textTheme.labelMedium!.copyWith(
                                                        color: ColorPallet().mainColor,
                                                      ),
                                                    ),
                                                  ]
                                              ),
                                              borderRadius: 24.0,
                                              enableButton: true,
                                            ),
                                          );
                                        }else{
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            padding: EdgeInsets.only(
                                              bottom: ScreenUtil().setWidth(20),
                                            ),
                                            itemCount: snapshotUploadFiles.data!.length,
                                            itemBuilder: (context,index){
                                              return   snapshotUploadFiles.data![index].type == 0 ?
                                              Stack(
                                                alignment: Alignment.bottomRight,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(16),
                                                    child: Image.file(
                                                      File(snapshotUploadFiles.data![index].fileName.path),
                                                      fit: BoxFit.fitHeight,
                                                      height: ScreenUtil().setWidth(600),
                                                      // width: MediaQuery.of(context).size.width,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:  EdgeInsets.only(
                                                        left: MediaQuery.of(context).size.width/2 - ScreenUtil().setWidth(30),
                                                        right: ScreenUtil().setWidth(30),
                                                        bottom: ScreenUtil().setWidth(15)
                                                    ),
                                                    child: CustomButton(
                                                      onPress: (){
                                                        AnalyticsHelper().log(AnalyticsEvents.SendSupportPg_DeleteFile_Btn_Clk);
                                                        widget.supportPresenter!.cancelUpload(snapshotUploadFiles.data![index].fileName.path,snapshotUploadFiles.data![index].fileNameForSend);
                                                      },
                                                      height: ScreenUtil().setWidth(70),
                                                      // height: ScreenUtil().setWidth(200),
                                                      margin: 0,
                                                      colors: [Color(0xfff9f9f9),Color(0xfff9f9f9)],
                                                      borderColor: Color(0xffCBCBCB),
                                                      child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            SvgPicture.asset(
                                                              'assets/images/ic_delete.svg',
                                                              width: ScreenUtil().setWidth(35),
                                                              height: ScreenUtil().setWidth(35),
                                                              fit: BoxFit.cover,
                                                              colorFilter: ColorFilter.mode(
                                                                ColorPallet().mainColor,
                                                                BlendMode.srcIn
                                                              ),
                                                            ),
                                                            SizedBox(width: ScreenUtil().setWidth(5)),
                                                            Text(
                                                              'پاک کردن عکس',
                                                              textAlign: TextAlign.center,
                                                              style:  context.textTheme.labelSmall!.copyWith(
                                                                color: ColorPallet().mainColor,
                                                              ),
                                                            ),
                                                          ]
                                                      ),
                                                      borderRadius: 24.0,
                                                      enableButton: true,
                                                    ),
                                                  ),
                                                ],
                                              )
                                                  :
                                              Container(
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
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Flexible(
                                                        child: GestureDetector(
                                                          onTap: (){
                                                            widget.supportPresenter!.cancelUpload(snapshotUploadFiles.data![index].fileName.path,snapshotUploadFiles.data![index].fileNameForSend);
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
                                                      flex: 2,
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
                                                                    stream: widget.supportPresenter!.sendValuePercentUploadFileObserve,
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
                                                      child: Container(
                                                        height: ScreenUtil().setWidth(100),
                                                        width:  ScreenUtil().setWidth(100),
                                                        margin: EdgeInsets.only(
                                                            right: ScreenUtil().setWidth(20)
                                                        ),
                                                        child:  SvgPicture.asset(
                                                          'assets/images/ic_pdf.svg',
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      }else{
                                        return Container();
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      // Spacer(),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width/2,
                      left: ScreenUtil().setWidth(30),
                      bottom: ScreenUtil().setWidth(30),
                    ),
                    child: StreamBuilder(
                      stream: widget.supportPresenter!.textSendObserve,
                      builder: (context,AsyncSnapshot<String>snapshotTextSend){
                        if(snapshotTextSend.data != null){
                          return StreamBuilder(
                            stream: widget.supportPresenter!.isLoadingButtonObserve,
                            builder: (context,AsyncSnapshot<bool>snapshotIsLoadingButton){
                              if(snapshotIsLoadingButton.data != null){
                                return CustomButton(
                                  title: 'ارسال',
                                  onPress: (){
                                    if(snapshotTextSend.data!.length >= 5){
                                      AnalyticsHelper().log(AnalyticsEvents.SendSupportPg_Send_Btn_Clk);
                                      widget.supportPresenter!.sendSupport(context,widget.supportPresenter!);
                                    }
                                  },
                                  height: ScreenUtil().setWidth(80),
                                  // height: ScreenUtil().setWidth(200),
                                  margin: 0,
                                  colors: [ColorPallet().mainColor,ColorPallet().mainColor],
                                  borderRadius: 32.0,
                                  isLoadingButton: snapshotIsLoadingButton.data,
                                  enableButton: snapshotTextSend.data!.length >=5 ? true : false,
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
                  ),
                ),
                SlidingUpPanel(
                    controller: widget.supportPresenter!.panelController,
                    backdropEnabled: true,
                    minHeight: 0,
                    backdropColor: Colors.black,
                    padding: EdgeInsets.zero,
                    maxHeight: MediaQuery.of(context).size.height / 5,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)
                    ),
                    panel:  attachPanel()
                ),
              ],
            )
        ),
      ),
    );
  }

  Widget attachPanel(){
    return  Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setWidth(30),
          left: ScreenUtil().setWidth(50),
          right: ScreenUtil().setWidth(50)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: itemAttach(
                      'assets/images/ic_camera.svg',
                      'دوربین',
                          (){
                        ///AnalyticsHelper().log(AnalyticsEvents.AddMemoryPg_CameraUploadImage_Btn_Clk);
                        widget.supportPresenter!.closeSlidingPanel();
                        widget.supportPresenter!.getFileImage(1,context);
                      }
                  ),
                ),
                SizedBox(width: ScreenUtil().setWidth(80)),
                Flexible(
                  child: itemAttach(
                      'assets/images/ic_gallery.svg',
                      'گالری',
                          (){
                        ///AnalyticsHelper().log(AnalyticsEvents.AddMemoryPg_GalleryUploadImage_Btn_Clk);
                        widget.supportPresenter!.closeSlidingPanel();
                        widget.supportPresenter!.getFileImage(0,context);
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
                  widget.supportPresenter!.closeSlidingPanel();
                  widget.supportPresenter!.getFileImage(2,context);
                }
            ),
          )
        ],
      ),
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

}
