import 'dart:io';
import 'package:flutter/material.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:photo_view/photo_view.dart';

class PhotoPageScreen extends StatefulWidget{
  final photo;
  final network;

  PhotoPageScreen({this.photo,this.network});

  @override
  State<StatefulWidget> createState() => PhotoPageScreenState();
}

class PhotoPageScreenState extends State<PhotoPageScreen>{

  @override
  Widget build(BuildContext context) {
    return  new Directionality(
      textDirection: TextDirection.rtl,
      child: new Scaffold(
          resizeToAvoidBottomInset: true,
          // resizeToAvoidBottomPadding: true,
          backgroundColor: Colors.white,
          body: Hero(
            tag: 'notePhoto',
            child: PhotoView(
                loadingBuilder: (context,event){
                  return Center(child: LoadingViewScreen(color: ColorPallet().mainColor));
                },
                imageProvider: getImage()
            ),
          )
      ),
    );
  }

  getImage(){
   return  widget.network ?
    NetworkImage(widget.photo) :
    FileImage(
        File(widget.photo)
    );
  }

}