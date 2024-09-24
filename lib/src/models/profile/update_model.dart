

class UpdateModel {
  late bool isUpdate;
  late String linkUpdate;
  late String buttonText;
  late String updateText;


  UpdateModel.fromJson(Map<String,dynamic> parsedJson){
    isUpdate = parsedJson['isUpdate'];
    linkUpdate = parsedJson['linkUpdate'];
    buttonText = parsedJson['buttonText'];
    updateText = parsedJson['updateText'];
  }

}