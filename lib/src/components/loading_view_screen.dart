

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:impo/src/components/colors.dart';



class LoadingViewScreen extends StatefulWidget{
  final Color? color;
  final lineWidth;
  final width;

  LoadingViewScreen({Key? key,this.color,this.lineWidth,this.width});

  @override
  State<StatefulWidget> createState() => LoadingViewScreenState();
}

class LoadingViewScreenState extends State<LoadingViewScreen>{
  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return new Container(
      height: widget.width == null ? ScreenUtil().setWidth(85) : widget.width,
      width:  widget.width == null ? ScreenUtil().setWidth(85) : widget.width,
      padding: widget.width == null ?  EdgeInsets.all(ScreenUtil().setWidth(10)) :  EdgeInsets.all(ScreenUtil().setWidth(0)),
      decoration: new BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(7)
      ),
      child: new Center(
        child: SpinKitRing(
          lineWidth: widget.lineWidth != null ?widget.lineWidth : ScreenUtil().setWidth(6),
          color: widget.color!,
//          size: 50.0,
          duration: Duration(seconds: 1),
        )
      ),
    );
  }

}