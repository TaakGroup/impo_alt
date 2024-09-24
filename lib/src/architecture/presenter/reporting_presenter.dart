
// import 'package:flutter_poolakey/flutter_poolakey.dart';
import 'package:impo/src/architecture/model/reporting_model.dart';
import 'package:impo/src/architecture/view/reporting_view.dart';
import 'package:impo/src/components/DateTime/my_datetime.dart';
import 'package:impo/src/core/app/view/widgets/snackbar/custom_snack_bar.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/models/reporting/chart_comparison_model.dart';
import 'package:impo/src/models/reporting/chart_timing_model.dart';
import 'package:impo/src/models/reporting/history_eras_model.dart';
// import 'package:myket_iap/myket_iap.dart';
// import 'package:myket_iap/util/iab_result.dart';
// import 'package:myket_iap/util/purchase.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:impo/src/models/reporting/report_era_model.dart';
import 'package:impo/src/models/expert/info.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:page_transition/page_transition.dart';
import 'package:impo/src/screens/home/tabs/profile/reporting/chart_screen.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:impo/src/screens/home/tabs/profile/reporting/report_pdf.dart';
import 'package:path_provider/path_provider.dart';

import '../../firebase_analytics_helper.dart';

class ReportingPresenter{

  late ReportingView _reportingView;

  ReportingModel reportingModel = new ReportingModel();
  late TabController tabController;

  ReportingPresenter(ReportingView view){

    this._reportingView = view;

  }

  // late PanelController panelController;
  late AnimationController animationControllerDialog;
  ScreenshotController screenshotControllerCompareChart = ScreenshotController();
  ScreenshotController screenshotControllerTimingChart = ScreenshotController();
  ScreenshotController screenshotControllerImpoLogo = ScreenshotController();

  final circlesCompare = BehaviorSubject<ChartComparisonModel>();
  final circlesTiming = BehaviorSubject<ChartTimingModel>();
  final isLoading = BehaviorSubject<bool>.seeded(false);
  final isLoadingButton = BehaviorSubject<bool>.seeded(false);
  final tryButtonError = BehaviorSubject<bool>.seeded(false);
  final valueError = BehaviorSubject<String>.seeded('');
  final reportEar = BehaviorSubject<ReportEraModel>();
  final infoAdvice = BehaviorSubject<InfoAdviceModel>();
  final isShowExitDialog = BehaviorSubject<bool>.seeded(false);
  final dialogScale = BehaviorSubject<double>.seeded(0.0);
  final selectedEarForBuy = BehaviorSubject<EraList>();
  final reportHistory = BehaviorSubject<ReportHistory>();
  final isLoadingPdf = BehaviorSubject<bool>.seeded(false);
  final isLoadingCafeBazar = BehaviorSubject<bool>.seeded(false);


  Stream<ChartComparisonModel> get circlesCompareObserve => circlesCompare.stream;
  Stream<ChartTimingModel> get circlesTimingObserve => circlesTiming.stream;
  Stream<bool> get isLoadingObserve => isLoading.stream;
  Stream<bool> get isLoadingButtonObserve => isLoadingButton.stream;
  Stream<bool> get tryButtonErrorObserve => tryButtonError.stream;
  Stream<String> get valueErrorObserve => valueError.stream;
  Stream<ReportEraModel> get reportEarObserve => reportEar.stream;
  Stream<InfoAdviceModel> get infoAdviceObserve => infoAdvice.stream;
  Stream<bool> get isShowExitDialogObserve => isShowExitDialog.stream;
  Stream<double> get dialogScaleObserve => dialogScale.stream;
  Stream<EraList> get selectedEarForBuyObserve => selectedEarForBuy.stream;
  Stream<ReportHistory> get reportHistoryObserve => reportHistory.stream;
  Stream<bool> get isLoadingPdfObserve => isLoadingPdf.stream;
  Stream<bool> get isLoadingCafeBazarObserve => isLoadingCafeBazar.stream;



  late ChartComparisonModel _chartComparisonModel;
  late ChartTimingModel _chartTiming;
  late ReportEraModel _reportEra;
  late InfoAdviceModel _infoAdviceModel;
  // List<HistoryErasModel> _historyEra = [];
  // int counterForShopScreen = 0;

    String format1(Date d,nationality) {
    final f = d.formatter;

    if(nationality == 'IR'){
      return "${f.mN}";
    }else{
      return "${f.mnAf}";
    }
  }

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



  // initPanelController(){
  //     panelController = new PanelController();
  // }

  initChart(int limit,HistoryErasModel? historyEra)async{
    RegisterParamViewModel register =  reportingModel.getRegisters();
    int currentCircleDay = historyEra != null ? historyEra.cycleLength : register.circleDay!;
    int currentPeriodDay = historyEra != null ? historyEra.periodLength : register.periodDay!;
    List<CycleViewModel> showCircles = [];
    if(historyEra != null){
      for(int i=0 ; i<historyEra.eras.length ; i++){
        showCircles.add(
            CycleViewModel.fromJson(
            {
            'id' : i,
            'isSavedToServer' : 1,
            'periodStartDate' : historyEra.eras[i].periodStart,
            'periodEndDate' : historyEra.eras[i].periodEnd,
            'cycleEndDate' : historyEra.eras[i].cycleEnd,
            'before' : '',
            'after' : '',
            'mental' : '',
            'other' : '',
            'ovu' : ''
            }
          )
        );
      }
    }else{
      List<CycleViewModel> periodCycles =  reportingModel.getAllPeriodCircles();

      if(limit != 0){
        showCircles = periodCycles.sublist(periodCycles.length-limit,periodCycles.length);
      }else{
        showCircles = periodCycles;
      }
    }

    List<CirclesComparison> circlesComparison = [];
    List<CirclesTimingModel> _circlesTiming = [];
    String dayStartCircle = '';
    String dayEdnPeriod = '';
    for(int i=0 ; i<showCircles.length ; i++){
      DateTime startPeriod = DateTime.parse(showCircles[i].periodStart!);
      DateTime endPeriod = DateTime.parse(showCircles[i].periodEnd!);
      DateTime endCircle = DateTime.parse(showCircles[i].circleEnd!);
      // print('startPeriod : $startPeriod');
      // print('endPeriod : $endPeriod');
      // print('endCircle : $endCircle');
      final DateFormat formatterMonthMiladi = DateFormat('LLL','fa');
      final DateFormat formatterMiladi = DateFormat('yyyy/MM/dd');
      Jalali shamsiStartPeriod = Jalali.fromDateTime(startPeriod);
      Jalali shamsiEndCircle = Jalali.fromDateTime(endCircle);
      Jalali shamsiEndPeriod = Jalali.fromDateTime(endPeriod);
      int periodDay =  MyDateTime().myDifferenceDays(startPeriod,endPeriod) + 1;
      List<String> months = [];
      String stringMonths;
      if(register.calendarType == 1){
        if(endCircle.month - startPeriod.month == 1 ||endCircle.month - startPeriod.month == -11){
          months.add(formatterMonthMiladi.format(startPeriod));
          months.add(formatterMonthMiladi.format(endCircle));
          stringMonths = months.toString().replaceAll('[','').replaceAll(']','').replaceAll(',','-').replaceAll(' ', '');
        }else if((endCircle.month - startPeriod.month >= 2 ||endCircle.month - startPeriod.month <= -10)){
          months.add(formatterMonthMiladi.format(startPeriod));
          months.add(formatterMonthMiladi.format(endCircle));
          stringMonths = months.toString().replaceAll('[','').replaceAll(']','').replaceAll(',',' تا');
        }else{
          months.add(formatterMonthMiladi.format(endCircle));
          stringMonths = months.toString().replaceAll('[','').replaceAll(']','').replaceAll(',','');
        }
      }else{
        if(shamsiEndCircle.month - shamsiStartPeriod.month == 1 ||shamsiEndCircle.month - shamsiStartPeriod.month == -11){
          months.add(format1(shamsiStartPeriod, register.nationality));
          months.add(format1(shamsiEndCircle, register.nationality));
          stringMonths = months.toString().replaceAll('[','').replaceAll(']','').replaceAll(',','-').replaceAll(' ', '');
        }else if((shamsiEndCircle.month - shamsiStartPeriod.month >= 2 ||shamsiEndCircle.month - shamsiStartPeriod.month <= -10)){
          months.add(format1(shamsiStartPeriod, register.nationality));
          months.add(format1(shamsiEndCircle, register.nationality));
          stringMonths = months.toString().replaceAll('[','').replaceAll(']','').replaceAll(',',' تا');
        }else{
          months.add(format1(shamsiEndCircle, register.nationality));
          stringMonths = months.toString().replaceAll('[','').replaceAll(']','').replaceAll(',','');
        }
      }
      circlesComparison.add(CirclesComparison.fromJson({
        'circleDay' :  MyDateTime().myDifferenceDays(startPeriod,endCircle) + 1,
        'periodDay' :    MyDateTime().myDifferenceDays(startPeriod,endPeriod) + 1,
        'months' : stringMonths,
        'status' :  MyDateTime().myDifferenceDays(startPeriod,endCircle) + 1 >= (currentCircleDay- 3) && MyDateTime().myDifferenceDays(startPeriod,endCircle) + 1 <= (currentCircleDay + 3) ? true : false
      })
      );
      // monthsChartTiming.clear();
      List<String> monthsChartTiming = [];
      List<int> daysStartMonths = [];
      for(int i=0 ; i<MyDateTime().myDifferenceDays(startPeriod,endCircle) + 1; i++){
        DateTime dateTime = DateTime(startPeriod.year,startPeriod.month,startPeriod.day+i);
        int currentDay = MyDateTime().myDifferenceDays(startPeriod,dateTime)+1;
        Jalali shamsi = Jalali.fromDateTime(dateTime);
        if(currentDay == 1){
          if(register.calendarType == 1){
            dayStartCircle = dateTime.day.toString();
          }else{
            dayStartCircle = shamsi.day.toString();
          }
        }else if(currentDay == periodDay){
          if(register.calendarType == 1){
            dayEdnPeriod = dateTime.day.toString();
          }else{
            dayEdnPeriod = shamsi.day.toString();
          }
        }
        // print(shamsi);
        // if(shamsi.month == 1 || shamsi.month == 2 || shamsi.month == 3 || shamsi.month == 4 || shamsi.month == 5 || shamsi.month == 6 ) {
        //   if (shamsi.day == 31) {
        //     monthsChartTiming.add(format1(shamsi, register.nationality));
        //     // daysStartMonths.add(i + 1);
        //   }
        // }else{
        //   if(shamsi.month == 7 || shamsi.month == 8 || shamsi.month == 9 || shamsi.month == 10 || shamsi.month == 11){
        //     if (shamsi.day == 30) {
        //       monthsChartTiming.add(format1(shamsi, register.nationality));
        //       // daysStartMonths.add(i + 1);
        //     }
        //   }else{
        //     if(shamsi.isLeapYear() && shamsi.month == 12){
        //       if (shamsi.day == 30) {
        //         monthsChartTiming.add(format1(shamsi, register.nationality));
        //         // daysStartMonths.add(i + 1);
        //       }
        //     }else{
        //       if (shamsi.day == 29) {
        //         monthsChartTiming.add(format1(shamsi, register.nationality));
        //         // daysStartMonths.add(i + 1);
        //       }
        //     }
        //   }
        // }
        // print(shamsi);
        if(register.calendarType == 1){
          if(dateTime.day == 1){
            monthsChartTiming.add(formatterMonthMiladi.format(dateTime));
          }
        }else{
          if(shamsi.day == 1){
            monthsChartTiming.add(format1(shamsi, register.nationality));
          }
        }
        daysStartMonths.add(i+1);
      }
      // print(monthsChartTiming);
      // print(daysStartMonths);

      _circlesTiming.add(CirclesTimingModel.fromJson({
        'circleDay' :  MyDateTime().myDifferenceDays(startPeriod,endCircle) + 1,
        'periodDay' :    MyDateTime().myDifferenceDays(startPeriod,endPeriod) + 1,
        'startPeriodDay' : register.calendarType == 1 ? startPeriod.day : shamsiStartPeriod.day,
        'endPeriodDay' : register.calendarType == 1 ? endPeriod.day : shamsiEndPeriod.day,
        'dayStartCircle' : dayStartCircle,
        'dayEdnPeriod' : dayEdnPeriod,
        'monthsChartTiming' : monthsChartTiming,
        'daysStartMonths' : daysStartMonths,
        'months' : stringMonths,
        'startPeriodDate' : register.calendarType == 1 ? formatterMiladi.format(startPeriod) : shamsiStartPeriod.toString().replaceAll('Jalali','').replaceAll(',','/').replaceAll(')','').replaceAll('(',''),
        'endPeriodDate' : register.calendarType == 1 ? formatterMiladi.format(endPeriod) : shamsiEndPeriod.toString().replaceAll('Jalali','').replaceAll(',','/').replaceAll(')','').replaceAll('(',''),
      }));

    }

    //
    int largestCircleDay = 1;
    int totalDays = 0;
    for(int i=0 ; i<circlesComparison.length ; i++){
      totalDays = circlesComparison[i].circleDay + totalDays;
      // print(circlesComparison[i].circleDay);
      // print(circlesComparison[i].periodDay);
      if(circlesComparison[i].circleDay > largestCircleDay){
        largestCircleDay = circlesComparison[i].circleDay;
      }
    }
    if(largestCircleDay < register.circleDay!){
      largestCircleDay = register.circleDay!;
    }
    _chartComparisonModel = ChartComparisonModel.fromJson(
      {
        'circleDayRegister' : currentCircleDay,
        'periodDayRegister' : currentPeriodDay,
        'largestCircleDay' : largestCircleDay,
        'totalDays' : totalDays,
        'circles' : circlesComparison
      }
    );
    // print(monthsChartTiming);
    _chartTiming = ChartTimingModel.fomJson(
      {
        'largestCircleDay' : largestCircleDay,
        'totalDays' : totalDays,
        'circles' : _circlesTiming

      }
    );

    // print(_chartTiming.circles[2].daysStartMonths);
    // print(_chartTiming.circles[1].daysStartMonths);
    // print(_chartTiming.circles[2].daysStartMonths);

    if(!circlesCompare.isClosed){
      circlesCompare.sink.add(_chartComparisonModel);
    }

    if(!circlesTiming.isClosed){
      circlesTiming.sink.add(_chartTiming);
    }
    //
    // print(circlesTiming.stream.value.circles[1].months);

  }

  getInfoPolar(_this)async{
    RegisterParamViewModel register =  reportingModel.getRegisters();
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }

    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        // 'advice/clinic',
        'advice/newclinicv1',
        'GET',
        {

        },
      register.token!
    );

    if(responseBody != null){
      // if(!isLoading.isClosed){
      //   isLoading.sink.add(false);
      // }
      // if(token != ''){
      //   checkBackUp();
      // }else{
      //   getChatsTicket(chatId,thiss);
      // }
      // print(responseBody);
      _infoAdviceModel = InfoAdviceModel.fromJson(responseBody);
      if(!infoAdvice.isClosed){
        infoAdvice.sink.add(_infoAdviceModel);
      }
      getEra(_this);
    }else{
      if(!tryButtonError.isClosed){
        tryButtonError.sink.add(true);
      }
      valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }

  }

  getEra(_this)async{
     List<CycleViewModel> periodCycles =  reportingModel.getAllPeriodCircles();
      RegisterParamViewModel register =  reportingModel.getRegisters();
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'report/era/${register.status == 3 ? -3 : register.status == 2 ? -2 : periodCycles.length}',
        'GET',
        {

        },
      register.token!
    );
    print(responseBody);
      if(responseBody != null){
        // if(!isLoading.isClosed){
        //   isLoading.sink.add(false);
        // }
        _reportEra = ReportEraModel.fromJson(responseBody);
        if(!reportEar.isClosed){
          reportEar.sink.add(_reportEra);
        }
        getHistoryReports(_this);
      }else{
        if(!tryButtonError.isClosed){
          tryButtonError.sink.add(true);
        }
        valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
      }
  }

  getHistoryReports(_this)async{
    RegisterParamViewModel register =  reportingModel.getRegisters();
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }

    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'report/v1',
        'GET',
        {

        },
        register.token!
    );
    print(responseBody);
    if(responseBody != null){
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
      // clinic.sink.add(InfoAdviceTypes.fromJson(responseBody['clinic']));
      reportHistory.sink.add(ReportHistory.fromJson(responseBody, register));
      tabController =  TabController(length: 2, vsync: _this,initialIndex: reportHistory.stream.value.eras.length != 0 ? 1 : 0);
      if(tabController.index == 0){
        AnalyticsHelper().log(AnalyticsEvents.ReportingPg_Reporting_Tab_Load);
      }else{
        AnalyticsHelper().log(AnalyticsEvents.ReportingPg_HistoryReporting_Tab_Load);
      }

      tabController.addListener(_handleTabSelection);
    }else{
      if(!tryButtonError.isClosed){
        tryButtonError.sink.add(true);
      }
      valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }

  }

  _handleTabSelection(){
      if(tabController.indexIsChanging){
        if(tabController.index == 0){
          AnalyticsHelper().log(AnalyticsEvents.ReportingPg_Reporting_Tab_Load);
        }else{
          AnalyticsHelper().log(AnalyticsEvents.ReportingPg_HistoryReporting_Tab_Load);
        }
      }
  }

  // onPressReportForBuy(EraList era)async{
  //   if(!selectedEarForBuy.isClosed){
  //     selectedEarForBuy.sink.add(era);
  //   }
  //   if(infoAdvice.stream.value.currentValue >= era.polar){
  //     Timer(Duration(milliseconds: 50),()async{
  //       animationControllerDialog.forward();
  //       if(!isShowExitDialog.isClosed){
  //         isShowExitDialog.sink.add(true);
  //       }
  //     });
  //   }else{
  //     panelController.open();
  //   }
  // }

   acceptDialog({BuildContext? context , bool? isDialog,expertPresenter})async{
      payReport(context,expertPresenter);
    }


  cancelDialog()async{
    await animationControllerDialog.reverse();
    if(!isShowExitDialog.isClosed){
      isShowExitDialog.sink.add(false);
    }
  }


  payReport(context,expertPresenter)async{
    RegisterParamViewModel register =  reportingModel.getRegisters();

      if(!isLoadingButton.isClosed){
        isLoadingButton.sink.add(true);
      }
      Map _body = await initBodyBuyReport(register.periodDay,register.circleDay,register.calendarType!);
      print(_body);
      Map<String,dynamic>? responseBody = await Http().sendRequest(
          womanUrl,
          'report/v1',
          'POST',
           _body,
          register.token!
      );

      print(responseBody);
    if(!isLoadingButton.isClosed){
      isLoadingButton.sink.add(false);
    }
      if(responseBody != null){
        if(responseBody['valid']){
          if(!responseBody['needPolar']){
            cancelDialog();
            InfoAdviceTypes infoAdviceTypes = InfoAdviceTypes.fromJson(responseBody['clinic']);
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child:  ChartScreen(
                      limit: selectedEarForBuy.stream.value.cycleCount,
                      name: register.name,
                      expertPresenter: expertPresenter,
                      infoAdviceTypes: infoAdviceTypes,
                    )
                )
            );
          }else{
            showToast(responseBody['message'], context);
          }
        }else{
          showToast(responseBody['message'], context);
        }
      }else{
        showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
      }
  }

  Future<Map> initBodyBuyReport(periodLength,cycleLength,int calendarType)async{
    List<CycleViewModel> periodCycles =  reportingModel.getAllPeriodCircles();
    List<CycleViewModel> showCircles;
    if(selectedEarForBuy.stream.value.cycleCount != 0){
      showCircles = periodCycles.sublist(periodCycles.length-selectedEarForBuy.stream.value.cycleCount,periodCycles.length);
    }else{
      showCircles = periodCycles;
    }
    DateTime firstCycle;
    DateTime endCycle;
    String stringFirstCycle;
    String stringEndCycle;
    firstCycle = DateTime.parse(showCircles[0].periodStart!);
    endCycle = DateTime.parse(showCircles[showCircles.length - 1].circleEnd!);
    if(calendarType == 1){
      final DateFormat formatter = DateFormat('yyyy/MM/dd');
      stringFirstCycle = formatter.format(firstCycle);
      stringEndCycle = formatter.format(endCycle);
    }else{
      stringFirstCycle = Jalali.fromDateTime(firstCycle).toString().replaceAll('(','').replaceAll(')','').replaceAll('Jalali','').replaceAll(',','/').replaceAll(' ','');
      stringEndCycle = Jalali.fromDateTime(endCycle).toString().replaceAll('(','').replaceAll(')','').replaceAll('Jalali','').replaceAll(',','/').replaceAll(' ','');
    }
    String description = 'از تاریخ $stringFirstCycle تا تاریخ $stringEndCycle';
    List<Map<String,dynamic>> infos = [];
    for(int i=0 ; i<showCircles.length ; i++){
      infos.add({
        "periodStart" : DateFormat('yyyy-MM-dd').format(DateTime.parse(showCircles[i].periodStart!)),
        "periodEnd" : DateFormat('yyyy-MM-dd').format(DateTime.parse(showCircles[i].periodEnd!)),
        "circleEnd" : DateFormat('yyyy-MM-dd').format(DateTime.parse(showCircles[i].circleEnd!)),
      });
    }
    Map _body = {
      "periodCount" : selectedEarForBuy.stream.value.cycleCount,
      "title" : "مشاهده گزارش ${selectedEarForBuy.stream.value.cycleCount} دوره",
      "description" : description,
      "PeriodLength" : periodLength,
      "CycleLength" :  cycleLength,
      "infos" : infos
    };
    return _body;
  }

  getPdf(context,limit,isShare)async{
        if(!isLoadingPdf.isClosed){
          isLoadingPdf.sink.add(true);
        }
      await saveScreenShot();
      await reportView(context,limit,isShare);

        if(!isLoadingPdf.isClosed){
          isLoadingPdf.sink.add(false);
        }
  }

  Future<bool>saveScreenShot()async{
    final directory = (await getApplicationDocumentsDirectory ()).path;
    print(directory);//from path_provide package
    String fileNameCompareChart = 'compareChart.jpg';
    String fileNameTimingChart = 'timingChart.jpg';
    String fileNameImpoLogo = 'fileNameImpoLogo.jpg';
    String path = '$directory';

    await screenshotControllerCompareChart.captureAndSave(
        path, //set path where screenshot will be saved
        fileName: fileNameCompareChart,
        pixelRatio: 2
      // pixelRatio: 1000
    );

    await screenshotControllerTimingChart.captureAndSave(
        path, //set path where screenshot will be saved
        fileName: fileNameTimingChart,
        pixelRatio: 2
      // pixelRatio: 1000
    );

    await screenshotControllerImpoLogo.captureAndSave(
        path, //set path where screenshot will be saved
        fileName: fileNameImpoLogo,
        pixelRatio: 1.5
      // pixelRatio: 1000
    );


    return true;
  }

  // payCafeBazar(EraList era,context,expertPresenter)async{
  //   if(!selectedEarForBuy.isClosed){
  //     selectedEarForBuy.sink.add(era);
  //   }
  //   if(!isLoadingCafeBazar.isClosed){
  //     isLoadingCafeBazar.sink.add(true);
  //   }
  //   print('payCafeBazar');
  //   try{
  //     PurchaseInfo purchaseInfo = await FlutterPoolakey.purchase(era.id.toString(), payload: 'DEVELOPER_PAYLOAD');
  //     print(purchaseInfo);
  //     await consumeCafeBazar(purchaseInfo,context,expertPresenter);
  //   }catch(e){
  //     if(!isLoadingCafeBazar.isClosed){
  //       isLoadingCafeBazar.sink.add(false);
  //     }
  //     showToast('ارتباط با کافه بازار برقرار نشد، لطفا مجددا تلاش کنید', context);
  //     print(e);
  //   }
  // }
  //
  // consumeCafeBazar(PurchaseInfo purchaseInfo,context,expertPresenter)async{
  //   bool result = await FlutterPoolakey.consume(purchaseInfo.purchaseToken);
  //   print(result);
  //   print('result');
  //   if(result){
  //     // await acceptBazar(purchaseInfo, context);
  //     payReportCafeBazarAndMykey(context,expertPresenter);
  //   }else{
  //     if(!isLoadingCafeBazar.isClosed){
  //       isLoadingCafeBazar.sink.add(false);
  //     }
  //     showToast('ارتباط با کافه بازار برقرار نشد، لطفا مجددا تلاش کنید', context);
  //   }
  // }


  // payMyket(EraList era,context,expertPresenter)async{
  //   if(!selectedEarForBuy.isClosed){
  //     selectedEarForBuy.sink.add(era);
  //   }
  //   if(!isLoadingCafeBazar.isClosed){
  //     isLoadingCafeBazar.sink.add(true);
  //   }
  //   print('payMykey');
  //   print(era.id.toString());
  //   try{
  //     var result = await MyketIAP.launchPurchaseFlow(sku: era.id.toString(), payload:"DEVELOPER_PAYLOAD");
  //     print(result);
  //     Purchase purchase = result[MyketIAP.PURCHASE];
  //     IabResult purchaseResult = result[MyketIAP.RESULT];
  //     if(purchaseResult.mResponse == 0){
  //       consumeCafeMyket(purchase, context,expertPresenter);
  //     }else{
  //       if(!isLoadingCafeBazar.isClosed){
  //         isLoadingCafeBazar.sink.add(false);
  //       }
  //       showToast('ارتباط با مایکت برقرار نشد، لطفا مجددا تلاش کنید', context);
  //     }
  //   }catch(e){
  //     if(!isLoadingCafeBazar.isClosed){
  //       isLoadingCafeBazar.sink.add(false);
  //     }
  //     showToast('ارتباط با مایکت برقرار نشد، لطفا مجددا تلاش کنید', context);
  //     print(e);
  //   }
  // }
  //
  // consumeCafeMyket(Purchase purchase,context,expertPresenter)async{
  //   print('consumeCafeMyket');
  //   var result = await MyketIAP.consume(purchase: purchase);
  //   print(result);
  //   IabResult purchaseResult = result[MyketIAP.RESULT];
  //   Purchase _purchase = result[MyketIAP.PURCHASE];
  //   if(purchaseResult.mResponse == 0){
  //     payReportCafeBazarAndMykey(context,expertPresenter);
  //   }else{
  //     if(!isLoadingCafeBazar.isClosed){
  //       isLoadingCafeBazar.sink.add(false);
  //     }
  //     showToast('ارتباط با مایکت برقرار نشد، لطفا مجددا تلاش کنید', context);
  //   }
  // }

  payReportCafeBazarAndMykey(EraList era,context,expertPresenter)async{
    if(!selectedEarForBuy.isClosed){
      selectedEarForBuy.sink.add(era); /// forWomansubscribtion Mode
    }
    RegisterParamViewModel register =  reportingModel.getRegisters();

    if(!isLoadingCafeBazar.isClosed){
      isLoadingCafeBazar.sink.add(true);
    }
    Map _body = await initBodyBuyReport(register.periodDay,register.circleDay,register.calendarType!);
    print(_body);
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'report/cafebuyv1', /// forWomansubscribtion Mode
        'POST',
        _body,
        register.token!
    );

    print('payReportCafeBazar');
    print(responseBody);
    if(!isLoadingCafeBazar.isClosed){
      isLoadingCafeBazar.sink.add(false);
    }
    if(responseBody != null){
      if(responseBody['valid']){
        if(!responseBody['needPolar']){
          // cancelDialog();
          InfoAdviceTypes infoAdviceTypes = InfoAdviceTypes.fromJson(responseBody['clinic']);
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: ChartScreen(
                    limit: selectedEarForBuy.stream.value.cycleCount,
                    name: register.name,
                    expertPresenter: expertPresenter,
                    infoAdviceTypes: infoAdviceTypes,
                  )
              )
          );
          // Navigator.push(
          //     context,
          //     PageTransition(
          //         type: PageTransitionType.fade,
          //         child:  ChartScreen(
          //           limit: selectedEarForBuy.stream.value.cycleCount,
          //           name: register.name,
          //           expertPresenter: expertPresenter,
          //           infoAdviceTypes: infoAdviceTypes,
          //         )
          //     )
          // );
        }else{
          showToast(responseBody['message'], context);
        }
      }else{
        showToast(responseBody['message'], context);
      }
    }else{

      showToast('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید', context);
    }
  }



  showToast(String message,context){
    //Fluttertoast.showToast(msg:message,toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.BOTTOM);
    CustomSnackBar.show(context, message);
  }

  dispose(){
    circlesCompare.close();
    circlesTiming.close();
    isLoading.close();
    tryButtonError.close();
    valueError.close();
    reportEar.close();
    infoAdvice.close();
    isShowExitDialog.close();
    dialogScale.close();
    selectedEarForBuy.close();
    isLoadingButton.close();
    reportHistory.close();
    isLoadingPdf.close();
    isLoadingCafeBazar.close();
  }

}