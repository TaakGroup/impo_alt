
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../firebase_analytics_helper.dart';

class ContactImpoScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ContactImpoScreenState();
}

class ContactImpoScreenState extends State<ContactImpoScreen>{

  late TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = _handlePress;
    super.initState();
  }

  void _handlePress() {
    AnalyticsHelper().log(AnalyticsEvents.ContactImpoPg_Call_Text_Clk);
    _makePhoneCall('tel:05191014180');
  }

  Future<void> _makePhoneCall(String url) async {
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.ContactImpoPg_Back_NavBar_Clk);
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
                    subTitleProfileTab: 'اطلاعات کاربری',
                    onPressBack: (){
                      AnalyticsHelper().log(AnalyticsEvents.ContactImpoPg_Back_Btn_Clk);
                      Navigator.pop(context);
                    },
                  ),
                ),
                Flexible(
                  flex: 5,
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(320),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/images/ic_big_support.svg',
                                    width: ScreenUtil().setWidth(180),
                                    height: ScreenUtil().setWidth(180),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: ScreenUtil().setWidth(20),
                                  ),
                                  child: Text(
                                    'ارتباط با ایمپو',
                                    style:  context.textTheme.headlineMedium!.copyWith(
                                      color: ColorPallet().gray,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(20)),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(30)
                            ),
                            child: Text(
                              'ایمپویی عزیز\nمی‌تونی هر سوال، مشکل، نظر و پیشنهادی رو در تلگرام ایمپو باهامون در میون بذاری',
                              textAlign: TextAlign.center,
                              style:  context.textTheme.bodyMedium!.copyWith(
                                color: ColorPallet().gray,
                              ),
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(80)),
                          CustomButton(
                            onPress: (){
                              AnalyticsHelper().log(AnalyticsEvents.ContactImpoPg_RegCommit_Btn_Clk);
                              _launchURL('https://t.me/impo_support');
                            },
                            title: 'ثبت نظر',
                            enableButton: true,
                            colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: ScreenUtil().setWidth(80),
                          right: ScreenUtil().setWidth(50),
                          left: ScreenUtil().setWidth(50),
                        ),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text : " جهت ارتباط با پشتیبانی، ارائه شکایات و ‌ گزارش‌ها\nمی‌تونید با شماره تلفن ",
                              style: context.textTheme.labelSmall!.copyWith(
                                color: ColorPallet().gray,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '05191014180',
                                  recognizer: _tapGestureRecognizer,
                                  mouseCursor: SystemMouseCursors.precise,
                                    style: context.textTheme.labelSmallProminent!.copyWith(
                                      color: ColorPallet().mentalMain,
                                    ),
                                ),
                                TextSpan(
                                  text: '\nاز ساعت 9 تا 21 تماس بگیرید',
                                    style: context.textTheme.labelSmall!.copyWith(
                                      color: ColorPallet().gray,
                                    ),
                                ),
                              ]
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
  }

}