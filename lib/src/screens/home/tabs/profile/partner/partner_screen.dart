
import 'package:clipboard/clipboard.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/partner_tab_presenter.dart';
import 'package:impo/src/architecture/presenter/partner_presenter.dart';
import 'package:impo/src/architecture/view/partner_view.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/dialogs/qus_dialog.dart';
import 'package:impo/src/components/expert_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:impo/src/components/text_field_area.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/widgets/snackbar/custom_snack_bar.dart';
import 'package:impo/src/models/partner/partner_model.dart';
import 'package:impo/src/screens/home/tabs/profile/partner/change_distance_screen.dart';
import 'package:impo/src/screens/home/home.dart';
import 'package:impo/src/screens/home/tabs/profile/profile_sceen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:impo/src/singleton/payload.dart';
import '../../../../../firebase_analytics_helper.dart';
import '../../../../../models/partner/partner_code_model.dart';

class PartnerScreen extends StatefulWidget{
  final PartnerTabPresenter? partnerTabPresenter;

  PartnerScreen({Key? key,this.partnerTabPresenter}):super(key:key);

  @override
  State<StatefulWidget> createState() => PartnerScreenState();
}

class PartnerScreenState extends State<PartnerScreen> with TickerProviderStateMixin implements PartnerView{

  late PartnerPresenter _presenter;
  Animations _animations =  Animations();
  late AnimationController _animationController;
  int modePress = 0;

  PartnerScreenState(){
    _presenter = PartnerPresenter(this);
  }

  @override
  void initState() {
    Payload.getGlobal().setPayload('');
    _presenter.getPair(context);
    _animationController = _animations.pressButton(this);
    _presenter.initialDialogScale(this);
    _presenter.partnerCodeSharePanelController = PanelController();
    /// FirebaseMessaging.onMessage.listen((event) {
    ///   debugPrint("onMessage: ${event.data}");
    ///   if(event.data['type'] != null){
    ///     if(event.data['type'] == '40'){
    ///       _presenter.getPair(context);
    ///     }
    ///   }
    /// });
    super.initState();
    /// WidgetsBinding.instance.addObserver(this);
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.PartnerPg_Back_NavBar_Clk);
    /// _presenter.cancelTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.partnerTabPresenter != null ?
      Navigator.pushReplacement(context,
          PageTransition(
              settings: RouteSettings(name: "/Page1"),
              type: PageTransitionType.topToBottom,
              child:  FeatureDiscovery(
                  recordStepsInSharedPreferences: true,
                  child: Home(
                    indexTab: 2,
                    register: true,
                    isChangeStatus: false,
                  )
              )
          )
      )
      : Navigator.pushReplacement(
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
    });
    return Future.value(false);
  }


  /// @override
  /// void didChangeAppLifecycleState(AppLifecycleState state) {
  ///   if(state == AppLifecycleState.paused){
  ///     /// _presenter.cancelTimer();
  ///   }else if(state == AppLifecycleState.resumed){
  ///     _presenter.getPair(context);
  ///   }
  /// }

  @override
  void dispose() {
    _animationController.dispose();
    /// WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = 0.5;
    return  WillPopScope(
      onWillPop: _onWillPop,
      child:  Directionality(
        textDirection: TextDirection.rtl,
        child:  Scaffold(
          backgroundColor: Colors.white,
          body:  Stack(
            children: <Widget>[
               SingleChildScrollView(
                child:  Column(
                  children: <Widget>[
                     CustomAppBar(
                      messages: false,
                      profileTab: true,
                       isEmptyLeftIcon: true,
                      icon: 'assets/images/ic_arrow_back.svg',
                      titleProfileTab: 'صفحه قبل',
                      subTitleProfileTab: 'همدل من',
                      onPressBack: (){
                        AnalyticsHelper().log(AnalyticsEvents.PartnerPg_Back_Btn_Clk);
                        _onWillPop();
                      },
                    ),
                     StreamBuilder(
                      stream: _presenter.isLoadingObserve,
                      builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                        if(snapshotIsLoading.data != null){
                          if(!snapshotIsLoading.data!){
                            return  StreamBuilder(
                              stream: _presenter.partnerDetailObserve,
                              builder: (context,AsyncSnapshot<PartnerViewModel>snapshotPartnerDetail){
                                if(snapshotPartnerDetail.data != null){
                                  if(!snapshotPartnerDetail.data!.isPair){
                                    return notPartner();
                                  }else{
                                    return exitPartner(snapshotPartnerDetail.data!);
                                  }
                                }else{
                                  return  Container();
                                }
                              },
                            );
                          }else{
                            return   Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height / 2.7
                              ),
                                child:  StreamBuilder(
                                  stream: _presenter.tryButtonErrorObserve,
                                  builder: (context,AsyncSnapshot<bool>snapshotTryButton){
                                    if(snapshotTryButton.data != null){
                                      if(snapshotTryButton.data!){
                                        return  Padding(
                                            padding: EdgeInsets.only(
                                                right: ScreenUtil().setWidth(80),
                                                left: ScreenUtil().setWidth(80),
                                                top: ScreenUtil().setWidth(200)
                                            ),
                                            child:  Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                 StreamBuilder(
                                                  stream: _presenter.valueErrorObserve,
                                                  builder: (context,AsyncSnapshot<String>snapshotValueError){
                                                    if(snapshotValueError.data != null){
                                                      return   Text(
                                                        snapshotValueError.data!,
                                                        textAlign: TextAlign.center,
                                                          style:  context.textTheme.bodyMedium!.copyWith(
                                                            color: Color(0xff707070),
                                                          )
                                                      );
                                                    }else{
                                                      return  Container();
                                                    }
                                                  },
                                                ),
                                                 Padding(
                                                    padding: EdgeInsets.only(
                                                        top: ScreenUtil().setWidth(32)
                                                    ),
                                                    child:    ExpertButton(
                                                      title: 'تلاش مجدد',
                                                      onPress: (){
                                                        _presenter.getPair(context);
                                                      },
                                                      enableButton: true,
                                                      isLoading: false,
                                                    )
                                                )
                                              ],
                                            )
                                        );
                                      }else{
                                        return  Center(
                                            child:   LoadingViewScreen(
                                                color: ColorPallet().mainColor
                                            )
                                        );
                                      }
                                    }else{
                                      return  Container();
                                    }
                                  },
                                )
                            );
                          }
                        }else{
                          return  Container();
                        }
                      },
                    ),
                  ],
                ),
              ),
               StreamBuilder(
                stream: _presenter.isShowExitDialogObserve,
                builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog) {
                  if (snapshotIsShowDialog.data != null) {
                    if (snapshotIsShowDialog.data!) {
                      return  StreamBuilder(
                        stream: _presenter.isLoadingButtonObserve,
                        builder: (context,snapshotIsLoadingButton){
                          if(snapshotIsLoadingButton.data != null){
                            return   QusDialog(
                              scaleAnim: _presenter.dialogScaleObserve,
                              onPressCancel: (){
                                AnalyticsHelper().log(AnalyticsEvents.PartnerPg_RemovePartnerNoDlg_Btn_Clk);
                                _presenter.cancelDialog();
                              },
                              value: 'ایمپویی عزیز\nآیا مطمئنی که می‌خوای همدلتو\nحذف کنی؟',
                              yesText: 'بله مطمئنم',
                              noText: 'نه',
                              onPressYes: () {
                                AnalyticsHelper().log(AnalyticsEvents.PartnerPg_RemovePartnerYesDlg_Btn_Clk);
                                _presenter.unPair(context);
                              },
                              isIcon: true,
                              colors: [
                                Colors.white,
                                Colors.white
                              ],
                              topIcon: 'assets/images/ic_box_question.svg',
                              isLoadingButton: snapshotIsLoadingButton.data,
                            );
                          }else{
                            return  Container();
                          }
                        },
                      );
                    } else {
                      return  Container();
                    }
                  } else {
                    return  Container();
                  }
                },
              ),
               SlidingUpPanel(
                controller: _presenter.partnerCodeSharePanelController,
                backdropEnabled: true,
                minHeight: 0,
                backdropColor: Colors.black,
                maxHeight: MediaQuery.of(context).size.height /3.25,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)
                ),
                panel:  Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(15)
                      ),
                      height: ScreenUtil().setWidth(5),
                      width: ScreenUtil().setWidth(100),
                      decoration:  BoxDecoration(
                          color: Color(0xff707070).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15)
                      ),
                    ),
                    Flexible(
                        child: shareText()
                    ),
                  ],
                ),
              ),
            ],
          )
        ),
      )
    );
  }

  Widget notPartner(){
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: _presenter.partnerCodeObserve,
        builder: (context,AsyncSnapshot<PartnerCodeModel>snapshotPartnerCode){
          if(snapshotPartnerCode.data != null){
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(30)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ScreenUtil().setWidth(30)),
                  Text(
                    'شماره موبایل یا ایمیل پارتنرت یا کدی که برات فرستاده رو اینجا وارد کن و بقیه کارها رو به ما بسپار',
                    style: context.textTheme.labelMedium
                  ),
                  Container(
                      height: ScreenUtil().setWidth(80),
                      margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(30),
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
                              enableInteractiveSelection: false,
                              style:  context.textTheme.labelMedium,
                              onChanged: (String value){
                                _presenter.onChangedInputCode(value);
                              },
                              decoration:  InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                hintText: 'اینجا تایپ کن...',
                                hintStyle: context.textTheme.labelSmall!.copyWith(
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
                  SizedBox(height: ScreenUtil().setWidth(50)),
                  StreamBuilder(
                    stream: _presenter.isLoadingButtonObserve,
                    builder: (context,snapshotIsLoadingButton){
                      if(snapshotIsLoadingButton.data != null){
                        return StreamBuilder(
                          stream: _presenter.codeOrPhoneOrEmailObserve,
                          builder: (context,AsyncSnapshot<String>snapshotCodeOrPhoneOrEmail){
                            if(snapshotCodeOrPhoneOrEmail.data != null){
                              return CustomButton(
                                onPress: ()  {
                                  if(snapshotCodeOrPhoneOrEmail.data!.length != 0){
                                    AnalyticsHelper().log(AnalyticsEvents.PartnerPg_CreatePartner_Btn_Clk);
                                    _presenter.createPartner(context);
                                  }
                                },
                                title: 'تایید',
                                margin: 220,
                                height: ScreenUtil().setWidth(75),
                                colors: [ColorPallet().mainColor, ColorPallet().mainColor],
                                borderRadius: 20.0,
                                isLoadingButton: snapshotIsLoadingButton.data,
                                enableButton: snapshotCodeOrPhoneOrEmail.data!.length != 0 ? true : false,
                              );
                            }else{
                              return Container();
                            }
                          },
                        );
                      }else{
                        return Container();
                      }
                    },
                  ),
                  SizedBox(height: ScreenUtil().setWidth(60)),
                  SvgPicture.asset(
                    'assets/images/or_separated.svg',
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(height: ScreenUtil().setWidth(60)),
                  Text(
                    'کد اختصاصی خودت رو برای پارتنرت بفرستی',
                    style: context.textTheme.labelMedium,
                  ),
                  SizedBox(height: ScreenUtil().setWidth(50)),
                  CustomButton(
                    onPress: ()  {
                      _presenter.partnerCodeSharePanelController.open();
                    },
                    margin: 100,
                    height: ScreenUtil().setWidth(75),
                    colors: [Colors.white,Colors.white],
                    borderColor: Color(0xff000000).withOpacity(0.09),
                    borderRadius: 20.0,
                    enableButton: true,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            color: ColorPallet().mainColor,
                            size: ScreenUtil().setWidth(35),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(5)),
                          Text(
                            'استفاده از کد اختصاصی',
                            textAlign: TextAlign.center,
                            style: context.textTheme.labelLarge!.copyWith(
                              color:  ColorPallet().mainColor,
                            ),
                          ),
                        ]
                    ),
                  ),
                ],
              ),
            );
          }else{
            return Container();
          }
        },
      ),
    );
  }

  Widget shareText(){
    return StreamBuilder(
      stream: _presenter.partnerCodeObserve,
      builder: (context,AsyncSnapshot<PartnerCodeModel>snapshotPartnerCode){
        if(snapshotPartnerCode.data != null){
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(30)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ScreenUtil().setWidth(30)),
                Text(
                  'کد اختصاصی زیر رو برای پارتنرت بفرست',
                  style: context.textTheme.labelMedium,
                ),
                SizedBox(height: ScreenUtil().setWidth(20)),
                Container(
                  // width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setWidth(20),
                        horizontal: ScreenUtil().setWidth(20)
                    ),
                    decoration:  BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                          color: Color(0xff909090).withOpacity(0.2)
                      ),
                    ),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        StreamBuilder(
                          stream: _presenter.isLoadingRefreshIconObserve,
                          builder: (context,AsyncSnapshot<bool>snapshotIsLoadingRefreshIcon){
                            if(snapshotIsLoadingRefreshIcon.data != null){
                              if(!snapshotIsLoadingRefreshIcon.data!){
                                return GestureDetector(
                                  onTap: (){
                                    AnalyticsHelper().log(AnalyticsEvents.PartnerPg_RefreshCode_Btn_Clk);
                                    _presenter.partnerCodeRequest(true,context);
                                  },
                                  child: Container(
                                      width: ScreenUtil().setWidth(40),
                                      height: ScreenUtil().setWidth(40),
                                      child:  SvgPicture.asset(
                                        'assets/images/ic_refresh.svg',
                                        fit: BoxFit.fitHeight,
                                      )
                                  ),
                                );
                              }else{
                                return LoadingViewScreen(
                                  color: Color(0xffB8B8B8),
                                  width: ScreenUtil().setWidth(30),
                                  lineWidth: ScreenUtil().setWidth(3.5),
                                );
                              }
                            }else{
                              return Container();
                            }
                          },
                        ),
                        Row(
                          children: [
                            Text(
                              snapshotPartnerCode.data!.code,
                              textDirection: TextDirection.ltr,
                              style:  context.textTheme.labelMedium!.copyWith(
                                color: ColorPallet().mainColor,
                              ),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(10)),
                            GestureDetector(
                              onTap: (){
                                AnalyticsHelper().log(AnalyticsEvents.PartnerPg_CopyCode_Icon_Clk);
                                copyToClipBoard(snapshotPartnerCode.data!.code);
                              },
                              child: Container(
                                  width: ScreenUtil().setWidth(40),
                                  height: ScreenUtil().setWidth(40),
                                  child:    Image.asset(
                                    'assets/images/ic_copy.png',
                                    fit: BoxFit.fitHeight,
                                    color: ColorPallet().mainColor,
                                  )
                              ),
                            )
                          ],
                        )
                      ],
                    )
                ),
                SizedBox(height: ScreenUtil().setWidth(50)),
                CustomButton(
                  onPress: ()  {
                    AnalyticsHelper().log(AnalyticsEvents.PartnerPg_ShareCode_Btn_Clk);
                    shareEnterFaceCode(snapshotPartnerCode.data!.shareText.toString());
                  },
                  margin: 100,
                  height: ScreenUtil().setWidth(75),
                  colors: [ColorPallet().mainColor, ColorPallet().mainColor],
                  borderRadius: 20.0,
                  enableButton: true,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.share_outlined,
                          color: Colors.white,
                          size: ScreenUtil().setWidth(35),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(5)),
                        Text(
                          'اشتراک گذاری کد با همدل',
                          textAlign: TextAlign.center,
                          style: context.textTheme.labelLarge!.copyWith(
                            color:  Colors.white,
                          ),
                        ),
                      ]
                  ),
                ),
              ],
            ),
          );
        }else{
          return Container();
        }
      },
    );
  }


  Widget exitPartner(PartnerViewModel value){
    return  Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(20)
          ),
          child: Align(
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(320),
                  ),
                  child: SvgPicture.asset(
                    'assets/images/ic_big_partner.svg',
                    width: ScreenUtil().setWidth(200),
                    height: ScreenUtil().setWidth(200),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: ScreenUtil().setWidth(20),
                  ),
                  child: Text(
                    'همدل من',
                    style: context.textTheme.headlineSmall!.copyWith(
                      color: ColorPallet().gray,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
         SizedBox(height: ScreenUtil().setHeight(50)),
         Text(
          'ایمپویی عزیز\nاطلاعات همدل شما در کادر زیر نمایش داده\nشده است',
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium!.copyWith(
            color: ColorPallet().gray,
          ),
        ),
         SizedBox(height: ScreenUtil().setHeight(50)),
         Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(5)),
            child: TextFieldArea(
              notFlex: true,
              label: 'نوع رابطه',
              textController: _presenter.distanceTypeController,
              readOnly: true,
              editBox: true,
              onPressEdit: (){
                AnalyticsHelper().log(AnalyticsEvents.PartnerPg_EditDistance_Btn_Clk);
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 500),
                        child: ChangeDistanceScreen(
                          distanceType: value.distanceType,
                          presenter: _presenter,
                          isEdit: true,
                        )
                    )
                );
              },
              bottomMargin: 60,
              topMargin: 0,
              obscureText: false,
              keyboardType: TextInputType.text,
            ),
        ),
         Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width - ScreenUtil().setWidth(110),
              // height: MediaQuery.of(context).size.height/8,
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(28),
                right: ScreenUtil().setWidth(28),
              ),
              decoration:  BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient:  LinearGradient(
                      colors: [
                        ColorPallet().mentalMain,
                        ColorPallet().mentalHigh,
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft
                  )
              ),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(height: ScreenUtil().setWidth(16)),
                  Text(
                    '${value.manName}',
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: ScreenUtil().setWidth(20),
                        top: ScreenUtil().setWidth(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/images/ic_small_partner.svg',
                          width: ScreenUtil().setWidth(50),
                          height: ScreenUtil().setWidth(50),
                          colorFilter: ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn
                          ),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(15)),
                        Text(
                          '${value.createTime}',
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height/8,
                width: MediaQuery.of(context).size.width - ScreenUtil().setWidth(110),
                decoration:  BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.transparent
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset(
                        'assets/images/ic_top_partner.svg',
                        width: ScreenUtil().setWidth(120),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child:   SvgPicture.asset(
                        'assets/images/ic_bottom_partner.svg',
                        width: ScreenUtil().setWidth(60),
                      ),
                    )
                  ],
                )
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child:  StreamBuilder(
                stream: _animations.squareScaleBackButtonObserve,
                builder: (context,AsyncSnapshot<double>snapshotScale){
                  if(snapshotScale.data != null){
                    return  Transform.scale(
                      scale: snapshotScale.data,
                      child:  GestureDetector(
                        onTap: ()async{
                          await _animationController.reverse();
                          AnalyticsHelper().log(AnalyticsEvents.PartnerPg_RemovePartner_Btn_Clk);
                          _presenter.onPressShowDialog();
                        },
                        child:  Container(
                          width: MediaQuery.of(context).size.width/3,
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(70),
                              top: ScreenUtil().setWidth(50)
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setWidth(7),
                              horizontal: ScreenUtil().setWidth(30)
                          ),
                          decoration:  BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child:  Center(
                            child:  Text(
                              'حذف همدل',
                              style: context.textTheme.labelLarge!.copyWith(
                                color: Color(0xff707070),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }else{
                    return  Container();
                  }
                },
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget customLine(Alignment wrap){
    return  Stack(
      alignment: wrap,
      children: <Widget>[
         Container(
          height: ScreenUtil().setWidth(3),
          width: MediaQuery.of(context).size.width/2 - ScreenUtil().setWidth(85),
          color: ColorPallet().gray.withOpacity(0.4),
        ),
         Container(
          height: ScreenUtil().setWidth(10),
          width:  ScreenUtil().setWidth(10),
          decoration:  BoxDecoration(
            shape: BoxShape.circle,
            color: ColorPallet().gray,
          ),
        )
      ],
    );
  }

  copyToClipBoard(token)async{
    FlutterClipboard.copy(token).then(( value ) {
      //Fluttertoast.showToast(msg:'کد کپی شد',toastLength: Toast.LENGTH_LONG);
      CustomSnackBar.show(context, 'کد کپی شد');
    });
  }

  shareEnterFaceCode(String token){
    Share.share(token);
  }

  @override
  void onError(msg) {
  }

  @override
  void onSuccess(msg){
  }

}