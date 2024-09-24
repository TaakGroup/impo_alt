
import 'package:impo/src/models/circle_model.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'alarm_model.dart';

class CellItem {

   DateTime? dateTime;
   CycleViewModel? circleItem;
   bool notInMonth = true;
   bool isToday = false;
   bool isPeriod = false;
   bool isPMS = false;
   bool isFert = false;
   bool isOvom = false;
   bool isSelect = false;
   bool isStartFert = false;
   bool isEndFert = false;
   bool isCurrent = false;
   bool isAlarm = false;
   bool readFlag = true;
   bool dayOfDelivery = false;
   bool dayOfAbortion = false;
   List<AlarmViewModel> alarms = [];

//   CellItem({this.dateTime,this.circleItem,this.notInMonth,this.isToday,this.isPeriod,this.isPMS,this.isFert,this.isOvom,this.isSelect,this.isStartFert,this.isEndFert});
//
//   CellItem.fromJson(Map<String,dynamic> parsedJson){
//
//     dateTime = parsedJson['dateTime'];
//     circleItem = parsedJson['circleItem'];
//     notInMonth = parsedJson['notInMonth'];
//     isToday = parsedJson['isToday'];
//     isPeriod = parsedJson['isPeriod'];
//     isPMS = parsedJson['isPMS'];
//     isFert = parsedJson['isFert'];
//     isOvom = parsedJson['isOvom'];
//     isSelect = parsedJson['isSelect'];
//     isStartFert = parsedJson['isStartFert'];
//     isEndFert = parsedJson['isEndFert'];
//
//   }

   DateTime getDateTime() {
    return dateTime!;
  }

   void setDateTime(DateTime dateTime) {
    this.dateTime = dateTime;
  }

   bool getIsToday() {
    return isToday;
  }

    void setToday(bool today) {
    isToday = today;
  }

   bool getIsPeriod() {
    return isPeriod;
  }

   void setPeriod(bool period) {
    isPeriod = period;
  }

   bool isNotInMonth() {
    return notInMonth;
  }

   void setNotInMonth(bool notInMonth) {
    this.notInMonth = notInMonth;
  }

   bool getIsPMS() {
    return isPMS;
  }

   void setPMS(bool PMS) {
    isPMS = PMS;
  }

   bool getIsFert() {
    return isFert;
  }

   void setFert(bool fert) {
    isFert = fert;
  }

   bool getIsOvom() {
    return isOvom;
  }

   void setOvom(bool ovom) {
    isOvom = ovom;
  }

   bool getIsSelect() {
    return isSelect;
  }

   void setSelect(bool select) {
    isSelect = select;
  }

  CycleViewModel getCircleItem() {
    return circleItem!;
  }

   void setCircleItem(CycleViewModel? circleItem) {
    this.circleItem = circleItem;
  }

   bool getIsStartFert() {
    return isStartFert;
  }

   void setStartFert(bool startFert) {
    isStartFert = startFert;
  }

   bool getIsEndFert() {
    return isEndFert;
  }

   void setEndFert(bool endFert) {
    isEndFert = endFert;
  }

//  bool getIsCurrent() {
//    return isCurrent;
//  }
//
//  void setCurrent(bool isCurrent) {
//    isEndFert = isCurrent;
//  }

  bool getIsAlarm() {
    return isAlarm;
  }

  void setAlarm(bool _isAlarm) {
    isAlarm = _isAlarm;
  }

  List<AlarmViewModel> getAlarms(){
     return alarms;
  }

  void addAlarms(AlarmViewModel _alarms){
     alarms.add(_alarms);
  }

  void removeAtAlarms(index){
     alarms.removeAt(index);
  }

  bool getReadFlag() {
    return readFlag;
  }

  void setReadFlag(bool _readFlag) {
    readFlag = _readFlag;
  }


  bool getIsDayOfDelivery(){
     return dayOfDelivery;
  }

  void setIsDayOfDelivery(bool _dayOfDelivery){
    dayOfDelivery = _dayOfDelivery;
  }

  bool getDayOfAbortion(){
    return dayOfAbortion;
  }

  void setDayOfAbortion(bool _dayOfAbortion){
    dayOfAbortion = _dayOfAbortion;
  }




}