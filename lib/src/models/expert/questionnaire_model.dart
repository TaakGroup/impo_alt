
import 'package:flutter/cupertino.dart';

class QuestionnaireModel{
  late String id;
  late bool validAnswer;
  late String answer;
  late String text;
  List<SubAnswerModel> subAnswer = [];
  late bool validSupplementAnswer;
  late String supplementAnswer;
  late bool hasSupplementAnswer;
  late int type;
  bool selected = false ;
  TextEditingController supplementaryAnswerController = new TextEditingController();
  TextEditingController answerController = new TextEditingController();

  QuestionnaireModel.fromJson(Map<String,dynamic> parsedJson){
    id = parsedJson['id'];
    validAnswer = parsedJson['validAnswer'];
    text = parsedJson['text'];
    validSupplementAnswer = parsedJson['validSupplementaryAnswer'];
    hasSupplementAnswer = parsedJson['hasSupplementaryAnswer'];
    type = parsedJson['type'];
    supplementAnswer = parsedJson['supplementaryAnswer'];
    supplementaryAnswerController = new TextEditingController(text: supplementAnswer);
    answer = parsedJson['answer'];
    answerController = new TextEditingController(text: answer);

    if(parsedJson['subAnswer'] != []){
      parsedJson['subAnswer'].forEach((item){
        subAnswer.add(
            SubAnswerModel.fromJson(
                {
                  'subAnswer' : item,
                  'selected' : type == 0 && item == answer && validAnswer ? true : false
                }
            )
        );
      });
    }

  }

}


class SubAnswerModel{

  late String subAnswer;
  bool selected = false;

  SubAnswerModel.fromJson(Map<String,dynamic> parsedJson){
    subAnswer = parsedJson['subAnswer'];
    selected = parsedJson['selected'];
  }


}
