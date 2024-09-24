


class PartnerBioModel{

  int? id;
  late int totalDay;
  late int bodyPercent;
  late int cognitivePercent;
  late int emotionalPercent;



  PartnerBioModel.fromJson(Map<String,dynamic> parsedJson){
    id = parsedJson['id'];
    totalDay = parsedJson['totalDay'];
    bodyPercent = parsedJson['bodyPercent'];
    cognitivePercent = parsedJson['cognitivePercent'];
    emotionalPercent = parsedJson['emotionalPercent'];
  }



}