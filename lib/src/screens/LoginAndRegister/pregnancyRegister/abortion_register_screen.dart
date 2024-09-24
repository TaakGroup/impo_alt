import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/register_presenter.dart';
import 'package:impo/src/architecture/view/register_view.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/bottom_text_register.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/LoginAndRegister/identity/set_password_screen.dart';

import '../../../firebase_analytics_helper.dart';


class AbortionRegisterScreen extends StatefulWidget {
  final phoneOrEmail;/// if this null ==> fromChangeStatus
  const AbortionRegisterScreen({Key? key, this.phoneOrEmail,}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AbortionRegisterScreenState();
}

class AbortionRegisterScreenState extends State<AbortionRegisterScreen> with TickerProviderStateMixin implements RegisterView {

  late RegisterPresenter _presenter;

  AbortionRegisterScreenState(){
    _presenter = RegisterPresenter(this);
  }

  Animations _animations =  Animations();

  List<String> yesOrNo = ["داشتم", "نداشتم"];

  int indexDays = 1;

  var registerInfo = locator<RegisterParamModel>();

  String getName(){
    return registerInfo.register.name!;
  }

  @override
  void initState() {
    _animations.shakeError(this);
    super.initState();
  }

  @override
  void dispose() {
    _animations.animationControllerShakeError.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.AbortionRegPg_Back_NavBar_Clk);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.phoneOrEmail == null ?
                      CustomAppBar(
                        messages: false,
                        profileTab: true,
                        icon: 'assets/images/ic_arrow_back.svg',
                        titleProfileTab: 'صفحه قبل',
                        subTitleProfileTab: 'صفحه اصلی',
                        onPressBack: () {
                          AnalyticsHelper().log(AnalyticsEvents.AbortionRegPg_Back_Btn_Clk);
                          Navigator.pop(context);
                        },
                      ) : Container(),
                      widget.phoneOrEmail != null ?
                      Container(
                        margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(120),
                            bottom: ScreenUtil().setWidth(80)
                        ),
                        height: ScreenUtil().setWidth(180),
                        width: ScreenUtil().setWidth(180),
                        child:  Image.asset(
                          'assets/images/file.png',
                          fit: BoxFit.cover,
                        ),
                      ) : Container(
                        width: ScreenUtil().setWidth(80),
                        height: ScreenUtil().setWidth(80),),
                      Padding(
                        padding:
                        EdgeInsets.only(bottom: ScreenUtil().setWidth(100)),
                        child: Text(
                          '${getName()} جان آیا تا بحال سابقه سقط داشتی؟',
                          textAlign: TextAlign.center,
                            style: context.textTheme.labelLarge
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(100)),
                      Container(
                          alignment: Alignment.center,
                          height: ScreenUtil().setWidth(220),
                          child: Center(
                              child: NotificationListener<
                                  OverscrollIndicatorNotification>(
                                  onNotification: (overscroll) {
                                    overscroll.disallowIndicator();
                                    return true;
                                  },
                                  child: Theme(
                                    data: ThemeData(
                                        cupertinoOverrideTheme:
                                        CupertinoThemeData(
                                            textTheme: CupertinoTextThemeData(
                                              pickerTextStyle: TextStyle(
                                                  color: ColorPallet().mainColor),
                                            ))),
                                    child: CupertinoPicker(
                                        scrollController:
                                        FixedExtentScrollController(
                                            initialItem: 1),
                                        itemExtent: ScreenUtil().setWidth(110),
                                        onSelectedItemChanged: (index) {
                                          setState(() {
                                            indexDays = index;
                                          });
                                        },
                                        children: List.generate(yesOrNo.length,
                                                (index) {
                                              return Center(
                                                child: Text(
                                                  yesOrNo[index],
                                                    style:  context.textTheme.bodyLarge!.copyWith(
                                                        color: ColorPallet().mainColor
                                                    )
                                                ),
                                              );
                                            })),
                                  )
                              )
                          )
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child:  Padding(
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setWidth(15)
                          ),
                          child: AnimatedBuilder(
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
                                                  margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(65)),
                                                  padding: EdgeInsets.only(left: _animations.animationShakeError.value + 4.0, right: 4.0 -_animations.animationShakeError.value),
                                                  child: Text(
                                                    snapshot.data != null ? snapshot.data! : '',
                                                    style:  TextStyle(
                                                        color: Color(0xffEE5858),
                                                        fontSize: ScreenUtil().setWidth(28),
                                                        fontWeight: FontWeight.w400
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
                      ),
                      Align(
                        child: Padding(
                          padding: EdgeInsets.only(top: ScreenUtil().setWidth(80)),
                          child: StreamBuilder(
                            stream: _presenter.isLoadingObserve,
                            builder: (context,snapshotIsLoading){
                              if(snapshotIsLoading.data != null){
                                return  CustomButton(
                                  title: 'ادامه',
                                  onPress: accept,
                                  colors: [
                                    ColorPallet().mentalHigh,
                                    ColorPallet().mentalMain
                                  ],
                                  borderRadius: 10.0,
                                  enableButton: true,
                                  isLoadingButton: snapshotIsLoading.data,
                                );
                              }else{
                                return Container();
                              }
                            },
                          )
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            bottomNavigationBar: widget.phoneOrEmail != null ?
            Padding(
              padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
              child: BottomTextRegister(),
            ) : Container(width: 0,height: 0)
        ),
      ),
    );
  }

  accept(){
    int typeAbortion = 0;

    if(yesOrNo[indexDays] == 'داشتم') typeAbortion = 1;

    if(yesOrNo[indexDays] == 'نداشتم') typeAbortion= 2;

    registerInfo.setHasAboration(typeAbortion);

    AnalyticsHelper().log(AnalyticsEvents.AbortionRegPg_Cont_Btn_Clk);
    if(widget.phoneOrEmail != null){
      Navigator.push(context,
        PageRouteBuilder(
          transitionDuration: Duration(seconds: 2),
          pageBuilder: (_, __, ___) => SetPasswordScreen(
            isRegister: true,
            phoneOrEmail: widget.phoneOrEmail,
            onlyLogin: false,
          ),
        ),
      );
    }else{
      _presenter.requestChangeStatus(2,_animations,context,false);
    }
  }

  @override
  void onError(msg){
  }

  @override
  void onSuccess(value) {
  }

  // int enterType(String selectedCircleDay) {
  //   if (selectedCircleDay == 'دارم')
  //     widget.registerParametersModel['typeSex'] = 1;
  //
  //   if (selectedCircleDay == 'ندارم')
  //     widget.registerParametersModel['typeSex'] = 0;
  // }

}
