import 'package:impo/src/components/DateTime/my_datetime.dart';


class OtherExperienceModel{
  late String topicName;
  late bool isPin;
  late bool isEdit;
  late String text;
  late String image;
  late String id;
  late bool isDelete;
  late  String createDateTime;
  late String name;
  late int likeCount;
  late int disliked;
  late int state;
  bool? selfExperience;
  late bool prohibtComment;
  late String avatar;
  late int commentCount;
  late bool approvedProfile;


  OtherExperienceModel.fromJson(Map<String,dynamic> parsedJson){
    topicName = parsedJson['topicName'];
    isPin = parsedJson['isPin'];
    isEdit = parsedJson['isEdit'];
    text = parsedJson['text'];
    image = parsedJson['image'];
    id = parsedJson['id'];
    isDelete = parsedJson['isDelete'];
    createDateTime =  MyDateTime().getDateTimeFormat(DateTime.parse(parsedJson['createTime']));
    name = parsedJson['name'];
    likeCount = parsedJson['likeCount'];
    disliked = parsedJson['disliked'];
    state = parsedJson['state'];
    selfExperience = parsedJson['selfExperience'];
    prohibtComment = parsedJson['prohibtComment'];
    avatar = parsedJson['avatar'];
    commentCount = parsedJson['commentCount'];
    approvedProfile = parsedJson['approvedProfile'];
  }

}