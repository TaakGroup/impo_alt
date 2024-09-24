import 'dart:async';
import 'package:impo/src/data/local/database_provider.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/calender/alarm_model.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/dashboard/pregnancy_numbers_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/models/signsModel/breastfeeding_signs_model.dart';
import 'package:impo/src/models/signsModel/pregnancy_signs_model.dart';
import 'package:impo/src/models/story_model.dart';
import 'package:story_view/models/story_model.dart';

import '../../models/bioRhythm/bio_model.dart';

class DashboardModel {

  late DataBaseProvider db  =  DataBaseProvider();
  late RegisterParamModel registerInfo;
  late CycleModel cycleInfo;
  late PregnancySignsModel pregnancySignsInfo;
  late PregnancyNumberModel pregnancyNumberInfo;
  late BreastfeedingSignsModel breastfeedingSignsInfo;
  late BioModel bioInfo;
  late StoryLocatorModel storyLocatorInfo;


  DashboardModel(){
    db.database;
     registerInfo = locator<RegisterParamModel>();
     cycleInfo = locator<CycleModel>();
    pregnancySignsInfo = locator<PregnancySignsModel>();
    pregnancyNumberInfo = locator<PregnancyNumberModel>();
    breastfeedingSignsInfo = locator<BreastfeedingSignsModel>();
    bioInfo = locator<BioModel>();
    storyLocatorInfo = locator<StoryLocatorModel>();
  }


  RegisterParamViewModel getRegisters(){
    return registerInfo.register;
  }

  List<CycleViewModel> getAllCircles(){
    List<CycleViewModel> circles =  cycleInfo.cycle;
    return circles;
  }

   insertCircleToLocal(dynamic map) {
     cycleInfo.addCycle(map);
   }

  Future<List<DailyRemindersViewModel>?>getDailyReminders()async{
    List<DailyRemindersViewModel>? dailyReminders = await db.getAllDailyReminders();
    return dailyReminders;
  }

  Future<bool> insertToLocal(dynamic map , String tableName)async{
    await db.insertDb(map,tableName);
    return true;
  }

  PregnancySignsViewModel getPregnancySigns(){
    return pregnancySignsInfo.pregnancySings;
  }

  setPregnancyNumbers(pregnancyNumberViewModel){
    pregnancyNumberInfo.setPregnancyNumbers(pregnancyNumberViewModel);
  }

  PregnancyNumberViewModel getPregnancyNumber(){
    return pregnancyNumberInfo.pregnancyNumbers;
  }

  BreastfeedingSignsViewModel getBreastfeedingSigns(){
    return breastfeedingSignsInfo.breastfeedingSings;
  }

  BioViewModel getBioRyhthms(){
    return bioInfo.bioRythms;
  }

  void addAllBio(Map<String,dynamic> map){
    bioInfo.addAllBio(map);
  }

  StoryViewModel getStories(){
    return storyLocatorInfo.story;
  }

  List<CycleViewModel> getAllPeriodCircles(){
    List<CycleViewModel> circles = getAllCircles();
    List<CycleViewModel> periodCycles = [];
    List<CycleViewModel> reverseCycles = circles.reversed.toList();
    for(int i=0 ; i<reverseCycles.length ; i++){
      if(reverseCycles[i].status == 0){
        periodCycles.add(reverseCycles[i]);
      }else{
        break;
      }
    }
    return periodCycles.reversed.toList();
  }

  //
  //
  // Future<bool> insertSugMessagesToLocal(dynamic map)async{
  //    await db.insertDb(map,'SugMessages');
  //   return true;
  // }
  //
  //
  // Future closeDb()async{
  //   await db.close();
  // }
  //
  //
  //
  //  Future<CircleModel> getLastCircles()async{
  //  CircleModel circles = await db.getLastItemCircleFromLocal();
  //  return circles;
  // }
  //
  //
  //
  // Future<bool> updateCircle(newRow,id)async{
  //
  //     await db.updateTables('Circles',newRow,id);
  //
  //     return true;
  //
  // }
  //
  // Future<bool> updateSingns(newRow)async{
  //   CircleModel circles = await db.getLastItemCircleFromLocal();
  //
  //   await db.updateTables('Circles',newRow,circles.id);
  //
  //   return true;
  //
  // }
  //
  // updateIsSavedToServer(newRow,id){
  //   db.updateTables('Circles',newRow,id);
  // }
  //
  // Future<bool> updateServerIdAlarmCalender(id,newRow)async{
  //   await db.updateTables("Alarms", newRow, id);
  //   return true;
  // }
  //
  // Future<bool> updateServerIdAlarmDaily(id,newRow)async{
  //   await db.updateTables("DailyReminders", newRow, id);
  //   return true;
  // }
  //
  // updateRegister(String name,value)async{
  //   List<RegisterParamViewModel> registerModel = await db.getAllRecordsRegister();
  //   await db.updateTables('Register', {name:value}, registerModel[0].id);
  // }
  //
  //
  //
  // Future<bool> removeLastCircles(tableName, id)async{
  //   await db.insertDb({'myIndex' : id}, 'RemoveCircles');
  //   print('idddddddddddddddddddddddddddd:$id');
  //   await db.removeRecordTable(tableName, id);
  //   return true;
  // }
  //
  // Future<bool> removeTable(tableName)async{
  //   await db.removeTable(tableName);
  //   return true;
  // }
  //
  // Future<bool> removeRecordTable(tableName,id)async{
  //   await db.removeRecordTable(tableName,id);
  //   return true;
  // }
  //
  //
  //
  // Future<List<AlarmViewModel>>getAlarms()async{
  //   List<AlarmViewModel> alarms = await db.getAllAlarmsItem();
  //   return alarms;
  // }
  //
  // Future<List<RemoveAlarmsModel>>getRemoveAlarms()async{
  //   List<RemoveAlarmsModel> removeAlarms = await db.getAllRemoveAlarms();
  //   return removeAlarms;
  // }
  //
  // Future<List<DashBoardAndNotifyMessagesParentLocalModel>>getParentDashBoardMessages()async{
  //   List<DashBoardAndNotifyMessagesParentLocalModel> parentMessages = await db.getAllParentNotifyMessages();
  //   return parentMessages;
  // }
  //
  // Future<List<DashBoardAndNotifyMessagesLocalModel>>getDashBoardMessages()async{
  //   List<DashBoardAndNotifyMessagesLocalModel> messages = await db.getAllNotifyMessages();
  //   return messages;
  // }
  //
  //
  // Future<List<MotivalListModel>>getMotival()async{
  //   List<MotivalListModel> motival = await db.getAllMotival();
  //   return motival;
  // }
  //
  // Future<List<SugMessagesLocalModel>>getSugLocal()async{
  //   List<SugMessagesLocalModel> sugMessage = await db.getAllSugMessagesLocal();
  //   return sugMessage;
  // }
  //
  // Future<bool> deleteRemoveTable(int id)async{
  //   await db.removeRecordTable('RemoveAlarms', id);
  //   return true;
  // }
  //


}