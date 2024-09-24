


// abstract class AlarmModel extends ChangeNotifier {
//
//   void addAlarm(Map<String,dynamic> map);
//
//   List<AlarmViewModel> get  alarms;
//
//   void removeAlarm(String noteId);
//
//   void removeAllAlarms();
//
// }
//
// class AlarmViewModelImplementation extends AlarmModel {
//
//   List<AlarmViewModel>  _alarm = [];
//
//   @override
//   List<AlarmViewModel>  get alarms => _alarm;
//
//   @override
//   void addAlarm(Map<String,dynamic> map) {
//     _alarm.add(AlarmViewModel.fromJson(map));
//     notifyListeners();
//   }
//
//   @override
//   void removeAlarm(String noteId) {
//     _alarm.removeWhere((element) => element.noteId == noteId);
//     notifyListeners();
//   }
//
//   @override
//   void removeAllAlarms() {
//     _alarm.clear();
//     notifyListeners();
//   }
//
// }



class AlarmViewModel{

  late int id;
  late String date;
  late int hour;
  late int minute;
  late String text;
  late String description;
  late int isActive;
  String serverId = '';
  String fileName = '';
  // late int isChange;
  late int mode;
  late int  readFlag = 1;
  bool isSelected = false;


  AlarmViewModel.fromJson(Map<String,dynamic> parsedJson){

    id = parsedJson['id'] != null ? parsedJson['id'] : 0;
    date = parsedJson['date'];
    hour = parsedJson['hour'];
    minute = parsedJson['minute'];
    text = parsedJson['text'];
    description = parsedJson['description'];
    isActive = parsedJson['isActive'].toString() == 'true' || parsedJson['isActive'].toString() == '1' ? 1 : 0 ;
    serverId = parsedJson['serverId'] != null ? parsedJson['serverId'] : '';
    fileName = parsedJson['fileName'];
    // isChange = parsedJson['isChange'];
    mode = parsedJson['mode'];
    readFlag = parsedJson['readFlag'];
  }


}



class DailyRemindersViewModel{

  int? id;
  String? title;
  String? time;
  int? mode;
  int? isSound;
  String? dayWeek;
  String? serverId;
  int? isChange;
  bool isSelected = false;


  DailyRemindersViewModel({this.title,this.mode,this.isSound,this.time,this.dayWeek});

  DailyRemindersViewModel.fromJson(Map<String,dynamic> parsedJson){

    id = parsedJson['id'];
    title = parsedJson['title'];
    mode = parsedJson['mode'];
    isSound = parsedJson['isSound'];
    time = parsedJson['time'];
    dayWeek = parsedJson['dayWeek'];
    isChange = parsedJson['isChange'];
    serverId = parsedJson['serverId'] != null ? parsedJson['serverId'] : '';

  }

  void setTime(String _time){
    time = _time;
  }

  String getTime(){
    return time!;
  }

  setTitle(_title){
    title = _title;
  }

  String getTitle(){
    return title!;
  }
  
  void setDayWeek(String _dayWeek){
    dayWeek = _dayWeek;
  }
  
  String getDayWeek(){
    return dayWeek!;
  }

}
