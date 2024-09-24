import 'package:flutter/material.dart';

class PartnerCustomIndicatorModel {
  Function()? onPressed;
  double? size;
  Color? color;
  bool? isSelected;

  PartnerCustomIndicatorModel({this.onPressed, this.size, this.color,this.isSelected = false});
}
