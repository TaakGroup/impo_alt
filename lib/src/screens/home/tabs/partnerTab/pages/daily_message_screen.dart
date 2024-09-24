import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/daily_message_presenter.dart';
import 'package:impo/src/architecture/presenter/partner_tab_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/expert_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/challenge/get_form_model.dart';
import '../../../../../components/colors.dart';

class DailyMessageScreen extends StatefulWidget{
  final DailyMessagePresenter? dailyMessagePresenter;
  final PartnerTabPresenter? partnerTabPresenter;

  DailyMessageScreen({Key? key,this.dailyMessagePresenter,this.partnerTabPresenter}):super(key:key);

  @override
  State<StatefulWidget> createState() => DailyMessageScreenState();
}

class DailyMessageScreenState extends State<DailyMessageScreen> with TickerProviderStateMixin{

  Animations animations =  Animations();
  late AnimationController animationControllerScaleButton;
  int? modePress;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    animationControllerScaleButton = animations.pressButton(this);
    // widget.dailyMessagePresenter!.initTabController(this);
    widget.dailyMessagePresenter!.getForm();
    super.initState();
  }

  @override
  void dispose() {
    animationControllerScaleButton.dispose();
    // widget.dailyMessagePresenter!.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop()async{
    if(!widget.dailyMessagePresenter!.hasPartner){
      widget.partnerTabPresenter!.getManInfo(context,false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child:  Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          bottomSheet: StreamBuilder(
            stream: widget.dailyMessagePresenter!.isLoadingObserve,
            builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
              if(snapshotIsLoading.data != null){
                if(!snapshotIsLoading.data!){
                  return StreamBuilder(
                      stream: widget.dailyMessagePresenter!.fromDailyMessageObserve,
                      builder: (context,AsyncSnapshot<GetFormModel>formDailyMessage){
                        if(formDailyMessage.data != null){
                          return Padding(
                            padding:  EdgeInsets.only(
                                bottom: ScreenUtil().setWidth(50)
                            ),
                            child: StreamBuilder(
                              stream: widget.dailyMessagePresenter!.textInputDaiyMessageObserve,
                              builder: (context,AsyncSnapshot<String>snapshotText){
                                if(snapshotText.data != null){
                                  return StreamBuilder(
                                      stream: widget.dailyMessagePresenter!.isLoadingButtonObserve,
                                      builder: (context,AsyncSnapshot<bool>snapshotIsLoadingBtn){
                                        if(snapshotIsLoadingBtn.data != null){
                                          return  CustomButton(
                                            onPress: ()  {
                                              if(!snapshotIsLoadingBtn.data!){
                                                widget.dailyMessagePresenter!.sendQuestions(
                                                    _scaffoldKey.currentContext,snapshotText.data!,formDailyMessage.data!,
                                                    widget.partnerTabPresenter!
                                                );
                                              }
                                            },
                                            margin: 40,
                                            height: ScreenUtil().setWidth(90),
                                            colors: [ColorPallet().mainColor, ColorPallet().mainColor],
                                            borderRadius: 12.0,
                                            enableButton: snapshotText.data != '' ? true : false,
                                            title: formDailyMessage.data!.btn.text,
                                            isLoadingButton: snapshotIsLoadingBtn.data,
                                          );
                                        }else{
                                          return Container();
                                        }
                                      }
                                  );
                                }else{
                                  return Container();
                                }
                              },
                            ),
                          );
                        }else{
                          return Container();
                        }
                      }
                  );
                }else{
                  return SizedBox.shrink();
                }
              }else{
                return Container();
              }
            },
          ),
          body: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(40)
                ),
                child: StreamBuilder(
                  stream: widget.dailyMessagePresenter!.isLoadingObserve,
                  builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                    if(snapshotIsLoading.data != null){
                      return StreamBuilder(
                          stream: widget.dailyMessagePresenter!.fromDailyMessageObserve,
                          builder: (context,AsyncSnapshot<GetFormModel>formDailyMessage){
                            if(formDailyMessage.data != null){
                              if(!snapshotIsLoading.data!){
                                return Column(
                                  children: [
                                    SizedBox(height: ScreenUtil().setWidth(40)),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        StreamBuilder(
                                          stream: animations.squareScaleBackButtonObserve,
                                          builder: (context,AsyncSnapshot<double>snapshotScale){
                                            if(snapshotScale.data != null){
                                              return Transform.scale(
                                                scale:  modePress == 0 ? snapshotScale.data : 1.0,
                                                child: GestureDetector(
                                                    onTap: ()async{
                                                      setState(() {
                                                        modePress = 0;
                                                      });
                                                      await animationControllerScaleButton.reverse();
                                                      if(!widget.dailyMessagePresenter!.hasPartner){
                                                        widget.partnerTabPresenter!.getManInfo(context,false);
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      width: ScreenUtil().setWidth(85),
                                                      height: ScreenUtil().setWidth(85),
                                                      decoration: BoxDecoration(
                                                          color: Colors.transparent,
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                              color: Color(0xffEFEFEF)
                                                          )
                                                      ),
                                                      child: Center(
                                                          child: Icon(
                                                            Icons.close,
                                                            size: ScreenUtil().setWidth(55),
                                                            color: ColorPallet().black,
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
                                        SizedBox(width: ScreenUtil().setWidth(15)),
                                        Text(
                                          formDailyMessage.data!.title,
                                          style: context.textTheme.titleSmall,
                                        )
                                      ],
                                    ),
                                    SizedBox(height: ScreenUtil().setWidth(40)),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          formDailyMessage.data!.date,
                                          style: context.textTheme.titleMedium!.copyWith(
                                              color: ColorPallet().mainColor
                                          ),
                                        ),
                                        Text(
                                          formDailyMessage.data!.status,
                                          style: context.textTheme.titleSmall,
                                        ),
                                        SizedBox(height: ScreenUtil().setWidth(65)),
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   crossAxisAlignment: CrossAxisAlignment.start,
                                        //   children: [
                                        //     Flexible(
                                        //       child: Text(
                                        //         'امروز تایم با کیفیت و مفیدی رو با هم گذروندین؟',
                                        //         style: context.textTheme.bodyMedium,
                                        //       ),
                                        //     ),
                                        //     SizedBox(width: ScreenUtil().setWidth(10)),
                                        //     Container(
                                        //       width: MediaQuery.of(context).size.width/2.5,
                                        //       decoration: BoxDecoration(
                                        //         color: Color(0xffF6F6F6),
                                        //         borderRadius: BorderRadius.circular(20)
                                        //       ),
                                        //       child: TabBar(
                                        //         controller: widget.dailyMessagePresenter!.tabController,
                                        //         // isScrollable: true,
                                        //         indicatorColor: ColorPallet().mainColor,
                                        //         indicatorSize: TabBarIndicatorSize.tab,
                                        //         padding: EdgeInsets.symmetric(
                                        //           vertical: ScreenUtil().setWidth(13)
                                        //         ),
                                        //         indicatorPadding: EdgeInsets.symmetric(
                                        //             vertical: ScreenUtil().setWidth(-13)
                                        //         ),
                                        //         splashBorderRadius: BorderRadius.circular(20),
                                        //         dividerColor: Colors.transparent,
                                        //         indicator: BoxDecoration(
                                        //           color: ColorPallet().mainColor,
                                        //           borderRadius: BorderRadius.circular(20)
                                        //         ),
                                        //         unselectedLabelStyle: context.textTheme.bodyMedium!.copyWith(
                                        //           color: ColorPallet().black
                                        //         ),
                                        //         labelStyle: context.textTheme.bodyMedium!.copyWith(
                                        //             color: Colors.white
                                        //         ),
                                        //         tabs: [
                                        //           Text('آره 😍',),
                                        //           Text('🥹 نه',)
                                        //         ],
                                        //       ),
                                        //     )
                                        //   ],
                                        // ),
                                        // SizedBox(height: ScreenUtil().setWidth(70)),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            formDailyMessage.data!.question,
                                            style: context.textTheme.bodyMedium,
                                          ),
                                        ),
                                        SizedBox(height: ScreenUtil().setWidth(20)),
                                        Container(
                                            height: ScreenUtil().setWidth(200),
                                            padding: EdgeInsets.only(
                                                top: ScreenUtil().setWidth(10),
                                                bottom: ScreenUtil().setWidth(10)
                                            ),
                                            decoration:  BoxDecoration(
                                              color: Color(0xffF6F6F6),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child:  Center(
                                                child:  Theme(
                                                  data: Theme.of(context).copyWith(
                                                      textSelectionTheme : TextSelectionThemeData(
                                                          selectionColor: Color(0xffaaaaaa),
                                                          cursorColor: ColorPallet().mainColor
                                                      )
                                                  ),
                                                  child:  TextField(
                                                    maxLines: 5,
                                                    maxLength: 500,
                                                    onChanged: widget.dailyMessagePresenter!.changedInput,
                                                    enableInteractiveSelection: false,
                                                    style:  context.textTheme.bodySmall,
                                                    decoration:  InputDecoration(

                                                        border: InputBorder.none,
                                                        hintText: formDailyMessage.data!.helper,
                                                        hintStyle:  context.textTheme.bodySmall!.copyWith(
                                                          color: ColorPallet().gray.withOpacity(0.5),
                                                        ),
                                                        contentPadding:  EdgeInsets.only(
                                                          right: ScreenUtil().setWidth(20),
                                                          left: ScreenUtil().setWidth(15),
                                                          bottom: ScreenUtil().setWidth(35),
                                                          top: ScreenUtil().setWidth(5),
                                                        )
                                                    ),
                                                  ),
                                                )
                                            )
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              }else{
                                return Center(
                                    child: StreamBuilder(
                                      stream: widget.dailyMessagePresenter!.tryButtonErrorObserve,
                                      builder: (context,AsyncSnapshot<bool>snapshotTryButton) {
                                        if (snapshotTryButton.data != null) {
                                          if (snapshotTryButton.data!) {
                                            return Padding(
                                                padding: EdgeInsets.only(right: ScreenUtil().setWidth(80), left: ScreenUtil().setWidth(80)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    StreamBuilder(
                                                      stream: widget.dailyMessagePresenter!.valueErrorObserve,
                                                      builder: (context,AsyncSnapshot<String>snapshotValueError) {
                                                        if (snapshotValueError.data != null) {
                                                          return Text(
                                                            snapshotValueError.data!,
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                color: Color(0xff707070),
                                                                fontWeight: FontWeight.w500,
                                                                fontSize: ScreenUtil().setSp(34)),
                                                          );
                                                        } else {
                                                          return Container();
                                                        }
                                                      },
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(top: ScreenUtil().setWidth(120)),
                                                        child: ExpertButton(
                                                          title: 'تلاش مجدد',
                                                          onPress: () {
                                                            widget.dailyMessagePresenter!.getForm();
                                                          },
                                                          enableButton: true,
                                                          isLoading: false,
                                                        ))
                                                  ],
                                                ));
                                          } else {
                                            return LoadingViewScreen(color: ColorPallet().mainColor);
                                          }
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ));
                              }
                            }else{
                              return Container();
                            }
                          }
                      );
                    }else{
                      return Container();
                    }
                  },
                )
            ),
          ),
        ),
      ),
    );
  }

}