import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:impo/src/architecture/presenter/dashboard_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../components/colors.dart';
import '../../../../../models/bioRhythm/bio_model.dart';
import '../../../../../models/bioRhythm/biorhythm_view_model.dart';

class MyBioRythmWidget extends StatefulWidget{
  final DashboardPresenter? dashboardPresenter;

  MyBioRythmWidget({Key? key,this.dashboardPresenter}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyBioRythmWidgetState();
}

class MyBioRythmWidgetState extends State<MyBioRythmWidget> with TickerProviderStateMixin{

  Animations _animations =  Animations();
  late AnimationController animationControllerScaleButton;

  @override
  void initState() {
    animationControllerScaleButton = _animations.pressButton(this);
    super.initState();
    Future.delayed(Duration.zero,(){
      widget.dashboardPresenter!.initBioRhythm(context);
    });
  }

  @override
  void dispose() {
    animationControllerScaleButton.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.only(
            right: ScreenUtil().setWidth(18),
            left: ScreenUtil().setWidth(18),
            bottom: ScreenUtil().setWidth(30)
        ),
        // height: MediaQuery.of(context).size.height/3.1,
        margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(40),
            right: ScreenUtil().setWidth(40),
            left: ScreenUtil().setWidth(40),
        ),
        color: Colors.white,
        // decoration: BoxDecoration(
        //     color: Colors.white,
        //     boxShadow: [BoxShadow(color: Color(0xff909FDE).withOpacity(0.3), blurRadius: 8.0)],
        //     borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'بیوریتم',
                  style : context.textTheme.labelLargeProminent
              ),
              Text(
                  "بیوریتم یه الگوی تکرارشونده در ابعاد جسمانی، احساسی و ذهنی هست که از روز تولد هر شخص محاسبه می‌شه",
                  style : context.textTheme.bodySmall
              ),
              StreamBuilder(
                stream: widget.dashboardPresenter!.bioRhythmsObserve,
                builder: (context, AsyncSnapshot<List<BioRhythmViewModel>> snapshotBioRhythms) {
                  if (snapshotBioRhythms.data != null) {
                    if (snapshotBioRhythms.data!.length != 0) {
                      var Percent = snapshotBioRhythms.data;
                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: ScreenUtil().setHeight(30),
                            ),
                            // snapshotBioRhythms.data[0].mainPersent == 50||
                            //     snapshotBioRhythms.data[1].mainPersent == 50 ||
                            //     snapshotBioRhythms.data[2].mainPersent == 50
                            //     ? GestureDetector(
                            //   onTap: () {
                            //     /// widget.dashboardPresenter!.ceriticalShowDialog();
                            //   },
                            //   child: Padding(
                            //     padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                            //     child: Row(
                            //       crossAxisAlignment: CrossAxisAlignment.end,
                            //       children: [
                            //         SizedBox(
                            //           height: ScreenUtil().setWidth(45),
                            //           width: ScreenUtil().setWidth(45),
                            //           child: SvgPicture.asset('assets/images/info_outline.svg'),
                            //         ),
                            //         SizedBox(width: ScreenUtil().setWidth(15)),
                            //         Container(
                            //           child: Text(
                            //             'روز بحرانی چیست؟',
                            //             style: TextStyle(
                            //                 color: ColorPallet().black,
                            //                 fontWeight: FontWeight.w400,
                            //                 fontSize: ScreenUtil().setSp(32)),
                            //           ),
                            //         )
                            //       ],
                            //     ),
                            //   ),
                            // )
                            //     :
                            /// hidden
                            // Container(),
                            // SizedBox(
                            //   height: ScreenUtil().setHeight(40),
                            // ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  snapshotBioRhythms.data!.length,
                                      (index) => Padding(
                                      padding: EdgeInsets.only(
                                        bottom: ScreenUtil().setWidth(30),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          widget.dashboardPresenter!.onPressItemBio(index);
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              // color: Colors.red,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey.withOpacity(0.18), //color of shadow
                                                          spreadRadius: 4, //spread radius
                                                          blurRadius: 8, // blur radius
                                                          offset: Offset(1, 1),
                                                        ),
                                                      ],
                                                      gradient: LinearGradient(
                                                          colors: !snapshotBioRhythms.data![index].isSelected!
                                                              ? [
                                                            Colors.white,
                                                            Colors.white,
                                                          ]
                                                              : snapshotBioRhythms.data![index].gradientIcon!),
                                                    ),
                                                    child: Center(
                                                      child: SvgPicture.asset(
                                                        snapshotBioRhythms.data![index].isSelected!
                                                            ? snapshotBioRhythms.data![index].icon!
                                                            : snapshotBioRhythms.data![index].deactiveIcon!,
                                                        colorFilter: snapshotBioRhythms.data![index].isSelected! ?
                                                        ColorFilter.mode(
                                                          Colors.white,
                                                          BlendMode.srcIn
                                                        ) : null,
                                                        width: index == 0 ? ScreenUtil().setWidth(54) : ScreenUtil().setWidth(48),
                                                        height: index == 0 ? ScreenUtil().setWidth(54) : ScreenUtil().setWidth(48),
                                                      ),
                                                    ),
                                                    width: ScreenUtil().setWidth(83),
                                                    height: ScreenUtil().setWidth(83),
                                                  ),
                                                  SizedBox(width: ScreenUtil().setWidth(4)),
                                                  Flexible(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: ColorPallet().backColoropacity,
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Padding(
                                                          padding: EdgeInsets.symmetric(
                                                            horizontal: ScreenUtil().setWidth(10),
                                                            vertical: ScreenUtil().setWidth(10),
                                                          ),
                                                          child: snapshotBioRhythms.data![index].mainPersent! <= 20
                                                              ? Stack(
                                                            children: [
                                                              Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  FDottedLine(
                                                                    color: ColorPallet().dottedBorder.withOpacity(.6),
                                                                    width: MediaQuery.of(context).size.width / 2.1 -
                                                                        (Percent![index].percent!),
                                                                    strokeWidth: .45,
                                                                    dottedLength: 6.0,
                                                                    space: 3.0,
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets.only(right: ScreenUtil().setWidth(0)),
                                                                    width: Percent[index].percent,
                                                                    height: ScreenUtil().setWidth(65),
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      gradient: LinearGradient(
                                                                          colors: snapshotBioRhythms.data![index].isSelected!
                                                                              ? snapshotBioRhythms.data![index].gradientColors!
                                                                              : [
                                                                            snapshotBioRhythms.data![index].mainColor!,
                                                                            snapshotBioRhythms.data![index].mainColor!
                                                                          ]),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Positioned(
                                                                top: ScreenUtil().setWidth(10),
                                                                // left: ScreenUtil().setWidth(1),
                                                                left: snapshotBioRhythms.data![index].mainPersent == 0
                                                                    ? (0 - ((0 * Percent[index].mainPersent!) / 100))
                                                                    : 199 - (199 - ((Percent[index].mainPersent! * 199) / 100)),
                                                                child: Align(
                                                                  // alignment: Alignment.center,
                                                                  child: Container(
                                                                    // width:ScreenUtil().setWidth(100),

                                                                    // height: ScreenUtil().setWidth(30),
                                                                    color: ColorPallet().backColoropacity,
                                                                    child: Padding(
                                                                      padding: EdgeInsets.only(
                                                                          right: ScreenUtil().setWidth(15),
                                                                          left: ScreenUtil().setWidth(8)),
                                                                      child: Text(
                                                                        '${snapshotBioRhythms.data![index].viewPercent}%',
                                                                        textAlign: TextAlign.center,
                                                                        style: context.textTheme.labelLarge!.copyWith(
                                                                          color: snapshotBioRhythms.data![index].isSelected!
                                                                              ? ColorPallet().black
                                                                              : ColorPallet().gray.withOpacity(.5),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                              : snapshotBioRhythms.data![index].mainPersent == 50
                                                              ? Container(
                                                            width: MediaQuery.of(context).size.width / 2.12,
                                                            height: ScreenUtil().setWidth(65),
                                                            decoration: BoxDecoration(
                                                              color: Colors.transparent,
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            padding: EdgeInsets.symmetric(
                                                              horizontal: ScreenUtil().setWidth(10),
                                                              vertical: ScreenUtil().setWidth(10),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                SvgPicture.asset(
                                                                  "assets/images/Danger.svg",
                                                                  colorFilter: snapshotBioRhythms.data![index].isSelected! ?
                                                                  null :
                                                                  ColorFilter.mode(
                                                                    ColorPallet().gray.withOpacity(.5),
                                                                    BlendMode.srcIn
                                                                  ),
                                                                  width: ScreenUtil().setWidth(40),
                                                                ),
                                                                SizedBox(
                                                                  width: ScreenUtil().setWidth(16),
                                                                ),
                                                                Text("روز بحرانی",
                                                                    textAlign: TextAlign.center,
                                                                    style: context.textTheme.bodyMedium!.copyWith(
                                                                      color: snapshotBioRhythms.data![index].isSelected!
                                                                          ? ColorPallet().black
                                                                          : ColorPallet().gray.withOpacity(.5),
                                                                    )
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                              : Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              FDottedLine(
                                                                color: ColorPallet().dottedBorder.withOpacity(.6),
                                                                width: MediaQuery.of(context).size.width / 2.1 -
                                                                    (Percent![index].percent!),
                                                                strokeWidth: .45,
                                                                dottedLength: 6.0,
                                                                space: 3.0,
                                                              ),
                                                              Container(
                                                                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(0)),
                                                                  width:
                                                                  // ScreenUtil().setWidth(200),
                                                                  Percent[index].percent,
                                                                  height: ScreenUtil().setWidth(65),
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(8),
                                                                    gradient: LinearGradient(
                                                                        colors: snapshotBioRhythms.data![index].isSelected!
                                                                            ? snapshotBioRhythms.data![index].gradientColors!
                                                                            : [
                                                                          snapshotBioRhythms.data![index].mainColor!,
                                                                          snapshotBioRhythms.data![index].mainColor!
                                                                        ]),
                                                                  ),
                                                                  child: Align(
                                                                    alignment: Alignment.centerRight,
                                                                    child: Padding(
                                                                      padding:
                                                                      EdgeInsets.only(right: ScreenUtil().setWidth(15)),
                                                                      child: Text(
                                                                        '${snapshotBioRhythms.data![index].viewPercent}%',
                                                                        textAlign: TextAlign.start,
                                                                        style: context.textTheme.labelLarge!.copyWith(
                                                                          color: snapshotBioRhythms.data![index].isSelected!
                                                                              ? Colors.white
                                                                              : ColorPallet().gray.withOpacity(.5),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )),
                                                            ],
                                                          )),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: ScreenUtil().setWidth(102),
                                                    child: Text(
                                                      snapshotBioRhythms.data![index].title!,
                                                      textAlign: TextAlign.center,
                                                      style: context.textTheme.bodySmall!.copyWith(
                                                        color: snapshotBioRhythms.data![index].isSelected!
                                                            ? ColorPallet().black
                                                            : ColorPallet().gray.withOpacity(.5),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                )),
                          ],
                        ),
                      );
                    }
                    return Container();
                  } else {
                    return Container();
                  }
                },
              ),
              StreamBuilder(
                stream: widget.dashboardPresenter!.bioRhythmsObserve,
                builder: (context, AsyncSnapshot<List<BioRhythmViewModel>> snapshotBiorhythms) {
                  if (snapshotBiorhythms.data != null) {
                    if (snapshotBiorhythms.data!.length != 0) {
                      return   Container(
                          height: ScreenUtil().setWidth(200),
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(30),
                          ),
                          margin: EdgeInsets.only(top: ScreenUtil().setWidth(24)),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: ColorPallet().backColor.withOpacity(.1),
                            border: Border.all(
                                color: snapshotBiorhythms.data![0].isSelected!
                                    ? ColorPallet().powerHigh
                                    : snapshotBiorhythms.data![1].isSelected!
                                    ? ColorPallet().emotionalHigh
                                    : ColorPallet().mentalHigh),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: StreamBuilder(
                            stream: widget.dashboardPresenter!.messageRandomBioObserve,
                            builder: (context, AsyncSnapshot<BioRhythmMessagesModel> snapshotMessageBio) {
                              if (snapshotMessageBio.data != null) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      textAlign: TextAlign.justify,
                                      text: TextSpan(
                                          text: '${snapshotMessageBio.data!.username}\n',
                                          style: context.textTheme.labelLarge!.copyWith(
                                            height: 1.5
                                          ),
                                          children: [
                                            TextSpan(
                                              text: '${snapshotMessageBio.data!.text}',
                                              style: context.textTheme.bodySmall
                                            ),
                                          ]
                                      ),
                                    )
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            },
                          )
                      );
                    } else {
                      return Container();
                    }
                  } else {
                    return Container();
                  }
                },
              ),
              SizedBox(height: ScreenUtil().setWidth(30)),
              Row(
               mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                      'assets/images/info_outline.svg',
                    colorFilter: ColorFilter.mode(
                        ColorPallet().mainColor,
                        BlendMode.srcIn
                    ),
                      width: ScreenUtil().setWidth(30),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(15)
                    ),
                    child: Text(
                        'درمورد بیوریتم سوال داری؟',
                        style : context.textTheme.bodySmall

                    ),
                  ),
                  StreamBuilder(
                    stream: _animations.squareScaleBackButtonObserve,
                    builder: (context,AsyncSnapshot<double>snapshotScale){
                      if(snapshotScale.data != null){
                        return Transform.scale(
                          scale: snapshotScale.data,
                          child: GestureDetector(
                            onTap: ()async{
                               await animationControllerScaleButton.reverse();
                               _launchURL('https://impo.app/biorhythm');
                            },
                            child: Text(
                                'اینجا جوابش رو ببین',
                                style : context.textTheme.bodySmall!.copyWith(
                                  color : ColorPallet().mainColor,
                                )
                            ),
                          ),
                        );
                      }else{
                        return Container();
                      }
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
    return true;
  }

}