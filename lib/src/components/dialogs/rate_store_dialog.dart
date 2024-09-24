

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/main.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:impo/src/architecture/presenter/dashboard_presenter.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:impo/src/screens/home/tabs/profile/reporting/reporting_screen.dart';

import '../../firebase_analytics_helper.dart';


class RateStore{

  late AnimationController animationControllerDialog;

  final isShowCheckReportingDialog = BehaviorSubject<bool>.seeded(false);
  final dialogScale = BehaviorSubject<double>.seeded(0.0);


  Stream<bool> get isShowCheckReportingDialogObserve => isShowCheckReportingDialog.stream;
  Stream<double> get dialogScaleObserve => dialogScale.stream;

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


  showDialog()async{
    AnalyticsHelper().log(AnalyticsEvents.DashPgPeriod_CheckReportingDlg_Dlg_Load);
    animationControllerDialog.forward();
    if(!isShowCheckReportingDialog.isClosed){
      isShowCheckReportingDialog.sink.add(true);
    }
  }


  checkShowComment()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? showComment = prefs.getBool('showComment');
    if(showComment!){
      showDialog();
    }
  }

  cancel()async{
    await animationControllerDialog.reverse();
    if(!isShowCheckReportingDialog.isClosed){
      isShowCheckReportingDialog.sink.add(false);
    }
  }

  accept(context,expertPresenter,name) async {
    cancel();
    if(typeStore == 1){
      await commentCafe();
    }else if(typeStore ==2){
      await commentMyket();
    }
  }

  commentCafe()async{
    final AndroidIntent intent = AndroidIntent(
      action: 'android.intent.action.EDIT',
      package: 'ir.duck.impo',
      data: 'bazaar://details?id=ir.duck.impo', // replace com.example.app with your applicationId
    );
    await intent.launch();
  }

  commentMyket()async{
    final AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      package: 'ir.duck.impo',
      data: 'myket://comment?id=ir.duck.impo', // replace com.example.app with your applicationId
    );
    await intent.launch();
  }

  dispose(){
    isShowCheckReportingDialog.close();
    dialogScale.close();
  }

}

class RateStoreDialog extends StatefulWidget{
  final scaleAnim;
  final onPressYes;
  final onPressNo;
  final title;

  RateStoreDialog({Key? key,this.scaleAnim,this.onPressYes,this.onPressNo,this.title}):super(key:key);
  @override
  State<StatefulWidget> createState() => RateStoreDialogState();
}

class RateStoreDialogState extends State<RateStoreDialog>{
  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = 0.5;
    return  Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            widget.onPressNo();
          },
          child: Container(
            decoration:  BoxDecoration(
                color: Colors.black.withOpacity(.8)
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(),
            StreamBuilder(
              stream: widget.scaleAnim,
              builder: (context,AsyncSnapshot<double> snapshotScale){
                if(snapshotScale.data != null){
                  return  Transform.scale(
                      scale: snapshotScale.data,
                      child:  Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(100),
                        ),
                        padding: EdgeInsets.only(
                          right: ScreenUtil().setWidth(30),
                          left: ScreenUtil().setWidth(30),
                          bottom: ScreenUtil().setWidth(5),
                          top: ScreenUtil().setWidth(50),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/rate_store.png',
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: ScreenUtil().setHeight(40)),
                            Text(
                              widget.title,
                              style: context.textTheme.titleSmall,
                            ),
                            SizedBox(height: ScreenUtil().setHeight(20)),
                            Text(
                              'با ثبت امتیاز و نظرت در مورد ایمپو کمک بزرگی به تیم ما در جهت توسعه و بهبود  ایمپو میکنی',
                              style: context.textTheme.bodyMedium,
                            ),
                            SizedBox(height: ScreenUtil().setHeight(40)),
                            CustomButton(
                              title: 'ارسال نظر',
                              height: ScreenUtil().setWidth(70),
                              onPress: (){
                                widget.onPressYes();
                              },
                              margin: 90,
                              colors: [ColorPallet().mainColor,ColorPallet().mainColor],
                              borderRadius: 10.0,
                              enableButton: true,
                            ),
                            CustomButton(
                              title: 'بعدا نظر میدم!',
                              onPress: (){
                                widget.onPressNo();
                              },
                              margin: 120,
                              textColor: Color(0xff7D7D7D),
                              colors: [Colors.white,Colors.white],
                              borderRadius: 10.0,
                              enableButton: true,
                            )
                          ],
                        ),
                      )
                  );
                }else{
                  return  Container();
                }
              },
            ),
          ],
        )

      ],
    );
  }

}