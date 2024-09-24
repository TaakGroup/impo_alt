import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/sharing_experience_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/dialogs/qus_dialog.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/firebase_analytics_helper.dart';
import 'package:impo/src/models/sharing_experience/comment_experience_model.dart';
import 'package:impo/src/screens/home/tabs/calender/photo_page_screen.dart';
import 'package:impo/src/screens/home/tabs/main/sharing_experience/sharing_experience_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../components/expert_button.dart';

class CommentShareExpScreen extends StatefulWidget{
  final SharingExperiencePresenter? sharingExperiencePresenter;
  final String? shareId;
  final isSelf;
  final int? indexShareExp;
  final bool? fromNotify;

  CommentShareExpScreen({Key? key,this.sharingExperiencePresenter,this.shareId,this.isSelf
   ,this.indexShareExp,this.fromNotify}):super(key:key);

  @override
  State<StatefulWidget> createState() => CommentShareExpScreenState();
}

class CommentShareExpScreenState extends State<CommentShareExpScreen> with TickerProviderStateMixin{


  late AnimationController animationControllerScaleButton;
  Animations animations =  Animations();
  int modePress = 0;
  ScrollController scrollController = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.ComntShareExpPg_Self_Pg_Load);
    AnalyticsHelper().enableEventsList([AnalyticsEvents.ComntShareExpPg_AllCommentExp_List_Scr]);
    widget.sharingExperiencePresenter!.savePosition();
    animationControllerScaleButton = animations.pressButton(this);
    widget.sharingExperiencePresenter!.initialDialogScale(this);
    widget.sharingExperiencePresenter!.getCommentShareExperience(state: 0,shareId: widget.shareId);
    scrollController.addListener(_listener);
    super.initState();
  }

  void _listener() {
    AnalyticsHelper().log(AnalyticsEvents.ComntShareExpPg_AllCommentExp_List_Scr,remainEventActive: false);
    if (scrollController.position.atEdge) {
      widget.sharingExperiencePresenter!.moreLoadGetCommentExp(widget.shareId);
    }
  }

  @override
  void dispose() {
    animationControllerScaleButton.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.ComntShareExpPg_Back_NavBar_Clk);
    if(widget.fromNotify != null){
      Navigator.pushReplacement(context,
          PageTransition(
              type: PageTransitionType.bottomToTop,
              child:  SharingExperienceScreen(
                // dashboardPresenter: widget.presenter,
              )
          )
      );
    }else{
      widget.sharingExperiencePresenter!.scrollController!.jumpTo(widget.sharingExperiencePresenter!.keepPosition);
      Navigator.pop(context);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = .5;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              StreamBuilder(
                stream: widget.sharingExperiencePresenter!.isLoadingObserve,
                builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                  if(snapshotIsLoading.data != null){
                    if(!snapshotIsLoading.data!){
                      return SingleChildScrollView(
                        controller: scrollController,
                        child: StreamBuilder(
                          stream: widget.sharingExperiencePresenter!.commentsListObserve,
                          builder: (context,AsyncSnapshot<List<ListCommentExperienceModel>>snapshotComments){
                            if(snapshotComments.data != null){
                              return Column(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          bottom: ScreenUtil().setWidth(15)
                                      ),
                                      child: CustomAppBar(
                                        messages: false,
                                        profileTab: true,
                                        icon: 'assets/images/ic_arrow_back.svg',
                                        titleProfileTab: 'صفحه قبل',
                                        subTitleProfileTab: 'اشتراک تجربه',
                                        onPressBack: (){
                                          AnalyticsHelper().log(AnalyticsEvents.ComntShareExpPg_Back_Btn_Clk);
                                          if(widget.fromNotify != null){
                                            Navigator.push(context,
                                                PageTransition(
                                                    type: PageTransitionType.bottomToTop,
                                                    child:  SharingExperienceScreen(
                                                      // dashboardPresenter: widget.presenter,
                                                    )
                                                )
                                            );
                                          }else{
                                            widget.sharingExperiencePresenter!.scrollController!.jumpTo(widget.sharingExperiencePresenter!.keepPosition);
                                            Navigator.pop(context);
                                          }
                                        },
                                        infoShareExp: true,
                                      )
                                  ),
                                  SizedBox(height: ScreenUtil().setWidth(15)),
                                  StreamBuilder(
                                    stream: widget.sharingExperiencePresenter!.commentExperiencesObserve,
                                    builder: (context,AsyncSnapshot<CommentExperienceModel>comment){
                                      if(comment.data != null){
                                        return header(comment.data!);
                                      }else{
                                        return Container();
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(30)
                                    ),
                                    child: Divider(
                                      color: Colors.black.withOpacity(0.06),
                                    ),
                                  ),
                                  SizedBox(height: ScreenUtil().setWidth(20)),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(30)
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        snapshotComments.data!.length != 0 ?
                                        Text(
                                          'پاسخ های بقیه',
                                          style: TextStyle(
                                              color: Color(0xff262527),
                                              fontWeight: FontWeight.w700,
                                              fontSize: ScreenUtil().setSp(32)
                                          ),
                                        ) :
                                        Center(
                                          child: Padding(
                                            padding:  EdgeInsets.only(
                                              top: ScreenUtil().setWidth(80)
                                            ),
                                            child: Column(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/empty_state_comment.svg',
                                                  width: ScreenUtil().setWidth(300),
                                                  fit: BoxFit.cover,
                                                ),
                                                SizedBox(height: ScreenUtil().setHeight(30)),
                                                Text(
                                                  widget.isSelf ?
                                                  'هنوز هیچ نظری برای تجربه تو ثبت نشده' : 'اولین نظر رو برای این تجربه، ثبت کن',
                                                  style: TextStyle(
                                                      color: Color(0xff262527),
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: ScreenUtil().setSp(26)
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            right: ScreenUtil().setWidth(80),
                                            top: ScreenUtil().setWidth(30)
                                          ),
                                          child: ListView.separated(
                                            itemCount: snapshotComments.data!.length,
                                            shrinkWrap: true,
                                            addAutomaticKeepAlives: false,
                                            primary: false,
                                            padding: EdgeInsets.zero,
                                            physics: NeverScrollableScrollPhysics(),
                                            separatorBuilder: (context,int index){
                                              return Divider(
                                                color: Colors.black.withOpacity(0.06),
                                              );
                                            },
                                            itemBuilder: (context,int index){
                                              return Padding(
                                                padding:  EdgeInsets.only(
                                                  top: ScreenUtil().setWidth(20)
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Image.network(
                                                          snapshotComments.data![index].avatar,
                                                          fit: BoxFit.cover,
                                                          width: ScreenUtil().setWidth(80),
                                                          height: ScreenUtil().setWidth(80),
                                                        ),
                                                        SizedBox(width: ScreenUtil().setWidth(13)),
                                                        Flexible(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        snapshotComments.data![index].selfComment ?
                                                                        'نظر تو' : snapshotComments.data![index].name,
                                                                        style: TextStyle(
                                                                            color: ColorPallet().mainColor,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: ScreenUtil().setSp(28)
                                                                        ),
                                                                      ),
                                                                      !snapshotComments.data![index].selfComment &&
                                                                       snapshotComments.data![index].approvedProfile ?
                                                                      SvgPicture.asset(
                                                                        'assets/images/verify.svg',
                                                                        width: ScreenUtil().setWidth(30),
                                                                        height: ScreenUtil().setWidth(30),
                                                                      ) : SizedBox.shrink()
                                                                    ],
                                                                  ),
                                                                  Text(
                                                                    snapshotComments.data![index].createDateTime,
                                                                    style: TextStyle(
                                                                        color: Color(0xffABABAB),
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: ScreenUtil().setSp(22)
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Text(
                                                                snapshotComments.data![index].text,
                                                                style: TextStyle(
                                                                    color: Color(0xff0C0C0D),
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: ScreenUtil().setSp(24)
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(height: ScreenUtil().setHeight(30)),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        snapshotComments.data![index].selfComment ?
                                                        StreamBuilder(
                                                          stream: animations.squareScaleBackButtonObserve,
                                                          builder: (context,AsyncSnapshot<double>snapshotScale){
                                                            if(snapshotScale.data != null){
                                                              return Transform.scale(
                                                                scale: snapshotComments.data![index].selected && modePress == 0 ? snapshotScale.data : 1.0,
                                                                child: GestureDetector(
                                                                  onTap: (){
                                                                    setState(() {
                                                                      modePress = 0;
                                                                    });
                                                                    animationControllerScaleButton.reverse();
                                                                    for(int i=0 ; i <snapshotComments.data!.length; i++){
                                                                      if(snapshotComments.data![i].selected){
                                                                        snapshotComments.data![i].selected = false;
                                                                      }
                                                                    }

                                                                    snapshotComments.data![index].selected = !snapshotComments.data![index].selected;
                                                                    AnalyticsHelper().log(AnalyticsEvents.ComntShareExpPg_RemoveExp_Btn_Clk);
                                                                    widget.sharingExperiencePresenter!.showCommentExpDialog(index);
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    'assets/images/ic_delete.svg',
                                                                    width: ScreenUtil().setWidth(45),
                                                                    height: ScreenUtil().setWidth(45),
                                                                  ),
                                                                ),
                                                              );
                                                            }else{
                                                              return Container();
                                                            }
                                                          },
                                                        )
                                                        : SizedBox.shrink(),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  snapshotComments.data![index].likeCount.toString(),
                                                                  style: TextStyle(
                                                                      color: Color(0xff0C0C0D),
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: ScreenUtil().setSp(28)
                                                                  ),
                                                                ),
                                                                SizedBox(width: ScreenUtil().setWidth(3)),
                                                                snapshotComments.data![index].selfComment ?
                                                                SvgPicture.asset(
                                                                  'assets/images/like_empty.svg',
                                                                  colorFilter: ColorFilter.mode(
                                                                    Color(0xff707070),
                                                                    BlendMode.srcIn
                                                                  ),
                                                                  width: ScreenUtil().setWidth(45),
                                                                  height: ScreenUtil().setWidth(45),
                                                                )
                                                                    :   snapshotComments.data![index].state == 1 ?
                                                                GestureDetector(
                                                                  onTap: (){
                                                                    AnalyticsHelper().log(AnalyticsEvents.ComntShareExpPg_ComntRemoveLike_Icon_Clk,parameters: {'commentId' : snapshotComments.data![index].id});
                                                                    widget.sharingExperiencePresenter!.removeLikeCommentShareExp(index,context,true,widget.shareId!);
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    'assets/images/like_full.svg',
                                                                    width: ScreenUtil().setWidth(45),
                                                                    height: ScreenUtil().setWidth(45),
                                                                    colorFilter: ColorFilter.mode(
                                                                      ColorPallet().mainColor,
                                                                      BlendMode.srcIn
                                                                    ),
                                                                  ),
                                                                )
                                                                    :  GestureDetector(
                                                                    onTap: (){
                                                                      AnalyticsHelper().log(AnalyticsEvents.ComntShareExpPg_ComntLike_Icon_Clk,parameters: {'commentId' : snapshotComments.data![index].id});
                                                                      widget.sharingExperiencePresenter!.likeCommentShareExp(index,context,widget.shareId!);
                                                                    },
                                                                    child: SvgPicture.asset(
                                                                      'assets/images/like_empty.svg',
                                                                      width: ScreenUtil().setWidth(45),
                                                                      height: ScreenUtil().setWidth(45),
                                                                      colorFilter: ColorFilter.mode(
                                                                        Color(0xff707070),
                                                                        BlendMode.srcIn
                                                                      ),
                                                                    )
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(width: ScreenUtil().setWidth(30)),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  snapshotComments.data![index].disliked.toString(),
                                                                  style: TextStyle(
                                                                      color: Color(0xff0C0C0D),
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: ScreenUtil().setSp(28)
                                                                  ),
                                                                ),
                                                                SizedBox(width: ScreenUtil().setWidth(3)),
                                                                snapshotComments.data![index].selfComment ?
                                                                SvgPicture.asset(
                                                                  'assets/images/dislike_empty.svg',
                                                                  colorFilter: ColorFilter.mode(
                                                                    Color(0xff707070),
                                                                    BlendMode.srcIn
                                                                  ),
                                                                  width: ScreenUtil().setWidth(45),
                                                                  height: ScreenUtil().setWidth(45),
                                                                )
                                                                    :   snapshotComments.data![index].state == 2 ?
                                                                GestureDetector(
                                                                  onTap: (){
                                                                    AnalyticsHelper().log(AnalyticsEvents.ComntShareExpPg_ComntRemoveDislike_Icon_Clk,parameters: {'commentId' : snapshotComments.data![index].id});
                                                                    widget.sharingExperiencePresenter!.removeLikeCommentShareExp(index,context,false,widget.shareId!);
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    'assets/images/dislike_full.svg',
                                                                    colorFilter: ColorFilter.mode(
                                                                        ColorPallet().mainColor,
                                                                        BlendMode.srcIn
                                                                    ),
                                                                    width: ScreenUtil().setWidth(45),
                                                                    height: ScreenUtil().setWidth(45),
                                                                  ),
                                                                ) :
                                                                GestureDetector(
                                                                  onTap: (){
                                                                    AnalyticsHelper().log(AnalyticsEvents.ComntShareExpPg_ComntDislike_Icon_Clk,parameters: {'commentId' : snapshotComments.data![index].id});
                                                                    widget.sharingExperiencePresenter!.disLikeCommentShareExp(index,context,widget.shareId!);
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                    'assets/images/dislike_empty.svg',
                                                                    colorFilter: ColorFilter.mode(
                                                                        Color(0xff707070),
                                                                        BlendMode.srcIn
                                                                    ),
                                                                    width: ScreenUtil().setWidth(45),
                                                                    height: ScreenUtil().setWidth(45),
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(height: ScreenUtil().setHeight(140)),
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
                      );
                    }else{
                      return Center(
                          child: StreamBuilder(
                            stream: widget.sharingExperiencePresenter!.tryButtonErrorObserve,
                            builder: (context,AsyncSnapshot<bool>snapshotTryButton) {
                              if (snapshotTryButton.data != null) {
                                if (snapshotTryButton.data!) {
                                  return Padding(
                                      padding: EdgeInsets.only(
                                          right: ScreenUtil().setWidth(80),
                                          left: ScreenUtil().setWidth(80)),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          StreamBuilder(
                                            stream: widget.sharingExperiencePresenter!.valueErrorObserve,
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
                                              padding:
                                              EdgeInsets.only(top: ScreenUtil().setWidth(120)),
                                              child: ExpertButton(
                                                title: 'تلاش مجدد',
                                                onPress: () {
                                                  widget.sharingExperiencePresenter!.getCommentShareExperience(state: 0,shareId: widget.shareId);
                                                },
                                                enableButton: true,
                                                isLoading: false,
                                              )
                                          )
                                        ],
                                      )
                                  );
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
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: StreamBuilder(
                  stream: widget.sharingExperiencePresenter!.isShowDeleteCommentExpDialogObserve,
                  builder: (context,AsyncSnapshot<bool>snapshotShowDialog){
                    if(snapshotShowDialog.data != null){
                      if(!snapshotShowDialog.data!){
                        return StreamBuilder(
                          stream: widget.sharingExperiencePresenter!.isLoadingObserve,
                          builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                            if(snapshotIsLoading.data != null){
                              if(!snapshotIsLoading.data!){
                                return Container(
                                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(15)),
                                  color: Colors.white,
                                  child: Container(
                                      margin: EdgeInsets.only(
                                        right: ScreenUtil().setWidth(30),
                                        left: ScreenUtil().setWidth(30),
                                        bottom: ScreenUtil().setWidth(20),
                                      ),

                                      decoration:  BoxDecoration(
                                        color: Color(0xffF6F6F6),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                            color: ColorPallet().mainColor
                                        ),
                                      ),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxHeight: ScreenUtil().setWidth(150),
                                        ),
                                        child: Stack(
                                          alignment: Alignment.bottomLeft,
                                          children: [
                                            Theme(
                                              data: Theme.of(context).copyWith(
                                                textSelectionTheme: TextSelectionThemeData(
                                                    selectionColor: Color(0xffaaaaaa),
                                                    cursorColor: ColorPallet().mainColor
                                                ),
                                              ),
                                              child:  TextFormField(
                                                autofocus: false,
                                                onChanged: (value){
                                                  widget.sharingExperiencePresenter!.onChangeCommentTextField(value,context);
                                                },
                                                style:  TextStyle(
                                                    fontSize: ScreenUtil().setSp(28),
                                                    color: Color(0xff0C0C0D),
                                                    fontWeight: FontWeight.w400
                                                ),
                                                maxLength: 300,
                                                maxLines: null,
                                                decoration:  InputDecoration(
                                                  isDense: true,
                                                  counterText: '',
                                                  border: InputBorder.none,
                                                  hintText: 'نظرت رو در مورد این تجربه بنویس',
                                                  hintStyle:  TextStyle(
                                                      fontSize: ScreenUtil().setSp(26),
                                                      color: ColorPallet().gray,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                  contentPadding:  EdgeInsets.only(
                                                      right: ScreenUtil().setWidth(30),
                                                      left: ScreenUtil().setWidth(180),
                                                      bottom: ScreenUtil().setWidth(17)
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: ScreenUtil().setWidth(3),
                                                left: ScreenUtil().setWidth(3),
                                                top: ScreenUtil().setWidth(3),
                                                bottom: ScreenUtil().setWidth(3),
                                              ),
                                              child: SizedBox(
                                                  width: ScreenUtil().setWidth(160),
                                                  child: StreamBuilder(
                                                    stream: widget.sharingExperiencePresenter!.commentTextSendObserve,
                                                    builder: (context,AsyncSnapshot<String>snapshotTextSend){
                                                      if(snapshotTextSend.data != null){
                                                        return StreamBuilder(
                                                          stream: widget.sharingExperiencePresenter!.isLoadingButtonObserve,
                                                          builder: (context,snapshotIsLoadingButton){
                                                            if(snapshotIsLoadingButton.data != null){
                                                              return CustomButton(
                                                                title: 'ارسال',
                                                                onPress: (){
                                                                  if(snapshotTextSend.data!.length >= 5){
                                                                    AnalyticsHelper().log(AnalyticsEvents.ComntShareExpPg_SendExp_Btn_Clk);
                                                                    widget.sharingExperiencePresenter!.sendCommentShareExp(_scaffoldKey.currentContext,widget.sharingExperiencePresenter!,widget.shareId!,widget.indexShareExp);
                                                                  }
                                                                },
                                                                height: ScreenUtil().setWidth(80),
                                                                // height: ScreenUtil().setWidth(200),
                                                                margin: 0,
                                                                colors: [ColorPallet().mainColor,ColorPallet().mainColor],
                                                                borderRadius: 16.0,
                                                                isLoadingButton: snapshotIsLoadingButton.data,
                                                                enableButton: snapshotTextSend.data!.length >=5 ? true : false,
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
                                                  )
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                  ),
                                );
                              }else{
                                return SizedBox.shrink();
                              }
                            }else{
                              return Container();
                            }
                          },
                        );
                      }else{
                        return SizedBox.shrink();
                    }
                    }else{
                      return Container();
                    }
                  },
                )
              ),
              StreamBuilder(
                stream: widget.sharingExperiencePresenter!.isShowDeleteCommentExpDialogObserve,
                builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog){
                  if(snapshotIsShowDialog.data != null){
                    if(snapshotIsShowDialog.data!){
                      return  StreamBuilder(
                        stream: widget.sharingExperiencePresenter!.isLoadingButtonObserve,
                        builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                          if(snapshotIsLoading.data != null){
                            return QusDialog(
                              scaleAnim: widget.sharingExperiencePresenter!.dialogScaleObserve,
                              onPressCancel: (){
                                AnalyticsHelper().log(AnalyticsEvents.ComntShareExpPg_RemoveExpNoDlg_Btn_Clk);
                                widget.sharingExperiencePresenter!.onPressCancelCommentExpDialog();
                              },
                              value: "مطمئنی می‌خوای کامنت تجربه‌ رو پاک کنی؟",
                              yesText: 'آره پاک میکنم',
                              noText: 'نه',
                              onPressYes: (){
                                if(!snapshotIsLoading.data!){
                                  AnalyticsHelper().log(AnalyticsEvents.ComntShareExpPg_RemoveExpYesDlg_Btn_Clk);
                                  widget.sharingExperiencePresenter!.deleteCommentExp(_scaffoldKey.currentContext,widget.shareId!,widget.indexShareExp);
                                }
                              },
                              isIcon: true,
                              colors: [Colors.white,Colors.white],
                              topIcon: 'assets/images/ic_delete_dialog.svg',
                              isLoadingButton: snapshotIsLoading.data,
                            );
                          }else{
                            return Container();
                          }
                        },
                      );
                    }else{
                      return  Container();
                    }
                  }else{
                    return  Container();
                  }
                },
              ),
            ],
          )
        ),
      ),
    );
  }

  header(CommentExperienceModel comment){
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(30)
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(20),
            vertical: ScreenUtil().setWidth(15)
        ),
        margin: EdgeInsets.only(
            bottom: ScreenUtil().setWidth(50)
        ),
        decoration: BoxDecoration(
            color: Color(0xffF9F9F9),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
                bottomLeft: Radius.circular(12)
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  comment.avatar,
                  fit: BoxFit.cover,
                  width: ScreenUtil().setWidth(80),
                  height: ScreenUtil().setWidth(80),
                ),
                SizedBox(width: ScreenUtil().setWidth(13)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.isSelf ? 'تجربه تو' : comment.name,
                          style: TextStyle(
                              color: ColorPallet().mainColor,
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(28)
                          ),
                        ),
                        widget.isSelf ?
                        SizedBox.shrink() :
                        comment.approvedProfile ?
                        SvgPicture.asset(
                          'assets/images/verify.svg',
                          width: ScreenUtil().setWidth(30),
                          height: ScreenUtil().setWidth(30),
                        ) : SizedBox.shrink()
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          comment.createDateTime,
                          style: TextStyle(
                              color: Color(0xffABABAB),
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil().setSp(22)
                          ),
                        ),
                        comment.topicName != '' ?
                        Text(
                          ' . ${comment.topicName}',
                          style: TextStyle(
                              color: Color(0xff989898),
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil().setSp(22)
                          ),
                        ) : SizedBox.shrink(),
                      ],
                    )
                  ],
                )
              ],
            ),
            Text(
              comment.text,
              style: TextStyle(
                  color: Color(0xff0C0C0D),
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenUtil().setSp(24)
              ),
            ),
            comment.image != '' ?
            GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: PhotoPageScreen(
                            photo: '$womanUrl/shareeexperiencev2/file/${comment.image}',
                           network: true,
                    )
                )
                );
              },
              child: Hero(
                tag: 'notePhoto',
                child: Padding(
                  padding:  EdgeInsets.only(
                      top: ScreenUtil().setWidth(15)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FancyShimmerImage(
                      imageUrl: '$womanUrl/shareeexperiencev2/file/${comment.image}',
                    ),
                  ),
                ),
              ),
            )
                : SizedBox.shrink(),
            SizedBox(height: ScreenUtil().setHeight(30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      comment.commentCount.toString(),
                      style: TextStyle(
                          color: Color(0xff0C0C0D),
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(28)
                      ),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(3)),
                    SvgPicture.asset(
                      'assets/images/comment.svg',
                      colorFilter: ColorFilter.mode(
                          Color(0xff707070),
                          BlendMode.srcIn
                      ),
                      width: ScreenUtil().setWidth(45),
                      height: ScreenUtil().setWidth(45),
                    )
                  ],
                ),
                SizedBox(width: ScreenUtil().setWidth(30)),
                Row(
                  children: [
                    Text(
                      comment.likeCount.toString(),
                      style: TextStyle(
                          color: Color(0xff0C0C0D),
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(28)
                      ),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(3)),
                    widget.isSelf ?
                    SvgPicture.asset(
                      'assets/images/like_empty.svg',
                      colorFilter: ColorFilter.mode(
                          Color(0xff707070),
                          BlendMode.srcIn
                      ),
                      width: ScreenUtil().setWidth(45),
                      height: ScreenUtil().setWidth(45),
                    ) :
                    comment.state == 1 ?
                    GestureDetector(
                      onTap: (){
                        AnalyticsHelper().log(AnalyticsEvents.ComntShareExpPg_RemoveLike_Icon_Clk,parameters: {'shareId' : widget.sharingExperiencePresenter!.otherExperiences.stream.value[widget.indexShareExp!].id});
                        widget.sharingExperiencePresenter!.removeLikeShareExp(widget.indexShareExp!, context,true,true);
                      },
                      child: SvgPicture.asset(
                        'assets/images/like_full.svg',
                        width: ScreenUtil().setWidth(45),
                        height: ScreenUtil().setWidth(45),
                        colorFilter: ColorFilter.mode(
                            ColorPallet().mainColor,
                            BlendMode.srcIn
                        ),
                      ),
                    )
                        :  GestureDetector(
                        onTap: (){
                          AnalyticsHelper().log(AnalyticsEvents.ComntShareExpPg_Like_Icon_Clk,parameters: {'shareId' : widget.sharingExperiencePresenter!.otherExperiences.stream.value[widget.indexShareExp!].id});
                          widget.sharingExperiencePresenter!.likeShareExp(widget.indexShareExp!,context,true);
                        },
                        child: SvgPicture.asset(
                          'assets/images/like_empty.svg',
                          colorFilter: ColorFilter.mode(
                              Color(0xff707070),
                              BlendMode.srcIn
                          ),
                          width: ScreenUtil().setWidth(45),
                          height: ScreenUtil().setWidth(45),
                        )
                    )
                  ],
                ),
                SizedBox(width: ScreenUtil().setWidth(30)),
                Row(
                  children: [
                    Text(
                      comment.dislikeCount.toString(),
                      style: TextStyle(
                          color: Color(0xff0C0C0D),
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(28)
                      ),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(3)),
                    widget.isSelf ?
                    SvgPicture.asset(
                      'assets/images/dislike_empty.svg',
                      colorFilter: ColorFilter.mode(
                          Color(0xff707070),
                          BlendMode.srcIn
                      ),
                      width: ScreenUtil().setWidth(45),
                      height: ScreenUtil().setWidth(45),
                    ) :
                    comment.state == 2 ?
                    GestureDetector(
                      onTap: (){
                        AnalyticsHelper().log(AnalyticsEvents.ComntShareExpPg_RemoveDislike_Icon_Clk,parameters: {'shareId' : widget.sharingExperiencePresenter!.otherExperiences.stream.value[widget.indexShareExp!].id});
                        widget.sharingExperiencePresenter!.removeLikeShareExp(widget.indexShareExp!, context,false,true);
                      },
                      child: SvgPicture.asset(
                        'assets/images/dislike_full.svg',
                        colorFilter: ColorFilter.mode(
                            ColorPallet().mainColor,
                            BlendMode.srcIn
                        ),
                        width: ScreenUtil().setWidth(45),
                        height: ScreenUtil().setWidth(45),
                      ),
                    ) :
                    GestureDetector(
                      onTap: (){
                        AnalyticsHelper().log(AnalyticsEvents.ComntShareExpPg_Dislike_Icon_Clk,parameters: {'shareId' : widget.sharingExperiencePresenter!.otherExperiences.stream.value[widget.indexShareExp!].id});
                        widget.sharingExperiencePresenter!.disLikeShareExp(widget.indexShareExp!, context,true);
                      },
                      child: SvgPicture.asset(
                        'assets/images/dislike_empty.svg',
                        colorFilter: ColorFilter.mode(
                          Color(0xff707070),
                          BlendMode.srcIn
                        ),
                        width: ScreenUtil().setWidth(45),
                        height: ScreenUtil().setWidth(45),
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

}