
import 'package:flutter/cupertino.dart';

abstract class PregnancySignsModel extends ChangeNotifier {

  PregnancySignsViewModel get  pregnancySings;

  setFetalSex(List<int> signs);
  setPhysical(List<int> signs);
  setPhysicalPregnancy(List<int> signs);
  setGastrointestinalPregnancy(List<int> signs);
  setPsychologyPregnancy(List<int> signs);
  removeAllPregnancySigns();


}

class PregnancySignsModelImplementation extends PregnancySignsModel {

  PregnancySignsViewModel  _pregnancySings = PregnancySignsViewModel();

  @override
  PregnancySignsViewModel get pregnancySings => _pregnancySings;

  @override
  setFetalSex(List<int> signs) {
    _pregnancySings.fetalSex = signs;
    notifyListeners();
  }

  @override
  setGastrointestinalPregnancy(List<int> signs) {
    _pregnancySings.gastrointestinalPregnancy = signs;
    notifyListeners();
  }

  @override
  setPhysical(List<int> signs) {
    _pregnancySings.physical = signs;
    notifyListeners();
  }

  @override
  setPhysicalPregnancy(List<int> signs) {
    _pregnancySings.physicalPregnancy = signs;
    notifyListeners();
  }

  @override
  setPsychologyPregnancy(List<int> signs) {
    _pregnancySings.psychologyPregnancy = signs;
    notifyListeners();
  }

  @override
  removeAllPregnancySigns() {
    _pregnancySings.fetalSex!.clear();
    _pregnancySings.physical!.clear();
    _pregnancySings.physicalPregnancy!.clear();
    _pregnancySings.gastrointestinalPregnancy!.clear();
    _pregnancySings.psychologyPregnancy!.clear();
    notifyListeners();
  }

}

class PregnancySignsViewModel{

  List<int>? fetalSex = [];
  List<int>? physical = [];
  List<int>? physicalPregnancy = [];
  List<int>? gastrointestinalPregnancy = [];
  List<int>? psychologyPregnancy = [];

  // PregnancySignsViewModel();

  PregnancySignsViewModel({this.fetalSex,this.physical,this.psychologyPregnancy,this.gastrointestinalPregnancy,this.physicalPregnancy});

}
