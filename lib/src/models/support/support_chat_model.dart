
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/animation.dart';
import 'package:shamsi_date/shamsi_date.dart';

class SupportChatModel {
  late  String date;
  late String time;
  late String id;
  late  bool sendByUser;
  late String text;
  String? fileName;
  String?  fileSize;
  int progress = 0;
  String localFilePath = '';
  double valueVoice = 0;
  Duration totalVoice = Duration();
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isLoading = false;
  late AnimationController animationController;

  SupportChatModel.fromJson(Map<String,dynamic> parsedJson){
    DateTime createTime = DateTime.parse(parsedJson['createTime']);
    Jalali shamsi = Jalali.fromDateTime(createTime);
    date = shamsi.formatter.date.toString().replaceAll('(', '').replaceAll(')', '').replaceAll('Jalali','').replaceAll(',', '/').replaceAll(' ','');
    time = parsedJson['createTime'].toString().substring(11,16);
    id = parsedJson['id'];
    sendByUser = parsedJson['sendByUser'];
    text = parsedJson['text'];
    fileName = parsedJson['fileName'];
  }

}