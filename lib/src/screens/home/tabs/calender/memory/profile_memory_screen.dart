import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/memory_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/dialogs/qus_dialog.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/models/memory/memort_get_model.dart';
import 'package:impo/src/screens/home/tabs/calender/memory/send_comment_screen.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../firebase_analytics_helper.dart';

class ProfileMemoryScreen extends StatefulWidget{
  final MemoryPresenter? memoryPresenter;
  final MemoryGetModel? memoryGetModel;

  ProfileMemoryScreen({this.memoryPresenter,this.memoryGetModel});

  @override
  State<StatefulWidget> createState() => ProfileMemoryScreenState();
}

class ProfileMemoryScreenState extends State<ProfileMemoryScreen> with TickerProviderStateMixin{

  Animations _animations =  Animations();
  late AnimationController animationControllerScaleButtons;

  int modePress = 0;

  @override
  void initState() {
    animationControllerScaleButtons = _animations.pressButton(this);
    widget.memoryPresenter!.initCreator(widget.memoryGetModel!);
    widget.memoryPresenter!.initialDialogScale(this);
    super.initState();
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.ProfileMemoryPg_Back_NavBar_Clk);
    return widget.memoryPresenter!.backProfileMemoryScreen();
  }


  loadImageNetwork(fileName,token){
    return fileName == null ?
    AssetImage(
      'assets/images/ic_placeholder_memory.png',
    ) : fileName == ''?
    AssetImage(
      'assets/images/ic_placeholder_memory.png',
    ) :     NetworkImage(
        '$mediaUrl/woman/$fileName',
        headers: {"Authorization": "Bearer $token"}
    ) ;
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
                      subTitleProfileTab: 'مرور خاطرات',
                      onPressBack: (){
                        AnalyticsHelper().log(AnalyticsEvents.ProfileMemoryPg_Back_Btn_Clk);
                        Navigator.pop(context);
                      },
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setWidth(20)
                        ),
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                              height: ScreenUtil().setHeight(1.5),
                              width: MediaQuery.of(context).size.width/5,
                              color: ColorPallet().gray.withOpacity(0.5),
                            ),
                            Text(
                              widget.memoryGetModel!.date,
                              style:  context.textTheme.bodyLarge!.copyWith(
                                color: ColorPallet().gray,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                              height: ScreenUtil().setHeight(1.5),
                              width: MediaQuery.of(context).size.width/5,
                              color: ColorPallet().gray.withOpacity(0.5),
                            ),
                          ],
                        )
                    ),
                    SizedBox(height: ScreenUtil().setHeight(30)),
                    Expanded(
                        child:  ListView(
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setWidth(20)
                          ),
                          children: [
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                FutureBuilder(
                                  future: widget.memoryPresenter!.getToken(),
                                  builder: (context,snapshotToken){
                                    if(snapshotToken.data != null){
                                      return Container(
                                        margin: EdgeInsets.only(
                                            top: ScreenUtil().setWidth(10)
                                        ),
                                        // height: ScreenUtil().setWidth(500),
                                        // width: MediaQuery.of(context).size.width,
                                        child: FadeInImage(
                                          // height: ScreenUtil().setWidth(280),
                                          width: MediaQuery.of(context).size.width,
                                          fit: BoxFit.fitWidth,
                                          image: widget.memoryGetModel!.localPath == null ?
                                          loadImageNetwork( widget.memoryGetModel!.fileName,snapshotToken.data)
                                              :  widget.memoryGetModel!.localPath == '' ?
                                          loadImageNetwork( widget.memoryGetModel!.fileName,snapshotToken.data)
                                              : FileImage(
                                            File( widget.memoryGetModel!.localPath!),
                                          ),
                                          placeholder: AssetImage(
                                            'assets/images/ic_placeholder_memory.png',
                                          ),
                                        ),
                                      );
                                    }else{
                                      return Container();
                                    }
                                  },
                                ),
                                // Center(
                                //   child:    ClipRRect(
                                //       borderRadius: BorderRadius.only(
                                //         topRight: Radius.circular(20),
                                //         topLeft:  Radius.circular(20),
                                //       ),
                                //       child:   BackdropFilter(
                                //           filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                //           child:   Container(
                                //             padding: EdgeInsets.only(
                                //               right: ScreenUtil().setWidth(60),
                                //               left: ScreenUtil().setWidth(60),
                                //               top:  ScreenUtil().setWidth(10),
                                //             ),
                                //             decoration: BoxDecoration(
                                //               gradient:  LinearGradient(
                                //                   colors: [
                                //                     Colors.white,
                                //                     Colors.white.withOpacity(0.7),
                                //                     Colors.white.withOpacity(0.5),
                                //                     Colors.white.withOpacity(0.3),
                                //                     Colors.white.withOpacity(0.1),
                                //                   ],
                                //                   begin: Alignment.bottomCenter,
                                //                   end: AlignmentDirectional.topCenter
                                //               ),
                                //               borderRadius: BorderRadius.only(
                                //                 topRight: Radius.circular(20),
                                //                 topLeft:  Radius.circular(20),
                                //               ),
                                //             ),
                                //             child:  Padding(
                                //               padding: EdgeInsets.only(
                                //                   top: ScreenUtil().setWidth(10)
                                //               ),
                                //               child: Row(
                                //                 crossAxisAlignment: CrossAxisAlignment.center,
                                //                 children: [
                                //                   Container(
                                //                     width: ScreenUtil().setWidth(17),
                                //                     height: ScreenUtil().setWidth(17),
                                //                     decoration: BoxDecoration(
                                //                         gradient: LinearGradient(
                                //                             colors: [ColorPallet().mentalMain,ColorPallet().mentalHigh]
                                //                         ),
                                //                         shape: BoxShape.circle
                                //                     ),
                                //                   ),
                                //                   SizedBox(width: ScreenUtil().setWidth(20),),
                                //                   Text(
                                //                     widget.memoryGetModel.title,
                                //                     style: TextStyle(
                                //                         color: ColorPallet().black,
                                //                         fontSize: ScreenUtil().setSp(38),
                                //                         fontWeight: FontWeight.w700
                                //                     ),
                                //                   )
                                //                 ],
                                //               ),
                                //             ),
                                //             // color: Colors.white.withAlpha(200),
                                //           )
                                //       )
                                //   ),
                                // )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: ScreenUtil().setWidth(60),
                                  top: ScreenUtil().setWidth(10)
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: ScreenUtil().setWidth(17),
                                    height: ScreenUtil().setWidth(17),
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setWidth(20)
                                    ),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [ColorPallet().mentalMain,ColorPallet().mentalHigh]
                                        ),
                                        shape: BoxShape.circle
                                    ),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(20),),
                                  Flexible(
                                    child: Text(
                                      widget.memoryGetModel!.title,
                                      style: context.textTheme.titleSmall,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    right: ScreenUtil().setWidth(60),
                                    bottom: ScreenUtil().setHeight(40),
                                    top: ScreenUtil().setWidth(10)
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'ایجاد شده توسط: ',
                                      style: context.textTheme.labelMediumProminent!.copyWith(
                                        color: ColorPallet().gray,
                                      ),
                                    ),
                                    StreamBuilder(
                                      stream: widget.memoryPresenter!.creatorObserve,
                                      builder: (context,AsyncSnapshot<String>snapshotCreator){
                                        if(snapshotCreator.data != null){
                                          return Text(
                                            snapshotCreator.data!,
                                            style: context.textTheme.labelMediumProminent!.copyWith(
                                              color : snapshotCreator.data == 'شما' ? ColorPallet().mainColor
                                                  : Color(0xff565AA7),
                                            ),
                                          );
                                        }else{
                                          return Container();
                                        }
                                      },
                                    )
                                  ],
                                )
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  right: ScreenUtil().setWidth(60),
                                  left: ScreenUtil().setWidth(60),
                                  bottom: ScreenUtil().setWidth(50)
                              ),
                              child:  Text(
                                widget.memoryGetModel!.text,
                                textAlign: TextAlign.justify,
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: ColorPallet().gray,
                                ),
                              ),
                            ),
                            widget.memoryGetModel!.validPartner ?
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setWidth(20),
                                  horizontal: ScreenUtil().setWidth(25)
                              ),
                              margin: EdgeInsets.only(
                                right: ScreenUtil().setWidth(60),
                                left: ScreenUtil().setWidth(60),
                                bottom: ScreenUtil().setWidth(40),
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: widget.memoryGetModel!.fromMan ? ColorPallet().mainColor :Color(0xff565AA7),
                                    width: ScreenUtil().setHeight(2),
                                  ),
                                  color: widget.memoryGetModel!.fromMan ? Color(0xffFFA5FC).withOpacity(0.3):
                                  Color(0xffBFCAFF).withOpacity(0.3),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      topRight: Radius.circular(7)
                                  )
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(ScreenUtil().setWidth(12)),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/images/ic_profile_partner.svg',
                                          width: ScreenUtil().setWidth(45),
                                          height: ScreenUtil().setWidth(45),
                                          colorFilter: ColorFilter.mode(
                                            widget.memoryGetModel!.fromMan ? ColorPallet().mainColor :Color(0xff565AA7),
                                            BlendMode.srcIn
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: ScreenUtil().setWidth(20)),
                                      Text(
                                        'نظر ${widget.memoryGetModel!.fromMan ? 'شما' : '${widget.memoryPresenter!.getPartnerName()}'}',
                                        style: context.textTheme.labelMediumProminent,
                                      )
                                    ],
                                  ),
                                  SizedBox(height: ScreenUtil().setHeight(15)),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: ScreenUtil().setWidth(7)
                                    ),
                                    child: Text(
                                      widget.memoryGetModel!.textPartner,
                                      style: context.textTheme.bodySmall,
                                    ),
                                  )
                                ],
                              ),
                            )
                                : Container(),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: widget.memoryGetModel!.validPartner ? ScreenUtil().setWidth(20) : ScreenUtil().setWidth(50),
                                    bottom: ScreenUtil().setWidth(50)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    !widget.memoryGetModel!.validPartner && widget.memoryGetModel!.fromMan ?
                                    StreamBuilder(
                                      stream: _animations.squareScaleBackButtonObserve,
                                      builder: (context,AsyncSnapshot<double>snapshotScale){
                                        if(snapshotScale.data != null){
                                          return Transform.scale(
                                            scale: modePress == 1 ? snapshotScale.data : 1.0,
                                            child: GestureDetector(
                                                onTap: ()async{
                                                  AnalyticsHelper().log(AnalyticsEvents.ProfileMemoryPg_whatdoyouthink_Btn_Clk);
                                                  if(this.mounted){
                                                    setState(() {
                                                      modePress = 1;
                                                    });
                                                  }
                                                  await animationControllerScaleButtons.reverse();
                                                  Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          child: SendCommentScreen(
                                                            id: widget.memoryGetModel!.id,
                                                            memoryPresenter: widget.memoryPresenter!,
                                                          ),
                                                          type: PageTransitionType.fade
                                                      )
                                                  );
                                                },
                                                child:  Container(
                                                    height: ScreenUtil().setWidth(70),
                                                    // width: ScreenUtil().setWidth(240),
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: ScreenUtil().setWidth(50)
                                                    ),
                                                    decoration:  BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        gradient:  LinearGradient(
                                                            colors: [
                                                              ColorPallet().mainColor,
                                                              Color(0xffFFA5FC),
                                                            ],
                                                            begin: Alignment.centerRight,
                                                            end: Alignment.centerLeft
                                                        )
                                                    ),
                                                    child:   Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: <Widget>[
                                                        Container(
                                                            height: ScreenUtil().setWidth(35),
                                                            width: ScreenUtil().setWidth(35),
                                                            child: SvgPicture.asset(
                                                              'assets/images/event_note.svg',
                                                              fit: BoxFit.cover,
                                                            )
                                                        ),
                                                        SizedBox(width: ScreenUtil().setWidth(15)),
                                                        Text(
                                                          'نظرت چیه؟',
                                                          style:  context.textTheme.labelMediumProminent!.copyWith(
                                                            color: Colors.white,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                )
                                            ),
                                          );
                                        }else{
                                          return Container();
                                        }
                                      },
                                    )
                                        : Container(),
                                    !widget.memoryGetModel!.validPartner && widget.memoryGetModel!.fromMan ?
                                    SizedBox(width: ScreenUtil().setWidth(30)) : Container(),
                                    StreamBuilder(
                                      stream: _animations.squareScaleBackButtonObserve,
                                      builder: (context,AsyncSnapshot<double>snapshotScale){
                                        if(snapshotScale.data != null){
                                          return Transform.scale(
                                            scale: modePress == 0 ? snapshotScale.data : 1.0,
                                            child: GestureDetector(
                                              onTap: ()async{
                                                AnalyticsHelper().log(AnalyticsEvents.ProfileMemoryPg_RemoveMemory_Btn_Clk);
                                                if(this.mounted){
                                                  setState(() {
                                                    modePress = 0;
                                                  });
                                                }
                                                await animationControllerScaleButtons.reverse();
                                                widget.memoryPresenter!.showDeleteMemoryDialog();
                                              },
                                              child:  Container(
                                                  height: ScreenUtil().setWidth(70),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: ScreenUtil().setWidth(50)
                                                  ),
                                                  decoration:  BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(
                                                          color: ColorPallet().gray.withOpacity(0.2)
                                                      )
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                        'حذف خاطره',
                                                        style:  context.textTheme.labelMedium!.copyWith(
                                                          color: ColorPallet().gray,
                                                        ),
                                                      )
                                                  )
                                              ),
                                            ),
                                          );
                                        }else{
                                          return Container();
                                        }
                                      },
                                    )
                                  ],
                                )
                            )
                          ],
                        )
                    )
                  ],
                ),
                StreamBuilder(
                  stream: widget.memoryPresenter!.isShowDialogObserve,
                  builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog){
                    if(snapshotIsShowDialog.data != null){
                      if(snapshotIsShowDialog.data!){
                        return  StreamBuilder(
                          stream: widget.memoryPresenter!.isLoadingButtonObserve,
                          builder: (context,snapshotIsLoadingButton){
                            if(snapshotIsLoadingButton.data != null){
                              return QusDialog(
                                scaleAnim: widget.memoryPresenter!.dialogScaleObserve,
                                onPressCancel: (){
                                  AnalyticsHelper().log(AnalyticsEvents.ProfileMemoryPg_RemoveMemoryNoDlg_Btn_Clk);
                                  widget.memoryPresenter!.cancelDeleteMemoryDialog();
                                },
                                value: "می‌خوای این خاطره رو حذف کنی؟",
                                yesText: 'آره!',
                                noText: 'نه',
                                onPressYes: (){
                                  AnalyticsHelper().log(AnalyticsEvents.ProfileMemoryPg_RemoveMemoryYesDlg_Btn_Clk);
                                  widget.memoryPresenter!.deleteMemory(widget.memoryGetModel!.id, context);
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

}