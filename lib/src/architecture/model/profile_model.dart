
import 'package:impo/src/architecture/model/register_model.dart';
import 'package:impo/src/data/local/database_provider.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/calender/alarm_model.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/profile/profile_all_data_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';

import '../../models/bioRhythm/bio_model.dart';


class ProfileModel {

  late DataBaseProvider db  =  DataBaseProvider();
  late RegisterParamModel registerInfo;
  late BioModel bioInfo;
  late ProfileAllDataModel profileAllDataInfo;

  ProfileModel(){
    registerInfo = locator<RegisterParamModel>();
    db.database;
    bioInfo = locator<BioModel>();
    profileAllDataInfo = locator<ProfileAllDataModel>();
  }


  RegisterParamViewModel getRegisters(){
    return registerInfo.register;
  }

  Future<List<DailyRemindersViewModel>?>getDailyReminders()async{
    List<DailyRemindersViewModel>? dailyReminders = await db.getAllDailyReminders();
    return dailyReminders;
  }

  void addAllBio(Map<String,dynamic> map){
    bioInfo.addAllBio(map);
  }

  //
  // updatePeriodDays(int newDays)async{
  //   Future<CircleModel> circles = db.getLastItemCircleFromLocal();
  //   List<RegisterParamViewModel> registerModel = await db.getAllRecordsRegister();
  //   circles.then((value) {
  //     DateTime periodStart = DateTime.parse(value.periodStart);
  //     DateTime periodEnd = DateTime(periodStart.year,periodStart.month,periodStart.day + (newDays -1));
  //     db.updateTables('Register',{'periodDay' : newDays}, registerModel[0].id);
  //     db.updateTables('Circles',{'isSavedToServer' : 0,'periodEnd' : periodEnd.toString()}, value.id);
  //
  //   });
  //
  // }
  //
  // updateCirclesDay(int newDays)async{
  //   Future<CircleModel> circles = db.getLastItemCircleFromLocal();
  //   List<RegisterParamViewModel> registerModel = await db.getAllRecordsRegister();
  //   circles.then((value) {
  //     DateTime periodStart = DateTime.parse(value.periodStart);
  //     DateTime circleEnd = DateTime(periodStart.year,periodStart.month,periodStart.day + (newDays -1));
  //     print(newDays);
  //     db.updateTables('Register',{'circleDay' : newDays}, registerModel[0].id);
  //     db.updateTables('Circles',{'isSavedToServer' : 0,'circleEnd' : circleEnd.toString()}, value.id);
  //   });
  // }
  //
  // Future<bool> insertCircleToLocal(dynamic map)async{
  //   var result = await db.insertDb(map,'Circles');
  //   return true;
  //
  // }
  //
  // void updateCircleDaysRegister(newDays)async{
  //   List<RegisterParamViewModel> registerModel = await db.getAllRecordsRegister();
  //  await db.updateTables('Register',{'circleDay' : newDays}, registerModel[0].id);
  // }
  //
  // Future<bool> updateProfile(String name,value)async{
  //   List<RegisterParamViewModel> registerModel = await db.getAllRecordsRegister();
  //   await db.updateTables('Register', {name:value}, registerModel[0].id);
  //   return true;
  // }
  //
  //
  //
  Future<bool> updateTable(tableName, newRow, id)async{
    db.updateTables(tableName, newRow, id);
    return true;
  }

  Future<bool> insertToRemoveTable(dynamic map)async{
    var result = await db.insertDb(map,'RemoveAlarms');
    return true;
  }

  ProfileAllDataViewModel getProfileAllData(){
    return profileAllDataInfo.profileAllData;
  }

  //
  // Future<List<DailyReminders>> getAllDailyReminders()async{
  //   return await db.getAllDailyReminders();
  // }
  //
  //
  // Future<CircleModel> getLastCircle()async{
  //   CircleModel circles = await db.getLastItemCircleFromLocal();
  //   return circles;
  // }
  //
  // Future<bool> insertToLocal(dynamic map , String tableName)async{
  //   await db.insertDb(map,tableName);
  //   return true;
  // }
  //
  // Future<bool> removeTable(tableName)async{
  //   await db.removeTable(tableName);
  //   return true;
  // }
  //
  //
  // Future<List<CircleModel>>getAllCircles()async{
  //   List<CircleModel> circles = await db.getAllCirclesItem();
  //   return circles;
  //   }
  //
  // Future closeDb()async{
  //   await db.close();
  // }

  }