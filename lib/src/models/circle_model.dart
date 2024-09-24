import 'package:flutter/cupertino.dart';

abstract class CycleModel extends ChangeNotifier {

  void addCycle(Map<String,dynamic> map);
  void addOfflineCycle(Map<String,dynamic> map);

  void removeCycle(int index);

  void updateCycle(int index,CycleViewModel cycleViewModel);

  void removeAllCycles();

  void removeRangeCycle(int start,int end);

  List<CycleViewModel> get  cycle;

}

class CycleModelImplementation extends CycleModel {

  List<CycleViewModel>  _cycle = [];
  // AppModelImplementation() {
  //   /// lets pretend we have to do some async initilization
  //   Future.delayed(Duration(seconds: 3)).then((_) => locator.signalReady(this));
  // }

  @override
  List<CycleViewModel>  get cycle => _cycle;

  @override
  void addCycle(Map<String,dynamic> map) {
    _cycle.add(CycleViewModel.fromJson(map));
    notifyListeners();
  }

  @override
  void removeCycle(int index) {
    _cycle.removeAt(index);
    notifyListeners();
  }

  @override
  void updateCycle(int index,CycleViewModel cycleViewModel) {
    _cycle[index] = cycleViewModel;
    notifyListeners();
  }

  @override
  void removeAllCycles() {
    _cycle.clear();
    notifyListeners();
  }

  @override
  void removeRangeCycle(int start, int end) {
    _cycle.removeRange(start, end);
    notifyListeners();
  }

  @override
  void addOfflineCycle(Map<String, dynamic> map) {
    _cycle.add(CycleViewModel.offlineModeFromJson(map));
    notifyListeners();
  }

}


class CycleViewModel {

  int? id;
  String? periodStart;
  String? periodEnd;
  String? circleEnd;
  int? status;
  String? before;
  String? after;
  String? mental;
  String? other;
  String? ovu;

  ///pregnancyAndBreastfeedingCalender
  bool? isOdd;
  bool? isCurrentWeek;
  String? textWeek;
  bool? isLastWeek;

  CycleViewModel({this.before,this.after,this.mental,
    this.ovu = '',this.other,this.periodStart,
    this.circleEnd,this.periodEnd,this.status,this.isOdd,this.isCurrentWeek,
    this.textWeek,this.isLastWeek = false});


  CycleViewModel.fromJson(Map<String,dynamic> parsedJson){

    periodStart = parsedJson['periodStartDate'];
    periodEnd = parsedJson['periodEndDate'];
    circleEnd = parsedJson['cycleEndDate'];
    status = parsedJson['status'];
    before = parsedJson['before'];
    after = parsedJson['after'];
    mental = parsedJson['mental'];
    other = parsedJson['other'];
    ovu = parsedJson['ovu'];

  }

  CycleViewModel.offlineModeFromJson(Map<String,dynamic> parsedJson){
    id = parsedJson['id'];
    periodStart = parsedJson['periodStartDate'];
    periodEnd = parsedJson['periodEndDate'];
    circleEnd = parsedJson['cycleEndDate'];
    status = parsedJson['status'];
  }


  Map<String,dynamic> getMap(CycleViewModel circleModel){
    Map<String,dynamic> json = {};
    json['periodStartDate'] = circleModel.getPeriodStart();
    json['periodEndDate'] = circleModel.getPeriodEnd();
    json['cycleEndDate'] =circleModel.getCircleEnd();
    json['status'] = circleModel.getStatus();
    json['before'] = circleModel.getBefore();
    json['after'] = circleModel.getAfter();
    json['mental'] = circleModel.getMental();
    json['other'] = circleModel.getOther();
    json['ovu'] = circleModel.getOvu();

    return json;

  }


  String getPeriodStart(){
    return periodStart!;
  }

  void setPeriodStart(String periodStart) {
    this.periodStart = periodStart;
  }

  String getPeriodEnd() {
    return periodEnd!;
  }

  void setPeriodEnd(String periodEnd) {
    this.periodEnd = periodEnd;
  }

  String getCircleEnd() {
    return circleEnd!;
  }

  void setCircleEnd(String circleEnd) {
    this.circleEnd = circleEnd;
  }

  int getStatus(){
    return status!;
  }

  void setStatus(int status){
    this.status = status;
  }

  String getBefore() {
    return before!;
  }

  void setBefore(String before) {
    this.before = before;
  }

  String getAfter() {
    return after!;
  }

  void setAfter(String after) {
    this.after = after;
  }

  String getMental() {
    return mental!;
  }

  void setMental(String mental) {
    this.mental = mental;
  }

  String getOther() {
    return other!;
  }

  void setOther(String other) {
    this.other = other;
  }


  String? getOvu() {
    return ovu;
  }

  void setOvu(String? ovu) {
    this.ovu = ovu;
  }


}