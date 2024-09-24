import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../firebase_analytics_helper.dart';

class AboutScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => AboutScreenState();
}

class AboutScreenState extends State<AboutScreen>{

  Future<String> getVersion()async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return version;
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.AboutPg_Back_NavBar_Clk);
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
          body:  Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
               Column(
                children: <Widget>[
                   Flexible(
                    child:  CustomAppBar(
                      messages: false,
                      profileTab: true,
                      isLogoImpo: true,
                      icon: 'assets/images/ic_arrow_back.svg',
                      titleProfileTab: 'صفحه قبل',
                      subTitleProfileTab: 'درباره ما',
                      onPressBack: (){
                        AnalyticsHelper().log(AnalyticsEvents.AboutPg_Back_Btn_Clk);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Flexible(
                      flex: 3,
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'impo',
                                style:  context.textTheme.headlineMedium,
                              ),
                              Text(
                                ' از دل این جمله بیرون اومده',
                                style:  context.textTheme.labelLargeProminent!.copyWith(
                                  color: ColorPallet().gray.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenUtil().setHeight(20)),
                          Text(
                            'I am important',
                            style:  context.textTheme.titleMedium!.copyWith(
                              color: ColorPallet().mainColor,
                            ),
                          ),
                          Text(
                            'یعنی من مهم هستم',
                            style:  context.textTheme.labelLargeProminent,
                          ),
                          SizedBox(height: ScreenUtil().setHeight(50)),
                          Padding(
                            padding:  EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(40)
                            ),
                            child: Text(
                              'ایمپو در کنارته تا هر روز بهت یادآوری کنه که باید بیشتر حواست به خودت باشه اینجاییم تا با خودمون در صلح باشیم، و سبک زندگی جدیدی رو با تغییر در نگرشمون بسازیم اینو یادت نره که تو خیلی مهم و ارزشمندی',
                              textAlign: TextAlign.center,
                              style:  context.textTheme.bodyMedium,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(100)),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.black,
                            height: ScreenUtil().setHeight(1),
                          )
                        ],
                      )
                  )
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: ScreenUtil().setWidth(30),
                      right: ScreenUtil().setWidth(50)
                  ),
                  child:  FutureBuilder(
                    future: getVersion(),
                    builder: (context,snapshot){
                      if(snapshot.data != null){
                        return  Text(
                          'نسخه ${snapshot.data}',
                          style:  context.textTheme.labelLarge,
                        );
                      }else{
                        return  Container();
                      }
                    },
                  )
              )
            ],
          )
        ),
      ),
    );
  }

}