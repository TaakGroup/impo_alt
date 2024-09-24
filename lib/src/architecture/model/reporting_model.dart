
import 'package:impo/src/data/local/database_provider.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';

class ReportingModel{

  var registerInfo;
  var cycleInfo;

  ReportingModel(){
    registerInfo = locator<RegisterParamModel>();
    cycleInfo = locator<CycleModel>();
  }


  RegisterParamViewModel getRegisters(){
    return registerInfo.register;
  }

  List<CycleViewModel> getAllCircles(){
    List<CycleViewModel> circles =  cycleInfo.cycle;
    return circles;
  }

  // List<CycleViewModel> getAllPeriodCircles(){
  //   List<CycleViewModel> circles = [];
  //   for(int i=0 ; i<getAllCircles().length ; i++){
  //     if(getAllCircles()[i].status == 0){
  //       circles.add(getAllCircles()[i]);
  //     }
  //   }
  //   return circles;
  // }

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


}