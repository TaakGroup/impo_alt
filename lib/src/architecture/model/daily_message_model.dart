

import 'package:impo/src/models/register/register_parameters_model.dart';

import '../../data/locator.dart';

class DailyMassageModel {

  late RegisterParamModel registerInfo;

  DailyMassageModel() {
    registerInfo = locator<RegisterParamModel>();
  }


  RegisterParamViewModel getRegisters() {
    return registerInfo.register;
  }

}