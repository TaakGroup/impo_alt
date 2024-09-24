import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/profile_presenter.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/expert_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/profile/update_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../firebase_analytics_helper.dart';

class UpdateScreen extends StatefulWidget{
  final ProfilePresenter? presenter;

  UpdateScreen({Key? key,this.presenter}) : super(key:key);

  @override
  State<StatefulWidget> createState() => UpdateScreenState();
}

class UpdateScreenState extends State<UpdateScreen>{



  Future<String> getVersion()async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return version;
  }



  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.UpdatePg_Back_NavBar_Clk);
    return Future.value(true);
  }

  @override
  void initState() {
    widget.presenter!.postUpdate(context);
    super.initState();
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
          body:  Column(
           children: <Widget>[
              Flexible(
               child:  CustomAppBar(
                 messages: false,
                 profileTab: true,
                 isLogoImpo: true,
                 icon: 'assets/images/ic_arrow_back.svg',
                 titleProfileTab: 'صفحه قبل',
                 subTitleProfileTab: 'کاربری',
                 onPressBack: (){
                   AnalyticsHelper().log(AnalyticsEvents.UpdatePg_Back_Btn_Clk);
                   Navigator.pop(context);
                 },
               ),
             ),
             StreamBuilder(
               stream: widget.presenter!.isLoadingObserve,
               builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                 if(snapshotIsLoading.data != null){
                   if(!snapshotIsLoading.data!){
                    return StreamBuilder(
                      stream: widget.presenter!.updatePropObserve,
                      builder: (context,AsyncSnapshot<UpdateModel>snapshotUpdate){
                        if(snapshotUpdate.data != null){
                          return Flexible(
                              flex: 3,
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/update_page.png',
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(height: ScreenUtil().setHeight(50)),
                                  Padding(
                                    padding:EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setWidth(30)
                                    ),
                                    child: Text(
                                      snapshotUpdate.data!.updateText,
                                      textAlign: TextAlign.center,
                                      style: context.textTheme.bodyMedium,
                                    ),
                                  ),
                                  Spacer(),
                                  !snapshotUpdate.data!.isUpdate ?  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: ScreenUtil().setWidth(100)
                                    ),
                                    child: CustomButton(
                                      title: snapshotUpdate.data!.buttonText,
                                      onPress: (){
                                        AnalyticsHelper().log(AnalyticsEvents.UpdatePg_Update_Btn_Clk);
                                        _launchURL(snapshotUpdate.data!.linkUpdate);
                                      },
                                      margin: 30,
                                      colors: [ColorPallet().mainColor,ColorPallet().mainColor],
                                      borderRadius: 10.0,
                                      enableButton: true,
                                    ),
                                  ) : SizedBox.shrink()
                                ],
                              )
                          );
                        }else{
                          return Container();
                        }
                      },
                    );
                   }else{
                     return Expanded(
                         child: StreamBuilder(
                           stream: widget.presenter!.tryButtonErrorObserve,
                           builder: (context,AsyncSnapshot<bool>snapshotTryButton) {
                             if (snapshotTryButton.data != null) {
                               if (snapshotTryButton.data!) {
                                 return Padding(
                                     padding: EdgeInsets.only(
                                         right: ScreenUtil().setWidth(80),
                                         left: ScreenUtil().setWidth(80),
                                         top: ScreenUtil().setWidth(200),
                                     ),
                                     child: Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: <Widget>[
                                         StreamBuilder(
                                           stream: widget.presenter!.valueErrorObserve,
                                           builder: (context,AsyncSnapshot<String>snapshotValueError) {
                                             if (snapshotValueError.data != null) {
                                               return Text(
                                                 snapshotValueError.data!,
                                                 textAlign: TextAlign.center,
                                                   style:  context.textTheme.bodyMedium!.copyWith(
                                                     color: Color(0xff707070),
                                                   )
                                               );
                                             } else {
                                               return Container();
                                             }
                                           },
                                         ),
                                         Padding(
                                             padding:
                                             EdgeInsets.only(top: ScreenUtil().setWidth(32)),
                                             child: ExpertButton(
                                               title: 'تلاش مجدد',
                                               onPress: () {
                                                 widget.presenter!.getSupport(context);
                                               },
                                               enableButton: true,
                                               isLoading: false,
                                             ))
                                       ],
                                     ));
                               } else {
                                 return LoadingViewScreen(color: ColorPallet().mainColor);
                               }
                             } else {
                               return Container();
                             }
                           },
                         ));
                   }
                 }else{
                   return Container();
                 }
               },
             )
           ],
              )
        ),
      ),
    );
  }

  Future<bool> _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
    // if (await canLaunch(httpUrl)) {
    //   await launch(httpUrl);
    // } else {
    //   throw 'Could not launch $httpUrl';
    // }
    return true;
  }

}