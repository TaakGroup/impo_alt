
import 'package:flutter/cupertino.dart';

abstract class BreastfeedingSignsModel extends ChangeNotifier {

  BreastfeedingSignsViewModel get  breastfeedingSings;

  setBabySigns(List<int> signs);
  setPhysical(List<int> signs);
  setBreastfeedingMother(List<int> signs);
  setPsychology(List<int> signs);
  removeAllBreastfeedingSigns();


}

class BreastfeedingSignsModelImplementation extends BreastfeedingSignsModel {

  BreastfeedingSignsViewModel  _breastfeedingSigns = BreastfeedingSignsViewModel();

  @override
  BreastfeedingSignsViewModel get breastfeedingSings => _breastfeedingSigns;

  @override
  setBabySigns(List<int> signs) {
    _breastfeedingSigns.babySigns = signs;
    notifyListeners();
  }


  @override
  setPhysical(List<int> signs) {
    _breastfeedingSigns.physical = signs;
    notifyListeners();
  }

  @override
  setBreastfeedingMother(List<int> signs) {
    _breastfeedingSigns.breastfeedingMother = signs;
    notifyListeners();
  }

  @override
  setPsychology(List<int> signs) {
    _breastfeedingSigns.psychology = signs;
    notifyListeners();
  }

  @override
  removeAllBreastfeedingSigns() {
    _breastfeedingSigns.babySigns!.clear();
    _breastfeedingSigns.physical!.clear();
    _breastfeedingSigns.breastfeedingMother!.clear();
    _breastfeedingSigns.psychology!.clear();
    notifyListeners();
  }

}





class BreastfeedingSignsViewModel{

  List<int>? babySigns = [];
  List<int>? physical= [];
  List<int>? breastfeedingMother = [];
  List<int>? psychology = [];

  // PregnancySignsViewModel();

  BreastfeedingSignsViewModel({this.babySigns,this.physical,this.breastfeedingMother,this.psychology});

}