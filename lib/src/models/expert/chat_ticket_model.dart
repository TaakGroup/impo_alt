import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/animation.dart';
import 'package:shamsi_date/shamsi_date.dart';

class ChatTicketModel{

  late bool drValid;
  late String drName;
  // double drRate;
  late String drImage;
  late String drSpeciality;
  late int state;
  List<ChatsModel> chats = [];
  late bool isRate;
  late double rate;
  String description = '';
  String drAcadimicCertificate = '';
  List<String> feedbackNegative = [];
  List<String> feedbackPositive = [];
  List<String> positive = [];
  List<String> negative = [];

  ChatTicketModel.fromJson(Map<String,dynamic> parsedJson){
    drValid = parsedJson['drValid'];
    drName = parsedJson['drName'];
    // drRate = parsedJson['drRate'] != null ? double.parse(parsedJson['drRate'].toString()) : parsedJson['drRate'];
    drImage = parsedJson['drImage'];
    drSpeciality = parsedJson['drSpeciality'];
    drAcadimicCertificate = parsedJson['drAcadimicCertificate'] != null ? parsedJson['drAcadimicCertificate'] : '';
    state = parsedJson['state'];
    description = parsedJson['description'] != null ? parsedJson['description'] : '';
    parsedJson['chats'] != [] ? parsedJson['chats'].forEach((item){
      chats.add(ChatsModel.formJson(item));
    }) : chats = [];
    isRate = parsedJson['isRate'];
    rate =  parsedJson['rate'] != null ? double.parse(parsedJson['rate'].toString()) : parsedJson['rate'];

    parsedJson['feedbackNegative'] != null ?
    parsedJson['feedbackNegative'].forEach((item){
      feedbackNegative.add(item);
    }) : feedbackNegative =  [];

    parsedJson['feedbackPositive'] != null ?
    parsedJson['feedbackPositive'].forEach((item){
      feedbackPositive.add(item);
    }) : feedbackPositive =  [];

    parsedJson['feedbacks']['positive'] != null ?
    parsedJson['feedbacks']['positive'].forEach((item){
      positive.add(item);
    }) : positive =  [];

    parsedJson['feedbacks']['negative'] != null ?
    parsedJson['feedbacks']['negative'].forEach((item){
      negative.add(item);
    }) : negative =  [];

  }

}

class ChatsModel{

  String text = '';
  String? media = '';
  late int sideType;
  late String date;
  late String time;
  String localFilePath = '';
  late int state;
  late int seq;
  String?  fileSize;
  // String taskId = '';
  // DownloadTaskStatus status = DownloadTaskStatus.undefined;
  int progress = 0;
  double valueVoice = 0;
  Duration totalVoice = Duration();
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isLoading = false;
  late AnimationController animationController;

  ChatsModel.formJson(Map<String,dynamic> parsedJson){
    text = parsedJson['text'] != null ?  parsedJson['text'] : '';
    media = parsedJson['media'] != null ? parsedJson['media'] : '';
    sideType = parsedJson['sideType'];
    DateTime createTime = DateTime.parse(parsedJson['dateTime']);
    Jalali shamsi = Jalali.fromDateTime(createTime);
    date = shamsi.formatter.date.toString().replaceAll('(', '').replaceAll(')', '').replaceAll('Jalali','').replaceAll(',', '/').replaceAll(' ','');
    time = parsedJson['dateTime'].toString().substring(11,16);
    state = parsedJson['state'];
    seq = parsedJson['seq'];
    // fileSize = '${parsedJson['fileSize']/1000}';
  }

}