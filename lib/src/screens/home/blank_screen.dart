

import 'dart:async';

import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:impo/src/architecture/presenter/expert_presenter.dart';
import 'package:impo/src/architecture/presenter/support_presenter.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/home/home.dart';
import 'package:impo/src/screens/home/tabs/calender/calender.dart';
import 'package:impo/src/screens/home/tabs/expert/chat_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/password_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/supportOnline/pages/chat_support_screen.dart';
import 'package:page_transition/page_transition.dart';

class BlankScreen extends StatefulWidget{
  final indexTab;
  final ExpertPresenter? expertPresenter;
  final SupportPresenter? supportPresenter;
  final chatId;
  final fromMainExpert;
  final fromActiveClini;
  BlankScreen({Key? key,this.indexTab,this.expertPresenter,this.supportPresenter,this.chatId,
    this.fromMainExpert,this.fromActiveClini}):super(key:key);
  @override
  State<StatefulWidget> createState() => BlankScreenState();
}

class BlankScreenState extends State<BlankScreen>{

  @override
  void initState() {
    goBack();
    super.initState();
  }

  goBack(){
    WidgetsBinding.instance.addPostFrameCallback((_){

      if(widget.indexTab < 5){
        Navigator.pushReplacement(context,
            MaterialPageRoute(
                settings: RouteSettings(name: "/Page1"),
                builder: (context) => new FeatureDiscovery(
                  recordStepsInSharedPreferences: true,
                  child:  Home(
                    indexTab: widget.indexTab,
                    register: true,
                    isChangeStatus: false,
                    // isLogin: false,
                  )
                )
            )
        );
      }else{
        if(widget.indexTab == 5){
          Navigator.pushReplacement(context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: new PasswordScreen()
              )
          );
        }else if(widget.indexTab == 7){
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child:  ChatSupportScreen(
                    supportPresenter: widget.supportPresenter,
                    chatId: widget.chatId,
                    fromNotify: false,
                  )
              )
          );
        }else{
          Navigator.pushReplacement(context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: ChatScreen(
                    expertPresenter: widget.expertPresenter,
                    chatId: widget.chatId,
                    fromMainExpert: widget.fromMainExpert,
                    fromActiveClini: widget.fromActiveClini,
                  )
              ),
          );
        }

      }

    });

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Container(
            color: Colors.white,
          ),
        ],
      ),
    );
  }

}