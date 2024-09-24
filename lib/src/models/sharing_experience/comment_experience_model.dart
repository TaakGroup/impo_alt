import 'package:impo/src/components/DateTime/my_datetime.dart';
import 'package:intl/intl.dart';


class CommentExperienceModel {
  late String name;
  late String topicName;
  late String text;
  late String image;
  late String createDateTime;
  late int likeCount;
  late int dislikeCount;
  late int commentCount;
  late int state;
  late String avatar;
  late bool approvedProfile;


  CommentExperienceModel.fromJson(Map<String,dynamic> parsedJson){
    name = parsedJson['name'];
    topicName = parsedJson['topicName'];
    text = parsedJson['text'];
    image = parsedJson['image'];
    createDateTime =  MyDateTime().getDateTimeFormat(DateTime.parse(parsedJson['createTime']));
    likeCount = parsedJson['likeCount'];
    dislikeCount = parsedJson['dislikeCount'];
    commentCount = parsedJson['commentCount'];
    state = parsedJson['state'];
    avatar = parsedJson['avatar'];
    approvedProfile = parsedJson['approvedProfile'];
  }

}


class ListCommentExperienceModel{
  late bool isEdit;
  late String text;
  late String id;
  late bool isDelete;
  late String createDateTime;
  late String name;
  late int likeCount;
  late int disliked;
  late  int state;
  late bool selfComment;

  late String avatar;
  late bool approvedProfile;
  bool selected = false;


  ListCommentExperienceModel.fromJson(Map<String,dynamic> parsedJson){
    isEdit = parsedJson['isEdit'];
    text = parsedJson['text'];
    id = parsedJson['id'];
    isDelete = parsedJson['isDelete'];
    createDateTime =  MyDateTime().getDateTimeFormat(DateTime.parse(parsedJson['createTime']));
    name = parsedJson['name'];
    likeCount = parsedJson['likeCount'];
    disliked = parsedJson['disliked'];
    state = parsedJson['state'];
    avatar = parsedJson['avatar'];
    selfComment = parsedJson['selfComment'];
    approvedProfile = parsedJson['approvedProfile'];
  }

}