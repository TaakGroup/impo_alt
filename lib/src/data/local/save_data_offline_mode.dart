import 'package:impo/src/data/local/database_provider.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/data/messages/generate_dashboard_notify_and_messages.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/dashboard/dashboard_messages_and_notify_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveDataOfflineMode{

  DataBaseProvider db = DataBaseProvider();
  var registerInfo = locator<RegisterParamModel>();

  saveAllDataOfflineMode(dashboardMessagesOfflineMode)async{
    saveCycles();
    await saveDashBoardMsg(dashboardMessagesOfflineMode);
    saveMotivalMsg();
    saveTypeCalendar();
    saveNationality();
  }

  saveCycles()async{
    var cycleInfo = locator<CycleModel>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int state = 0;
    List<CycleViewModel> cycles = cycleInfo.cycle;
    List<CycleViewModel> reverseCycles = cycles.reversed.toList();
    List<CycleViewModel> saveCycles = [];
    DateTime now = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
    DateTime lastYear = DateTime(now.year-1,now.month,now.day);
    bool flag = true;
    for(int i=0 ; flag &&  i< reverseCycles.length ; i++){
      CycleViewModel curCycle = reverseCycles[i];
      DateTime  periodStart = DateTime.parse(reverseCycles[i].periodStart!);
      saveCycles.add(curCycle);
      switch(state){
        case 0:{
          if(curCycle.status == 2){
            state = 1;
          }else if(curCycle.status == 3){
            state = 2;
          }else{
            if(periodStart.isBefore(lastYear)){
              flag = false;
            }
          }
          break;
        }
        case 1:{
          if(curCycle.status != 2){
            state = 3;
          }
          break;
        }
        case 2:{
          if(curCycle.status != 3){
            state = 3;
          }
          break;
        }
        case 3:{
          if(periodStart.isBefore(lastYear)){
            flag = false;
          }
          break;
        }
      }
    }

    List<CycleViewModel> reverseSaveCycles = saveCycles.reversed.toList();

    await db.removeTable('Cycles');
    for(int i=0 ; i<reverseSaveCycles.length ; i++){
      await db.insertDb(
        {
          'periodStartDate' : reverseSaveCycles[i].periodStart,
          'periodEndDate' : reverseSaveCycles[i].periodEnd,
          'cycleEndDate' :  reverseSaveCycles[i].circleEnd,
          'status' : reverseSaveCycles[i].status
        },
        'Cycles'
      );
    }
    CycleViewModel lastCycle = reverseSaveCycles[reverseSaveCycles.length-1];
    int status = lastCycle.status == 0 ? 1 : lastCycle.status!;

    if(status == 1){
      prefs.setInt('periodDay', registerInfo.register.periodDay!);
      prefs.setInt('circleDay', registerInfo.register.circleDay!);
    }

    // for(int i=0 ; i<reverseCycles.length ; i++){
    //   DateTime  periodStart = DateTime.parse(reverseCycles[i].periodStart);
    //       if(periodStart.isAfter(lastYear) ||
    //           periodStart.year == lastYear.year && periodStart.month == lastYear.month && periodStart.day == lastYear.day){
    //         saveCycles.add(reverseCycles[i]);
    //       }else if(reverseCycles[i].status == 2){
    //
    //           saveCycles.add(reverseCycles[i]);
    //
    //         if(reverseCycles[i+1].status != 2){
    //          saveCycles.add(reverseCycles[i+1]);
    //          break;
    //         }
    //
    //       }else if(reverseCycles[i].status == 3){
    //
    //           saveCycles.add(reverseCycles[i]);
    //
    //         if(reverseCycles[i+1].status != 3){
    //           saveCycles.add(reverseCycles[i+1]);
    //           break;
    //         }
    //
    //       }else{
    //         break;
    //       }
    // }

  }



  saveDashBoardMsg(dashboardMessagesOfflineMode)async{
    await db.removeTable('DashboardMsg');
    for(int i=0 ; i<dashboardMessagesOfflineMode.length ; i++){
      await db.insertDb(
        {
          'serverId' : dashboardMessagesOfflineMode[i]['serverId'],
          'condition' : dashboardMessagesOfflineMode[i]['condition'],
          'status' : dashboardMessagesOfflineMode[i]['status'],
          'text' : dashboardMessagesOfflineMode[i]['text'],
        },
        'DashboardMsg'
      );
    }
  }

  saveMotivalMsg()async{
    var allDashboardMessageInfo =  locator<AllDashBoardMessageAndNotifyModel>();
    List<DashBoardMessageAndNotifyViewModel> motivalMessages = allDashboardMessageInfo.motivalMessages;
    await db.removeTable('MotivalMsg');
    for(int i=0 ; i<motivalMessages.length ; i++){
      await db.insertDb(
        {
          'text' : motivalMessages[i].text
        },
        'MotivalMsg'
      );
      if(i== 29) break;
    }
  }


  saveTypeCalendar()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('calendarType', registerInfo.register.calendarType!);
  }

  saveNationality()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('nationality', registerInfo.register.nationality!);
  }

}