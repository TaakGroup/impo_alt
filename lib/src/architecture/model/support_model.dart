import '../../data/locator.dart';
import '../../models/register/register_parameters_model.dart';

class SupportModel{

  late RegisterParamModel registerInfo;


  SupportModel(){
    registerInfo = locator<RegisterParamModel>();
  }



  RegisterParamViewModel getRegisters(){
    return registerInfo.register;
  }
}