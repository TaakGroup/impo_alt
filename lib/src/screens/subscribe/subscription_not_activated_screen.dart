import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/main.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/firebase_analytics_helper.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../architecture/presenter/subscribe_presenter.dart';
import '../../components/animations.dart';

class SubscriptionNotActivatedScreen extends StatefulWidget{
  final SubscribePresenter? subscribePresenter;
  final String? supportPhone;

  SubscriptionNotActivatedScreen({Key? key,this.subscribePresenter,this.supportPhone}):super(key:key);

  @override
  State<StatefulWidget> createState() => SubscriptionNotActivatedScreenState();
}

class SubscriptionNotActivatedScreenState extends State<SubscriptionNotActivatedScreen> with TickerProviderStateMixin{

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.SubNotActivatedPg_Back_NavBar_Clk);
    return Future.value(true);
  }

  Animations _animations =  Animations();

  String? title;
  String? description;
  bool isSendToken = false;

  @override
  void initState() {
    _animations.shakeError(this);
    initTexts();
    widget.subscribePresenter!.tokenStoreController = TextEditingController();
    super.initState();
  }

  initTexts(){
    if(typeStore == 1){
      title = 'فعال نشدن اشتراک از کافه بازار';
      description = 'از قسمت کاربری (بازار من)، قسمت "کیف پول و پرداخت" رو انتخاب کن و از قسمت "تراکنش‌ها" توکن تراکنش ایمپو رو در قسمت زیر وارد کن';
      isSendToken = true;
    }else if(typeStore == 2){
      title = 'فعال نشدن اشتراک از مایکت';
      description = 'از قسمت کاربری (مارکت من)، قسمت تراکنش ها رو انتخاب کن، در صورتی که تراکنش موفق در مایکت داشتی، توکن تراکنشت رو در قسمت زیر وارد کن';
      isSendToken = true;
    }else{
      description = 'در صورتی که پرداخت موفق بوده و اشتراک شما فعال نشده، اپلیکیشن رو ببندید، چند دقیقه صبر کنید و دوباره وارد ایمپو بشید. اشتراک شما بعد از چند دقیقه فعال خواهد شد\n\nدر صورتیکه پرداخت ناموفق باشه هم حداکثر تا 72 ساعت، مبلغ کسر شده به حسابت برمیگرده';
      isSendToken = false;
    }
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
          body:  Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: <Widget>[
                  Flexible(
                    child:  CustomAppBar(
                      messages: false,
                      profileTab: true,
                      isEmptyLeftIcon: true,
                      icon: 'assets/images/ic_arrow_back.svg',
                      titleProfileTab: 'صفحه قبل',
                      subTitleProfileTab: 'فعال نشدن اشتراک',
                      onPressBack: (){
                        AnalyticsHelper().log(AnalyticsEvents.SubNotActivatedPg_Back_Btn_Clk);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(30)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isSendToken ?
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title!,
                                style: context.textTheme.labelLargeProminent,
                              ),
                              Text(
                                description!,
                                style: context.textTheme.bodySmall,
                              ),
                              Container(
                                  height: ScreenUtil().setWidth(80),
                                  margin: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(50),
                                  ),
                                  decoration:  BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color:  ColorPallet().gray.withOpacity(0.3),
                                      ),
                                      boxShadow:  [
                                        BoxShadow(
                                            color: Color(0xff989898).withOpacity(0.15),
                                            blurRadius: 5.0
                                        )
                                      ]

                                  ),
                                  child:  Center(
                                      child:  Theme(
                                        data: Theme.of(context).copyWith(
                                          textSelectionTheme: TextSelectionThemeData(
                                              selectionColor: Color(0xffaaaaaa),
                                              cursorColor: ColorPallet().mainColor
                                          ),
                                        ),
                                        child:  TextField(
                                          autofocus: false,
                                          // maxLength: 20,
                                          controller: widget.subscribePresenter!.tokenStoreController,
                                          enableInteractiveSelection: false,
                                          style:  context.textTheme.bodySmall,
                                          decoration:  InputDecoration(
                                            counterText: '',
                                            border: InputBorder.none,
                                            hintText: 'توکن',
                                            hintStyle:  context.textTheme.bodySmall!.copyWith(
                                              color: ColorPallet().gray.withOpacity(0.5),
                                            ),
                                            contentPadding:  EdgeInsets.only(
                                              right: ScreenUtil().setWidth(20),
                                              left: ScreenUtil().setWidth(10),
                                              bottom: ScreenUtil().setWidth(20),
//                                          top: ScreenUtil().setWidth(20),
                                            ),
                                          ),
                                        ),
                                      )
                                  )
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child:  AnimatedBuilder(
                                    animation: _animations.animationShakeError,
                                    builder: (buildContext, child) {
                                      if (_animations.animationShakeError.value < 0.0) print('${_animations.animationShakeError.value + 8.0}');
                                      return  StreamBuilder(
                                        stream: _animations.isShowErrorObserve,
                                        builder: (context,AsyncSnapshot<bool> snapshot){
                                          if(snapshot.data != null){
                                            if(snapshot.data!){
                                              return  StreamBuilder(
                                                  stream: _animations.errorTextObserve,
                                                  builder: (context,AsyncSnapshot<String>snapshot){
                                                    return Container(
                                                        padding: EdgeInsets.only(left: _animations.animationShakeError.value + 4.0, right: 4.0 -_animations.animationShakeError.value),
                                                        child: Text(
                                                          snapshot.data != null ? snapshot.data! : '',
                                                          style:  context.textTheme.bodySmall!.copyWith(
                                                            color: Color(0xffEE5858),
                                                          ),
                                                        )
                                                    );
                                                  }
                                              );
                                            }else {
                                              return  Opacity(
                                                opacity: 0.0,
                                                child:  Container(
                                                  child:  Text(''),
                                                ),
                                              );
                                            }
                                          }else{
                                            return  Opacity(
                                              opacity: 0.0,
                                              child:  Container(
                                                child:  Text(''),
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    }),
                              ),
                              SizedBox(height: ScreenUtil().setHeight(70)),
                              StreamBuilder(
                                stream: widget.subscribePresenter!.isLoadingCheckCodeButtonObserve,
                                builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                                  if(snapshotIsLoading.data != null){
                                    if(!snapshotIsLoading.data!){
                                      return  CustomButton(
                                        title: 'ارسال توکن',
                                        onPress: (){
                                          AnalyticsHelper().log(AnalyticsEvents.SubNotActivatedPg_SendToken_Btn_Clk);
                                          widget.subscribePresenter!.checkCode(_animations, context);
                                        },
                                        margin: 160,
                                        colors: [ColorPallet().mainColor,ColorPallet().mainColor],
                                        borderRadius: 10.0,
                                        enableButton: true,
                                      );
                                    }else{
                                      return  Center(
                                          child:  LoadingViewScreen(color: ColorPallet().mainColor,)
                                      );
                                    }
                                  }else{
                                    return  Container();
                                  }
                                },
                              ),
                            ],
                          ) :
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(16)
                            ),
                            child: Text(
                              description!,
                              textAlign: TextAlign.center,
                              style: context.textTheme.labelMedium,
                            ),
                          ),
                          // Spacer(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          bottomNavigationBar: SizedBox(
            height: MediaQuery.of(context).size.height/4.8,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: ScreenUtil().setWidth(50)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding:EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(32)
                    ),
                    child: Text(
                      'در صورتیکه بعد از طی این مراحل اشتراکت فعال نشد\nبا شماره ${widget.supportPhone} تماس بگیر',
                      textAlign: TextAlign.center,
                      style: context.textTheme.labelSmall,
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setWidth(20)),
                  CustomButton(
                    title: 'تماس با ایمپو',
                    height: ScreenUtil().setWidth(75),
                    textColor: Color(0xff1F1F1F),
                    icon: 'assets/images/call.svg',
                    onPress: (){
                      _launchURL('tel:${widget.supportPhone}');
                    },
                    margin: 220,
                    colors: [Colors.transparent,Colors.transparent],
                    borderColor: Color(0xffE7E7E7),
                    borderRadius: 12.0,
                    enableButton: true,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
    return true;
  }


}