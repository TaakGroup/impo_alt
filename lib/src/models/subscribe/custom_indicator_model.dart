import 'package:flutter/material.dart';

class CustomIndicatorModel {
  Function()? onPressed;
  double? size;
  Color? color;
  bool isSelected;

  CustomIndicatorModel({this.onPressed, this.size, this.color,this.isSelected = false});
}
