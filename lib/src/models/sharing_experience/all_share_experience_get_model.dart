import 'package:impo/src/models/sharing_experience/other_experience_model.dart';
import 'package:impo/src/models/sharing_experience/self_experience_model.dart';
import 'package:impo/src/models/sharing_experience/topic_model.dart';

class AllShareExperienceGetModel {
  late String selfTitleText;
  late String groupsTitleText;
  late String otherTitleText;
  late String inputText;
  List<TopicModel> topics = [];
  // List<PinExperienceModel> pin = [];
  List<SelfExperienceModel> self = [];
  List<OtherExperienceModel> other = [];
  // String text;
  // String boldText = '';

  AllShareExperienceGetModel.fromJson(Map<String,dynamic> parsedJson){
    selfTitleText = parsedJson['selfTitleText'];
    groupsTitleText = parsedJson['groupsTitleText'];
    otherTitleText = parsedJson['otherTitleText'];
    inputText = parsedJson['inputText'];
    parsedJson['topics'].forEach((item){
      topics.add(TopicModel.fromJson(item));
    });
    // parsedJson['pin'].forEach((item){
    //   pin.add(PinExperienceModel.fromJson(item));
    // });
    parsedJson['self'].forEach((item){
      self.add(SelfExperienceModel.fromJson(item));
    });
    parsedJson['other'].forEach((item){
      other.add(OtherExperienceModel.fromJson(item));
    });
    // String _text = parsedJson['text'];
    // if(_text.toString().contains('//')){
    //   int startIndex = _text.indexOf('//');
    //   int endIndex = _text.lastIndexOf('//');
    //   boldText = _text.substring(startIndex,endIndex).replaceAll('//','');
    //   text = _text.substring(endIndex,_text.length).replaceAll('//','');
    // }else{
    //   text = _text;
    //   boldText = '';
    // }
  }

}