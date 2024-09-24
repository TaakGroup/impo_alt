import 'package:flutter/material.dart';

abstract class ProfileAllDataModel extends ChangeNotifier {


  void setAllProfile(ProfileAllDataViewModel profileAllDataViewModel);


  ProfileAllDataViewModel get  profileAllData;

}

class ProfileAllDataModelImplementation extends ProfileAllDataModel {

  ProfileAllDataViewModel _profileAllData = ProfileAllDataViewModel();

  @override
  ProfileAllDataViewModel get profileAllData => _profileAllData;

  @override
  void setAllProfile(ProfileAllDataViewModel profileAllDataViewModel) {
    _profileAllData = profileAllDataViewModel;
    notifyListeners();
  }

}

class ProfileAllDataViewModel {

  String? name;
  String? userName;
  String? subButtonText;
  String? subText;
  bool? hasSubscritbion;

  ProfileAllDataViewModel({this.name,this.userName,this.subButtonText,
    this.subText,this.hasSubscritbion});

  ProfileAllDataViewModel.fromJson(Map<String,dynamic> parsedJson){
    name = parsedJson['name'];
    userName = parsedJson['userName'];
    subButtonText = parsedJson['subButtonText'];
    subText = parsedJson['subText'];
    hasSubscritbion = parsedJson['hasSubscritbion'];
  }

}