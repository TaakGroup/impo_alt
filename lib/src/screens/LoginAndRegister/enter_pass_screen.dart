


import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/dialogs/check_version_dialog.dart';
import 'package:impo/src/components/dialogs/qus_dialog.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/register/enter_pass_model.dart';
import 'package:impo/src/models/profile/item_profile_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/home/home.dart';
import 'package:impo/src/screens/offlineMode/offline_dashboard_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/password_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_shadow/simple_shadow.dart';

class EnterPassScreen extends StatefulWidget{

  final splash;
  final offlineModel;

  EnterPassScreen({Key? key,this.splash,this.offlineModel}):super(key:key);

  @override
  State<StatefulWidget> createState() => EnterPassScreenState();
}

class EnterPassScreenState extends State<EnterPassScreen> with TickerProviderStateMixin{

  late AnimationController animationControllerScaleButtons;


  Animations _animations =  Animations();

  late TextEditingController numberController;

  List<String> n = [];

  final LocalAuthentication auth = LocalAuthentication();

//  CheckVersionDialog checkVersionDialog =  CheckVersionDialog();

  @override
  void initState() {
    animationControllerScaleButtons = _animations.pressButton(this);
    _animations.shakeError(this);
    numberController = TextEditingController();
    if(widget.splash)     checkFingerPrint();
//    checkVersionDialog.initialDialogScale(this);
//    if(widget.splash) checkVersionDialog.checkVersion();
    super.initState();
  }

  checkFingerPrint()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('fingerPrint') != null){
      if(prefs.getBool('fingerPrint')!){
        _authenticate();
      }
    }
  }

  Future<void> _authenticate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool womansubscribtion =  prefs.getBool('womansubscribtion')!;
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          localizedReason: 'اثر انگشت خود را اسکن کنید تا احراز هویت شود',
          options: AuthenticationOptions(
              useErrorDialogs: true,
              stickyAuth: true
          ),
      );
      if(authenticated){
        if(widget.splash){
          if(widget.offlineModel){
            Navigator.pushReplacement(
                context,
                PageTransition(
                    settings: RouteSettings(name: "/Page1"),
                    type: PageTransitionType.fade,
                    duration: Duration(seconds: 1),
                    child:  OfflineDashboardScreen()
                )
            );
          }else{
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    settings: RouteSettings(name: "/Page1"),
                    builder: (context) =>  FeatureDiscovery(
                        recordStepsInSharedPreferences: true,
                        child: Home(
                          indexTab: 4,
                          isChangeStatus: false,
                          womansubscribtion: womansubscribtion,
                          // isLogin: false,
                          // checkMessageNotRead: true,
                        )
                    )
                )
            );
          }
        }else{

          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                  child:  PasswordScreen()
              )
          );

        }
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    if (!mounted) return;

    // final String message = authenticated ? 'Authorized' : 'Not Authorized';
    // print(authenticated);
//    setState(() {
//      _authorized = message;
//    });
  }


  @override
  void dispose() {
    animationControllerScaleButtons.dispose();
//    checkVersionDialog.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = 0.5;
    return  Directionality(
      textDirection: TextDirection.ltr,
      child:  Scaffold(
        backgroundColor: Colors.white,
        body:  Padding(
          padding: EdgeInsets.only(top: ScreenUtil().setWidth(100)),
          child:  Column(
            children: <Widget>[
              Expanded(
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(270),
                            ),
                            child: SvgPicture.asset(
                              'assets/images/ic_big_pass.svg',
                              width: ScreenUtil().setWidth(185),
                              height: ScreenUtil().setWidth(185),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: ScreenUtil().setWidth(10),
                            ),
                            child: Text(
                              'رمز قفل',
                              style:  context.textTheme.headlineSmall!.copyWith(
                                color: ColorPallet().gray,
                              )
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(
                          top: ScreenUtil().setWidth(15)
                      ),
                      child: Text(
                        'ایمپویی عزیز، رمز قفل را ثبت کنید',
                        style:  context.textTheme.bodyMedium!.copyWith(
                          color: ColorPallet().gray
                        )
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width/3
                        ),
                        child:  Theme(
                          data: Theme.of(context).copyWith(
                            textSelectionTheme: TextSelectionThemeData(
                                selectionColor: Color(0xffaaaaaa),
                                cursorColor: ColorPallet().mainColor
                            ),
                          ),
                          child:  TextField(
                            controller: numberController,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.center,
                            cursorColor: ColorPallet().mainColor,
                            style:  context.textTheme.headlineLarge!.copyWith(
                              color: ColorPallet().mainColor,
                            ),
                            obscureText: true,
                            readOnly: true,
                            maxLength: 4,
                            decoration:  InputDecoration(
                              counterText: '',
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorPallet().mainColor,
                                      width: 2
                                  )
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorPallet().mainColor,
                                      width: 2
                                  )
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorPallet().mainColor,
                                      width: 2
                                  )
                              ),
                            ),
                          ),
                        )
                    ),
                    Align(
                      alignment: Alignment.center,
                      child:  Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setWidth(20)
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

                                                padding: EdgeInsets.only(left: _animations.animationShakeError.value + 4.0, right: 4.0 -_animations.animationShakeError.value),
                                                child: Text(
                                                  snapshot.data != null ? snapshot.data! : '',
                                                  style: context.textTheme.bodySmall!.copyWith(
                                                    color: Color(0xffEE5858),
                                                  )
                                                )
                                            );
                                          }
                                      );
                                    }else {
                                      return  Opacity(
                                        opacity: 0.0,
                                        child:  Container(
                                          child:  Text('رمز وارد شده صحیح نمیباشد'),
                                        ),
                                      );
                                    }
                                  }else{
                                    return  Opacity(
                                      opacity: 0.0,
                                      child:  Container(
                                        child:  Text('رمز وارد شده صحیح نمیباشد'),
                                      ),
                                    );
                                  }
                                },
                              );
                            }),
                      ),
                    ),
                    Expanded(
                        child:  Padding(
                          padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(120),
                            right: ScreenUtil().setWidth(120),
                            top: ScreenUtil().setWidth(40),
                          ),
                          child:   GridView.builder(
                            padding: EdgeInsets.zero,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,childAspectRatio: 1),
                            itemCount: numbers.length,
                            shrinkWrap: true,
                            itemBuilder: (context,index){
                              return  Center(
                                child:  StreamBuilder(
                                  stream: _animations.squareScaleBackButtonObserve,
                                  builder: (context,AsyncSnapshot<double>snapshotScale){
                                    if(snapshotScale.data != null){
                                      return  Transform.scale(
                                        scale: numbers[index].selected ? snapshotScale.data != null ? snapshotScale.data : 0.7 : 1.0,
                                        child:  GestureDetector(
                                            onTap: ()async{
                                              if(!animationControllerScaleButtons.isAnimating){
                                                animationControllerScaleButtons.reverse();
                                              }
                                              for(int i=0 ; i <numbers.length; i++){
                                                if(numbers[i].selected){
                                                  numbers[i].selected = false;
                                                }
                                              }

                                              numbers[index].selected = !numbers[index].selected;
                                              index == 11 ? onPressDec() :  onPressAdd(numbers[index].value.toString());
                                            },
                                            child: index == 9 ?
                                            Container()
                                                : index == 11 ?
                                            Center(
                                                child:   Padding(
                                                    padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(50)),
                                                    child: SimpleShadow(
                                                        color: Color(0xff5F9BDF),
                                                        opacity: 0.2,
                                                        sigma: 5.0,
                                                        offset: Offset(0,0),
                                                        child:  SvgPicture.asset(
                                                          'assets/images/delete_icon.svg',
                                                        )
                                                    )
                                                )
                                            )
                                                :  Container(
                                              margin: EdgeInsets.only(
                                                  top: ScreenUtil().setWidth(5),
                                                  bottom: ScreenUtil().setWidth(30)
                                              ),
                                              decoration:  BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Color(0xff5F9BDF).withOpacity(0.15),
                                                        blurRadius: 5.0
                                                    )
                                                  ],
                                                  color: Colors.white
                                              ),
                                              child:  Center(
                                                child:  Text(
                                                  numbers[index].value.toString(),
                                                  style:  TextStyle(
                                                      color: ColorPallet().mainColor,
                                                      fontSize: ScreenUtil().setSp(55),
                                                      fontWeight: FontWeight.w700
                                                  ),
                                                ),
                                              ),
                                            )
                                        ),
                                      );
                                    }else{
                                      return  Container();
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        )
                    )
                  ],
                ),
              )
            ],
          )
        )
      )
    );
  }

  onPressAdd(number){
    _animations.isErrorShow.sink.add(false);
    if(n.length < 4){
      setState(() {
        n.add(number);
        numberController.text = n.toString().replaceAll(',', '').replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '');
//        print(numberController.text);
      });
      if(n.length == 4){
        checkIncorrectPassword(numberController.text);
        n.clear();
        numberController.clear();
      }
    }
  }

  onPressDec(){
    if(n.length >0){
      setState(() {
        n.removeLast();
        numberController.text = n.toString().replaceAll(',', '').replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '');
      });
    }
  }

  checkIncorrectPassword(pass)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool womansubscribtion =  prefs.getBool('womansubscribtion')!;
    if(pass == prefs.getString('pass')){
      _animations.isErrorShow.sink.add(false);
      if(widget.splash){
        if(widget.offlineModel){
          Navigator.pushReplacement(
              context,
              PageTransition(
                  settings: RouteSettings(name: "/Page1"),
                  type: PageTransitionType.fade,
                  duration: Duration(seconds: 1),
                  child:  OfflineDashboardScreen()
              )
          );
        }else{
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  settings: RouteSettings(name: "/Page1"),
                  builder: (context) =>  FeatureDiscovery(
                      recordStepsInSharedPreferences: true,
                      child: Home(
                        indexTab: 4,
                        isChangeStatus: false,
                        womansubscribtion: womansubscribtion,
                        // isLogin: false,
                        // checkMessageNotRead: true,
                      )
                  )
              )
          );
        }
      }else{

        Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
              child:  PasswordScreen()
            )
        );

      }
    }else{
      _animations.showShakeError('رمز وارد شده صحیح نمیباشد');
    }
  }

}