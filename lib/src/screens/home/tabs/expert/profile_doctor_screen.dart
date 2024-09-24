import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/expert/ticket_info_model.dart';
import 'package:impo/src/screens/home/tabs/expert/item_doctor_widget.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';

import '../../../../architecture/presenter/expert_presenter.dart';
import '../../../../components/colors.dart';
import '../../../../components/custom_appbar.dart';
import '../../../../components/expert_button.dart';
import '../../../../components/loading_view_screen.dart';
import '../../../../components/my_separator.dart';
import '../../../../firebase_analytics_helper.dart';
import '../../../../models/expert/dr_info_model.dart';

class ProfileDoctorScreen extends StatefulWidget{
  final ExpertPresenter? expertPresenter;

  ProfileDoctorScreen({Key? key,this.expertPresenter}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfileDoctorScreenState();
}

class ProfileDoctorScreenState extends State<ProfileDoctorScreen>{

  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    AnalyticsHelper().enableEventsList([AnalyticsEvents.ProfileDoctorPg_CommentList_List_Scr]);
    widget.expertPresenter!.getDoctorInfo();
    scrollController.addListener(_listener);
    super.initState();
  }

  void _listener() {
    AnalyticsHelper().log(AnalyticsEvents.ProfileDoctorPg_CommentList_List_Scr,remainEventActive: false);
    if (scrollController.position.atEdge) {
      widget.expertPresenter!.moreLoadGetListCommit();
    }
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.ProfileDoctorPg_Back_NavBar_Clk);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return  WillPopScope(
        onWillPop: _onWillPop,
        child:  Directionality(
            textDirection: TextDirection.rtl,
            child:  Scaffold(
                backgroundColor: Colors.white,
                body:   StreamBuilder(
                  stream: widget.expertPresenter!.isLoadingObserve,
                  builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                    if(snapshotIsLoading.data != null){
                      if(!snapshotIsLoading.data!){
                        return StreamBuilder(
                          stream: widget.expertPresenter!.ticketInfoObserve,
                          builder: (context,AsyncSnapshot<TicketInfoAdviceModel>snapshotTicketInfo){
                            if(snapshotTicketInfo.data != null){
                              return  ListView(
                                controller: scrollController,
                                padding: EdgeInsets.zero,
                                // shrinkWrap: true,
                                addAutomaticKeepAlives: false,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
                                    child:  CustomAppBar(
                                      messages: true,
                                      profileTab: true,
                                      subTitleProfileTab: "کلینیک",
                                      valuePolar: snapshotTicketInfo.data!.currentValue.toString(),
                                      titleProfileTab: 'صفحه قبل',
                                      icon: 'assets/images/ic_arrow_back.svg',
                                      isPolar: true,
                                      onPressBack: (){
                                        AnalyticsHelper().log(AnalyticsEvents.ProfileDoctorPg_Back_Btn_Clk);
                                        Navigator.pop(context);
                                      },
                                      expertPresenter: widget.expertPresenter!,
                                    ),
                                  ),
                                  StreamBuilder(
                                    stream: widget.expertPresenter!.drInfoProfileObserve,
                                    builder: (context,AsyncSnapshot<DrInfoModel>snapshotSelectedDrInfoProfile){
                                      if(snapshotSelectedDrInfoProfile.data != null){
                                        // CommentsInfoModel comments = snapshotSelectedDrInfoProfile.data.info.comments;
                                        return Column(
                                          children: [
                                            ItemDoctorWidget(
                                              doctorInfo: snapshotSelectedDrInfoProfile.data!.info,
                                            ),
                                            SizedBox(height: ScreenUtil().setWidth(30)),
                                            Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: ScreenUtil().setWidth(30)
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(
                                                        color: Color(0xffE4E4E4),
                                                        width: ScreenUtil().setWidth(2)
                                                    )
                                                ),
                                                child: StreamBuilder(
                                                  stream: widget.expertPresenter!.counterMoreLoadObserve,
                                                  builder: (context,snapshotCounterMoreLoad){
                                                    if(snapshotCounterMoreLoad.data != null){
                                                      print(snapshotSelectedDrInfoProfile.data!.info.comments.list.length);
                                                      return ListView.builder(
                                                        padding: EdgeInsets.zero,
                                                        addAutomaticKeepAlives: false,
                                                        itemCount: snapshotSelectedDrInfoProfile.data!.info.comments.list.length,
                                                        shrinkWrap: true,
                                                        // physics: NeverScrollableScrollPhysics(),
                                                        primary: false,
                                                        itemBuilder: (context,index){
                                                          // if(index == snapshotSelectedDrInfoProfile.data.info.comments.list.length - 1){
                                                          //   print('sssssssssssssssssss');
                                                          //   widget.expertPresenter!.moreLoadGetListCommit();
                                                          // }
                                                          return Column(
                                                            children: [
                                                              index == 0 ?
                                                              Column(
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top: ScreenUtil().setWidth(10),
                                                                        right: ScreenUtil().setWidth(20),
                                                                        bottom: ScreenUtil().setWidth(5)
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          'نظرات کاربران ',
                                                                          style: context.textTheme.labelMediumProminent,
                                                                        ),
                                                                        Text(
                                                                          '(${snapshotSelectedDrInfoProfile.data!.info.comments.totalCount} نظر)',
                                                                            style: context.textTheme.labelMedium,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    color: Color(0xffF8F8F8),
                                                                    height: ScreenUtil().setWidth(1),
                                                                  ),
                                                                ],
                                                              ) : Container(),
                                                              commentItem(snapshotSelectedDrInfoProfile.data!.info.comments.list[index],
                                                                  index == snapshotSelectedDrInfoProfile.data!.info.comments.list.length - 1 ? true : false)
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }else{
                                                      return Container();
                                                    }
                                                  },
                                                )
                                            ),
                                            SizedBox(height: ScreenUtil().setWidth(30)),
                                          ],
                                        );
                                      }else{
                                        return Container();
                                      }
                                    },
                                  ),
                                ],
                              );
                            }else{
                              return Container();
                            }
                          },
                        );
                      }else{
                        return  Center(
                            child:  StreamBuilder(
                              stream: widget.expertPresenter!.tryButtonErrorObserve,
                              builder: (context,AsyncSnapshot<bool>snapshotTryButton){
                                if(snapshotTryButton.data != null){
                                  if(snapshotTryButton.data!){
                                    return  Padding(
                                        padding: EdgeInsets.only(
                                            right: ScreenUtil().setWidth(80),
                                            left: ScreenUtil().setWidth(80),
                                          top: ScreenUtil().setWidth(200),
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
                                                    widget.expertPresenter!.getDoctorInfo();
                                                  },
                                                  enableButton: true,
                                                  isLoading: false,
                                                )
                                            )
                                          ],
                                        )
                                    );
                                  }else{
                                    return  LoadingViewScreen(
                                        color: ColorPallet().mainColor
                                    );
                                  }
                                }else{
                                  return  Container();
                                }
                              },
                            )
                        );
                      }
                    }else{
                      return Container();
                    }
                  },
                )
            )
        )
    );
  }

  Widget commentItem(ListCommentsInfoModel comment,bool lastIndex){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: ScreenUtil().setWidth(20)),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(30)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                comment.userName,
                style: context.textTheme.labelMediumProminent,
              ),
              Row(
                children: [
                  Text(
                    comment.time,
                    style: context.textTheme.labelSmall!.copyWith(
                      color: Color(0xff454545),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(20)
                    ),
                    width: ScreenUtil().setWidth(1),
                    height: ScreenUtil().setWidth(50),
                    color: Color(0xffCBCBCB),
                  ),
                  Row(
                    children: [
                      Text(
                        '${comment.rate} ',
                        style: context.textTheme.labelMediumProminent!.copyWith(
                          color: Color(0xff454545),
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/images/ic_star.svg',
                        colorFilter: ColorFilter.mode(
                          Color(0xffffc404),
                          BlendMode.srcIn
                        ),
                        width: ScreenUtil().setWidth(25),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(30)
          ),
          child: Text(
            comment.descritpion,
            style: context.textTheme.bodySmall,
          ),
        ),
        comment.negatives.isEmpty && comment.positives.isEmpty ? SizedBox.shrink() :
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(30),
              vertical: ScreenUtil().setWidth(10)
          ),
          child: MySeparator(color: Color(0xffE4E4E4),height: ScreenUtil().setWidth(1),),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: comment.positives.length,
                itemBuilder: (context,index){
                  return positivesAndNegatives(comment.positives[index],Color(0xff178F32));
                },
              ),
              ListView.builder(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: comment.negatives.length,
                itemBuilder: (context,index){
                  return positivesAndNegatives(comment.negatives[index],Color(0xffEA4F4F));
                },
              )
            ],
          )
        ),
        SizedBox(height: ScreenUtil().setWidth(15)),
        !lastIndex ? Container(
          color: Color(0xffE4E4E4),
          height: ScreenUtil().setWidth(2),
        ) : Container(),
        Align(
          alignment: Alignment.center,
          child: StreamBuilder(
            stream: widget.expertPresenter!.isMoreLoadingObserve,
            builder: (context,AsyncSnapshot<bool>isMoreLoading){
              if(isMoreLoading.data != null){
                if(isMoreLoading.data!){
                  return  Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                      child:  LoadingViewScreen(
                        color: ColorPallet().mainColor,
                        width: lastIndex ?ScreenUtil().setWidth(70) : 0.0,
                      )
                  );
                }else{
                  return  Container();
                }
              }else{
                return Container();
              }
            },
          ),
        )
      ],
    );
  }

  Widget positivesAndNegatives(String item,Color boxColor){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: ScreenUtil().setWidth(17),
          height:  ScreenUtil().setWidth(17),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: boxColor
          ),
        ),
        SizedBox(width: ScreenUtil().setWidth(10)),
        Text(
          item,
          style: context.textTheme.bodySmall!.copyWith(
            color: Color(0xff454545),
          ),
        )
      ],
    );
  }
}
