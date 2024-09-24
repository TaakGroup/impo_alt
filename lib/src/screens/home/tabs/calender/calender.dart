import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/calender_presenter.dart';
import 'package:impo/src/architecture/presenter/expert_presenter.dart';
import 'package:impo/src/architecture/view/calender_view.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/tab_target.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/dashboard/dashboard_messages_and_notify_model.dart';
import 'package:impo/src/models/advertise_model.dart';
import 'package:impo/src/models/calender/cell_item.dart';
import 'package:impo/src/models/calender/grid_item.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/models/signsModel/button_animation.dart';
import 'package:impo/src/singleton/payload.dart';
import 'package:impo/src/screens/home/tabs/calender/note_list_screen.dart';
import 'package:impo/src/screens/home/tabs/calender/note_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../firebase_analytics_helper.dart';
import '../expert/clinic_question_screen.dart';


class Calender extends StatefulWidget {
  final CalenderPresenter? calenderPresenter;
  final isOfflineMode;
  final ExpertPresenter? expertPresenter;

  Calender({Key? key,this.calenderPresenter,this.isOfflineMode,this.expertPresenter}):super(key:key);
  @override
  State<StatefulWidget> createState() => CalenderState();

}

//'فروردین',
//'اردیبهشت',
//'خرداد',
//'تیر',
//'مرداد',
//'شهریور',
//'مهر',
//'آبان',
//'آذر',
//'دی',
//'بهمن',
//'اسفند'

class CalenderState extends State<Calender> with TickerProviderStateMixin implements CalenderView {

//  CalenderPresenter _presenter;
//  PageController _controller;



//  CalenderState(){
//    widget.calenderPresenter! = CalenderPresenter(this);
//  }

  static const String feature11 = 'feature11',
      // feature12 = 'feature12',
      feature13 = 'feature13';

  bool _visible = true;

  int modePress = 0;

  bool _readFlagVisible = true;



  bool scrollUp = true;
  double _width = 280.0;
  late ScrollController _scrollController ;

  List<String> weekDay = ['شنبه','یک','دو','سه','چهار','پنج','جمعه'];

//  PersianDate persianDate = PersianDate(format: "yyyy/mm/dd  \n DD  , d  MM  ");
//  String _datetime = '';
//  String _format = 'yyyy-mm-dd';
//  String _value = '';
//  String _valuePiker = '';
//  DateTime selectedDate = DateTime.now();
//
//  Future _selectDate() async {
//    String picked = await jalaliCalendarPicker(
//        context: context,
//        convertToGregorian: false,
//        showTimePicker: true,
//        hore24Format: true);
//    if (picked != null) setState(() => _value = picked);
//  }

  late AnimationController animationControllerScaleButtons;

  late AnimationController controller;
  late Animation<double> animation;

  Animations _animations =  Animations();
  late PageController _controller;
  late AnimationController _animationController;


@override
  void initState() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    FeatureDiscovery.discoverFeatures(
      context,
      const <String>{
        feature11,
        // feature12,
        feature13,
      },
    );
  });
  Payload.getGlobal().setPayload('');
  widget.calenderPresenter!.getAdvertise();
  animationControllerScaleButtons = _animations.pressButton(this);
  widget.calenderPresenter!.getRandomMessage(widget.isOfflineMode);
  Timer(Duration(milliseconds: 500),(){
    widget.calenderPresenter!.loadCircleItems();
  });
  widget.calenderPresenter!.initialDialogScale(this);
  setAnim();
  _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      upperBound: 1.0,
      lowerBound: 0.0
  );
  _animationController.forward();
  _scrollController = ScrollController()
    ..addListener(() async{
      if(_scrollController.position.userScrollDirection == ScrollDirection.forward){
        if(this.mounted){
          setState(() {
            // scrollUp = true;
            _width = 280;
          });
        }
        _animationController.forward();
      }else if(_scrollController.position.userScrollDirection == ScrollDirection.reverse){
        if(this.mounted){
          setState(() {
            // scrollUp = false;
            _width = 70;
          });
        }
        _animationController.reverse();
      }
    });

    super.initState();
  }

  setAnim(){
    controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

  }




  int? initialPage(List<GirdItem>? girdItems){
   if(girdItems != null){
     for(int i=0 ; i<girdItems.length ; i++){
       for(int j=0 ; j<girdItems[i].cells.length; j++){
         if(girdItems[i].cells[j].isToday){
           return i;
         }
       }
     }
   }else{
        return 0;
   }
   return null;
  }


  double width = 0;
  double height = 0;

  Future<bool> onWillPop()async{
    if(widget.isOfflineMode){
      return Future.value(true);
    }else{
      if(widget.calenderPresenter!.isShowDialog.stream.value){
        if(ButtonAnimation.getGlobal()!.getAnim().isCompleted){
          ButtonAnimation.getGlobal()!.getAnim().reverse();
          setState(() {
            ButtonAnimation.getGlobal()!.setIsShowBoxDateTime(true);
          });
        }else{
          await widget.calenderPresenter!.animationControllerDialog.reverse();
          widget.calenderPresenter!.isShowDialog.sink.add(false);
        }
      }

      return Future.value(false);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  clickOnBanner(String id) async {
    var register = locator<RegisterParamModel>();
    Map responseBody = await Http().sendRequest(
        womanUrl, 'report/msgmotival/$id', 'POST', {}, register.register.token!);
    print(responseBody);
  }

  Future<bool> _launchURL(String url,String? id) async {
    if(id != null){
      if(id != ''){
        clickOnBanner(id);
      }
    }
    String httpUrl = '';
    if(url.startsWith('http')){
      httpUrl = url;
    }else{
      httpUrl = 'https://$url';
    }
    // if (await canLaunch(httpUrl)) {
    //   await launch(httpUrl);
    // } else {
    //   throw 'Could not launch $httpUrl';
    // }
    if (!await launchUrl(Uri.parse(httpUrl))) throw 'Could not launch $httpUrl';
    return true;
  }


  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = .5;
    width = MediaQuery.of(context).size.width;
    height= MediaQuery.of(context).size.height;
    return  WillPopScope(
      onWillPop: onWillPop,
      child:  Directionality(
        textDirection: TextDirection.rtl,
        child:  Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              controller: _scrollController,
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  top: ScreenUtil().setWidth(0),
                  bottom: ScreenUtil().setWidth(25)
              ),
              children: <Widget>[
                widget.isOfflineMode ?
                    offlineModeAppbar()
                    :
                StreamBuilder(
                  stream: widget.calenderPresenter!.randomMessageObserve,
                  builder: (context,AsyncSnapshot<DashBoardMessageAndNotifyViewModel>snapshotRandomMessage){
                    return CustomAppBar(
                      messages: true,
                      titleMessage: snapshotRandomMessage.data != null ? snapshotRandomMessage.data!.text : '',
                      idMotivalMessage: snapshotRandomMessage.data != null ? snapshotRandomMessage.data!.id : '',
                      link: snapshotRandomMessage.data != null ? snapshotRandomMessage.data!.link : '',
                      typeLink: snapshotRandomMessage.data != null ? snapshotRandomMessage.data!.typeLink : '',
                      expertPresenter: widget.expertPresenter!,
                      icon:  'assets/images/ic_event_calendar.svg',
                      profileTab: false,
                      onPressBack: (){},
                      calenderPresenter: widget.calenderPresenter!,
                      isReminder: true,
                      // isMemory: true,
                    );
                  },
                ),
                StreamBuilder(
                  stream: widget.calenderPresenter!.advertis,
                  builder: (context,AsyncSnapshot<AdvertiseViewModel>snapshotAdv){
                    if(snapshotAdv.data != null){
                      return  Padding(
                          padding: EdgeInsets.only(
                            top: ScreenUtil().setWidth(25),
                            right: ScreenUtil().setWidth(50),
                            left: ScreenUtil().setWidth(50),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: ScreenUtil().setWidth(160),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: FadeInImage.assetNetwork(
                                    fit: BoxFit.cover,
                                    placeholder: 'assets/images/place_holder_adv.png' ,
                                    image:'$mediaUrl/file/${snapshotAdv.data!.image}',
                                  ),
                                  // Image.network(
                                  //   '$mediaUrl/file/${snapshotAdv.data.image}',
                                  // ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    // splashColor: Colors.lightGreenAccent,
                                    onTap: (){
                                      if(snapshotAdv.data!.typeLink == 1 || snapshotAdv.data!.typeLink == 2){
                                        AnalyticsHelper().log(AnalyticsEvents.CalendarJalaliPg_AdvBanner_Banner_Clk);
                                        if(snapshotAdv.data!.typeLink == 1){
                                          if(widget.expertPresenter != null){
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    type: PageTransitionType.fade,
                                                    child:  ClinicQuestionScreen(
                                                      expertPresenter: widget.expertPresenter!,
                                                      bodyTicketInfo: json.decode(snapshotAdv.data!.link),
                                                      // ticketId: ticketsModel.ticketId,
                                                    )
                                                )
                                            );
                                          }
                                        }
                                        if(snapshotAdv.data!.typeLink == 2){
                                          if(snapshotAdv.data!.link != ''){
                                            Timer(Duration(milliseconds: 300),(){
                                              _launchURL(snapshotAdv.data!.link,snapshotAdv.data!.id);
                                            });
                                          }
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: ScreenUtil().setWidth(145),
                                    )
                                ),
                              )
                            ],
                          )
                        // Ink.image(
                        //   image: NetworkImage(
                        //     '$mediaUrl/file/${snapshotAdv.data.image}',
                        //   ),
                        //   fit: BoxFit.cover,
                        //   child: InkWell(
                        //     onTap: (){
                        //       print('dsds');
                        //     },
                        //   ),
                        // )
                      );
                    }else{
                      return Container();
                    }
                  },
                ),
                SizedBox(height: ScreenUtil().setHeight(60)),
                StreamBuilder(
                  stream: widget.calenderPresenter!.listGirdItemsObserve,
                  builder: (context,AsyncSnapshot<List<GirdItem>> snapshot){
                    if (snapshot.data != null) {
                      if(snapshot.data!.length == 0){
                        return  Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height/2 - ScreenUtil().setHeight(140)
                            ),
                            child:  Center(
                              child:  Text(
                                'در حال بارگذاری تقویم',
                                style:  context.textTheme.bodyMedium
                              ),
                            )
                        );
                      }else{
                        return  Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(40)
                            ),
                            child:  Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: (){
                                        AnalyticsHelper().log(AnalyticsEvents.CalendarJalaliPg_LastMonth_Btn_Clk);
                                        _controller.previousPage(
                                            duration: Duration(milliseconds: 300),
                                            curve: Curves.ease
                                        );
                                      },
                                      child:  Row(
                                        children: <Widget>[
                                          Icon(Icons.keyboard_arrow_right,color: ColorPallet().gray),
                                          Text(
                                            'ماه قبل',
                                            style:  context.textTheme.labelMedium                                          )
                                        ],
                                      ),
                                    ),
                                    StreamBuilder(
                                      stream: widget.calenderPresenter!.indexMoonObserve,
                                      builder: (context,AsyncSnapshot<int>snapshotIndex){
                                        if(snapshotIndex.data != null){
                                          return    Text(
                                            snapshot.data![snapshotIndex.data!].persianTitle!,
                                            style:  context.textTheme.bodyLarge!.copyWith(
                                              color: widget.calenderPresenter!.getRegister().status == 1 ?
                                              ColorPallet().mainColor :
                                              ColorPallet().mentalMain,
                                            )
                                          );
                                        }else{
                                          return  Container();
                                        }
                                      },
                                    ),
                                    GestureDetector(
                                      onTap:(){
                                        AnalyticsHelper().log(AnalyticsEvents.CalendarJalaliPg_NextMonth_Btn_Clk);
                                        _controller.nextPage(
                                            duration: Duration(milliseconds: 300),
                                            curve: Curves.ease
                                        );
                                      },
                                      child:  Row(
                                        children: <Widget>[
                                          Text(
                                            'ماه بعد',
                                              style:  context.textTheme.labelMedium
                                          ),
                                          Icon(Icons.keyboard_arrow_left,color: ColorPallet().gray),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: ScreenUtil().setHeight(30)),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: List.generate(
                                        weekDay.length, (index) {
                                      return  Center(
                                          child: Text(
                                            weekDay[index],
                                            style:  context.textTheme.bodySmall!.copyWith(
                                                color: ColorPallet().gray
                                            )
                                          )
                                      );
                                    })
                                ),
                                StreamBuilder(
                                  stream: widget.calenderPresenter!.heightCalendarObserve,
                                  builder: (context,AsyncSnapshot<int>snapshotHeightCalendar){
                                    if(snapshotHeightCalendar.data != null){
                                      return Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: ScreenUtil().setWidth(snapshotHeightCalendar.data!),
                                          child:  NotificationListener<OverscrollIndicatorNotification>(
                                            onNotification: (overscroll) {
                                              overscroll.disallowIndicator();
                                              return true;
                                            },
                                            child: PageView.builder(
                                              controller: _controller =  PageController(
                                                  initialPage: initialPage(snapshot.data) != null ? initialPage(snapshot.data)! : 0
                                              ),
                                              onPageChanged: (index) {
                                                for (int i = 0; i < snapshot.data![index].cells.length; i++) {
                                                  if (snapshot.data![index].cells[i].isCurrent) {
                                                    widget.calenderPresenter!.changeText(snapshot.data![index].cells, i,index);
                                                    widget.calenderPresenter!.showChangeCircleButton(snapshot.data!,snapshot.data![index].cells,index,i);
                                                  }
                                                }
                                                widget.calenderPresenter!.setHeightCalendar(snapshot.data![index].cells);
                                              },
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (context, index) {
                                                return GridView.builder(
                                                  physics: NeverScrollableScrollPhysics(),
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  itemCount: snapshot.data![index]
                                                      .cells.length,
                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 7,
                                                      childAspectRatio: 0.9
                                                  ),
                                                  itemBuilder: (context, index1) {
                                                    return  Opacity(
                                                        opacity: snapshot.data![index]
                                                            .cells[index1].notInMonth
                                                            ? 0
                                                            : 1,
                                                        child:  GestureDetector(
                                                          onTap: () {
                                                            AnalyticsHelper().log(
                                                                AnalyticsEvents.CalendarJalaliPg_ItemDate_Item_Clk,
                                                                parameters: {
                                                                  'date' : snapshot.data![index].cells[index1].dateTime.toString()
                                                                }
                                                            );
                                                            !snapshot.data![index].
                                                            cells[index1].notInMonth?
                                                            setState(() {
                                                              _visible = false;
                                                              Timer(Duration(
                                                                  milliseconds: 200), () {
                                                                _visible = true;
                                                                onPressItems(snapshot.data!, snapshot.data![index].cells,index, index1);
                                                              });
                                                            }) : (){};
                                                          },
                                                          child:  Stack(
                                                            alignment: Alignment.bottomCenter,
                                                            children: <Widget>[
                                                              Container(
                                                                  margin: setMargin(snapshot.data![index].cells[index1]),
                                                                  height: ScreenUtil().setWidth(55),
                                                                  decoration:  BoxDecoration(
                                                                      color: setColorDay(
                                                                          snapshot
                                                                              .data![index]
                                                                              .cells[index1]),
                                                                      borderRadius: setBorderRadius(
                                                                          snapshot
                                                                              .data![index]
                                                                              .cells[index1])
                                                                  ),
                                                                  child: snapshot.data![index].cells[index1].readFlag ?
                                                                  Center(
                                                                    child: Text(
                                                                      Jalali
                                                                          .fromDateTime(
                                                                          snapshot
                                                                              .data![index]
                                                                              .cells[index1]
                                                                              .getDateTime())
                                                                          .day
                                                                          .toString(),
                                                                      style:  context.textTheme.bodyMedium!.copyWith(
                                                                        color:  setTextColorDay(snapshot.data![index].cells[index1]),
                                                                      )
                                                                    ),
                                                                  )
                                                                      : textIsNotReadFlag(snapshot.data![index].cells[index1].getDateTime())
                                                              ),
                                                              snapshot.data![index]
                                                                  .cells[index1]
                                                                  .getIsOvom() ?
                                                              Stack(
                                                                children: [
                                                                  Container(
                                                                      width: ScreenUtil().setWidth(70),
                                                                      height:  ScreenUtil().setWidth(70),
                                                                      decoration:  BoxDecoration(
                                                                        color: Color(0xff2EE9E9),
                                                                        shape: BoxShape.circle,
                                                                      ),
                                                                      child: snapshot.data![index].cells[index1].readFlag ?
                                                                      Center(
                                                                        child: Text(
                                                                          Jalali
                                                                              .fromDateTime(
                                                                              snapshot
                                                                                  .data![index]
                                                                                  .cells[index1]
                                                                                  .getDateTime())
                                                                              .day
                                                                              .toString(),
                                                                          style:  context.textTheme.bodyMedium!.copyWith(
                                                                            color: Colors.white,
                                                                          )
                                                                        ),
                                                                      )
                                                                          : textIsNotReadFlag(snapshot.data![index].cells[index1].getDateTime())
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets.only(
                                                                        right: ScreenUtil().setWidth(15),
                                                                        top: ScreenUtil().setWidth(10)
                                                                    ),
                                                                    width: ScreenUtil().setWidth(7),
                                                                    height: ScreenUtil().setWidth(7),
                                                                    decoration: BoxDecoration(
                                                                        color: Color(0xff0a7b7f),
                                                                        shape: BoxShape.circle
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                                  :
                                                              Container(),
                                                              snapshot.data![index]
                                                                  .cells[index1]
                                                                  .isToday ?
                                                              Positioned(
                                                                top: ScreenUtil().setWidth(-6),
                                                                child: Text(
                                                                  'امروز',
                                                                  style: context.textTheme.labelSmall!.copyWith(
                                                                    color: Color(0xff313131),
                                                                  )
                                                                ),
                                                              )
                                                                  :  Container(),
                                                              snapshot.data![index].cells[index1].dayOfDelivery ||
                                                                  snapshot.data![index].cells[index1].dayOfAbortion ?
                                                              Container(
                                                                  width: ScreenUtil().setWidth(70),
                                                                  height: ScreenUtil().setWidth(70),
                                                                  decoration:  BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    gradient: LinearGradient(
                                                                        colors: snapshot.data![index].cells[index1].dayOfDelivery ?
                                                                        [ColorPallet().mentalMain,ColorPallet().mentalHigh] :
                                                                        [Color(0xffAAAAAA),Color(0xffAAAAAA)],
                                                                        begin: Alignment.topCenter,
                                                                        end: Alignment.bottomCenter
                                                                    ),
                                                                  ),
                                                                  child: snapshot.data![index].cells[index1].readFlag ?
                                                                  Center(
                                                                    child: Text(
                                                                      Jalali
                                                                          .fromDateTime(
                                                                          snapshot
                                                                              .data![index]
                                                                              .cells[index1]
                                                                              .getDateTime())
                                                                          .day
                                                                          .toString(),
                                                                      style:  context.textTheme.labelLarge!.copyWith(
                                                                        color: Colors.white,
                                                                      )
                                                                    ),
                                                                  )
                                                                      : textIsNotReadFlag(snapshot.data![index].cells[index1].getDateTime())
                                                              ) :
                                                              Container(),
                                                              snapshot.data![index]
                                                                  .cells[index1]
                                                                  .isCurrent ?
                                                              TabTarget(
                                                                id: feature11,
                                                                // width: 1,
                                                                // height: 1,
                                                                contentLocation: ContentLocation.above,
                                                                icon:  SizedBox(
                                                                    width: ScreenUtil().setWidth(80),
                                                                    height:  ScreenUtil().setWidth(80),
                                                                    child: Padding(
                                                                      padding: setPaddingCurrent(snapshot.data![index].cells[index1]),
                                                                      child: DottedBorder(
                                                                          borderType: BorderType.Circle,
                                                                          dashPattern: const [5, 5],
                                                                          child: Container(
                                                                            decoration: const BoxDecoration(shape: BoxShape.circle),
                                                                            child: snapshot.data![index].cells[index1].readFlag ?
                                                                            Center(
                                                                              child: Text(
                                                                                Jalali
                                                                                    .fromDateTime(
                                                                                    snapshot
                                                                                        .data![index]
                                                                                        .cells[index1]
                                                                                        .getDateTime())
                                                                                    .day
                                                                                    .toString(),
                                                                                style: context.textTheme.bodyLarge!.copyWith(
                                                                                  color: ColorPallet().mainColor,
                                                                                )
                                                                              ),
                                                                            )
                                                                                : textIsNotReadFlag(snapshot.data![index].cells[index1].getDateTime()),
                                                                          ),
                                                                      ),
                                                                    )
                                                                ) ,
                                                                title: 'روز های تقویم',
                                                                description: 'با کلیک روی روزهای تقویم می‌تونی ببینی که در اون روز در چه وضعیتی هستی',
                                                                child:
                                                                SizedBox(
                                                                    width: ScreenUtil().setWidth(80),
                                                                    height:  ScreenUtil().setWidth(80),
                                                                    child: Padding(
                                                                      padding: setPaddingCurrent(snapshot.data![index].cells[index1]),
                                                                      child: DottedBorder(
                                                                          borderType: BorderType.Circle,
                                                                          dashPattern: const [5, 5],
                                                                          child: Container(
                                                                            decoration: const BoxDecoration(shape: BoxShape.circle),
                                                                          )
                                                                      ),
                                                                    )
                                                                ),
                                                              )
                                                                  :
                                                              Container(),
                                                              snapshot.data![index].cells[index1].isAlarm ?
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: List.generate( snapshot.data![index].cells[index1].alarms.length >= 3 ? 3 :  snapshot.data![index].cells[index1].alarms.length ,
                                                                        (indexAlarms) {
                                                                      return  Container(
                                                                        margin: EdgeInsets.only(
                                                                            bottom: ScreenUtil().setWidth(5),
                                                                            left: ScreenUtil().setWidth(2),
                                                                            right: ScreenUtil().setWidth(2)
                                                                        ),
                                                                        height: ScreenUtil().setWidth(8),
                                                                        width: ScreenUtil().setWidth(8),
                                                                        decoration:  BoxDecoration(
                                                                            color: ColorPallet().periodDeep,
                                                                            borderRadius: BorderRadius.circular(2)
                                                                        ),
                                                                      );
                                                                    }),
                                                              )
                                                                  :  Container(),
                                                            ],
                                                          ),
                                                        )
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          )
                                      );
                                    }else{
                                      return Container();
                                    }
                                  },
                                )
                              ],
                            )
                        );
                      }
                    } else {
                      return  Container();
                    }
                  },
                ),
                widget.calenderPresenter!.getRegister().status == 1 ?
                Column(
                  children: [
                    SizedBox(height: ScreenUtil().setWidth(40)),
                    Padding(
                      padding:  EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(24)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          itemHelp(
                              Container(
                                width: ScreenUtil().setWidth(45),
                                height: ScreenUtil().setWidth(30),
                                decoration: BoxDecoration(
                                    color: Color(0xffFFE2F5),
                                    borderRadius: BorderRadius.circular(20)
                                ),
                              ),
                              'پریود'
                          ),
                          itemHelp(
                              Container(
                                width: ScreenUtil().setWidth(45),
                                height: ScreenUtil().setWidth(30),
                                decoration: BoxDecoration(
                                    color: Color(0xffEDE3FF),
                                    borderRadius: BorderRadius.circular(20)
                                ),
                              ),
                              'PMS'
                          ),
                          itemHelp(
                              Container(
                                width: ScreenUtil().setWidth(45),
                                height: ScreenUtil().setWidth(30),
                                decoration: BoxDecoration(
                                    color: Color(0xffDBFFFF),
                                    borderRadius: BorderRadius.circular(20)
                                ),
                              ),
                              'باروری'
                          ),
                          itemHelp(
                              Stack(
                                children: [
                                  Container(
                                    width: ScreenUtil().setWidth(30),
                                    height: ScreenUtil().setWidth(30),
                                    decoration:  BoxDecoration(
                                      color: Color(0xff2EE9E9),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: ScreenUtil().setWidth(5),
                                        top: ScreenUtil().setWidth(7)
                                    ),
                                    width: ScreenUtil().setWidth(5),
                                    height: ScreenUtil().setWidth(5),
                                    decoration: BoxDecoration(
                                        color: Color(0xff0a7b7f),
                                        shape: BoxShape.circle
                                    ),
                                  )
                                ],
                              ),
                              'روز تخمک‌گذاری'
                          ),
                          itemHelp(
                              SizedBox(
                                  width: ScreenUtil().setWidth(30),
                                  height: ScreenUtil().setWidth(30),
                                  child: DottedBorder(
                                      borderType: BorderType.Circle,
                                      dashPattern: const [5, 5],
                                      child: Container(
                                        decoration: const BoxDecoration(shape: BoxShape.circle),
                                      )
                                  )
                              ),
                              'انتخاب شده'
                          ),
                        ],
                      ),
                    ),
                  ],
                ) : SizedBox.shrink(),
                SizedBox(height: ScreenUtil().setWidth(40)),
                StreamBuilder(
                  stream: widget.calenderPresenter!.bigTextObserve,
                  builder: (context,AsyncSnapshot<String>snapshotBigText){
                    if(snapshotBigText.data != null){
                      return StreamBuilder(
                        stream: widget.calenderPresenter!.todayDateTextObserve,
                        builder: (context,snapshotTodayText){
                          if(snapshotTodayText.data != null){
                            return Container(
                              padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setWidth(15),
                                horizontal: ScreenUtil().setWidth(15)
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(50)
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xffF9F9F9),
                                borderRadius: BorderRadius.circular(7)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Text(
                                     '${snapshotTodayText.data} - ',
                                     style: context.textTheme.bodyMedium!.copyWith(
                                       color: Color(0xff1C1B1E),
                                     )
                                   ),
                                   Flexible(
                                     child: StreamBuilder(
                                       stream: widget.calenderPresenter!.colorBigTextObserve,
                                       builder: (context,AsyncSnapshot<Shader>snapshotColorText){
                                         if(snapshotColorText.data != null){
                                           return AutoSizeText(
                                             snapshotBigText.data!,
                                              maxLines: 1,
                                             style:  context.textTheme.bodyMedium!.copyWith(
                                               foreground: Paint()..shader = snapshotColorText.data,
                                     
                                             )
                                           );
                                         }else{
                                           return Container();
                                         }
                                       },
                                     ),
                                   )
                                 ],
                               ),
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
                SizedBox(height: ScreenUtil().setWidth(30)),
                StreamBuilder(
                  stream: widget.calenderPresenter!.listGirdItemsObserve,
                  builder: (context,AsyncSnapshot<List<GirdItem>>snapshot){
                    if(snapshot.data != null){
                      if(snapshot.data!.length != 0){
                        return  Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                StreamBuilder(
                                    stream: widget.calenderPresenter!.isAlarmObserve,
                                    builder: (context,AsyncSnapshot<bool>snapshotIsAlarm){
                                      if(snapshotIsAlarm.data != null){
                                        if(!widget.isOfflineMode || snapshotIsAlarm.data!){
                                          return  StreamBuilder(
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
                                                          if(snapshotIsAlarm.data!){
                                                            AnalyticsHelper().log(AnalyticsEvents.CalendarJalaliPg_Notes_Btn_Clk);
                                                          }else{
                                                            AnalyticsHelper().log(AnalyticsEvents.CalendarJalaliPg_RecordNotes_Btn_Clk);
                                                          }
                                                          await animationControllerScaleButtons.reverse();
                                                          Navigator.push(context,
                                                              PageTransition(
                                                                  type: PageTransitionType.fade,
                                                                  child: snapshotIsAlarm.data! ?
                                                                  NoteListScreen(
                                                                    calenderPresenter: widget.calenderPresenter!,
                                                                    isTwoBack: false,
                                                                    isOfflineMode: widget.isOfflineMode,
                                                                  ) :
                                                                  NoteScreen(
                                                                    calenderPresenter: widget.calenderPresenter!,
                                                                    mode: 0,
                                                                    isTwoBack: false,
                                                                    isOfflineMode: widget.isOfflineMode,
                                                                  )

                                                              )
                                                          );
//                                                    widget.calenderPresenter!.onPressShowAddNoteDialog();
                                                        },
                                                        child:  TabTarget(
                                                          id: feature13,
                                                          width: ScreenUtil().setWidth(220),
                                                          contentLocation: ContentLocation.above,
                                                          icon:  Directionality(
                                                            textDirection: TextDirection.rtl,
                                                            child:  Container(
                                                                height: ScreenUtil().setWidth(70),
                                                                width: ScreenUtil().setWidth(240),
                                                                decoration:  BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(7),
                                                                    gradient:  LinearGradient(
                                                                        colors: [
                                                                          Color(0xffFFA3E0),
                                                                          Color(0xffC33091),
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
                                                                      snapshotIsAlarm.data! ? 'یادداشت‌ها' : 'ثبت یادداشت',
                                                                        style: context.textTheme.labelLarge!.copyWith(
                                                                          color: Colors.white,
                                                                        )
                                                                    )
                                                                  ],
                                                                )
                                                            ),
                                                          ),
                                                          title: 'یادداشت‌ها' ,
                                                          description: 'تو این قسمت این امکان برات وجود داره که برای روزهای مختلف یادداشت و یادآور بذاری تا چیزی رو فراموش نکنی',
                                                          child:  Container(
                                                              height: ScreenUtil().setWidth(70),
                                                              width: ScreenUtil().setWidth(240),
                                                              decoration:  BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(7),
                                                                  gradient:  LinearGradient(
                                                                      colors: [
                                                                        Color(0xffFFA3E0),
                                                                        Color(0xffC33091),
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
                                                                  StreamBuilder(
                                                                    stream: widget.calenderPresenter!.isAlarmObserve,
                                                                    builder: (context,AsyncSnapshot<bool>snapshotIsAlarm){
                                                                      if(snapshotIsAlarm.data != null){
                                                                        return  Text(
                                                                          snapshotIsAlarm.data! ? 'یادداشت‌ها' : 'ثبت یادداشت',
                                                                          style: context.textTheme.labelLarge!.copyWith(
                                                                            color: Colors.white,
                                                                          )
                                                                        );
                                                                      }else{
                                                                        return  Container();
                                                                      }
                                                                    },
                                                                  )
                                                                ],
                                                              )
                                                          ),
                                                        )
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
                                      }else{
                                        return  Container();
                                      }
                                    }
                                )
                              ],
                            ),
                            SizedBox(height: ScreenUtil().setHeight(30)),
                          ],
                        );
                      }else{
                        return  Container();
                      }
                    }else{
                      return  Container();
                    }
                  },
                ),
                SizedBox(height: ScreenUtil().setWidth(20)),
              ],
            ),
           // floatingActionButton: Align(
           //   alignment: Alignment.bottomRight,
           //   child: Padding(
           //     padding: EdgeInsets.only(
           //       right: ScreenUtil().setWidth(80)
           //     ),
           //     child: FloatingActionButton(
           //       onPressed: (){},
           //
           //     ),
           //   ),
           // )
        ),
      ),
    );
  }

  @override
  void onError(msg) {

  }

  @override
  void onSuccess(msg) {

  }

  Widget offlineModeAppbar(){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
          child:  CustomAppBar(
            messages: false,
            profileTab: true,
            isEmptyLeftIcon: widget.isOfflineMode ? true : null,
            icon: 'assets/images/ic_arrow_back.svg',
            titleProfileTab: 'صفحه قبل',
            subTitleProfileTab: 'داشبورد',
            onPressBack: (){
              Navigator.pop(context);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(40)
          ),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              SvgPicture.asset(
                'assets/images/ic_offlineMode.svg',
                width: ScreenUtil().setWidth(80),
                height: ScreenUtil().setWidth(80),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(30)
                ),
                child: Text(
                  'این صفحه نشان‌دهنده آخرین باری هست که آنلاین شدی. برای مشاهده وضعیت دقیق‌‌تر لازمه که آنلاین بشی',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: ColorPallet().gray,
                  )
                ),
              )
            ],
          ),
        ),
        StreamBuilder(
          stream: widget.calenderPresenter!.randomMessageObserve,
          builder: (context,AsyncSnapshot<DashBoardMessageAndNotifyViewModel>snapshotRandomMessage){
            if(snapshotRandomMessage.data != null){
              return  Align(
                  alignment: Alignment.centerLeft,
                  child:  Container(
                      padding: EdgeInsets.only(
                          top: ScreenUtil().setWidth(8),
                          bottom: ScreenUtil().setWidth(13),
                          right: ScreenUtil().setWidth(40),
                          left: ScreenUtil().setWidth(40)
                      ),
                      margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(30),
                        left: ScreenUtil().setWidth(40),
                       right: ScreenUtil().setWidth(40)
                      ),
                      decoration:  BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20) ,
                            bottomRight: Radius.circular(20),
                          ),
                          color: Color(0xffF1F1F1)
                      ),
                      child:  Row(
                        children: [
                          Container(),
                          Container(),
                          Flexible(
                            child:  Text(
                              snapshotRandomMessage.data!.text!,
                              textAlign: TextAlign.start,
                              style: context.textTheme.bodySmall!.copyWith(
                                color: ColorPallet().black,
                              )
                            ),
                          )
                        ],
                      )
                  )
              );
            }else{
              return Container();
            }
          },
        ),
      ],
    );
  }

  Widget itemHelp(Widget child,String text){
    return Row(
      children: [
        child,
        SizedBox(width: ScreenUtil().setWidth(5)),
        Text(
          text,
          style : context.textTheme.labelSmall!.copyWith(
            color: Color(0xff1C1B1E),
            fontWeight: FontWeight.w500
          )
        )
      ],
    );
  }

  Widget textIsNotReadFlag(dateTime){
    return FadeTransition(
      opacity:animation,
      child:    Center(
        child: Text(
          Jalali
              .fromDateTime(dateTime)
              .day
              .toString(),
          style: context.textTheme.bodyMedium!.copyWith(
            color: ColorPallet()
                .mainColor,
          )
        ),
      ),
    );
  }

  Color setTextColorDay(CellItem cellItem){

    if(cellItem.circleItem != null){
      if(cellItem.circleItem!.isCurrentWeek != null){
        if(cellItem.circleItem!.isCurrentWeek!){
          return Colors.white;
        }
      }
    }

    // if(cellItem.getIsPeriod()){
    //   return  Colors.white;
    // }else{
      return Color(0xff5F5F5F);
    // }
  }

  Color setColorDay(CellItem cellItem){

     if(cellItem.getIsPeriod()) return Color(0xffFFE2F5);

     if(cellItem.getIsPMS()) return Color(0xffEDE3FF);

     if(cellItem.getIsFert()) return Color(0xffDBFFFF);

     // if(cellItem.getIsPregnancyEven()) return Color(0xffAFB3FC);


     if(cellItem.circleItem != null){
       if(cellItem.circleItem!.isCurrentWeek != null){
         if(cellItem.circleItem!.isCurrentWeek!){
           return Color(0xffAFB3FC);
         }
       }
       if(cellItem.circleItem!.isOdd != null){
         if(cellItem.circleItem!.isOdd!){
           return Colors.white;
         }else{
           return Color(0xffD9C6E9).withOpacity(0.2);
         }
       }
     }

     // if(cellItem.getIsPregnancyOdd()) return Color(0xffD9C6E9).withOpacity(0.9);

     return Colors.white;
  }


  BorderRadius setBorderRadius(CellItem cellItem){

     if(cellItem.getIsStartFert()) return BorderRadius.only(bottomRight: Radius.circular(16),topRight: Radius.circular(16));

     if(cellItem.getIsEndFert()) return BorderRadius.only(topLeft: Radius.circular(16),bottomLeft: Radius.circular(16));
     

//       print(cellItem.circleItem.getPeriodStart());

    if(cellItem.circleItem != null){
      if(DateTime.parse(cellItem.circleItem!.getPeriodStart()) == cellItem.dateTime) return BorderRadius.only(bottomRight: Radius.circular(16),topRight: Radius.circular(16));
      if(cellItem.circleItem!.status == 0){
        if(DateTime.parse(cellItem.circleItem!.getPeriodEnd()) == cellItem.dateTime) return BorderRadius.only(bottomLeft: Radius.circular(16),topLeft: Radius.circular(16));
      }

      if(DateTime.parse(cellItem.circleItem!.getCircleEnd()) == cellItem.dateTime) return BorderRadius.only(bottomLeft: Radius.circular(16),topLeft: Radius.circular(16));
      DateTime cycleEnd = DateTime.parse(cellItem.circleItem!.getCircleEnd());
      if(DateTime(cycleEnd.year,cycleEnd.month,cycleEnd.day - 4) ==  cellItem.dateTime && cellItem.isPMS) return BorderRadius.only(bottomRight: Radius.circular(16),topRight: Radius.circular(16));


    }

     return BorderRadius.circular(0);
  }

  EdgeInsets setPaddingCurrent(CellItem cellItem){

    if(cellItem.getIsStartFert()) return EdgeInsets.only(right: ScreenUtil().setWidth(5),top: ScreenUtil().setWidth(10));

    if(cellItem.getIsEndFert()) return EdgeInsets.only(left: ScreenUtil().setWidth(5),top: ScreenUtil().setWidth(10));



    if(cellItem.circleItem != null){
      if(DateTime.parse(cellItem.circleItem!.getPeriodStart()) == cellItem.dateTime) return  EdgeInsets.only(right: ScreenUtil().setWidth(5),top: ScreenUtil().setWidth(10));
      if(cellItem.circleItem!.status == 0){
        if(DateTime.parse(cellItem.circleItem!.getPeriodEnd()) == cellItem.dateTime) return EdgeInsets.only(left: ScreenUtil().setWidth(5),top: ScreenUtil().setWidth(10));
      }

      if(DateTime.parse(cellItem.circleItem!.getCircleEnd()) == cellItem.dateTime && !cellItem.dayOfAbortion && !cellItem.dayOfDelivery) return EdgeInsets.only(left: ScreenUtil().setWidth(5),top: ScreenUtil().setWidth(10));
      DateTime cycleEnd = DateTime.parse(cellItem.circleItem!.getCircleEnd());
      if(DateTime(cycleEnd.year,cycleEnd.month,cycleEnd.day - 4) ==  cellItem.dateTime && cellItem.isPMS) return EdgeInsets.only(right: ScreenUtil().setWidth(5),top: ScreenUtil().setWidth(10));


    }

    return EdgeInsets.only(top: ScreenUtil().setWidth(10));
  }

  EdgeInsets setMargin(CellItem cellItem){

    if(cellItem.getIsStartFert()) return EdgeInsets.only(right: ScreenUtil().setWidth(7),top: ScreenUtil().setWidth(10), bottom: ScreenUtil().setWidth(10));

    if(cellItem.getIsEndFert()) return EdgeInsets.only(left: ScreenUtil().setWidth(7),top: ScreenUtil().setWidth(10), bottom: ScreenUtil().setWidth(10));


//       print(cellItem.circleItem.getPeriodStart());

    if(cellItem.circleItem != null){
      if(DateTime.parse(cellItem.circleItem!.getPeriodStart()) == cellItem.dateTime) return  EdgeInsets.only(right: ScreenUtil().setWidth(7),top: ScreenUtil().setWidth(10), bottom: ScreenUtil().setWidth(10));
      if(cellItem.circleItem!.status == 0){
        if(DateTime.parse(cellItem.circleItem!.getPeriodEnd()) == cellItem.dateTime) return EdgeInsets.only(left: ScreenUtil().setWidth(7),top: ScreenUtil().setWidth(10), bottom: ScreenUtil().setWidth(10));
      }

      if(DateTime.parse(cellItem.circleItem!.getCircleEnd()) == cellItem.dateTime) return EdgeInsets.only(left: ScreenUtil().setWidth(7),top: ScreenUtil().setWidth(10), bottom: ScreenUtil().setWidth(10));
      DateTime cycleEnd = DateTime.parse(cellItem.circleItem!.getCircleEnd());
      if(DateTime(cycleEnd.year,cycleEnd.month,cycleEnd.day - 4) ==  cellItem.dateTime && cellItem.isPMS) return EdgeInsets.only(right: ScreenUtil().setWidth(7),top: ScreenUtil().setWidth(10), bottom: ScreenUtil().setWidth(10));


    }

    return EdgeInsets.only(top: ScreenUtil().setWidth(10), bottom: ScreenUtil().setWidth(10));
  }

  onPressItems(List<GirdItem> girdItem,List<CellItem> cell,index,index1){
  setState(() {

    for(int i=0 ; i< cell.length ; i++){

      cell[i].isCurrent = false;

    }



    cell[index1].isCurrent = !cell[index1].isCurrent;
  });

  widget.calenderPresenter!.changeText(cell,index1,index);

  widget.calenderPresenter!.showChangeCircleButton(girdItem,cell,index,index1);

  }



}