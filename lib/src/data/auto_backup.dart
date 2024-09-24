

import 'dart:convert';

import 'package:impo/src/data/http.dart';
import 'package:impo/src/data/local/database_provider.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/models/calender/alarm_model.dart';
import 'package:impo/src/models/remove_alarms_model.dart';

import 'locator.dart';

class AutoBackup{

  DataBaseProvider db =  DataBaseProvider();


  // autoAllBackup()async{
  //   // print('alllllllllllllllllllllllllllBackUp');
  //   // await setCycleInfo();
  //   // await setGeneralInfo();
  //   // await setCycleCalender();
  //   // await setCheckList();
  //   // await checkAlarmCalender();
  //   checkAlarmDaily();
  // }

  // setCycleInfoAndCycleCalender()async{
  //   await setCycleInfo();
  //   setCycleCalender();
  // }
  //
  // Future<bool> setCycleInfo()async{
  //   RegisterParamViewModel register = await getRegister();
  //
  //   List<EditProfileModel> editProfiles = await db.getAllRecordsEditProfile();
  //
  //   if(editProfiles != null){
  //     for(int i=0 ; i<editProfiles.length ; i++){
  //       if(editProfiles[i].editType == 0 ||editProfiles[i].editType == 1 || editProfiles[i].editType == 4){
  //         // print(editProfiles[i].editType);
  //         print('server : ${register.circleDay}');
  //         Map responseBody = await Http().sendRequest(
  //             womanUrl,
  //             'info/cycleInfo',
  //             'POST',
  //             {
  //               "startPeriodDate" : DateFormat('yyyy/MM/dd').format(DateTime.parse(register.lastPeriod)),
  //               "totalCycleLength" : register.circleDay,
  //               "periodLength" : register.periodDay
  //             },
  //             register.token
  //         );
  //         print('setCycleInfo : $responseBody');
  //         if(responseBody != null){
  //           if(responseBody.isNotEmpty){
  //             if(responseBody['isValid']){
  //               if(editProfiles != null){
  //                 for(int i=0 ; i<editProfiles.length ; i++){
  //                   if(editProfiles[i].editType == 0 || editProfiles[i].editType == 1 || editProfiles[i].editType == 4){
  //                     await db.removeRecordTable('EditProfile',editProfiles[i].id);
  //                   }
  //                 }
  //                 break;
  //               }
  //             }
  //           }
  //         }
  //       }
  //     }
  //   }
  //
  //   return true;
  // }
  //
  // Future<bool> setGeneralInfo()async{
  //
  //     RegisterParamViewModel register = await getRegister();
  //     List<EditProfileModel> editProfiles = await db.getAllRecordsEditProfile();
  //     if(editProfiles!= null){
  //       for(int i=0 ; i<editProfiles.length ; i++){
  //         if(editProfiles[i].editType == 2 || editProfiles[i].editType == 3 || editProfiles[i].editType == 5 || editProfiles[i].editType == 6 || editProfiles[i].editType == 7){
  //           List listBirthDay;
  //           if(register.birthDay.contains(',')){
  //             listBirthDay = register.birthDay.split(',');
  //           }else{
  //             listBirthDay = register.birthDay.split('/');
  //           }
  //
  //           Jalali _dateTime = Jalali(
  //               int.parse(listBirthDay[0]),
  //               int.parse(listBirthDay[1]),
  //               int.parse(listBirthDay[2])
  //           );
  //           print(DateFormat('yyyy/MM/dd').format(_dateTime.toDateTime()));
  //           Map responseBody = await Http().sendRequest(
  //               womanUrl,
  //               'info/generalInfov1',
  //               'POST',
  //               {
  //                 "name" : register.name,
  //                 "birthDate" : DateFormat('yyyy/MM/dd').format(_dateTime.toDateTime()),
  //                 "sexualStatus" : register.sex,
  //                 "nationality" : register.nationality == 'AF' ? 1 : 0,
  //                 "calendarType" : register.calendarType != null ? register.calendarType : 0
  //               },
  //               register.token
  //           );
  //           print('generalInfo :$responseBody');
  //           if(responseBody != null){
  //             if(responseBody.isNotEmpty){
  //               if(responseBody['isValid']){
  //                 List<EditProfileModel> editProfiles = await db.getAllRecordsEditProfile();
  //                 if(editProfiles != null){
  //                   for(int i=0 ; i<editProfiles.length ; i++){
  //                     if(editProfiles[i].editType == 2 || editProfiles[i].editType == 3 || editProfiles[i].editType == 5 || editProfiles[i].editType == 6 || editProfiles[i].editType == 7 ){
  //                       db.removeRecordTable('EditProfile',editProfiles[i].id);
  //                     }
  //                   }
  //                   break;
  //                 }
  //               }
  //             }
  //           }
  //         }
  //       }
  //     }
  //     return true;
  // }
  //
  // Future<bool> setCycleCalender()async{
  //   CirclesSendServerMode circlesSendServerMode = new CirclesSendServerMode();
  //   RegisterParamViewModel register = await getRegister();
  //   List<CircleModel> listCirclesItem = await db.getAllCirclesItem();
  //   List<RemoveCirclesModel> removeCircles = await db.getAllRemoveCircles();
  //   List<CircleModel> notSavedToServer = [];
  //
  //   if(listCirclesItem != null){
  //     for(int i=0 ; i<listCirclesItem.length ; i++){
  //       // print('isSavaed To server : ${listCirclesItem[i].isSavedToServer}');
  //       if(listCirclesItem[i].isSavedToServer == 0){
  //         notSavedToServer.add(listCirclesItem[i]);
  //       }
  //     }
  //   }
  //
  //
  //   if(notSavedToServer.length != 0){
  //
  //      circlesSendServerMode = CirclesSendServerMode.fromJson(notSavedToServer,register.token);
  //
  //   }
  //
  //   if(removeCircles != null){
  //     for(int i=0 ; i<removeCircles.length ; i++){
  //       circlesSendServerMode.cycleInfos.add(
  //           {
  //             'periodStartDate' : "",
  //             'periodEndDate' :  "",
  //             'cycleStartDate' : "",
  //             'cycleEndDate' : "",
  //             'cycleIndex' : removeCircles[i].myIndex,
  //             'remove' : true
  //           }
  //       );
  //     }
  //   }
  //   // print('cycleInfos');
  //   if(circlesSendServerMode.cycleInfos != null){
  //     if(circlesSendServerMode.cycleInfos.length != 0){
  //       // print(circlesSendServerMode.cycleInfos);
  //       Map responseBody = await Http().sendRequest(
  //           womanUrl,
  //           'info/cycleCalender',
  //           'POST',
  //           {
  //             "cycles" : circlesSendServerMode.cycleInfos
  //           },
  //           register.token
  //       );
  //       print('setCycleCalender : $responseBody');
  //       if(responseBody != null){
  //         if(responseBody['isValid']){
  //           if(listCirclesItem != null){
  //             for(int i=0 ; i<listCirclesItem.length ; i++){
  //               if(listCirclesItem[i].isSavedToServer == 0){
  //                 await db.updateTables('Circles',
  //                     {
  //                       'isSavedToServer' : 1
  //                     },
  //                     listCirclesItem[i].id
  //                 );
  //               }
  //             }
  //           }
  //           await db.removeTable('RemoveCircles');
  //         }
  //       }
  //
  //     }
  //   }
  //
  //   return true;
  // }
  //
  // Future<bool> setCheckList()async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if(prefs.getBool('isChangeSignWoman')){
  //     RegisterParamViewModel register = await getRegister();
  //     CircleModel lastCircle = await db.getLastItemCircleFromLocal();
  //     if(lastCircle != null){
  //       Map responseBody = await Http().sendRequest(
  //           womanUrl,
  //           'info/checkList',
  //           'POST',
  //           {
  //             "sign" : GenerateDashboardAndNotifyMessages().getWomanSignUser(lastCircle)
  //           },
  //           register.token
  //       );
  //       print('setCheckList : $responseBody');
  //
  //       if(responseBody != null){
  //         if(responseBody['isValid']){
  //           prefs.setBool('isChangeSignWoman',false);
  //         }
  //       }
  //     }
  //   }
  //   return true;
  // }
  //
  //
  // checkAlarmCalender()async{
  //   List<AlarmViewModel> alarms = await db.getAllAlarmsItem();
  //   if(alarms != null){
  //     if(alarms.length != 0){
  //       for(int i=0 ; i<alarms.length ; i++){
  //         if(alarms[i].mode == 0){
  //           if(alarms[i].serverId == ''){
  //             createAlarmCalender(alarms[i].id,alarms[i].text,alarms[i].description,
  //                 DateTime(DateTime.parse(alarms[i].date).year,DateTime.parse(alarms[i].date).month,DateTime.parse(alarms[i].date).day,alarms[i].hour,alarms[i].minute).toString(),
  //                 alarms[i].isActive == 0 ? false : true);
  //           }else if(alarms[i].serverId != '' && alarms[i].isChange == 1){
  //             changeAlarmCalender(alarms[i].id,alarms[i].serverId,alarms[i].text,alarms[i].description,
  //                 DateTime(DateTime.parse(alarms[i].date).year,DateTime.parse(alarms[i].date).month,DateTime.parse(alarms[i].date).day,alarms[i].hour,alarms[i].minute).toString(),
  //                 alarms[i].isActive == 0 ? false : true);
  //           }
  //         }
  //       }
  //     }
  //   }
  //   List<RemoveAlarmsModel> removeAlarms = await db.getAllRemoveAlarms();
  //   if(removeAlarms != null){
  //     if(removeAlarms.length != 0){
  //       for(int i=0;i<removeAlarms.length;i++){
  //         if(removeAlarms[i].mode == 0){
  //           deleteAlarmCalender(removeAlarms[i].id, removeAlarms[i].serverId);
  //         }
  //       }
  //     }
  //   }
  // }
  //
  // Future<bool> createAlarmCalender(int id,String title,String text , String dateTime,bool reminder)async{
  //   // print("createAlarmCalender");
  //   RegisterParamViewModel register = await getRegister();
  //   // print(dateTime);
  //   Map responseBody = await Http().sendRequest(
  //       womanUrl,
  //       'date/note',
  //       'PUT',
  //       {
  //         "title" : title,
  //         "text" :  text,
  //         "dateTime" :  dateTime,
  //         "reminder" : reminder
  //       },
  //       register.token
  //   );
  //   if(responseBody != null){
  //     if(responseBody.isNotEmpty){
  //       if(responseBody['isValid']){
  //         db.updateTables('Alarms',
  //             {
  //               'serverId' : responseBody['id']
  //             },
  //           id
  //         );
  //       }
  //     }
  //   }
  //   return true;
  // }
  // Future<bool> changeAlarmCalender(int id,String serverId,String title,String text , String dateTime,bool reminder)async{
  //   // print('changeAlarmCalender');
  //   // print(serverId);
  //   RegisterParamViewModel register = await getRegister();
  //   if(serverId != ''){
  //     Map responseBody = await Http().sendRequest(
  //         womanUrl,
  //         'date/note',
  //         'POST',
  //         {
  //           "noteId" : serverId,
  //           "title" : title,
  //           "text" :  text,
  //           "dateTime" : dateTime,
  //           "reminder" : reminder
  //         },
  //         register.token
  //     );
  //     if(responseBody != null){
  //       if(responseBody.isNotEmpty){
  //         if(responseBody['isValid']){
  //           db.updateTables('Alarms',
  //               {'isChange' : 0},
  //               id
  //           );
  //         }
  //       }
  //     }
  //   }
  //   return true;
  // }
  //   Future<bool> deleteAlarmCalender(int id,String serverId)async{
  //     // print('deleteAlarmCalender');
  //     if(serverId != ''){
  //       RegisterParamViewModel register = await getRegister();
  //
  //       Map responseBody = await Http().sendRequest(
  //           womanUrl,
  //           'date/note',
  //           'DELETE',
  //           {
  //             "noteId" : serverId,
  //           },
  //           register.token
  //       );
  //       if(responseBody != null){
  //         if(responseBody.isNotEmpty){
  //           if(responseBody['isValid']){
  //             await db.removeRecordTable('RemoveAlarms', id);
  //           }
  //         }
  //       }
  //     }
  //     return true;
  //   }


  Future<bool> checkAlarmDaily(String token)async{
    List<DailyRemindersViewModel>? reminders = await db.getAllDailyReminders();
    List<bool> returns = [];
    if(reminders != null){
      if(reminders.length != 0){
        for(int i=0 ; i<reminders.length ; i++){
          if(reminders[i].serverId == '' && reminders[i].mode != 0){
           returns.add(await createAlarmDaily(token,reminders[i].id!, reminders[i].title!, reminders[i].time!, reminders[i].dayWeek!, reminders[i].mode!, reminders[i].isSound == 0 ? false : true));
          }else if(reminders[i].serverId != '' && reminders[i].isChange == 1){
            returns.add(await changeAlarmDaily(token,reminders[i].id!, reminders[i].serverId!, reminders[i].title!,reminders[i].time!,reminders[i].dayWeek!,reminders[i].mode!, reminders[i].isSound == 0 ? false : true));
          }
        }
      }
    }
    List<RemoveAlarmsModel>? removeAlarms = await db.getAllRemoveAlarms();
    if(removeAlarms != null){
      if(removeAlarms.length != 0){
        for(int i=0;i<removeAlarms.length;i++){
          if(removeAlarms[i].mode == 1){
           returns.add(await deleteAlarmDaily(token,removeAlarms[i].id, removeAlarms[i].serverId));
          }
        }
      }
    }
    // print('returns : $returns');
    return returns.contains(false) ? false : true;
  }

  Future<bool> createAlarmDaily(String token,int id,String title,String time,String dayWeek,int mode,bool isSound)async{
    print("createAlarmDaily");
    // print(id);

    Map responseBody = await Http().sendRequest(
        womanUrl,
        'date/alram',
        'PUT',
        {
          "category" : id < 26 ? 0 : id~/100,
          "title" : title,
          "time" : time,
          "day" : dayWeekToDecimal(dayWeek),
          "mode" : mode,
          "sound" : isSound,
          "clientId" : id.toString()
        },
        token
    );
    // print(responseBody);
    if(responseBody != null){
      if(responseBody.isNotEmpty){
        if(responseBody['isValid']){
          db.updateTables('DailyReminders',
              {'serverId' : responseBody['id']},
              id
          );
          return true;
        }else{
          return false;
        }
      }else{
        return false;
      }
    }else{
      return false;
    }
  }
  Future<bool> changeAlarmDaily(String token,int id,String serverId,String title,String time,String dayWeek,int mode,bool isSound)async{
    print('changeAlarmDaily');
    // print(serverId);
    if(serverId != ''){
      Map responseBody = await Http().sendRequest(
          womanUrl,
          'date/alram',
          'POST',
          {
            "alramId" :  serverId,
            "category" : id < 26 ? 0 : id~/100,
            "title" : title,
            "time" : time,
            "day" : dayWeekToDecimal(dayWeek),
            "mode" : mode,
            "sound" : isSound,
            "clientId" : id.toString()
          },
          token
      );
      if(responseBody != null){
        if(responseBody.isNotEmpty){
          if(responseBody['isValid']){
            db.updateTables('DailyReminders',
                {'isChange' : 0},
                id
            );
            return true;
          }else{
            return false;
          }
        }else{
          return false;
        }
      }else{
        return false;
      }
    }else{
      return false;
    }
  }
  Future<bool> deleteAlarmDaily(String token,int id,String serverId)async{
      print('deleteAlarmDaily');
      // print(serverId);
      if(serverId != ''){
        Map responseBody = await Http().sendRequest(
            womanUrl,
            'date/alram',
            'DELETE',
            {
              "alramId" : serverId,
            },
            token
        );
        if(responseBody != null){
          if(responseBody.isNotEmpty){
            if(responseBody['isValid']){
              await db.removeRecordTable('RemoveAlarms', id);
              return true;
            }else{
              return false;
            }
          }else{
            return false;
          }
        }else{
          return false;
        }
      }else{
        return false;
      }
  }

  int dayWeekToDecimal(days){
    // print(days);
    // List dayWeek = json.decode(days);
    List dayWeek = days != '' ? json.decode(days) : [];
    int a =0;
    if(dayWeek.isNotEmpty){
      for(int i=0 ; i<dayWeek.length ; i++){
        if(dayWeek[i] == 0){
          a= a+1;
        }else if(dayWeek[i] == 1){
          a=a+2;
        }else if(dayWeek[i] == 2){
          a=a+4;
        }else if(dayWeek[i] == 3){
          a=a+8;
        }else if(dayWeek[i] == 4){
          a=a+16;
        }else if(dayWeek[i] == 5){
          a=a+32;
        }else if(dayWeek[i] == 6){
          a=a+64;
        }
      }
    }
    return a;
  }


  // clickOnPinMessages(String type,String id)async{
  //   RegisterParamViewModel register = await getRegister();
  //   Map responseBody = await Http().sendRequest(
  //       womanUrl,
  //       'report/msg$type/$id',
  //       'POST',
  //       {
  //
  //       },
  //       register.token
  //   );
  //   print(responseBody);
  //   // if(responseBody != null){
  //   //   if(responseBody.isNotEmpty){
  //   //     if(responseBody['isValid']){
  //   //       await db.removeRecordTable('RemoveAlarms', id);
  //   //     }
  //   //   }
  //   // }
  // }


}