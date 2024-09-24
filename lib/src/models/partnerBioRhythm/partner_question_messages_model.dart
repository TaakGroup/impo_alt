

class PartnerQuestionMessagesModel {
  int? id;
  String? text;

  PartnerQuestionMessagesModel({this.id,this.text});

  PartnerQuestionMessagesModel.fromJson(Map<String,dynamic> parsedJson){
    id = parsedJson['id'];
    text = parsedJson['text'];
  }

}