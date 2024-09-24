
class SendQuestionsModel{

  late String id;
  late String answer;
  late String supplementaryAnswer;


  Map<String,dynamic> setJson(String _id,String _answer,String _supplementaryAnswer){

    Map<String,dynamic> json = {};

    json['id'] = _id;
    id = _id;

    json['answer'] = _answer;
    answer = _answer;

    json['supplementaryAnswer'] = _supplementaryAnswer;
    supplementaryAnswer = _supplementaryAnswer;

    return json;

  }

}