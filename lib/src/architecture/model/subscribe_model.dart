import '../../data/locator.dart';
import '../../models/register/register_parameters_model.dart';

class SubscribeModel{

  late RegisterParamModel registerInfo;


  SubscribeModel(){
    registerInfo = locator<RegisterParamModel>();
  }



  RegisterParamViewModel getRegisters(){
    return registerInfo.register;
  }
}