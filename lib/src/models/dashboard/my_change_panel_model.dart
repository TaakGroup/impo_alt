

class MyChangePanelModel{
  String? title;
  int? mode;
  int? dayMode;


  MyChangePanelModel({this.mode,this.title,this.dayMode});


  setTitle(_title){
    title = _title;
  }

  getTitle(){
    return title;
  }

  setMode(_mode){
    mode = _mode;
  }

  getMode(){
    return mode;
  }

  setDayMode(_dayMode){
    dayMode = _dayMode;
  }

  getDayMode(){
    return dayMode;
  }


}