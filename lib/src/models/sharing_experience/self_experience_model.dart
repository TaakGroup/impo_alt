import 'package:impo/src/components/DateTime/my_datetime.dart';



class SelfExperienceModel{
  late String topicName;
  late bool isEdit;
  late String text;
  late String image;
  late String id;
  late bool isDelete;
  late String createDateTime;
  late int likeCount;
  late int disliked;
  late int commentCount;
  late bool prohibtComment;
  late bool approvedProfile;
  bool selected = false;




  SelfExperienceModel.fromJson(Map<String,dynamic> parsedJson){
    topicName = parsedJson['topicName'];
    isEdit = parsedJson['isEdit'];
    text = parsedJson['text'];
    image = parsedJson['image'];
    id = parsedJson['id'];
    isDelete = parsedJson['isDelete'];
    createDateTime =  MyDateTime().getDateTimeFormat(DateTime.parse(parsedJson['createTime']));
    likeCount = parsedJson['likeCount'];
    disliked = parsedJson['disliked'];
    commentCount = parsedJson['commentCount'];
    prohibtComment = parsedJson['prohibtComment'];
    approvedProfile = parsedJson['approvedProfile'];
  }

}