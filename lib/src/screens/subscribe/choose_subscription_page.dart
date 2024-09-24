import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';
import 'package:impo/src/architecture/presenter/subscribe_presenter.dart';
import 'package:impo/src/architecture/view/subscribe_view.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/subscribe/subscribtions_packages_model.dart';
import 'package:impo/src/screens/subscribe/subscription_not_activated_screen.dart';
import 'package:impo/src/screens/subscribe/widgets/items_sub.dart';
import 'package:impo/src/screens/subscribe/widgets/sub_organizational_widget.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../components/colors.dart';
import '../../components/dialogs/exit_app_dialog.dart';
import '../../components/dialogs/qus_dialog.dart';
import '../../components/expert_button.dart';
import '../../components/loading_view_screen.dart';
import '../../data/locator.dart';
import '../../firebase_analytics_helper.dart';
import '../../models/register/register_parameters_model.dart';
import '../../models/subscribe/subscribes_get_model.dart';
import '../home/tabs/profile/profile_sceen.dart';
import '../splash_screen.dart';

class ChooseSubscriptionPage extends StatefulWidget {
  final bool? isSub;

  ChooseSubscriptionPage({Key? key,this.isSub}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChooseSubscriptionPageState();
}


class ChooseSubscriptionPageState extends State<ChooseSubscriptionPage> with TickerProviderStateMixin implements SubscribeView {
  late SubscribePresenter _presenter;
  var registerInfo = locator<RegisterParamModel>();
  ExitAppDialog exitAppDialog =  ExitAppDialog();
  Animations animations =  Animations();
  late AnimationController animationControllerScaleButton;
  bool enableDiscountButton = false;

  ChooseSubscriptionPageState() {
    _presenter = SubscribePresenter(this);
  }

  int modePress = 0;
  Future<bool> _onWillPop() async {
    AnalyticsHelper().log(AnalyticsEvents.ChooseSubscriptionPg_Back_NavBar_Clk);
    if(widget.isSub!){
      Navigator.pop(context);
    }else{
      exitAppDialog.onPressShowDialog();
    }
    return Future.value(false);
  }

  late ScrollController scrollController;



  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.ChooseSubscriptionPg_Self_Pg_Load);
    scrollController = ScrollController();
    _presenter.panelController =  PanelController();
    _presenter.discountController = TextEditingController(text: '');
    _presenter.getSubscribtions(false,context);
    exitAppDialog.initialDialogScale(this);
    animationControllerScaleButton = animations.pressButton(this);
    _presenter.initUniLinks(context);
    // SystemChrome.setEnabledSystemUIOverlays([
    //   SystemUiOverlay.bottom, //This line is used for showing the bottom bar
    // ]);
    checkVisibilityKeyBoard();
    super.initState();
  }


  checkVisibilityKeyBoard(){
    KeyboardVisibilityController().onChange.listen((bool visible) {
      if(mounted){
        if(visible){
          Timer(Duration(milliseconds: 100),(){
            scrollController.jumpTo(scrollController.position.pixels + 200);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    animationControllerScaleButton.dispose();
    _presenter.cancelUniLinkSub();
    super.dispose();
  }
  // @override
  // void dispose() {
  //   _presenter.cancelUniLinkSub();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          key: _presenter.scaffoldKey,
            backgroundColor: Color(0xffF8F8F8),
            // resizeToAvoidBottomInset: true,
            body: Stack(
              children: [
                StreamBuilder(
                  stream: _presenter.isLoadingObserve,
                  builder: (context,AsyncSnapshot<bool>snapshotIsLoading) {
                    if (snapshotIsLoading.data != null) {
                      if (!snapshotIsLoading.data!) {
                        return SingleChildScrollView(
                          controller: scrollController,
                          child: StreamBuilder(
                              stream: _presenter.subscribeObserve,
                              builder:
                                  (context, AsyncSnapshot<SubscribesGetModel> snapshotSubscribe) {
                                if (snapshotSubscribe.data != null) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        color: Color(0xffFFEBF8),
                                        child: Column(
                                          children: [
                                            SizedBox(height: ScreenUtil().setWidth(100)),
                                            Text(
                                              '${registerInfo.register.name} عزیز',
                                              style: context.textTheme.labelLargeProminent,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
                                              child: Text(
                                                // 'بااشتراک ایمپو، می‌تونی از همه امکانات اپلیکیشن\nبصورت نامحدود استفاده کنی',
                                                snapshotSubscribe.data!.text,
                                                textAlign: TextAlign.center,
                                                style: context.textTheme.labelSmallProminent,
                                              ),
                                            ),
                                            SizedBox(height: ScreenUtil().setWidth(20)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: ScreenUtil().setHeight(20)),
                                      snapshotSubscribe.data!.upText != '' ?
                                      Padding(
                                        padding:  EdgeInsets.only(
                                          right: ScreenUtil().setWidth(30),
                                          left: ScreenUtil().setWidth(30),
                                          bottom: ScreenUtil().setWidth(40),
                                        ),
                                        child: Text(
                                          snapshotSubscribe.data!.upText,
                                          style: context.textTheme.bodySmall,
                                        ),
                                      ) : SizedBox.shrink(),
                                      ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshotSubscribe.data!.packages.length,
                                        itemBuilder: (context, index) {
                                          return ItemsSub(
                                            item: snapshotSubscribe.data!.packages[index],
                                            onPress: () {
                                              _presenter.onPressItem(index);
                                              // if(snapshotSubscribe.data.packages[index].isFree){
                                              //   _presenter.pressFreeSub(context, snapshotSubscribe.data.packages[index].id);
                                              // }else{
                                              //   AnalyticsHelper().log(
                                              //       AnalyticsEvents.ChooseSubscriptionPg_PaySub_Item_Clk,
                                              //       parameters: {
                                              //         'id' : snapshotSubscribe.data.packages[index].id
                                              //       }
                                              //   );
                                              //   if(snapshotSubscribe.data.packages[index].inAppPurchase){
                                              //      _presenter.payMyket((int.parse(snapshotSubscribe.data.packages[index].id)+ 100).toString(), context);
                                              //      //_presenter.payCafeBazar((int.parse(snapshotSubscribe.data.packages[index].id)+ 100).toString(), context);
                                              //   }else{
                                              //     _presenter.pressPackagesSub(context, snapshotSubscribe.data.packages[index].id,snapshotSubscribe.data.packages[index].value);
                                              //   }
                                              //    //_presenter.pressPackagesSub(context, snapshotSubscribe.data.packages[index].id,snapshotSubscribe.data.packages[index].value);
                                              // }
                                            },
                                          );
                                        },
                                      ),
                                      snapshotSubscribe.data!.isShowOrganization ?
                                      Center(
                                        child: Material(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(12),
                                          child: InkWell(
                                            onTap: (){
                                              _presenter.showMyBottomSheet(context,snapshotSubscribe.data!);
                                            },
                                            borderRadius: BorderRadius.circular(12),
                                            child: Container(
                                                width: MediaQuery.of(context).size.width - ScreenUtil().setWidth(60),
                                              padding: EdgeInsets.symmetric(
                                                vertical: ScreenUtil().setWidth(20)
                                              ),
                                              decoration: BoxDecoration(
                                                // color: Color(0xffF8F8F8),
                                                color: Colors.transparent,
                                                border: Border.all(
                                                  color: Color(0xffCBCBCB),
                                                  width: ScreenUtil().setWidth(1)
                                                ),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  snapshotSubscribe.data!.organizationText,
                                                  style: context.textTheme.bodyMedium,
                                                ),
                                              )
                                            ),
                                          ),
                                        ),
                                      )
                                      : SizedBox.shrink(),
                                      Padding(
                                        padding:  EdgeInsets.only(
                                          top: ScreenUtil().setWidth(10),
                                          bottom: ScreenUtil().setWidth(20),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            snapshotSubscribe.data!.downText != ''
                                                ? Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: ScreenUtil().setWidth(30)
                                                  ),
                                                  child: Text(
                                                snapshotSubscribe.data!.downText,
                                              style: context.textTheme.bodySmall,
                                            ),
                                                ) : SizedBox.shrink(),
                                            snapshotSubscribe.data!.downText != '' ? SizedBox(height: ScreenUtil().setWidth(10)) : SizedBox(height: ScreenUtil().setWidth(5)),
                                            discountBox(),
                                            SizedBox(height: ScreenUtil().setWidth(25)),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: ScreenUtil().setWidth(30)
                                              ),
                                              child: StreamBuilder(
                                                stream: _presenter.subscribtionsPackagesSelectedObserve,
                                                builder: (context,AsyncSnapshot<SubscribtionsPackagesModel>snapshotSelectedSub){
                                                  if(snapshotSelectedSub.data != null){
                                                    return Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'جزییات پرداخت',
                                                          style: context.textTheme.labelMediumProminent!.copyWith(
                                                            color: Color(0xff575757),
                                                          ),
                                                        ),
                                                        SizedBox(height: ScreenUtil().setWidth(15)),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              snapshotSelectedSub.data!.text,
                                                              style:  context.textTheme.bodyMedium,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  snapshotSelectedSub.data!.realValueText,
                                                                  style: context.textTheme.bodyMedium!.copyWith(
                                                                    color: Color(0xff575757),
                                                                  ),
                                                                ),
                                                                SizedBox(width: ScreenUtil().setWidth(5)),
                                                                !snapshotSelectedSub.data!.isFree ?
                                                                Text(
                                                                  snapshotSelectedSub.data!.unit,
                                                                  style: context.textTheme.bodyMedium!.copyWith(
                                                                    color: Color(0xff575757),
                                                                  ),
                                                                ) : Container(width: 0,height: 0,),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        snapshotSelectedSub.data!.discount != 0 ?
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              'تخفیف',
                                                              style:  context.textTheme.bodySmall!.copyWith(
                                                                color: Color(0xffEF4056),
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  snapshotSelectedSub.data!.discountText,
                                                                  style:  context.textTheme.bodySmall!.copyWith(
                                                                    color: Color(0xffEF4056),
                                                                  ),
                                                                ),
                                                                SizedBox(width: ScreenUtil().setWidth(5)),
                                                                !snapshotSelectedSub.data!.isFree ? Text(
                                                                  snapshotSelectedSub.data!.unit,
                                                                  style:  context.textTheme.bodySmall!.copyWith(
                                                                    color: Color(0xffEF4056),
                                                                  ),
                                                                ) : Container(width: 0,height: 0,),
                                                              ],
                                                            )
                                                          ],
                                                        ) :
                                                        SizedBox.shrink(),
                                                        snapshotSelectedSub.data!.vat != 0 ?
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              '10 درصد مالیات برارزش افزوده',
                                                              style:  context.textTheme.bodySmall!.copyWith(
                                                                color : Color(0xff968E98),
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  snapshotSelectedSub.data!.vatText,
                                                                  style:  context.textTheme.bodySmall!.copyWith(
                                                                    color : Color(0xff968E98),
                                                                  ),
                                                                ),
                                                                SizedBox(width: ScreenUtil().setWidth(5)),
                                                                !snapshotSelectedSub.data!.isFree ? Text(
                                                                  snapshotSelectedSub.data!.unit,
                                                                  style:  context.textTheme.bodySmall!.copyWith(
                                                                    color : Color(0xff968E98),
                                                                  ),
                                                                ) : Container(width: 0,height: 0,),
                                                              ],
                                                            )
                                                          ],
                                                        ) :
                                                        SizedBox.shrink(),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                            top: ScreenUtil().setWidth(5),
                                                            bottom: ScreenUtil().setWidth(2),
                                                          ),
                                                          child: Divider(
                                                            color: Color(0xffE4E4E4),
                                                            thickness: ScreenUtil().setWidth(1.5),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              'مبلغ قابل پرداخت',
                                                              style:  context.textTheme.labelMediumProminent!.copyWith(
                                                                color: Color(0xff575757),
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  snapshotSelectedSub.data!.totalPayText,
                                                                  style:  context.textTheme.labelMediumProminent!.copyWith(
                                                                    color: Color(0xff575757),
                                                                  ),
                                                                ),
                                                                SizedBox(width: ScreenUtil().setWidth(5)),
                                                                !snapshotSelectedSub.data!.isFree ? Text(
                                                                  snapshotSelectedSub.data!.unit,
                                                                  style:  context.textTheme.labelMediumProminent!.copyWith(
                                                                    color: Color(0xff575757),
                                                                  ),
                                                                ) : Container(width: 0,height: 0,),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  }else{
                                                    return Container();
                                                  }
                                                },
                                              )
                                            ),
                                            SizedBox(height: ScreenUtil().setWidth(15)),
                                            Divider(
                                              color: Color(0xffF0F0F0),
                                              thickness: ScreenUtil().setWidth(10),
                                            ),
                                            SizedBox(height: ScreenUtil().setWidth(15)),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: ScreenUtil().setWidth(30)
                                              ),
                                              child: Column(
                                                children: [
                                                  StreamBuilder(
                                                    stream: animations.squareScaleBackButtonObserve,
                                                    builder: (context,AsyncSnapshot<double>snapshotScale){
                                                      if(snapshotScale.data != null){
                                                        return Transform.scale(
                                                          scale: modePress == 2 ? snapshotScale.data : 1,
                                                          child: GestureDetector(
                                                            onTap: ()async{
                                                              setState(() {
                                                                modePress =2;
                                                              });
                                                              await animationControllerScaleButton.reverse();
                                                              Navigator.push(
                                                                  context,
                                                                  PageTransition(
                                                                      type: PageTransitionType.fade,
                                                                      child:  SubscriptionNotActivatedScreen(
                                                                        subscribePresenter: _presenter,
                                                                        supportPhone: snapshotSubscribe.data!.supportPhone,
                                                                      )
                                                                  )
                                                              );
                                                            },
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  'اشتراک خریدی ولی فعال نشده؟',
                                                                  style: context.textTheme.labelSmall!.copyWith(
                                                                    color: Color(0xff575757),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  ' اینجا رو کلیک کن',
                                                                  style: context.textTheme.labelSmall!.copyWith(
                                                                    color: ColorPallet().mainColor,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ) ,
                                                        );
                                                      }else{
                                                        return Container();
                                                      }
                                                    },
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      snapshotSubscribe.data!.supportText,
                                                      //'در صورت وجود هرگونه مشکل با شماره 05191014180 تماس بگیر',
                                                      textAlign: TextAlign.center,
                                                      style: context.textTheme.labelSmall!.copyWith(
                                                        color: Color(0xff575757),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: ScreenUtil().setWidth(20)),
                                                  CustomButton(
                                                    title: 'تماس با ایمپو',
                                                    height: ScreenUtil().setWidth(75),
                                                    textColor: Color(0xff575757),
                                                    icon: 'assets/images/call.svg',
                                                    onPress: (){
                                                      _launchURL('tel:${snapshotSubscribe.data!.supportPhone}');
                                                    },
                                                    margin: 190,
                                                    colors: [Colors.transparent,Colors.transparent],
                                                    borderColor: Color(0xffE7E7E7),
                                                    borderRadius: 12.0,
                                                    enableButton: true,
                                                  )
                                                ],
                                              ),
                                            )
                                       ],
                                     )
                                    ),
                                      SizedBox(height: ScreenUtil().setHeight(120)),
                                   ]
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        );
                      } else {
                        return Center(
                            child: StreamBuilder(
                          stream: _presenter.tryButtonErrorObserve,
                          builder: (context,AsyncSnapshot<bool>snapshotTryButton) {
                            if (snapshotTryButton.data != null) {
                              if (snapshotTryButton.data!) {
                                return Padding(
                                    padding: EdgeInsets.only(
                                        right: ScreenUtil().setWidth(80),
                                        left: ScreenUtil().setWidth(80),
                                        top : ScreenUtil().setWidth(200),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        StreamBuilder(
                                          stream: _presenter.valueErrorObserve,
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
                                                _presenter.getSubscribtions(false,context);
                                              },
                                              enableButton: true,
                                              isLoading: false,
                                            )
                                        )
                                      ],
                                    )
                                );
                              } else {
                                return LoadingViewScreen(color: ColorPallet().mainColor);
                              }
                            } else {
                              return Container();
                            }
                          },
                        ));
                      }
                    } else {
                      return Container();
                    }
                  },
                ),
                StreamBuilder(
                  stream: _presenter.subscribeObserve,
                  builder: (context,AsyncSnapshot<SubscribesGetModel>snapshotSubscribe){
                    if(snapshotSubscribe.data != null){
                      if(snapshotSubscribe.data!.showCloseButton){
                        return Align(
                          alignment: Alignment.topRight,
                          child: StreamBuilder(
                            stream: animations.squareScaleBackButtonObserve,
                            builder: (context,AsyncSnapshot<double>snapshotScale){
                              if(snapshotScale.data != null){
                                return Transform.scale(
                                  scale:  modePress == 0 ? snapshotScale.data : 1,
                                  child: GestureDetector(
                                      onTap: ()async{
                                        AnalyticsHelper().log(AnalyticsEvents.ChooseSubscriptionPg_Close_Icon_Clk);
                                        setState(() {
                                          modePress =0;
                                        });
                                        await animationControllerScaleButton.reverse();
                                        if(widget.isSub!){
                                          Navigator.pop(context);
                                        }else{
                                          Navigator.pushReplacement(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child:  SplashScreen(
                                                    localPass: false,
                                                    index: 4,
                                                  )
                                              )
                                          );
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: ScreenUtil().setWidth(60),
                                            right: ScreenUtil().setWidth(30)
                                        ),
                                        width: ScreenUtil().setWidth(80),
                                        height: ScreenUtil().setWidth(80),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color(0xff989898).withOpacity(0.3),
                                                  blurRadius: 10.0
                                              )
                                            ]
                                        ),
                                        child: Center(
                                            child: Icon(
                                              Icons.close,
                                              color: ColorPallet().gray,
                                            )
                                        ),
                                      )
                                  ),
                                );
                              }else{
                                return Container();
                              }
                            },
                          ),
                        );
                      }else{
                        return Container();
                      }
                    }else{
                      return Container();
                    }
                  },
                ),
                !widget.isSub! ?
                Align(
                  alignment: Alignment.topLeft,
                  child: StreamBuilder(
                    stream: animations.squareScaleBackButtonObserve,
                    builder: (context,AsyncSnapshot<double>snapshotScale){
                      if(snapshotScale.data != null){
                        return Transform.scale(
                          scale:  modePress == 1 ? snapshotScale.data : 1,
                          child: GestureDetector(
                              onTap: ()async{
                                AnalyticsHelper().log(AnalyticsEvents.ChooseSubscriptionPg_Profile_Icon_Clk);
                                setState(() {
                                  modePress = 1;
                                });
                                await animationControllerScaleButton.reverse();
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        duration: Duration(milliseconds: 500),
                                        child:  FeatureDiscovery(
                                            recordStepsInSharedPreferences: true,
                                            child: ProfileScreen()
                                        )
                                    )
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(80),
                                    left: ScreenUtil().setWidth(30)
                                ),
                                width: ScreenUtil().setWidth(80),
                                height: ScreenUtil().setWidth(80),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xff989898).withOpacity(0.3),
                                          blurRadius: 10.0
                                      )
                                    ]
                                ),
                                child: Center(
                                    child: SvgPicture.asset(
                                      'assets/images/ic_name.svg',
                                      width: ScreenUtil().setWidth(45),
                                      height: ScreenUtil().setWidth(45),
                                      colorFilter: ColorFilter.mode(
                                          ColorPallet().mainColor,
                                        BlendMode.srcIn
                                      ),
                                    )
                                ),
                              )
                          ),
                        );
                      }else{
                        return Container();
                      }
                    },
                  ),
                )
                    : SizedBox.shrink(),
                StreamBuilder(
                  stream: _presenter.isLoadingObserve,
                  builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                    if(snapshotIsLoading.data != null){
                      if(!snapshotIsLoading.data!){
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: Colors.white,
                            height: ScreenUtil().setWidth(115),
                            padding: EdgeInsets.only(
                                bottom: ScreenUtil().setWidth(20),
                                top: ScreenUtil().setWidth(10)
                            ),
                            child: StreamBuilder(
                              stream: _presenter.subscribtionsPackagesSelectedObserve,
                              builder: (context,AsyncSnapshot<SubscribtionsPackagesModel>snapshotSelectedSub){
                                if(snapshotSelectedSub.data != null){
                                  return CustomButton(
                                    title: snapshotSelectedSub.data!.payButtonText,
                                    onPress: () async {
                                      if(snapshotSelectedSub.data!.isFree){
                                        _presenter.pressFreeSub(context,snapshotSelectedSub.data!.id);
                                      }else{
                                        AnalyticsHelper().log(
                                            AnalyticsEvents.ChooseSubscriptionPg_PaySub_Item_Clk,
                                            parameters: {
                                              'id' : snapshotSelectedSub.data!.id
                                            }
                                        );
                                        if(snapshotSelectedSub.data!.inAppPurchase){
                                           _presenter.payMyket((int.parse(snapshotSelectedSub.data!.id)+ 100).toString(), context);
                                          // if(await _presenter.isCafeBazar()){
                                          //   _presenter.payCafeBazar((int.parse(snapshotSelectedSub.data!.id)+ 100).toString(), context);
                                          // }else{
                                          //   _presenter.pressPackagesSub(context,snapshotSelectedSub.data!.id,snapshotSelectedSub.data!.totalPay);
                                          // }
                                        }else{
                                          _presenter.pressPackagesSub(context,snapshotSelectedSub.data!.id,snapshotSelectedSub.data!.totalPay);
                                        }
                                        // _presenter.pressPackagesSub(context,snapshotSelectedSub.data!.id,snapshotSelectedSub.data!.totalPay);
                                      }
                                    },
                                    margin: 160,
                                    colors: [ColorPallet().mainColor,ColorPallet().mainColor],
                                    borderRadius: 10.0,
                                    enableButton: true,
                                  );
                                }else{
                                  return Container();
                                }
                              },
                            ),
                          ),
                        );
                      }else{
                        return SizedBox.shrink();
                      }
                    }else{
                      return SizedBox.shrink();
                    }
                  },
                ),
                SlidingUpPanel(
                    controller: _presenter.panelController,
                    backdropEnabled: true,
                    minHeight: 0,
                    backdropColor: Colors.black,
                    padding: EdgeInsets.zero,
                    maxHeight: MediaQuery.of(context).size.height / 2.6,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)
                    ),
                    panel: SubOrganizationalWidget(subscribePresenter: _presenter)
                ),
                StreamBuilder(
                  stream: _presenter.isLoadingButtonObserve,
                  builder: (context,AsyncSnapshot<bool>snapshotIsLoadingButton) {
                    if (snapshotIsLoadingButton.data != null) {
                      if (snapshotIsLoadingButton.data!) {
                        return Container(
                          color: ColorPallet().gray.withOpacity(0.7),
                          child: Center(
                              child: Container(
                            padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: LoadingViewScreen(
                              color: ColorPallet().mainColor,
                            ),
                          )),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    } else {
                      return Container();
                    }
                  },
                ),
                StreamBuilder(
                  stream: exitAppDialog.isShowExitDialogObserve,
                  builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog) {
                    if (snapshotIsShowDialog.data != null) {
                      if (snapshotIsShowDialog.data!) {
                        return  QusDialog(
                          scaleAnim: exitAppDialog.dialogScaleObserve,
                          onPressCancel: (){
                            AnalyticsHelper().log(AnalyticsEvents.ChooseSubscriptionPg_ExitNoDlg_Btn_Clk);
                            exitAppDialog.cancelDialog();
                          },
                          value: '\nمطمئنی می‌خوای از ایمپو خارج بشی؟\n',
                          yesText: 'آره برمیگردم',
                          noText: 'نه',
                          onPressYes: () {
                            AnalyticsHelper().log(AnalyticsEvents.ChooseSubscriptionPg_ExitYesDlg_Btn_Clk);
                            exitAppDialog.acceptDialog(context);
                          },
                          isIcon: true,
                          colors: [
                            Colors.white,
                            Colors.white
                          ],
                          topIcon: 'assets/images/ic_box_question.svg',
                          isLoadingButton: false,
                        );
                      } else {
                        return  Container();
                      }
                    } else {
                      return  Container();
                    }
                  },
                ),
              ],
            ),
        ),
      ),
    );
  }

  Widget discountBox(){
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(30)
      ),
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: ScreenUtil().setWidth(90),
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(30),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12)
              ),
              child:  Row(
                children: [
                  SvgPicture.asset(
                      'assets/images/gift.svg'
                  ),
                  Flexible(
                    child: TextField(
                      autofocus: false,
                      // maxLength: 20,
                      controller: _presenter.discountController,
                      onChanged: (value){
                        if(value != ''){
                          setState(() {
                            enableDiscountButton = true;
                          });
                        }else{
                          setState(() {
                            enableDiscountButton = false;
                          });
                        }
                      },
                      enableInteractiveSelection: false,
                      style:  context.textTheme.bodySmall,
                      decoration:  InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        hintText: 'ثبت کد تخفیف',
                        hintStyle:  context.textTheme.bodySmall!.copyWith(
                          color: ColorPallet().gray.withOpacity(0.5),
                        ),
                        contentPadding:  EdgeInsets.only(
                          right: ScreenUtil().setWidth(20),
                          left: ScreenUtil().setWidth(10),
//                                          top: ScreenUtil().setWidth(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(15)),
          CustomButton(
            title: 'اعمال کد تخفیف',
            onPress: (){
              if(enableDiscountButton){
                _presenter.getSubscribtions(true,context);
              }
            },
            margin: 0,
            colors: enableDiscountButton ?
            [ColorPallet().mainColor,ColorPallet().mainColor] :
            [Colors.white,Colors.white],
            textColor: enableDiscountButton ? Colors.white : Color(0xffD1D1D1),
            borderRadius: 10.0,
            enableButton: true,
          )
        ],
      ),
    );
  }

  Future<bool> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
    // if (await canLaunch(httpUrl)) {
    //   await launch(httpUrl);
    // } else {
    //   throw 'Could not launch $httpUrl';
    // }
    return true;
  }


  @override
  void onError(msg) {}

  @override
  void onSuccess(value) {}
}
