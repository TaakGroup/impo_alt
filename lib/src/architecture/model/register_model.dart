


import 'package:impo/src/data/local/database_provider.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/calender/alarm_model.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/models/remove_alarms_model.dart';

class RegisterModel {

  DataBaseProvider db  =  DataBaseProvider();
  //

  late RegisterParamModel registerInfo;
  late CycleModel cycleInfo;

  RegisterModel(){
    db.database;
     registerInfo = locator<RegisterParamModel>();
     cycleInfo = locator<CycleModel>();
  }

  insertDataRegister(RegisterParamViewModel registerParamViewModel){
    registerInfo.setAllRegister(registerParamViewModel);
  }

   insertDataCycles(dynamic map){
    cycleInfo.addCycle(map);
  }

  RegisterParamViewModel getRegisterInfo(){
    return registerInfo.register;
  }

   updateSings(CycleViewModel cycleViewModel){
      cycleInfo.updateCycle(cycleInfo.cycle.length-1, cycleViewModel);
    }

  Future<List<DailyRemindersViewModel>?>getDailyReminders()async{
    List<DailyRemindersViewModel>? dailyReminders = await db.getAllDailyReminders();
    return dailyReminders;
  }

  CycleViewModel getLastCircle(){
    return cycleInfo.cycle[cycleInfo.cycle.length-1];
  }

  Future<List<AlarmViewModel>?>getAlarms()async{
    List<AlarmViewModel>? alarms = await db.getAllAlarmsItem();
    return alarms;
  }

  Future<bool> insertDailyRemindersToLocal(dynamic map)async{
    var result = await db.insertDb(map,'DailyReminders');
    return true;
  }

  Future<bool> insertAlarmsToLocal(dynamic map)async{
    var result = await db.insertDb(map,'Alarms');
    return true;
  }

  Future<bool> updateDailyRemindersToLocal(id,newRow)async{
    await db.updateTables('DailyReminders',
        newRow, id
    );
    return true;
  }

  Future<bool> removeTable(String tableName)async{
    await db.removeTable(tableName);
    return true;
  }

  //
  // Future<List<RemoveAlarmsModel>>getRemoveAlarms()async{
  //   List<RemoveAlarmsModel> removeAlarms = await db.getAllRemoveAlarms();
  //   return removeAlarms;
  // }
  //
  //
  // Future<bool> updateServerIdAlarmCalender(id,newRow)async{
  //   await db.updateTables("Alarms", newRow, id);
  //   return true;
  // }
  //
  // Future<bool> deleteRemoveTable(int id)async{
  //   await db.removeRecordTable('RemoveAlarms', id);
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
  // Future<RegisterParamViewModel>getRegisters()async{
  //   List<RegisterParamViewModel> registerModel = await db.getAllRecordsRegister();
  //   return registerModel[0];
  // }
  //
  // Future<bool> insertCircleToLocal(dynamic map)async{
  //   var result = await db.insertDb(map,'Circles');
  //   return true;
  //
  // }
  //
  //
  // Future<List<CircleModel>>getAllCircles()async{
  //   List<CircleModel> circles = await db.getAllCirclesItem();
  //   return circles;
  // }
  //
  // Future closeDb()async{
  //   await db.close();
  // }
  // //


}