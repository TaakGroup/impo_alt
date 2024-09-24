
import 'package:flutter/material.dart';

abstract class PregnancyNumberModel extends ChangeNotifier {

  PregnancyNumberViewModel get  pregnancyNumbers;

  setPregnancyNumbers(PregnancyNumberViewModel pregnancyNumberViewModel);

}

class PregnancyNumberModelImplementation extends PregnancyNumberModel {

  PregnancyNumberViewModel? _pregnancyNumbers;


  @override
  PregnancyNumberViewModel get pregnancyNumbers => _pregnancyNumbers!;

  @override
  setPregnancyNumbers(PregnancyNumberViewModel pregnancyNumberViewModel) {
    _pregnancyNumbers = pregnancyNumberViewModel;
    notifyListeners();
  }


}

class PregnancyNumberViewModel{
  int? weekNoPregnancy;
  int? monthNoPregnancy;
  int? dayToDelivery;
  DateTime? lastPeriod;
  DateTime? givingBirth;

  PregnancyNumberViewModel({this.weekNoPregnancy,this.dayToDelivery,this.monthNoPregnancy,this.lastPeriod,this.givingBirth});


}