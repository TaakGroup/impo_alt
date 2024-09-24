

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/expert_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:impo/src/data/auto_backup.dart';

import '../screens/home/tabs/expert/clinic_question_screen.dart';

class BoxMessages extends StatefulWidget{
  final value;
  final color;
  final borderColor;
  final link;
  final typeLink;
  final id;
  final margin;
  final ExpertPresenter? expertPresenter;
  final pressAnalytics;

  BoxMessages({this.value,this.color,this.borderColor,this.link,this.typeLink,
    this.id,this.margin,this.expertPresenter,this.pressAnalytics});
  @override
  State<StatefulWidget> createState() => BoxMessagesState();
}

class BoxMessagesState extends State<BoxMessages> with TickerProviderStateMixin{

  late AnimationController _controller;
  Tween<double> _tween = Tween(begin: 0.75, end: 1);

  late AnimationController _animationController;

  Animations _animations = new Animations();

  String _link = '';


  @override
  void initState() {
    _animationController = _animations.pressButton(this);
    if(widget.link != null){
      _link = widget.link;
    }
    _controller = AnimationController(duration: const Duration(milliseconds: 2700), vsync: this);
    _controller.repeat(reverse: true);
    super.initState();
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _animations.squareScaleBackButtonObserve,
      builder: (context,AsyncSnapshot<double> snapshot){
        if(snapshot.data != null){
          return Transform.scale(
            scale: snapshot.data,
            child: GestureDetector(
              onTap: ()async{
                if(widget.link != null){
                  if(widget.typeLink != null){
                    if(widget.typeLink == 1 || widget.typeLink == 2){
                      widget.pressAnalytics();
                      if(widget.typeLink == 1){
                        if(widget.link != ''){
                          if(widget.expertPresenter != null){
                            await _animationController.reverse();
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child:  ClinicQuestionScreen(
                                      expertPresenter: widget.expertPresenter!,
                                      bodyTicketInfo: json.decode(widget.link),
                                      // ticketId: ticketsModel.ticketId,
                                    )
                                )
                            );
                          }
                        }
                      }
                      if(widget.typeLink == 2){
                        if(widget.link != ''){
                          await _animationController.reverse();
                          _launchURL(widget.link,widget.id);
                        }
                      }
                    }
                  }
                }
              },
              child : new Container(
                margin: EdgeInsets.only(
                  top: ScreenUtil().setWidth(15),
                  right: ScreenUtil().setWidth(widget.margin),
                  left: ScreenUtil().setWidth(widget.margin),
                ),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(15),
                    vertical: ScreenUtil().setWidth(10)
                ),
                decoration: new BoxDecoration(
                    border: Border.all(
                        color: widget.borderColor,
//          ColorPallet().mainColor,
                        width: ScreenUtil().setWidth(2)
                    ),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)
                    ),
                    color: widget.color
//        Color(0xffFFE8F7).withOpacity(.5),
                ),
                child: Row(
                  children:[
                    _link != '' ?
                    ScaleTransition(
                      scale: _tween.animate(CurvedAnimation(parent: _controller, curve: Curves.ease)),
                      child:  Container(
                        width: ScreenUtil().setWidth(45),
                        height:  ScreenUtil().setWidth(45),
                        padding: EdgeInsets.all( ScreenUtil().setWidth(8)),
                        decoration: BoxDecoration(
                            color: widget.borderColor,
                            shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                            'assets/images/ic_link_.png'
                        ),
                      ),
                    )
                        : Container(),
                    _link != '' ?
                        SizedBox(width: ScreenUtil().setWidth(10)) :
                        Container(),
                    Flexible(
                      child:   new Text(
                        widget.value,
                        textAlign: TextAlign.start,
                        textDirection: TextDirection.rtl,
                        style:  context.textTheme.bodySmall!.copyWith(
                          color: Color(0xff575757),
                        ),
                      ),
                    )
                  ],
                )
              )
            ),
          );
        }else{
          return Container();
        }
      },
    );

  }

  Future<bool> _launchURL(url,id) async {
    if(id != null){
      if(id != ''){
        clickOnPinMessages('dashboard', id);
      }
    }
    String httpUrl = '';
    if(url.startsWith('http')){
      httpUrl = url;
    }else{
      httpUrl = 'https://$url';
    }
    // if (await canLaunch(httpUrl)) {
    //   await launch(httpUrl);
    // } else {
    //   throw 'Could not launch $httpUrl';
    // }
    if (!await launch(httpUrl)) throw 'Could not launch $httpUrl';
    return true;
  }

  clickOnPinMessages(String type, String id) async {
    var register = locator<RegisterParamModel>();
    Map responseBody = await Http().sendRequest(
        womanUrl, 'report/msg$type/$id', 'POST', {}, register.register.token!);
    print(responseBody);
  }

}