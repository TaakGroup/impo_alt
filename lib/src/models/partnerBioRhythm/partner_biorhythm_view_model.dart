import 'package:flutter/material.dart';
import 'package:impo/src/models/partnerBioRhythm/partner_bioRhythm_messages_model.dart';

class PartnerBioRhythmViewModel {

  String? icon;
  String? deactiveIcon;
  String? title;
  String? viewPercent;
  double? percent;
  int? mainPersent;
  Color? mainColor;
  List<Color>? gradientColors;
  List<Color>? gradientIcon;
  bool isSelected;

  PartnerBioRhythmViewModel({this.icon,this.title,this.viewPercent,this.percent,this.mainColor,
    this.gradientColors,this.isSelected = false,this.mainPersent,this.gradientIcon,this.deactiveIcon});

}

List<PartnerBioRhythmViewModel> viewPartnerBioRhythms = [];
List<PartnerBioRhythmMessagesModel> partnerAllRandomMessages = [];
