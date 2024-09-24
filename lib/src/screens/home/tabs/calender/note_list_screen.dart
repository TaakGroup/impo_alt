

import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/calender_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/calender/alarm_model.dart';
import 'package:impo/src/screens/home/tabs/calender/note_screen.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../firebase_analytics_helper.dart';
import '../../home.dart';

class NoteListScreen extends StatefulWidget{

  final CalenderPresenter? calenderPresenter;
  final isTwoBack;
  final defaultTab;
  final isOfflineMode;

  NoteListScreen({Key? key,this.calenderPresenter,this.isTwoBack,this.defaultTab,this.isOfflineMode}):super(key:key);

  @override
  State<StatefulWidget> createState() => NoteListScreenState();

}

class NoteListScreenState extends State<NoteListScreen> with TickerProviderStateMixin{

  late AnimationController animationControllerScaleButtons;
  Animations _animations =  Animations();
  int modePress =0;
  List<ItemTypeNotes> items = [];
  List<AlarmViewModel> myNotes = [];
  int modeNote = 0;
  bool isLoading  = true;
  bool rcvNote = false;


  Future<bool> onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.NotePg_Back_NavBar_Clk);
  if(widget.isTwoBack){
    Navigator.of(context)
        .popUntil(ModalRoute.withName("/Page1"));
    // Navigator.pop(context);
    // Navigator.pop(context);
    widget.calenderPresenter!.checkAlarms(widget.calenderPresenter!.backupDateAddNote);
  }else{
    Navigator.of(context)
        .popUntil(ModalRoute.withName("/Page1"));
  }
    return Future.value(false);
  }


  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.NoteListPg_Self_Pg_Load);
    animationControllerScaleButtons = _animations.pressButton(this);
    initItemTypeNotes();
//    goBack();
    super.initState();
  }

  @override
  void dispose() {
    animationControllerScaleButtons.dispose();
    super.dispose();
  }

   initItemTypeNotes()async{
    myNotes.clear();
    setState(() {
      isLoading = true;
    });
  items.add(ItemTypeNotes(title: 'یادداشت‌های من',isShow: true,selected: false));
  items.add( ItemTypeNotes(title: 'پیام های ارسالی',isShow: false,selected: false));
  items.add( ItemTypeNotes(title: 'پیام های دریافتی',isShow: false,selected: false));

  List<AlarmViewModel> alarms = [];
  List<AlarmViewModel>? list = await widget.calenderPresenter!.getAllAlarms();
  DateTime dateTime = widget.calenderPresenter!.dateAddNote!;
  if(list != null){
    for(int i=0 ; i<list.length ; i++){
      if(dateTime.year == DateTime.parse(list[i].date).year && dateTime.month == DateTime.parse(list[i].date).month && dateTime.day == DateTime.parse(list[i].date).day){
        if(list[i].mode == 0){
          myNotes.add(list[i]);
        }
        alarms.add(
            list[i]
        );

      }
    }
  }

    for(int i=0 ; i<alarms.length ; i++){
      if(alarms[i].mode == 0){
        items[0].isShow = true;
      }
      if(alarms[i].mode == 1){
        items[1].isShow = true;
      }
      if(alarms[i].mode == 2){
        items[2].isShow = true;
        if(alarms[i].readFlag == 0){
          items[2].selected = true;
          modeNote = 2;
          rcvNote =true;
        }
      }
    }


    List  isShows = [];
    for(int i=0 ; i<items.length ; i++){
      if(items[i].isShow!){
        isShows.add(i);
      }
    }

    if(!rcvNote){
      for(int i=0 ; i<items.length ; i++){
        if(items[i].isShow!){
          if(widget.defaultTab != null){
            items[widget.defaultTab].selected = true;
            modeNote = widget.defaultTab;
          }else{
            items[i].selected = true;
            modeNote = i;
          }
          break;
        }
      }
    }

    if(isShows.length <= 1){
      for(int i=0 ; i<items.length ; i++){
        items[i].isShow = false;
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = .5;
    return  WillPopScope(
      onWillPop: onWillPop,
      child:  Directionality(
        textDirection: TextDirection.rtl,
        child:  Scaffold(
          backgroundColor: Colors.white,
          body:  Column(
            children: [
              CustomAppBar(
                messages: false,
                profileTab: true,
                isEmptyLeftIcon: widget.isOfflineMode ? true : null,
                icon: 'assets/images/ic_arrow_back.svg',
                titleProfileTab: 'صفحه قبل',
                subTitleProfileTab: 'یادداشت‌ها',
                onPressBack: (){
                  AnalyticsHelper().log(AnalyticsEvents.NotePg_Back_Btn_Clk);
                  onWillPop();
                },
              ),
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
                              color: ColorPallet().gray.withOpacity(0.5),
                            ),
                            Text(
                              "${snapshotTodayDate.data}",
                              style:  context.textTheme.bodyLarge!.copyWith(
                                color: ColorPallet().gray,
                              )
                            ),
                            Container(
                              margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                              height: ScreenUtil().setHeight(1.5),
                              width: MediaQuery.of(context).size.width/5,
                              color: ColorPallet().gray.withOpacity(0.5),
                            ),
                          ],
                        )
                    );
                  }else{
                    return  Container();
                  }
                },
              ),
              !isLoading ?
              Expanded(
                  child: Column(
                    children: [
                      StreamBuilder(
                          stream: widget.calenderPresenter!.listAlarmsObserve,
                          builder: (context,AsyncSnapshot<List<AlarmViewModel>>snapshotListAlarms){
                            if(snapshotListAlarms.data != null){
                              return Padding(
                                  padding:  EdgeInsets.only(
                                    top: ScreenUtil().setWidth(30),
                                    right: ScreenUtil().setWidth(20),
                                    left: ScreenUtil().setWidth(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(items.length, (index) {
                                      return items[index].isShow! ?
                                      GestureDetector(
                                          onTap: (){
                                            for(int i=0 ; i<items.length ; i++){
                                              setState(() {
                                                items[i].selected = false;
                                              });
                                            }
                                            setState(() {
                                              items[index].selected = true;
                                              modeNote = index;
                                            });
                                          },
                                          child :  Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: ScreenUtil().setWidth(5),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: ScreenUtil().setWidth(15),
                                                vertical: ScreenUtil().setWidth(10)
                                            ),
                                            decoration: BoxDecoration(
                                                color: items[index].selected! ? ColorPallet().mainColor : Colors.white,
                                                border: Border.all(
                                                    color: items[index].selected! ? ColorPallet().mainColor : Colors.grey
                                                ),
                                                borderRadius: BorderRadius.circular(15)
                                            ),
                                            child: Text(
                                              items[index].title!,
                                              style: context.textTheme.bodyMedium!.copyWith(
                                                color: items[index].selected! ? Colors.white : Color(0xff707070),
                                              )
                                            ),
                                          )
                                      )
                                          :
                                      Container();
                                    }),
                                  )
                              );
                            }else{
                              return Container();
                            }
                          }
                      ),
                      Expanded(
                          child:  Column(
                            children: [
                              Expanded(
                                child:  StreamBuilder(
                                  stream: widget.calenderPresenter!.listAlarmsObserve,
                                  builder: (context,AsyncSnapshot<List<AlarmViewModel>>snapshotListAlarms){
                                    if(snapshotListAlarms.data != null){

                                      if(snapshotListAlarms.data!.length != 0){
                                        return   Directionality(
                                          textDirection: TextDirection.ltr,
                                          child:   Theme(
                                              data: Theme.of(context).copyWith(
                                                  highlightColor: Color(0xfff7b3e9)
                                              ),
                                              child:  Scrollbar(
                                                  child:  NotificationListener<OverscrollIndicatorNotification>(
                                                      onNotification: (overscroll) {
                                                        overscroll.disallowIndicator();
                                                        return true;
                                                      },
                                                      child:   FadingEdgeScrollView.fromScrollView(
                                                        // shouldDisposeScrollController: true,
                                                        gradientFractionOnEnd: .7,
                                                        gradientFractionOnStart: .7,
                                                        child:  ListView.builder(
                                                          controller: ScrollController(),
                                                          itemCount: snapshotListAlarms.data!.length,
                                                          itemBuilder: (context,index){
                                                            return modeNote == 0 && myNotes.length == 0 && index == 0?
                                                            Align(
                                                                alignment:Alignment.center,
                                                                child :
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top: ScreenUtil().setWidth(50)
                                                                  ),
                                                                  child:  Text(
                                                                    'هیچ یادداشتی در این روز ثبت نکردی!',
                                                                    style:  context.textTheme.bodyMedium
                                                                  ),
                                                                )
                                                            )
                                                                : modeNote == snapshotListAlarms.data![index].mode ?
                                                            StreamBuilder(
                                                              stream: _animations.squareScaleBackButtonObserve,
                                                              builder: (context,AsyncSnapshot<double>snapshotScale){
                                                                if(snapshotScale.data != null){
                                                                  return  Transform.scale(
                                                                      scale: snapshotListAlarms.data![index].isSelected && modePress ==0 ? snapshotScale.data : 1,
                                                                      child:  Directionality(
                                                                        textDirection: TextDirection.rtl,
                                                                        child:  GestureDetector(
                                                                          onTap: ()async{
                                                                            animationControllerScaleButtons.reverse();

                                                                            for(int i=0 ; i<snapshotListAlarms.data!.length ; i++){
                                                                              snapshotListAlarms.data![i].isSelected = false;
                                                                            }
                                                                            setState(() {
                                                                              modePress =0;
                                                                              snapshotListAlarms.data![index].isSelected = true;
                                                                            });
                                                                            AnalyticsHelper().log(
                                                                                AnalyticsEvents.NoteListPg_NotesList_Item_Clk,
                                                                                parameters: {
                                                                                  'id' : snapshotListAlarms.data![index].id
                                                                                }
                                                                            );
                                                                            widget.calenderPresenter!.setSelectedAlarm(index);
                                                                            Navigator.push(
                                                                                context,
                                                                                PageTransition(
                                                                                    type: PageTransitionType.fade,
                                                                                    child:  NoteScreen(
                                                                                      calenderPresenter: widget.calenderPresenter!,
                                                                                      mode: snapshotListAlarms.data![index].mode == 2 ? 2 : 1,
                                                                                      isTwoBack: false,
                                                                                      isOfflineMode: widget.isOfflineMode,
                                                                                    )
                                                                                )
                                                                            );
//                                      widget.calenderPresenter!.onPressEditOrDeleteNote(index);
                                                                          },
                                                                          child:  Container(
                                                                            margin: EdgeInsets.only(
                                                                              bottom: ScreenUtil().setWidth(30),
                                                                              right: ScreenUtil().setWidth(50),
                                                                              left: ScreenUtil().setWidth(50),
                                                                            ),
                                                                            padding: EdgeInsets.symmetric(
                                                                                vertical: ScreenUtil().setWidth(15),
                                                                                horizontal: ScreenUtil().setWidth(20)
                                                                            ),
                                                                            decoration:  BoxDecoration(
                                                                                color: Colors.white,
                                                                                borderRadius: BorderRadius.circular(17),
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
                                                                            child:  Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: <Widget>[
                                                                                Padding(
                                                                                    padding: EdgeInsets.only(top: ScreenUtil().setWidth(5)),
                                                                                    child:  Row(
                                                                                      children: [
                                                                                        snapshotListAlarms.data![index].mode == 2 ?
                                                                                        Padding(
                                                                                            padding: EdgeInsets.only(
                                                                                                left: ScreenUtil().setWidth(10)
                                                                                            ),
                                                                                            child: Image.asset(
                                                                                                'assets/images/ic_heart.png'
                                                                                            )
                                                                                        )
                                                                                            : Container(),
                                                                                        Text(
                                                                                          snapshotListAlarms.data![index].text,
                                                                                          style:  context.textTheme.bodyMedium,
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                ),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: <Widget>[
                                                                                    snapshotListAlarms.data![index].mode == 1 ?
                                                                                    Icon(
                                                                                      Icons.share,
                                                                                      color: ColorPallet().mainColor,
                                                                                      size: ScreenUtil().setWidth(50),
                                                                                    )
                                                                                        :  snapshotListAlarms.data![index].isActive == 1 ?
                                                                                    Text(
                                                                                      '${snapshotListAlarms.data![index].hour.toString().padLeft(2,'0')}:${snapshotListAlarms.data![index].minute.toString().padLeft(2,'0')}',
                                                                                      style:  context.textTheme.bodyMedium,
                                                                                    )
                                                                                        :  Container(),
                                                                                    SizedBox(width: ScreenUtil().setWidth(20)),
                                                                                    SvgPicture.asset(
                                                                                      snapshotListAlarms.data![index].isActive == 1 ?
                                                                                      'assets/images/ic_reminder.svg' : 'assets/images/ic_date.svg',
                                                                                      width: ScreenUtil().setWidth(45),
                                                                                      height: ScreenUtil().setWidth(45),
                                                                                      colorFilter: ColorFilter.mode(
                                                                                          snapshotListAlarms.data![index].mode == 2 ?
                                                                                          snapshotListAlarms.data![index].readFlag == 0 ?
                                                                                          ColorPallet().periodDeep  : Color(0xffc5c5c5):
                                                                                          ColorPallet().mainColor,
                                                                                        BlendMode.srcIn
                                                                                      ),
                                                                                      // color: snapshotListAlarms.data![index].mode == 2 ?
                                                                                      // snapshotListAlarms.data![index].readFlag == 0 ?
                                                                                      // ColorPallet().periodDeep  : Color(0xffc5c5c5):
                                                                                      // ColorPallet().mainColor,
                                                                                    )
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                  );
                                                                }else{
                                                                  return  Container();
                                                                }
                                                              },
                                                            )
                                                                :
                                                            Container();
                                                          },
                                                        ),
                                                      )
                                                  )
                                              )
                                          ),
                                        );
                                      }else{
                                        return  Padding(
                                          padding: EdgeInsets.only(
                                              top: ScreenUtil().setWidth(50)
                                          ),
                                          child:  Text(
                                            'هیچ یادداشتی در این روز ثبت نکردی!',
                                            style: context.textTheme.bodyMedium
                                          ),
                                        );
                                      }
                                    }else{
                                      return  Container();
                                    }
                                  },
                                ),
                              ),
                              modeNote != 2 && !widget.isOfflineMode ?
                              StreamBuilder(
                                stream: _animations.squareScaleBackButtonObserve,
                                builder: (context,AsyncSnapshot<double>snapshotScale){
                                  if(snapshotScale.data != null){
                                    return  Transform.scale(
                                      scale:  modePress == 1 ? snapshotScale.data : 1,
                                      child:  GestureDetector(
                                          onTap: ()async{
                                            animationControllerScaleButtons.reverse();
                                            setState(() {
                                              modePress =1;
                                            });
                                            AnalyticsHelper().log(AnalyticsEvents.NoteListPg_AddNote_Btn_Clk);
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    type: PageTransitionType.fade,
                                                    child:  NoteScreen(
                                                      calenderPresenter: widget.calenderPresenter!,
                                                      mode: 0,
                                                      isTwoBack: true,
                                                      isOfflineMode: widget.isOfflineMode,
                                                    )
                                                )
                                            );
                                          },
                                          child:  Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: ScreenUtil().setWidth(30)
                                            ),
                                            height: ScreenUtil().setWidth(110),
                                            width: ScreenUtil().setWidth(110),
                                            decoration:  BoxDecoration(
                                               gradient: LinearGradient(
                                                 colors: [
                                                   ColorPallet().mentalMain,ColorPallet().mentalHigh
                                                 ]
                                               ),
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: modeNote == 1 ? Color(0xffF9C4E7): Color(0xff565AA7).withOpacity(0.2),
                                                      blurRadius: 5
                                                  )
                                                ]
                                            ),
                                            child:  Center(
                                              child:  Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: ScreenUtil().setWidth(80),
                                              ),
                                            ),
                                          )
                                      ),
                                    );
                                  }else{
                                    return  Container();
                                  }
                                },
                              )
                                  : Container()
                            ],
                          )
                      )
                    ],
                  )
              )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

}


class ItemTypeNotes{
  String? title;
  bool? isShow;
  bool? selected;

  ItemTypeNotes({this.title,this.selected,this.isShow});
}