
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/LoginAndRegister/breastfeedingRegister/pregnancy_date_register_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import '../../../../firebase_analytics_helper.dart';
import '../../../LoginAndRegister/pregnancyRegister/bardari_register_screen.dart';

class ChangeStatusScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ChangeStatusScreenState();
}

class ChangeStatusScreenState extends State<ChangeStatusScreen> with TickerProviderStateMixin{

  final assetsAudioPlayer = AssetsAudioPlayer();
  int? status;
  Animations _animations =  Animations();
  late AnimationController animationControllerScaleButton;
  int modePress = 0;



  @override
  void initState() {
    if(status == 1){
      AnalyticsHelper().log(AnalyticsEvents.ChangeStatusPgPeriod_Self_Pg_Load);
    }else{
      AnalyticsHelper().log(AnalyticsEvents.ChangeStatusPgPregnancy_Self_Pg_Load);
    }
    animationControllerScaleButton = _animations.pressButton(this);
    getStatus();
    playMusic();
    super.initState();
  }


  var registerInfo = locator<RegisterParamModel>();
  getStatus(){
    status = registerInfo.register.status!;
  }

  playMusic()async{
    assetsAudioPlayer.open(
      Audio(status == 1 ? "assets/musics/bardari.mp3" :
      "assets/musics/zayman.mp3"),
      loopMode: LoopMode.single
    );
  }


  @override
  void dispose() {
    assetsAudioPlayer.stop();
    assetsAudioPlayer.dispose();
    animationControllerScaleButton.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop()async{
    if(status == 1){
      AnalyticsHelper().log(AnalyticsEvents.ChangeStatusPgPeriod_Back_NavBar_Clk);
    }else{
      AnalyticsHelper().log(AnalyticsEvents.ChangeStatusPgPregnancy_Back_NavBar_Clk);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = .5;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child:  Scaffold(
            body: Stack(
              alignment: Alignment.center,
              children: [
                background(status == 1 ? 'back_bardari.png' : 'back_zayman.png'),
                frame(status == 1 ? 'frame_bardari.png' : 'frame_zayman.png'),
                avatar(status == 1 ? 'bardari_json.zip' : 'zayman_json.zip'),
                Padding(
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(100),
                    right: ScreenUtil().setWidth(70)
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                top: ScreenUtil().setWidth(12)
                              ),
                              height: ScreenUtil().setWidth(90),
                              // color: Colors.red,
                              child: Text(
                                '${registerInfo.register.name} جان',
                                style: context.textTheme.headlineSmall!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              top: ScreenUtil().setWidth(50),
                              child: Image.asset(
                                'assets/images/ic_under_text.png',
                                fit: BoxFit.fitHeight,
                                width: ScreenUtil().setWidth(80),
                                height: ScreenUtil().setWidth(80),
                              ),
                            )
                          ],
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setWidth(20),
                                horizontal: ScreenUtil().setWidth(30)
                            ),
                            margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(80),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(7),
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                )
                            ),
                            child: Center(
                              child: Text(
                                status == 2 ? 'فرشته‌ی کوچک تو، این هدیه‌ی زیبای خدا، حالا در آغوشته. مادر شدنت هزاران بار مبارک❤'
                                : 'جوانه‌ای که در دلت پرورده میشه، یک روز نهال سبز و تنومندی خواهدشد. هستی‌ات سبز و فردایش روشن. ایمپو هم به اندازه‌ی تو خوشحاله😍',
                                textAlign: TextAlign.justify,
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: Color(0xff2A0E47),
                                ),
                              ),
                            )
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: ScreenUtil().setWidth(30),
                            left: ScreenUtil().setWidth(80),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StreamBuilder(
                                stream: _animations.squareScaleBackButtonObserve,
                                builder: (context,AsyncSnapshot<double>snapshotScale){
                                  if(snapshotScale.data != null){
                                    return Transform.scale(
                                      scale: modePress == 2 ? snapshotScale.data : 1.0,
                                      child: GestureDetector(
                                        onTap: (){
                                          animationControllerScaleButton.reverse();
                                          if(this.mounted){
                                            setState(() {
                                              modePress =2;
                                            });
                                          }
                                          if(status == 1){
                                            AnalyticsHelper().log(AnalyticsEvents.ChangeStatusPgPeriod_Back_Btn_Clk);
                                          }else{
                                            AnalyticsHelper().log(AnalyticsEvents.ChangeStatusPgPregnancy_Back_Btn_Clk);
                                          }
                                          Navigator.pop(context);
                                        },
                                        child:  _button(
                                            Colors.white,
                                            "بازگشت",
                                            [ Colors.transparent,Colors.transparent]
                                        ),
                                      ),
                                    );
                                  }else{
                                    return Container();
                                  }
                                },
                              ),
                              // SizedBox(width: ScreenUtil().setWidth(30)),
                              StreamBuilder(
                                stream: _animations.squareScaleBackButtonObserve,
                                builder: (context,AsyncSnapshot<double>snapshotScale){
                                  if(snapshotScale.data != null){
                                    return Transform.scale(
                                      scale: modePress == 3 ? snapshotScale.data : 1.0,
                                      child: GestureDetector(
                                        onTap: (){
                                          assetsAudioPlayer.stop();
                                          animationControllerScaleButton.reverse();
                                          if(status == 2){
                                            AnalyticsHelper().log(AnalyticsEvents.ChangeStatusPgPregnancy_Complete_Btn_Clk);
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                  child: PregnancyDateRegisterScreen(),
                                                  type: PageTransitionType.fade
                                              )
                                            );
                                          }else{
                                            AnalyticsHelper().log(AnalyticsEvents.ChangeStatusPgPeriod_Complete_Btn_Clk);
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    child: BardariRegisterScreen(),
                                                    type: PageTransitionType.fade
                                                )
                                            );
                                          }
                                          if(this.mounted){
                                            setState(() {
                                              modePress =3;
                                            });
                                          }
                                        },
                                        child: _button(
                                            Colors.transparent,
                                            "تکمیل اطلاعات",
                                            status == 2 ?
                                            [ ColorPallet().mainColor, ColorPallet().lightMainColor,] :
                                            [ ColorPallet().mentalMain, ColorPallet().mentalHigh,]
                                        ),
                                      ),
                                    );
                                  }else{
                                    return Container();
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
        )
      ),
    );
  }

  Widget background(String image){
    return  Image.asset(
        'assets/images/$image',
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height
    );
  }
  
  Widget frame(String image){
    return Padding(
      padding: EdgeInsets.only(
        top: status == 1 ? ScreenUtil().setWidth(80) : ScreenUtil().setWidth(60),
        bottom: status == 1 ?  ScreenUtil().setWidth(20) : ScreenUtil().setWidth(0),
        right:  ScreenUtil().setWidth(25),
        left: ScreenUtil().setWidth(25),
      ),
      child: Image.asset(
          'assets/images/$image',
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height
      ),
    );
  }
  
  Widget  avatar(String json){
    return Padding(
        padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(150)
        ),
        child:Lottie.asset(
          'assets/json/$json',
          fit: BoxFit.cover,
        )
    );
  }

  Widget _button(Color? borderColor, String title,List<Color> colors) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setWidth(12),
          horizontal: ScreenUtil().setWidth(20)),
      width: ScreenUtil().setWidth(280),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
              colors: colors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight),
          border: Border.all(
              color: borderColor ?? Colors.transparent, width: 1.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: context.textTheme.bodyMedium!.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

}