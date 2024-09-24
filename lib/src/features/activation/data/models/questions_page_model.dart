
import 'package:get/get.dart';
import 'package:taakitecture/taakitecture.dart';

class QuestionsPageModel extends BaseModel with ModelMixin{
  late List<OptionsQuestionsPageModel> options;
  late String title;
  late String description;
  late String subtitle;
  late bool enable;
  late String btnLabel;
  late String btnLabel2;
  late String image;
  late List<String> gradient;
  late bool doRepeat;


  @override
  BaseModel getInstance() => QuestionsPageModel();

  @override
  Map<String, dynamic> get properties =>{
    'options' : options,
    'title' : title,
    'description' : description,
    'subtitle' : subtitle,
    'enable' : enable,
    'btnLabel' : btnLabel,
    'btnLabel2' : btnLabel2,
    'image' : image,
    'gradient' : gradient,
    'doRepeat' : doRepeat,
  };

  @override
  void setProp(String key, value) {
    switch (key) {
      case "options":
        options = [for (var mapJson in value) OptionsQuestionsPageModel().fromJson(mapJson)];
        break;
      case "title":
        title = value;
        break;
      case "description":
        description = value;
        break;
      case "subtitle":
        subtitle = value;
        break;
      case "enable":
        enable = value;
        break;
      case "btnLabel":
        btnLabel = value;
        break;
      case "btnLabel2":
        btnLabel2 = value;
        break;
      case "image":
        image = value;
        break;
      case "gradient":
        gradient = [for (var text in value) text];
        break;
      case "doRepeat":
        doRepeat = value;
        break;
    }
  }

}

class OptionsQuestionsPageModel extends BaseModel with ModelMixin{
  late int id;
  late String text;
  late String description;
  Rx<bool> selected = false.obs;


  @override
  BaseModel getInstance() => OptionsQuestionsPageModel();

  @override
  Map<String, dynamic> get properties =>{
    'id' : id,
    'text' : text,
    'description' : description
  };

  @override
  void setProp(String key, value) {
    switch (key) {
      case "id":
        id = value;
        break;
      case "text":
        text = value;
        break;
      case "description":
        description = value;
        break;
    }
  }

}