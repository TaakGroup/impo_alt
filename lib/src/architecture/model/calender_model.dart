import 'dart:async';
import 'package:impo/src/components/number_to_text_withM.dart';
import 'package:impo/src/data/local/database_provider.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/bioRhythm/bio_model.dart';
import 'package:impo/src/models/calender/alarm_model.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/dashboard/pregnancy_numbers_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';

class CalenderModel {

  late DataBaseProvider db  =  DataBaseProvider();
  late RegisterParamModel registerInfo;
  late CycleModel cycleInfo;
  late PregnancyNumberModel pregnancyNumberInfo;
  late BioModel bioInfo;

  CalenderModel(){
    db.database;
    registerInfo = locator<RegisterParamModel>();
    cycleInfo = locator<CycleModel>();
    pregnancyNumberInfo = locator<PregnancyNumberModel>();
    bioInfo = locator<BioModel>();
  }



  Future<List<AlarmViewModel>?> getAllAlarms()async{

    List<AlarmViewModel>? alarmsItems = await db.getAllAlarmsItem();

    return alarmsItems;

  }

  RegisterParamViewModel getRegisters(){
    return registerInfo.register;
  }

  CycleViewModel getLastCircles(){
    CycleViewModel circles = cycleInfo.cycle[cycleInfo.cycle.length-1];
    return circles;
  }

  void addAllBio(Map<String,dynamic> map){
    bioInfo.addAllBio(map);
  }

//
//
//
//   Future<List<CircleModel>>getAllCircles()async{
//     List<CircleModel> circles = await db.getAllCirclesItem();
//     return circles;
//   }
//

  List<CycleViewModel> getAllCycles(){
    List<CycleViewModel> circlesItem = cycleInfo.cycle;
    return circlesItem;
  }

  List<CycleViewModel> getCircleItems(){
    var cyclesInfo = locator<CycleModel>();
    var registerInfo = locator<RegisterParamModel>();


    List<CycleViewModel> circlesItem = [];
    for(int i=0 ; i<cyclesInfo.cycle.length ; i++){
      DateTime _periodStart = DateTime.parse(cyclesInfo.cycle[i].periodStart!);
      DateTime _periodEnd = DateTime.parse(cyclesInfo.cycle[i].periodEnd!);
      DateTime _cycleEnd = DateTime.parse(cyclesInfo.cycle[i].circleEnd!);
      circlesItem.add(
          CycleViewModel.fromJson({
            'periodStartDate' : DateTime(_periodStart.year,_periodStart.month,_periodStart.day).toString(),
            'periodEndDate' :  DateTime(_periodEnd.year,_periodEnd.month,_periodEnd.day).toString(),
            'cycleEndDate' :  DateTime(_cycleEnd.year,_cycleEnd.month,_cycleEnd.day).toString(),
            'status' : cycleInfo.cycle[i].status,
            'before' : cyclesInfo.cycle[i].before,
            'after' : cyclesInfo.cycle[i].after,
            'mental' : cyclesInfo.cycle[i].mental,
            'other' : cyclesInfo.cycle[i].other,
            'ovu' : cyclesInfo.cycle[i].ovu
          })
      );
    }
    RegisterParamViewModel registerModel = registerInfo.register;

    if(registerModel.status == 1){
      for (int i = 0; i < 2;i++)
      {

        CycleViewModel oldItem = circlesItem[circlesItem.length-1];
        CycleViewModel newItem =  CycleViewModel();


        DateTime oldEndCycle = DateTime.parse(oldItem.circleEnd!);
        DateTime newPeriodStart = DateTime(oldEndCycle.year,oldEndCycle.month,oldEndCycle.day + 1);
        newItem.setPeriodStart(newPeriodStart.toString());

        DateTime newPeriodEnd = DateTime(newPeriodStart.year,newPeriodStart.month,(newPeriodStart.day) + (registerModel.periodDay!-1));
        newItem.setPeriodEnd(newPeriodEnd.toString());

        DateTime newCycleEnd = DateTime(newPeriodStart.year,newPeriodStart.month,(newPeriodStart.day) + (registerModel.circleDay! - 1));
        newItem.setCircleEnd(newCycleEnd.toString());
        /// newItem.setIsSavedToServer(0);

        /// newItem.setId(oldItem.getId()+1);

        newItem.setStatus(0);
        newItem.setBefore(oldItem.getBefore());
        newItem.setAfter(oldItem.getAfter());
        newItem.setMental(oldItem.getMental());
        newItem.setOther(oldItem.getOther());
        newItem.setOvu(oldItem.getOvu());

        circlesItem.add(newItem);
      }
    }
    int pCurrentWeek=0;
    int bCurrentWeek=0;

    for(int i=0 ; i<circlesItem.length ; i++){
      if(circlesItem[i].status == 2){
        // print(circlesItem[i].periodStart);
        pCurrentWeek++;
        String textCurrentWeek = NumberToTextWithM().ConvertWithM(pCurrentWeek);
        int currentMonth;


        if(pCurrentWeek <= 4){
          currentMonth = 1;
        }else if(pCurrentWeek <= 8){
          currentMonth = 2;
        }else if(pCurrentWeek <= 13){
          currentMonth = 3;
        }else if(pCurrentWeek <= 17){
          currentMonth = 4;
        }else if(pCurrentWeek <= 22){
          currentMonth = 5;
        }else if(pCurrentWeek <= 27){
          currentMonth = 6;
        }else if(pCurrentWeek <= 31){
          currentMonth = 7;
        }else if(pCurrentWeek <= 35){
          currentMonth = 8;
        }else if(pCurrentWeek <= 40){
          currentMonth = 9;
        }else{
          currentMonth = 10;
        }

        String textCurrentMonth = currentMonth <=9 ? NumberToTextWithM().ConvertWithM(currentMonth) : 'آخر';


        circlesItem[i].isOdd = i.isOdd;
        circlesItem[i].isCurrentWeek = registerModel.status == 2 ? pregnancyNumberInfo.pregnancyNumbers.weekNoPregnancy == pCurrentWeek ? true : false : false;
        circlesItem[i].textWeek = 'هفته $textCurrentWeek بارداری (ماه $textCurrentMonth)';
        circlesItem[i].isLastWeek = pCurrentWeek >= 41 && registerModel.status == 2 ?
        false : i == circlesItem.length - 1 ? true :
        circlesItem[i+1].status == 3 || circlesItem[i+1].status == 0 ? true : false;
        // print('pCurrentWeek : $pCurrentWeek');

      }else{
        pCurrentWeek = 0;
      }
      if(circlesItem[i].status == 3){
        bCurrentWeek++;
        String textCurrentWeek = NumberToTextWithM().ConvertWithM(bCurrentWeek);
        double _currentMonth = bCurrentWeek/4;
        int currentMonth;
        if(int.tryParse(_currentMonth.toString().split('.')[1]) != 0){
          currentMonth = (bCurrentWeek~/4)+1;
        }else{
          currentMonth = (bCurrentWeek~/4);
        }
        //String textCurrentMonth = bCurrentWeek <= 21 ? NumberToTextWithM().ConvertWithM(currentMonth) : 'آخر';
        String textCurrentMonth = NumberToTextWithM().ConvertWithM(currentMonth);
        circlesItem[i].isOdd = i.isOdd;
        circlesItem[i].isCurrentWeek = registerModel.status == 3 ? registerModel.breastfeedingNumberModel!.breastfeedingCurrentWeek == bCurrentWeek ? true : false : false;
        circlesItem[i].textWeek = 'هفته $textCurrentWeek شروع مادری (ماه $textCurrentMonth)';
      }else{
        bCurrentWeek =0;
      }
    }

    return circlesItem;

  }

  // generatePregnancyAndBreastfeeding(List<CycleViewModel> circlesItem){
  //
  //   RegisterParamViewModel register = registerInfo.register;
  //   DateTime lastPeriod = pregnancyNumberInfo.pregnancyNumbers.lastPeriod;
  //   DateTime childBirthDate = register.childBirthDate;
  //
  //    List<int> counterRemoves = [];
  //   for(int i=0 ; i<circlesItem.length ; i++){
  //     print(circlesItem[i].circleEnd);
  //     if(
  //     // lastPeriod.isAfter(DateTime.parse(circlesItem[i].periodStart)) &&
  //     lastPeriod.isBefore(DateTime.parse(circlesItem[i].circleEnd))){
  //       print('11111111');
  //       counterRemoves.add(i);
  //       // circlesItem.removeAt(i);
  //     }
  //   }
  //   print(circlesItem.length);
  //   if(counterRemoves.length != 0){
  //     circlesItem.removeRange(counterRemoves[0], counterRemoves[counterRemoves.length-1]+1);
  //   }
  //   print(circlesItem.length);
  //
  //
  //   for(int i=0 ; i<40 ; i++){
  //     int currentWeek  = i+1;
  //     String textCurrentWeek = NumberToTextWithM().ConvertWithM(currentWeek);
  //     double _currentMonth = currentWeek/4;
  //     int currentMonth;
  //
  //     if(int.tryParse(_currentMonth.toString().split('.')[1]) != 0){
  //       currentMonth = (currentWeek~/4)+1;
  //     }else{
  //       currentMonth = (currentWeek~/4);
  //     }
  //     String textCurrentMonth = currentWeek <= 36 ? NumberToTextWithM().ConvertWithM(currentMonth) : 'آخر';
  //     DateTime circleEnd = DateTime(lastPeriod.year,lastPeriod.month,lastPeriod.day+(i*7)+6);
  //     if(register.status == 3 && circleEnd.isAfter(childBirthDate)){
  //       circleEnd = childBirthDate;
  //     }
  //     circlesItem.add(
  //       CycleViewModel(
  //         periodStart: DateTime(lastPeriod.year,lastPeriod.month,lastPeriod.day+(i*7)).toString(),
  //         // periodEnd: DateTime(lastPeriod.year,lastPeriod.month,lastPeriod.day+(i*7)+6).toString(),
  //         circleEnd: circleEnd.toString(),
  //         isOdd: i.isOdd,
  //         isCurrentWeek: register.status == 2 ? pregnancyNumberInfo.pregnancyNumbers.weekNoPregnancy == i+1 ? true : false : false,
  //         textWeek: 'هفته $textCurrentWeek بارداری (ماه $textCurrentMonth)'
  //       )
  //     );
  //     if(circleEnd == childBirthDate){
  //       break;
  //     }
  //   }
  //
  //   if(register.status == 3){
  //     DateTime startDate = DateTime(childBirthDate.year,childBirthDate.month,childBirthDate.day+1);
  //     for(int i=0 ; i<25 ; i++){
  //       int currentWeek  = i+1;
  //       String textCurrentWeek = NumberToTextWithM().ConvertWithM(currentWeek);
  //       double _currentMonth = currentWeek/4;
  //       int currentMonth;
  //
  //       if(int.tryParse(_currentMonth.toString().split('.')[1]) != 0){
  //         currentMonth = (currentWeek~/4)+1;
  //       }else{
  //         currentMonth = (currentWeek~/4);
  //       }
  //       String textCurrentMonth = currentWeek <= 21 ? NumberToTextWithM().ConvertWithM(currentMonth) : 'آخر';
  //       circlesItem.add(
  //           CycleViewModel(
  //               periodStart: DateTime(startDate.year,startDate.month,startDate.day+(i*7)).toString(),
  //               circleEnd: DateTime(startDate.year,startDate.month,startDate.day+(i*7)+6).toString(),
  //               isOdd: i.isOdd,
  //               isCurrentWeek: register.breastfeedingCurrentWeek == i+1 ? true : false,
  //               textWeek: 'هفته $textCurrentWeek شیردهی (ماه $textCurrentMonth)'
  //           )
  //       );
  //     }
  //   }
  // }

  Future<bool> updateTable(String tableName,Map<String,dynamic> newRow,id)async{
    await db.updateTables(tableName, newRow, id);
    return true;
  }
//
  Future<bool>  insertAlarmsToLocal(dynamic map)async{
    var result = await db.insertDb(map,'Alarms');
    return true;
  }
//
//   Future<bool> insertToRemoveTable(dynamic map)async{
//     var result = await db.insertDb(map,'RemoveAlarms');
//     return true;
//   }
//
//
//
//
//
  Future<bool> removeRecord(tableName, id)async{
    await db.removeRecordTable(tableName, id);
    return true;
  }
//
//
//   Future<bool> insertToRemoveCircles(dynamic map)async{
//     var result = await db.insertDb(map,'RemoveCircles');
//     return true;
//   }
//
//   Future<bool> removeTable(String tableName)async{
//     await db.removeTable(tableName);
//     return true;
//   }
//

  // Future closeDb()async{
  //   await db.close();
  // }


}