import 'package:flutter/cupertino.dart';
import 'package:impo/src/models/breastfeeding/breastfeeding_number_model.dart';
import 'package:shamsi_date/extensions.dart';


abstract class RegisterParamModel extends ChangeNotifier {

  // void addRegister(Map<String,dynamic> map);

  void setAllRegister(RegisterParamViewModel registerParamViewModel);

  ///Global
  setStatus(_status);
  setInterFaceCode(_interFaceCode);
  setName(String _name);
  setNationality(String _nationality);
  setBirthDay(String _birthDay);
  setSex(int _sex);
  setCalendarType(int _type);
  setSignText(String _signText);
  setPeriodStatus(int? _periodStatus);
  setToken(String _token);


  ///Ghaedegi
  setPeriodDay(int _periodDay);
  setCircleDay(int _circleDay);
  setLastPeriod(String _lastPeriod);

  ///Bardari
  setIsDeliveryDate(bool _isDeliveryDate);
  setPregnancyDate(DateTime _pregnancyDate);
  setHasAboration(int _hasAboration);
  setPregnancyNo(int _pregnancyNo);


  /// Breastfeeding (lactation)
  setChildBirthDate(DateTime _childBirthDate);
  setChildType(int _childType);
  setChildBirthType(int _childBirthType);
  setChildName(String _childName);
  setBreastfeedingNumberModel(BreastfeedingNumberModel _breastfeedingNumberModel);

  RegisterParamViewModel get  register;

}

class RegisterParamModelImplementation extends RegisterParamModel {

  RegisterParamViewModel _register = RegisterParamViewModel();

  @override
  RegisterParamViewModel get register => _register;

  // @override
  // void addRegister(Map<String, dynamic> map) {
  //   _register = RegisterParamViewModel.fromJson(map);
  //   notifyListeners();
  // }

  @override
  void setAllRegister(RegisterParamViewModel registerParamViewModel) {
    _register = registerParamViewModel;
    notifyListeners();
  }


  @override
  setStatus(_status) {
    _register.status = _status;
    notifyListeners();
  }

  @override
  setInterFaceCode(_interFaceCode) {
    _register.interFaceCode = _interFaceCode;
    notifyListeners();
  }

  @override
  setName(String _name) {
    _register.name = _name;
    notifyListeners();
  }

  @override
  setNationality(String _nationality) {
    _register.nationality = _nationality;
    notifyListeners();
  }

  @override
  setBirthDay(String _birthDay) {
    _register.birthDay = _birthDay;
    notifyListeners();
  }

  @override
  setSex(int _sex) {
    _register.sex = _sex;
    notifyListeners();
  }


  @override
  setPeriodDay(int _periodDay) {
    _register.periodDay = _periodDay;
    notifyListeners();
  }


  @override
  setCircleDay(int _circleDay) {
    _register.circleDay = _circleDay;
    notifyListeners();
  }

  @override
  setLastPeriod(String _lastPeriod) {
    _register.lastPeriod = _lastPeriod;
    notifyListeners();
  }




  @override
  setIsDeliveryDate(bool _isDeliveryDate) {
   _register.isDeliveryDate = _isDeliveryDate;
    notifyListeners();
  }

  @override
  setPregnancyDate(DateTime _pregnancyDate) {
    _register.pregnancyDate = _pregnancyDate;
    notifyListeners();
  }

  @override
  setHasAboration(int _hasAboration) {
    _register.hasAboration = _hasAboration;
    notifyListeners();
  }

  @override
  setPregnancyNo(int _pregnancyNo) {
    _register.pregnancyNo = _pregnancyNo;
    notifyListeners();
  }




  @override
  setChildBirthDate(DateTime _childBirthDate) {
    _register.childBirthDate = _childBirthDate;
    notifyListeners();
  }

  @override
  setChildBirthType(int _childBirthType) {
    _register.childBirthType = _childBirthType;
    notifyListeners();
  }

  @override
  setChildType(int _childType) {
    _register.childType = _childType;
    notifyListeners();
  }

  @override
  setChildName(String _childName) {
    _register.childName = _childName;
    notifyListeners();
  }

  @override
  setBreastfeedingNumberModel(BreastfeedingNumberModel _breastfeedingNumberModel) {
    _register.breastfeedingNumberModel = _breastfeedingNumberModel;
    notifyListeners();
  }


  @override
  setCalendarType(int _type) {
    _register.calendarType = _type;
    notifyListeners();
  }


  @override
  setSignText(String _setSignText) {
    _register.signText = _setSignText;
    notifyListeners();
  }

  @override
  setPeriodStatus(int? _periodStatus) {
    _register.periodStatus = _periodStatus;
    notifyListeners();
  }

  @override
  setToken(String _token) {
    _register.token = _token;
    notifyListeners();
  }

}

class RegisterParamViewModel {

    int? status;
    String? interFaceCode;
    String? name;
    String? birthDay;
    int? sex;
    String? nationality;
    String? token = '';
    int? calendarType = 0;
    String? signText;
    int? periodStatus;

    int? periodDay;
    int? circleDay;
    String? lastPeriod;


    bool? isDeliveryDate;
    DateTime? pregnancyDate;
    int? hasAboration;
    int? pregnancyNo;

    DateTime? childBirthDate;
    int? childBirthType;
    int? childType;
    String? childName = '';
    BreastfeedingNumberModel? breastfeedingNumberModel;

   RegisterParamViewModel({
     this.status, this.interFaceCode, this.name, this.birthDay,
     this.sex,this.token,this.calendarType,this.signText,this.periodStatus,
     this.nationality, this.periodDay, this.circleDay,
     this.lastPeriod, this.isDeliveryDate, this.pregnancyDate,
     this.hasAboration, this.pregnancyNo,this.childBirthDate,this.childBirthType,
     this.childType,this.childName,this.breastfeedingNumberModel
});



  RegisterParamViewModel.fromJson(Map<String,dynamic> parsedJson){

    status = parsedJson['status'];
    interFaceCode = parsedJson['interFaceCode'];
    name = parsedJson['name'];
    birthDay = parsedJson['birthDay'];
    sex = parsedJson['typeSex'];
    nationality = parsedJson['nationality'];
    token = parsedJson['token'];
    calendarType = parsedJson['calendarType'];
    signText = parsedJson['signText'];
    periodStatus = parsedJson['periodStatus'];

    periodDay = parsedJson['periodDay'];
    circleDay = parsedJson['circleDay'];
    lastPeriod = parsedJson['lastPeriod'];

    isDeliveryDate = parsedJson['isDeliveryDate'];
    pregnancyDate = parsedJson['pregnancyDate'];
    hasAboration = parsedJson['hasAboration'];
    pregnancyNo = parsedJson['pregnancyNo'];

  }




  String getName(){
    return name!;
  }

  
  int getPeriodDay(){
    return periodDay!;
  }



  int getCircleDay(){
    return circleDay!;
  }


  String getLastPeriod(){
    return lastPeriod!;
  }

  String getBirthDay(){
    return birthDay!;
  }


  int getSex(){
    return sex!;
  }


}