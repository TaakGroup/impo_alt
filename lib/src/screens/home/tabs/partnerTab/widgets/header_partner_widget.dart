import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/daily_message_presenter.dart';
import 'package:impo/src/architecture/presenter/partner_tab_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/models/challenge/get_challenge_model.dart';
import 'package:impo/src/screens/home/tabs/calender/memory/memory_game_screen.dart';
import 'package:impo/src/screens/home/tabs/partnerTab/pages/daily_message_screen.dart';
import 'package:impo/src/screens/home/tabs/partnerTab/pages/archive_daily_message_screen.dart';
import 'package:impo/src/screens/home/tabs/partnerTab/pages/send_message_screen.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social/chat_application.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../packages/featureDiscovery/src/foundation/feature_discovery.dart';

class HeaderPartnerWidget extends StatefulWidget{
  final PartnerTabPresenter? partnerTabPresenter;
  final GetChallengeModel? challenge;
  final DailyMessagePresenter? dailyMessagePresenter;

  HeaderPartnerWidget({Key? key,this.partnerTabPresenter,this.challenge,this.dailyMessagePresenter}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HeaderPartnerWidgetState();
}

class HeaderPartnerWidgetState extends State<HeaderPartnerWidget> with TickerProviderStateMixin{

  Animations animations =  Animations();
  late AnimationController animationControllerScaleButton;
  int? modePress;
  late AnimationController _controller;

  @override
  void initState() {
    animationControllerScaleButton = animations.pressButton(this);
    _controller = AnimationController(vsync: this);
    _controller.addListener(() {
      if(_controller.isCompleted){
        _controller.repeat();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // timeDilation = 2;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/back_partner.webp',
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                  height: widget.challenge!.card.text != '' ||
                      widget.challenge!.card.btnText != '' ?
                  null : ScreenUtil().setWidth(500),
                ),
                Column(
                  children: [
                    SizedBox(height: ScreenUtil().setWidth(100)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        boxAvatar(widget.challenge!.manAvatar),
                        SizedBox(width: ScreenUtil().setWidth(15)),
                        boxAvatar(widget.challenge!.womanAvatar)
                      ],
                    ),
                    Text(
                      '${widget.challenge!.manName} و ${widget.challenge!.womanName}',
                      style: context.textTheme.titleMedium!.copyWith(
                        foreground: Paint()..shader = LinearGradient(
                          colors: <Color>[Color(0xff6F2E82),Color(0xff4F0057)],
                        ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      ),
                    ),
                    widget.challenge!.status != '' ?
                    Text(
                      widget.challenge!.status,
                      style: context.textTheme.labelSmallProminent,
                    ) : SizedBox.shrink(),
                    SizedBox(height: ScreenUtil().setWidth(20)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(40)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StreamBuilder(
                              stream: notReadMessageObserve,
                              builder: (context,snapshotNotRead){
                                if(snapshotNotRead.data != null){
                                  return itemButton(
                                      widget.challenge!.button.b1,
                                      'assets/images/ic_small_send_message.svg',
                                          () {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType.fade,
                                                child: SendMessageScreen()
                                            )
                                        );
                                      },
                                      badgeMessage: snapshotNotRead.data != 0 ? true : false
                                  );
                                }else{
                                  return Container();
                                }
                              }
                          ),
                          itemButton(
                              widget.challenge!.button.b2,
                              'assets/images/ic_diary.svg',
                                  () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: MemoryGameScreen()
                                    )
                                );
                              }
                          ),
                          itemButton(
                              widget.challenge!.button.b3,
                              'assets/images/ic_history_partner.svg',
                                  () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: ArchiveDailyMessageScreen(
                                          dailyMessagePresenter: widget.dailyMessagePresenter,
                                          partnerTabPresenter: widget.partnerTabPresenter,
                                        )
                                    )
                                );
                              }
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            widget.challenge!.card.text != '' ||
                widget.challenge!.card.btnText != '' ?
            SizedBox(height: ScreenUtil().setWidth(100))
            : SizedBox.shrink(),
          ],
        ),
        widget.challenge!.card.text != '' ||
            widget.challenge!.card.btnText != '' ?
        Container(
          margin: EdgeInsets.only(
            right: ScreenUtil().setWidth(30),
            left: ScreenUtil().setWidth(30),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(10),
            vertical: ScreenUtil().setWidth(30),
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Color(0xff8C93FE).withOpacity(0.15),
                    offset: Offset(8,8),
                    blurRadius: 8
                )
              ]
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(15)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: checkFormatIcon(widget.challenge!.card.rightIcon),
                    ),
                    widget.challenge!.card.rightIcon != '' ?
                    SizedBox(width: ScreenUtil().setWidth(20)) :
                    SizedBox.shrink(),
                    Flexible(
                      flex: 6,
                      child: Text(
                        widget.challenge!.card.text,
                        textAlign: widget.challenge!.card.rightIcon != ''
                            ? TextAlign.start : TextAlign.center,
                        style: context.textTheme.bodyMedium,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: checkFormatIcon(widget.challenge!.card.leftIcon),
                    )
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setWidth(15)),
              widget.challenge!.card.btnText != '' ?
              CustomButton(
                onPress: ()  {
                  checkPressBtn(widget.challenge!.card.link);
                },
                margin: 40,
                height: ScreenUtil().setWidth(75),
                colors: [ColorPallet().mainColor, ColorPallet().mainColor],
                borderRadius: 12.0,
                enableButton: true,
                title: widget.challenge!.card.btnText,
              ) : SizedBox.shrink(),
            ],
          ),
        )
            : SizedBox.shrink(),
      ],
    );
  }

  Widget boxAvatar(String image){
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: ScreenUtil().setWidth(210),
          height: ScreenUtil().setWidth(210),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        Container(
          width: ScreenUtil().setWidth(190),
          height: ScreenUtil().setWidth(190),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(image)
              )
          ),
        ),
      ],
    );
  }

  Widget itemButton(String text,String icon,void Function() press,{bool badgeMessage = false}){
    return Flexible(
      child: CustomButton(
        onPress: press,
        margin: 10,
        height: ScreenUtil().setWidth(70),
        colors: [Colors.white,Colors.white],
        borderRadius: 20.0,
        padding: ScreenUtil().setWidth(20),
        enableButton: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
                icon
            ),
            SizedBox(width: ScreenUtil().setWidth(5)),
            Text(
              text,
              style: context.textTheme.labelSmall,
            ),
            badgeMessage ?
            StreamBuilder(
              stream: notReadMessageObserve,
              builder: (context, snapshotNotRead) {
                if (snapshotNotRead.data != null) {
                  if (snapshotNotRead.data != 0) {
                    return Container(
                        margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                        padding: EdgeInsets.all(ScreenUtil().setWidth(13)),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: ColorPallet().mainColor),
                        child: Center(
                          child: Text(
                            snapshotNotRead.data.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: ScreenUtil().setWidth(26)
                            ),
                          ),
                        ));
                  } else {
                    return SizedBox.shrink();
                  }
                } else {
                  return Container();
                }
              },
            ) : SizedBox.shrink()
          ],
        ),
      ),
    );

  }

  Widget checkFormatIcon(String icon){
    if(icon.contains('.webp')){
      return Image.network(
        icon,
        fit: BoxFit.cover,
      );
    }else if(icon.contains('.json')){
      return Lottie.network(
          icon,
          fit: BoxFit.cover,
          controller: _controller,
          onLoaded: (composition) {
            // Configure the AnimationController with the duration of the
            // Lottie file and start the animation.
            _controller
              ..duration = Duration(milliseconds: 1800)
              ..forward();
          },
          repeat: true,
          width: ScreenUtil().setWidth(120),
          height: ScreenUtil().setWidth(120)
      );
    }else{
      return SizedBox.shrink();
    }
  }

  checkPressBtn(LinkCardChallengeModel link) async {
    switch (link.type) {
      case 0:
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: DailyMessageScreen(
                  dailyMessagePresenter: widget.dailyMessagePresenter,
                  partnerTabPresenter: widget.partnerTabPresenter,
                )
            )
        );
        break;
      case 1:
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: ArchiveDailyMessageScreen(
                  dailyMessagePresenter: widget.dailyMessagePresenter,
                  partnerTabPresenter: widget.partnerTabPresenter,
                )
            )
        );
        break;
      case 2:
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: MemoryGameScreen()
            )
        );
        break;
      case 3:
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: SendMessageScreen()
            )
        );
        break;
      case 4:
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: ChatApp(
                  back: (bool hasPartnerFromChat){
                    if(hasPartnerFromChat){
                      Navigator.pop(context);
                    }else{
                      widget.partnerTabPresenter!.getManInfo(context,false);
                      Navigator.pop(context);
                    }
                  },
                  baseUrl: womanUrl,
                  baseMediaUrl: mediaUrl,
                  token: widget.dailyMessagePresenter!.getRegisters().token!,
                  id: link.url,
                )
            )
        );
        break;
      case 10:
        _launchURL(link.url);
        break;
    }
  }

  Future<bool> _launchURL(String url) async {
    String httpUrl = '';
    if(url.startsWith('http')){
      httpUrl = url;
    }else{
      httpUrl = 'https://$url';
    }
    if (!await launch(httpUrl)) throw 'Could not launch $httpUrl';
    return true;
  }

}