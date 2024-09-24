import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/support_presenter.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/expert_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/firebase_analytics_helper.dart';
import 'package:impo/src/models/support/support_hostory_model.dart';
import 'package:impo/src/screens/home/tabs/profile/supportOnline/pages/chat_support_screen.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:page_transition/page_transition.dart';

class SupportHistoryScreen extends StatefulWidget{
  final SupportPresenter? supportPresenter;

  SupportHistoryScreen({Key? key,this.supportPresenter}):super(key:key);

  @override
  State<StatefulWidget> createState() => SupportHistoryScreenState();
}

class SupportHistoryScreenState extends State<SupportHistoryScreen>{

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.SupportHistoryPg_Back_NavBar_Clk);
    return Future.value(true);
  }

  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.SupportHistoryPg_Self_Pg_Load);
    AnalyticsHelper().enableEventsList([AnalyticsEvents.SupportHistoryPg_HistoryList_List_Scr]);
    widget.supportPresenter!.getHistorySupport(state: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return  WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child:  Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: <Widget>[
                CustomAppBar(
                  messages: false,
                  profileTab: true,
                  isEmptyLeftIcon: true,
                  icon: 'assets/images/ic_arrow_back.svg',
                  titleProfileTab: 'صفحه قبل',
                  subTitleProfileTab: 'پشتیبانی',
                  onPressBack: (){
                    AnalyticsHelper().log(AnalyticsEvents.SupportHistoryPg_Back_Btn_Clk);
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: ScreenUtil().setWidth(40)),
                Padding(
                  padding:  EdgeInsets.only(
                    right: ScreenUtil().setWidth(60)
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      ' تیکت‌های فعال',
                      style: context.textTheme.labelLargeProminent,
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: widget.supportPresenter!.isLoadingObserve,
                  builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                    if(snapshotIsLoading.data != null){
                      if(!snapshotIsLoading.data!){
                        return  Expanded(
                          child: StreamBuilder(
                            stream: widget.supportPresenter!.historySupportsObserve,
                            builder: (context,AsyncSnapshot<List<SupportHistoryModel>>snapshotHistories){
                              if(snapshotHistories.data != null){
                                if(snapshotHistories.data!.length != 0){
                                  return  ListView.builder(
                                    addAutomaticKeepAlives: false,

                                    padding: EdgeInsets.only(top: ScreenUtil().setWidth(15)),
                                    itemCount: snapshotHistories.data!.length,
                                    itemBuilder: (context,int index){
                                      AnalyticsHelper().log(AnalyticsEvents.SupportHistoryPg_HistoryList_List_Scr,remainEventActive: false);
                                      if(index == snapshotHistories.data!.length-1){
                                        widget.supportPresenter!.moreLoadGetHistories();
                                      }
                                      return  boxHistory(snapshotHistories.data![index],index,snapshotHistories.data!.length);
                                    },
                                  );
                                }else{
                                  return Center(
                                    child: Text(
                                        'هنوز هیچ تیکت پشتیبانی ثبت نکردی'
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
                          stream: widget.supportPresenter!.tryButtonErrorObserve,
                          builder: (context,AsyncSnapshot<bool>snapshotTryButton){
                            if(snapshotTryButton.data != null){
                              if(snapshotTryButton.data!){
                                return  Padding(
                                    padding: EdgeInsets.only(
                                        right: ScreenUtil().setWidth(80),
                                        left: ScreenUtil().setWidth(80),
                                        top: ScreenUtil().setWidth(200)
                                    ),
                                    child:  Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        StreamBuilder(
                                          stream: widget.supportPresenter!.valueErrorObserve,
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
                                                widget.supportPresenter!.getHistorySupport(state: 0);
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
                )
              ],
            )
        ),
      ),
    );
  }

  Widget boxHistory(SupportHistoryModel history,index,totalLength){
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
                    AnalyticsHelper().log(AnalyticsEvents.SupportHistoryPg_HistoryList_Item_Clk,
                    parameters: {
                      'id' : history.id
                    });
                    Navigator.pushReplacement(context,
                        PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child:  ChatSupportScreen(
                              supportPresenter: widget.supportPresenter,
                              chatId: history.id,
                              fromNotify: false,
                              // dashboardPresenter: widget.presenter,
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.asset(
                                  'assets/images/impo_icon.png'
                              ),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(20)),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${history.categoryName != '' ? history.categoryName : 'دسته بندی عمومی'}',
                                    overflow: TextOverflow.ellipsis,
                                    style:  context.textTheme.labelMediumProminent,
                                  ),
                                  Text(
                                    history.text,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style:  context.textTheme.bodySmall!.copyWith(
                                      color: Color(0xff4B454D),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setHeight(30)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '${history.time} ${history.date}',
                              style:  context.textTheme.labelSmallProminent!.copyWith(
                                color:  ColorPallet().gray.withOpacity(0.6),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                history.status == 3 ?
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
                                      history.statusText,
                                        style: context.textTheme.bodySmall!.copyWith(
                                          color: Color(int.parse(history.statusColor)),
                                        )
                                    ),
                                    // history.status == 2 ?
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: ScreenUtil().setWidth(3)
                                      ),
                                      child: SvgPicture.asset(
                                          'assets/images/ic_need_expert.svg',
                                           width: ScreenUtil().setWidth(22),
                                           height: ScreenUtil().setWidth(22),
                                           colorFilter: ColorFilter.mode(
                                             Color(int.parse(history.statusColor)),
                                             BlendMode.srcIn
                                           ),
                                      ),
                                    )
                                        // : Container()
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
            stream: widget.supportPresenter!.isMoreHistoryLoadingObserve,
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

  // Color checkColorStateHistory(int state){
  //   if(state == 1){
  //     return Color(0xffFF6A88);
  //   } else{
  //     return ColorPallet().gray.withOpacity(0.5);
  //   }
  // }
  //
  // String checkTextStateHistory(int state){
  //   if(state == 1){
  //     return 'بسته شده';
  //   }else{
  //     return 'درحال بررسی';
  //   }
  // }

}