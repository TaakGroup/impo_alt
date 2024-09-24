

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/text_field_area.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/widgets/snackbar/custom_snack_bar.dart';
import 'package:impo/src/screens/home/tabs/calender/memory/send_comment_screen.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../firebase_analytics_helper.dart';

class EnterFaceCodeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => EnterFaceCodeScreenState();
}

class EnterFaceCodeScreenState extends State<EnterFaceCodeScreen>{

  String enterFaceCode = '';
  String enterFaceText = '';

  @override
  void initState() {
    getInterfaceCode();
    super.initState();
  }

  getInterfaceCode()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.getString('interfaceCode'));
    if(this.mounted){
      setState(() {
        enterFaceCode = prefs.getString('interfaceCode')!;
        if(prefs.getString('interfaceText') != null){
          enterFaceText = prefs.getString('interfaceText')!;
        }
      });
    }
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.EnterFaceCodePg_Back_NavBar_Clk);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return  WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child:  Scaffold(
          backgroundColor: Colors.white,
          body:    Column(
            children: <Widget>[
               Flexible(
                child:  CustomAppBar(
                  messages: false,
                  profileTab: true,
                  isEmptyLeftIcon: true,
                  icon: 'assets/images/ic_arrow_back.svg',
                  titleProfileTab: 'صفحه قبل',
                  subTitleProfileTab: 'کد معرف',
                  onPressBack: (){
                    AnalyticsHelper().log(AnalyticsEvents.EnterFaceCodePg_Back_Btn_Clk);
                    Navigator.pop(context);
                  },
                ),
              ),
               Flexible(
                flex: 5,
                child:  Column(
                  children: <Widget>[
                     Padding(
                       padding: EdgeInsets.symmetric(
                         horizontal: ScreenUtil().setWidth(32)
                       ),
                       child: Text(
                        'ایمپویی عزیز، با ارسال این کد برای دوستانت\nبه ایمپو دعوتشون کن و با خرید اشتراک هر کدوم\nاز دوستانت، 10 روز اشتراک رایگان از ایمپو هدیه بگیر',
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium!.copyWith(
                          height: 1.6
                        ),
                    ),
                     ),
                     SizedBox(height: ScreenUtil().setWidth(80)),
                     GestureDetector(
                      onTap: (){
                        copyToClipBoard();
                        AnalyticsHelper().log(AnalyticsEvents.EnterFaceCodePg_CopyCode_Icon_Clk);
                      },
                      child:  Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(90)
                          ),
                          decoration:  BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                                color: Color(0xff909090).withOpacity(0.2)
                            ),
                          ),
                          child:  Stack(
                            alignment: Alignment.centerLeft,
                            children: <Widget>[
                               Align(
                                  alignment: Alignment.center,
                                  child:  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: ScreenUtil().setWidth(25)
                                    ),
                                    child:  Text(
                                      enterFaceCode,
                                      style:  context.textTheme.labelMediumProminent!.copyWith(
                                        color: ColorPallet().mainColor,
                                      ),
                                    ),
                                  )
                              ),
                               Container(
                                  width: ScreenUtil().setWidth(65),
                                  height: ScreenUtil().setWidth(65),
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(25)
                                  ),
                                  child:    Image.asset(
                                    'assets/images/ic_copy.png',
                                    fit: BoxFit.fitWidth,
                                  )
                              )
                            ],
                          )
                      ),
                    ),
                     SizedBox(height: ScreenUtil().setHeight(20)),
                     Text(
                      'برای دعوت از کد بالا استفاده کن',
                      style:  context.textTheme.bodySmall!.copyWith(
                        color: Color(0xff707070),
                      ),
                    ),
                     Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setWidth(120)
                        ),
                        child:  CustomButton(
                          onPress: (){
                            AnalyticsHelper().log(AnalyticsEvents.EnterFaceCodePg_ShareCode_Btn_Clk);
                            shareEnterFaceCode();
                          },
                          colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                          margin: 230,
                          title: 'اشتراک گذاری',
                          enableButton: true,
                        )
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  copyToClipBoard()async{
    FlutterClipboard.copy(enterFaceCode).then(( value ) {
      //Fluttertoast.showToast(msg:'کد معرف کپی شد',toastLength: Toast.LENGTH_LONG);
      CustomSnackBar.show(context,'کد معرف کپی شد');
    });
  }


  shareEnterFaceCode(){
   // Share.share('دوست خوبم! از تو هم دعوت میکنم که مثل من ایمپویی بشی، می‌تونی از لینک زیر ایمپو رو نصب کنی و با این کد از ایمپو هدیه بگیری\nکد معرف برای ثبت نام:  $enterFaceCode\nلینک نصب اپلیکیشن: https://cafebazaar.ir/app/ir.duck.impo');
    Share.share(enterFaceText);
  }

}