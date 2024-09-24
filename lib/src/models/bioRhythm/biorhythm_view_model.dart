
import 'package:flutter/material.dart';
import 'package:impo/src/models/bioRhythm/bio_model.dart';


class BioRhythmViewModel {

  String? icon;
  String? deactiveIcon;
  String? title;
  String? viewPercent;
  double? percent;
  int? mainPersent;
  Color? mainColor;
  List<Color>? gradientColors;
  List<Color>? gradientIcon;
  bool? isSelected = false;

  BioRhythmViewModel({this.icon,this.title,this.viewPercent,this.percent,this.mainColor,this.gradientColors,this.isSelected,this.mainPersent,this.gradientIcon,this.deactiveIcon});

}

List<BioRhythmViewModel> viewBioRhythms = [];
List<BioRhythmMessagesModel> allRandomMessages = [];
