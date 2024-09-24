import 'package:flutter/cupertino.dart';

abstract class BioModel extends ChangeNotifier {

  BioViewModel get bioRythms;

  void addAllBio(Map<String,dynamic> map);

}

class BioModelImplementation extends BioModel {

  late BioViewModel _bioRythms;

  @override
  void addAllBio(Map<String,dynamic> map) {
    _bioRythms = BioViewModel.fromJson(map);
    notifyListeners();
  }

  @override
  BioViewModel get bioRythms => _bioRythms;

}


class BioViewModel{

  late bool visibility;
  late int totalDay;
  late int bodyPercent;
  late int cognitivePercent;
  late int emotionalPercent;
  List<BioRhythmMessagesModel> cognitiveMessage = [];
  List<BioRhythmMessagesModel> bodyMessage = [];
  List<BioRhythmMessagesModel> emotionalMessage = [];


  BioViewModel.fromJson(Map<String,dynamic> parsedJson){
    visibility = parsedJson['visibility'];
    totalDay = parsedJson['totalDay'];
    bodyPercent = parsedJson['bodyPercent'];
    cognitivePercent = parsedJson['cognitivePercent'];
    emotionalPercent = parsedJson['emotionalPercent'];

    parsedJson['bodyMessage'] != null ?
    parsedJson['bodyMessage'].forEach((item){
      bodyMessage.add(BioRhythmMessagesModel(text: item,type: 0));
    }) : bodyMessage =  [];

    parsedJson['emotionalMessage'] != null ?
    parsedJson['emotionalMessage'].forEach((item){
      emotionalMessage.add(BioRhythmMessagesModel(text: item,type: 1));
    }) : emotionalMessage =  [];

    parsedJson['cognitiveMessage'] != null ?
    parsedJson['cognitiveMessage'].forEach((item){
      cognitiveMessage.add(BioRhythmMessagesModel(text: item,type: 2));
    }) : cognitiveMessage =  [];

  }

}

class BioRhythmMessagesModel {
  String? text;
  int? type;
  String username;

  BioRhythmMessagesModel({this.text, this.type, this.username = ''});

  // BioRhythmMessagesModel.fromJson(Map<String, dynamic> parsedJson) {
  //   text = parsedJson['text'];
  //   type = parsedJson['type'];
  // }
}
