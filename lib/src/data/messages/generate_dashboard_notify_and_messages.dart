
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:impo/src/components/DateTime/my_datetime.dart';
import 'package:impo/src/data/local/database_provider.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/breastfeeding/breastfeeding_number_model.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/dashboard/dashboard_messages_and_notify_model.dart';
import 'package:impo/src/models/dashboard/pregnancy_numbers_model.dart';
import 'package:impo/src/models/partner/partner_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/models/signsModel/breastfeeding_signs_model.dart';
import 'dart:convert';
import 'package:impo/src/models/signsModel/pregnancy_signs_model.dart';
import 'package:impo/src/singleton/notification_init.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:impo/src/models/cancel_notify.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class GenerateDashboardAndNotifyMessages {

  var cycleInfo = locator<CycleModel>();
  var registerInfo = locator<RegisterParamModel>();
  var partnerInfo = locator<PartnerModel>();
  var allDashboardMessageInfo =  locator<AllDashBoardMessageAndNotifyModel>();
  DataBaseProvider db = DataBaseProvider();


  int power(int x, int n) {
    int retval = 1;
    for (int i = 0; i < n; i++) {
      retval *= x;
    }

    return retval;
  }

  int getTimeConditionUser(currentToday, periodDay, maxDays, fertStartDays, fertEndDays) {
    if (currentToday == 1) {
      return 1;
    } else if (currentToday > 1 && currentToday < periodDay) {
      return 2;
    } else if (currentToday == periodDay) {
      return 4;
    } else if (currentToday == fertStartDays) {
      return 8;
    } else if (currentToday > fertStartDays && currentToday < fertEndDays) {
      if (currentToday == maxDays - 13) {
        return 32;
      } else {
        return 16;
      }
    } else if (currentToday == fertEndDays) {
      return 64;
    } else if (currentToday == maxDays - 4) {
      return 128;
    } else if (currentToday > maxDays - 4 && currentToday < maxDays) {
      return 256;
    } else if (currentToday == maxDays) {
      return 512;
    } else {
      return 1024;
    }
  }

  int getTimeConditionUserForLocalNotify(currentToday, periodDay, maxDays, fertStartDays, fertEndDays) {
    // print(currentToday);
    // print(periodDay);
    // print(maxDays);
    // print(fertStartDays);
    // print(fertEndDays);
    if (currentToday == 1) {
      return 1;
    } else if (currentToday == 2) {
      return 2;
    } else if (currentToday == periodDay) {
      return 4;
    } else if (currentToday == fertStartDays) {
      return 8;
    } else if (currentToday == fertStartDays + 1) {
      return 16;
    } else if (currentToday == maxDays - 13) {
      return 32;
    } else if (currentToday == fertEndDays) {
      return 64;
    } else if (currentToday == maxDays - 4) {
      return 128;
    } else if (currentToday == maxDays - 4 + 1) {
      return 256;
    } else if (currentToday == maxDays) {
      return 512;
    } else {
      return 1024;
    }
  }

  int getWeekPregnancyConditionUser(int currentWeek){
    for(int i=1 ; i<43 ; i++){
      if(currentWeek == i){
        return power(2, i-1);
      }
    }
    return 0;
  }

  int getWeekBreastfeedingConditionUser(int currentWeek){
    for(int i=1 ; i<26 ; i++){
      if(currentWeek == i){
        return power(2, i-1);
      }
    }
    return 0;
  }

  int getWomanSignUser(CycleViewModel lastCircle) {
    List before = lastCircle.before != '' ? json.decode(lastCircle.before!) : [];
    List after = lastCircle.after != '' ? json.decode(lastCircle.after!) : [];
    List ovu = lastCircle.ovu != null ? lastCircle.ovu != '' ? json.decode(lastCircle.ovu!) : [] : [];
    // List ovu = lastCircle.ovu != '' ? json.decode(lastCircle.ovu) : [];
    List mental = lastCircle.mental != '' ? json.decode(lastCircle.mental!) : [];
    List other = lastCircle.other != '' ? json.decode(lastCircle.other!) : [];
    int a = 0;

    if (before.isNotEmpty) {
      for (int i = 0; i < before.length; i++) {
        if (before[i] == 0) {
          a = a + 1;
        } else if (before[i] == 1) {
          a = a + 2;
        } else if (before[i] == 2) {
          a = a + 4;
        } else if (before[i] == 3) {
          a = a + 8;
        }else if (before[i] == 4) {
          a = a + 4194304;
        }else if (before[i] == 5) {
          a = a + 8388608;
        }else if (before[i] == 6) {
          a = a + 16777216;
        }else if (before[i] == 7) {
          a = a + 33554432;
        }else if (before[i] == 8) {
          a = a + 134217728;
        }else if (before[i] == 9) {
          a = a + 268435456;
        }
      }
    }

    if (after.isNotEmpty) {
      for (int i = 0; i < after.length; i++) {
        if (after[i] == 0) {
          a = a + 16;
        } else if (after[i] == 1) {
          a = a + 32;
        } else if (after[i] == 2) {
          a = a + 64;
        } else if (after[i] == 3) {
          a = a + 128;
        } else if (after[i] == 4) {
          a = a + 256;
        } else if (after[i] == 5) {
          a = a + 512;
        } else if (after[i] == 6) {
          a = a + 1024;
        }else if (after[i] == 7) {
          a = a + 8589934592;
        }else if (after[i] == 8) {
          a = a + 67108864;
        }
      }
    }

    if (ovu.isNotEmpty) {
      for (int i = 0; i < ovu.length; i++) {
        if (ovu[i] == 0) {
          a = a + 1073741824;
        } else if (ovu[i] == 1) {
          a = a + 2147483648;
        } else if (ovu[i] == 2) {
          a = a + 4294967296;
        }
      }
    }


    if (mental.isNotEmpty) {
      for (int i = 0; i < mental.length; i++) {
        if (mental[i] == 0) {
          a = a + 2048;
        } else if (mental[i] == 1) {
          a = a + 4096;
        } else if (mental[i] == 2) {
          a = a + 8192;
        } else if (mental[i] == 3) {
          a = a + 16384;
        } else if (mental[i] == 4) {
          a = a + 32768;
        } else if (mental[i] == 5) {
          a = a + 65536;
        } else if (mental[i] == 6) {
          a = a + 131072;
        }
      }
    }

    if (other.isNotEmpty) {
      for (int i = 0; i < other.length; i++) {
        if (other[i] == 0) {
          a = a + 262144;
        } else if (other[i] == 1) {
          a = a + 524288;
        } else if (other[i] == 2) {
          a = a + 1048576;
        } else if (other[i] == 3) {
          a = a + 2097152;
        }else if (other[i] == 4) {
          a = a + 536870912;
        }
      }
    }

    return a;
  }


  int getPregnancyWomanSignUser({PregnancySignsViewModel? pregnancySignsViewModel}){
    PregnancySignsViewModel pregnancySigns;
    if(pregnancySignsViewModel != null){
      pregnancySigns = pregnancySignsViewModel;
    }else{
      var pregnancySignInfo = locator<PregnancySignsModel>();
      pregnancySigns = pregnancySignInfo.pregnancySings;
    }
    List<int> fetalSexIndex = pregnancySigns.fetalSex!;
    List<int> physicalSignsIndex = pregnancySigns.physical!;
    List<int> pregnancyPhysicalSignsIndex = pregnancySigns.physicalPregnancy!;
    List<int> pregnancyGastrointestinalSignsIndex = pregnancySigns.gastrointestinalPregnancy!;
    List<int> pregnancyPsychologySignsIndex = pregnancySigns.psychologyPregnancy!;
    int a = 0;

    for(int i=0 ; i<fetalSexIndex.length ; i++){
      if (fetalSexIndex[i] == 0) {
        a = a + 1;
      } else if (fetalSexIndex[i] == 1) {
        a = a + 2;
      } else if (fetalSexIndex[i] == 2) {
        a = a + 4;
      }
    }

    for(int i=0 ; i<physicalSignsIndex.length ; i++){
      if (physicalSignsIndex[i] == 0) {
        a = a + 8;
      } else if (physicalSignsIndex[i] == 1) {
        a = a + 32;
      } else if (physicalSignsIndex[i] == 2) {
        a = a + 64;
      }else if (physicalSignsIndex[i] == 3) {
        a = a + 128;
      }else if (physicalSignsIndex[i] == 4) {
        a = a + 8192;
      }else if (physicalSignsIndex[i] == 5) {
        a = a + 16384;
      }
    }

    for(int i=0 ; i<pregnancyPhysicalSignsIndex.length ; i++){
      if (pregnancyPhysicalSignsIndex[i] == 0) {
        a = a + 1024;
      } else if (pregnancyPhysicalSignsIndex[i] == 1) {
        a = a + 2048;
      } else if (pregnancyPhysicalSignsIndex[i] == 2) {
        a = a + 4096;
      }else if (pregnancyPhysicalSignsIndex[i] == 3) {
        a = a + 262144;
      }else if (pregnancyPhysicalSignsIndex[i] == 4) {
        a = a + 524288;
      }else if (pregnancyPhysicalSignsIndex[i] == 5) {
        a = a + 8388608;
      }else if (pregnancyPhysicalSignsIndex[i] == 6) {
        a = a + 16777216;
      }else if (pregnancyPhysicalSignsIndex[i] == 7) {
        a = a + 67108864;
      }else if (pregnancyPhysicalSignsIndex[i] == 8) {
        a = a + 134217728;
      }else if (pregnancyPhysicalSignsIndex[i] == 9) {
        a = a + 268435456;
      }else if(pregnancyPhysicalSignsIndex[i] == 10){
        a= a + 68719476736;
      }
    }

    for(int i=0 ; i<pregnancyGastrointestinalSignsIndex.length ; i++){
      if (pregnancyGastrointestinalSignsIndex[i] == 0) {
        a = a + 536870912;
      } else if (pregnancyGastrointestinalSignsIndex[i] == 1) {
        a = a + 33554432;
      } else if (pregnancyGastrointestinalSignsIndex[i] == 2) {
        a = a + 1048576;
      }else if (pregnancyGastrointestinalSignsIndex[i] == 3) {
        a = a + 2097152;
      }else if (pregnancyGastrointestinalSignsIndex[i] == 4) {
        a = a + 4194304;
      }else if (pregnancyGastrointestinalSignsIndex[i] == 5) {
        a = a + 131072;
      }else if (pregnancyGastrointestinalSignsIndex[i] == 6) {
        a = a + 16;
      }else if (pregnancyGastrointestinalSignsIndex[i] == 7) {
        a = a + 65536;
      }
    }

    for(int i=0 ; i<pregnancyPsychologySignsIndex.length ; i++){
      if (pregnancyPsychologySignsIndex[i] == 0) {
        a = a + 1073741824;
      } else if (pregnancyPsychologySignsIndex[i] == 1) {
        a = a + 2147483648;
      } else if (pregnancyPsychologySignsIndex[i] == 2) {
        a = a + 4294967296;
      }else if (pregnancyPsychologySignsIndex[i] == 3) {
        a = a + 8589934592;
      }else if (pregnancyPsychologySignsIndex[i] == 4) {
        a = a + 17179869184;
      }else if (pregnancyPsychologySignsIndex[i] == 5) {
        a = a + 34359738368;
      }
    }

    return a;
  }

  int getBreastfeedingWomanSignUser({BreastfeedingSignsViewModel? breastfeedingSignsViewModel}){
    BreastfeedingSignsViewModel breastfeedingSigns;
    if(breastfeedingSignsViewModel != null){
      breastfeedingSigns = breastfeedingSignsViewModel;
    }else{
      var breastfeedingInfo = locator<BreastfeedingSignsModel>();
      breastfeedingSigns = breastfeedingInfo.breastfeedingSings;
    }
    List<int> babySignsIndex = breastfeedingSigns.babySigns!;
    List<int> physicalSignsIndex = breastfeedingSigns.physical!;
    List<int> breastfeedingMotherSignsIndex = breastfeedingSigns.breastfeedingMother!;
    List<int> psychologySignsIndex = breastfeedingSigns.psychology!;
    int a = 0;

    for(int i=0 ; i<babySignsIndex.length ; i++){
      if (babySignsIndex[i] == 0) {
        a = a + 8;
      } else if (babySignsIndex[i] == 1) {
        a = a + 16;
      } else if (babySignsIndex[i] == 2) {
        a = a + 32;
      }else if (babySignsIndex[i] == 3) {
        a = a + 64;
      }else if (babySignsIndex[i] == 4) {
        a = a + 128;
      }
    }

    for(int i=0 ; i<physicalSignsIndex.length ; i++){
      if (physicalSignsIndex[i] == 0) {
        a = a + 2048;
      } else if (physicalSignsIndex[i] == 1) {
        a = a + 4096;
      } else if (physicalSignsIndex[i] == 2) {
        a = a + 8192;
      }else if (physicalSignsIndex[i] == 3) {
        a = a + 65536;
      }else if (physicalSignsIndex[i] == 4) {
        a = a + 131072;
      }else if (physicalSignsIndex[i] == 5) {
        a = a + 262144;
      }else if (physicalSignsIndex[i] == 6) {
        a = a + 524288;
      }else if (physicalSignsIndex[i] == 7) {
        a = a + 1048576;
      }else if (physicalSignsIndex[i] == 8) {
        a = a + 2097152;
      }else if (physicalSignsIndex[i] == 9) {
        a = a + 16777216;
      }
    }

    for(int i=0 ; i<breastfeedingMotherSignsIndex.length ; i++){
      if (breastfeedingMotherSignsIndex[i] == 0) {
        a = a + 256;
      } else if (breastfeedingMotherSignsIndex[i] == 1) {
        a = a + 512;
      } else if (breastfeedingMotherSignsIndex[i] == 2) {
        a = a + 8388608;
      }else if (breastfeedingMotherSignsIndex[i] == 3) {
        a = a + 4194304;
      }else if (breastfeedingMotherSignsIndex[i] == 4) {
        a = a + 1024;
      }
    }

    for(int i=0 ; i<psychologySignsIndex.length ; i++){
      if (psychologySignsIndex[i] == 0) {
        a = a + 33554432;
      } else if (psychologySignsIndex[i] == 1) {
        a = a + 67108864;
      } else if (psychologySignsIndex[i] == 2) {
        a = a + 134217728;
      }else if (psychologySignsIndex[i] == 3) {
        a = a + 268435456;
      }else if (psychologySignsIndex[i] == 4) {
        a = a + 536870912;
      }
    }

    return a;
  }

  int getSexualUser(int typeSex) {
    if (typeSex == 1) {
      return 1;
    } else {
      return 2;
    }
  }

  int getAgeUser(RegisterParamViewModel registerParamViewModel) {
    DateTime now = DateTime.now();
    List data = registerParamViewModel.birthDay!.replaceAll(',', '/').split(
        '/');
    DateTime birthDay = Jalali(
      int.parse(data[0]),
      int.parse(data[1]),
      int.parse(data[2]),
    ).toDateTime();

    int diff = ((now.millisecondsSinceEpoch -
        birthDay.millisecondsSinceEpoch) ~/ 31556926000);
    // int diff = MyDateTime().myDifferenceDays(birthDay,now)~/365;
    // int diff = now.difference(birthDay).inDays~/365;
    // int diff = 25;
    // print(diff);

    if(diff < 14){
      return 1;
    }else if(diff < 18){
      return 2;
    }else if(diff < 30){
      return 4;
    }else if(diff < 50){
      return 8;
    }else{
      return 16;
    }

    // if (diff <= 15) {
    //   return 1;
    // } else if (diff >= 16 && diff <= 39) {
    //   return 2;
    // } else {
    //   return 4;
    // }
  }

  int getPairUser(PartnerViewModel partnerDbModel) {
    if (partnerDbModel.isPair) {
      return 2;
    } else {
      return 1;
    }
  }

  int getBirthdayUser(RegisterParamViewModel registerParamViewModel, PartnerViewModel partnerDbModel) {
    Jalali now = Jalali.fromDateTime(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
    List data = registerParamViewModel.birthDay!.replaceAll(',', '/').split('/');
    Jalali birthDay = Jalali(
      int.parse(data[0]),
      int.parse(data[1]),
      int.parse(data[2]),
    );
    List dataPartner = partnerDbModel.birthDate.split('/');
    Jalali partnerBirthday = Jalali.fromDateTime(DateTime(
        int.parse(dataPartner[0]), int.parse(dataPartner[1]),
        int.parse(dataPartner[2])));
    // print(birthDay);
    // print(partnerBirthday);
    // print(now);

    if (now.month == partnerBirthday.month && now.day == partnerBirthday.day &&
        partnerDbModel.isPair) {
      return 2;
    } else if (now.month == birthDay.month && now.day == birthDay.day) {
      return 1;
    } else {
      return 0;
    }
  }

  int getBirthdayUserForNotify(DateTime dateTime, RegisterParamViewModel registerParamViewModel, PartnerViewModel partnerDbModel) {
    Jalali now = Jalali.fromDateTime(DateTime(dateTime.year, dateTime.month, dateTime.day));
    List data = registerParamViewModel.birthDay!.replaceAll(',', '/').split('/');
    Jalali birthDay = Jalali(
      int.parse(data[0]),
      int.parse(data[1]),
      int.parse(data[2]),
    );
    List dataPartner = partnerDbModel.birthDate.split('/');
    Jalali partnerBirthday = Jalali.fromDateTime(DateTime(
        int.parse(dataPartner[0]), int.parse(dataPartner[1]),
        int.parse(dataPartner[2])));
    // print(birthDay);
    // print(partnerBirthday);
    // print(now);

    if (now.month == partnerBirthday.month && now.day == partnerBirthday.day && partnerDbModel.isPair == 1) {
      return 2;
    } else if (now.month == birthDay.month && now.day == birthDay.day) {
      return 1;
    } else {
      return 0;
    }
  }

  int getDistanceUser(PartnerViewModel partnerDbModel) {
    if (partnerDbModel.isPair) {
      if (partnerDbModel.distanceType == 0) {
        return 2;
      } else {
        return 1;
      }
    } else {
      return 0;
    }
  }

  int getMonthNumber(){
    Jalali now = Jalali.now();
    for(int i=1 ; i< 13;i++){
      if(now.month == i){
        return power(2,i-1);
      }
    }
    return 0;
  }

  List<DashBoardMessageAndNotifyViewModel> getTwoSug({currentToday, periodDay, maxDays, fertStartDays, fertEndDays,currentWeekPregnancy}) {
    List<DashBoardMessageAndNotifyViewModel> all =  checkConditionUserWithServer(
        currentToday : currentToday,
        periodDay : periodDay,
        maxDays : maxDays,
        fertStartDays : fertStartDays,
        fertEndDays : fertEndDays,
        currentWeekPregnancy : currentWeekPregnancy
    );
    if(all != null){
      if (all.length <= 2) {
        return all;
      }
      else {
        return getTwoRandom(all);
      }
    }else{
      return [];
    }
  }

  List<DashBoardMessageAndNotifyViewModel>  checkConditionUserWithServer({currentToday, periodDay, maxDays, fertStartDays, fertEndDays,currentWeekPregnancy}) {

    CycleViewModel? lastCircle;
    RegisterParamViewModel registerParametersModel = registerInfo.register;
    List<DashBoardMessageAndNotifyViewModel> randomMessages = [];
    PartnerViewModel partnerViewModel = partnerInfo.partnerDetail;
    List<ParentDashboardMessageAndNotifyViewModel> parentMessages = allDashboardMessageInfo.parentDashboardMessages;
    int condition = 0;
    int womanSign = 0;

    int abortion = 0;
    int pregnancyCount = 0;

    int childBirthType = 0;
    int childType = 0;

    if(registerParametersModel.status == 1){
      lastCircle = cycleInfo.cycle[cycleInfo.cycle.length-1];
    }

    if (parentMessages != null  && partnerViewModel != null) {
      if (parentMessages.isNotEmpty ) {
        for (int i = 0; i < parentMessages.length; i++) {
          if(registerParametersModel.status == 1){
              condition = getTimeConditionUser(currentToday, periodDay, maxDays, fertStartDays, fertEndDays) & parentMessages[i].condition!;
              womanSign = getWomanSignUser(lastCircle!) & parentMessages[i].womanSign!;

          }else if(registerParametersModel.status == 2){
             condition = getWeekPregnancyConditionUser(currentWeekPregnancy)& parentMessages[i].condition!;
              womanSign = getPregnancyWomanSignUser() & parentMessages[i].womanSign!;
              abortion = (registerParametersModel.hasAboration!) & parentMessages[i].abortionHistory;
              pregnancyCount = (registerParametersModel.pregnancyNo!) & parentMessages[i].pregnancyCount;
          }else if(registerParametersModel.status == 3){
            condition = getWeekBreastfeedingConditionUser(registerParametersModel.breastfeedingNumberModel!.breastfeedingCurrentWeek) & parentMessages[i].condition!;
            womanSign = getBreastfeedingWomanSignUser() & parentMessages[i].womanSign!;
            childBirthType = (registerParametersModel.childBirthType!) & parentMessages[i].childBirthType;
            childType = (registerParametersModel.childType!) & parentMessages[i].childType;

            abortion = (registerParametersModel.hasAboration!) & parentMessages[i].abortionHistory;
            pregnancyCount = (registerParametersModel.pregnancyNo!) & parentMessages[i].pregnancyCount;
          }

          // print(getWeekPregnancyConditionUser(currentWeekPregnancy));
          // print(parentMessages[i].condition);
          // print('condition : $condition');
          // print('womanSign : $womanSign');
          int sexual = getSexualUser(registerParametersModel.getSex()) & parentMessages[i].sexual!;
          int age = getAgeUser(registerParametersModel) & parentMessages[i].age!;
          int single = getPairUser(partnerViewModel) & parentMessages[i].single!;
          int birth = getBirthdayUser(registerParametersModel, partnerViewModel) & parentMessages[i].birth!;
          int distance = getDistanceUser(partnerViewModel) & parentMessages[i].distance!;
          if ((condition > 0) && (womanSign == parentMessages[i].womanSign) && (sexual > 0 || parentMessages[i].sexual == 0)
              && (age > 0 || parentMessages[i].age == 0) && (single > 0 || parentMessages[i].single == 0)
              && (birth > 0 || parentMessages[i].birth == 0) && (distance > 0 || parentMessages[i].distance == 0)
              && (abortion > 0 || parentMessages[i].abortionHistory == 0)
              && (pregnancyCount > 0 || parentMessages[i].pregnancyCount == 0)
              && (childBirthType > 0 || parentMessages[i].childBirthType == 0)
              && (childType > 0 || parentMessages[i].childType == 0)
          ) {
            for (int j = 0; j < parentMessages[i].dashboardMessages.length; j++) {
              randomMessages.add(parentMessages[i].dashboardMessages[j]);
            }
          }
          // print(parentMessages[i].childBirthType);
          // print(parentMessages[i].pregnancyCount);
          // print('TimeCondition : $condition');
          // print('WomanSign : $womanSign');
          // print('Sexual : $sexual');
          // print('Age : $age');
          // print('abortionHistory :  ${parentMessages[i].abortionHistory}');
          // print('pregnancyCount : ${parentMessages[i].pregnancyCount}');
        }
      } else {
        print('1111');
        return [];
        // return SugGenerator().getTwoSug(
        //     registerParametersModel.name,
        //     periodDay,
        //     currentToday,
        //     maxDays - 13,
        //     fertStartDays,
        //     fertEndDays,
        //     maxDays - 5,
        //     maxDays,
        //     registerParametersModel.getSex(),
        //     lastCircle);
      }
    } else {
      print('2222');
      return [];
      // return SugGenerator().getTwoSug(
      //     registerParametersModel.name,
      //     periodDay,
      //     currentToday,
      //     maxDays - 13,
      //     fertStartDays,
      //     fertEndDays,
      //     maxDays - 5,
      //     maxDays,
      //     registerParametersModel.getSex(),
      //     lastCircle);
    }
    return randomMessages.isEmpty ? [] : randomMessages;
    // return randomMessages.isEmpty ? SugGenerator().getTwoSug(
    //     registerParametersModel.name,
    //     periodDay,
    //     currentToday,
    //     maxDays - 13,
    //     fertStartDays,
    //     fertEndDays,
    //     maxDays - 5,
    //     maxDays,
    //     registerParametersModel.getSex(),
    //     lastCircle) : randomMessages;
  }



  // List<DashBoardMessageAndNotifyViewModel> pregnancyGetTwoSug(int currentWeek) {
  //   List<DashBoardMessageAndNotifyViewModel> all = pregnancyCheckConditionUserWithServer(currentWeek);
  //   // print(all);
  //   if (all.length <= 2) {
  //     return all;
  //   }
  //   else {
  //     return getTwoRandom(all);
  //   }
  // }
  //
  // List<DashBoardMessageAndNotifyViewModel>  pregnancyCheckConditionUserWithServer(int currentWeek) {
  //
  //   CycleViewModel lastCircle = cycleInfo.cycle[cycleInfo.cycle.length-1];
  //   RegisterParamViewModel registerParametersModel = registerInfo.register;
  //   List<DashBoardMessageAndNotifyViewModel> randomMessages = [];
  //   PartnerViewModel partnerViewModel = partnerInfo.partnerDetail;
  //   List<ParentDashboardMessageAndNotifyViewModel> parentMessages = allDashboardMessageInfo.parentDashboardMessages;
  //
  //   if (parentMessages != null  && partnerViewModel != null) {
  //     if (parentMessages.isNotEmpty ) {
  //       // getBirthdayUser(registerParametersModel,partners[0]);
  //       for (int i = 0; i < parentMessages.length; i++) {
  //         int condition = getWeekPregnancyConditionUser(currentWeek)& parentMessages[i].condition;
  //         int womanSign = getWomanSignUser(lastCircle) & parentMessages[i].womanSign;
  //         int sexual = getSexualUser(registerParametersModel.getSex()) & parentMessages[i].sexual;
  //         int age = getAgeUser(registerParametersModel) & parentMessages[i].age;
  //         int single = getPairUser(partnerViewModel) & parentMessages[i].single;
  //         int birth = getBirthdayUser(registerParametersModel, partnerViewModel) & parentMessages[i].birth;
  //         int distance = getDistanceUser(partnerViewModel) & parentMessages[i].distance;
  //         int abortion = registerParametersModel.hasAboration & parentMessages[i].abortionHistory;
  //         int pregnancyCount = registerParametersModel.pregnancyNo & parentMessages[i].pregnancyCount;
  //         if ((condition > 0) && (womanSign == parentMessages[i].womanSign) && (sexual > 0 || parentMessages[i].sexual == 0) && (age > 0 || parentMessages[i].age == 0) && (single > 0 || parentMessages[i].single == 0) && (birth > 0 || parentMessages[i].birth == 0) && (distance > 0 || parentMessages[i].distance == 0)) {
  //           for (int j = 0; j < parentMessages[i].dashboardMessages.length; j++) {
  //             randomMessages.add(parentMessages[i].dashboardMessages[j]);
  //           }
  //         }
  //         // print('TimeCondition : $condition');
  //         // print('WomanSign : $womanSign');
  //         // print('Sexual : $sexual');
  //         // print('Age : $age');
  //       }
  //     } else {
  //       return null;
  //     }
  //   } else {
  //     return null;
  //   }
  //   return randomMessages.isEmpty ? null : randomMessages;
  // }


  List<DashBoardMessageAndNotifyViewModel> getTwoRandom(List<DashBoardMessageAndNotifyViewModel> bankStr) {
    int random1 =  Random().nextInt(bankStr.length);
    int random2 =  Random().nextInt(bankStr.length);
    List<DashBoardMessageAndNotifyViewModel> notPinBankStr = [];
    if (random1 == random2)
      return getTwoRandom(bankStr);
    else {
      List<DashBoardMessageAndNotifyViewModel> twoStr = [];
      for (int i = 0; i < bankStr.length; i++) {
        if (bankStr.reversed.toList()[i].isPin!) {
          twoStr.add(bankStr.reversed.toList()[i]);
          break;
        }
      }
      for (int i = 0; i < bankStr.length; i++) {
        if (!bankStr[i].isPin!) {
          notPinBankStr.add(bankStr[i]);
        }
      }
      if (twoStr.length == 0) {
        twoStr.add(bankStr[random1]);
        twoStr.add(bankStr[random2]);
      } else {
        int random2NotPin =  Random().nextInt(notPinBankStr.length);
        twoStr.add(notPinBankStr[random2NotPin]);
      }
      return twoStr;
    }
  }

  Future<bool> checkForNotificationMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? womansubscribtion = prefs.getBool('womansubscribtion');
    if(womansubscribtion!){
      // print('startttt');
      // print('checkForNotificationMessage');
      bool? isNotify = prefs.getBool('isLocalNotify');
      CycleViewModel? lastCircle;
      RegisterParamViewModel register = registerInfo.register;

      print(register.status);
      if(register.status == 1){
        lastCircle = cycleInfo.cycle[cycleInfo.cycle.length-1];
      }

      List<ParentDashboardMessageAndNotifyViewModel> parentNotifies = allDashboardMessageInfo.parentNotifies;
      PartnerViewModel partnerViewModel = partnerInfo.partnerDetail;
      List<CancelNotify>? cancelNotifyes = await db.getAllCancelNotify();
      int womanSign = 0;

      int abortion = 0;
      int pregnancyCount = 0;

      int childBirthType = 0;
      int childType = 0;

      if (cancelNotifyes != null) {
        for (int i = 0; i < cancelNotifyes.length; i++) {
          if (cancelNotifyes[i].notifyId != 0) {
            // print('notifyId : ${cancelNotifyes[i].notifyId}');
            await NotificationInit.getGlobal().getNotify().cancel(
                cancelNotifyes[i].notifyId);
          }
        }
      }
      await db.removeTable('CancelNotify');
      if (parentNotifies != null && partnerViewModel != null) {
        if (parentNotifies.isNotEmpty) {
          for (int i = 0; i < parentNotifies.length; i++) {
            List<String> title = [];
            List<String> message = [];

            if(register.status == 1){
              // condition = getTimeConditionUser(currentToday, periodDay, maxDays, fertStartDays, fertEndDays) & parentMessages[i].condition;
              womanSign = getWomanSignUser(lastCircle!) & parentNotifies[i].womanSign!;

            }else if(register.status == 2){
              // condition = getWeekPregnancyConditionUser(currentWeekPregnancy)& parentMessages[i].condition;
              womanSign = getPregnancyWomanSignUser() & parentNotifies[i].womanSign!;
              abortion = (register.hasAboration!) & parentNotifies[i].abortionHistory;
              pregnancyCount = (register.pregnancyNo!) & parentNotifies[i].pregnancyCount;

            }else if(register.status == 3){
              womanSign = getBreastfeedingWomanSignUser() & parentNotifies[i].womanSign!;
              childBirthType = (register.childBirthType!) & parentNotifies[i].childBirthType;
              childType = (register.childType!) & parentNotifies[i].childType;

              abortion = (register.hasAboration!) & parentNotifies[i].abortionHistory;
              pregnancyCount = (register.pregnancyNo!) & parentNotifies[i].pregnancyCount;
            }

            // int condition = getTimeConditionUser(currentToday, periodDay, maxDays, fertStartDays, fertEndDays) & parentNotifies[i].condition;
            // int womanSign = getWomanSignUser(lastCircle) & parentNotifies[i].womanSign;
            int sexual = getSexualUser(register.getSex()) & parentNotifies[i].sexual!;
            int age = getAgeUser(register) & parentNotifies[i].age!;
            int single = getPairUser(partnerViewModel) & parentNotifies[i].single!;
            int distance = getDistanceUser(partnerViewModel) & parentNotifies[i].distance!;
            // print('woman Sign : $womanSign');
            // print('sexual : $sexual');
            // print('age : $age');
            if ((womanSign == parentNotifies[i].womanSign) &&
                (sexual > 0 || parentNotifies[i].sexual == 0) &&
                (age > 0 || parentNotifies[i].age == 0) &&
                (single > 0 || parentNotifies[i].single == 0) &&
                (distance > 0 || parentNotifies[i].distance == 0)&&
                (abortion > 0 || parentNotifies[i].abortionHistory == 0) &&
                (pregnancyCount > 0 || parentNotifies[i].pregnancyCount == 0) &&
                (childType > 0 || parentNotifies[i].childType == 0) &&
                (childBirthType > 0 || parentNotifies[i].childBirthType == 0)
            ) {
              if(register.status == 1){
                menstruationGenerateNotify(lastCircle!,parentNotifies[i],register,partnerViewModel,isNotify!,title,message);
              }else if(register.status == 2 || register.status == 3){
                pregnancyAndBreastfeedingGenerateNotify(parentNotifies[i],
                    partnerViewModel, isNotify!,title,message,register.status!);
              }
            }
            // if(title.length > 0 && message.length > 0){
            //   print(parentNotifies[i].condition);
            //   checkTimeConditionNotify(isNotify,parentNotifies[i].id+1,title[_random.nextInt(title.length)],message[_random.nextInt(message.length)],parentNotifies[i].condition,parentNotifies[i].day,parentNotifies[i].timeSend,lastCircle,RegisterParamViewModel.circleDay,RegisterParamViewModel.periodDay);
            // }

          }
        }
      } else {
        // print('nuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuul');
      }
    }
    return true;
  }

  menstruationGenerateNotify(CycleViewModel lastCircle,
      ParentDashboardMessageAndNotifyViewModel parentNotify,
      RegisterParamViewModel register,PartnerViewModel partnerViewModel,bool isNotify,List<String> title,List<String> message)async{
    // List<String> title = [];
    // List<String> message = [];
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final _random =  Random();
    int condition;
    int birth;
    int fertStartDays;
    int fertEndDays;
    DateTime lastPeriod = DateTime.parse(lastCircle.periodStart!);
    DateTime startCircle = DateTime.parse(lastCircle.periodStart!);
    DateTime endCircle = DateTime.parse(lastCircle.circleEnd!);
    DateTime endPeriod = DateTime.parse(lastCircle.periodEnd!);
    int periodDay = MyDateTime().myDifferenceDays(startCircle, endPeriod) + 1;
    int currentToday = MyDateTime().myDifferenceDays(lastPeriod, today) + 1;
    int maxDays = MyDateTime().myDifferenceDays(startCircle, endCircle) + 1;

    if ((maxDays - 18) <= periodDay) {
      fertStartDays = periodDay + 1;
      fertEndDays = maxDays - 10;
    } else {
      fertStartDays = maxDays - 18;
      fertEndDays = maxDays - 10;
    }
    int forLength = (maxDays - currentToday + 1) + register.circleDay!;
    // print(currentToday);
    for (int t = 0; t < forLength; t++) {
      // if(parentNotifies[i].birth != 0){
      //   await NotificationInit.getGlobal().getNotify().cancel(int.parse('1000${parentNotifies[i].id+1}$t'));
      //   print('cancel Id : ${int.parse('1000${parentNotifies[i].id+1}$t')}');
      // }
      // int currentToday = today.difference(lastPeriod).inDays;
      if (currentToday <= maxDays) {
        condition = getTimeConditionUserForLocalNotify(
            currentToday, periodDay, maxDays, fertStartDays,
            fertEndDays) & parentNotify.condition!;
      } else {
        if ((register.circleDay! - 18) <= register.periodDay!) {
          fertStartDays = register.periodDay! + 1;
          fertEndDays = register.circleDay! - 10;
        } else {
          fertStartDays = register.circleDay! - 18;
          fertEndDays = register.circleDay! - 10;
        }
        int newCurrentToday = currentToday - maxDays;
        // print('newCurrentToday : $newCurrentToday');
        condition = getTimeConditionUserForLocalNotify(
            newCurrentToday,register.periodDay,
            register.circleDay, fertStartDays,
            fertEndDays) & parentNotify.condition!;
      }
      DateTime dateTime = DateTime(lastPeriod.year,lastPeriod.month,lastPeriod.day+currentToday - 1);
      birth = getBirthdayUserForNotify(dateTime,register,partnerViewModel) & parentNotify.birth!;
      if (condition > 0 && (birth > 0 || parentNotify.birth == 0)) {
        for (int j = 0; j < parentNotify.dashboardMessages.length ; j++) {
          // if (parentNotifies[i].id == notifies[j].parentId) {
          title.add(parentNotify.dashboardMessages[j].title!);
          message.add(parentNotify.dashboardMessages[j].text!);
          // }
        }
        DateTime setNotifDateTime = DateTime(lastPeriod.year,lastPeriod.month,lastPeriod.day + currentToday - 1);
        // lastPeriod.add(Duration(days: currentToday - 1));
        setNotifDateTime = DateTime(
            setNotifDateTime.year, setNotifDateTime.month,
            setNotifDateTime.day - parentNotify.day!,
            int.parse(parentNotify.timeSend!.split(':')[0]),
            int.parse(parentNotify.timeSend!.split(':')[1]));
        // print(setNotifDateTime);
        if (title.length > 0 && message.length > 0) {
          // print(int.parse('1000${parentNotifies[i].id+1}$t'));
          await db.insertDb(
            {
              'notifyId': int.parse('1000${parentNotify.id! + 1}$t')
            },
            'CancelNotify',
          );
          // db.close();
          createNotify(
              isNotify, int.parse('1000${parentNotify.id! + 1}$t'),
              title[_random.nextInt(title.length)],
              message[_random.nextInt(message.length)],
              setNotifDateTime);
        }
      }
      currentToday++;
    }
  }

  // List<String> title = [];
  // List<String> message = [];
  pregnancyAndBreastfeedingGenerateNotify(
      ParentDashboardMessageAndNotifyViewModel parentNotify,
      PartnerViewModel partnerViewModel,
      bool isNotify,List<String> title,List<String> message,int status)async{
    // print('pregnancyGenerateNotify');
    final _random =  Random();
    int? condition;
    int birth;
    int monthName;
    int remainingDays = 0;
    int currentToday;
    DateTime? startDate;
    PregnancyNumberModel pregnancyNumberInfo = locator<PregnancyNumberModel>();
    RegisterParamViewModel register = registerInfo.register;
    DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    if(status == 2){

      remainingDays = (43 - pregnancyNumberInfo.pregnancyNumbers.weekNoPregnancy!)*7;
      startDate = pregnancyNumberInfo.pregnancyNumbers.lastPeriod;

    }else if(status == 3){
      remainingDays = (26 - register.breastfeedingNumberModel!.breastfeedingCurrentWeek)*7;
      startDate = DateTime(register.childBirthDate!.year,register.childBirthDate!.month,register.childBirthDate!.day + 1);

    }
    // print('startDate : $startDate');
    // print('today : $today');
    currentToday = MyDateTime().myDifferenceDays(startDate!, today) + 1;

    if(remainingDays != 0){
      for(int t=0 ; t<remainingDays ; t++){
        // print('currentToday : $currentToday');

        if(int.tryParse(((currentToday)/7).toString().split('.')[1]) == 0){
          // print('currentWeek : ${((currentToday)~/7)}');
          if(status == 2){

            condition = getWeekPregnancyConditionUser(((currentToday)~/7))& parentNotify.condition!;

          }else if(status == 3){
            condition = getWeekBreastfeedingConditionUser(((currentToday)~/7)) & parentNotify.condition!;
          }
        }else{
          condition = 0;
        }
         // print(getMonthNumber());
         // print('///////////////');
         // print(parentNotify.monthName);
         monthName = getMonthNumber() & parentNotify.monthName;
         DateTime dateTime = DateTime(startDate.year,startDate.month,startDate.day+ (currentToday - 6) - 1);
         birth = getBirthdayUserForNotify(dateTime,register,partnerViewModel) & parentNotify.birth!;

         if (condition! > 0 && (birth > 0 || parentNotify.birth == 0) && (monthName > 0 || parentNotify.monthName == 0) ) {
           for (int j = 0; j < parentNotify.dashboardMessages.length ; j++) {
             // if (parentNotifies[i].id == notifies[j].parentId) {
             title.add(parentNotify.dashboardMessages[j].title!);
             message.add(parentNotify.dashboardMessages[j].text!);
             // }
           }
           DateTime setNotifDateTime = DateTime(startDate.year,startDate.month,startDate.day + (currentToday - 6) - 1);
           // lastPeriod.add(Duration(days: currentToday - 1));
           setNotifDateTime = DateTime(
               setNotifDateTime.year, setNotifDateTime.month,
               setNotifDateTime.day - parentNotify.day!,
               int.parse(parentNotify.timeSend!.split(':')[0]),
               int.parse(parentNotify.timeSend!.split(':')[1]));
           // print(setNotifDateTime);
           if (title.length > 0 && message.length > 0) {
             // print(message);
             // print(setNotifDateTime);
               db.insertDb(
               {
                 'notifyId': int.parse('1000${parentNotify.id! + 1}$t')
               },
               'CancelNotify',
             );

             // db.close();
             createNotify(
                 isNotify, int.parse('1000${parentNotify.id! + 1}$t'),
                 title[_random.nextInt(title.length)],
                 message[_random.nextInt(message.length)],
                 setNotifDateTime);
           }
         }


        // if(int.tryParse((t/7).toString().split('.')[1]) == 0 ) {
        //   currentWeek++;
        // }
        currentToday++;
      }
    }
  }



  createNotify(bool isNotify, int id, String title, String message, DateTime dateTime) async {
    // print('createNotify');
    // print(id);
    if ((DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour,
        dateTime.minute)).isAfter(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute))) {
      if (isNotify) {
        try{
          tz.initializeTimeZones();
          final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
          tz.setLocalLocation(tz.getLocation(timeZoneName));
          await NotificationInit.getGlobal().getNotify().zonedSchedule(
              id,
              title,
              message,
              tz.TZDateTime.from(dateTime,tz.local),
              platformChannel,
              androidAllowWhileIdle: true,
              payload: '$title*$message*تایید',
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          );
        }catch(e){
          print(e);
        }
        // print('$message///$dateTime///$id');
      // print('notification is set $dateTime with id : $message');
      }
    }
  }

  generateWeekPregnancy(bool isOfflineMode,{RegisterParamViewModel? registerParamViewModel,DateTime? pregnancyDate}){
    var pregnancyNumberInfo = locator<PregnancyNumberModel>();
    RegisterParamViewModel? register;
    if(isOfflineMode){
      register = null;
    }else{
      if(registerParamViewModel != null){
        register = registerParamViewModel;
      }else{
        register = registerInfo.register;
      }
    }
    DateTime now = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
    int currentWeek;
    int currentMonth;
    int _dayOfDelivery;
    // DateTime now = DateTime(2022,03,20);
    // print('isDeliveryDate : ${register.isDeliveryDate}');
    DateTime lastPeriod;
    DateTime? givingBirth;
    if(register != null){
      if(register.isDeliveryDate!){
        givingBirth = register.pregnancyDate!;
        // print('تاریخ زیامان : $givingBirth');
        lastPeriod = DateTime(givingBirth.year,givingBirth.month,givingBirth.day - 279);
      }else{
        lastPeriod = register.pregnancyDate!;
      }
    }else{
      lastPeriod = pregnancyDate!;
    }
    // print('تاریخ آخرین پریود : $lastPeriod');
    // print('تاریخ امروز : $now');

    int diffDays = MyDateTime().myDifferenceDays(lastPeriod,now) + 1;
    // int diffDays =  now.difference(lastPeriod).inDays;
    // print(diffDays);

    double weekDays = (diffDays/7);
    if(int.tryParse(weekDays.toString().split('.')[1]) != 0 ){
      currentWeek = (diffDays~/7)+1;
      // currentMonth = (currentWeek~/4)+1;
    }else{
      currentWeek = diffDays~/7;
      // currentMonth = currentWeek~/4;
    }
    currentWeek == 0 ? currentWeek = 1 : currentWeek = currentWeek;

    // double _currentMonth = currentWeek/4;
    //
    // if(int.tryParse(_currentMonth.toString().split('.')[1]) != 0){
    //   currentMonth = (currentWeek~/4)+1;
    // }else{
    //   currentMonth = (currentWeek~/4);
    // }

    if(currentWeek <= 4){
      currentMonth = 1;
    }else if(currentWeek <= 8){
      currentMonth = 2;
    }else if(currentWeek <= 13){
      currentMonth = 3;
    }else if(currentWeek <= 17){
      currentMonth = 4;
    }else if(currentWeek <= 22){
      currentMonth = 5;
    }else if(currentWeek <= 27){
      currentMonth = 6;
    }else if(currentWeek <= 31){
      currentMonth = 7;
    }else if(currentWeek <= 35){
      currentMonth = 8;
    }else if(currentWeek <= 40){
      currentMonth = 9;
    }else{
      currentMonth = 10;
    }


    if(diffDays >= 280){
      // if(diffDays < 287){
      //   _dayOfDelivery = 287 - diffDays;
      // }else if(diffDays < 294){
      //   _dayOfDelivery = 294 - diffDays;
      // }else{
      //   _dayOfDelivery = 1;
      // }
      _dayOfDelivery = 0;
    }else{
      _dayOfDelivery = 280 - diffDays;
    }
    print('currentWeek : $currentWeek');
    // generateBottomMessage(currentWeekPregnancy: currentWeek);
    PregnancyNumberViewModel pregnancyNumberViewModel =
    PregnancyNumberViewModel(
        weekNoPregnancy:currentWeek,
        monthNoPregnancy: currentMonth,
        dayToDelivery:  _dayOfDelivery,
        lastPeriod: lastPeriod,
        givingBirth: givingBirth
    );
    // if(!pregnancyNumber.isClosed){
    //   pregnancyNumber.sink.add(pregnancyNumberViewModel);
    // }
    pregnancyNumberInfo.setPregnancyNumbers(pregnancyNumberViewModel);
  }

  generateWeekBreastfeeding(bool isOfflineMode,{DateTime? childBirthDate}){
    RegisterParamViewModel register = registerInfo.register;
    DateTime now = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
    DateTime givingBirth;

    if(isOfflineMode){

      givingBirth = DateTime(childBirthDate!.year,childBirthDate.month, childBirthDate.day);

    }else{

     givingBirth =  DateTime(register.childBirthDate!.year,register.childBirthDate!.month, register.childBirthDate!.day + 1);

    }

    // print(register.childBirthDate);
    // print(givingBirth);
    // print(now);
    int diffDays = MyDateTime().myDifferenceDays(givingBirth,now) + 1 ;
    // int diffDays =  now.difference(givingBirth).inDays;
    int currentWeek;
    int currentMonth;
    double weekDays = (diffDays/7);
    print(weekDays);
    if(int.tryParse(weekDays.toString().split('.')[1]) != 0 ){
      currentWeek = (diffDays~/7)+1;
      // currentMonth = (currentWeek~/4)+1;
    }else{
      currentWeek = diffDays~/7;
      // currentMonth = currentWeek~/4;
    }

    double _currentMonth = currentWeek/4;

    if(int.tryParse(_currentMonth.toString().split('.')[1]) != 0){
      currentMonth = (currentWeek~/4)+1;
    }else{
      currentMonth = (currentWeek~/4);
    }
    print('currentWeek breast : $currentWeek');
    registerInfo.setBreastfeedingNumberModel(
      BreastfeedingNumberModel(
        breastfeedingCurrentWeek: currentWeek,
        breastfeedingCurrentMonth: currentMonth
      )
    );
  }


}

var androidChannel = AndroidNotificationDetails(
  'daily', 'channel_name',
  channelDescription: 'channel_description',
  importance: Importance.max,
  priority: Priority.max,
  vibrationPattern: Int64List(1000),
  largeIcon: DrawableResourceAndroidBitmap('impo_icon'),
  icon: "not_icon",
  playSound: true,
  styleInformation: BigTextStyleInformation(''),
);

var iosChannel = DarwinNotificationDetails(
  presentSound: true,
);

NotificationDetails platformChannel = NotificationDetails(
    android: androidChannel, iOS: iosChannel);