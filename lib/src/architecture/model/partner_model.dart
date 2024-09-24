

import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';


class PartnerModel {


  var registerInfo;

  PartnerModel(){
    registerInfo = locator<RegisterParamModel>();
  }

  RegisterParamViewModel getRegisters(){
    return registerInfo.register;
  }

  // Future<CircleModel>getLastCircle()async{
  //   CircleModel lastCircle = await db.getLastItemCircleFromLocal();
  //   return lastCircle;
  // }
  //
  // Future<List<CircleModel>>getAllCircles()async{
  //   List<CircleModel> circles = await db.getAllCirclesItem();
  //   return circles;
  // }
  //
  // Future<List<RemoveCirclesModel>>getAllRemoveCircles()async{
  //   List<RemoveCirclesModel> removes = await db.getAllRemoveCircles();
  //   return removes;
  // }
  //
  // Future<bool> removeTable(String tableName)async{
  //   await db.removeTable(tableName);
  //   return true;
  // }
  //
  // Future<bool> updateTable(tableName,newRow,id)async{
  //   await db.updateTables(
  //       tableName,
  //       newRow,
  //       id
  //   );
  //   return true;
  // }
  // Future<bool> insertToLocal(dynamic map , String tableName)async{
  //   await db.insertDb(map,tableName);
  //   return true;
  // }


}