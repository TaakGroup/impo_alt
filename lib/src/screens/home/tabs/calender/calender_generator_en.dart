
import 'dart:core';
import 'package:impo/src/components/DateTime/my_datetime.dart';
import 'package:impo/src/models/calender/cell_item.dart';
import 'package:impo/src/models/calender/grid_item.dart';
import 'package:impo/src/models/circle_model.dart';
// import 'package:shamsi_date/shamsi_date.dart';
import 'package:intl/intl.dart';

class CalendarGeneratorEN {


  List<CycleViewModel> circleItems = [];
  late CycleViewModel lastCircle;
  late CycleViewModel counterCircle;
  late DateTime counterStartFert;
  late DateTime counterEndFert;

  int indexCircle = 0;
  int counter = 1;
  int indexIsNotInMonth=0;


  List<GirdItem> getGridList(List<CycleViewModel> circleItems,nationality){
//    print(circleItems);
    List<GirdItem> gridItems = [];
    this.circleItems = circleItems;
    lastCircle = circleItems[circleItems.length-1];
    counterCircle = circleItems[0];
    DateTime _cycleEnd = DateTime.parse(lastCircle.circleEnd!);
    DateTime cycleEnd = DateTime(_cycleEnd.year,_cycleEnd.month,_cycleEnd.day-1);
    if(counterCircle.status == 0)setFertTime();

    DateTime dateInGrid = DateTime.parse(counterCircle.periodStart!);


    while (true)
    {
      GirdItem grid = generateGrid(dateInGrid,nationality);
      gridItems.add(grid);
//      print(grid.persianTitle);
      // grid.getCells().get(grid.getIndexOfLastDayOfMonth()).getDateTime().getTime() >= lastCircle.getCycleEndDate().getTime()
      if (grid.getCells()[grid.indexOfLastDayOfMonth].dateTime!.isAfter(cycleEnd))
        break;
      else
//        dateInGrid = DateGenerator.GetAfterDay(grid.getCells().get(grid.getCells().size() - 1).getDateTime(),1);
        dateInGrid = DateTime(grid.getCells()[(grid.getCells().length) - 1].dateTime!.year,grid.getCells()[(grid.getCells().length) - 1].dateTime!.month,(grid.getCells()[(grid.getCells().length) - 1].dateTime!.day)+1);
    }

    return gridItems;

  }

  getNewCircle(bool isNotInMonth) {
    if(isNotInMonth) indexIsNotInMonth++;
    indexCircle++;
    if (indexCircle < circleItems.length) {
//      counterCircle = circleItems.get(indexCircle);
      counterCircle = circleItems[indexCircle];
      if(counterCircle.status == 0)setFertTime();
    }
  }


  void getPrevCircle() {
    if (indexCircle > 0) {
      for(int i=0 ; i<indexIsNotInMonth ; i++){

        indexCircle--;
      }
      indexIsNotInMonth=0;
      // if(indexCircle == 2){
      //   indexCircle--;
      //   indexCircle--;
      // }
      // indexCircle--;
      // print('indexCircle');
//      counterCircle = circleItems.get(indexCircle);
      counterCircle = circleItems[indexCircle];
      if(counterCircle.status == 0)setFertTime();
    }
  }

  // String format1(Date d,nationality) {
  //   final f = d.formatter;
  //
  //   if(nationality == 'IR'){
  //     return "${f.mN} ${f.yyyy}";
  //   }else{
  //     return "${f.mnAf} ${f.yyyy}";
  //   }
  // }


  GirdItem generateGrid(DateTime dateInGrid,nationality) {
    bool selectDay = false;
    GirdItem currentGrid = new GirdItem();
//    DateTime cycleEnd = DateTime.parse(counterCircle.circleEnd);
//     Jalali shamsi = Jalali.fromDateTime(dateInGrid);
//    currentGrid.persianTitle = "${shamsi.month}  ${shamsi.year}";
    final DateFormat formatter = DateFormat('LLL yyyy','fa');
    currentGrid.setPersianTitle(formatter.format(dateInGrid));
    DateTime dayGrid = goToFirstDayGrid(dateInGrid);
//    DateTime periodStart = DateTime.parse(counterCircle.periodStart);
    // DateGenerator.GetDaysBetween(dayGrid,counterCircle.getPeriodStartDate()) > 0
    if ( MyDateTime().myDifferenceDays(dayGrid,DateTime.parse(counterCircle.periodStart!)) > 0)
      getPrevCircle();
    for(int i = 0;i < 42;i++)
    {
      CellItem cell_item = new CellItem();
      cell_item.setDateTime(dayGrid);
//      cell_item.dateTime = dayGrid;
      checkCircleItem(cell_item);
      checkInThisMonth(cell_item,dayGrid,dateInGrid.month,currentGrid,i);
      checkToday(cell_item,dayGrid,i,currentGrid);
      if(counterCircle.status == 0){
        checkColorDay(cell_item,dayGrid);
      }

      if(counterCircle.status == 2){
        if(counterCircle.isLastWeek!){
          /// DateTime periodStart = DateTime.parse(counterCircle.periodStart!);
          // DateTime yesterdayPeriodStart = DateTime(periodStart.year,periodStart.month,periodStart.day - 1);
          DateTime cycleEnd = DateTime.parse(counterCircle.circleEnd!);
          // DateTime tomorrowCycleEnd = DateTime(cycleEnd.year,cycleEnd.month,cycleEnd.day + 1);
          DateTime periodEnd = DateTime.parse(counterCircle.periodEnd!);
          DateTime hasAbortionDateTime = DateTime(3000,1,1);
          if(cycleEnd.year == cell_item.dateTime!.year
              && cycleEnd.month == cell_item.dateTime!.month && cycleEnd.day == cell_item.dateTime!.day){
            if(periodEnd.year == hasAbortionDateTime.year && periodEnd.month == hasAbortionDateTime.month && periodEnd.day == hasAbortionDateTime.day){
              cell_item.setDayOfAbortion(true);
            }else{
              cell_item.setIsDayOfDelivery(true);
            }
            // if(periodEnd.isAfter(yesterdayPeriodStart) && periodEnd.isBefore(tomorrowCycleEnd)){
            //   cell_item.setIsDayOfDelivery(true);
            // }else{
            //   cell_item.setDayOfAbortion(true);
            // }
          }
        }
      }

      if (!selectDay)
        selectDay = selectOneDay(dayGrid,dateInGrid.month,currentGrid,i);
      currentGrid.getCells().add(cell_item);
//        currentGrid.cells.add(cell_item);
//      DateGenerator.GetDaysBetween(dayGrid,counterCircle.getCycleEndDate()) == 0
//      print(cycleEnd.difference(dayGrid).inDays);
//      print(cell_item.dateTime)
//       print(Jalali.fromDateTime(cell_item.getDateTime()).day.toString());
//      print('day Grid$dayGrid');
//      print('cycleEnd$DateTime.parse(counterCircle.circleEnd)');
      if (MyDateTime().myDifferenceDays(dayGrid, DateTime.parse(counterCircle.circleEnd!)) == 0){
//        print(cycleEnd.difference(dayGrid).inDays);
//        print(dayGrid.difference(cycleEnd).inDays);
        getNewCircle(cell_item.isNotInMonth());
//        print(counter++);
      }

//      print('day Grid after$dayGrid');
//      print('cycleEnd after$DateTime.parse(counterCircle.circleEnd)');

//      dayGrid = DateGenerator.GetAfterDay(dayGrid,1);
      dayGrid = DateTime(dayGrid.year,dayGrid.month,dayGrid.day+1);
//        print('day grdi : ${dayGrid}');
    }
    return currentGrid;
  }

  void checkInThisMonth(CellItem item,DateTime pointDate,int monthNumber,GirdItem grid_item,int index) {
    // Jalali dateShamsi = Jalali.fromDateTime(pointDate);
    if (pointDate.month != monthNumber)
      item.setNotInMonth(true);
//      item.notInMonth = true;
    else {
      item.setNotInMonth(false);
//       item.notInMonth = false;
      grid_item.setIndexOfLastDayOfMonth(index);
//      grid_item.indexOfLastDayOfMonth = index;
    }
  }

  bool selectOneDay(DateTime pointDate,int monthNumber,GirdItem grid_item,int index){

    // Jalali dateShamsi = Jalali.fromDateTime(pointDate);
    if (pointDate.month != monthNumber)
      return false;
    else {
      grid_item.setIndexSelect(index);
//      grid_item.indexSelect = index;
      return true;
    }
  }

  void checkColorDay(CellItem item,DateTime pointDate) {
    DateTime _periodStart = DateTime.parse(counterCircle.periodStart!);
    DateTime periodStart = DateTime(_periodStart.year,_periodStart.month,_periodStart.day-1);
    DateTime _periodEnd = DateTime.parse(counterCircle.periodEnd!);
    DateTime periodEnd = DateTime(_periodEnd.year,_periodEnd.month,_periodEnd.day+1);
    DateTime _cycleEnd = DateTime.parse(counterCircle.circleEnd!);
    DateTime cycleEnd = DateTime(_cycleEnd.year,_cycleEnd.month,_cycleEnd.day+1);
    DateTime pmsStart = DateTime(_cycleEnd.year,_cycleEnd.month,_cycleEnd.day-5);
    DateTime startFert = DateTime(counterStartFert.year,counterStartFert.month,counterStartFert.day-1);
    DateTime endFert = DateTime(counterEndFert.year,counterEndFert.month,counterEndFert.day+1);
    DateTime ovumDay = DateTime(_cycleEnd.year,_cycleEnd.month,_cycleEnd.day-13);
//    print(Jalali.fromDateTime(_periodStart).day.toString());
//    print(Jalali.fromDateTime(item.getDateTime()).day.toString());
    //pointDate.getTime() >= counterCircle.getPeriodStartDate().getTime() && pointDate.getTime() <= counterCircle.getPeriodEndDate().getTime()
    if (pointDate.isAfter(periodStart) && pointDate.isBefore(periodEnd))
      item.setPeriod(true);
//      item.isPeriod = true;
    //pointDate.getTime() >= DateGenerator.GetAfterDay(counterCircle.getCycleEndDate(),-4).getTime() && pointDate.getTime() <= (counterCircle.getCycleEndDate().getTime()) && DateGenerator.GetDaysBetween(counterCircle.getPeriodStartDate(),counterCircle.getCycleEndDate()) > 15
    else if (pointDate.isAfter(pmsStart) && pointDate.isBefore(cycleEnd) && MyDateTime().myDifferenceDays(_periodStart,_cycleEnd) > 15)
      item.setPMS(true);
//      item.isPMS = true;
    //pointDate.getTime() >= counterStartFert.getTime() && pointDate.getTime() <= counterEndFert.getTime() && DateGenerator.GetDaysBetween(counterCircle.getPeriodStartDate(),counterCircle.getCycleEndDate()) > 18
    else if (pointDate.isAfter(startFert) && pointDate.isBefore(endFert) && MyDateTime().myDifferenceDays(_periodStart,_cycleEnd) > 18)
      if(!(MyDateTime().myDifferenceDays(_periodEnd,_cycleEnd) < 15)){
        item.setFert(true);
      }
//        item.isFert = true;
    // DateGenerator.isOneDay(pointDate,counterStartFert)
    if (pointDate.year == counterStartFert.year && pointDate.month == counterStartFert.month && pointDate.day == counterStartFert.day && MyDateTime().myDifferenceDays(_periodStart,_cycleEnd) > 18)
      item.setStartFert(true);
//        item.isStartFert = true;
    // DateGenerator.isOneDay(pointDate,counterEndFert)
    else if (pointDate.year == counterEndFert.year && pointDate.month == counterEndFert.month && pointDate.day == counterEndFert.day&& MyDateTime().myDifferenceDays(_periodStart,_cycleEnd) > 18)
      item.setEndFert(true);
//        item.isEndFert = true;
    //DateGenerator.GetDaysBetween(counterCircle.getPeriodStartDate(),counterCircle.getCycleEndDate()) > 18
    if (MyDateTime().myDifferenceDays(_periodStart,_cycleEnd) > 18) {
      // DateGenerator.isOneDay(pointDate, DateGenerator.GetAfterDay(counterCircle.getCycleEndDate(), -13))
      if (pointDate.year == ovumDay.year && pointDate.month == ovumDay.month && pointDate.day == ovumDay.day){
        if(!(MyDateTime().myDifferenceDays(_periodEnd,_cycleEnd) < 15)){
          item.setOvom(true);
        }
      }
//          item.isOvom = true;

    }

  }

  void checkToday(CellItem cell_item,DateTime pointDate ,int position,GirdItem grid_item) {
    //DateGenerator.isOneDay(pointDate,DateGenerator.GetCurrentDate())
    DateTime today = DateTime.now();
    if ( (today.year == pointDate.year && today.month == pointDate.month && today.day == pointDate.day)&& (!cell_item.isNotInMonth())) {
      grid_item.setIndexSelect(position);
//    grid_item.indexSelect = position;
      grid_item.setCurrent(true);
//      grid_item.isCurrent = true;
      cell_item.setToday(true);
//    cell_item.isToday = true;
    }
  }

  void checkCircleItem(CellItem cellItem) {
    DateTime periodStart = DateTime.parse(counterCircle.periodStart!);
    DateTime cycleEnd = DateTime.parse(counterCircle.circleEnd!);
    //cellItem.getDateTime().getTime() < counterCircle.getPeriodStartDate().getTime() || cellItem.getDateTime().getTime() > counterCircle.getCycleEndDate().getTime()
    if (cellItem.getDateTime().isBefore(periodStart) || cellItem.getDateTime().isAfter(cycleEnd))
      cellItem.setCircleItem(null);
//      cellItem.circleItem = null;
    else {
      cellItem.setCircleItem(counterCircle);
    }
//       cellItem.circleItem = counterCircle;
  }

  DateTime goToFirstDayGrid(DateTime dateInGrid) {
    DateTime counterDate  = dateInGrid;
    bool isAchieveFirst = false;
    while (true)
    {
      // Jalali counterShamsi = Jalali.fromDateTime(counterDate);
      //Dar sorate residan be avale mah isAchive baraye residan Be Shanbe True mishavad
      if (counterDate.day == 1)
        isAchieveFirst = true;

      if (isAchieveFirst && counterDate.weekday == 1)
      {
        return counterDate;
      }
      else
        counterDate = DateTime(counterDate.year,counterDate.month,counterDate.day -1);
//        counterDate = DateGenerator.GetYesterDay(counterDate);

    }
  }

  void setFertTime() {
    DateTime periodEnd = DateTime.parse(counterCircle.periodEnd!);
    DateTime cycleEnd = DateTime.parse(counterCircle.circleEnd!);
    // DateGenerator.GetDaysBetween(counterCircle.getPeriodEndDate(),counterCircle.getCycleEndDate())
    if (MyDateTime().myDifferenceDays(periodEnd,cycleEnd) <= 18)
//      counterStartFert = DateGenerator.GetAfterDay(counterCircle.getPeriodEndDate(),1);
      counterStartFert = DateTime(periodEnd.year,periodEnd.month,periodEnd.day+1);
    else
//      counterStartFert = DateGenerator.GetAfterDay(counterCircle.getCycleEndDate(),-18);
      counterStartFert = DateTime(cycleEnd.year,cycleEnd.month,cycleEnd.day - 18);

//    counterEndFert = DateGenerator.GetAfterDay(counterCircle.getCycleEndDate(),-10);
    counterEndFert = DateTime(cycleEnd.year,cycleEnd.month,cycleEnd.day - 10);
  }

}