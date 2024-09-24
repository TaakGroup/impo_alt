import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:get/get.dart';
import '../../../../../firebase_analytics_helper.dart';

// ignore: must_be_immutable
class HelpAlarms extends StatelessWidget{
   final isOfflineMode;

  HelpAlarms({this.isOfflineMode});

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.HelpAlarmsPg_Back_NavBar_Clk);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child:  Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              new CustomAppBar(
                messages: false,
                profileTab: true,
                icon: 'assets/images/ic_arrow_back.svg',
                titleProfileTab: 'صفحه قبل',
                subTitleProfileTab: 'راهنما ی یادآورها',
                onPressBack: (){
                  AnalyticsHelper().log(AnalyticsEvents.HelpAlarmsPg_Back_Btn_Clk);
                  Navigator.pop(context);
                },
                isEmptyLeftIcon: isOfflineMode ? true : null,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(50)
                  ),
                  child: ListView(
                    children: [
                      Text(
                        'سامسونگ Samsung',
                        style: titleStyle(context),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(25)),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: ScreenUtil().setWidth(2),
                        color: ColorPallet().mainColor,
                      ),
                      SizedBox(height: ScreenUtil().setHeight(40)),
                      Text(
                         samsung,
                        style: subTileStyle(context),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(60)),
                      //////
                      Text(
                        'هوآوی Huawei',
                        style: titleStyle(context),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(25)),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: ScreenUtil().setWidth(2),
                        color: ColorPallet().mainColor,
                      ),
                      SizedBox(height: ScreenUtil().setHeight(40)),
                      Text(
                        huawei,
                        style: subTileStyle(context),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(60)),
                      //////
                      Text(
                        'شیاومی XiaoMI',
                        style: titleStyle(context),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(25)),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: ScreenUtil().setWidth(2),
                        color: ColorPallet().mainColor,
                      ),
                      SizedBox(height: ScreenUtil().setHeight(40)),
                      Text(
                        xiaoMI,
                        style: subTileStyle(context),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(60)),
                      //////
                      Text(
                        'سایر گوشی ها',
                        style: titleStyle(context),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(25)),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: ScreenUtil().setWidth(2),
                        color: ColorPallet().mainColor,
                      ),
                      SizedBox(height: ScreenUtil().setHeight(40)),
                      Text(
                        samsung,
                        style: subTileStyle(context),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(60)),
                    ],
                  )
                )
              )
            ],
          ),
        )
      ),
    );
  }

  TextStyle  titleStyle(BuildContext context){
    return context.textTheme.headlineMedium!.copyWith(
      color: ColorPallet().mainColor,
      fontSize: 32,
    );
  }

  TextStyle subTileStyle(BuildContext context){
    return context.textTheme.bodyLarge!.copyWith(
        height: 2
    );
  }

  String samsung = '''1- تنظیمات گوشی (setting) > مراقب دستگاه (device care) >  سه نقطه (بالای صفحه) >  پیشرفته(advanced)  >
الف : بهینه سازی خودکار (auto optimization) خاموش شود.
ب : بهینه کردن تنظیمات (optimize setting) خاموش شود.

2- تنظیمات گوشی (setting) >  مراقب دستگاه (device care) > باتری (battery) >  حالت نیرو (power mode) >
الف :  بهینه شده  (optimized) خاموش شود.
ب :  ذخیره نیرو انطباقی (adaptive power saving) خاموش شود.
 (در برخی گوشی ها این امکان وجود ندارد.)

3- تنظیمات گوشی (setting) > مراقب دستگاه  (device care) > باتری (battery) > مدیریت نیروی برنامه (app power management)  >
الف :  برنامه های در حال خواب (sleeping apps) > ایمپو را غیر فعال نمایید.
ب :  برنامه هایی که به خواب نمی روند (apps that wont be to sleep) > ایمپو  را به قسمت افزودن برنامه (add apps) اضافه نمایید.
د : باتری تطبیقی خاموش نمایید(adaptive battery)

4- تنظیمات گوشی (setting) > برنامه ها (apps) > ایمپو > باتری (battery) >
الف : فعالیت در پس زمینه روشن نمایید.
ب: بهینه سازی (optimize battery usage)  > (نوار بالای صفحه) همه برنامه ها > ایمپو غیر فعال نمایید. 
                      ''';

  String huawei = '''1- تنظیمات گوشی (setting) > باتری (battery)  > راه اندازی  (App launch)> ایمپو  را غیر فعال نمایید. (یا بر روی گزینه اجرا در پس زمینه قرار دهید)  Run in Backgorundفعال باشد

2- تنظیمات گوشی (setting)  > باتری (battery)   > حالت ذخیره نیرو خاموش شود. Power saving mode 

3- تنظیمات گوشی (setting) > باتری  (battery) > حالت ذخیره نیروی بیشتر خاموش شود. Ultra power saving mode 

4- تنظیمات گوشی (setting) > باتری  (battery) > بهینه ساز باتری  optimize battery  > ایمپو  را غیر مجاز نمایید.
(در برخی گوشی ها این امکان وجود ندارد.)

5- تنظیمات گوشی (setting) > برنامه ها و اعلان ها  Apps & notifications> ایمپو > بهینه ساز باتری  optimize battery  > ایمپو  را غیر مجاز نمایید.
(در برخی گوشی ها این امکان وجود ندارد.)
  ''';

  String xiaoMI = '''1. تنظیمات گوشی (setting) >  برنامه ها (apps) > مدیریت برنامه ها (manage apps) > ایمپو :
الف : تیک شروع خودکار (auto start) روشن شود.
ب: سایر مجوزها (other permissions) > آغاز در پس زمینه (start in background) > قبول شود (accept)
2. باتری و عملکرد (battery & performance) > محافظ باتری (battery saver) را خاموش نمایید.
 باتری و عملکرد (battery & performance) > محافظ باتری برنامه (App battery saver) > ایمپو  ، را بدون محدودیت قرار دهید. ( unlimited )
در گوشی های شیاومی اندروید 10 و بالاتر :
. تنظیمات گوشی (setting) >  برنامه ها (apps) > مدیریت برنامه ها (manage apps) > ایمپو <  سایر مجوز ها  (other permissions) همه موارد قبول شود :
  ''';

}