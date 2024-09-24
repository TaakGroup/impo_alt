

import 'package:impo/src/data/local/database_provider.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/partner/partner_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';

class PartnerTabModel {

  var registerInfo;
  var partnerInfo;

  PartnerTabModel(){
    registerInfo = locator<RegisterParamModel>();
    partnerInfo = locator<PartnerModel>();
  }



  RegisterParamViewModel getRegisters(){
    return registerInfo.register;
  }

  PartnerViewModel? getPartner(){
    return partnerInfo.partnerDetail;
  }

}