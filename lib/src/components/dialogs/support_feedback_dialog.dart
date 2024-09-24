
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/expert_presenter.dart';
import 'package:impo/src/architecture/presenter/support_presenter.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:get/get.dart';

import '../animations.dart';
import '../loading_view_screen.dart';

class SupportFeedBackDialog extends StatefulWidget{

  final scaleAnim;
  final onPressClose;
  final SupportPresenter? supportPresenter;
  final chatId;

  SupportFeedBackDialog({Key? key,this.scaleAnim,this.onPressClose,this.supportPresenter,this.chatId}):super(key:key);

  @override
  State<StatefulWidget> createState() => SupportFeedBackDialogState();

}

class SupportFeedBackDialogState extends State<SupportFeedBackDialog> with TickerProviderStateMixin{

  late AnimationController animationControllerScaleButtons;
  Animations _animations =  Animations();

  int modePress = 0;

  @override
  void initState() {
    animationControllerScaleButtons = _animations.pressButton(this);
    super.initState();
  }

  @override
  void dispose() {
    animationControllerScaleButtons.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = 0.5;
    return  Stack(
      children: <Widget>[
        GestureDetector(
          onTap: widget.onPressClose,
          child:  Container(
            decoration:  BoxDecoration(
                color: Colors.black.withOpacity(.8)
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: ListView(
            shrinkWrap: true,
            children: [
              StreamBuilder(
                stream: widget.scaleAnim,
                builder: (context,AsyncSnapshot<double> snapshotScaleDialog){
                  if(snapshotScaleDialog.data != null){
                    return  Transform.scale(
                        scale: snapshotScaleDialog.data,
                        child:  Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            StreamBuilder(
                              stream: widget.supportPresenter!.valueRateObserve,
                              builder: (context,AsyncSnapshot<double> snapshotValueRate){
                                if(snapshotValueRate.data != null){
                                  return Container(
//                              width: 280,
//                              height: 400,
                                    margin: EdgeInsets.only(
                                        top: ScreenUtil().setWidth(120),
                                        right: ScreenUtil().setWidth(60),
                                        left: ScreenUtil().setWidth(60)
                                    ),
                                    padding: EdgeInsets.only(
                                        top: ScreenUtil().setWidth(100)
                                    ),
                                    decoration:  BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        gradient: LinearGradient(
                                            colors: [Colors.white,Colors.white],
                                            begin: Alignment.bottomLeft,
                                            end:Alignment.topRight
                                        )
                                    ),
                                    child:  Padding(
                                      padding: EdgeInsets.only(
                                        right: ScreenUtil().setWidth(30),
                                        left: ScreenUtil().setWidth(30),
                                      ),
                                      child:  Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: RatingBar.builder(
                                              initialRating: snapshotValueRate.data!,
                                              minRating:1.0,
                                              direction: Axis.horizontal,
                                              allowHalfRating: false,
                                              itemCount: 5,
                                              itemSize: ScreenUtil().setWidth(50),
                                              itemPadding: EdgeInsets.symmetric(horizontal:ScreenUtil().setWidth(15)),
                                              itemBuilder: (context, _) => SvgPicture.asset(
                                                'assets/images/ic_star.svg',
                                                colorFilter: ColorFilter.mode(
                                                    ColorPallet().mentalMain.withOpacity(0.75),
                                                    BlendMode.srcIn
                                                ),
                                              ),
                                              glowColor: Colors.white,
                                              unratedColor: ColorPallet().mentalMain.withOpacity(0.35),
                                              onRatingUpdate: (rating) {

                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: ScreenUtil().setWidth(28)
                                            ),
                                            child: Text(
                                              'لطفا نظرت رو برامون بنویس تا بتونیم بررسی کنیم و درآینده سرویس بهتری ارائه بدیم',
                                              textAlign: TextAlign.center,
                                              style: context.textTheme.bodyMedium,
                                            ),
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(
                                                top: ScreenUtil().setWidth(40),
                                                bottom: ScreenUtil().setWidth(50),
                                                right: ScreenUtil().setWidth(10),
                                                left: ScreenUtil().setWidth(10),
                                              ),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(7),
                                                  border: Border.all(
                                                      color: ColorPallet().mentalMain.withOpacity(0.7)
                                                  )
                                              ),
                                              child: Theme(
                                                data: Theme.of(context).copyWith(
                                                  textSelectionTheme: TextSelectionThemeData(
                                                      selectionColor: Color(0xffaaaaaa),
                                                      cursorColor: ColorPallet().mainColor
                                                  ),
                                                ),
                                                child:  TextField(
                                                  controller: widget.supportPresenter!.rateValueController,
                                                  maxLines: 3,
                                                  maxLength: 250,
                                                  enableInteractiveSelection: false,
                                                  style: context.textTheme.bodyMedium,
                                                  decoration:  InputDecoration(
                                                    // counter: widget.mode == 2 ? Text(''): null,
                                                      border: InputBorder.none,
                                                      hintText: 'در صورت نیاز توضیح خود را در این قسمت بنویسید',
                                                      hintStyle: context.textTheme.bodySmall!.copyWith(
                                                        color: ColorPallet().gray.withOpacity(0.5),
                                                      ),
                                                      contentPadding:  EdgeInsets.only(
                                                          right: ScreenUtil().setWidth(20),
                                                          left: ScreenUtil().setWidth(15),
                                                          top: ScreenUtil().setWidth(5)
                                                        // bottom: ScreenUtil().setWidth(35),
                                                        // top: ScreenUtil().setWidth(5),
                                                      )
                                                  ),
                                                ),
                                              )
                                          ),
                                          StreamBuilder(
                                            stream: widget.supportPresenter!.isLoadingButtonObserve,
                                            builder: (context,snapshotIsLoadingButton){
                                              if(snapshotIsLoadingButton.data != null){
                                                return  CustomButton(
                                                  title: 'ارسال بازخورد',
                                                  onPress: (){
                                                    widget.supportPresenter!.sendRate(widget.chatId,widget.supportPresenter, context);
                                                  },
                                                  colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                                                  borderRadius: 20.0,
                                                  enableButton: true,
                                                  isLoadingButton: snapshotIsLoadingButton.data,
                                                  margin: 150,
                                                );
                                              }else{
                                                return Container();
                                              }
                                            },
                                          ),
                                          SizedBox(height: ScreenUtil().setHeight(40))
                                        ],
                                      ),
                                    ),
                                  );
                                }else{
                                  return Container();
                                }
                              },
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(50)
                                ),
                                width: ScreenUtil().setWidth(160),
                                height: ScreenUtil().setWidth(160),
                                decoration:  BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white
                                ),
                                child: Center(
                                    child: SvgPicture.asset(
                                      'assets/images/ic_feedback.svg',
                                      width: ScreenUtil().setWidth(145),
                                      height: ScreenUtil().setHeight(145),
                                      // fit: BoxFit.fill,
                                    )
                                )
                            ),
                          ],
                        )
                    );
                  }else{
                    return  Container();
                  }
                },
              ),
            ],
          ),
        )
      ],
    );
  }

}