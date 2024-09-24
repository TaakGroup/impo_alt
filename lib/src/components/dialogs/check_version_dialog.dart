
import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:impo/src/data/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';


class CheckVersionDialog{

  late AnimationController animationControllerDialog;

  final isShowCheckUpdateDialog = BehaviorSubject<bool>.seeded(false);
  final dialogScale = BehaviorSubject<double>.seeded(0.0);
  final valueCheckUpdateDialog = BehaviorSubject<List>.seeded([]);


  Stream<bool> get isShowCheckUpdateDialogObserve => isShowCheckUpdateDialog.stream;
  Stream<double> get dialogScaleObserve => dialogScale.stream;
  Stream<List> get valueCheckUpdateDialogObserve => valueCheckUpdateDialog.stream;

  initialDialogScale(_this){
    animationControllerDialog = AnimationController(
        vsync: _this,
        lowerBound: 0.0,
        upperBound: 1,
        duration: Duration(milliseconds: 250));
    animationControllerDialog.addListener(() {
      dialogScale.sink.add(animationControllerDialog.value);
    });
  }

  Future<String> getVersion()async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return version;
  }


  checkVersion()async{
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        identityUrl,
        'customerAccount/checkupdate',
        'POST',
        {
          "deviceType" : Platform.isIOS ? 1 : 0,
          "version"  : await getVersion()
        },
        ''
    );


    List _vlaue = [];
   //
   // print(responseBody);

    if(responseBody != null){

      if(responseBody['neeUpdate']){

        Timer(Duration(milliseconds: 50),()async{
          animationControllerDialog.forward();
          if(!isShowCheckUpdateDialog.isClosed){
            isShowCheckUpdateDialog.sink.add(true);
          }
        });

        _vlaue.add(responseBody['message']);
        _vlaue.add(responseBody['link']);
        _vlaue.add(responseBody['isCritical']);

        if(!valueCheckUpdateDialog.isClosed){
          valueCheckUpdateDialog.sink.add(_vlaue);
        }

      }else{

      }

    }else{

    }

  }

  cancelUpdate()async{
    await animationControllerDialog.reverse();
    if(!isShowCheckUpdateDialog.isClosed){
      isShowCheckUpdateDialog.sink.add(false);
    }
  }

  acceptUpdate(String url) async {
    // await animationControllerDialog.reverse();
    // if(!isShowCheckUpdateDialog.isClosed){
    //   isShowCheckUpdateDialog.sink.add(false);
    // }
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
  }


  dispose(){
    isShowCheckUpdateDialog.close();
    dialogScale.close();
    valueCheckUpdateDialog.close();
  }

}