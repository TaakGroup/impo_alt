
import 'package:impo/src/core/app/utiles/extensions/on_datetime/on_jalali.dart';
import 'package:shamsi_date/extensions.dart';
import 'package:taakitecture/taakitecture.dart';

enum PregnancyHistoryStatus {fistTime, haveKid, abortingExperience, notMatter}
enum WomanStatus {pre, menstruation, pregnancy, breastfeeding, menopause}
enum AbortionStatus {notImportant ,hasAbortion , hasNotAbortion}
enum PregnancyNo {notImportant ,hasPregnancy , hasNotPregnancy}
enum PeriodStatus {notImportant,prevention, intent}
enum Sickness {ovarianLaziness,uterineFibrosis,thyroidProblems,endometriosis,overweight,noProblem}
enum PregnancyCommit {none,moreThan6Month,lessThan6Month}
enum PeriodSituation {dontKnow,regular,irregular}
enum OnFertilitySex {haveSex,dontKnow}
enum PmsStatus {None,Pms,Pmdd}
enum PreventionWays {condom,naturalPervention,birthControlPills,IUD,emergencyPill,otherWays}
enum PreventionSexCommited {safeDays,dontCare,dontKnow}
enum PragnencyDisease {bloodPressure,diabetes,fate,heartDisease,asthma,dontKnow,noProblem}
enum PragnencyHistoryType {Natural,Caesarean,NoExperienc}

class RegisterModel extends BaseModel with ModelMixin{
  PregnancyHistoryStatus? pragnencyHistoryStatus = PregnancyHistoryStatus.values[0];
  String? firstName;
  String? identity;
  String? password;
  String? interfaceCode;
  String? deviceToken;
  Jalali? birthDate;
  int? periodLength = 0;
  Jalali? startPeriodDate;
  String? phoneModel;
  int? totalCycleLength = 0;
  // int? sexualStatus;
  // int? nationality;
  WomanStatus? status = WomanStatus.values[0];
  bool? isDeliveryDate = false;
  Jalali? pregnancyDate;
  AbortionStatus? hasAboration = AbortionStatus.values[0];
  PregnancyNo? pregnancyNo = PregnancyNo.values[0];
  PeriodStatus? periodStatus = PeriodStatus.values[0];
  Sickness? sickness = Sickness.values[0];
  PregnancyCommit? pregnencyCommite = PregnancyCommit.values[0];
  PeriodSituation? periodSituation = PeriodSituation.values[0];
  OnFertilitySex? onFertilitySex = OnFertilitySex.values[0];
  PmsStatus? pmsStatus = PmsStatus.values[0];
  PreventionWays? preventionWays = PreventionWays.values[0];
  PreventionSexCommited? preventionSexCommited = PreventionSexCommited.values[0];
  PragnencyDisease? pragnencyDisease = PragnencyDisease.values[0];
  PragnencyHistoryType? pragnencyHistoryType = PragnencyHistoryType.values[0];

  @override
  BaseModel getInstance() => RegisterModel();

  @override
  Map<String, dynamic> get properties => {
    'pragnencyHistoryStatus' : pragnencyHistoryStatus!.index,
    'firstName' : firstName,
    'identity' : identity,
    'password' : password,
    'interfaceCode' : interfaceCode,
    'deviceToken' : deviceToken,
    'birthDate' : birthDate!.toServerStr,
    'periodLength' : periodLength,
    'startPeriodDate' : startPeriodDate != null ? startPeriodDate!.toServerStr : '',
    'phoneModel' : phoneModel,
    'totalCycleLength' : totalCycleLength,
    'status' : status!.index,
    'isDeliveryDate' : isDeliveryDate,
    'pregnancyDate' : pregnancyDate != null ? pregnancyDate!.toServerStr : '',
    'hasAboration' : hasAboration!.index,
    'pregnancyNo' : pregnancyNo!.index,
    'periodStatus' : periodStatus!.index,
    'sickness' : sickness!.index,
    'pregnencyCommite' : pregnencyCommite!.index,
    'periodSituation' : periodSituation!.index,
    'onFertilitySex' : onFertilitySex!.index,
    'pmsStatus' : pmsStatus!.index,
    'preventionWays': preventionWays!.index,
    'preventionSexCommited' : preventionSexCommited!.index,
    'pragnencyDisease' : pragnencyDisease!.index,
    'pragnencyHistoryType' : pragnencyHistoryType!.index
  };

  @override
  void setProp(String key, value) {
    switch (key) {
      case "pragnencyHistoryStatus":
        pragnencyHistoryStatus = value;
        break;
      case "firstName":
        firstName = value;
        break;
      case "identity":
        identity = value;
        break;
      case "password":
        password = value;
        break;
      case "interfaceCode":
        interfaceCode = value;
        break;
      case "deviceToken":
        deviceToken = value;
        break;
      case "birthDate":
        birthDate = value;
        break;
      case "periodLength":
        periodLength = value;
        break;
      case "startPeriodDate":
        startPeriodDate = value;
        break;
      case "phoneModel":
        phoneModel = value;
        break;
      case "totalCycleLength":
        totalCycleLength = value;
        break;
      case "status":
        status = value;
        break;
      case "isDeliveryDate":
        isDeliveryDate = value;
        break;
      case "pregnancyDate":
        pregnancyDate = value;
        break;
      case "hasAboration":
        hasAboration = value;
        break;
      case "pregnancyNo":
        pregnancyNo = value;
        break;
      case "periodStatus":
        periodStatus = value;
        break;
      case "sickness":
        sickness = value;
        break;
      case "pregnencyCommite":
        pregnencyCommite = value;
        break;
      case "periodSituation":
        periodSituation = value;
        break;
      case "onFertilitySex":
        onFertilitySex = value;
        break;
      case "pmsStatus":
        pmsStatus = value;
        break;
      case "preventionWays":
        preventionWays = value;
        break;
      case "preventionSexCommited":
        preventionSexCommited = value;
        break;
      case "pragnencyDisease":
        pragnencyDisease = value;
        break;
      case "pragnencyHistoryType":
        pragnencyHistoryType = value;
        break;
    }
  }

}