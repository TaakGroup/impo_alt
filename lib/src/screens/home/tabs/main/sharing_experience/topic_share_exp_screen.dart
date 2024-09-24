import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/sharing_experience_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/firebase_analytics_helper.dart';
import 'package:impo/src/models/sharing_experience/other_experience_model.dart';
import 'package:impo/src/models/sharing_experience/topic_model.dart';
import 'package:impo/src/screens/home/tabs/main/sharing_experience/comment_share_exp_screen.dart';
import 'package:impo/src/screens/home/tabs/main/sharing_experience/send_share_exp_screen.dart';
import 'package:impo/src/screens/home/tabs/main/sharing_experience/sharing_experience_screen.dart';
import 'package:page_transition/page_transition.dart';
import '../../../../../components/expert_button.dart';

class TopicShareExpScreen extends StatefulWidget{
  final SharingExperiencePresenter? sharingExperiencePresenter;
  final String? topicId;
  final bool? fromNotify;

  TopicShareExpScreen({Key? key,this.sharingExperiencePresenter,this.topicId,this.fromNotify}):super(key:key);

  @override
  State<StatefulWidget> createState() => TopicShareExpScreenState();
}

class TopicShareExpScreenState extends State<TopicShareExpScreen> with TickerProviderStateMixin{


  late AnimationController animationControllerScaleButton;
  Animations animations =  Animations();
  int modePress = 0;
  ScrollController scrollController = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.TopicShareExpPg_Self_Pg_Load);
    AnalyticsHelper().enableEventsList([AnalyticsEvents.TopicShareExpPg_TopicsExp_List_Scr]);
    widget.sharingExperiencePresenter!.savePosition();
    animationControllerScaleButton = animations.pressButton(this);
    widget.sharingExperiencePresenter!.getTopicShareExperience(state: 0,topicId: widget.topicId);
    scrollController.addListener(_listener);
    super.initState();
  }

  void _listener() {
    AnalyticsHelper().log(AnalyticsEvents.TopicShareExpPg_TopicsExp_List_Scr,remainEventActive: false);
    if (scrollController.position.atEdge) {
      widget.sharingExperiencePresenter!.moreLoadGetTopicExp(widget.topicId);
    }
  }

  @override
  void dispose() {
    animationControllerScaleButton.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.TopicShareExpPg_Back_NavBar_Clk);
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
      widget.sharingExperiencePresenter!.getShareExperience();
      Navigator.pop(context);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    ///ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
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
                      return StreamBuilder(
                        stream: widget.sharingExperiencePresenter!.otherExperiencesObserve,
                        builder: (context,AsyncSnapshot<List<OtherExperienceModel>>snapshotTopics){
                          if(snapshotTopics.data != null){
                            return Align(
                              alignment: Alignment.topCenter,
                              child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: StreamBuilder(
                                    stream: widget.sharingExperiencePresenter!.topicObserve,
                                    builder: (context,AsyncSnapshot<TopicModel>topic){
                                      if(topic.data != null){
                                        return Column(
                                          children: [
                                            Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                Stack(
                                                  children: [
                                                    Image.network(
                                                      topic.data!.coverImage,

                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom: ScreenUtil().setWidth(15)
                                                        ),
                                                        child: CustomAppBar(
                                                          messages: false,
                                                          profileTab: true,
                                                          icon: 'assets/images/ic_arrow_back.svg',
                                                          titleProfileTab: '',
                                                          subTitleProfileTab: '',
                                                          onPressBack: (){
                                                            AnalyticsHelper().log(AnalyticsEvents.TopicShareExpPg_Back_Btn_Clk);
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
                                                              widget.sharingExperiencePresenter!.getShareExperience();
                                                              Navigator.pop(context);
                                                            }
                                                          },
                                                          infoShareExp: true,
                                                        )
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: ScreenUtil().setWidth(30)
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        topic.data!.name,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: ScreenUtil().setSp(42)
                                                        ),
                                                      ),
                                                      Text(
                                                        //'گزارش‌گیری از دوره‌های قبلی پریود برای تشخیص اختلالات قاعدگی و پریود نامنظم و امکان ارسال برای پزشک',
                                                        topic.data!.bio,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: ScreenUtil().setSp(26)
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height: ScreenUtil().setWidth(30)
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            snapshotTopics.data!.length != 0 ?
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: ScreenUtil().setWidth(30)
                                              ),
                                              child: Column(
                                                children: [
                                                  SizedBox(height: ScreenUtil().setHeight(30)),
                                                  ListView.builder(
                                                    itemCount: snapshotTopics.data!.length,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    padding: EdgeInsets.zero,
                                                    addAutomaticKeepAlives: false,
                                                    primary: false,
                                                    itemBuilder: (context,int index){
                                                      return Container(
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal: ScreenUtil().setWidth(20),
                                                            vertical: ScreenUtil().setWidth(15)
                                                        ),
                                                        margin: EdgeInsets.only(
                                                            bottom: ScreenUtil().setWidth(25)
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
                                                                  snapshotTopics.data![index].avatar,
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
                                                                          snapshotTopics.data![index].selfExperience! ?
                                                                          'تجربه تو' : snapshotTopics.data![index].name,
                                                                          style: TextStyle(
                                                                              color: ColorPallet().mainColor,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: ScreenUtil().setSp(28)
                                                                          ),
                                                                        ),
                                                                        snapshotTopics.data![index].approvedProfile ?
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
                                                                          snapshotTopics.data![index].createDateTime,
                                                                          style: TextStyle(
                                                                              color: Color(0xffABABAB),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: ScreenUtil().setSp(22)
                                                                          ),
                                                                        ),
                                                                        snapshotTopics.data![index].topicName != '' ?
                                                                        Text(
                                                                          ' . ${snapshotTopics.data![index].topicName}',
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
                                                            GestureDetector(
                                                                onTap: (){
                                                                  Navigator.push(context,
                                                                      PageTransition(
                                                                          type: PageTransitionType.bottomToTop,
                                                                          child:  CommentShareExpScreen(
                                                                            shareId: snapshotTopics.data![index].id,
                                                                            sharingExperiencePresenter: widget.sharingExperiencePresenter!,
                                                                            isSelf: snapshotTopics.data![index].selfExperience ,
                                                                            indexShareExp: index,
                                                                          )
                                                                      )
                                                                  );
                                                                },
                                                                child: Text(
                                                                  snapshotTopics.data![index].text,
                                                                  style: TextStyle(
                                                                      color: Color(0xff0C0C0D),
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: ScreenUtil().setSp(24)
                                                                  ),
                                                                )
                                                            ),
                                                            snapshotTopics.data![index].image != '' ?
                                                            GestureDetector(
                                                              onTap: (){
                                                                Navigator.push(context,
                                                                    PageTransition(
                                                                        type: PageTransitionType.bottomToTop,
                                                                        child:  CommentShareExpScreen(
                                                                          shareId: snapshotTopics.data![index].id,
                                                                          sharingExperiencePresenter: widget.sharingExperiencePresenter!,
                                                                          isSelf: snapshotTopics.data![index].selfExperience ,
                                                                          indexShareExp: index,
                                                                        )
                                                                    )
                                                                );
                                                              },
                                                              child: Padding(
                                                                padding:  EdgeInsets.only(
                                                                    top: ScreenUtil().setWidth(15)
                                                                ),
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(12),
                                                                  child: FancyShimmerImage(
                                                                    imageUrl: '$womanUrl/shareeexperiencev2/file/${snapshotTopics.data![index].image}',
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                                : SizedBox.shrink(),
                                                            SizedBox(height: ScreenUtil().setHeight(30)),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                GestureDetector(
                                                                    onTap: (){
                                                                      Navigator.push(context,
                                                                          PageTransition(
                                                                              type: PageTransitionType.bottomToTop,
                                                                              child:  CommentShareExpScreen(
                                                                                shareId: snapshotTopics.data![index].id,
                                                                                sharingExperiencePresenter: widget.sharingExperiencePresenter!,
                                                                                isSelf: false,
                                                                                indexShareExp: index,
                                                                              )
                                                                          )
                                                                      );
                                                                    },
                                                                    child: Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                        horizontal: ScreenUtil().setWidth(20),

                                                                      ),
                                                                      decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                              color: ColorPallet().mainColor
                                                                          ),
                                                                          borderRadius: BorderRadius.circular(20)
                                                                      ),
                                                                      child: Text(
                                                                        'نظر بده',
                                                                        style: TextStyle(
                                                                            color: ColorPallet().mainColor,
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: ScreenUtil().setSp(24)
                                                                        ),
                                                                      ),
                                                                    )
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap: (){
                                                                        Navigator.push(context,
                                                                            PageTransition(
                                                                                type: PageTransitionType.bottomToTop,
                                                                                child:  CommentShareExpScreen(
                                                                                  shareId: snapshotTopics.data![index].id,
                                                                                  sharingExperiencePresenter: widget.sharingExperiencePresenter!,
                                                                                  isSelf: snapshotTopics.data![index].selfExperience,
                                                                                  indexShareExp: index,
                                                                                )
                                                                            )
                                                                        );
                                                                      },
                                                                      child: Row(
                                                                        children: [
                                                                          Text(
                                                                            snapshotTopics.data![index].commentCount.toString(),
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
                                                                    ),
                                                                    SizedBox(width: ScreenUtil().setWidth(30)),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          snapshotTopics.data![index].likeCount.toString(),
                                                                          style: TextStyle(
                                                                              color: Color(0xff0C0C0D),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: ScreenUtil().setSp(28)
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: ScreenUtil().setWidth(3)),
                                                                        snapshotTopics.data![index].state == 1 ?
                                                                        GestureDetector(
                                                                          onTap: (){
                                                                            AnalyticsHelper().log(AnalyticsEvents.TopicShareExpPg_RemoveLike_Icon_Clk,parameters: {'shareId' : snapshotTopics.data![index].id});
                                                                            widget.sharingExperiencePresenter!.removeLikeShareExp(index, context,true,false);
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
                                                                              AnalyticsHelper().log(AnalyticsEvents.TopicShareExpPg_Like_Icon_Clk,parameters: {'shareId' : snapshotTopics.data![index].id});
                                                                              widget.sharingExperiencePresenter!.likeShareExp(index,context,false);
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
                                                                          snapshotTopics.data![index].disliked.toString(),
                                                                          style: TextStyle(
                                                                              color: Color(0xff0C0C0D),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: ScreenUtil().setSp(28)
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: ScreenUtil().setWidth(3)),
                                                                        snapshotTopics.data![index].state == 2 ?
                                                                        GestureDetector(
                                                                          onTap: (){
                                                                            AnalyticsHelper().log(AnalyticsEvents.TopicShareExpPg_RemoveDislike_Icon_Clk,parameters: {'shareId' : snapshotTopics.data![index].id});
                                                                            widget.sharingExperiencePresenter!.removeLikeShareExp(index, context,false,false);
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
                                                                            AnalyticsHelper().log(AnalyticsEvents.TopicShareExpPg_Dislike_Icon_Clk,parameters: {'shareId' : snapshotTopics.data![index].id});
                                                                            widget.sharingExperiencePresenter!.disLikeShareExp(index, context,false);
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
                                                            Align(
                                                              alignment: Alignment.center,
                                                              child: StreamBuilder(
                                                                stream: widget.sharingExperiencePresenter!.isMoreOtherLoadingObserve,
                                                                builder: (context,AsyncSnapshot<bool>isMoreLoading){
                                                                  if(isMoreLoading.data != null){
                                                                    if(isMoreLoading.data!){
                                                                      return  Padding(
                                                                          padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                                                                          child:  LoadingViewScreen(
                                                                            color: ColorPallet().mainColor,
                                                                            width: index == snapshotTopics.data!.length - 1  ? ScreenUtil().setWidth(70) : 0.0,
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
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  SizedBox(height: ScreenUtil().setHeight(120)),
                                                ],
                                              ),
                                            ) :
                                            Center(
                                              child: Padding(
                                                padding:  EdgeInsets.only(
                                                    top: MediaQuery.of(context).size.height/2 - ScreenUtil().setWidth(450)
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
                                                      'هنوز هیچ تجربه‌ای ثبت نشده. اولین تجربه رو، تو ثبت کن',
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
                                          ],
                                        );
                                      }else{
                                        return Container();
                                      }
                                    },
                                  )
                              ),
                            );
                          }else{
                            return Container();
                          }
                        },
                      );
                    }else{
                      return Center(
                          child: StreamBuilder(
                            stream: widget.sharingExperiencePresenter!.tryButtonErrorObserve,
                            builder: (context, AsyncSnapshot<bool>snapshotTryButton) {
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
                                                  widget.sharingExperiencePresenter!.getTopicShareExperience(state: 0,topicId: widget.topicId);
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
              StreamBuilder(
                stream: widget.sharingExperiencePresenter!.isLoadingObserve,
                builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                  if(snapshotIsLoading.data != null){
                    if(!snapshotIsLoading.data!){
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
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
                                    StreamBuilder(
                                      stream: widget.sharingExperiencePresenter!.topicObserve,
                                      builder: (context,AsyncSnapshot<TopicModel>snapshotTopic){
                                        if(snapshotTopic.data != null){
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              textSelectionTheme: TextSelectionThemeData(
                                                  selectionColor: Color(0xffaaaaaa),
                                                  cursorColor: ColorPallet().mainColor
                                              ),
                                            ),
                                            child:  TextFormField(
                                              autofocus: false,
                                              onChanged: (value){
                                                widget.sharingExperiencePresenter!.onChangeTextField(value,context);
                                              },
                                              onTap: (){
                                                widget.sharingExperiencePresenter!.selectTopic();
                                                Navigator.push(context,
                                                    PageTransition(
                                                        type: PageTransitionType.bottomToTop,
                                                        child:  SendShareExpScreen(
                                                          sharingExperiencePresenter: widget.sharingExperiencePresenter!,
                                                          isComment: false,
                                                          fromTopicScreen : true
                                                        )
                                                    )
                                                );
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
                                                hintText: snapshotTopic.data!.inputText,
                                                hintStyle:  TextStyle(
                                                    fontSize: ScreenUtil().setSp(20),
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
                                          );
                                        }else{
                                          return Container();
                                        }
                                      },
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
                                            stream: widget.sharingExperiencePresenter!.textSendObserve,
                                            builder: (context,AsyncSnapshot<String>snapshotTextSend){
                                              if(snapshotTextSend.data != null){
                                                return StreamBuilder(
                                                  stream: widget.sharingExperiencePresenter!.isLoadingButtonObserve,
                                                  builder: (context,snapshotIsLoadingButton){
                                                    if(snapshotIsLoadingButton.data != null){
                                                      return CustomButton(
                                                        title: 'ارسال',
                                                        onPress: (){
                                                          // if(snapshotTextSend.data.length >= 5){
                                                          //   AnalyticsHelper().log(AnalyticsEvents.TopicShareExpPg_SendExp_Btn_Clk);
                                                          //   widget.sharingExperiencePresenter!.sendShareExp(context,topicId: widget.topicId);
                                                          // }
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
                        ),
                      );
                    }else{
                      return SizedBox.shrink();
                    }
                  }else{
                    return Container();
                  }
                },
              )
            ],
          )
        ),
      ),
    );
  }

}