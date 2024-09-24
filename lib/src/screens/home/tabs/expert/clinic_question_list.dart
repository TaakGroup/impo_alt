
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/expert_presenter.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/expert_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/models/expert/tickets_model.dart';
import 'package:impo/src/screens/home/home.dart';
import 'package:impo/src/screens/home/tabs/expert/chat_screen.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../firebase_analytics_helper.dart';

class ClinicQuestionList extends StatefulWidget{
  final currentValue;
  final ExpertPresenter? expertPresenter;
  final bool? isAllTicket;
  ClinicQuestionList({Key? key,this.currentValue,this.expertPresenter,this.isAllTicket}):super(key:key);
  @override
  State<StatefulWidget> createState() => ClinicQuestionListState();
}

class ClinicQuestionListState extends State<ClinicQuestionList>{

 // ScrollController _scrollController;

  @override
  void initState() {
    widget.expertPresenter!.setTypeTicketInit(widget.isAllTicket!);
    // _scrollController =  ScrollController();
    widget.expertPresenter!.getTickets(state: 0);
    super.initState();
  }

  Future<bool> _onWillPop()async{
    /// Navigator.push(
    ///   context,
    ///   PageTransition(
    ///       settings: RouteSettings(name: "/Page1"),
    ///     type: PageTransitionType.fade,
    ///    child: FeatureDiscovery(
    ///         recordStepsInSharedPreferences: true,
    ///         child: ExpertScreen(
    ///           randomMessage: widget.randomMessage,
    ///           expertPresenter: widget.expertPresenter!,
    ///           currentValue: widget.currentValue,
    ///         )
    ///     )
    ///   )
    /// );
    AnalyticsHelper().log(AnalyticsEvents.ClinicQuestionList_Back_NavBar_Clk);
    Navigator.push(
        context,
        PageTransition(
            settings: RouteSettings(name: "/Page1"),
            type: PageTransitionType.fade,
            child: FeatureDiscovery(
                recordStepsInSharedPreferences: true,
                child: Home(
                  indexTab: 1,
                  isChangeStatus: false,
                )
            )
        )
    );
    return Future.value(false);
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = 0.5;
    return  WillPopScope(
      onWillPop: _onWillPop,
      child:  Directionality(
        textDirection: TextDirection.rtl,
        child:  Scaffold(
          backgroundColor: Colors.white,
          body:  Column(
            children: <Widget>[
               Padding(
                padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
                child:  CustomAppBar(
                  messages: true,
                  profileTab: true,
                  valuePolar: widget.currentValue.toString(),
                  subTitleProfileTab: "کلینیک",
                  titleProfileTab: 'صفحه قبل',
                  icon: 'assets/images/ic_arrow_back.svg',
                  isPolar: true,
                  onPressBack: (){
                    AnalyticsHelper().log(AnalyticsEvents.ClinicQuestionList_Back_Btn_Clk);
                    _onWillPop();
                  },
                  expertPresenter: widget.expertPresenter!,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(30)),
              Align(
                alignment: Alignment.center,
                child:  Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(420),
                      ),
                      child: SvgPicture.asset(
                        'assets/images/ic_main_expert.svg',
                        width: ScreenUtil().setWidth(150),
                        height: ScreenUtil().setWidth(150),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil().setWidth(20),
                      ),
                      child: Text(
                        'تاریخچه مشاوره‌ها',
                        style:  context.textTheme.headlineMedium!.copyWith(
                          color: ColorPallet().gray,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(40)),
              StreamBuilder(
                stream: widget.expertPresenter!.isLoadingObserve,
                builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                  if(snapshotIsLoading.data != null){
                    if(!snapshotIsLoading.data!){
                      return  Expanded(
                        child:  StreamBuilder(
                          stream: widget.expertPresenter!.ticketsListObserve,
                          builder: (context,AsyncSnapshot<List<TicketsModel>>snapshotTickets){
                            if(snapshotTickets.data != null){
                              if(snapshotTickets.data!.length != 0){
                                return  StreamBuilder(
                                  stream: widget.expertPresenter!.counterMoreLoadObserve,
                                  builder: (context,counterMoreLoad){
                                    if(counterMoreLoad.data != null){
                                      return   ListView.builder(
                                        addAutomaticKeepAlives: false,
                                        padding: EdgeInsets.only(top: ScreenUtil().setWidth(15)),
                                        itemCount: snapshotTickets.data!.length,
                                        itemBuilder: (context,int index){
                                          if(index == snapshotTickets.data!.length-1){
                                            widget.expertPresenter!.moreLoadGetTickets();
                                          }
                                          return  boxQuestion(snapshotTickets.data![index],index,snapshotTickets.data!.length);
                                        },
                                      );
                                    }else{
                                      return  Container();
                                    }
                                  },
                                );
                              }else{
                                return Center(
                                  child: Text(
                                    'شما تا به حال مشاوره فعالی نداشته‌اید'
                                  ),
                                );
                              }
                            }else{
                              return  Container();
                            }
                          },
                        ),
                      );
                    }else{
                      return  StreamBuilder(
                        stream: widget.expertPresenter!.tryButtonErrorObserve,
                        builder: (context,AsyncSnapshot<bool>snapshotTryButton){
                          if(snapshotTryButton.data != null){
                            if(snapshotTryButton.data!){
                              return  Padding(
                                  padding: EdgeInsets.only(
                                      right: ScreenUtil().setWidth(80),
                                      left: ScreenUtil().setWidth(80),
                                      top : ScreenUtil().setWidth(200)
                                  ),
                                  child:  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      StreamBuilder(
                                        stream: widget.expertPresenter!.valueErrorObserve,
                                        builder: (context,AsyncSnapshot<String>snapshotValueError){
                                          if(snapshotValueError.data != null){
                                            return   Text(
                                              snapshotValueError.data!,
                                              textAlign: TextAlign.center,
                                                style:  context.textTheme.bodyMedium!.copyWith(
                                                  color: Color(0xff707070),
                                                )
                                            );
                                          }else{
                                            return  Container();
                                          }
                                        },
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: ScreenUtil().setWidth(32)
                                          ),
                                          child:    ExpertButton(
                                            title: 'تلاش مجدد',
                                            onPress: (){
                                              widget.expertPresenter!.getTickets(state: 0);
                                            },
                                            enableButton: true,
                                            isLoading: false,
                                          )
                                      )
                                    ],
                                  )
                              );
                            }else{
                              return  Expanded(
                                child:  Center(
                                  child:  LoadingViewScreen(
                                      color: ColorPallet().mainColor
                                  ),
                                ),
                              );
                            }
                          }else{
                            return  Container();
                          }
                        },
                      );
                    }
                  }else{
                    return  Container();
                  }
                },
              ),
              /// StreamBuilder(
              ///   stream: widget.expertPresenter!.ticketsListObserve,
              ///   builder: (context,AsyncSnapshot<List<TicketsModel>>snapshotTickets){
              ///     if(snapshotTickets.data != null){
              ///       if(snapshotTickets.data.length !=0){
              ///         return  StreamBuilder(
              ///           stream: widget.expertPresenter!.isLoadingObserve,
              ///           builder: (context,snapshotIsLoading){
              ///             if(snapshotIsLoading.data != null){
              ///               if(!snapshotIsLoading.data){
              ///                 return   sendQuestionButton();
              ///               }else{
              ///                 return  Container();
              ///               }
              ///             }else{
              ///              return  Container();
              ///            }
              ///          },
              ///        );
              ///       }else{
              ///         return  Container();
              ///       }
              ///     }else{
              ///       return  Container();
              ///     }
              ///   },
              /// )
            ],
          ),
        ),
      ),
    );
  }

  Widget boxQuestion(TicketsModel ticketsModel,index,totalLength){
    return  Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(
                  right: ScreenUtil().setWidth(50),
                  left: ScreenUtil().setWidth(50),
                  bottom: ScreenUtil().setWidth(30)
              ),
              decoration:  BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff5F9BDF).withOpacity(0.3),
                      blurRadius: 5.0,
                    )
                  ],
                  borderRadius: BorderRadius.circular(20)
              ),
              child:  Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(7),
                child:  InkWell(
                  onTap: (){
                    AnalyticsHelper().log(
                        AnalyticsEvents.ClinicQuestionList_TicketList_Item_Clk,
                      parameters: {
                          'id' : ticketsModel.ticketId
                      }
                    );
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child:  ChatScreen(
                              expertPresenter: widget.expertPresenter!,
                              chatId: ticketsModel.ticketId,
                              fromMainExpert: false,
                              fromActiveClini: false,
                            )
                        )
                    );
                  },
                  splashColor: Color(0xffA684EB).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(7),
                  child:  Container(
                    padding: EdgeInsets.all(
                        ScreenUtil().setWidth(20)
                    ),
                    child:  Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                                child: ticketsModel.drValid ?
                                ticketsModel.drImage != '' ?
                                Container(
                                  height: ScreenUtil().setWidth(115),
                                  width: ScreenUtil().setWidth(115),
                                  decoration:  BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Color(0xffF2F2F2),
                                          width: ScreenUtil().setWidth(2)
                                      ),
                                      image:  DecorationImage(
                                        fit: BoxFit.cover,
                                          image: NetworkImage(
                                            '$mediaUrl/file/${ticketsModel.drImage}',
                                          )
                                      )
                                  ),
                                ) :
                                Container(
                                  padding: EdgeInsets.all(
                                      ScreenUtil().setWidth(17)
                                  ),
                                  decoration: BoxDecoration(
                                      color: ColorPallet().gray.withOpacity(0.07),
                                      shape: BoxShape.circle
                                  ),
                                  child: SvgPicture.asset(
                                      'assets/images/ic_unknown.svg'
                                  ),
                                )
                                    :   Container(
                                  padding: EdgeInsets.all(
                                      ScreenUtil().setWidth(17)
                                  ),
                                  decoration: BoxDecoration(
                                      color: ColorPallet().gray.withOpacity(0.07),
                                      shape: BoxShape.circle
                                  ),
                                  child: SvgPicture.asset(
                                      'assets/images/ic_unknown.svg'
                                  ),
                                )
                            ),
                            SizedBox(width: ScreenUtil().setWidth(20)),
                            Flexible(
                                flex: 4,
                                child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      ticketsModel.drValid ? ticketsModel.drName : 'نا مشخص',
                                        style:  context.textTheme.labelMediumProminent!.copyWith(
                                          color: ticketsModel.drValid ? ColorPallet().mainColor : ColorPallet().gray,
                                        )
                                    ),
                                    ticketsModel.drValid ?
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: ScreenUtil().setWidth(5)
                                        ),
                                        child:  Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Flexible(
                                                flex: 2,
                                                child:  ticketsModel.drValid ?
                                                Text(
                                                  ticketsModel.drAcadimicCertificate,
                                                  style:  context.textTheme.bodySmall!.copyWith(
                                                    color: ColorPallet().gray,
                                                  ),
                                                ) :  Container(width: 0,height: 0,)
                                            ),
                                          ],
                                        )
                                    )
                                        :  Container(width: 0,height: 0,)
                                  ],
                                )
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Flexible(
                              child:  Container(),
                            ),
                            Flexible(
                              flex: 4,
                              child:  Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(5),
                                        right: ScreenUtil().setWidth(15)
                                    ),
                                    height: ScreenUtil().setWidth(30),
                                    width: ScreenUtil().setWidth(1),
                                    color:  ColorPallet().gray.withOpacity(0.6),
                                  ),
                                  Flexible(
                                      child:  Container(
                                        // alignment: Alignment.center,
                                          child:  Text(
                                            ticketsModel.text != '' ? ticketsModel.text : 'فایل',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style:  context.textTheme.labelSmall!.copyWith(
                                              color: ColorPallet().gray.withOpacity(0.6),
                                            ),
                                          )
                                      )
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setHeight(10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '${ticketsModel.time} ${ticketsModel.date}',
                                style: context.textTheme.labelMedium!.copyWith(
                                  color:  ColorPallet().gray.withOpacity(0.6),
                                )
                            ),
                            Row(
                              children: <Widget>[
                                checkIsRate(ticketsModel),
                                ticketsModel.state == 3 ?
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(10)
                                  ),
                                  height: ScreenUtil().setWidth(30),
                                  width: ScreenUtil().setWidth(3),
                                  color: Color(0xff9F9F9F).withOpacity(0.3),
                                ) :  Container(),
                                Row(
                                  children: [
                                    Text(
                                      checkTextStateQuestion(ticketsModel.state),
                                        style:  context.textTheme.labelMedium!.copyWith(
                                          color: checkColorStateQuestion(ticketsModel.state),
                                        )
                                    ),
                                    ticketsModel.state == 2 ?
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: ScreenUtil().setWidth(3)
                                      ),
                                      child: SvgPicture.asset(
                                          'assets/images/ic_need_expert.svg'
                                      ),
                                    )
                                        : Container()
                                  ],
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
          ),
          StreamBuilder(
            stream: widget.expertPresenter!.isMoreLoadingObserve,
            builder: (context,AsyncSnapshot<bool>isMoreLoading){
              if(isMoreLoading.data != null){
                if(isMoreLoading.data!){
                  return  Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                      child:  LoadingViewScreen(
                        color: ColorPallet().mainColor,
                        width: index == totalLength-1 ?ScreenUtil().setWidth(70) : 0.0,
                      )
                  );
                }else{
                  return  Container();
                }
              }else{
                return  Padding(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                    child:  LoadingViewScreen(
                      color: ColorPallet().mainColor,
                      width: index == totalLength-1 ?ScreenUtil().setWidth(70) : 0.0,
                    )
                );
              }
            },
          )
        ]
    );

  }


  Color checkColorStateQuestion(int state){
    if(state == 2){
      return ColorPallet().emotionalMain;
    }else if(state == 3){
      return ColorPallet().gray.withOpacity(0.5);
    }else if(state == 4){
      return Color(0xffFF6A88);
    }else if(state == 5){
      return Color(0xffe4a607);
    } else{
      return ColorPallet().gray.withOpacity(0.5);
    }
  }

  String checkTextStateQuestion(int state){
    if(state == 2){
      return 'نیاز به پاسخ دهی شما';
    }else if(state == 3){
      return 'بسته شده';
    }else if(state == 4){
      return 'رد شده';
    }else if(state == 5){
      return 'در انتظار پرداخت';
    } else{
      return 'درحال بررسی';
    }
  }

  Widget checkIsRate(TicketsModel ticketsModel){
    if(ticketsModel.isRate){
      return   Directionality(
          textDirection: TextDirection.ltr,
          child: RatingBar.builder(
            initialRating: ticketsModel.rate,
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            ignoreGestures: true,
            itemCount: 5,
            itemSize: ScreenUtil().setWidth(25),
            itemPadding: EdgeInsets.symmetric(horizontal:ScreenUtil().setWidth(2)),
            itemBuilder: (context, _) => SvgPicture.asset('assets/images/ic_star.svg'),
            unratedColor: Color(0xff707070).withOpacity(0.35),
            onRatingUpdate: (rating) {
              debugPrint(rating.toString());
            },
          )
      );
    }else if(!ticketsModel.isRate && ticketsModel.state == 3){
      return  Text(
        'امتیاز به متخصص',
          style:  context.textTheme.labelMedium!.copyWith(
            color: ColorPallet().mentalMain,
          )
      );
    }else{
      return  Container();
    }
  }


}