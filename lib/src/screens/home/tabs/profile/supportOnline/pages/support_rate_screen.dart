
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:impo/src/architecture/presenter/support_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/dialogs/support_feedback_dialog.dart';
import 'package:get/get.dart';
import 'package:impo/src/screens/home/tabs/profile/supportOnline/pages/chat_support_screen.dart';
import 'package:page_transition/page_transition.dart';


class SupportRateScreen extends StatefulWidget{
  final SupportPresenter? supportPresenter;
  final String? chatId;

  SupportRateScreen({Key? key,this.supportPresenter,this.chatId}):super(key:key);

  @override
  State<StatefulWidget> createState() => SupportRateScreenState();

}

class SupportRateScreenState extends State<SupportRateScreen> with TickerProviderStateMixin{

  Animations animations =  Animations();
  late AnimationController animationControllerScaleButton;
  int modePress = 0;



  @override
  void initState() {
    widget.supportPresenter!.clearTextRate();
    animationControllerScaleButton = animations.pressButton(this);
    widget.supportPresenter!.initialDialogScale(this);
    widget.supportPresenter!.initTextEditingControllerFeedback();
    super.initState();
  }


  @override
  void dispose() {
    animationControllerScaleButton.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return WillPopScope(
      onWillPop: () => widget.supportPresenter!.onWillPopRateScreen(context,widget.supportPresenter!,widget.chatId),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            alignment: Alignment.topLeft,
            children: [
              StreamBuilder(
                stream: widget.supportPresenter!.valueRateObserve,
                builder: (context,AsyncSnapshot<double>snapshotValueRate){
                  if(snapshotValueRate.data != null){
                    return Padding(
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setWidth(180),
                        right: ScreenUtil().setWidth(50),
                        left: ScreenUtil().setWidth(50),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          Padding(
                            padding:  EdgeInsets.only(
                              bottom: ScreenUtil().setWidth(200)
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: ScreenUtil().setWidth(50)
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(20),
                                    vertical: ScreenUtil().setWidth(15),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color(0xffFD9FDD).withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child:   Text(
                                    'امیدواریم این راهنمایی واست مفید باشه به پاسخی که دریافت کردی چه امتیازی میدی؟',
                                    textAlign: TextAlign.center,
                                    style:  context.textTheme.bodyMedium!.copyWith(
                                      color: ColorPallet().mainColor,
                                    ),
                                  ),
                                ),
                                Directionality(
                                    textDirection: TextDirection.ltr,
                                    child:  Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: ScreenUtil().setWidth(25),
                                          horizontal: ScreenUtil().setWidth(30),
                                        ),
                                        decoration:  BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color(0xff5F9BDF).withOpacity(0.25),
                                                  blurRadius: 5.0
                                              )
                                            ]
                                        ),
                                        child: Center(
                                            child: Column(
                                              children: [
                                                RatingBar.builder(
                                                  initialRating: snapshotValueRate.data!,
                                                  minRating:1.0,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: false,
                                                  itemCount: 5,
                                                  itemSize: ScreenUtil().setWidth(80),
                                                  itemPadding: EdgeInsets.symmetric(horizontal:ScreenUtil().setWidth(15)),
                                                  itemBuilder: (context, _) => SvgPicture.asset(
                                                    'assets/images/ic_star.svg',
                                                    colorFilter: ColorFilter.mode(
                                                      ColorPallet().mentalMain,
                                                      BlendMode.srcIn
                                                    ),
                                                  ),
                                                  glowColor: Colors.white,
                                                  unratedColor: ColorPallet().mentalMain.withOpacity(0.35),
                                                  onRatingUpdate: (rating) {
                                                    widget.supportPresenter!.changeRateValue(rating);
                                                  },
                                                ),
                                              ],
                                            )
                                        )
                                    )
                                )
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(20),
                                  bottom: ScreenUtil().setWidth(50)
                              ),
                              child:
                              Column(
                                children: [
                                  Text(
                                    'لطفا نظرت رو برامون بنویس تا بتونیم بررسی کنیم و در آینده سرویس بهتری ارائه بدیم',
                                    textAlign: TextAlign.center,
                                    style: context.textTheme.labelMedium!.copyWith(
                                      color: ColorPallet().gray.withOpacity(0.5),
                                    ),
                                  ),
                                  SizedBox(height: ScreenUtil().setHeight(25)),
                                  CustomButton(
                                    title: 'ثبت نظر',
                                    onPress: (){
                                      ///AnalyticsHelper().log(AnalyticsEvents.RatePg_RegComment_Btn_Clk);
                                      if(snapshotValueRate.data != 0){
                                        widget.supportPresenter!.showFeedBackDialog();
                                      }
                                    },
                                    colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                                    borderRadius: 20.0,
                                    enableButton: true,
                                    isLoadingButton: false,
                                    margin: 210,
                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                    );
                  }else{
                    return Container();
                  }
                },
              ),
              StreamBuilder(
                stream: animations.squareScaleBackButtonObserve,
                builder: (context,AsyncSnapshot<double>snapshotScale){
                  if(snapshotScale.data != null){
                    return Transform.scale(
                      scale: modePress == 0 ? snapshotScale.data : 1.0,
                      child: GestureDetector(
                          onTap: ()async{
                            if(this.mounted){
                              setState(() {
                                modePress = 0;
                              });
                            }
                            ///AnalyticsHelper().log(AnalyticsEvents.RatePg_Back_Btn_Clk);
                            await animationControllerScaleButton.reverse();
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: ChatSupportScreen(
                                      supportPresenter: widget.supportPresenter!,
                                      chatId: widget.chatId,
                                      fromNotify: false,
                                    )
                                )
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                top: ScreenUtil().setWidth(90),
                                left: ScreenUtil().setWidth(50)
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
              StreamBuilder(
                stream: widget.supportPresenter!.isShowFeedbackDialogObserve,
                builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog){
                  if(snapshotIsShowDialog.data != null){
                    if(snapshotIsShowDialog.data!){
                      return SupportFeedBackDialog(
                        scaleAnim: widget.supportPresenter!.dialogScaleObserve,
                        onPressClose: widget.supportPresenter!.closeFeedbackDialog,
                        supportPresenter: widget.supportPresenter!,
                        chatId: widget.chatId,
                      );
                    }else{
                      return  Container();
                    }
                  }else{
                    return Container();
                  }
                },
              )
            ],
          ),
        ),
      )
    );
  }

}