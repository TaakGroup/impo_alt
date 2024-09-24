
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/support_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:get/get.dart';
import 'package:impo/src/screens/home/tabs/profile/supportOnline/pages/send_support_screen.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:page_transition/page_transition.dart';

class BannerContactSupportWidget extends StatefulWidget{
  final SupportPresenter? supportPresenter;
  final Function()? onPress;
  BannerContactSupportWidget({Key? key,this.supportPresenter,this.onPress}):super(key:key);

  @override
  State<StatefulWidget> createState() => BannerContactSupportWidgetState();
}

class BannerContactSupportWidgetState extends State<BannerContactSupportWidget> with TickerProviderStateMixin{

  Animations animations = Animations();
  late AnimationController animationControllerScaleButton;


  @override
  void initState() {
    animationControllerScaleButton = animations.pressButton(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return StreamBuilder(
      stream: animations.squareScaleBackButtonObserve,
      builder: (context,snapshotScale){
        if(snapshotScale.data != null){
          return Padding(
            padding: EdgeInsets.only(
                bottom: ScreenUtil().setWidth(30)
            ),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.asset(
                  'assets/images/support_online.png',
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding:  EdgeInsets.only(
                        right: ScreenUtil().setWidth(60)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'مشکلت رو تو سوالات بالا پیدا نکردی؟',
                          style: context.textTheme.labelSmallProminent,
                        ),
                        Text(
                          'سوالت رو از پشتیبانی بپرس',
                          style: context.textTheme.labelSmall!.copyWith(
                            color: Color(0xff323232),
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(15)),
                        StreamBuilder(
                          stream: animations.squareScaleBackButtonObserve,
                          builder: (context,AsyncSnapshot<double>snapshotScale){
                            if(snapshotScale.data != null){
                              return Transform.scale(
                                scale: snapshotScale.data,
                                child: GestureDetector(
                                  onTap: ()async{
                                    widget.onPress!();
                                    await animationControllerScaleButton.reverse();
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: SendSupportScreen(
                                              supportPresenter: widget.supportPresenter,
                                            ),
                                            type: PageTransitionType.fade
                                        )
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setWidth(20),
                                        vertical: ScreenUtil().setWidth(12)
                                    ),
                                    width: ScreenUtil().setWidth(320),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      color: ColorPallet().mainColor,
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/images/ic_message.svg'
                                        ),
                                        SizedBox(width: ScreenUtil().setWidth(10)),
                                        Text(
                                          'ارتباط با پشتیبانی',
                                          style: context.textTheme.labelLarge!.copyWith(
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }else{
                              return Container();
                            }
                          },
                        ),
                        SizedBox(height: ScreenUtil().setHeight(30)),
                      ],
                    ),
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

}