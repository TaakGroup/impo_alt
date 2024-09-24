import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:impo/src/models/calender/alarm_model.dart';
import 'package:impo/src/models/cancel_notify.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/dashboard/dashboard_messages_and_notify_model.dart';
import 'package:impo/src/models/dashboard/dashboard_msg_offline_mode.dart';
import 'package:impo/src/models/remove_alarms_model.dart';
import 'package:impo/src/models/signsModel/sings_view_model.dart';
import 'package:impo/src/singleton/notification_init.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';


class DataBaseProvider{

  static Database? _dataBase;




  initDB()async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentDirectory.path,'RegisterDB.db');

    return await openDatabase(path,version: 7,onOpen: (db){},
        onCreate: (Database db,int version)async {
          await db.execute("CREATE TABLE Alarms ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "date TEXT,"
              "hour INTEGER,"
              "minute INTEGER,"
              "text TEXT,"
              "description TEXT,"
              "isActive INTEGER,"
              "serverId TEXT,"
              "fileName TEXT,"
              "isChange INTEGER,"
              "mode INTEGER,"
              "readFlag INTEGER"
              ")");
          await db.execute("CREATE TABLE DailyReminders ("
              "id INTEGER PRIMARY KEY,"
              "title TEXT,"
              "time TEXT,"
              "isSound INTEGER,"
              "mode INTEGER,"
              "dayWeek TEXT,"
              "serverId TEXT,"
              "isChange INTEGER"
              ")");
          await db.execute("CREATE TABLE CancelNotify ("
              "id INTEGER PRIMARY KEY,"
              "notifyId INTEGER"
              ")"
          );
          await db.execute("CREATE TABLE RemoveAlarms ("
              "id INTEGER PRIMARY KEY,"
              "mode INTEGER,"
              "serverId TEXT"
              ")"
          );
          await db.execute("CREATE TABLE Cycles ("  //========> for Offline Mode
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "periodStartDate TEXT,"
              "periodEndDate TEXT,"
              "cycleEndDate TEXT,"
              "status INTEGER"
              ")");
          await db.execute("CREATE TABLE MotivalMsg ("  //========> for Offline Mode
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "text TEXT"
              ")");
          await db.execute("CREATE TABLE DashboardMsg ("  //========> for Offline Mode
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "serverId TEXT,"
              "condition INTEGER,"
              "status INTEGER,"
              "text TEXT"
              ")");
        },
        onUpgrade: (db, oldVersion, newVersion) async {
      if(oldVersion <= 5){
        await db.delete('Register');
        await db.delete('Circles');
        await db.delete('EditProfile');
        // await db.delete('Alarms');
        // await db.delete('DailyReminders');
        // await db.delete('RemoveAlarms');
        await db.delete('MotivalMessages');
        await db.delete('ParentDashboardMessages');
        await db.delete('DashboardMessages');
        await db.delete('ParentNotifyMessages');
        await db.delete('NotifyMessages');
        await db.delete('SugMessages');
        await db.delete('RemoveCircles');
        await db.delete('Partner');
        // await db.delete('CancelNotify');

        await db.execute("CREATE TABLE Cycles ("  //========> for Offline Mode
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "periodStartDate TEXT,"
            "periodEndDate TEXT,"
            "cycleEndDate TEXT,"
            "status INTEGER"
            ")");
        await db.execute("CREATE TABLE MotivalMsg ("  //========> for Offline Mode
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "text TEXT"
            ")");
        await db.execute("CREATE TABLE DashboardMsg ("  //========> for Offline Mode
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "serverId TEXT,"
            "condition INTEGER,"
            "status INTEGER,"
            "text TEXT"
            ")");

      }else if(oldVersion == 6){

        await db.execute("CREATE TABLE Cycles ("  //========> for Offline Mode
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "periodStartDate TEXT,"
            "periodEndDate TEXT,"
            "cycleEndDate TEXT,"
            "status INTEGER"
            ")");
        await db.execute("CREATE TABLE MotivalMsg ("  //========> for Offline Mode
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "text TEXT"
            ")");
        await db.execute("CREATE TABLE DashboardMsg ("  //========> for Offline Mode
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "serverId TEXT,"
            "condition INTEGER,"
            "status INTEGER,"
            "text TEXT"
            ")");

      }
        },
      onDowngrade: onDatabaseDowngradeDelete
    );

  }

  Future<Database> get database async{
   if(_dataBase != null) {
     return _dataBase!;
   }
    _dataBase = await initDB();
    return _dataBase!;

  }


  Future<bool>insertDb(dynamic map , String tableName)async{
    final db = await database;
    await db.insert(tableName, map);
    return true;
  }


  Future<List<AlarmViewModel>?> getAllAlarmsItem()async{
    final db = await database;
    var res = await db.query('Alarms');

    List<AlarmViewModel> alarmItems = [];
    res.forEach((item){
      alarmItems.add(AlarmViewModel.fromJson(item));
    });
    return res.isNotEmpty ? alarmItems : null;
  }

  Future<List<RemoveAlarmsModel>?> getAllRemoveAlarms()async{
    final db = await database;
    var res = await db.query('RemoveAlarms');

    List<RemoveAlarmsModel> removeAlarms = [];
    res.forEach((item){
      removeAlarms.add(RemoveAlarmsModel.fromJson(item));
    });
    return res.isNotEmpty ? removeAlarms : null;
  }

  Future<List<DailyRemindersViewModel>?> getAllDailyReminders()async{
    final db = await database;
    var res = await db.query('DailyReminders');

    List<DailyRemindersViewModel> _dailyReminders = [];
    res.forEach((item){
      _dailyReminders.add(DailyRemindersViewModel.fromJson(item));
    });
    return res.isNotEmpty ? _dailyReminders : null;
  }

  Future<List<CancelNotify>?> getAllCancelNotify()async{
    final db = await database;
    var res = await db.query('CancelNotify');

    List<CancelNotify> cancelNotifyes = [];
    res.forEach((item){
      cancelNotifyes.add(CancelNotify.fromJson(item));
    });
    return res.isNotEmpty ? cancelNotifyes : null;
  }

  Future<List<CycleViewModel>?> getAllOfflineModeCycles()async{
    final db = await database;
    var res = await db.query('Cycles');

    List<CycleViewModel> cycles = [];
    res.forEach((item){
      cycles.add(CycleViewModel.offlineModeFromJson(item));
    });
    return res.isNotEmpty ? cycles : null;
  }

  Future<List<DashBoardMessageAndNotifyViewModel>?> getAllOfflineModeMotivalMsg()async{
    final db = await database;
    var res = await db.query('MotivalMsg');

    List<DashBoardMessageAndNotifyViewModel> motivalMessages = [];
    res.forEach((item){
      motivalMessages.add(DashBoardMessageAndNotifyViewModel.offlineModeMotivalFromJson(item));
    });
    return res.isNotEmpty ? motivalMessages : null;
  }

  Future<List<DashBoardMsgOfflineMode>?> getAllOfflineModeDashboardMsg()async{
    final db = await database;
    var res = await db.query('DashboardMsg');

    List<DashBoardMsgOfflineMode> dashboardMsg = [];
    res.forEach((item){
      dashboardMsg.add(DashBoardMsgOfflineMode.fromJson(item));
    });
    return res.isNotEmpty ? dashboardMsg : null;
  }

  Future<bool> updateTables(tableName,newRow,id)async{
    final db = await database;
    await db.update(
      tableName,
      newRow,
      where: "id = ?",
      whereArgs: [id]
    );

    return true;
  }

  Future<bool> removeRecordTable(String tableName,id)async{
    final db = await database;
    await db.delete(
        tableName,
        where: "id = ?",
        whereArgs: [id]
    );

    return true;
  }

  removeTable(tableName)async{
    final db = await database;
    await db.delete(tableName);

  }

  removeAllDataBase()async{
    final db = await database;
    if(Platform.isAndroid) await clearAllAlarmsAndReminders();
    // await db.delete('Register');
    // await db.delete('Circles');
    // await db.delete('EditProfile');
    await db.delete('Alarms');
    await db.delete('DailyReminders');
    await db.delete('CancelNotify');
    await db.delete('RemoveAlarms');
    // await db.delete('MotivalMessages');
    // await db.delete('ParentDashboardMessages');
    // await db.delete('DashboardMessages');
    // await db.delete('SugMessages');
    // await db.delete('ParentNotifyMessages');
    // await db.delete('NotifyMessages');

    // for(int i = 0 ; i<beforePeriodSings.length ; i++){
    //   beforePeriodSings[i].isSelected = false;
    // }
    // for(int i = 0 ; i<duringPeriodSigns.length ; i++){
    //   duringPeriodSigns[i].isSelected = false;
    // }
    // for(int i = 0 ; i<mentalSigns.length ; i++){
    //   mentalSigns[i].isSelected = false;
    // }
    // for(int i = 0 ; i<otherSigns.length ; i++){
    //   otherSigns[i].isSelected = false;
    // }
    await NotificationInit.getGlobal().getNotify().cancelAll();
//    await db.close();
  }

  Future<bool> clearAllAlarmsAndReminders()async{
    List<DailyRemindersViewModel>? reminders = await getAllDailyReminders();
    List<AlarmViewModel>? alarms = await getAllAlarmsItem();
    if(alarms != null){
      for(int i=0 ; i<alarms.length ; i++){
        AndroidAlarmManager.cancel(int.parse('100${alarms[i].id}'));
      }
    }
    if(reminders != null){
      for(int i=0 ; i<reminders.length ; i++){
        // print(reminders[i].id);
        AndroidAlarmManager.cancel(reminders[i].id!);
      }
    }
    return true;
  }


}