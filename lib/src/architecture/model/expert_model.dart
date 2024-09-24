
import 'package:impo/src/data/local/database_provider.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';

class ExpertModel {

  var registerInfo;

  ExpertModel(){
    registerInfo = locator<RegisterParamModel>();
  }

  RegisterParamViewModel getRegisters(){
    return registerInfo.register;
  }


}