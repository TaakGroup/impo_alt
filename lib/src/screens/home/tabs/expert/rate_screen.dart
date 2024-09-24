

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:impo/src/architecture/presenter/expert_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/dialogs/feedback_dialog.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/models/expert/chat_ticket_model.dart';
import 'package:impo/src/models/expert/item_feedback_model.dart';
import 'package:impo/src/screens/home/tabs/expert/chat_screen.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../firebase_analytics_helper.dart';
import '../../../../models/expert/tickets_model.dart';

class RateScreen extends StatefulWidget{
  final ExpertPresenter? expertPresenter;
  final chatId;
  final fromMainExpert;
  final fromActiveClini;

  RateScreen({Key? key,this.expertPresenter,this.chatId,this.fromMainExpert,this.fromActiveClini}):super(key:key);

  @override
  State<StatefulWidget> createState() => RateScreenState();

}

class RateScreenState extends State<RateScreen> with TickerProviderStateMixin{

  Animations animations =  Animations();
  late AnimationController animationControllerScaleButton;
  int modePress = 0;



  @override
  void initState() {
    widget.expertPresenter!.clearTextRate();
    animationControllerScaleButton = animations.pressButton(this);
    widget.expertPresenter!.initTabController(this);
    widget.expertPresenter!.initialDialogScale(this);
    widget.expertPresenter!.initTextEditingControllerFeedback();
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
      onWillPop: () => widget.expertPresenter!.onWillPopRateScreen(context,widget.expertPresenter!,
          widget.fromActiveClini, widget.fromMainExpert,widget.chatId),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            alignment: Alignment.topLeft,
            children: [
              StreamBuilder(
                stream: widget.expertPresenter!.chatsObserve,
                builder: (context,AsyncSnapshot<ChatTicketModel>snapshotChats){
                  if(snapshotChats.data != null){
                    return StreamBuilder(
                      stream: widget.expertPresenter!.valueRateObserve,
                      builder: (context,AsyncSnapshot<double>snapshotValueRate){
                        if(snapshotValueRate.data != null){
                          return Padding(
                            padding: EdgeInsets.only(
                              top: ScreenUtil().setWidth(180),
                              right: ScreenUtil().setWidth(50),
                              left: ScreenUtil().setWidth(50),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: ScreenUtil().setWidth(200),
                                      width: ScreenUtil().setWidth(200),
                                      decoration:  BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Color(0xffF2F2F2),
                                              width: ScreenUtil().setWidth(2)
                                          ),
                                          image:  DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                '$mediaUrl/file/${snapshotChats.data!.drImage}',
                                              )
                                          )
                                      ),
                                    ),
                                    SizedBox(width: ScreenUtil().setWidth(30)),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${snapshotChats.data!.drName}',
                                          style:context.textTheme.labelLargeProminent!.copyWith(
                                            color: ColorPallet().mainColor,
                                          ),
                                        ),
                                        Text(
                                          '${snapshotChats.data!.drAcadimicCertificate}',
                                          style: context.textTheme.bodySmall!.copyWith(
                                            color: ColorPallet().gray,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: ScreenUtil().setHeight(30)),
                                Flexible(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      snapshotValueRate.data == 0 ?
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
                                      ) : Container(),
                                      snapshotValueRate.data == 0 ?
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
                                                          widget.expertPresenter!.changeRateValue(rating);
                                                        },
                                                      ),
                                                    ],
                                                  )
                                              )
                                          )
                                      ) :
                                      Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: Flexible(
                                              child:  Container(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: ScreenUtil().setWidth(25),
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
                                                          widget.expertPresenter!.changeRateValue(rating);
                                                        },
                                                      ),
                                                      Flexible(
                                                          child:   StreamBuilder(
                                                            stream: widget.expertPresenter!.currentIndexTabObserve,
                                                            builder: (context,snapshotCurrentIndex){
                                                              if(snapshotCurrentIndex.data != null){
                                                                return Column(
                                                                  children: [
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          top: ScreenUtil().setWidth(15)
                                                                      ),
                                                                      child:  TabBar(
                                                                        controller: widget.expertPresenter!.tabController,
                                                                        labelColor: ColorPallet().black,
                                                                        indicatorColor: snapshotCurrentIndex.data == 0 ? Color(0xffFF6A88) : Color(0xff45D193),
                                                                        unselectedLabelColor: ColorPallet().gray.withOpacity(0.5),
                                                                        labelStyle: context.textTheme.bodyMedium,
                                                                        tabs: [
                                                                          Tab(text: 'بازخورد منفی'),
                                                                          Tab(text: 'بازخورد مثبت',),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Flexible(
                                                                      child: TabBarView(
                                                                        controller: widget.expertPresenter!.tabController,
                                                                        children: [
                                                                          StreamBuilder(
                                                                            stream: widget.expertPresenter!.negativeFeedBackObserve,
                                                                            builder: (context,AsyncSnapshot<List<ItemFeedBackModel>>snapshotNegative){
                                                                              if(snapshotNegative.data != null){
                                                                                return feedBacks(snapshotNegative.data!,false);
                                                                              }else{
                                                                                return Container();
                                                                              }
                                                                            },
                                                                          ),
                                                                          StreamBuilder(
                                                                            stream: widget.expertPresenter!.positiveFeedBackObserve,
                                                                            builder: (context,AsyncSnapshot<List<ItemFeedBackModel>>snapshotPositive){
                                                                              if(snapshotPositive.data != null){
                                                                                return feedBacks(snapshotPositive.data!,true);
                                                                              }else{
                                                                                return Container();
                                                                              }
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                );
                                                              }else{
                                                                return Container();
                                                              }
                                                            },
                                                          )
                                                      )
                                                    ],
                                                  )
                                              )
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: ScreenUtil().setWidth(20),
                                        bottom: ScreenUtil().setWidth(50)
                                    ),
                                    child: snapshotValueRate.data == 0.0 ?
                                    Text(
                                      'نظراتت با حفظ حریم شخصی ثبت میشن!',
                                      style: context.textTheme.bodySmall!.copyWith(
                                        color: ColorPallet().gray.withOpacity(0.5),
                                      ),
                                    ) :
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
                                            AnalyticsHelper().log(AnalyticsEvents.RatePg_RegComment_Btn_Clk);
                                            widget.expertPresenter!.showFeedBackDialog();
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
                            AnalyticsHelper().log(AnalyticsEvents.RatePg_Back_Btn_Clk);
                            await animationControllerScaleButton.reverse();
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: ChatScreen(
                                      expertPresenter: widget.expertPresenter!,
                                      chatId: widget.chatId,
                                      fromActiveClini: widget.fromActiveClini,
                                      fromMainExpert: widget.fromMainExpert,
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
                stream: widget.expertPresenter!.isShowFeedbackDialogObserve,
                builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog){
                  if(snapshotIsShowDialog.data != null){
                    if(snapshotIsShowDialog.data!){
                      return FeedBackDialog(
                        scaleAnim: widget.expertPresenter!.dialogScaleObserve,
                        onPressClose: widget.expertPresenter!.closeFeedbackDialog,
                        expertPresenter: widget.expertPresenter!,
                        chatId: widget.chatId,
                        fromMainExpert: widget.fromMainExpert,
                        fromActiveClini: widget.fromActiveClini,
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

  Widget feedBacks(List<ItemFeedBackModel> feedbacks,isPositive){
    return  GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3
        ),
        itemCount: feedbacks.length,
        padding: EdgeInsets.only(
          right: ScreenUtil().setWidth(5),
          left: ScreenUtil().setWidth(5),
          top:  ScreenUtil().setWidth(20),
        ),
        shrinkWrap: true,
        itemBuilder: (context,i){
          return  GestureDetector(
            onTap: (){
              widget.expertPresenter!.onPressItemFeedback(isPositive,i);
              // if(!isChange){
              //   if(this.mounted){
              //     setState(() {
              //       isChange = true;
              //     });
              //   }
              // }
              // widget.bioRhythmPresenter.onPressAnswerQuestions(index,i,j);
            },
            child: Container(
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(5),
                  right: ScreenUtil().setWidth(5),
                  bottom: ScreenUtil().setWidth(20),
                ),
                decoration:  BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    border: Border.all(
                        color: feedbacks[i].isSelected   ?
                        isPositive ? Color(0xff45D193) : Color(0xffFF6A88)
                            : ColorPallet().gray.withOpacity(0.4),
                        width: ScreenUtil().setWidth(3)
                    )
                ),
                child:  Center(
                    child:    Text(
                      feedbacks[i].text!,
                      textAlign: TextAlign.center,
                      style:  context.textTheme.bodySmall!.copyWith(
                        color: feedbacks[i].isSelected   ?
                        isPositive ? Color(0xff45D193) : Color(0xffFF6A88)
                            : ColorPallet().gray,
                      ),
                    )
                )
            ),
          );
        }
    );
  }

}