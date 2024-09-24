

import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';

class SharingExperienceModel{

  late RegisterParamModel registerInfo;


  SharingExperienceModel(){
    registerInfo = locator<RegisterParamModel>();
  }



  RegisterParamViewModel getRegisters(){
    return registerInfo.register;
  }

}