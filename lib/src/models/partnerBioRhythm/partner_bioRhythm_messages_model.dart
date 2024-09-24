

class PartnerBioRhythmMessagesModel{

  int? id;
  String? text;
  int? type;


  PartnerBioRhythmMessagesModel({this.id,this.text,this.type});

  PartnerBioRhythmMessagesModel.fromJson(Map<String,dynamic> parsedJson){
    id = parsedJson['id'];
    text = parsedJson['text'];
    type = parsedJson['type'];
  }

}