
import 'package:impo/src/data/local/database_provider.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/dashboard/dashboard_messages_and_notify_model.dart';
import 'package:impo/src/models/dashboard/dashboard_msg_offline_mode.dart';
import 'package:impo/src/models/dashboard/pregnancy_numbers_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';

class OfflineModeDashboardModel {

  late DataBaseProvider db = DataBaseProvider();
  late RegisterParamModel registerInfo;
  late PregnancyNumberModel pregnancyNumberInfo;
  late AllDashBoardMessageAndNotifyModel allDashboardMessageInfo;
  late  CycleModel cycleInfo;

  OfflineModeDashboardModel() {
    db.database;
    registerInfo = locator<RegisterParamModel>();
    pregnancyNumberInfo = locator<PregnancyNumberModel>();
    allDashboardMessageInfo = locator<AllDashBoardMessageAndNotifyModel>();
    cycleInfo = locator<CycleModel>();
  }

  Future<List<CycleViewModel>?> getAllCirclesOfflineMode()async{
    List<CycleViewModel>? circles = await db.getAllOfflineModeCycles();
    return circles;
  }

  Future<bool> insertToLocal(dynamic map , String tableName)async{
    await db.insertDb(map,tableName);
    return true;
  }

  RegisterParamViewModel getRegisters(){
    return registerInfo.register;
  }

  PregnancyNumberViewModel getPregnancyNumber(){
    return pregnancyNumberInfo.pregnancyNumbers;
  }

  Future<List<DashBoardMsgOfflineMode>?> getAllOfflineMessages()async{
    List<DashBoardMsgOfflineMode>? offlineMessages = await db.getAllOfflineModeDashboardMsg();
    return offlineMessages;
  }

  Future<List<DashBoardMessageAndNotifyViewModel>?> getAllMotivalMessages()async{
    List<DashBoardMessageAndNotifyViewModel>? motivalMessages = await db.getAllOfflineModeMotivalMsg();
    return motivalMessages;
  }

  removeAllMotivalMessages(){
    allDashboardMessageInfo.removeAllMessageAndNotifies();
  }

  addMotivalMessage(map){
    allDashboardMessageInfo.addOfflineMotivalMessage(map);
  }

  addCycleToLocator(dynamic map){
    cycleInfo.addOfflineCycle(map);
  }

  List<CycleViewModel> getAllCyclesLocator(){
    return cycleInfo.cycle;
  }

  removeAllCycles(){
    cycleInfo.removeAllCycles();
  }

}