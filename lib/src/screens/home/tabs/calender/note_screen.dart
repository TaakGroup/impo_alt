import 'dart:async';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/calender_presenter.dart';
import 'package:impo/src/components/action_manage_overlay.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/dialogs/qus_dialog.dart';
import 'package:get/get.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:impo/src/core/app/view/widgets/snackbar/custom_snack_bar.dart';
import '../../../../firebase_analytics_helper.dart';

class NoteScreen extends StatefulWidget {
  final CalenderPresenter? calenderPresenter;
  final mode;
  final isTwoBack;
  final isOfflineMode;

  NoteScreen({Key? key,
    this.calenderPresenter,
    this.mode,
    this.isTwoBack,
    this.isOfflineMode,
  })
      : super(key: key);

  @override
  State<StatefulWidget> createState() => NoteScreenState();
}

class NoteScreenState extends State<NoteScreen> with TickerProviderStateMixin {
  late TextEditingController titleController;
  late TextEditingController subtitleController;
  Animations _animations =  Animations();
  DateTime now = DateTime.now();
  TimeOfDay time = TimeOfDay.fromDateTime(DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      12, 00));
  bool _value = false;
  late AnimationController animationControllerScaleButtons;
  int modePress = 0;
  int modePanel = 0;
  late ScrollController scrollController;
  bool isKeyBoard = false;

  Future<bool> onWillPop() async {
    AnalyticsHelper().log(AnalyticsEvents.NotePg_Back_NavBar_Clk);
    Navigator.pop(context);
    return Future.value(false);
  }


  @override
  void dispose() {
    animationControllerScaleButtons.dispose();
    super.dispose();
  }

  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.NotePg_Self_Pg_Load);
    titleController =  TextEditingController();
    subtitleController =  TextEditingController();
    scrollController = ScrollController();
    widget.calenderPresenter!.initialDialogScale(this);
    _animations.shakeError(this);
    checkVisibilityKeyBoard();
    widget.calenderPresenter!.initPanelController();
    animationControllerScaleButtons = _animations.pressButton(this);
    widget.calenderPresenter!.checkIsAlarm();
    if (widget.mode == 1 || widget.mode == 2) setDefaultValuesForEdit();
    super.initState();
  }


  checkVisibilityKeyBoard(){
    KeyboardVisibilityController().onChange.listen((bool visible) {
      if(mounted){
        if(visible){
          setState(() {
            isKeyBoard = true;
          });
          Timer(Duration(milliseconds: 50),(){
            scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500),curve: Curves.ease);
          });
        }else{
          setState(() {
            isKeyBoard = false;
          });
        }
      }
    });
  }


  setDefaultValuesForEdit() async {
    titleController =  TextEditingController(
        text: widget.calenderPresenter!.selectedAlarm.text);
    subtitleController =  TextEditingController(
        text: widget.calenderPresenter!.selectedAlarm.description);
    widget.calenderPresenter!.initFiles();
    if (widget.calenderPresenter!.selectedAlarm.isActive == 1) {
      setState(() {
        _value = true;
      });
    } else {
      setState(() {
        _value = false;
      });
    }

    time = TimeOfDay.fromDateTime(DateTime(
        DateTime
            .now()
            .year,
        DateTime
            .now()
            .month,
        DateTime
            .now()
            .day,
        widget.calenderPresenter!.selectedAlarm.hour,
        widget.calenderPresenter!.selectedAlarm.minute));
  }

  Future<bool> checkCanDrawOverlays() async {
    if (Platform.isIOS) {
      return true;
    } else {
      return await ActionManageOverlay.canDrawOverlays;
    }
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    // timeDilation = .5;
    return  WillPopScope(
      onWillPop: onWillPop,
      child:  Directionality(
        textDirection: TextDirection.rtl,
        child:  Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body:  Stack(
              children: [
                SingleChildScrollView(
                  controller: scrollController,
                  child:  Column(
                    children: [
                      CustomAppBar(
                        messages: false,
                        profileTab: true,
                        isEmptyLeftIcon: widget.isOfflineMode ? true : null,
                        icon: 'assets/images/ic_arrow_back.svg',
                        titleProfileTab: 'صفحه قبل',
                        subTitleProfileTab: 'ثبت یادداشت',
                        onPressBack: (){
                          AnalyticsHelper().log(AnalyticsEvents.NotePg_Back_Btn_Clk);
                          Navigator.pop(context);
                        },
                      ),
                      // widget.isPartner ?
                      // Padding(
                      //     padding: EdgeInsets.only(
                      //         top: ScreenUtil().setWidth(50)
                      //     ),
                      //     child:    Column(
                      //       children: [
                      //         Image.asset(
                      //             'assets/images/ic_note_hamdel.png'
                      //         ),
                      //         SizedBox(height:ScreenUtil().setHeight(20)),
                      //         Text(
                      //           'پیام همدل',
                      //           style: TextStyle(
                      //               color: ColorPallet().periodDeep,
                      //               fontSize: ScreenUtil().setSp(46),
                      //               fontWeight: FontWeight.bold
                      //           ),
                      //         )
                      //       ],
                      //     )
                      // )
                      //     : Container(),
                      widget.mode == 0 ?
                      Padding(
                        padding: EdgeInsets.only(
                          top:  ScreenUtil().setWidth(70),
                          right: ScreenUtil().setWidth(50),
                          left: ScreenUtil().setWidth(50),
                        ),
                        child:   Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: ()async{
                                  setState(() {
                                    modePanel =0;
                                  });
                                  widget.calenderPresenter!.openDateTimePicker(context,widget.calenderPresenter!);
                                  // _selectDate(context);
                                },
                                child: Row(
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(24),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: ScreenUtil().setWidth(20),
                                            vertical: ScreenUtil().setWidth(15)
                                        ),
                                        decoration:  BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            // border: Border.all(
                                            //     color: ColorPallet().gray.withOpacity(0.3)
                                            // ),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color(0xff989898).withOpacity(0.2),
                                                  blurRadius: 5.0
                                              )
                                            ]
                                        ),
                                        child:  Center(
                                          child:   SvgPicture.asset(
                                            'assets/images/ic_date.svg',
                                            fit: BoxFit.cover,
                                            width: ScreenUtil().setWidth(45),
                                            height: ScreenUtil().setWidth(45),
                                          ),
                                        )
                                    ),
                                    Text(
                                      'تنظیم تاریخ',
                                      style:  context.textTheme.bodyLarge
                                    ),
                                  ],
                                )
                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  modePanel =0;
                                });
                                widget.calenderPresenter!.openDateTimePicker(context,widget.calenderPresenter!);
                                // _selectDate(context);
                              },
                              child:  Container(

                                  margin: EdgeInsets.only(
                                    right: ScreenUtil().setWidth(50),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(20),
                                      vertical: ScreenUtil().setWidth(15)
                                  ),
                                  decoration:  BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: ColorPallet().gray.withOpacity(0.3)
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xff989898).withOpacity(0.15),
                                            blurRadius: 5.0
                                        )
                                      ]
                                  ),
                                  child:  Center(
                                      child: Container(
                                          height: ScreenUtil().setWidth(45),
                                          child:  Row(
                                            children: [
                                              StreamBuilder(
                                                stream: widget.calenderPresenter!.todayDateObserve,
                                                builder: (context,AsyncSnapshot<String>snapshotToday){
                                                  if(snapshotToday.data != null){
                                                    return   Text(
                                                      snapshotToday.data!,
                                                      style: context.textTheme.bodyMedium!.copyWith(
                                                        color: ColorPallet().mainColor,
                                                      )
                                                    );
                                                  }else{
                                                    return  Container();
                                                  }
                                                },
                                              )
                                            ],
                                          )
                                      )
                                  )
                              ),
                            ),
                          ],
                        ),
                      ) :
                      StreamBuilder(
                        stream: widget.calenderPresenter!.todayTextForNoteListScreenObserve,
                        builder: (context,snapshotTodayDate){
                          if(snapshotTodayDate.data != null){
                            return  Padding(
                                padding: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(50)
                                ),
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                                      height: ScreenUtil().setHeight(1.5),
                                      width: MediaQuery.of(context).size.width/5,
                                      color: Color(0xff707070),
                                    ),
                                    Text(
                                      "${snapshotTodayDate.data}",
                                      style:  context.textTheme.bodyLarge!.copyWith(
                                        color: Color(0xff707070),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                                      height: ScreenUtil().setHeight(1.5),
                                      width: MediaQuery.of(context).size.width/5,
                                      color: Color(0xff707070),
                                    ),
                                  ],
                                )
                            );
                          }else{
                            return  Container();
                          }
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: ScreenUtil().setWidth(55),
                            left:  ScreenUtil().setWidth(55),
                            bottom: ScreenUtil().setWidth(50)
                        ),
                        child:  Column(
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child:  Container(
                                      height: ScreenUtil().setWidth(90),
                                      margin: EdgeInsets.only(
                                        top: ScreenUtil().setWidth(40),
                                      ),
                                      decoration:  BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color:  ColorPallet().gray.withOpacity(0.3),
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
                                              maxLength: 20,
                                              readOnly: widget.mode == 2 || widget.isOfflineMode ? true : false,
                                              enableInteractiveSelection: false,
                                              style: context.textTheme.bodyMedium,
                                              controller: titleController,
                                              decoration:  InputDecoration(
                                                counterText: '',
                                                border: InputBorder.none,
                                                hintText: 'عنوان یادداشت',
                                                hintStyle: context.textTheme.bodyMedium!.copyWith(
                                                  color: ColorPallet().gray.withOpacity(0.5),
                                                ),
                                                contentPadding:  EdgeInsets.only(
                                                  right: ScreenUtil().setWidth(20),
                                                  left: ScreenUtil().setWidth(10),
//                                                  bottom: ScreenUtil().setWidth(20),
//                                          top: ScreenUtil().setWidth(20),
                                                ),
                                              ),
                                            ),
                                          )
                                      )
                                  ),
                                ),
                                widget.mode ==1 && !widget.isOfflineMode ?
                                StreamBuilder(
                                  stream: _animations.squareScaleBackButtonObserve,
                                  builder: (context,AsyncSnapshot<double>snapshotScale){
                                    if(snapshotScale.data != null){
                                      return  Transform.scale(
                                        scale: modePress == 2 ? snapshotScale.data : 1.0,
                                        child:  GestureDetector(
                                            onTap: ()async{
                                              setState(() {
                                                modePress = 2;
                                              });
                                              AnalyticsHelper().log(AnalyticsEvents.NotePg_RemoveNote_Btn_Clk);
                                              await animationControllerScaleButtons.reverse();
                                              widget.calenderPresenter!.onPressShowDeleteNoteDialog();
                                            },
                                            child:  Container(
                                                margin: EdgeInsets.only(
                                                  right: ScreenUtil().setWidth(30),
                                                  top: ScreenUtil().setWidth(40),
                                                ),
                                                height: ScreenUtil().setWidth(90),
                                                width: ScreenUtil().setWidth(90),
                                                decoration:  BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(13),
                                                    border: Border.all(
                                                        color: ColorPallet().gray.withOpacity(0.3)
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Color(0xff989898).withOpacity(0.2),
                                                          blurRadius: 5.0
                                                      )
                                                    ]
                                                ),
                                                child:  Center(
                                                    child:  SvgPicture.asset(
                                                      'assets/images/ic_delete_note.svg',
                                                      width: ScreenUtil().setWidth(45),
                                                      height: ScreenUtil().setWidth(45),
                                                    )
                                                )
                                            )
                                        ),
                                      );
                                    }else{
                                      return  Container();
                                    }
                                  },
                                )
                                    :  Container()
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child:  Padding(
                                padding: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(10),
                                  bottom: ScreenUtil().setWidth(20),
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
                                                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                                                        padding: EdgeInsets.only(left: _animations.animationShakeError.value + 4.0, right: 4.0 -_animations.animationShakeError.value),
                                                        child: Text(
                                                          snapshot.data != null ? snapshot.data! : '',
                                                          style:  context.textTheme.bodySmall!.copyWith(
                                                            color: Color(0xffEE5858),
                                                          )
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
                            // !widget.isPartner ?
                            !_value && widget.isOfflineMode ?
                            Container() :
                            StreamBuilder(
                              stream: widget.calenderPresenter!.isAlarmNoteObserve,
                              builder: (context,AsyncSnapshot<bool>isAlarm){
                                if(isAlarm.data != null){
                                  if(isAlarm.data!){
                                    return  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Theme(
                                              data: Theme.of(context).copyWith(
                                                  colorScheme: ColorScheme.light(
                                                    primary: ColorPallet().mainColor,
                                                    background: Colors.green,
                                                    onBackground: Colors.black,
                                                    onPrimary: Colors.white,
                                                    secondary: Colors.amber,
                                                    onSecondary: Colors.amber,
                                                  )
                                              ),
                                              child:  Builder(
                                                builder: (context) =>  GestureDetector(
                                                  onTap: (){
                                                    _selectDate(context);
                                                  },
                                                  child:  Container(
                                                      margin: EdgeInsets.only(
                                                        left: ScreenUtil().setWidth(24),
                                                      ),
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: ScreenUtil().setWidth(20),
                                                          vertical: ScreenUtil().setWidth(15)
                                                      ),
                                                      decoration:  BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(10),
                                                          // border: Border.all(
                                                          //     color: ColorPallet().gray.withOpacity(0.3)
                                                          // ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Color(0xff989898).withOpacity(0.2),
                                                                blurRadius: 5.0
                                                            )
                                                          ]
                                                      ),
                                                      child:   Center(
                                                        child:   SvgPicture.asset(
                                                          'assets/images/ic_reminder.svg',
                                                          fit: BoxFit.cover,
                                                          width: ScreenUtil().setWidth(45),
                                                          height: ScreenUtil().setWidth(45),
                                                        ),
                                                      )
                                                  ),
                                                ),
                                              ),
                                            ),
                                            _value ?
                                            Theme(
                                              data: Theme.of(context).copyWith(
//                                            primaryColor: ColorPallet().mainColor,
//                                            backgroundColor: Colors.black,
//                                            accentColor: ColorPallet().periodLight,
                                                  colorScheme: ColorScheme.light(
                                                    primary: ColorPallet().mainColor,
                                                    background: Colors.green,
                                                    onBackground: Colors.black,
                                                    onPrimary: Colors.white,
                                                    secondary: Colors.amber,
                                                    onSecondary: Colors.amber,
                                                  )
                                              ),
                                              child:  Builder(
                                                builder: (context) =>  GestureDetector(
                                                    onTap: ()async{
                                                      _selectDate(context);
                                                    },
                                                    child:  Text(
                                                      time.format(context),
                                                      style: context.textTheme.titleSmall!.copyWith(
                                                        color: ColorPallet().mainColor,
                                                      )
                                                    )
                                                ),
                                              ),
                                            )
                                                :  Text(
                                              'تنظیم یادآور',
                                              style:  context.textTheme.bodyLarge
                                            ),
                                          ],
                                        ),
                                        !widget.isOfflineMode ?
                                        Theme(
                                          data: Theme.of(context).copyWith(
//                                            primaryColor: ColorPallet().mainColor,
//                                            backgroundColor: Colors.black,
//                                            accentColor: ColorPallet().periodLight,
                                              colorScheme: ColorScheme.light(
                                                primary: ColorPallet().mainColor,
                                                background: Colors.green,
                                                onBackground: Colors.black,
                                                onPrimary: Colors.white,
                                                secondary: Colors.amber,
                                                onSecondary: Colors.amber,
                                              )
                                          ),
                                          child:  Builder(
                                            builder: (context) =>  GestureDetector(
                                              onTap: ()async{
                                                _selectDate(context);
                                              },
                                              child: Transform.scale(
                                                  scale: .7,
                                                  child:  CupertinoSwitch(
                                                    value: _value,
                                                    trackColor: ColorPallet().gray.withOpacity(0.5),
                                                    activeColor: ColorPallet().mainColor,
                                                    onChanged: (bool value)async{
                                                      if(value){
                                                        if(!await checkCanDrawOverlays()){
                                                          widget.calenderPresenter!.showCanDrawOverlaysDialog();
                                                        }
                                                        _selectDate(context);
                                                      }
                                                      setState(() {
                                                        _value = value;
                                                      });
                                                      if(value){
                                                        AnalyticsHelper().log(AnalyticsEvents.NotePg_TurnOnTheAlarmCalendar_Switch_Clk);
                                                      }else{
                                                        AnalyticsHelper().log(AnalyticsEvents.NotePg_TurnOffTheAlarmCalendar_Switch_Clk);
                                                      }
                                                    },
                                                  )
                                              ),
                                            ),
                                          ),
                                        ) :
                                        Container()
                                      ],
                                    );
                                  }else{
                                    return Container();
                                  }
                                }else{
                                  return Container();
                                }
                              },
                            ) ,
                                // : Container(),
                            // !widget.isPartner ?
                            SizedBox(height: ScreenUtil().setHeight(40)),
                                // : Container(),
                            widget.isOfflineMode && subtitleController.text == '' ?
                            Container() :
                            DottedBorder(
                              color: widget.mode == 2 ? Colors.white : ColorPallet().gray.withOpacity(0.3),
                              radius: Radius.circular(7),
                              dashPattern: [3,5],
                              borderType: BorderType.RRect,
                              strokeWidth: 1,
                              child:   Container(
                                  height: ScreenUtil().setWidth(200),
                                  padding: EdgeInsets.only(
                                    // top: ScreenUtil().setWidth(10),
                                      bottom: ScreenUtil().setWidth(10)
                                  ),
                                  decoration:  BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: widget.mode == 2 ? ColorPallet().gray.withOpacity(0.3): Colors.white,
                                          width: ScreenUtil().setWidth(2.5)
                                      )
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
                                          maxLength: 250,
                                          readOnly: widget.mode == 2 || widget.isOfflineMode ? true : false,
                                          enableInteractiveSelection: false,
                                          style:  context.textTheme.bodyMedium,
                                          decoration:  InputDecoration(
                                              counter: widget.mode == 2 ? Text(''): null,
                                              border: InputBorder.none,
                                              hintText: widget.mode == 2 ? '' : 'برای نوشتن بیشتر',
                                              hintStyle:  context.textTheme.bodyMedium!.copyWith(
                                                color: ColorPallet().gray.withOpacity(0.5),
                                              ),
                                              contentPadding:  EdgeInsets.only(
                                                right: ScreenUtil().setWidth(10),
                                                left: ScreenUtil().setWidth(15),
                                                // bottom: ScreenUtil().setWidth(35),
                                                // top: ScreenUtil().setWidth(5),
                                              )
                                          ),
                                        ),
                                      )
                                  )
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(40)),
//                             widget.isPartner ?
//                             StreamBuilder(
//                               stream: widget.calenderPresenter!.uploadFilesObserve,
//                               builder: (context,AsyncSnapshot<List<UploadFileModel>>snapshotUploadFiles){
//                                 if(snapshotUploadFiles.data != null){
//                                   if(snapshotUploadFiles.data.length != 0){
//                                     return   ListView.builder(
//                                       shrinkWrap: true,
//                                       padding: EdgeInsets.zero,
//                                       itemCount: snapshotUploadFiles.data.length,
//                                       itemBuilder: (context,index){
//                                         return  Container(
//                                           padding: EdgeInsets.only(
//                                               left: ScreenUtil().setWidth(20),
//                                               top: ScreenUtil().setWidth(25),
//                                               bottom: ScreenUtil().setWidth(25)
//                                           ),
//                                           decoration:  BoxDecoration(
//                                               border: Border.all(
//                                                 color: Color(0xff707070).withOpacity(0.2),
//                                               ),
//                                               borderRadius: BorderRadius.circular(10)
//                                           ),
//                                           child:  Row(
//                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                             children: <Widget>[
//                                               widget.mode != 2 ?
//                                               Flexible(
//                                                   child: GestureDetector(
//                                                     onTap: (){
//                                                       widget.calenderPresenter!.cancelUpload();
//                                                     },
//                                                     child:   Container(
//                                                       padding: EdgeInsets.all(ScreenUtil().setWidth(3)),
//                                                       decoration:  BoxDecoration(
//                                                           shape: BoxShape.circle,
//                                                           color: snapshotUploadFiles.data[index].stateUpload == 0 ?
//                                                           Colors.transparent : ColorPallet().mainColor.withOpacity(0.2),
//                                                           border: Border.all(
//                                                               color: snapshotUploadFiles.data[index].stateUpload == 0 ?
//                                                               ColorPallet().mainColor: Colors.transparent,
//                                                               width: ScreenUtil().setWidth(2)
//                                                           )
//                                                       ),
//                                                       child:  Center(
//                                                           child: snapshotUploadFiles.data[index].stateUpload == 0 ?
//                                                           Icon(
//                                                               Icons.close,
//                                                               color: Color(0xff707070)
//                                                           ) :  Container(
//                                                               height: ScreenUtil().setWidth(55),
//                                                               width: ScreenUtil().setWidth(55),
//                                                               child:  Padding(
//                                                                   padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
//                                                                   child:  Image.asset(
//                                                                     'assets/images/ic_delete.png',
//                                                                     color: ColorPallet().mainColor,
//                                                                     fit: BoxFit.fitHeight,
//                                                                   )
//                                                               )
//                                                           )
//                                                       ),
//                                                     ),
//                                                   )
//                                               )
//                                                   : Container(),
//                                               Flexible(
//                                                 flex: 3,
//                                                 child:  Column(
//                                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                                   children: <Widget>[
//                                                     Text(
//                                                       snapshotUploadFiles.data[index].name,
//                                                       textDirection: TextDirection.ltr,
//                                                       style:  TextStyle(
//                                                           color: Color(0xff545454),
//                                                           fontSize: ScreenUtil().setSp(30),
//                                                           fontWeight: FontWeight.w500
//                                                       ),
//                                                     ),
//                                                     SizedBox(height: ScreenUtil().setHeight(10)),
//                                                     snapshotUploadFiles.data[index].stateUpload == 0 ?
//                                                     ClipRRect(
//                                                         borderRadius: BorderRadius.all(Radius.circular(10)),
//                                                         child:  Directionality(
//                                                             textDirection: TextDirection.ltr,
//                                                             child:  StreamBuilder(
//                                                               stream: widget.calenderPresenter!.sendValuePercentUploadFileObserve,
//                                                               builder: (context,snapshotPercentUpload){
//                                                                 if(snapshotPercentUpload.data != null){
//                                                                   return  LinearPercentIndicator(
//                                                                     padding: EdgeInsets.zero,
//                                                                     // width: MediaQuery.of(context).size.width / 2,
//                                                                     lineHeight: ScreenUtil().setWidth(17),
//                                                                     percent: snapshotPercentUpload.data/100,
//                                                                     backgroundColor: Color(0xffececec),
//                                                                     progressColor: ColorPallet().mainColor,
//                                                                   );
//                                                                 }else{
//                                                                   return  Container();
//                                                                 }
//                                                               },
//                                                             )
//                                                         )
//                                                     )
//                                                         :  Container()
//                                                   ],
//                                                 ),
//                                               ),
//                                               Flexible(
//                                                 child: snapshotUploadFiles.data[index].type == 0 ?
//                                                 snapshotUploadFiles.data[index].fileName.path.startsWith('http') ?
//                                                 GestureDetector(
//                                                     onTap: (){
//                                                       Navigator.push(
//                                                           context,
//                                                           PageTransition(
//                                                               type: PageTransitionType.fade,
//                                                               child: PhotoPageScreen(
//                                                                 photo: snapshotUploadFiles.data[index].fileName.path,
//                                                               )
//                                                           )
//                                                       );
//                                                     },
//                                                     child: Hero(
//                                                         tag: 'notePhoto',
//                                                         child:  Container(
//                                                             height: ScreenUtil().setWidth(100),
//                                                             width:  ScreenUtil().setWidth(100),
//                                                             margin: EdgeInsets.only(
//                                                                 right: ScreenUtil().setWidth(20)
//                                                             ),
//                                                             decoration:  BoxDecoration(
//                                                               borderRadius: BorderRadius.circular(10),
//                                                               border: Border.all(
//                                                                   color: Color(0xff707070).withOpacity(0.2),
//                                                                   width: ScreenUtil().setWidth(2)
//                                                               ),
//                                                             ),
//                                                             child: ClipRRect(
//                                                               borderRadius: BorderRadius.circular(10),
//                                                               child: CachedNetworkImage(
//                                                                 imageUrl: snapshotUploadFiles.data[index].fileName.path,
//                                                                 fit: BoxFit.cover,
//                                                               ),
//                                                             )
//                                                         )
//                                                     )
//                                                 )
//                                                     :
//                                                 Container(
//                                                   height: ScreenUtil().setWidth(100),
//                                                   width:  ScreenUtil().setWidth(100),
//                                                   margin: EdgeInsets.only(
//                                                       right: ScreenUtil().setWidth(20)
//                                                   ),
//                                                   decoration:  BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(10),
//                                                       border: Border.all(
//                                                           color: Color(0xff707070).withOpacity(0.2),
//                                                           width: ScreenUtil().setWidth(2)
//                                                       ),
//                                                       image:  DecorationImage(
//                                                           fit: BoxFit.cover,
//                                                           image: FileImage(
//                                                               File( snapshotUploadFiles.data[index].fileName.path,)
//                                                           )
//                                                       )
//                                                   ),
// //                                                  )
//                                                 )
//                                                     :
//                                                 Container(
//                                                   height: ScreenUtil().setWidth(100),
//                                                   width:  ScreenUtil().setWidth(100),
//                                                   margin: EdgeInsets.only(
//                                                       right: ScreenUtil().setWidth(20)
//                                                   ),
//                                                   decoration:  BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(10),
//                                                       image:  DecorationImage(
//                                                           fit: BoxFit.fitHeight,
//                                                           image: AssetImage(
//                                                             'assets/images/ic_pdf.png',
//                                                           )
//                                                       )
//                                                   ),
// //                                                  )
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                     );
//                                   }else{
//                                     return widget.mode != 2 ?
//                                     StreamBuilder(
//                                       stream: _animations.squareScaleBackButtonObserve,
//                                       builder: (context,snapshotScale){
//                                         if(snapshotScale.data != null){
//                                           return Transform.scale(
//                                             scale: modePress == 3 ? snapshotScale.data : 1.0,
//                                             child: GestureDetector(
//                                                 onTap: ()async{
//                                                   setState(() {
//                                                     modePress = 3;
//                                                   });
//                                                   await animationControllerScaleButtons.reverse();
//                                                   setState(() {
//                                                     modePanel = 1;
//                                                   });
//                                                   widget.calenderPresenter!.openDateTimePicker();
//                                                 },
//                                                 child : Container(
//                                                   margin: EdgeInsets.symmetric(
//                                                       horizontal: ScreenUtil().setWidth(200)
//                                                   ),
//                                                   padding: EdgeInsets.symmetric(
//                                                       vertical: ScreenUtil().setWidth(5)
//                                                   ),
//                                                   decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(15),
//                                                       color: Colors.transparent,
//                                                       border: Border.all(
//                                                           color: ColorPallet().mainColor
//                                                       )
//                                                   ),
//                                                   child: Row(
//                                                     mainAxisAlignment: MainAxisAlignment.center,
//                                                     children: [
//                                                       Container(
//                                                         width: ScreenUtil().setWidth(45),
//                                                         height: ScreenUtil().setWidth(45),
//                                                         child:Image.asset(
//                                                           'assets/images/ic_attach.png',
//                                                           color: Color(0xff707070),
//                                                         ),
//                                                       ),
//                                                       SizedBox(width : ScreenUtil().setWidth(10)),
//                                                       Text(
//                                                         'آپلود عکس',
//                                                         style: TextStyle(
//                                                             color: Color(0xff707070),
//                                                             fontSize: ScreenUtil().setSp(30)
//                                                         ),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 )
//                                             ),
//                                           );
//                                         }else{
//                                           return Container();
//                                         }
//                                       },
//                                     )
//                                         : Container();
//                                   }
//                                 }else{
//                                   return  Container();
//                                 }
//                               },
//                             )
//                                 : Container()
                          ],
                        ),
                      ),
                      widget.mode != 2 && !widget.isOfflineMode ?
                      Padding(
                          padding: EdgeInsets.only(
                            right: ScreenUtil().setWidth(50),
                            left: ScreenUtil().setWidth(50),
                          ),
                          child:   Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StreamBuilder(
                                stream: widget.calenderPresenter!.isLoadingObserve,
                                builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                                  if(snapshotIsLoading.data != null){
                                   return StreamBuilder(
                                      stream: _animations.squareScaleBackButtonObserve,
                                      builder: (context,AsyncSnapshot<double>snapshotScale){
                                        if(snapshotScale.data != null){
                                          return Transform.scale(
                                              scale: modePress == 0 ? snapshotScale.data : 1,
                                              child:  GestureDetector(
                                                onTap: ()async{
                                                  setState(() {
                                                    modePress = 0;
                                                  });
                                                  await animationControllerScaleButtons.reverse();
                                                  if(widget.mode == 1){
                                                    AnalyticsHelper().log(AnalyticsEvents.NotePg_Edit_Btn_Clk);
                                                  }else{
                                                    AnalyticsHelper().log(AnalyticsEvents.NotePg_AcceptAndSave_Btn_Clk);
                                                  }
                                                  onPressYes();
                                                },
                                                child: Container(
                                                    height: ScreenUtil().setWidth(70),
                                                    width: MediaQuery.of(context).size.width/3.2,
                                                    decoration:  BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        gradient: LinearGradient(
                                                            colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain]
                                                        )
                                                    ),
                                                    child:  Center(
                                                        child: !snapshotIsLoading.data! ?
                                                        Text(
                                                          widget.mode == 1 ? 'ویرایش' :
                                                          // widget.isPartner ? 'تایید و ارسال' :
                                                          'تایید و ذخیره',
                                                          style: context.textTheme.labelLarge!.copyWith(
                                                            color: Colors.white,
                                                          )
                                                        )
                                                            : LoadingViewScreen(
                                                          color: Colors.white,
                                                          width: ScreenUtil().setWidth(40),
                                                          lineWidth: ScreenUtil().setWidth(5),
                                                        )
                                                    )
                                                ),
                                              )
                                          );
                                        }else{
                                          return  Container();
                                        }
                                      },
                                    );
                                  }else{
                                    return Container();
                                  }
                                },
                              ),
                              SizedBox(width: ScreenUtil().setWidth(20)),
                              StreamBuilder(
                                stream: _animations.squareScaleBackButtonObserve,
                                builder: (context,AsyncSnapshot<double>snapshotScale){
                                  if(snapshotScale.data != null){
                                    return Transform.scale(
                                        scale: modePress == 1 ? snapshotScale.data : 1,
                                        child:  GestureDetector(
                                          onTap: ()async{
                                            setState(() {
                                              modePress = 1;
                                            });
                                            AnalyticsHelper().log(AnalyticsEvents.NotePg_No_Btn_Clk);
                                            await animationControllerScaleButtons.reverse();
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                              height: ScreenUtil().setWidth(70),
                                              width: MediaQuery.of(context).size.width/3.2,
                                              decoration:  BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  color: ColorPallet().gray.withOpacity(0.2)
                                              ),
                                              child:  Center(
                                                child:   Text(
                                                  'بیخیال',
                                                  style: context.textTheme.labelLarge!.copyWith(
                                                    color: ColorPallet().gray,
                                                  )
                                                ),
                                              )
                                          ),
                                        )
                                    );
                                  }else{
                                    return  Container();
                                  }
                                },
                              ),
                            ],
                          )
                      )
                          : Container()
                    ],
                  ),
                ),
                // SlidingUpPanel(
                //     controller: widget.calenderPresenter!.panelController,
                //     backdropEnabled: true,
                //     minHeight: 0,
                //     // onPanelClosed: (){
                //     //   widget.calenderPresenter!.closeDateTimePicker();
                //     // },
                //     // onPanelOpened: (){
                //     //   widget.calenderPresenter!.openDateTimePicker();
                //     // },
                //     backdropColor: Colors.black,
                //     padding: EdgeInsets.zero,
                //     maxHeight: modePanel == 0 ? MediaQuery.of(context).size.height / 2 : MediaQuery.of(context).size.height / 5,
                //     borderRadius: BorderRadius.only(
                //         topLeft: Radius.circular(30),
                //         topRight: Radius.circular(30)
                //     ),
                //     panel: modePanel == 0 ?
                //     CustomDateTimePicker(
                //       calenderPresenter: widget.calenderPresenter!,
                //     )
                //     : attachPanel()
                // ),
                StreamBuilder(
                  stream: widget.calenderPresenter!.isShowDeleteNoteDialogObserve,
                  builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog){
                    if(snapshotIsShowDialog.data != null){
                      if(snapshotIsShowDialog.data!){
                        return  StreamBuilder(
                          stream: widget.calenderPresenter!.isLoadingButtonObserve,
                          builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                            if(snapshotIsLoading.data != null){
                              return QusDialog(
                                scaleAnim: widget.calenderPresenter!.dialogScaleObserve,
                                onPressCancel: (){
                                  AnalyticsHelper().log(AnalyticsEvents.NotePg_RemoveNoteNoDlg_Btn_Clk);
                                  widget.calenderPresenter!.onPressCancelDeleteNoteDialog();
                                },
                                value: "می‌خوای این یادداشت رو حذف کنی؟",
                                yesText: 'آره!',
                                noText: 'نه',
                                onPressYes: (){
                                  if(!snapshotIsLoading.data!){
                                    AnalyticsHelper().log(AnalyticsEvents.NotePg_RemoveNoteYesDlg_Btn_Clk);
                                    widget.calenderPresenter!.deleteAlarmCalender(context,widget.calenderPresenter!,widget.isTwoBack,widget.isOfflineMode);
                                  }
                                },
                                isIcon: true,
                                colors: [Colors.white,Colors.white],
                                topIcon: 'assets/images/ic_delete_dialog.svg',
                                isLoadingButton: snapshotIsLoading.data,
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
                  stream: widget.calenderPresenter!.isShowCanDrawOverlaysDialogObserve,
                  builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog){
                    if(snapshotIsShowDialog.data != null){
                      if(snapshotIsShowDialog.data!){
                        return  QusDialog(
                          scaleAnim: widget.calenderPresenter!.dialogScaleObserve,
                          onPressCancel: ()async{
                            AnalyticsHelper().log(AnalyticsEvents.NotePg_NoPermAlarmCalendar_Btn_Clk_Dlg);
                            await widget.calenderPresenter!.animationControllerDialog.reverse();
                            if(!widget.calenderPresenter!.isShowCanDrawOverlaysDialog.isClosed){
                              widget.calenderPresenter!.isShowCanDrawOverlaysDialog.sink.add(false);
                            }
                          },
                          value: "برای نمایش بهتر یاد‌آور‌ها، لازمه که به ایمپو مجوز نمایش بدی",
                          yesText: 'اجازه میدم',
                          noText: 'نه!',
                          onPressYes: ()async{
                            AnalyticsHelper().log(AnalyticsEvents.NotePg_IAllowPermAlarmCalendar_Btn_Clk_Dlg);
                            await ActionManageOverlay.goToSettingPermissionOverlay();
                            await widget.calenderPresenter!.animationControllerDialog.reverse();
                            if(!widget.calenderPresenter!.isShowCanDrawOverlaysDialog.isClosed){
                              widget.calenderPresenter!.isShowCanDrawOverlaysDialog.sink.add(false);
                            }
                          },
                          isIcon: true,
                          colors: [Colors.white,Colors.white],
                          topIcon: 'assets/images/ic_box_question.svg',
                          isLoadingButton: false,
                        );
                      }else{
                        return  Container();
                      }
                    }else{
                      return  Container();
                    }
                  },
                )
              ],
            )
        ),
      ),
    );
  }


  onPressYes() {
    _animations.isErrorShow.sink.add(false);
    if (titleController.text.length != 0) {
      widget.calenderPresenter!.onPressAddNote(
          titleController.text,
          subtitleController.text,
          _value,
          time,
          widget.mode,
          context,
          widget.calenderPresenter!,
          widget.isTwoBack,
          widget.isOfflineMode
      );
    } else {
      _animations.showShakeError('عنوان یادت رفت!');
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    // print(now.hour);
    if(!widget.isOfflineMode){
      TimeOfDay? _time = await showTimePicker(
        context: context,
        builder: (context, child) {
          return Localizations.override(
            context: context,
            locale: Locale('fa', 'IR'),
            child: child,
          );
        },

        initialTime: _value ? time : TimeOfDay.now(),
      );

      if (_time != null) {
        if (widget.calenderPresenter!.dateAddNote!.year == now.year &&
            widget.calenderPresenter!.dateAddNote!.month == now.month &&
            widget.calenderPresenter!.dateAddNote!.day == now.day) {
          if (DateTime(now.year, now.month, now.day, _time.hour, _time.minute)
              .isBefore(
              DateTime(now.year, now.month, now.day, now.hour, now.minute))) {
            // Fluttertoast.showToast(msg:'زمان انتخابی گذشته است',
            //     toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
            CustomSnackBar.show(context, 'زمان انتخابی گذشته است');
            _selectDate(context);
          } else {
            setState(() {
              if (_time != null) time = _time;
            });
          }
        } else {
          setState(() {
            if (_time != null) time = _time;
          });
        }
      }
    }
    // print('ok');
  }

}
