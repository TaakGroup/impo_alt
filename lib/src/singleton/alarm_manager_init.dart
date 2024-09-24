import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:impo/src/data/local/database_provider.dart';
import 'package:impo/src/models/calender/alarm_model.dart';

class AlarmManagerInit{

  static AlarmManagerInit? alarm;

  static AlarmManagerInit getGlobal(){
    if(alarm == null) {
      // print('create');
      alarm = new AlarmManagerInit();
    }
    return alarm!;
  }


  initAlarm()async{
    await AndroidAlarmManager.initialize();
  }





}

callbackAlarmReminders(int id)async{
//
print('setttttt');
print(id);
  DataBaseProvider db  = new DataBaseProvider();
  List<DailyRemindersViewModel>? dailyReminders = await db.getAllDailyReminders();
  // final int isolateId = Isolate.current.hashCode;
  // print('id:$id');
  // print('isolateId : $isolateId');
//  int.parse(dialy[index].time.substring(0,2)),
//    int.parse(dialy[index].time.substring(3,5)),

  int? index;
  DateTime? dateTimeForAlarmAndroid;
  for(int i=0 ;i<dailyReminders!.length ; i++){
    if(dailyReminders[i].id == id){
      index = i;
      // print(dailyReminders[i].title);
      // print(dailyReminders[i].isSound);
      dateTimeForAlarmAndroid = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day + 1,
          int.parse(dailyReminders[i].time!.substring(0,2)),
          int.parse(dailyReminders[i].time!.substring(3,5)),
          0
      );
    }
  }

  // print('Hello');

//  var androidChannel = AndroidNotificationDetails(
//    'reminders$index${dailyReminders[index].time}' , 'channel_name' , 'channel_description',
//    importance: Importance.Max,
//    priority: Priority.Max,
//    vibrationPattern: Int64List(1000),
//    largeIcon: DrawableResourceAndroidBitmap('impo_icon'),
//    icon: 'impo_icon' ,
//    playSound:  dailyReminders[index].isSound == 1 ? true : false,
//    sound:  index == 0 ? RawResourceAndroidNotificationSound('sound_water') : index == 1 ? RawResourceAndroidNotificationSound('sound_study') : index == 2 ?
//    RawResourceAndroidNotificationSound('sound_drug') : index == 3 ? RawResourceAndroidNotificationSound('sound_fruit')
//        : index == 4 ? RawResourceAndroidNotificationSound('sound_sport') : index == 5 ? RawResourceAndroidNotificationSound('sound_sleep') : RawResourceAndroidNotificationSound('sound_other') ,
//    styleInformation: BigTextStyleInformation(''),
//  );
//
//  var iosChannel = IOSNotificationDetails(
//    presentSound: dailyReminders[index].isSound == 1 ? true : false,
//    sound: index == 0 ? 'sound_water.aiff' : index == 1 ? 'sound_study.aiff' : index == 2 ?
//    'sound_drug.aiff' : index == 3 ? 'sound_fruit.aiff' : index == 4 ? 'sound_sport.aiff' : index == 5 ? 'sound_sleep.aiff' : 'sound_other.aiff' ,
//  );
//
//  NotificationDetails platformChannel = NotificationDetails(androidChannel,iosChannel);
//
//  await NotificationInit.getGlobal().getNotify().show(
//      int.parse('1$index'),
//      index == 0 ? 'نوشیدن آب' : index == 1 ? 'یادآور مطالعه' : index == 2 ? 'یادآور دارو' : index == 3 ? 'یادآور میوه' : index == 4 ? 'یادآور ورزش' : index == 5 ? 'یادآور خواب' : 'استفاده از موبایل',
//      index == 0 ? 'ایمپویی عزیز نوشیدن آب کافی، مهم تر از چیزیه که فکرشو کنی!' :
//      index == 1 ? "دوست خوبم امروز قراره چه کتابی بخونی؟" :
//      index == 2 ? "ایمپویی عزیز وقتشه که داروهاتو بخوری" :
//      index == 3 ? "دوست خوبم امروز میوه خوردی؟" :
//      index == 4 ?  "وقت ورزشه!" :
//      index == 5 ? "ایمپویی عزیز خواب به موقع و کافی رو دست کم نگیر" :
//      "ایمپویی جان امروز چند ساعت با گوشیت وقت گذروندی؟ " ,
//      platformChannel,
//    payload: index == 0 ? '${dailyReminders[index].title}/ایمپویی عزیز نوشیدن آب کافی، مهم تر از چیزیه که فکرشو کنی!/ممنون! یادم نمیره' :
//    index == 1 ? "${dailyReminders[index].title}/دوست خوبم امروز قراره چه کتابی بخونی؟/ممنون! یادم نمیره" :
//    index == 2 ? "${dailyReminders[index].title}/ایمپویی عزیز وقتشه که داروهاتو بخوری/ممنون! یادم نمیره" :
//    index == 3 ? "${dailyReminders[index].title}/دوست خوبم امروز میوه خوردی؟/ممنون! یادم نمیره" :
//    index == 4 ?  "${dailyReminders[index].title}/وقت ورزشه!/ممنون! یادم نمیره" :
//    index == 5 ? "${dailyReminders[index].title}/ایمپویی عزیز خواب به موقع و کافی رو دست کم نگیر/رفتم بخوابم!" :
//    "${dailyReminders[index].title}/ایمپویی جان امروز چند ساعت با گوشیت وقت گذروندی؟/رفتم بخوابم!" ,
//  );

  AndroidAlarmManager.oneShotAt(
      dateTimeForAlarmAndroid!,
      id,
      callbackAlarmReminders,
      wakeup: true,
      exact: true,
      rescheduleOnReboot: true,
      allowWhileIdle: true,
      sound: dailyReminders[index!].isSound!,
      dayweek: dailyReminders[index].dayWeek!,
      title: dailyReminders[index].title!
  );



}


callBackAlarms()async{

//     DateTime now = DateTime(
//       DateTime.now().year,
//         DateTime.now().month,
//         DateTime.now().day,
//         DateTime.now().hour,
//         DateTime.now().minute,
//     );
//
//    DataBaseProvider db  = new DataBaseProvider();
//    List<AlarmViewModel> alarms = await db.getAllAlarmsItem();
//
//    for(int i=0 ; i<alarms.length ; i++){
//
//      if(DateTime(DateTime.parse(alarms[i].date).year,DateTime.parse(alarms[i].date).month,DateTime.parse(alarms[i].date).day,alarms[i].hour,alarms[i].minute).isBefore(now)){
//        AndroidAlarmManager.cancel(int.parse('10${alarms[i].id}'));
//      }
//
//    }

  // print('show Alarm');

}
