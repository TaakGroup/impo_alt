
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/memory_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/expert_button.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/expert/upload_file_model.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../../firebase_analytics_helper.dart';

class AddMemoryScreen extends StatefulWidget{
  final MemoryPresenter? memoryPresenter;

  AddMemoryScreen({this.memoryPresenter});

  @override
  State<StatefulWidget> createState() => AddMemoryScreenState();
}


class AddMemoryScreenState extends State<AddMemoryScreen> with TickerProviderStateMixin{

  Animations _animations =  Animations();
  late AnimationController animationControllerScaleButtons;
  int modePress=0;
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();

  String title = '';
  String des = '';

  @override
  void initState() {
    animationControllerScaleButtons = _animations.pressButton(this);
    widget.memoryPresenter!.initPanelController();
    super.initState();
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.AddMemoryPg_Back_NavBar_Clk);
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
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child:  ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        CustomAppBar(
                          messages: false,
                          profileTab: true,
                          icon: 'assets/images/ic_arrow_back.svg',
                          titleProfileTab: 'صفحه قبل',
                          subTitleProfileTab: 'ثبت خاطره',
                          onPressBack: (){
                            AnalyticsHelper().log(AnalyticsEvents.AddMemoryPg_Back_Btn_Clk);
                            Navigator.pop(context);
                          },
                        ),
                        Align(
                          alignment: Alignment.center,
                          child:  Padding(
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setWidth(40),
                                bottom: ScreenUtil().setWidth(20)
                            ),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(360),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/images/ic_big_memory.svg',
                                    width: ScreenUtil().setWidth(140),
                                    height: ScreenUtil().setWidth(140),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: ScreenUtil().setWidth(20),
                                  ),
                                  child: Text(
                                    'ایجاد خاطره جدید',
                                    style: context.textTheme.titleMedium!.copyWith(
                                      color: ColorPallet().mainColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'امروز',
                              style: context.textTheme.bodyLarge!.copyWith(
                                color: ColorPallet().gray,
                              ),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(20)),
                            FutureBuilder(
                              future: widget.memoryPresenter!.getToday(),
                              builder: (context,AsyncSnapshot<String>snapshotToday){
                                if(snapshotToday.data != null){
                                  return Text(
                                    snapshotToday.data!,
                                    style:context.textTheme.bodyLarge!.copyWith(
                                      color: ColorPallet().mainColor,
                                    ),
                                  );
                                }else{
                                  return Container();
                                }
                              },
                            )
                          ],
                        ),
                        StreamBuilder(
                          stream: widget.memoryPresenter!.uploadFilesObserve,
                          builder: (context,AsyncSnapshot<List<UploadFileModel>>snapshotUploadFiles){
                            if(snapshotUploadFiles.data != null){
                              if(snapshotUploadFiles.data!.length == 0){
                                return Padding(
                                    padding: EdgeInsets.only(
                                      top: ScreenUtil().setWidth(30),
                                      right: ScreenUtil().setWidth(50),
                                      left: ScreenUtil().setWidth(50),
                                    ),
                                    child: DottedBorder(
                                      padding: EdgeInsets.only(
                                        top: ScreenUtil().setWidth(40),
                                        bottom: ScreenUtil().setWidth(40),
                                        // right: ScreenUtil().setWidth(30),
                                        // left: ScreenUtil().setWidth(30),
                                      ),
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(10),
                                      dashPattern: [5,6],
                                      color: ColorPallet().gray.withOpacity(0.5),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'می‌تونی برای خاطره خودت یک عکس آپلود کنی',
                                              style: context.textTheme.bodySmall!.copyWith(
                                                  color: ColorPallet().gray.withOpacity(0.6)
                                              ),
                                            ),
                                            StreamBuilder(
                                              stream: _animations.squareScaleBackButtonObserve,
                                              builder: (context,AsyncSnapshot<double>snapshotScaleYes){
                                                if(snapshotScaleYes.data != null){
                                                  return  Transform.scale(
                                                    scale: modePress == 0 ? snapshotScaleYes.data : 1.0,
                                                    child:  GestureDetector(
                                                      onTap: ()async{
                                                        AnalyticsHelper().log(AnalyticsEvents.AddMemoryPg_UploadImage_Btn_Clk);
                                                        setState(() {
                                                          modePress=0;
                                                        });
                                                        await animationControllerScaleButtons.reverse();
                                                        widget.memoryPresenter!.openSlidingPanel();
                                                      },
                                                      child:  Container(
                                                          padding: EdgeInsets.symmetric(
                                                            vertical: ScreenUtil().setWidth(15),
                                                          ),
                                                          width: MediaQuery.of(context).size.width/2.9,
                                                          margin: EdgeInsets.only(
                                                              top: ScreenUtil().setWidth(30)
                                                          ),
                                                          decoration:  BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(15),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Color(0xff989898).withOpacity(0.2),
                                                                    blurRadius: 7.0
                                                                )
                                                              ]
                                                          ),
                                                          child:  Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: <Widget>[
                                                              SvgPicture.asset(
                                                                'assets/images/ic_attach.svg',
                                                                width: ScreenUtil().setWidth(45),
                                                                height: ScreenUtil().setWidth(45),
                                                                colorFilter: ColorFilter.mode(
                                                                    ColorPallet().mainColor,
                                                                    BlendMode.srcIn
                                                                ),
                                                                // color: ColorPallet().mainColor,
                                                                // fit: BoxFit.cover,
                                                              ),
                                                              SizedBox(width: ScreenUtil().setWidth(15)),
                                                              Text(
                                                                'آپلود عکس',
                                                                style:  context.textTheme.labelLarge!.copyWith(
                                                                  color: ColorPallet().gray,
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                      ),
                                                    ),
                                                  );
                                                }else{
                                                  return  Container();
                                                }
                                              },
                                            ),
                                            // Align(
                                            //   alignment: Alignment.center,
                                            //   child:  Padding(
                                            //     padding: EdgeInsets.only(
                                            //         top: ScreenUtil().setWidth(15)
                                            //     ),
                                            //     child: AnimatedBuilder(
                                            //         animation: _animations.animationShakeError,
                                            //         builder: (buildContext, child) {
                                            //           if (_animations.animationShakeError.value < 0.0) print('${_animations.animationShakeError.value + 8.0}');
                                            //           return  StreamBuilder(
                                            //             stream: _animations.isShowErrorObserve,
                                            //             builder: (context,AsyncSnapshot<bool> snapshot){
                                            //               if(snapshot.data != null){
                                            //                 if(snapshot.data!){
                                            //                   return  StreamBuilder(
                                            //                       stream: _animations.errorTextObserve,
                                            //                       builder: (context,AsyncSnapshot<String>snapshot){
                                            //                         return Container(
                                            //                             margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(65)),
                                            //                             padding: EdgeInsets.only(left: _animations.animationShakeError.value + 4.0, right: 4.0 -_animations.animationShakeError.value),
                                            //                             child: Text(
                                            //                               snapshot.data != null ? snapshot.data! : '',
                                            //                               style:  TextStyle(
                                            //                                   color: Color(0xffEE5858),
                                            //                                   fontSize: ScreenUtil().setWidth(26),
                                            //                                   fontWeight: FontWeight.w400
                                            //                               ),
                                            //                             )
                                            //                         );
                                            //                       }
                                            //                   );
                                            //                 }else {
                                            //                   return  Opacity(
                                            //                     opacity: 0.0,
                                            //                     child:  Container(
                                            //                       child:  Text(''),
                                            //                     ),
                                            //                   );
                                            //                 }
                                            //               }else{
                                            //                 return  Opacity(
                                            //                   opacity: 0.0,
                                            //                   child:  Container(
                                            //                     child:  Text(''),
                                            //                   ),
                                            //                 );
                                            //               }
                                            //             },
                                            //           );
                                            //         }),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      )
                                    )
                                );
                              }else{
                                return  ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(
                                    bottom: ScreenUtil().setWidth(20),
                                    top: ScreenUtil().setWidth(40),
                                  ),
                                  itemCount: snapshotUploadFiles.data!.length,
                                  itemBuilder: (context,index){
                                    return  Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: ScreenUtil().setWidth(60)
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
                                          GestureDetector(
                                            onTap: (){
                                              widget.memoryPresenter!.cancelUpload(snapshotUploadFiles.data![index].fileName.path,snapshotUploadFiles.data![index].fileNameForSend);
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
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child:  Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: <Widget>[
                                                Text(
                                                  snapshotUploadFiles.data![index].fileNameForSend,
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
                                                          stream: widget.memoryPresenter!.sendValuePercentUploadFileObserve,
                                                          builder: (context,AsyncSnapshot<double>snapshotPercentUpload){
                                                            if(snapshotPercentUpload.data != null){
                                                              return  LinearPercentIndicator(
                                                                padding: EdgeInsets.zero,
                                                                // width: MediaQuery.of(context).size.width / 2.5,
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
                                );
                              }
                            }else{
                              return Container();
                            }
                          },
                        ),
                        Container(
                            height: ScreenUtil().setWidth(90),
                            margin: EdgeInsets.only(
                              top: ScreenUtil().setWidth(40),
                              right: ScreenUtil().setWidth(60),
                              left: ScreenUtil().setWidth(60),
                            ),
                            decoration:  BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color:  ColorPallet().gray.withOpacity(0.2),
                                ),
                                boxShadow:  [
                                  BoxShadow(
                                      color: Color(0xff989898).withOpacity(0.15),
                                      blurRadius: 5.0
                                  )
                                ]

                            ),
                            child:  Center(
                                child:  Theme(
                                  data: Theme.of(context).copyWith(
                                    textSelectionTheme: TextSelectionThemeData(
                                        selectionColor: Color(0xffaaaaaa),
                                        cursorColor: ColorPallet().mainColor
                                    ),
                                  ),
                                  child:  TextField(
                                    autofocus: false,
                                    maxLength: 50,
                                    onChanged: (value){
                                      if(this.mounted){
                                        setState(() {
                                          title = value;
                                        });
                                      }
                                    },
                                    style: context.textTheme.bodyMedium,
                                    controller: titleController,
                                    decoration:  InputDecoration(
                                      counterText: '',
                                      border: InputBorder.none,
                                      hintText: 'اسم خاطره‌ت رو اینجا بنویس',
                                      hintStyle:  context.textTheme.bodyMedium!.copyWith(
                                        color: ColorPallet().gray.withOpacity(0.5),
                                      ),
                                      contentPadding:  EdgeInsets.only(
                                        right: ScreenUtil().setWidth(20),
                                        left: ScreenUtil().setWidth(10),
                                      ),
                                    ),
                                  ),
                                )
                            )
                        ),
                        Container(
                            margin: EdgeInsets.only(
                              top: ScreenUtil().setWidth(40),
                              right: ScreenUtil().setWidth(60),
                              left: ScreenUtil().setWidth(60),
                            ),
                            height: ScreenUtil().setWidth(200),
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setWidth(10),
                                bottom: ScreenUtil().setWidth(10)
                            ),
                            decoration:  BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color:  ColorPallet().gray.withOpacity(0.2),
                                ),
                                boxShadow:  [
                                  BoxShadow(
                                      color: Color(0xff989898).withOpacity(0.15),
                                      blurRadius: 5.0
                                  )
                                ]
                            ),
                            child:  Center(
                                child:  Theme(
                                  data: Theme.of(context).copyWith(
                                    textSelectionTheme: TextSelectionThemeData(
                                        selectionColor: Color(0xffaaaaaa),
                                        cursorColor: ColorPallet().mainColor
                                    ),
                                  ),
                                  child:  TextField(
                                    controller: subtitleController,
                                    maxLines: 5,
                                    maxLength: 3000,
                                    onChanged: (value){
                                      if(this.mounted){
                                        setState(() {
                                          des = value;
                                        });
                                      }
                                    },
                                    style:  context.textTheme.bodyMedium,
                                    decoration:  InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'متن خاطره‌ت رو اینجا بنویس',
                                        counterText: '',
                                        hintStyle: context.textTheme.bodyMedium!.copyWith(
                                          color: ColorPallet().gray.withOpacity(0.5),
                                        ),
                                        contentPadding:  EdgeInsets.only(
                                          right: ScreenUtil().setWidth(10),
                                          left: ScreenUtil().setWidth(15),
                                          bottom: ScreenUtil().setWidth(35),
                                        )
                                    ),
                                  ),
                                )
                            )
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setWidth(30),
                        bottom: ScreenUtil().setWidth(20)
                    ),
                    child: StreamBuilder(
                      stream: widget.memoryPresenter!.isLoadingButtonObserve,
                      builder: (context,snapshotIsLoadingButton){
                        if(snapshotIsLoadingButton.data != null){
                          return StreamBuilder(
                            stream: widget.memoryPresenter!.uploadFilesObserve,
                            builder: (context,AsyncSnapshot<List<UploadFileModel>>snapshotUploadFile){
                              if(snapshotUploadFile.data != null){
                                return CustomButton(
                                  title: 'ثبت خاطره',
                                  onPress: (){
                                    // if(title.length != 0 && des.length != 0){
                                    //   widget.memoryPresenter.sendMemory(title,des,context);
                                    // }
                                    if (title.length != 0 && des.length != 0) {
                                      if(snapshotUploadFile.data!.length != 0){
                                        if(snapshotUploadFile.data![0].stateUpload == 1){
                                          widget.memoryPresenter!.sendMemory(title, des, context);
                                        }
                                      }else{
                                        widget.memoryPresenter!.sendMemory(title, des, context);
                                      }
                                    }
                                  },
                                  colors: [Color(0xffFFA5FC),ColorPallet().mainColor],
                                  borderRadius: 10.0,
                                  // enableButton: title.length != 0 && des.length != 0 ?
                                  // true : false,
                                  enableButton: title.length != 0 && des.length != 0 ?
                                  snapshotUploadFile.data!.length != 0 ? snapshotUploadFile.data![0].stateUpload == 1 ? true : false : true
                                      : false,
                                  isLoadingButton: snapshotIsLoadingButton.data,
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
                  )
                ],
              ),
              SlidingUpPanel(
                  controller: widget.memoryPresenter!.panelController,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: itemAttach(
                  'assets/images/ic_camera.svg',
                  'دوربین',
                      (){
                    AnalyticsHelper().log(AnalyticsEvents.AddMemoryPg_CameraUploadImage_Btn_Clk);
                    widget.memoryPresenter!.closeSlidingPanel();
                    widget.memoryPresenter!.getFileImage(1,context,false);
                  }
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(80)),
            Flexible(
              child: itemAttach(
                  'assets/images/ic_gallery.svg',
                  'گالری',
                      (){
                    AnalyticsHelper().log(AnalyticsEvents.AddMemoryPg_GalleryUploadImage_Btn_Clk);
                    widget.memoryPresenter!.closeSlidingPanel();
                    widget.memoryPresenter!.getFileImage(0,context,false);
                  }
              ),
            ),
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