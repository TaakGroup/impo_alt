
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:impo/src/architecture/presenter/dashboard_presenter.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_date_time_picker.dart';
import 'package:impo/src/core/app/view/widgets/snackbar/custom_snack_bar.dart';
import 'package:impo/src/data/local/save_data_offline_mode.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/data/messages/generate_dashboard_notify_and_messages.dart';
import 'package:impo/src/models/bioRhythm/bio_model.dart';
import 'package:impo/src/models/bioRhythm/biorhythm_view_model.dart';
import 'package:impo/src/models/register/circles_send_server_model.dart';
import 'package:impo/src/models/dashboard/dashboard_messages_and_notify_model.dart';
import 'package:impo/src/models/advertise_model.dart';
import 'package:impo/src/screens/home/blank_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:impo/src/architecture/model/calender_model.dart';
import 'package:impo/src/architecture/view/calender_view.dart';
import 'package:impo/src/components/DateTime/my_datetime.dart';
import 'package:impo/src/components/action_manage_overlay.dart';
import 'package:impo/src/models/calender/alarm_model.dart';
import 'package:impo/src/models/calender/cell_item.dart';
import 'package:impo/src/models/calender/grid_item.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/home/tabs/calender/calender_generator_en.dart';
import 'package:impo/src/screens/home/tabs/calender/note_list_screen.dart';
import 'package:impo/src/singleton/alarm_manager_init.dart';
import 'package:impo/src/singleton/notification_init.dart';
import 'package:impo/src/screens/home/tabs/calender/calender_generator_fa.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/models/expert/upload_file_model.dart';
import '../../firebase_analytics_helper.dart';

DashBoardMessageAndNotifyViewModel topMessage = DashBoardMessageAndNotifyViewModel();

class CalenderPresenter{

  late CalenderView _calenderView;

  late CalenderModel _calenderModel =  CalenderModel();

  late AnimationController animationControllerDialog;

  CalenderPresenter(CalenderView view){

    this._calenderView = view;

  }


  CycleViewModel? lastCircle;
  CycleViewModel? selectedCircle;


  final listGirdItems = BehaviorSubject<List<GirdItem>>.seeded([]);
  final bigText = BehaviorSubject<String>.seeded('روز عادی');
  // final smallText = BehaviorSubject<String>.seeded('');
  final colorBigText = BehaviorSubject<Shader>();
  final indexMoon = BehaviorSubject<int>.seeded(0);
  final dialogScale = BehaviorSubject<double>.seeded(0.0);
  final isShowDialog = BehaviorSubject<bool>.seeded(false);
  final isTodayCircle = BehaviorSubject<bool>.seeded(true);
  final todayDateText = BehaviorSubject<String>.seeded('');
  final todayDate = BehaviorSubject<String>.seeded('');
  final isShowDeleteNoteDialog = BehaviorSubject<bool>.seeded(false);
  final listAlarms = BehaviorSubject<List<AlarmViewModel>>.seeded([]);
  final isShowCanDrawOverlaysDialog = BehaviorSubject<bool>.seeded(false);
  final isOpenPanel = BehaviorSubject<bool>.seeded(false);
  final isAlarm = BehaviorSubject<bool>.seeded(false);
  final isAlarmNote = BehaviorSubject<bool>.seeded(false);
  final todayTextForNoteListScreen = BehaviorSubject<String>.seeded('');
  final uploadFiles = BehaviorSubject<List<UploadFileModel>>.seeded([]);
  final sendValuePercentUploadFile = BehaviorSubject<double>.seeded(0);
  final isLoadingButton = BehaviorSubject<bool>.seeded(false);
  final countNotReadMsg = BehaviorSubject<int>.seeded(0);
  final startCycleSelected = BehaviorSubject<Jalali>();
  final endPeriodSelected = BehaviorSubject<Jalali>();
  final endCycleSelected = BehaviorSubject<Jalali>();
  final selectedPeriodDay = BehaviorSubject<int>.seeded(0);
  final selectedCycleDay = BehaviorSubject<int>.seeded(0);
  final advertis = BehaviorSubject<AdvertiseViewModel>();
  final randomMessage = BehaviorSubject<DashBoardMessageAndNotifyViewModel>();
  final isLoading = BehaviorSubject<bool>.seeded(false);
  final heightCalendar = BehaviorSubject<int>.seeded(550);


  Stream<List<GirdItem>> get listGirdItemsObserve => listGirdItems.stream;
  Stream<String> get bigTextObserve => bigText.stream;
  // Stream<String> get smallTextObserve => smallText.stream;
  Stream<Shader> get colorBigTextObserve => colorBigText.stream;
  Stream<int> get indexMoonObserve => indexMoon.stream;
  Stream<double> get dialogScaleObserve => dialogScale.stream;
  Stream<bool> get isShowDialogObserve => isShowDialog.stream;
  Stream<bool> get isTodayCircleObserve => isTodayCircle.stream;
  Stream<String> get todayDateTextObserve => todayDateText.stream;
  Stream<String> get todayDateObserve => todayDate.stream;
  Stream<bool> get isShowDeleteNoteDialogObserve => isShowDeleteNoteDialog.stream;
  Stream<List<AlarmViewModel>> get listAlarmsObserve => listAlarms.stream;
  Stream<bool> get isShowCanDrawOverlaysDialogObserve => isShowCanDrawOverlaysDialog.stream;
  Stream<bool> get isOpenPanelObserve => isOpenPanel.stream;
  Stream<bool> get isAlarmObserve => isAlarm.stream;
  Stream<bool> get isAlarmNoteObserve => isAlarmNote.stream;
  Stream<String> get todayTextForNoteListScreenObserve =>todayTextForNoteListScreen.stream;
  Stream<List<UploadFileModel>> get uploadFilesObserve => uploadFiles.stream;
  Stream<double> get sendValuePercentUploadFileObserve => sendValuePercentUploadFile.stream;
  Stream<bool> get isLoadingButtonObserve => isLoadingButton.stream;
  Stream<int> get countNotReadMsgObserve => countNotReadMsg.stream;
  Stream<Jalali> get startCycleSelectedObserve => startCycleSelected.stream;
  Stream<Jalali> get endPeriodSelectedObserve => endPeriodSelected.stream;
  Stream<Jalali> get endCycleSelectedObserve => endCycleSelected.stream;
  Stream<int> get selectedPeriodDayObserve => selectedPeriodDay.stream;
  Stream<int> get selectedCycleDayObserve => selectedCycleDay.stream;
  Stream<AdvertiseViewModel> get advertisObserve => advertis.stream;
  Stream<DashBoardMessageAndNotifyViewModel> get randomMessageObserve =>  randomMessage.stream;
  Stream<bool> get isLoadingObserve => isLoading.stream;
  Stream<int> get heightCalendarObserve => heightCalendar.stream;


  DateTime? dateAddNote;

  late DateTime backupDateAddNote;

  List<AlarmViewModel> _listAlarms = [];

  List<GirdItem> girdItem = [];

  late AlarmViewModel selectedAlarm;


  int? indexSelectedAlarm ;

  late BuildContext buildContext;

  // PanelController panelController;

  String _todayDateString = '';

  List<UploadFileModel> _uploadFiles = [];

  DateTime now = DateTime.now();

  Dio _dio = new Dio();

  int indexCellItem = 0;

  List<CycleViewModel> defaultCycles = [];


  late DateTime currentStartCircle;
  late DateTime currentEndCircle;
  late DateTime currentEndPeriod;
  late int currentCycleDays;
  late int currentPeriodDays;

  Future<List<AlarmViewModel>?> getAllAlarms()async{
    List<AlarmViewModel>? list = await _calenderModel.getAllAlarms();
    return list;
  }

  initPanelController()async{
    // panelController =  PanelController();
    /// if(selectedAlarm != null){
    ///   if(selectedAlarm.serverId != '' && selectedAlarm.readFlag == 0 && selectedAlarm.mode == 2){
    ///    readNotPartner();
    ///   }
    /// }
    _uploadFiles.clear();
    if(!uploadFiles.isClosed){
      uploadFiles.sink.add(_uploadFiles);
    }
    RegisterParamViewModel register = _calenderModel.getRegisters();
    if(register.calendarType == 1){

      final DateFormat formatter = DateFormat('dd LLL yyyy','fa');
      DateTime now = DateTime.now();
      if(_todayDateString == '') _todayDateString = '${now.year}/${now.month.toString().padLeft(2,'0')}/${now.day.toString().padLeft(2,'0')}';
      if(!todayDate.isClosed){
        todayDate.sink.add(_todayDateString);
      }
      List splitDate = _todayDateString.split('/');
      DateTime dateTime = DateTime(int.parse(splitDate[0]),int.parse(splitDate[1]),int.parse(splitDate[2]));
      dateAddNote = dateTime;
      if(!todayTextForNoteListScreen.isClosed){
        todayTextForNoteListScreen.sink.add(formatter.format(dateTime));
      }

    }else{

      Jalali now = Jalali.now();
      if(_todayDateString == '') _todayDateString = '${now.year}/${now.month.toString().padLeft(2,'0')}/${now.day.toString().padLeft(2,'0')}';
      if(!todayDate.isClosed){
        todayDate.sink.add(_todayDateString);
      }


      List splitDate = _todayDateString.split('/');
      Jalali jalali = Jalali(int.parse(splitDate[0]),int.parse(splitDate[1]),int.parse(splitDate[2]));
      dateAddNote = jalali.toDateTime();
      if(!todayTextForNoteListScreen.isClosed){
        todayTextForNoteListScreen.sink.add(format1(Jalali.fromDateTime(dateAddNote!)));
      }
    }
  }

  initFiles(){
    _uploadFiles.clear();
      if(selectedAlarm.fileName != ''){
        _uploadFiles.add(
            UploadFileModel.fromJson(
                {
                  'name' : selectedAlarm.fileName,
                  'type' : 0,
                  'fileNameForSend' : selectedAlarm.fileName,
                  'stateUpload' : 1,
                  'fileName' : PickedFile('$mediaUrl/file/${selectedAlarm.fileName}')
                }
            )
        );
      }
    // }
    if(!uploadFiles.isClosed){
      uploadFiles.sink.add(_uploadFiles);
    }
  }

  getRandomMessage(bool isOfflineMode) {
    if (topMessage.text == null) {
      final _random = new Random();
      var allDashboardMessageInfo = locator<AllDashBoardMessageAndNotifyModel>();
      if(!isOfflineMode){
        for(int i=0 ; i<allDashboardMessageInfo.motivalMessages.length ; i++){
          if(allDashboardMessageInfo.motivalMessages[i].isPin!){
            topMessage = allDashboardMessageInfo.motivalMessages[i];
            break;
          }
        }
      }
      if(topMessage.text == null){
        topMessage = allDashboardMessageInfo.motivalMessages[
        _random.nextInt(allDashboardMessageInfo.motivalMessages.length - 1)];
      }
    }
    if(!randomMessage.isClosed){
      randomMessage.sink.add(topMessage);
    }
  }


  openDateTimePicker(context,calenderPresenter)async{
    // await panelController.open();
    AnalyticsHelper().log(AnalyticsEvents.NotePg_SetTheDate_Btn_Clk);
    showModalBottomSheet<void>(
      context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (BuildContext context) {
          return CustomDateTimePicker(
            calenderPresenter: calenderPresenter,
          );
        }
    );
  }

  closeDateTimePicker(context)async{
    // if(!isOpenPanel.isClosed){
    //   isOpenPanel.sink.add(false);
    // }
    // await panelController.close();
    Navigator.pop(context);
  }

  // Future closeDb()async{
  //   await _calenderModel.closeDb();
  // }


  initialDialogScale(_this){
    animationControllerDialog = AnimationController(
        vsync: _this,
        lowerBound: 0.0,
        upperBound: 1,
        duration: Duration(milliseconds: 250));
    animationControllerDialog.addListener(() {
      dialogScale.sink.add(animationControllerDialog.value);
    });
  }

  getAdvertise(){
    var advertiseInfo = locator<AdvertiseModel>();
    List<AdvertiseViewModel> allAds = advertiseInfo.advertises;
    List<AdvertiseViewModel> calendardUpAds = [];
    AdvertiseViewModel? showAds;
    if(allAds.length != 0){
      for(int i=0 ; i<allAds.length ; i++){
        if(allAds[i].place == 1){
          calendardUpAds.add(allAds[i]);
        }
      }
      if(calendardUpAds.isNotEmpty){
        if(calendardUpAds.length > 1){
          final _random =  Random();
          showAds = calendardUpAds[_random.nextInt(calendardUpAds.length)];

        }else{
          showAds = calendardUpAds[0];
        }
      }

    }
    if(!advertis.isClosed && showAds != null){
      advertis.sink.add(showAds);
    }
  }


  List<GirdItem> getGridItem(){
    return girdItem;
  }



  loadCircleItems()async{

    List<CycleViewModel> circlesItem =   _calenderModel.getCircleItems();
   List<AlarmViewModel>? listAlarms = await _calenderModel.getAllAlarms();
   RegisterParamViewModel register = _calenderModel.getRegisters();

    // List<CycleViewModel> listCirclesItem =  _calenderModel.getCircleItems();

    lastCircle = circlesItem[circlesItem.length-1];

    girdItem =   register.calendarType == 1 ? CalendarGeneratorEN().getGridList(circlesItem,register.nationality)
    :    CalendarGeneratorFA().getGridList(circlesItem,register.nationality);

//   print(girdItem);
//    print(girdItem[0].persianTitle);
//    print(girdItem[1].persianTitle);
//    print(girdItem[2].persianTitle);

    listGirdItems.sink.add(girdItem);


   for(int i=0 ; i<girdItem.length ; i++){
     for(int j=0 ; j<girdItem[i].cells.length; j++){
       if(girdItem[i].cells[j].getIsToday()){
         setHeightCalendar(girdItem[i].cells);
         selectedCircle = girdItem[i].cells[j].circleItem!;
         girdItem[i].cells[j].isCurrent = true;
         girdItem[i].currents.add(girdItem[i].cells[j].isCurrent);
         indexMoon.sink.add(i);
         changeText(girdItem[i].cells,j,i);
         showChangeCircleButton(girdItem,girdItem[i].cells,i,j);
       }
       if(listAlarms != null){
         for(int k=0 ; k<listAlarms.length ; k++){
           if(listGirdItems.stream.value[i].cells[j].dateTime!.year == DateTime.parse(listAlarms[k].date).year && listGirdItems.stream.value[i].cells[j].dateTime!.month == DateTime.parse(listAlarms[k].date).month && listGirdItems.stream.value[i].cells[j].dateTime!.day == DateTime.parse(listAlarms[k].date).day){
             listGirdItems.stream.value[i].cells[j].isAlarm = true;
             listGirdItems.stream.value[i].cells[j].alarms.add(listAlarms[k]);
           }
           for(int g=0 ; g<listGirdItems.stream.value[i].cells[j].alarms.length; g ++){
             // print(listGirdItems.stream.value[i].cells[j].alarms[g].readFlag);
             if(listGirdItems.stream.value[i].cells[j].alarms[g].readFlag == 0){
               listGirdItems.stream.value[i].cells[j].setReadFlag(false);
               break;
             }
           }
         }
       }
     }
   }


   for(int i=0 ; i<girdItem.length ; i++){
     for(int j=0 ; j<girdItem[i].cells.length ; j++){
       if(!girdItem[i].cells[j].notInMonth && girdItem[i].currents.length == 0){
         girdItem[i].cells[j].isCurrent = true;
         girdItem[i].currents.add(girdItem[i].cells[j].isCurrent);
       }
     }
   }



  }

  setHeightCalendar(List<CellItem> cells){
    List<CellItem> reversedPages = cells.reversed.toList();
    List<CellItem> notInMonths = [];
    for(int i=0 ; i<reversedPages.length ; i++){
      if(reversedPages[i].notInMonth){
        notInMonths.add(reversedPages[i]);
      }else{
        break;
      }
    }
    if(notInMonths.length >= 7 ){
      heightCalendar.sink.add(550);
    }else{
      heightCalendar.sink.add(650);
    }
  }

  checkIsAlarm(){
    DateTime now = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day-1);
    if(dateAddNote == null) dateAddNote =now;
    if(dateAddNote != null){
      if(dateAddNote!.isAfter(now)){
        if(!isAlarmNote.isClosed){
          isAlarmNote.sink.add(true);
        }
      }else{
        if(!isAlarmNote.isClosed){
          isAlarmNote.sink.add(false);
        }
      }
    }
  }


  String format1(Date d) {
    final f = d.formatter;
    var registerInfo = locator<RegisterParamModel>();

    if(registerInfo.register.nationality == 'IR'){
      return "${f.d} ${f.mN} ${f.yyyy}";
    }else{
      return "${f.d} ${f.mnAf} ${f.yyyy}";
    }
  }

  RegisterParamViewModel getRegister(){
    return _calenderModel.getRegisters();
  }

  CycleViewModel getLastCircles(){
    CycleViewModel circles = _calenderModel.getLastCircles();
    return circles;
  }

  changeText(List<CellItem> cellItem,index,_indexMoon){
    indexMoon.sink.add(_indexMoon);
    indexCellItem = index;
    // print('change');

    checkAlarms(cellItem[index].dateTime!);
    // int daysEndOFPeriod,daysStartOfPeriod;

    Timer(Duration(microseconds: 100),(){
      // print(cellItem[index].isAlarm);
      if(cellItem[index].isAlarm){
        isAlarm.sink.add(true);
      }else{
        isAlarm.sink.add(false);
      }
    });


    // if(cellItem[index].circleItem != null){
    //   daysEndOFPeriod =  MyDateTime().myDifferenceDays(cellItem[index].dateTime,DateTime.parse(cellItem[index].circleItem.periodEnd)) + 1;
    //   daysStartOfPeriod = MyDateTime().myDifferenceDays(cellItem[index].dateTime,DateTime.parse(cellItem[index].circleItem.circleEnd)) + 1;
    // }


    setDateTimesForCalendar(cellItem[index].dateTime);

    bigText.sink.add('روز عادی');
//    final Shader linearGradient = LinearGradient(
//      colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
//    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    colorBigText.add(LinearGradient(
      colors: <Color>[ColorPallet().normalDeep, Color(0xff7ea0fc)],
    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)));

    // if(cellItem[index].circleItem != null){
    //   // smallText.sink.add('$daysStartOfPeriod روز تا شروع پریود');
    // }else{
    //   // smallText.sink.add('اطلاعاتی ثبت نشده است');
    // }

     if(cellItem[index].getIsPeriod()){
       bigText.sink.add('پریود');
       // smallText.sink.add('$daysEndOFPeriod روز تا پایان پریود');
       colorBigText.add(LinearGradient(
         colors: <Color>[Color(0xffC33091), Color(0xffFFA3E0)],
       ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)));
     }

     if(cellItem[index].getIsFert()){
       bigText.sink.add('باروری بالا');
       colorBigText.add(LinearGradient(
         colors: <Color>[ Color(0xffFFA3E0),Color(0xff20DFE4)],
       ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)));
       // smallText.sink.add('$daysStartOfPeriod روز تا شروع پریود');
       if(cellItem[index].getIsOvom()){
         // smallText.sink.add('روز تخمک گذاری');
         bigText.sink.add('روز تخمک گذاری');
       }
     }

     if(cellItem[index].getIsPMS()){
       bigText.sink.add('P M S');
       colorBigText.add(LinearGradient(
         colors: <Color>[Color(0xffA684EB), Color(0xff9076C4)],
       ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)));
       // smallText.sink.add('$daysStartOfPeriod روز تا شروع پریود');
     }
     if(cellItem[index].circleItem != null){
       if(cellItem[index].circleItem!.status != 0){
         bigText.sink.add(cellItem[index].circleItem!.textWeek!);
         colorBigText.add(LinearGradient(
           colors:
           cellItem[index].circleItem!.status == 3 ?
             [Color(0xff9BF8FB),Color(0xffAFB3FC)] :
             [ColorPallet().mentalMain,ColorPallet().mentalHigh]
           ,
         ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)));
         if(cellItem[index].dayOfDelivery){
           Jalali deliveryDate = Jalali.fromDateTime(cellItem[index].dateTime!);

           if(getRegister().calendarType == 1){
             final DateFormat formatter = DateFormat('dd LLL','fa');
             bigText.sink.add('${formatter.format(cellItem[index].dateTime!)} - روز زایمان');
           }else{
             bigText.sink.add('${formatDeliveryDate(deliveryDate)} - روز زایمان');
           }
         }
         if(cellItem[index].dayOfAbortion){
           bigText.sink.add('پایان بارداری');
           colorBigText.sink.add(
               LinearGradient(
                 colors: [ColorPallet().gray.withOpacity(0.5),ColorPallet().gray.withOpacity(0.5)]
               ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0))
           );
         }
       }
     }
  }

  String formatDeliveryDate(Date d) {
    final f = d.formatter;
    var registerInfo = locator<RegisterParamModel>();

    if(registerInfo.register.nationality == 'IR'){
      return "${f.d} ${f.mN}";
    }else{
      return "${f.d} ${f.mnAf}";
    }
  }

  setDateTimesForCalendar(dateTime){
    var registerInfo = locator<RegisterParamModel>();
    if(registerInfo.register.calendarType == 1){
      final DateFormat formatter = DateFormat('dd LLL yyyy','fa');
      todayDateText.sink.add(formatter.format(dateTime));
      todayTextForNoteListScreen.sink.add(formatter.format(dateTime));
      todayDate.sink.add('${dateTime.year}/${dateTime.month.toString().padLeft(2,'0')}/${dateTime.day.toString().padLeft(2,'0')}');
    }else{
      if(!todayDateText.isClosed){
        todayDateText.sink.add(format1(Jalali.fromDateTime(dateTime)));
      }
      if(!todayDate.isClosed){
        Jalali shamsi = Jalali.fromDateTime((dateTime));
        todayDate.sink.add('${shamsi.year}/${shamsi.month.toString().padLeft(2,'0')}/${shamsi.day.toString().padLeft(2,'0')}');
      }
      if(!todayTextForNoteListScreen.isClosed){
        todayTextForNoteListScreen.sink.add(format1(Jalali.fromDateTime(dateTime)));
      }
    }

    _todayDateString = todayDate.stream.value;
    dateAddNote = dateTime;
    backupDateAddNote = dateAddNote!;
  }


   Future<bool>checkAlarms(DateTime dateTime)async{
    _listAlarms.clear();
    if(!listAlarms.isClosed){
      listAlarms.sink.add(_listAlarms);
    }
   List<AlarmViewModel>? list = await _calenderModel.getAllAlarms();

   if(list != null){
     for(int i=0 ; i<list.length ; i++){
       if(dateTime.year == DateTime.parse(list[i].date).year && dateTime.month == DateTime.parse(list[i].date).month && dateTime.day == DateTime.parse(list[i].date).day){
         _listAlarms.add(
             list[i]
         );
         // print(_listAlarms.length);
         // print('yess');
         if(!listAlarms.isClosed){
           listAlarms.sink.add(_listAlarms);
         }
       }
     }
   }
   return true;
  }


  onPressChangeCircle(){
    Timer(Duration(milliseconds: 150),()async{
      animationControllerDialog.forward();
      isShowDialog.sink.add(true);
    });
  }

  onPressCancelDialog()async{
    await animationControllerDialog.reverse();
    isShowDialog.sink.add(false);
  }

  showChangeCircleButton(List<GirdItem> girdItem,List<CellItem> cellItem,index,index1){

    selectedCircle = cellItem[index1].circleItem;

    DateTime endCircle = DateTime.parse(lastCircle!.circleEnd!);


        if(cellItem[index1].circleItem != null){
          if(cellItem[index1].dateTime!.isAfter(endCircle)){
            isTodayCircle.sink.add(false);
          }else{
            isTodayCircle.sink.add(true);
          }
        }else{
          isTodayCircle.sink.add(false);
        }

//      if(cellItem[index].isToday){
//        isTodayCircle.sink.add(true);
//      }else{
//        isTodayCircle.sink.add(false);
//      }

  }


  onPressShowDeleteNoteDialog(){
//    mode = 0;
    Timer(Duration(milliseconds: 150),()async{
      animationControllerDialog.forward();
      isShowDeleteNoteDialog.sink.add(true);
    });
  }

  onPressCancelDeleteNoteDialog()async{
    await animationControllerDialog.reverse();
    isShowDeleteNoteDialog.sink.add(false);
  }

  onPressAddNote(String title,String subTitle,bool isActive,TimeOfDay time,int mode,context,CalenderPresenter calenderPresenter,isTwoBack,bool isOfflineMode){
    if (!isLoading.isClosed) {
      isLoading.sink.add(true);
    }
    if (mode == 0) {
      createAlarmCalender(title, subTitle,isActive,time,context,isTwoBack, calenderPresenter,isOfflineMode);
    } else {
      changeAlarmCalender(title, subTitle,isActive,time,context, isTwoBack, calenderPresenter,isOfflineMode);
    }
  }

  Future<bool> createAlarmCalender(String title, String text,bool isActive,TimeOfDay time,context, isTwoBack, calenderPresenter,bool isOfflineMode) async {
    var registerInfo = locator<RegisterParamModel>();
    // print(dateTime);
    String selectedDateTime = DateTime(
        dateAddNote!.year,
        dateAddNote!.month,
        dateAddNote!.day,
        time.hour,time.minute).toString();
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'date/note',
        'PUT',
        {
          "title": title,
          "text": text,
          "dateTime": selectedDateTime,
          "reminder": isActive
        },
        registerInfo.register.token!);
    // print(responseBody);
    if (responseBody != null) {
      if (responseBody.isNotEmpty) {
        if (responseBody['isValid']) {
          succeedCreateNote(title,text,isActive,time,responseBody['id'], context, isTwoBack, calenderPresenter,isOfflineMode);
        } else {
          if (!isLoading.isClosed) {
            isLoading.sink.add(false);
          }
          showToast(context, 'امکان افزودن یادداشت وجود ندارد');
        }
      } else {
        if (!isLoading.isClosed) {
          isLoading.sink.add(false);
        }
        showToast(context,
            'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
      }
    } else {
      if (!isLoading.isClosed) {
        isLoading.sink.add(false);
      }
      showToast(context,
          'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }
    return true;
  }

  succeedCreateNote(title, text,bool isActive,TimeOfDay time,id, context, isTwoBack, calenderPresenter,bool isOfflineMode)async{
    await _calenderModel.insertAlarmsToLocal(
        {
          'date' : dateAddNote.toString(),
          'hour' : time.hour,
          'minute' : time.minute,
          'text' : title,
          'description' : text,
          'IsActive' : isActive ? 1 : 0,
          'fileName' : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileNameForSend : '',
          'isChange' : 0,
          'mode' : 0,
          'readFlag' : 1,
          'serverId' : id
        }
    );

    Timer(Duration(milliseconds: 20),()async{
      List<AlarmViewModel>? allListAlarms = await _calenderModel.getAllAlarms();
      /// if(isPartner){
      ///   for(int i=0 ; i<_listAlarms.length ; i++){
      ///     if(_listAlarms[i].id == allListAlarms[allListAlarms.length-1].id){
      ///       _listAlarms[i].serverId = serverId;
      ///     }
      ///   }
      /// }
      // print('idddddddddddddddddddddddddddddddddddddd');
      // print(allListAlarms![allListAlarms.length-1].id);
      _listAlarms.add(
          AlarmViewModel.fromJson(
              {
                'id' : allListAlarms![allListAlarms.length-1].id,
                'date' : dateAddNote.toString(),
                'hour' : time.hour,
                'minute' : time.minute,
                'text' : title,
                'description' : text,
                'isActive' : isActive ? 1 : 0,
                'fileName' : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileNameForSend : '',
                // 'fileNameOnDisplay' : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileName.path  : '',
                'mode' : 0,
                'readFlag' : 1,
                'serverId' : id
              }
          )
      );
      if(!listAlarms.isClosed){
        listAlarms.sink..add(_listAlarms);
      }

      if(isActive) setAlarm(allListAlarms[allListAlarms.length-1].id,title,text,dateAddNote!,time);

      for(int i=0 ; i<listGirdItems.stream.value.length ; i++){
        for(int j=0 ; j<listGirdItems.stream.value[i].cells.length; j++){

          if(listGirdItems.stream.value[i].cells[j].dateTime!.year == dateAddNote!.year && listGirdItems.stream.value[i].cells[j].dateTime!.month == dateAddNote!.month && listGirdItems.stream.value[i].cells[j].dateTime!.day == dateAddNote!.day){
            List<AlarmViewModel>? allListAlarms = await _calenderModel.getAllAlarms();
            girdItem[i].cells[j].isAlarm = true;
            girdItem[i].cells[j].addAlarms(
                AlarmViewModel.fromJson(
                    {
                      'id' : allListAlarms![allListAlarms.length-1].id,
                      'date' : dateAddNote.toString(),
                      'hour' : time.hour,
                      'minute' : time.minute,
                      'text' : title,
                      'description' : text,
                      'isActive' : isActive ? 1 : 0,
                      'fileName' : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileNameForSend : '',
                      // 'fileNameOnDisplay' : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileName.path: '',
                      'mode' :  0,
                      'readFlag' : 1,
                      'serverId' : id
                    }
                )
            );
            if(dateAddNote == backupDateAddNote){
              isAlarm.sink.add(true);
            }
            if(!listGirdItems.isClosed){
              listGirdItems.sink.add(girdItem);
            }
          }
        }
      }
      /// if(isPartner){
      ///   if(!isLoadingButton.isClosed){
      ///     isLoadingButton.sink.add(false);
      ///   }
      ///   _uploadFiles.clear();
      ///   if(!uploadFiles.isClosed){
      ///     uploadFiles.sink.add(_uploadFiles);
      ///   }
      /// }
      if (!isLoading.isClosed) {
        isLoading.sink.add(false);
      }
      Navigator.push(context,
          PageTransition(
              type: PageTransitionType.fade,
              child:  NoteListScreen(
                calenderPresenter: calenderPresenter,
                isTwoBack: isTwoBack,
                isOfflineMode: isOfflineMode,
              )
          )
      );
      // }
    });

    // _listAlarms.add(AlarmViewModel.fromJson({
    //   'id' : allListAlarms[allListAlarms.length-1].id,
    //   'date' : dateAddNote.toString(),
    //   'hour' : time.hour,
    //   'minute' : time.minute,
    //   'text' : title,
    //   'description' : text,
    //   'isActive' : isActive ? 1 : 0,
    //   'fileName' : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileNameForSend : '',
    //   // 'fileNameOnDisplay' : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileName.path  : '',
    //   'mode' : 0,
    //   'readFlag' : 1,
    //   'serverId' : id
    // }));
    // if (!listAlarms.isClosed) {
    //   listAlarms.sink..add(_listAlarms);
    // }
    //
    // for (int i = 0; i < listGirdItems.stream.value.length; i++) {
    //   for (int j = 0; j < listGirdItems.stream.value[i].cells.length; j++) {
    //     if (listGirdItems.stream.value[i].cells[j].dateTime.year ==
    //         dateAddNote.year &&
    //         listGirdItems.stream.value[i].cells[j].dateTime.month ==
    //             dateAddNote.month &&
    //         listGirdItems.stream.value[i].cells[j].dateTime.day ==
    //             dateAddNote.day) {
    //       girdItem[i].cells[j].isAlarm = true;
    //       girdItem[i].cells[j].addAlarms(AlarmViewModel.fromJson({
    //         'noteId': id,
    //         'date': dateAddNote.toString(),
    //         'title': title,
    //         'description': text,
    //         'fileName': '',
    //       }));
    //       if (dateAddNote == backupDateAddNote) {
    //         isAlarm.sink.add(true);
    //       }
    //       if (!listGirdItems.isClosed) {
    //         listGirdItems.sink.add(girdItem);
    //       }
    //     }
    //   }
    // }
    // if (!isLoading.isClosed) {
    //   isLoading.sink.add(false);
    // }
    // Navigator.push(
    //     context,
    //     PageTransition(
    //         type: PageTransitionType.fade,
    //         child: NoteListScreen(
    //           calenderPresenter: calenderPresenter,
    //           isTwoBack: isTwoBack,
    //         )));
  }

  Future<bool> changeAlarmCalender(String title, String text,bool isActive,TimeOfDay time,context, isTwoBack, calenderPresenter,bool isOfflineMode) async {
    var registerInfo = locator<RegisterParamModel>();
    String selectedDateTime = DateTime(
        dateAddNote!.year,
        dateAddNote!.month,
        dateAddNote!.day,
        time.hour,time.minute).toString();
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'date/note',
        'POST',
        {
          "noteId": selectedAlarm.serverId,
          "title": title,
          "text": text,
          "dateTime": selectedDateTime,
          "reminder": isActive
        },
        registerInfo.register.token!);
    // print(responseBody);
    if (responseBody != null) {
      if (responseBody.isNotEmpty) {
        if (responseBody['isValid']) {
          succeedChangeNote(title, text,isActive,time,context, isTwoBack, calenderPresenter,isOfflineMode);
        } else {
          if (!isLoading.isClosed) {
            isLoading.sink.add(false);
          }
          showToast(context, 'امکان نغییر یادداشت وجود ندارد');
        }
      } else {
        if (!isLoading.isClosed) {
          isLoading.sink.add(false);
        }
        showToast(context,
            'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
      }
    } else {
      if (!isLoading.isClosed) {
        isLoading.sink.add(false);
      }
      showToast(context,
          'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }
    return true;
  }

  succeedChangeNote(title, text,bool isActive,TimeOfDay time,context, isTwoBack, calenderPresenter,bool isOfflineMode)async{

    await _calenderModel.updateTable(
        'Alarms',
        {
          'serverId' : selectedAlarm.serverId,
          'date' : dateAddNote.toString(),
          'hour' : time.hour,
          'minute' : time.minute,
          'text' : title,
          'description' : text,
          'isActive' : isActive ? 1 : 0,
          'fileName' : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileNameForSend : '',
          // 'fileNameOnDisplay' : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileName.path  : '',
          'isChange' : 0,
          'mode' : 0,
          'readFlag' : 1

        },
        selectedAlarm.id
    );

    int i = _listAlarms[indexSelectedAlarm!].id;
    _listAlarms.removeAt(indexSelectedAlarm!);
    _listAlarms.insert(
        indexSelectedAlarm!,
        AlarmViewModel.fromJson(
            {
              'id' : i,
              'date' : dateAddNote.toString(),
              'hour' : time.hour,
              'minute' : time.minute,
              'text' : title,
              'description' : text,
              'isActive' : isActive ? 1 : 0,
              'fileName' : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileNameForSend : '',
              // 'fileNameOnDisplay' : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileName.path : '',
              'mode' : 0,
              'serverId' : selectedAlarm.serverId,
              'readFlag' : 1
            }
        )
    );

    if(!listAlarms.isClosed){
      listAlarms.sink..add(_listAlarms);
    }

    /// if(!isPartner){
      if(Platform.isIOS){
        await NotificationInit.getGlobal().getNotify().cancel(int.parse('100$i'));
      }
      else{
        AndroidAlarmManager.cancel(int.parse('100$i'));
      }
    /// }

    if(isActive) setAlarm(i,title,text,dateAddNote!,time);

    /// if(isPartner){
    ///   if(!isLoadingButton.isClosed){
    ///     isLoadingButton.sink.add(false);
    ///   }
    ///   _uploadFiles.clear();
    ///   if(!uploadFiles.isClosed){
    ///     uploadFiles.sink.add(_uploadFiles);
    ///   }
    ///
    /// }
    if (!isLoading.isClosed) {
      isLoading.sink.add(false);
    }
    Navigator.pushReplacement(context,
        PageTransition(
            type: PageTransitionType.fade,
            child:  new NoteListScreen(
              calenderPresenter: calenderPresenter,
              isTwoBack: isTwoBack,
              isOfflineMode: isOfflineMode,
            )
        )
    );


    // var alarmInfo = locator<AlarmModel>();
    // alarmInfo.removeAlarm(selectedAlarm.noteId);
    // alarmInfo.addAlarm({
    //   'title': title,
    //   'description': text,
    //   'date': dateAddNote.toString(),
    //   'noteId': selectedAlarm.noteId,
    //   'fileName': ''
    // });
    //
    // _listAlarms.removeAt(indexSelectedAlarm);
    // _listAlarms.insert(
    //     indexSelectedAlarm,
    //     AlarmViewModel.fromJson({
    //       'noteId': selectedAlarm.noteId,
    //       'date': dateAddNote.toString(),
    //       'title': title,
    //       'description': text,
    //       'fileName': '',
    //     }));
    //
    // if (!listAlarms.isClosed) {
    //   listAlarms.sink..add(_listAlarms);
    // }
    //
    // if (!isLoading.isClosed) {
    //   isLoading.sink.add(false);
    // }
    // Navigator.pushReplacement(
    //     context,
    //     PageTransition(
    //         type: PageTransitionType.fade,
    //         child: new NoteListScreen(
    //           calenderPresenter: calenderPresenter,
    //           isTwoBack: isTwoBack,
    //         )));
  }

  // addNote(String title,String subTitle,bool isActive,TimeOfDay time,int mode,context,CalenderPresenter calenderPresenter,isTwoBack,String serverId)async{
  //
  //   if(mode == 0){
  //     await _calenderModel.insertAlarmsToLocal(
  //         {
  //           'date' : dateAddNote.toString(),
  //           'hour' : time.hour,
  //           'minute' : time.minute,
  //           'text' : title,
  //           'description' : subTitle,
  //           'IsActive' : isActive ? 1 : 0,
  //           'fileName' : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileNameForSend : '',
  //           'isChange' : 0,
  //           'mode' : isPartner ? 1 : 0,
  //           'readFlag' : 1,
  //           'serverId' : serverId
  //         }
  //     );
  //
  //     Timer(Duration(milliseconds: 20),()async{
  //       List<AlarmViewModel> allListAlarms = await _calenderModel.getAllAlarms();
  //       if(isPartner){
  //         for(int i=0 ; i<_listAlarms.length ; i++){
  //           if(_listAlarms[i].id == allListAlarms[allListAlarms.length-1].id){
  //             _listAlarms[i].serverId = serverId;
  //           }
  //         }
  //       }
  //       _listAlarms.add(
  //           AlarmViewModel.fromJson(
  //               {
  //                 'id' : allListAlarms[allListAlarms.length-1].id,
  //                 'date' : dateAddNote.toString(),
  //                 'hour' : time.hour,
  //                 'minute' : time.minute,
  //                 'text' : title,
  //                 'description' : subTitle,
  //                 'isActive' : isActive ? 1 : 0,
  //                 'fileName' : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileNameForSend : '',
  //                 // 'fileNameOnDisplay' : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileName.path  : '',
  //                 'mode' : isPartner ? 1 : 0,
  //                 'readFlag' : 1,
  //                 'serverId' : serverId
  //               }
  //           )
  //       );
  //       if(!listAlarms.isClosed){
  //         listAlarms.sink..add(_listAlarms);
  //       }
  //
  //       if(isActive) setAlarm(allListAlarms[allListAlarms.length-1].id,title, subTitle,dateAddNote,time);
  //
  //       for(int i=0 ; i<listGirdItems.stream.value.length ; i++){
  //         for(int j=0 ; j<listGirdItems.stream.value[i].cells.length; j++){
  //
  //           if(listGirdItems.stream.value[i].cells[j].dateTime.year == dateAddNote.year && listGirdItems.stream.value[i].cells[j].dateTime.month == dateAddNote.month && listGirdItems.stream.value[i].cells[j].dateTime.day == dateAddNote.day){
  //             List<AlarmViewModel> allListAlarms = await _calenderModel.getAllAlarms();
  //             girdItem[i].cells[j].isAlarm = true;
  //             girdItem[i].cells[j].addAlarms(
  //                 AlarmViewModel.fromJson(
  //                     {
  //                       'id' : allListAlarms[allListAlarms.length-1].id,
  //                       'date' : dateAddNote.toString(),
  //                       'hour' : time.hour,
  //                       'minute' : time.minute,
  //                       'text' : title,
  //                       'description' : subTitle,
  //                       'isActive' : isActive ? 1 : 0,
  //                       'fileName' : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileNameForSend : '',
  //                       // 'fileNameOnDisplay' : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileName.path: '',
  //                       'mode' : isPartner ? 1 : 0,
  //                       'readFlag' : 1,
  //                       'serverId' : serverId
  //                     }
  //                 )
  //             );
  //             if(dateAddNote == backupDateAddNote){
  //               isAlarm.sink.add(true);
  //             }
  //             if(!listGirdItems.isClosed){
  //               listGirdItems.sink.add(girdItem);
  //             }
  //           }
  //         }
  //       }
  //         if(isPartner){
  //           if(!isLoadingButton.isClosed){
  //             isLoadingButton.sink.add(false);
  //           }
  //           _uploadFiles.clear();
  //           if(!uploadFiles.isClosed){
  //             uploadFiles.sink.add(_uploadFiles);
  //           }
  //         }
  //       // Navigator.pop(context);
  //         Navigator.push(context,
  //             PageTransition(
  //                 type: PageTransitionType.fade,
  //                 child:  NoteListScreen(
  //                   calenderPresenter: calenderPresenter,
  //                   isTwoBack: isTwoBack,
  //                   defaultTab: isPartner ? 1 : null,
  //                 )
  //             )
  //         );
  //       // }
  //     });
  //
  //   }else{
  //
  //     await _calenderModel.updateTable(
  //         'Alarms',
  //         {
  //           'serverId' : selectedAlarm.serverId,
  //           'date' : dateAddNote.toString(),
  //           'hour' : time.hour,
  //           'minute' : time.minute,
  //           'text' : title,
  //           'description' : subTitle,
  //           'isActive' : isActive ? 1 : 0,
  //           'fileName' : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileNameForSend : '',
  //           // 'fileNameOnDisplay' : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileName.path  : '',
  //           'isChange' : 1,
  //           'mode' : selectedAlarm.mode,
  //           'readFlag' : 1
  //
  //         },
  //         selectedAlarm.id
  //     );
  //
  //     int i = _listAlarms[indexSelectedAlarm].id;
  //     _listAlarms.removeAt(indexSelectedAlarm);
  //     _listAlarms.insert(
  //       indexSelectedAlarm,
  //         AlarmViewModel.fromJson(
  //             {
  //               'id' : i,
  //               'date' : dateAddNote.toString(),
  //               'hour' : time.hour,
  //               'minute' : time.minute,
  //               'text' : title,
  //               'description' : subTitle,
  //               'isActive' : isActive ? 1 : 0,
  //               'fileName' : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileNameForSend : '',
  //               // 'fileNameOnDisplay' : uploadFiles.stream.value.length != 0 ? uploadFiles.stream.value[0].fileName.path : '',
  //               'mode' : selectedAlarm.mode,
  //               'serverId' : selectedAlarm.serverId,
  //               'readFlag' : 1
  //             }
  //         )
  //     );
  //
  //     if(!listAlarms.isClosed){
  //       listAlarms.sink..add(_listAlarms);
  //     }
  //
  //     if(!isPartner){
  //       if(Platform.isIOS){
  //         await NotificationInit.getGlobal().getNotify().cancel(int.parse('100$i'));
  //       }
  //       else{
  //         AndroidAlarmManager.cancel(int.parse('100$i'));
  //       }
  //     }
  //
  //     if(isActive) setAlarm(i,title, subTitle,dateAddNote,time);
  //
  //       if(isPartner){
  //         if(!isLoadingButton.isClosed){
  //           isLoadingButton.sink.add(false);
  //         }
  //         _uploadFiles.clear();
  //         if(!uploadFiles.isClosed){
  //           uploadFiles.sink.add(_uploadFiles);
  //         }
  //
  //       }
  //     Navigator.pushReplacement(context,
  //         PageTransition(
  //             type: PageTransitionType.fade,
  //             child:  new NoteListScreen(
  //               calenderPresenter: calenderPresenter,
  //               isTwoBack: isTwoBack,
  //               defaultTab: isPartner ? 1 : null,
  //             )
  //         )
  //     );
  //
  //   }
  //
  //
  // }

  Future<bool> checkCanDrawOverlays()async{
    if(Platform.isIOS){
      return true;
    }else{
      return await ActionManageOverlay.canDrawOverlays;
    }
  }

  // onPressDeleteNote(context,isPartner, calenderPresenter, isTwoBack){
  //   if(isPartner){
  //     deleteNoteForPartner(selectedAlarm.serverId,context, calenderPresenter, isTwoBack);
  //   }else{
  //     deleteNote(context, isPartner, calenderPresenter, isTwoBack);
  //   }
  // }

  Future<bool> deleteAlarmCalender(context, calenderPresenter, isTwoBack,bool isOfflineMode) async {
    if (!isLoadingButton.isClosed) {
      isLoadingButton.sink.add(true);
    }
    var registerInfo = locator<RegisterParamModel>();
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'date/note',
        'DELETE',
        {
          "noteId": selectedAlarm.serverId,
        },
        registerInfo.register.token!);
    if (responseBody != null) {
      if (responseBody.isNotEmpty) {
        if (responseBody['isValid']) {
          succeedDeleteNote(context, calenderPresenter, isTwoBack,isOfflineMode);
        } else {
          if (!isLoadingButton.isClosed) {
            isLoadingButton.sink.add(false);
          }
          showToast(context, 'امکان حذف یادداشت وجود ندارد');
        }
      } else {
        if (!isLoadingButton.isClosed) {
          isLoadingButton.sink.add(false);
        }
        showToast(context,
            'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
      }
    } else {
      if (!isLoadingButton.isClosed) {
        isLoadingButton.sink.add(false);
      }
      showToast(context,
          'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }
    return true;
  }

  succeedDeleteNote(context, calenderPresenter, isTwoBack,bool isOfflineMode) async {

    print('delteid${selectedAlarm.serverId}');

    _calenderModel.removeRecord('Alarms', selectedAlarm.id);

    /// if(selectedAlarm.serverId != '' && !isPartner){
    ///   _calenderModel.insertToRemoveTable(
    ///       {
    ///         "mode" : 0,
    ///         "serverId" : selectedAlarm.serverId
    ///       }
    ///   );
    /// }

    _listAlarms.removeAt(indexSelectedAlarm!);

    if(!listAlarms.isClosed){
      listAlarms.sink.add(_listAlarms);
    }


    for(int i=0 ; i<listGirdItems.stream.value.length ; i++){
      for(int j=0 ; j<listGirdItems.stream.value[i].cells.length; j++){

        if(listGirdItems.stream.value[i].cells[j].dateTime!.year == dateAddNote!.year && listGirdItems.stream.value[i].cells[j].dateTime!.month == dateAddNote!.month && listGirdItems.stream.value[i].cells[j].dateTime!.day == dateAddNote!.day){
          if(listAlarms.stream.value.length == 0){
            girdItem[i].cells[j].isAlarm = false;
            if(dateAddNote == backupDateAddNote){
              isAlarm.sink.add(false);
            }
          }
          print(dateAddNote);
          print(girdItem[i].cells[j].alarms.length);
          print(girdItem[i].cells[j].dateTime);
          print(indexSelectedAlarm);
          girdItem[i].cells[j].removeAtAlarms(indexSelectedAlarm);
          if(!listGirdItems.isClosed){
            listGirdItems.sink.add(girdItem);
          }
        }
      }
    }
//    }


    /// if(!isPartner){
      if(Platform.isIOS){
        await NotificationInit.getGlobal().getNotify().cancel(int.parse('100${selectedAlarm.id}'));
      }else{
        AndroidAlarmManager.cancel(int.parse('100${selectedAlarm.id}'));
      }
    /// }
    /// if(isPartner){
    ///
    ///   if(!isLoadingButton.isClosed){
    ///     isLoadingButton.sink.add(false);
    ///   }
    ///   _uploadFiles.clear();
    ///   if(!uploadFiles.isClosed){
    ///     uploadFiles.sink.add(_uploadFiles);
    ///   }
    ///
    ///   List<AlarmViewModel> shareNotes = [];
    ///   if(listAlarms.stream.value.length != 0){
    ///     for(int i=0 ; i<listAlarms.stream.value.length ; i++){
    ///       if(listAlarms.stream.value[i].mode == 1){
    ///         shareNotes.add(listAlarms.stream.value[i]);
    ///       }
    ///     }
    ///
    ///     if(shareNotes.length != 0){
    ///       Navigator.pushReplacement(context,
    ///          PageTransition(
    ///               type: PageTransitionType.fade,
    ///               child:  NoteListScreen(
    ///                 calenderPresenter: calenderPresenter,
    ///                 isTwoBack: isTwoBack,
    ///                 defaultTab: isPartner && shareNotes.length != 0 ? 1 : null,
    ///              )
    ///           )
    ///       );
    ///     }else{
    ///       Navigator.of(context).popUntil(ModalRoute.withName("/Page1"));
    ///     }
    ///
    ///   }else{
    ///
    ///     Navigator.of(context).popUntil(ModalRoute.withName("/Page1"));
    ///
    ///   }
    ///
    ///
    /// }else{
    if (!isLoadingButton.isClosed) {
      isLoadingButton.sink.add(false);
    }
      if(listAlarms.stream.value.length != 0){

        Navigator.pushReplacement(context,
            PageTransition(
                type: PageTransitionType.fade,
                child:   NoteListScreen(
                  calenderPresenter: calenderPresenter,
                  isTwoBack: isTwoBack,
                  isOfflineMode : isOfflineMode
                )
            )
        );

      }else{

        Navigator.of(context).popUntil(ModalRoute.withName("/Page1"));

      }
    /// }

    await animationControllerDialog.reverse();
    isShowDeleteNoteDialog.sink.add(false);




//     var alarmInfo = locator<AlarmModel>();
//
//     alarmInfo.removeAlarm(selectedAlarm.noteId);
//
//     _listAlarms.removeAt(indexSelectedAlarm);
//
//     if (!listAlarms.isClosed) {
//       listAlarms.sink.add(_listAlarms);
//     }
//
// //    if(listAlarms.stream.value.length == 0){
//     for (int i = 0; i < listGirdItems.stream.value.length; i++) {
//       for (int j = 0; j < listGirdItems.stream.value[i].cells.length; j++) {
//         if (listGirdItems.stream.value[i].cells[j].dateTime.year ==
//             dateAddNote.year &&
//             listGirdItems.stream.value[i].cells[j].dateTime.month ==
//                 dateAddNote.month &&
//             listGirdItems.stream.value[i].cells[j].dateTime.day ==
//                 dateAddNote.day) {
//           if (listAlarms.stream.value.length == 0) {
//             girdItem[i].cells[j].isAlarm = false;
//             if (dateAddNote == backupDateAddNote) {
//               isAlarm.sink.add(false);
//             }
//           }
//           girdItem[i].cells[j].removeAtAlarms(indexSelectedAlarm);
// //            listGirdItems.stream.value[i].cells[j].alarms.removeAt(indexSelectedAlarm);
//           if (!listGirdItems.isClosed) {
//             listGirdItems.sink.add(girdItem);
//           }
//         }
//       }
//     }
//     if (!isLoading.isClosed) {
//       isLoading.sink.add(false);
//     }
//     if (listAlarms.stream.value.length != 0) {
//       Navigator.pushReplacement(
//           context,
//           PageTransition(
//               type: PageTransitionType.fade,
//               child: NoteListScreen(
//                 calenderPresenter: calenderPresenter,
//                 isTwoBack: isTwoBack,
//               )));
//     } else {
//       Navigator.of(context).popUntil(ModalRoute.withName("/Page1"));
//     }
//
//     await animationControllerDialog.reverse();
//     isShowDeleteNoteDialog.sink.add(false);
  }

//   deleteNote(context,calenderPresenter, isTwoBack)async{
//
//    print('delteid${selectedAlarm.serverId}');
//
//     _calenderModel.removeRecord('Alarms', selectedAlarm.id);
//     // print(selectedAlarm.serverId);
//     if(selectedAlarm.serverId != '' && !isPartner){
//       _calenderModel.insertToRemoveTable(
//         {
//           "mode" : 0,
//           "serverId" : selectedAlarm.serverId
//         }
//       );
//     }
//
//     _listAlarms.removeAt(indexSelectedAlarm);
//
//     if(!listAlarms.isClosed){
//       listAlarms.sink.add(_listAlarms);
//     }
//
// //    if(listAlarms.stream.value.length == 0){
//       for(int i=0 ; i<listGirdItems.stream.value.length ; i++){
//         for(int j=0 ; j<listGirdItems.stream.value[i].cells.length; j++){
//
//           if(listGirdItems.stream.value[i].cells[j].dateTime.year == dateAddNote.year && listGirdItems.stream.value[i].cells[j].dateTime.month == dateAddNote.month && listGirdItems.stream.value[i].cells[j].dateTime.day == dateAddNote.day){
//             if(listAlarms.stream.value.length == 0){
//               girdItem[i].cells[j].isAlarm = false;
//               if(dateAddNote == backupDateAddNote){
//                 isAlarm.sink.add(false);
//               }
//             }
//             girdItem[i].cells[j].removeAtAlarms(indexSelectedAlarm);
// //            listGirdItems.stream.value[i].cells[j].alarms.removeAt(indexSelectedAlarm);
//             if(!listGirdItems.isClosed){
//               listGirdItems.sink.add(girdItem);
//             }
//           }
//         }
//       }
// //    }
//
//
//     if(!isPartner){
//       if(Platform.isIOS){
//         await NotificationInit.getGlobal().getNotify().cancel(int.parse('100${selectedAlarm.id}'));
//       }else{
//         AndroidAlarmManager.cancel(int.parse('100${selectedAlarm.id}'));
//       }
//     }
//
//
//     if(isPartner){
//
//       if(!isLoadingButton.isClosed){
//         isLoadingButton.sink.add(false);
//       }
//       _uploadFiles.clear();
//       if(!uploadFiles.isClosed){
//         uploadFiles.sink.add(_uploadFiles);
//       }
//
//       List<AlarmViewModel> shareNotes = [];
//       if(listAlarms.stream.value.length != 0){
//         for(int i=0 ; i<listAlarms.stream.value.length ; i++){
//           if(listAlarms.stream.value[i].mode == 1){
//             shareNotes.add(listAlarms.stream.value[i]);
//           }
//         }
//
//         if(shareNotes.length != 0){
//           Navigator.pushReplacement(context,
//               PageTransition(
//                   type: PageTransitionType.fade,
//                   child:  NoteListScreen(
//                     calenderPresenter: calenderPresenter,
//                     isTwoBack: isTwoBack,
//                     defaultTab: isPartner && shareNotes.length != 0 ? 1 : null,
//                   )
//               )
//           );
//         }else{
//           Navigator.of(context).popUntil(ModalRoute.withName("/Page1"));
//         }
//
//       }else{
//
//         Navigator.of(context).popUntil(ModalRoute.withName("/Page1"));
//
//       }
//
//
//     }else{
//       if(listAlarms.stream.value.length != 0){
//
//         Navigator.pushReplacement(context,
//             PageTransition(
//                 type: PageTransitionType.fade,
//                 child:   NoteListScreen(
//                   calenderPresenter: calenderPresenter,
//                   isTwoBack: isTwoBack,
//                 )
//             )
//         );
//
//       }else{
//
//         Navigator.of(context).popUntil(ModalRoute.withName("/Page1"));
//
//       }
//     }
//
//     await animationControllerDialog.reverse();
//     isShowDeleteNoteDialog.sink.add(false);
//   }

  setAlarm(int id,String title,String subTitle,DateTime dateTime,TimeOfDay time)async{

    if(Platform.isIOS){


      // var androidChannel = AndroidNotificationDetails(
      //   'alarms$id' , 'channel_name',
      //   channelDescription: 'channel_description',
      //   importance: Importance.max,
      //   priority: Priority.max,
      //   vibrationPattern: Int64List(1000),
      //   largeIcon: DrawableResourceAndroidBitmap('impo_icon'),
      //   icon: "not_icon",
      //   sound: RawResourceAndroidNotificationSound('sound_other'),
      //   styleInformation: BigTextStyleInformation(''),
      // );
      //
      // var iosChannel = DarwinNotificationDetails(
      //   presentSound: true ,
      //   sound: 'sound_other.aiff',
      // );
      //
      // NotificationDetails platformChannel = NotificationDetails(android: androidChannel,iOS: iosChannel);
      // await NotificationInit.getGlobal().getNotify().schedule(
      //   int.parse('100$id'),
      //   title,
      //   subTitle,
      //   DateTime(dateTime.year,dateTime.month,dateTime.day,time.hour,time.minute),
      //   platformChannel,
      //   payload: '$title*$subTitle*یادم نمیره',
      // );

    }else{

      if((DateTime(dateTime.year,dateTime.month,dateTime.day,time.hour,time.minute)).isAfter(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute))){
        // print('set');
        await AndroidAlarmManager.oneShotAt(
            DateTime(dateTime.year,dateTime.month,dateTime.day,time.hour,time.minute),
            int.parse('100$id'),
            callBackAlarms,
            wakeup: true,
            exact: true,
            rescheduleOnReboot: true,
            allowWhileIdle: true,
            sound: 1,
            title: title,
            msg: subTitle,
            dayweek: ""
        );
      }

    }


  }

   setSelectedAlarm(index){
    indexSelectedAlarm = index;
    selectedAlarm = listAlarms.stream.value[index];
  }

  setSelectedNotePartner(AlarmViewModel alarm){
    selectedAlarm = alarm;
    // print(selectedAlarm.id);
    // print(selectedAlarm.serverId);
  }

  showCanDrawOverlaysDialog(){
    AnalyticsHelper().log(AnalyticsEvents.NotePg_PermAlarmCalendar_Dlg_Load);
    Timer(Duration(milliseconds: 50),()async{
      animationControllerDialog.forward();
      if(!isShowCanDrawOverlaysDialog.isClosed){
        isShowCanDrawOverlaysDialog.sink.add(true);
      }
    });
  }

  onPressYesOverlayDialog()async{
    await ActionManageOverlay.goToSettingPermissionOverlay();
    await animationControllerDialog.reverse();
    if(!isShowCanDrawOverlaysDialog.isClosed){
      isShowCanDrawOverlaysDialog.sink.add(false);
    }

  }

  onPressCancelOverlayDialog()async{
    await animationControllerDialog.reverse();
    if(!isShowCanDrawOverlaysDialog.isClosed){
      isShowCanDrawOverlaysDialog.sink.add(false);
    }

  }

  setDateTime(DateTime dateTime,context){
    var registerInfo = locator<RegisterParamModel>();
    closeDateTimePicker(context);
    dateAddNote = dateTime;
    checkIsAlarm();
    checkAlarms(dateAddNote!);
    if(registerInfo.register.calendarType == 1){
      final DateFormat formatter = DateFormat('dd LLL yyyy','fa');
      if(!todayDate.isClosed){
        todayDate.sink.add('${dateTime.year}/${dateTime.month.toString().padLeft(2,'0')}/${dateTime.day.toString().padLeft(2,'0')}');
      }
      if(!todayTextForNoteListScreen.isClosed){
        todayTextForNoteListScreen.sink.add(formatter.format(dateTime));
      }
    }else{
      if(!todayDate.isClosed){
        Jalali shamsi = Jalali.fromDateTime(dateTime);
        todayDate.sink.add('${shamsi.year}/${shamsi.month.toString().padLeft(2,'0')}/${shamsi.day.toString().padLeft(2,'0')}');
      }
      if(!todayTextForNoteListScreen.isClosed){
        todayTextForNoteListScreen.sink.add(format1(Jalali.fromDateTime(dateTime)));
      }
    }
  }

  getFileImage(int type ,bool isChatScreen,context,{String text = '',String chatId = '' })async{
    late PickedFile? file;
    if(type == 2){
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: ['pdf','doc','rtf','dotx','dotm','docm','docx']);

      if(result != null) {
        file = PickedFile(result.files.single.path!);
        _uploadFiles.add(
            UploadFileModel.fromJson(
                {
                  'name' : file.path.split('/').last,
                  'type' : 1,
                  'fileNameForSend' : '',
                  'stateUpload' : 0,
                  'fileName' : file
                }
            )
        );
        if(!uploadFiles.isClosed){
          uploadFiles.sink.add(_uploadFiles);
        }
        // print(file);
      } else {
        // User canceled the picker
      }
    }else{
      // ignore: invalid_use_of_visible_for_testing_member
      file = await ImagePicker.platform.pickImage(source: type == 0 ? ImageSource.gallery : ImageSource.camera);
      // print(file);
      _uploadFiles.add(
          UploadFileModel.fromJson(
              {
                'name' : file!.path.split('/').last,
                'type' : 0,
                'fileNameForSend' : '',
                'stateUpload' : 0,
                'fileName' : file
              }
          )
      );

      if(!uploadFiles.isClosed){
        uploadFiles.sink.add(_uploadFiles);
      }

    }

    uploadFile(file!,isChatScreen,text,chatId,context);

  }

  uploadFile(PickedFile image,bool isChatScreen,String text,String ticketId,context)async{

    _dio = Dio();
    FormData formData = FormData();

    formData.files.addAll(
        [MapEntry('files',MultipartFile.fromFileSync(image.path))]);

    try{

      await _dio.put('$mediaUrl/file/private',data: formData,
          onSendProgress: (int sent, int total){
            // print(sent);
            // print(total);
            sendValuePercentUploadFile.sink.add((sent*100)/total);
          }
      ).
      then((res)async{
        // print(res.statusMessage);
        // print(res.statusCode);
        if(res.statusMessage == 'OK'){
          // print(res.data);
          _uploadFiles.insert(0,
              UploadFileModel.fromJson(
                  {
                    'name' : _uploadFiles[0].name,
                    'type' : _uploadFiles[0].type,
                    'fileNameForSend' : res.data,
                    'stateUpload' : 1,
                    'fileName' : _uploadFiles[0].fileName
                  }
              )
          );
          _uploadFiles.removeAt(1);
          if(!uploadFiles.isClosed){
            uploadFiles.sink.add(_uploadFiles);
          }

          // if(isChatScreen){
          //   onPressSendMessage(text, ticketId);
          // }
        }else{
          if(_uploadFiles.length != 0){
            showToast(context, 'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
            _uploadFiles.removeAt(0);
            if(!uploadFiles.isClosed){
              uploadFiles.sink.add(_uploadFiles);
            }
          }
        }

      });

    }catch(e){

      if(_uploadFiles.length != 0){
        showToast(context, 'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');

        _uploadFiles.removeAt(0);
        if(!uploadFiles.isClosed){
          uploadFiles.sink.add(_uploadFiles);
        }
      }

    }

  }

  showToast(context,message){
    // Fluttertoast.showToast(
    //     msg:message,toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM
    // );
    CustomSnackBar.show(context, message);
  }

  cancelUpload(){
    _uploadFiles.removeAt(0);
    if(!uploadFiles.isClosed){
      uploadFiles.sink.add(_uploadFiles);
    }
    _dio.close(force: true);
  }

  // createNoteForPartner(title,text,context,calenderPresenter,isTwoBack,isActive, time, mode)async{
  //   print('createNoteForPartner');
  //   RegisterParamViewModel register = await _calenderModel.getRegisters();
  //   if(!isLoadingButton.isClosed){
  //     isLoadingButton.sink.add(true);
  //   }
  //
  //   Map<String,dynamic> responseBody = await Http().sendRequest(
  //       womanUrl,
  //       'pairDate/note',
  //       'PUT',
  //       {
  //         "title" : title,
  //         "text" :  text,
  //         "dateTime" :  dateAddNote.toString(),
  //         "reminder" : false,
  //         "fileName" : uploadFiles.stream.value.length != 0 ? [uploadFiles.stream.value[0].fileNameForSend] : []
  //       },
  //       register.token
  //   );
  //   print(responseBody);
  //   if(responseBody != null){
  //     if(responseBody['isValid']){
  //       addNote(title,text,isActive, time, mode, context, calenderPresenter, isTwoBack, true,responseBody['id']);
  //     }else{
  //       if(!isLoadingButton.isClosed){
  //         isLoadingButton.sink.add(false);
  //       }
  //       showToast(context,'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
  //
  //     }
  //   }else{
  //     if(!isLoadingButton.isClosed){
  //       isLoadingButton.sink.add(false);
  //     }
  //     showToast(context,'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
  //   }
  //
  // }
  //
  //
  // changeNoteForPartner(serverId,title,text,context,calenderPresenter,isTwoBack,isActive, time, mode)async{
  //   print(serverId);
  //   RegisterParamViewModel register = await _calenderModel.getRegisters();
  //   if(!isLoadingButton.isClosed){
  //     isLoadingButton.sink.add(true);
  //   }
  //
  //   Map<String,dynamic> responseBody = await Http().sendRequest(
  //       womanUrl,
  //       'pairDate/note',
  //       'POST',
  //       {
  //         "noteId" : serverId,
  //         "title" : title,
  //         "text" :  text,
  //         "dateTime" :  dateAddNote.toString(),
  //         "reminder" : false,
  //         "fileName" : uploadFiles.stream.value.length != 0 ? [uploadFiles.stream.value[0].fileNameForSend] : []
  //       },
  //       register.token
  //   );
  //   print(responseBody);
  //   if(responseBody != null){
  //     if(responseBody['isValid']){
  //
  //       addNote(title,text, isActive, time, mode, context,calenderPresenter, isTwoBack,true, serverId);
  //
  //     }else{
  //       if(!isLoadingButton.isClosed){
  //         isLoadingButton.sink.add(false);
  //       }
  //       showToast(context,'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
  //
  //     }
  //   }else{
  //     if(!isLoadingButton.isClosed){
  //       isLoadingButton.sink.add(false);
  //     }
  //     showToast(context,'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
  //   }
  //
  // }
  //
  //
  // deleteNoteForPartner(serverId,context,calenderPresenter,isTwoBack)async{
  //   print(serverId);
  //   RegisterParamViewModel register = await _calenderModel.getRegisters();
  //   if(!isLoadingButton.isClosed){
  //     isLoadingButton.sink.add(true);
  //   }
  //
  //   Map<String,dynamic> responseBody = await Http().sendRequest(
  //       womanUrl,
  //       'pairDate/note',
  //       'DELETE',
  //       {
  //         "noteId" : serverId,
  //       },
  //       register.token
  //   );
  //   print(responseBody);
  //   if(responseBody != null){
  //     if(responseBody['isValid']){
  //
  //       deleteNote(context,true,calenderPresenter, isTwoBack);
  //
  //     }else{
  //       if(!isLoadingButton.isClosed){
  //         isLoadingButton.sink.add(false);
  //       }
  //       showToast(context,'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
  //
  //     }
  //   }else{
  //     if(!isLoadingButton.isClosed){
  //       isLoadingButton.sink.add(false);
  //     }
  //     showToast(context,'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
  //   }
  //
  // }
  //
  // readNotPartner()async{
  //   RegisterParamViewModel register = await _calenderModel.getRegisters();
  //   Map<String,dynamic> responseBody = await Http().sendRequest(
  //       womanUrl,
  //       'pairDate/read',
  //       'POST',
  //       {
  //         "noteId" : selectedAlarm.serverId,
  //       },
  //       register.token
  //   );
  //   print(responseBody);
  //   if(responseBody != null){
  //     if(responseBody['isValid']){
  //       if(girdItem.isNotEmpty){
  //         if(girdItem[indexMoon.stream.value].cells.isNotEmpty){
  //           if(girdItem[indexMoon.stream.value].cells[indexCellItem].alarms.isNotEmpty){
  //             if(indexSelectedAlarm != null){
  //               girdItem[indexMoon.stream.value].cells[indexCellItem].alarms[indexSelectedAlarm].readFlag = 1;
  //             }
  //           }
  //         }
  //       }
  //       selectedAlarm.readFlag = 1;
  //       print('iddddd : ${selectedAlarm.id}');
  //       _calenderModel.updateTable(
  //           'Alarms',
  //           {
  //             'readFlag' : 1
  //           },
  //           selectedAlarm.id
  //       );
  //       checkNotReadMsg(register.token);
  //     }
  //   }
  // }
  //
  // checkNotReadMsg(String token)async {
  //   Map<String,dynamic> responseBody = await Http().sendRequest(
  //       womanUrl,
  //       'pairDate/notRead',
  //       'GET',
  //       {
  //       },
  //       token
  //   );
  //   print(responseBody);
  //   if (responseBody != null) {
  //     setCountNotReadMdg(responseBody['count']);
  //     if(girdItem.isNotEmpty){
  //       for(int i=0 ; i< girdItem[indexMoon.stream.value].cells[indexCellItem].alarms.length ; i++){
  //         if(girdItem[indexMoon.stream.value].cells[indexCellItem].alarms[i].readFlag == 1){
  //           girdItem[indexMoon.stream.value].cells[indexCellItem].readFlag = true;
  //         }else{
  //           girdItem[indexMoon.stream.value].cells[indexCellItem].readFlag = false;
  //           break;
  //         }
  //       }
  //     }
  //   }
  // }
  //
  //   setCountNotReadMdg(count){
  //   if(!countNotReadMsg.isClosed){
  //     countNotReadMsg.sink.add(count);
  //   }
  // }


  initChangeCycleScreen() async {
    var cycleInfo = locator<CycleModel>();
    CycleViewModel lastCircle = cycleInfo.cycle[cycleInfo.cycle.length - 1];
    currentStartCircle = DateTime.parse(lastCircle.periodStart!);
    currentEndCircle = DateTime.parse(lastCircle.circleEnd!);
    currentEndPeriod = DateTime.parse(lastCircle.periodEnd!);

    if (!startCycleSelected.isClosed) {
      startCycleSelected.sink.add(Jalali.fromDateTime(currentStartCircle));
    }

    if (!endPeriodSelected.isClosed) {
      endPeriodSelected.sink.add(Jalali.fromDateTime(currentEndPeriod));
    }
    currentPeriodDays =
        MyDateTime().myDifferenceDays(currentStartCircle, currentEndPeriod) + 1;
    if (!selectedPeriodDay.isClosed) {
      selectedPeriodDay.sink.add(currentPeriodDays);
    }

    if (!endCycleSelected.isClosed) {
      endCycleSelected.sink.add(Jalali.fromDateTime(currentEndCircle));
    }
    currentCycleDays =
        MyDateTime().myDifferenceDays(currentStartCircle, currentEndCircle) + 1;
    if (!selectedCycleDay.isClosed) {
      selectedCycleDay.sink.add(currentCycleDays);
    }
  }

  onChangedCurrentStartCycle(value, isMilady) {
    print(value);
    if (!startCycleSelected.isClosed) {
      startCycleSelected.sink
          .add(isMilady ? Jalali.fromDateTime(value) : value);
    }
    changeCycleAndPeriodDays();
  }

  onChangedCurrentEndPeriod(value, isMilady) {
    print(value);
    if (!endPeriodSelected.isClosed) {
      endPeriodSelected.sink.add(isMilady ? Jalali.fromDateTime(value) : value);
    }
    changeCycleAndPeriodDays();
  }

  onChangedCurrentEndCycle(value, isMilady) {
    if (!endCycleSelected.isClosed) {
      endCycleSelected.sink.add(isMilady ? Jalali.fromDateTime(value) : value);
    }
    changeCycleAndPeriodDays();
  }

  changeCycleAndPeriodDays() {
    if (!selectedCycleDay.isClosed) {
      selectedCycleDay.sink.add(MyDateTime().myDifferenceDays(
          startCycleSelected.stream.value.toDateTime(),
          endCycleSelected.stream.value.toDateTime()) +
          1);
    }
    if (!selectedPeriodDay.isClosed) {
      selectedPeriodDay.sink.add(MyDateTime().myDifferenceDays(
          startCycleSelected.stream.value.toDateTime(),
          endPeriodSelected.stream.value.toDateTime()) +
          1);
    }
  }

  acceptChangeCycle(context) async {
    print(endPeriodSelected.stream.value);
    if (!isLoading.isClosed) {
      isLoading.sink.add(true);
    }
    DateTime _startCycle = startCycleSelected.stream.value.toDateTime();
    DateTime noww = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
    DateTime _endCycle = _startCycle.add(Duration(days: getRegister().circleDay!- 1));
    print(noww);
    print(_endCycle);
    if(_endCycle.isBefore(noww)){
      _endCycle = noww;
    }

    endCycleSelected.sink.add(Jalali.fromDateTime(_endCycle));

    var cycleInfo = locator<CycleModel>();
    defaultCycles.clear();
    for (int i = 0; i < cycleInfo.cycle.length; i++) {
      defaultCycles.add(CycleViewModel.fromJson({
        'periodStartDate': cycleInfo.cycle[i].periodStart,
        'periodEndDate': cycleInfo.cycle[i].periodEnd,
        'cycleEndDate': cycleInfo.cycle[i].circleEnd,
        'before': cycleInfo.cycle[i].before,
        'after': cycleInfo.cycle[i].after,
        'mental': cycleInfo.cycle[i].mental,
        'other': cycleInfo.cycle[i].other,
        'status' : cycleInfo.cycle[i].status,
        'ovu': cycleInfo.cycle[i].ovu
      }));
    }
    // List<CycleViewModel> defaultCycles = cycleInfo.cycle;
    DateTime now = DateTime.now();
    DateTime _startCycleSelected = startCycleSelected.stream.value.toDateTime();
    int _selectedCycleDay = MyDateTime().myDifferenceDays(
        startCycleSelected.stream.value.toDateTime(),
        endCycleSelected.stream.value.toDateTime()) +
        1;
    int _selectedPeriodDay = MyDateTime().myDifferenceDays(
        startCycleSelected.stream.value.toDateTime(),
        endPeriodSelected.stream.value.toDateTime()) +
        1;
    if (checkPeriodAndCycleDays()) {
      if (_selectedCycleDay <= 60 && _selectedCycleDay >= 20) {
        if (_selectedPeriodDay <= 10 && _selectedPeriodDay >= 2) {
          DateTime endCycle = DateTime(
              _startCycleSelected.year,
              _startCycleSelected.month,
              _startCycleSelected.day + _selectedCycleDay);
          if (now.isBefore(endCycle)) {
            if (_startCycleSelected.isAfter(currentStartCircle)) {
              await checkCyclesForSelectedAfterLastPeriod(_startCycleSelected);
              // await autoBackup(context);
              setCycleCalendar(context);
            } else if (_startCycleSelected.isBefore(currentStartCircle)) {
              await checkCyclesForSelectedBeforeLastPeriod(_startCycleSelected);
              // await autoBackup(context);
              setCycleCalendar(context);
            } else {
              ///noChangeLastPeriod
              var cycleInfo = locator<CycleModel>();
              List<CycleViewModel> circles = cycleInfo.cycle;
              CycleViewModel lastCycle = circles[circles.length - 1];
              cycleInfo.updateCycle(
                  circles.length - 1,
                  CycleViewModel.fromJson({
                    'periodStartDate': lastCycle.periodStart,
                    'periodEndDate': DateTime(
                        _startCycleSelected.year,
                        _startCycleSelected.month,
                        _startCycleSelected.day + (_selectedPeriodDay - 1))
                        .toString(),
                    'cycleEndDate': DateTime(
                        _startCycleSelected.year,
                        _startCycleSelected.month,
                        _startCycleSelected.day + (_selectedCycleDay - 1))
                        .toString(),
                    'status' : lastCycle.status,
                    'before': lastCycle.before,
                    'after': lastCycle.after,
                    'mental': lastCycle.mental,
                    'other': lastCycle.other,
                    'ovu': lastCycle.ovu
                  }));
              // await _calenderModel.updateTable(
              //     'Circles',
              //     {
              //       'isSavedToServer' : 0,
              //       'periodEnd' : DateTime(_startCycleSelected.year,_startCycleSelected.month,_startCycleSelected.day+(_selectedPeriodDay-1)).toString(),
              //       'circleEnd' : DateTime(_startCycleSelected.year,_startCycleSelected.month,_startCycleSelected.day+(_selectedCycleDay-1)).toString()
              //     },
              //     lastCycle.id
              // );
              // await autoBackup(context,randomMessage);
              setCycleCalendar(context);
            }
          } else {
            if (!isLoading.isClosed) {
              isLoading.sink.add(false);
            }
            showToast(context, 'خطا');
          }
        } else {
          if (!isLoading.isClosed) {
            isLoading.sink.add(false);
          }
          showToast(
              context, 'طول پریود نباید کمتر از 2 و بیشتر از 10 روز باشه');
        }
      } else {
        if (!isLoading.isClosed) {
          isLoading.sink.add(false);
        }
        showToast(context, 'طول دوره نباید کمتر از 20 و بیشتر از 60 روز باشه');
      }
    } else {
      if (!isLoading.isClosed) {
        isLoading.sink.add(false);
      }
      showToast(context,
          'لازمه طول دوره یا طول پریودت رو تغییر بدی تا با هم متناسب باشند.');
    }
  }

  bool checkPeriodAndCycleDays() {
    int _cycle = MyDateTime().myDifferenceDays(
        startCycleSelected.stream.value.toDateTime(),
        endCycleSelected.stream.value.toDateTime()) +
        1;
    int _period = MyDateTime().myDifferenceDays(
        startCycleSelected.stream.value.toDateTime(),
        endPeriodSelected.stream.value.toDateTime()) +
        1;

    if (_cycle < 25) {
      if (_cycle == 24 && _period > 9) {
        return false;
      } else if (_cycle == 23 && _period > 8) {
        return false;
      } else if (_cycle == 22 && _period > 7) {
        return false;
      } else if (_cycle == 21 && _period > 6) {
        return false;
      } else if (_cycle == 20 && _period > 5) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  checkCyclesForSelectedAfterLastPeriod(DateTime _selectedLastPeriod) async {
    CycleViewModel item = CycleViewModel();
    List<CycleViewModel> newAddCycle = [];

    int _cycle = MyDateTime().myDifferenceDays(
        startCycleSelected.stream.value.toDateTime(),
        endCycleSelected.stream.value.toDateTime()) +
        1;
    int _period = MyDateTime().myDifferenceDays(
        startCycleSelected.stream.value.toDateTime(),
        endPeriodSelected.stream.value.toDateTime()) +
        1;
    var cycleInfo = locator<CycleModel>();
    List<CycleViewModel> circles = cycleInfo.cycle;
    CycleViewModel lastCycle = circles[circles.length - 1];
    // await _calenderModel.insertToRemoveCircles(
    //     {'myIndex' : circles[circles.length-1].id}
    // );

    // await _calenderModel.removeRecord('Circles', circles[circles.length-1].id);
    item.setPeriodStart(DateTime(_selectedLastPeriod.year,
        _selectedLastPeriod.month, _selectedLastPeriod.day, 23)
        .toString());
    item.setPeriodEnd(DateTime(
        _selectedLastPeriod.year,
        _selectedLastPeriod.month,
        (_selectedLastPeriod.day + _period - 1),
        23)
        .toString());
    item.setCircleEnd(DateTime(
        _selectedLastPeriod.year,
        _selectedLastPeriod.month,
        (_selectedLastPeriod.day + _cycle - 1),
        23)
        .toString());

    // item.setIsSavedToServer(0);
    item.setStatus(0);
    item.setBefore(lastCycle.getBefore());
    item.setAfter(lastCycle.getAfter());
    item.setMental(lastCycle.getMental());
    item.setOther(lastCycle.getOther());
    item.setOvu(lastCycle.getOvu());

    // print(DateTime(_selectedLastPeriod.year,_selectedLastPeriod.month,_selectedLastPeriod.day-1));
    if (circles.length > 1) {
      if(circles[circles.length - 2].status == 0){
        cycleInfo.updateCycle(
            circles.length - 2,
            CycleViewModel.fromJson({
              'periodStartDate': circles[circles.length - 2].periodStart,
              'periodEndDate': circles[circles.length - 2].periodEnd,
              'cycleEndDate': DateTime(_selectedLastPeriod.year,
                  _selectedLastPeriod.month, _selectedLastPeriod.day - 1)
                  .toString(),
              'status' : circles[circles.length - 2].status,
              'before': circles[circles.length - 2].before,
              'after': circles[circles.length - 2].after,
              'mental': circles[circles.length - 2].mental,
              'other': circles[circles.length - 2].other,
              'ovu': circles[circles.length - 2].ovu
            })
        );
      }else if(circles[circles.length - 2].status == 2 && DateTime.parse(circles[circles.length - 2].periodEnd!).year != 3000){
        print('fsdfsdfdf');
        DateTime startDate = DateTime(
            DateTime.parse(circles[circles.length - 2].circleEnd!).year,
            DateTime.parse(circles[circles.length - 2].circleEnd!).month,
            DateTime.parse(circles[circles.length - 2].circleEnd!).day +1
        );
        DateTime endDate = _selectedLastPeriod;
        int totalDays = MyDateTime().myDifferenceDays(startDate, endDate);
        int weeksBreastfeeding = (totalDays~/7)+1;
        for(int i=0 ; i<weeksBreastfeeding ; i++){
          DateTime periodStart =  DateTime(startDate.year, startDate.month, startDate.day + (i  * 7));
          DateTime circleEnd = i == weeksBreastfeeding - 1 ? DateTime(endDate.year,endDate.month,endDate.day - 1) :
          DateTime(startDate.year, startDate.month, startDate.day + (i * 7) + 6);
          newAddCycle.add(
              CycleViewModel(
                  periodStart: periodStart.toString(),
                  periodEnd: DateTime(periodStart.year,periodStart.month,periodStart.day + 3).toString(),
                  circleEnd: circleEnd.toString(),
                  status: 3,
                  before: '',
                  after: '',
                  other: '',
                  ovu: '',
                  mental: ''
              )
          );
        }
      }

      // await _calenderModel.updateTable(
      //     'Circles',
      //     {
      //       'isSavedToServer' : 0,
      //       'circleEnd' :DateTime(_selectedLastPeriod.year,_selectedLastPeriod.month,_selectedLastPeriod.day-1).toString()
      //     },
      //     circles[circles.length-2].id
      // );
    }
    cycleInfo.removeCycle(circles.length - 1);
    if(newAddCycle.isNotEmpty){
      for(int i=0 ; i<newAddCycle.length ; i++){
        cycleInfo.addCycle(CycleViewModel().getMap(newAddCycle[i]));
      }
    }
    cycleInfo.addCycle(CycleViewModel().getMap(item));
    // await _calenderModel.insertCircleToLocal(CircleModel().getMap(item));
  }

  checkCyclesForSelectedBeforeLastPeriod(DateTime _selectedLastPeriod) async {
    var cycleInfo = locator<CycleModel>();
    String periodEndForAbortion = '';
    List<CycleViewModel> circles = cycleInfo.cycle;
    List<int> counterRemoves = [];

    for (int i = 0; i < circles.length; i++) {
      if (_selectedLastPeriod.isBefore(DateTime.parse(circles[i].periodStart!)) || _selectedLastPeriod == DateTime.parse(circles[i].periodStart!)) {
        // await _calenderModel.insertToRemoveCircles(
        //     {'myIndex' : circles[i].id}
        // );
        // await _calenderModel.removeRecord('Circles',circles[i].id);
        if(circles[i].status == 2 && DateTime.parse(circles[i].periodEnd!).year == 3000 && DateTime.parse(circles[i].periodEnd!).month == 1 && DateTime.parse(circles[i].periodEnd!).day == 1){
          periodEndForAbortion = circles[i].periodEnd!;
        }
        counterRemoves.add(i);
      }
    }

    if (counterRemoves.length != 0) {
      cycleInfo.removeRangeCycle(counterRemoves[0], counterRemoves[counterRemoves.length - 1] + 1);
    }

    List<CycleViewModel> newCircles = cycleInfo.cycle;
    if (newCircles != null) {
      if (newCircles.length != 0) {
        DateTime newStartCycle = DateTime.parse(newCircles[newCircles.length - 1].periodStart!);
        int newCycleDay = MyDateTime().myDifferenceDays(newStartCycle, _selectedLastPeriod);
        if (newCycleDay >= 10 || newCircles[newCircles.length - 1].status != 0) {
          cycleInfo.updateCycle(
              newCircles.length - 1,
              CycleViewModel.fromJson({
                'periodStartDate':
                newCircles[newCircles.length - 1].periodStart,
                'periodEndDate': periodEndForAbortion != '' ? periodEndForAbortion : newCircles[newCircles.length - 1].periodEnd,
                'cycleEndDate': DateTime(_selectedLastPeriod.year,
                    _selectedLastPeriod.month, _selectedLastPeriod.day - 1)
                    .toString(),
                'status' : newCircles[newCircles.length - 1].status,
                'before': newCircles[newCircles.length - 1].before,
                'after': newCircles[newCircles.length - 1].after,
                'mental': newCircles[newCircles.length - 1].mental,
                'other': newCircles[newCircles.length - 1].other,
                'ovu': newCircles[newCircles.length - 1].ovu
              }));
          // await _calenderModel.updateTable(
          //     'Circles',
          //     {
          //       'isSavedToServer' : 0,
          //       'circleEnd' : DateTime(_selectedLastPeriod.year,_selectedLastPeriod.month,_selectedLastPeriod.day-1).toString()
          //     },
          //     newCircles[newCircles.length-1].id
          // );

        } else {
          // await _calenderModel.insertToRemoveCircles(
          //     {'myIndex' : newCircles[newCircles.length-1].id}
          // );
          // await _calenderModel.removeRecord('Circles', newCircles[newCircles.length-1].id);
          if (newCircles.length > 1) {
            cycleInfo.updateCycle(
                newCircles.length - 2,
                CycleViewModel.fromJson({
                  'periodStartDate':
                  newCircles[newCircles.length - 2].periodStart,
                  'periodEndDate': newCircles[newCircles.length - 2].periodEnd,
                  'cycleEndDate': DateTime(
                      _selectedLastPeriod.year,
                      _selectedLastPeriod.month,
                      _selectedLastPeriod.day - 1)
                      .toString(),
                  'status' : newCircles[newCircles.length - 2].status,
                  'before': newCircles[newCircles.length - 2].before,
                  'after': newCircles[newCircles.length - 2].after,
                  'mental': newCircles[newCircles.length - 2].mental,
                  'other': newCircles[newCircles.length - 2].other
                }));
            // await _calenderModel.updateTable(
            //     'Circles',
            //     {
            //       'isSavedToServer' : 0,
            //       'circleEnd' : DateTime(_selectedLastPeriod.year,_selectedLastPeriod.month,_selectedLastPeriod.day-1).toString()
            //     },
            //     newCircles[newCircles.length-2].id
            // );
          }
          cycleInfo.removeCycle(newCircles.length - 1);
        }
      }
    }
    CycleViewModel item = CycleViewModel();
    int _cycle = MyDateTime().myDifferenceDays(
        startCycleSelected.stream.value.toDateTime(),
        endCycleSelected.stream.value.toDateTime()) +
        1;
    int _period = MyDateTime().myDifferenceDays(
        startCycleSelected.stream.value.toDateTime(),
        endPeriodSelected.stream.value.toDateTime()) +
        1;
    item.setPeriodStart(DateTime(_selectedLastPeriod.year,
        _selectedLastPeriod.month, _selectedLastPeriod.day, 23)
        .toString());
    item.setPeriodEnd(DateTime(
        _selectedLastPeriod.year,
        _selectedLastPeriod.month,
        (_selectedLastPeriod.day + _period - 1),
        23)
        .toString());
    item.setCircleEnd(DateTime(
        _selectedLastPeriod.year,
        _selectedLastPeriod.month,
        (_selectedLastPeriod.day + _cycle - 1),
        23)
        .toString());

    // item.setIsSavedToServer(0);
    item.setStatus(0);
    item.setBefore(defaultCycles[defaultCycles.length - 1].getBefore());
    item.setAfter(defaultCycles[defaultCycles.length - 1].getAfter());
    item.setMental(defaultCycles[defaultCycles.length - 1].getMental());
    item.setOther(defaultCycles[defaultCycles.length - 1].getOther());
    item.setOvu(defaultCycles[defaultCycles.length - 1].getOvu());
    cycleInfo.addCycle(CycleViewModel().getMap(item));
    // await _calenderModel.insertCircleToLocal(CircleModel().getMap(item));
  }


  Future<bool> setCycleCalendar(context) async {
    var registerInfo = locator<RegisterParamModel>();
    var cycleInfo = locator<CycleModel>();
    CirclesSendServerMode circlesSendServerMode = CirclesSendServerMode();
    if (cycleInfo.cycle.length != 0) {
      circlesSendServerMode = CirclesSendServerMode.fromJson(cycleInfo.cycle);
    }
    if (circlesSendServerMode.cycleInfos != null) {
      if (circlesSendServerMode.cycleInfos!.length != 0) {
        Map<String,dynamic>? responseBody = await Http().sendRequest(
            womanUrl,
            'info/setcycleCalender',
            'POST',
            {"cycles": circlesSendServerMode.cycleInfos},
            registerInfo.register.token!);

        print('setCycleCalender : $responseBody');
        if (responseBody != null) {
          if (responseBody['isValid']) {
            await GenerateDashboardAndNotifyMessages().checkForNotificationMessage();
            if (!isLoading.isClosed) {
              isLoading.sink.add(false);
            }
            bottomMessageDashboard.clear();
            SaveDataOfflineMode().saveCycles();
            await updateBioRhythm(responseBody);
            await updateAdvertise(responseBody);
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: BlankScreen(
                      indexTab: 4,
                    )));
          } else {
            returnToDefaultCycle();
            if (!isLoading.isClosed) {
              isLoading.sink.add(false);
            }
            showToast(context, 'امکان تغییر دوره وجود ندارد');
          }
        } else {
          returnToDefaultCycle();
          if (!isLoading.isClosed) {
            isLoading.sink.add(false);
          }
          showToast(context,
              'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
        }
      } else {
        returnToDefaultCycle();
        if (!isLoading.isClosed) {
          isLoading.sink.add(false);
        }
        showToast(context, 'امکان تغییر دوره وجود ندارد');
      }
    } else {
      returnToDefaultCycle();
      if (!isLoading.isClosed) {
        isLoading.sink.add(false);
      }
      showToast(context, 'امکان تغییر دوره وجود ندارد');
    }

    return true;
  }

  Future<bool> updateBioRhythm(bioRythm)async{
    BioViewModel bioRhythmModel;
    // List<BioRhythmMessagesModel> biorhythmMessages = [];

    //bioRhythm
    bioRhythmModel =  BioViewModel.fromJson(bioRythm['bioRythm']);


    if(bioRhythmModel != null){

      _calenderModel.addAllBio(bioRythm['bioRythm']);
    }


    allRandomMessages.clear();
    viewBioRhythms.clear();
    return true;
  }

  Future<bool> updateAdvertise(advertise)async{
    var advertiseInfo = locator<AdvertiseModel>();
    advertiseInfo.advertises.clear();
    if(advertise['advertise']['advertise'].length != 0){
      advertise['advertise']['advertise'].forEach((item){
        advertiseInfo.addAdvertise(item);
      });
    }
    return true;
  }

  returnToDefaultCycle() {
    var cycleInfo = locator<CycleModel>();
    // print(cycleInfo.cycle.length);
    cycleInfo.removeAllCycles();
    for (int i = 0; i < defaultCycles.length; i++) {
      cycleInfo.addCycle({
        'periodStartDate': defaultCycles[i].periodStart,
        'periodEndDate': defaultCycles[i].periodEnd,
        'cycleEndDate': defaultCycles[i].circleEnd,
        'status' : defaultCycles[i].status,
        'before': defaultCycles[i].before,
        'after': defaultCycles[i].after,
        'mental': defaultCycles[i].mental,
        'other': defaultCycles[i].other,
        'ovu': defaultCycles[i].ovu
      });
    }
  }

  // initChangeCycleScreen()async{
  //   CycleViewModel lastCircle =  _calenderModel.getLastCircles();
  //   currentStartCircle = DateTime.parse(lastCircle.periodStart);
  //   currentEndCircle = DateTime.parse(lastCircle.circleEnd);
  //   currentEndPeriod = DateTime.parse(lastCircle.periodEnd);
  //
  //
  //   if(!startCycleSelected.isClosed){
  //     startCycleSelected.sink.add(Jalali.fromDateTime(currentStartCircle));
  //   }
  //
  //
  //
  //   if(!endPeriodSelected.isClosed){
  //     endPeriodSelected.sink.add(Jalali.fromDateTime(currentEndPeriod));
  //   }
  //   currentPeriodDays = MyDateTime().myDifferenceDays(currentStartCircle,currentEndPeriod) + 1;
  //   if(!selectedPeriodDay.isClosed){
  //     selectedPeriodDay.sink.add(currentPeriodDays);
  //   }
  //
  //
  //
  //   if(!endCycleSelected.isClosed){
  //     endCycleSelected.sink.add(Jalali.fromDateTime(currentEndCircle));
  //   }
  //   currentCycleDays = MyDateTime().myDifferenceDays(currentStartCircle,currentEndCircle) + 1;
  //   if(!selectedCycleDay.isClosed){
  //     selectedCycleDay.sink.add(currentCycleDays);
  //   }
  //
  //
  // }
  //
  // onChangedCurrentStartCycle(value,isMilady){
  //   if(!startCycleSelected.isClosed){
  //     startCycleSelected.sink.add(isMilady ? Jalali.fromDateTime(value) : value);
  //   }
  //   changeCycleAndPeriodDays();
  // }
  //
  // onChangedCurrentEndPeriod(value,isMilady){
  //   if(!endPeriodSelected.isClosed){
  //     endPeriodSelected.sink.add(isMilady ? Jalali.fromDateTime(value) : value);
  //   }
  //   changeCycleAndPeriodDays();
  // }
  //
  // onChangedCurrentEndCycle(value,isMilady){
  //   print(value);
  //   if(!endCycleSelected.isClosed){
  //     endCycleSelected.sink.add(isMilady ? Jalali.fromDateTime(value) : value);
  //   }
  //   changeCycleAndPeriodDays();
  // }
  //
  // changeCycleAndPeriodDays(){
  //   if(!selectedCycleDay.isClosed){
  //     selectedCycleDay.sink.add(MyDateTime().myDifferenceDays(startCycleSelected.stream.value.toDateTime(),endCycleSelected.stream.value.toDateTime()) + 1);
  //   }
  //   if(!selectedPeriodDay.isClosed){
  //     selectedPeriodDay.sink.add(MyDateTime().myDifferenceDays(startCycleSelected.stream.value.toDateTime(),endPeriodSelected.stream.value.toDateTime()) + 1);
  //   }
  // }
  //
  // acceptChangeCycle(context)async{
  //   DateTime now = DateTime.now();
  //   DateTime _startCycleSelected = startCycleSelected.stream.value.toDateTime();
  //   int _selectedCycleDay = MyDateTime().myDifferenceDays(startCycleSelected.stream.value.toDateTime(),endCycleSelected.stream.value.toDateTime()) + 1;
  //   int _selectedPeriodDay = MyDateTime().myDifferenceDays(startCycleSelected.stream.value.toDateTime(),endPeriodSelected.stream.value.toDateTime()) + 1;
  //   print(_selectedCycleDay);
  //   print(_selectedPeriodDay);
  //   if(checkPeriodAndCycleDays()){
  //     if(_selectedCycleDay <= 60 && _selectedCycleDay >= 20){
  //       if(_selectedPeriodDay <= 10 && _selectedPeriodDay >= 2){
  //         DateTime endCycle = DateTime(_startCycleSelected.year,_startCycleSelected.month,_startCycleSelected.day+_selectedCycleDay);
  //         if(now.isBefore(endCycle)){
  //           if(_startCycleSelected.isAfter(currentStartCircle)){
  //             // showToast(context,'after');
  //             await checkCyclesForSelectedAfterLastPeriod(_startCycleSelected);
  //             await autoBackup(context);
  //           }else if(_startCycleSelected.isBefore(currentStartCircle)){
  //             // showToast(context,'before');
  //             await checkCyclesForSelectedBeforeLastPeriod(_startCycleSelected);
  //             await autoBackup(context);
  //           }else{
  //             ///noChangeLastPeriod
  //             List<CircleModel> circles = await _calenderModel.getAllCircles();
  //             CircleModel lastCycle = circles[circles.length-1];
  //             await _calenderModel.updateTable(
  //                 'Circles',
  //                 {
  //                   'isSavedToServer' : 0,
  //                   'periodEnd' : DateTime(_startCycleSelected.year,_startCycleSelected.month,_startCycleSelected.day+(_selectedPeriodDay-1)).toString(),
  //                   'circleEnd' : DateTime(_startCycleSelected.year,_startCycleSelected.month,_startCycleSelected.day+(_selectedCycleDay-1)).toString()
  //                 },
  //                 lastCycle.id
  //             );
  //             await autoBackup(context);
  //             // showToast(context,'noChangeLastPeriod');
  //           }
  //
  //         }else{
  //           showToast(context,'خطا');
  //         }
  //       }else{
  //         showToast(context,'طول پریود نباید کمتر از 2 و بیشتر از 10 روز باشه');
  //       }
  //     }else{
  //       showToast(context,'طول دوره نباید کمتر از 20 و بیشتر از 60 روز باشه');
  //     }
  //   }else{
  //     showToast(context,'لازمه طول دوره یا طول پریودت رو تغییر بدی تا با هم متناسب باشند.');
  //   }
  // }
  //
  // bool checkPeriodAndCycleDays(){
  //
  //   int _cycle = MyDateTime().myDifferenceDays(startCycleSelected.stream.value.toDateTime(),endCycleSelected.stream.value.toDateTime()) + 1;
  //   int _period = MyDateTime().myDifferenceDays(startCycleSelected.stream.value.toDateTime(),endPeriodSelected.stream.value.toDateTime()) + 1;
  //
  //   if(_cycle < 25){
  //     if(_cycle == 24 && _period > 9){
  //       return false;
  //     }else if(_cycle == 23 && _period > 8){
  //       return false;
  //     }else if(_cycle == 22 && _period > 7){
  //       return false;
  //     }else if(_cycle == 21 && _period > 6){
  //       return false;
  //     }else if(_cycle == 20 && _period > 5){
  //       return false;
  //     }else{
  //
  //       return true;
  //
  //     }
  //   }else{
  //
  //     return true;
  //
  //   }
  // }
  //
  // checkCyclesForSelectedAfterLastPeriod(DateTime _selectedLastPeriod)async{
  //   CircleModel item =  CircleModel();
  //   int _cycle = MyDateTime().myDifferenceDays(startCycleSelected.stream.value.toDateTime(),endCycleSelected.stream.value.toDateTime()) + 1;
  //   int _period = MyDateTime().myDifferenceDays(startCycleSelected.stream.value.toDateTime(),endPeriodSelected.stream.value.toDateTime()) + 1;
  //   List<CircleModel> circles = await _calenderModel.getAllCircles();
  //   CircleModel lastCycle = circles[circles.length-1];
  //   await _calenderModel.insertToRemoveCircles(
  //     {'myIndex' : circles[circles.length-1].id}
  //   );
  //   await _calenderModel.removeRecord('Circles', circles[circles.length-1].id);
  //   item.setPeriodStart(_selectedLastPeriod.toString());
  //   item.setPeriodEnd(DateTime(_selectedLastPeriod.year,_selectedLastPeriod.month,(_selectedLastPeriod.day + _period - 1 )).toString());
  //   item.setCircleEnd(DateTime(_selectedLastPeriod.year,_selectedLastPeriod.month,(_selectedLastPeriod.day + _cycle - 1 )).toString());
  //
  //   item.setIsSavedToServer(0);
  //   item.setBefore(lastCycle.getBefore());
  //   item.setAfter(lastCycle.getAfter());
  //   item.setMental(lastCycle.getMental());
  //   item.setOther(lastCycle.getOther());
  //   // print(item.periodStart);
  //   // print(item.periodEnd);
  //   // print(item.circleEnd);
  //   print(DateTime(_selectedLastPeriod.year,_selectedLastPeriod.month,_selectedLastPeriod.day-1));
  //   if(circles.length > 1){
  //     await _calenderModel.updateTable(
  //         'Circles',
  //         {
  //           'isSavedToServer' : 0,
  //           'circleEnd' :DateTime(_selectedLastPeriod.year,_selectedLastPeriod.month,_selectedLastPeriod.day-1).toString()
  //         },
  //         circles[circles.length-2].id
  //     );
  //   }
  //   await _calenderModel.insertCircleToLocal(CircleModel().getMap(item));
  // }
  //
  // checkCyclesForSelectedBeforeLastPeriod(DateTime _selectedLastPeriod)async{
  //   // print(_selectedLastPeriod);
  //   List<CircleModel> circles = await _calenderModel.getAllCircles();
  //   for(int i=0 ; i<circles.length ; i++){
  //     // print(DateTime.parse(circles[i].periodStart));
  //     if(_selectedLastPeriod.isBefore(DateTime.parse(circles[i].periodStart))||_selectedLastPeriod == DateTime.parse(circles[i].periodStart)){
  //       await _calenderModel.insertToRemoveCircles(
  //           {'myIndex' : circles[i].id}
  //       );
  //       await _calenderModel.removeRecord('Circles',circles[i].id);
  //     }
  //   }
  //   List<CircleModel> newCircles = await _calenderModel.getAllCircles();
  //   if(newCircles != null){
  //     if(newCircles.length != 0){
  //       DateTime newStartCycle = DateTime.parse(newCircles[newCircles.length-1].periodStart);
  //       int newCycleDay = MyDateTime().myDifferenceDays(newStartCycle,_selectedLastPeriod);
  //       print(newCycleDay);
  //       if(newCycleDay >=10){
  //
  //         await _calenderModel.updateTable(
  //             'Circles',
  //             {
  //               'isSavedToServer' : 0,
  //               'circleEnd' : DateTime(_selectedLastPeriod.year,_selectedLastPeriod.month,_selectedLastPeriod.day-1).toString()
  //             },
  //             newCircles[newCircles.length-1].id
  //         );
  //
  //       }else{
  //         await _calenderModel.insertToRemoveCircles(
  //             {'myIndex' : newCircles[newCircles.length-1].id}
  //         );
  //         await _calenderModel.removeRecord('Circles', newCircles[newCircles.length-1].id);
  //         if(newCircles.length > 1){
  //           await _calenderModel.updateTable(
  //               'Circles',
  //               {
  //                 'isSavedToServer' : 0,
  //                 'circleEnd' : DateTime(_selectedLastPeriod.year,_selectedLastPeriod.month,_selectedLastPeriod.day-1).toString()
  //               },
  //               newCircles[newCircles.length-2].id
  //           );
  //         }
  //
  //
  //       }
  //     }
  //   }
  //   CircleModel item =  CircleModel();
  //   int _cycle = MyDateTime().myDifferenceDays(startCycleSelected.stream.value.toDateTime(),endCycleSelected.stream.value.toDateTime()) + 1;
  //   int _period = MyDateTime().myDifferenceDays(startCycleSelected.stream.value.toDateTime(),endPeriodSelected.stream.value.toDateTime()) + 1;
  //   print(_cycle);
  //   item.setPeriodStart(_selectedLastPeriod.toString());
  //   item.setPeriodEnd(DateTime(_selectedLastPeriod.year,_selectedLastPeriod.month,(_selectedLastPeriod.day + _period - 1 )).toString());
  //   item.setCircleEnd(DateTime(_selectedLastPeriod.year,_selectedLastPeriod.month,(_selectedLastPeriod.day + _cycle - 1 )).toString());
  //
  //   item.setIsSavedToServer(0);
  //   item.setBefore(circles[circles.length-1].getBefore());
  //   item.setAfter(circles[circles.length-1].getAfter());
  //   item.setMental(circles[circles.length-1].getMental());
  //   item.setOther(circles[circles.length-1].getOther());
  //   await _calenderModel.insertCircleToLocal(CircleModel().getMap(item));
  // }

  // autoBackup(context)async{
  //   RegisterParamViewModel register = await _calenderModel.getRegisters();
  //   List<CircleModel> circles = await _calenderModel.getAllCircles();
  //   await _calenderModel.removeTable('SugMessages');
  //   /// GenerateDashboardAndNotifyMessages().checkForNotificationMessage(circles[circles.length-1], register); این باید پیاده شود
  //   AutoBackup().setCycleInfoAndCycleCalender();
  //   Navigator.pushReplacement(
  //       context,
  //       PageTransition(
  //           type: PageTransitionType.fade,
  //           child:  BlankScreen(
  //             indexTab: 2,
  //           )
  //       )
  //   );
  //
  // }


  dispose(){
    animationControllerDialog.dispose();
    listGirdItems.close();
    bigText.close();
    colorBigText.close();
    // smallText.close();
    indexMoon.close();
    dialogScale.close();
    isShowDialog.close();
    isTodayCircle.close();
    todayDateText.close();
    isShowDeleteNoteDialog.close();
    listAlarms.close();
    isShowCanDrawOverlaysDialog.close();
    isAlarm.close();
    isOpenPanel.close();
    todayDate.close();
    isAlarmNote.close();
    todayTextForNoteListScreen.close();
    uploadFiles.close();
    sendValuePercentUploadFile.close();
    isLoadingButton.close();
    countNotReadMsg.close();
    startCycleSelected.close();
    endPeriodSelected.close();
    endCycleSelected.close();
    selectedCycleDay.close();
    selectedPeriodDay.close();
    advertis.close();
    randomMessage.close();
    isLoading.close();
    heightCalendar.close();
  }


}