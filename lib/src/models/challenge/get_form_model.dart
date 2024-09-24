
class GetFormModel{

  late bool valid;
  late String id;
  late String title;
  late String date;
  late String status;
  late String question;
  late String helper;
  late BtnFormModel btn;


  GetFormModel.fromJson(Map<String,dynamic> parsedJson){
    valid = parsedJson['valid'];
    id = parsedJson['id'];
    title = parsedJson['title'];
    date = parsedJson['date'];
    status = parsedJson['status'];
    question = parsedJson['question'];
    helper = parsedJson['helper'];
    btn = BtnFormModel.fromJson(parsedJson['btn']);
  }

}

class BtnFormModel{

  late String text;
  late int nextStep;

  BtnFormModel.fromJson(Map<String,dynamic> parsedJson){
    text = parsedJson['text'];
    nextStep = parsedJson['nextStep'];
  }

}