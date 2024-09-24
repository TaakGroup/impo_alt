import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/packages/featureDiscovery/feature_discovery.dart';
import 'package:impo/src/architecture/presenter/sharing_experience_presenter.dart';
import 'package:impo/src/architecture/view/sharing_experience_view.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/dialogs/qus_dialog.dart';
import 'package:impo/src/components/expert_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/firebase_analytics_helper.dart';
import 'package:impo/src/models/sharing_experience/all_share_experience_get_model.dart';
import 'package:impo/src/models/sharing_experience/other_experience_model.dart';
import 'package:impo/src/models/sharing_experience/self_experience_model.dart';
import 'package:impo/src/screens/home/home.dart';
import 'package:impo/src/screens/home/tabs/main/sharing_experience/comment_share_exp_screen.dart';
import 'package:impo/src/screens/home/tabs/main/sharing_experience/header_list_widget.dart';
import 'package:impo/src/models/sharing_experience/topic_model.dart';
import 'package:impo/src/screens/home/tabs/main/sharing_experience/send_share_exp_screen.dart';
import 'package:impo/src/screens/home/tabs/main/sharing_experience/topic_share_exp_screen.dart';
import 'package:page_transition/page_transition.dart';



class SharingExperienceScreen extends StatefulWidget{
  final bool? fromNotify;

  SharingExperienceScreen({Key? key,this.fromNotify}):super(key:key);

  @override
  State<StatefulWidget> createState() => SharingExperienceScreenState();
}

class SharingExperienceScreenState extends State<SharingExperienceScreen> with TickerProviderStateMixin implements SharingExperienceView{

  late SharingExperiencePresenter _sharingExperiencePresenter;
  late AnimationController animationControllerScaleButton;
  Animations animations =  Animations();
  int modePress = 0;


  ScrollController selfScrollController = ScrollController();

  ScrollController topicScrollController = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SharingExperienceScreenState(){
    _sharingExperiencePresenter = SharingExperiencePresenter(this);
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.ShareExpPg_Back_NavBar_Clk);
    if(_sharingExperiencePresenter.headerItems[1].selected!){
      for(int i=0 ; i<_sharingExperiencePresenter.headerItems.length ; i++){
        setState(() {
          _sharingExperiencePresenter.headerItems[i].selected = false;
        });
      }
        _sharingExperiencePresenter.getShareExperience();
      setState(() {
        _sharingExperiencePresenter.headerItems[0].selected = true;
      });
    }else{
      // if(widget.fromNotify != null){
        Navigator.pushReplacement(context,
            PageTransition(
                settings: RouteSettings(name: "/Page1"),
                type: PageTransitionType.topToBottom,
                child: FeatureDiscovery(
                  recordStepsInSharedPreferences: true,
                  child: Home(
                    indexTab: 4,
                    register: true,
                    isChangeStatus: false,
                  ),
                )
            )
        );
      // }else{
      //   Navigator.pop(context);
      // }
    }
    return Future.value(false);
  }

  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.ShareExpPg_Self_Pg_Load);
    AnalyticsHelper().enableEventsList([AnalyticsEvents.ShareExpPg_SelfExp_List_Scr]);
    AnalyticsHelper().enableEventsList([AnalyticsEvents.ShareExpPg_OtherExp_List_Scr]);
    AnalyticsHelper().enableEventsList([AnalyticsEvents.ShareExpPg_TopicsExp_List_Scr]);
    _sharingExperiencePresenter.initScrollController();
    _sharingExperiencePresenter.initAnimationController(this);
    _sharingExperiencePresenter.initialDialogScale(this);
    _sharingExperiencePresenter.getShareExperience();
    animationControllerScaleButton = animations.pressButton(this);
    _sharingExperiencePresenter.scrollController!.addListener(_listener);
    selfScrollController.addListener(_selfListener);
    topicScrollController.addListener(_topicListener);
    super.initState();
  }


  void _listener() {
    if(_sharingExperiencePresenter.headerItems[0].selected!){
      AnalyticsHelper().log(AnalyticsEvents.ShareExpPg_OtherExp_List_Scr,remainEventActive: false);
      if ( _sharingExperiencePresenter.scrollController!.position.atEdge) {
        _sharingExperiencePresenter.moreLoadGetOtherExp();
      }
    }else if(_sharingExperiencePresenter.headerItems[1].selected!){
      AnalyticsHelper().log(AnalyticsEvents.ShareExpPg_SelfExp_List_Scr,remainEventActive: false);
      if (_sharingExperiencePresenter.scrollController!.position.atEdge) {
        _sharingExperiencePresenter.moreLoadGetSelfExp();
      }
    }
  }

  void _selfListener() {
    AnalyticsHelper().log(AnalyticsEvents.ShareExpPg_SelfExp_List_Scr,remainEventActive: false);
  }

  void _topicListener() {
    AnalyticsHelper().log(AnalyticsEvents.ShareExpPg_TopicsExp_List_Scr,remainEventActive: false);
  }

  @override
  void dispose() {
    _sharingExperiencePresenter.dispose();
    animationControllerScaleButton.dispose();
    // scrollController.dispose();
    selfScrollController.dispose();
    super.dispose();
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
            alignment: Alignment.bottomCenter,
            children: [
              StreamBuilder(
                stream: _sharingExperiencePresenter.isLoadingObserve,
                builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                  if(snapshotIsLoading.data != null){
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
                                AnalyticsHelper().log(AnalyticsEvents.ShareExpPg_Back_Btn_Clk);
                                if(_sharingExperiencePresenter.headerItems[1].selected!){
                                  for(int i=0 ; i<_sharingExperiencePresenter.headerItems.length ; i++){
                                    setState(() {
                                      _sharingExperiencePresenter.headerItems[i].selected = false;
                                    });
                                  }
                                  _sharingExperiencePresenter.getShareExperience();
                                  setState(() {
                                    _sharingExperiencePresenter.headerItems[0].selected = true;
                                  });
                                }else{
                                  if(widget.fromNotify != null){
                                    Navigator.pushReplacement(context,
                                        PageTransition(
                                            settings: RouteSettings(name: "/Page1"),
                                            type: PageTransitionType.topToBottom,
                                            child: FeatureDiscovery(
                                              recordStepsInSharedPreferences: true,
                                              child: Home(
                                                indexTab: 4,
                                                register: true,
                                                isChangeStatus: false,
                                              ),
                                            )
                                        )
                                    );
                                  }else{
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              infoShareExp: true,
                            )
                        ),
                        Expanded(
                          child: _sharingExperiencePresenter.headerItems[0].selected! ?
                          RefreshIndicator(
                              onRefresh: (){
                                _sharingExperiencePresenter.getShareExperience();
                                return Future((){});
                              },
                              child: body(snapshotIsLoading.data!)
                          ) :
                          body(snapshotIsLoading.data!),
                        ),
                      ],
                    );
                  }else{
                    return Container();
                  }
                },
              ),
              StreamBuilder(
                stream: _sharingExperiencePresenter.isLoadingObserve,
                builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                  if(snapshotIsLoading.data != null){
                    if(!snapshotIsLoading.data!){
                      return StreamBuilder(
                        stream: _sharingExperiencePresenter.allExperiencesObserve,
                        builder: (context,AsyncSnapshot<AllShareExperienceGetModel>snapshotAllExp){
                          if(snapshotAllExp.data != null){
                            return Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
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
                                              readOnly: true,
                                              onChanged: (value){
                                                _sharingExperiencePresenter.onChangeTextField(value,context);
                                              },
                                              onTap: (){
                                                _sharingExperiencePresenter.selectTopic(unselectAll: true);
                                                Navigator.push(context,
                                                    PageTransition(
                                                        type: PageTransitionType.bottomToTop,
                                                        child:  SendShareExpScreen(
                                                          sharingExperiencePresenter: _sharingExperiencePresenter,
                                                          isComment: false,
                                                          fromTopicScreen : false
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
                                                hintText: snapshotAllExp.data!.inputText,
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
                                                  stream: _sharingExperiencePresenter.textSendObserve,
                                                  builder: (context,AsyncSnapshot<String>snapshotTextSend){
                                                    if(snapshotTextSend.data != null){
                                                      return StreamBuilder(
                                                        stream: _sharingExperiencePresenter.isLoadingButtonObserve,
                                                        builder: (context,snapshotIsLoadingButton){
                                                          if(snapshotIsLoadingButton.data != null){
                                                            return CustomButton(
                                                              title: 'ارسال',
                                                              onPress: (){
                                                                // if(snapshotTextSend.data.length >= 5){
                                                                //   AnalyticsHelper().log(AnalyticsEvents.ShareExpPg_SendExp_Btn_Clk);
                                                                //   _sharingExperiencePresenter.sendShareExp(context);
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
              ),
              StreamBuilder(
                stream: _sharingExperiencePresenter.isShowDeleteExpDialogObserve,
                builder: (context,AsyncSnapshot<bool>snapshotIsShowDialog){
                  if(snapshotIsShowDialog.data != null){
                    if(snapshotIsShowDialog.data!){
                      return  StreamBuilder(
                        stream: _sharingExperiencePresenter.isLoadingButtonObserve,
                        builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                          if(snapshotIsLoading.data != null){
                            return QusDialog(
                              scaleAnim: _sharingExperiencePresenter.dialogScaleObserve,
                              onPressCancel: (){
                                AnalyticsHelper().log(AnalyticsEvents.SelfShareExpPg_RemoveExpNoDlg_Btn_Clk);
                                _sharingExperiencePresenter.onPressCancelExpDialog();
                              },
                              value: "مطمئنی می‌خوای تجربه‌ت رو پاک کنی؟",
                              yesText: 'آره پاک میکنم',
                              noText: 'نه',
                              onPressYes: (){
                                if(!snapshotIsLoading.data!){
                                  AnalyticsHelper().log(AnalyticsEvents.SelfShareExpPg_RemoveExpYesDlg_Btn_Clk);
                                  _sharingExperiencePresenter.deleteExp(_scaffoldKey.currentContext);
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

  Widget body(bool isLoading){
    return SingleChildScrollView(
      controller: _sharingExperiencePresenter.scrollController,
      child: Column(
        children: [
          SizedBox(height: ScreenUtil().setHeight(20)),
          HeaderListWidget(
            sharingExperiencePresenter: _sharingExperiencePresenter,
            onPress: (int index){
              for(int i=0 ; i<_sharingExperiencePresenter.headerItems.length ; i++){
                setState(() {
                  _sharingExperiencePresenter.headerItems[i].selected = false;
                });
              }
              if(index == 1){
                _sharingExperiencePresenter.getSelfShareExperience(state: 0);
              }else{
                _sharingExperiencePresenter.getShareExperience();
              }
              setState(() {
                _sharingExperiencePresenter.headerItems[index].selected = !_sharingExperiencePresenter.headerItems[index].selected!;
              });
            },
          ),
          !isLoading ?
          StreamBuilder(
            stream: _sharingExperiencePresenter.allExperiencesObserve,
            builder: (context,AsyncSnapshot<AllShareExperienceGetModel>snapAllExp){
              if(snapAllExp.data != null){
                return StreamBuilder(
                  stream: _sharingExperiencePresenter.otherExperiencesObserve,
                  builder: (context,AsyncSnapshot<List<OtherExperienceModel>>snapshotOtherExp){
                    if(snapshotOtherExp.data != null){
                      return Column(
                        children: [
                          _sharingExperiencePresenter.headerItems[0].selected! ?
                          StreamBuilder(
                            stream: _sharingExperiencePresenter.otherExperiencesObserve,
                            builder: (context,AsyncSnapshot<List<OtherExperienceModel>>snapshotOtherExperiences){
                              if(snapshotOtherExperiences.data != null){
                                return pin(snapshotOtherExperiences.data!);
                              }else{
                                return Container();
                              }
                            },
                          ) :
                          SizedBox.shrink(),
                          _sharingExperiencePresenter.headerItems[0].selected! ?
                          Column(
                            children: [
                              // snapAllExp.data.self.length != 0 ?
                              // Padding(
                              //   padding: EdgeInsets.symmetric(
                              //       horizontal: ScreenUtil().setWidth(30)
                              //   ),
                              //   child: selfExperiences(snapAllExp.data.self,snapAllExp.data),
                              // )
                              //     : SizedBox.shrink(),
                              snapAllExp.data!.topics.length != 0 ?
                              Column(
                                children: [
                                  SizedBox(height: ScreenUtil().setHeight(5)),
                                  groupsExperiences(snapAllExp.data!.topics,snapAllExp.data!),
                                ],
                              ) : SizedBox.shrink(),
                              SizedBox(height: ScreenUtil().setHeight(40)),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(30)
                                ),
                                child: otherExperiences(snapshotOtherExp.data!,snapAllExp.data!),
                              )
                            ],
                          )
                              :
                          _sharingExperiencePresenter.headerItems[1].selected! ?
                          selfExperiences() :
                          SizedBox.shrink()
                        ],
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
              :
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height/2 - ScreenUtil().setWidth(200)
              ),
              child: StreamBuilder(
                stream: _sharingExperiencePresenter.tryButtonErrorObserve,
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
                                stream: _sharingExperiencePresenter.valueErrorObserve,
                                builder: (context,AsyncSnapshot<String>snapshotValueError) {
                                  if (snapshotValueError.data != null) {
                                    return Text(
                                      snapshotValueError.data!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xff707070),
                                          fontWeight: FontWeight.w500,
                                          fontSize: ScreenUtil().setSp(34)
                                      ),
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
                                      _sharingExperiencePresenter.getShareExperience();
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
              ))
        ],
      ),
    );
  }

  pin(List<OtherExperienceModel> other){
    return ListView.builder(
      itemCount: other.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      addAutomaticKeepAlives: false,
      primary: false,
      itemBuilder: (context,int index){
        return other[index].isPin ?
        Padding(
          padding:  EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(30)
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(20),
                vertical: ScreenUtil().setWidth(15)
            ),
            margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(30),
              bottom: ScreenUtil().setWidth(20),
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
                      other[index].avatar,
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
                              other[index].name,
                              style: TextStyle(
                                  color: ColorPallet().mainColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(28)
                              ),
                            ),
                            other[index].approvedProfile ?
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
                              other[index].createDateTime,
                              style: TextStyle(
                                  color: Color(0xff989898),
                                  fontWeight: FontWeight.w500,
                                  fontSize: ScreenUtil().setSp(22)
                              ),
                            ),
                            other[index].topicName != '' ?
                            Text(
                              ' . ${other[index].topicName}',
                              style: TextStyle(
                                  color: Color(0xff989898),
                                  fontWeight: FontWeight.w500,
                                  fontSize: ScreenUtil().setSp(22)
                              ),
                            ) : SizedBox.shrink(),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                          PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child:  CommentShareExpScreen(
                                shareId: other[index].id,
                                sharingExperiencePresenter: _sharingExperiencePresenter,
                                isSelf: false,
                                indexShareExp: index,
                              )
                          )
                      );
                    },
                    child: Text(
                      other[index].text,
                      style: TextStyle(
                          color: Color(0xff0C0C0D),
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(24)
                      ),
                    )
                ),
                other[index].image != '' ?
                GestureDetector(
                  onTap: (){
                    Navigator.push(context,
                        PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child:  CommentShareExpScreen(
                              shareId: other[index].id,
                              sharingExperiencePresenter: _sharingExperiencePresenter,
                              isSelf: false,
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
                        imageUrl: '$womanUrl/shareeexperiencev2/file/${other[index].image}',
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
                                    shareId: other[index].id,
                                    sharingExperiencePresenter: _sharingExperiencePresenter,
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
                                      shareId: other[index].id,
                                      sharingExperiencePresenter: _sharingExperiencePresenter,
                                      isSelf: false,
                                      indexShareExp: index,
                                    )
                                )
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                other[index].commentCount.toString(),
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
                              other[index].likeCount.toString(),
                              style: TextStyle(
                                  color: Color(0xff0C0C0D),
                                  fontWeight: FontWeight.w500,
                                  fontSize: ScreenUtil().setSp(28)
                              ),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(3)),
                            other[index].state == 1 ?
                            GestureDetector(
                              onTap: (){
                                AnalyticsHelper().log(AnalyticsEvents.ShareExpPg_RemoveLike_Icon_Clk,parameters: {'shareId' : other[index].id});
                                _sharingExperiencePresenter.removeLikeShareExp(index, context,true,false);
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
                                  AnalyticsHelper().log(AnalyticsEvents.ShareExpPg_Like_Icon_Clk,parameters: {'shareId' : other[index].id});
                                  _sharingExperiencePresenter.likeShareExp(index,context,false);
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
                              other[index].disliked.toString(),
                              style: TextStyle(
                                  color: Color(0xff0C0C0D),
                                  fontWeight: FontWeight.w500,
                                  fontSize: ScreenUtil().setSp(28)
                              ),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(3)),
                            other[index].state == 2 ?
                            GestureDetector(
                              onTap: (){
                                AnalyticsHelper().log(AnalyticsEvents.ShareExpPg_RemoveDislike_Icon_Clk,parameters: {'shareId' : other[index].id});
                                _sharingExperiencePresenter.removeLikeShareExp(index, context,false,false);
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
                                AnalyticsHelper().log(AnalyticsEvents.ShareExpPg_Dislike_Icon_Clk,parameters: {'shareId' : other[index].id});
                                _sharingExperiencePresenter.disLikeShareExp(index, context,false);
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
          ),
        )
            : SizedBox.shrink();
      },
    );
  }

  // Widget selfExperiences(List<SelfExperienceModel> self,AllShareExperienceGetModel allShareExperience){
  //   return  Column(
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             allShareExperience.selfTitleText,
  //             style: TextStyle(
  //                 color: Color(0xff262527),
  //                 fontWeight: FontWeight.w700,
  //                 fontSize: ScreenUtil().setSp(32)
  //             ),
  //           ),
  //           StreamBuilder(
  //             stream: animations.squareScaleBackButtonObserve,
  //             builder: (context,snapshotScale){
  //               if(snapshotScale.data != null){
  //                 return Transform.scale(
  //                   scale: modePress == 1 ? snapshotScale.data : 1.0,
  //                   child: GestureDetector(
  //                     onTap: ()async{
  //                       setState(() {
  //                         modePress = 1;
  //                       });
  //                       await  animationControllerScaleButton.reverse();
  //                       AnalyticsHelper().log(AnalyticsEvents.ShareExpPg_ViewAll_Btn_Clk);
  //                       Navigator.push(context,
  //                           PageTransition(
  //                               type: PageTransitionType.fade,
  //                               child:  SelfShareExpScreen(
  //                                 sharingExperiencePresenter: _sharingExperiencePresenter,
  //                                 // dashboardPresenter: widget.presenter,
  //                               )
  //                           )
  //                       );
  //                     },
  //                     child: Text(
  //                       'مشاهده همه',
  //                       style: TextStyle(
  //                           color: ColorPallet().mainColor,
  //                           decoration: TextDecoration.underline,
  //                           fontWeight: FontWeight.w700,
  //                           fontSize: ScreenUtil().setSp(26)
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               }else{
  //                 return Container();
  //               }
  //             },
  //           )
  //         ],
  //       ),
  //       SizedBox(height: ScreenUtil().setHeight(10)),
  //       SizedBox(
  //         height: ScreenUtil().setWidth(190),
  //         child: ListView.builder(
  //           controller: selfScrollController,
  //           itemCount: self.length > 4 ? 4 : self.length,
  //           scrollDirection: Axis.horizontal,
  //           itemBuilder: (context,int index){
  //             return GestureDetector(
  //               onTap: (){
  //                 Navigator.push(context,
  //                     PageTransition(
  //                         type: PageTransitionType.bottomToTop,
  //                         child:  CommentShareExpScreen(
  //                           shareId: self[index].id,
  //                           sharingExperiencePresenter: _sharingExperiencePresenter,
  //                           isSelf: true,
  //                         )
  //                     )
  //                 );
  //               },
  //               child: Container(
  //                 width: MediaQuery.of(context).size.width/1.8,
  //                 margin: EdgeInsets.only(
  //                     right: index == 0 ?
  //                     0 : ScreenUtil().setWidth(15)
  //                 ),
  //                 padding: EdgeInsets.only(
  //                   left: ScreenUtil().setWidth(15),
  //                   right: ScreenUtil().setWidth(15),
  //                   top: ScreenUtil().setWidth(20),
  //                 ),
  //                 decoration: BoxDecoration(
  //                     color: Color(0xffF8F8F8),
  //                     borderRadius: BorderRadius.only(
  //                         topLeft: Radius.circular(12),
  //                         bottomLeft: Radius.circular(12),
  //                         bottomRight: Radius.circular(12)
  //                     )
  //                 ),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       self[index].text,
  //                       textAlign: TextAlign.justify,
  //                       maxLines: 2,
  //                       softWrap: true,
  //                       overflow: TextOverflow.ellipsis,
  //                       style: TextStyle(
  //                           color: Color(0xff0C0C0D),
  //                           fontWeight: FontWeight.w400,
  //                           fontSize: ScreenUtil().setSp(24)
  //                       ),
  //                     ),
  //                     SizedBox(height: ScreenUtil().setHeight(20)),
  //                     Padding(
  //                       padding: EdgeInsets.only(
  //                           bottom: ScreenUtil().setWidth(15)
  //                       ),
  //                       child: Row(
  //                         children: [
  //                           Row(
  //                             children: [
  //                               Text(
  //                                 self[index].commentCount.toString(),
  //                                 style: TextStyle(
  //                                     color: Color(0xff0C0C0D),
  //                                     fontWeight: FontWeight.w500,
  //                                     fontSize: ScreenUtil().setSp(26)
  //                                 ),
  //                               ),
  //                               SizedBox(width: ScreenUtil().setWidth(3)),
  //                               SvgPicture.asset(
  //                                   'assets/images/comment.svg'
  //                               )
  //                             ],
  //                           ),
  //                           SizedBox(width: ScreenUtil().setWidth(30)),
  //                           Row(
  //                             children: [
  //                               Text(
  //                                 self[index].likeCount.toString(),
  //                                 style: TextStyle(
  //                                     color: Color(0xff0C0C0D),
  //                                     fontWeight: FontWeight.w500,
  //                                     fontSize: ScreenUtil().setSp(26)
  //                                 ),
  //                               ),
  //                               SizedBox(width: ScreenUtil().setWidth(3)),
  //                               SvgPicture.asset(
  //                                   'assets/images/like_empty.svg'
  //                               )
  //                             ],
  //                           ),
  //                           SizedBox(width: ScreenUtil().setWidth(30)),
  //                           Row(
  //                             children: [
  //                               Text(
  //                                 self[index].disliked.toString(),
  //                                 style: TextStyle(
  //                                     color: Color(0xff0C0C0D),
  //                                     fontWeight: FontWeight.w500,
  //                                     fontSize: ScreenUtil().setSp(26)
  //                                 ),
  //                               ),
  //                               SizedBox(width: ScreenUtil().setWidth(3)),
  //                               SvgPicture.asset(
  //                                   'assets/images/dislike_empty.svg'
  //                               )
  //                             ],
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget selfExperiences(){
    return  StreamBuilder(
      stream: _sharingExperiencePresenter.selfExperiencesObserve,
      builder: (context,AsyncSnapshot<List<SelfExperienceModel>>snapshotSelf){
        if(snapshotSelf.data != null){
          if(snapshotSelf.data!.isNotEmpty){
            return  Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(30)
              ),
              child: ListView.builder(
                itemCount: snapshotSelf.data!.length,
                shrinkWrap: true,
                addAutomaticKeepAlives: false,
                primary: false,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                    bottom: ScreenUtil().setWidth(110),
                    top: ScreenUtil().setWidth(30)
                ),
                itemBuilder: (context,int index){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context,
                              PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child:  CommentShareExpScreen(
                                    shareId: snapshotSelf.data![index].id,
                                    sharingExperiencePresenter: _sharingExperiencePresenter,
                                    isSelf: true,
                                  )
                              )
                          );
                        },
                        child: Text(
                          snapshotSelf.data![index].text,
                          style: TextStyle(
                              color: Color(0xff0C0C0D),
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil().setSp(24)
                          ),
                        ),
                      ),
                      Text(
                        snapshotSelf.data![index].createDateTime,
                        style: TextStyle(
                            color: Color(0xffABABAB),
                            fontWeight: FontWeight.w500,
                            fontSize: ScreenUtil().setSp(22)
                        ),
                      ),
                      snapshotSelf.data![index].image != '' ?
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context,
                              PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child:  CommentShareExpScreen(
                                    shareId: snapshotSelf.data![index].id,
                                    sharingExperiencePresenter: _sharingExperiencePresenter,
                                    isSelf: true,
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
                              imageUrl: '$womanUrl/shareeexperiencev2/file/${snapshotSelf.data![index].image}',
                            ),
                          ),
                        ),
                      )
                          : SizedBox.shrink(),
                      SizedBox(height: ScreenUtil().setHeight(20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StreamBuilder(
                            stream: animations.squareScaleBackButtonObserve,
                            builder: (context,AsyncSnapshot<double>snapshotScale){
                              if(snapshotScale.data != null){
                                return Transform.scale(
                                  scale: snapshotSelf.data![index].selected && modePress == 0 ? snapshotScale.data : 1.0,
                                  child: GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        modePress = 0;
                                      });
                                      animationControllerScaleButton.reverse();
                                      for(int i=0 ; i <snapshotSelf.data!.length; i++){
                                        if(snapshotSelf.data![i].selected){
                                          snapshotSelf.data![i].selected = false;
                                        }
                                      }

                                      snapshotSelf.data![index].selected = !snapshotSelf.data![index].selected;
                                      AnalyticsHelper().log(AnalyticsEvents.SelfShareExpPg_RemoveExp_Btn_Clk);
                                      _sharingExperiencePresenter.showExpDialog(index);
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
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context,
                                          PageTransition(
                                              type: PageTransitionType.bottomToTop,
                                              child:  CommentShareExpScreen(
                                                shareId: snapshotSelf.data![index].id,
                                                sharingExperiencePresenter: _sharingExperiencePresenter,
                                                isSelf: true,
                                              )
                                          )
                                      );
                                    },
                                    child: Text(
                                      snapshotSelf.data![index].commentCount.toString(),
                                      style: TextStyle(
                                          color: Color(0xff0C0C0D),
                                          fontWeight: FontWeight.w500,
                                          fontSize: ScreenUtil().setSp(28)
                                      ),
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
                                    snapshotSelf.data![index].likeCount.toString(),
                                    style: TextStyle(
                                        color: Color(0xff0C0C0D),
                                        fontWeight: FontWeight.w500,
                                        fontSize: ScreenUtil().setSp(28)
                                    ),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(3)),
                                  SvgPicture.asset(
                                    'assets/images/like_empty.svg',
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
                                    snapshotSelf.data![index].disliked.toString(),
                                    style: TextStyle(
                                        color: Color(0xff0C0C0D),
                                        fontWeight: FontWeight.w500,
                                        fontSize: ScreenUtil().setSp(28)
                                    ),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(3)),
                                  SvgPicture.asset(
                                    'assets/images/dislike_empty.svg',
                                    colorFilter: ColorFilter.mode(
                                        Color(0xff707070),
                                        BlendMode.srcIn
                                    ),
                                    width: ScreenUtil().setWidth(45),
                                    height: ScreenUtil().setWidth(45),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      !(index == snapshotSelf.data!.length - 1)  ?
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: ScreenUtil().setWidth(20),
                            top: ScreenUtil().setWidth(15)
                        ),
                        child: Divider(
                          color: Color(0xff000000).withOpacity(0.2),
                        ),
                      ) : SizedBox(height: ScreenUtil().setHeight(20)),
                      Align(
                        alignment: Alignment.center,
                        child: StreamBuilder(
                          stream: _sharingExperiencePresenter.isMoreSelfLoadingObserve,
                          builder: (context,AsyncSnapshot<bool>isMoreLoading){
                            if(isMoreLoading.data != null){
                              if(isMoreLoading.data!){
                                return  Padding(
                                    padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                                    child:  LoadingViewScreen(
                                      color: ColorPallet().mainColor,
                                      width: index == snapshotSelf.data!.length - 1  ? ScreenUtil().setWidth(70) : 0.0,
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
                },
              ),
            );
          }else{
            return Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height/3
              ),
              child: Text(
                'هنوز هیچ تجربه‌ای ایجاد نکردی',
                style: TextStyle(
                    color: Color(0xff262527),
                    fontWeight: FontWeight.w700,
                    fontSize: ScreenUtil().setSp(26)
                ),
              ),
            );
          }
        }else{
          return Container();
        }
      },
    );
  }

  Widget groupsExperiences(List<TopicModel> topics,AllShareExperienceGetModel allShareExperience){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: ScreenUtil().setWidth(30)
          ),
          child: Text(
            allShareExperience.groupsTitleText,
            style: TextStyle(
                color: Color(0xff262527),
                fontWeight: FontWeight.w700,
                fontSize: ScreenUtil().setSp(32)
            ),
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(10)),
        SizedBox(
          height: ScreenUtil().setWidth(250),
          child: ListView.builder(
            controller: topicScrollController,
            itemCount: topics.length,
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(15)
            ),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context,int index){
              return GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      PageTransition(
                          type: PageTransitionType.bottomToTop,
                          child:  TopicShareExpScreen(
                            topicId: topics[index].id,
                            sharingExperiencePresenter: _sharingExperiencePresenter,
                          )
                      )
                  );
                },
                child: Padding(
                  padding:  EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(10)
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child:
                        // Image.network(topics[index].image)
                        FancyShimmerImage(
                          imageUrl: topics[index].image,
                          width: ScreenUtil().setWidth(215),
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(
                          bottom: ScreenUtil().setWidth(10)
                        ),
                        child: Text(
                          topics[index].name,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: ScreenUtil().setSp(20)
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget otherExperiences(List<OtherExperienceModel> other,AllShareExperienceGetModel allShareExperience){
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            allShareExperience.otherTitleText,
            style: TextStyle(
                color: Color(0xff262527),
                fontWeight: FontWeight.w700,
                fontSize: ScreenUtil().setSp(32)
            ),
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(10)),
        ListView.builder(
          itemCount: other.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          addAutomaticKeepAlives: false,
          primary: false,
          itemBuilder: (context,int index){
            return ! other[index].isPin ?
            Container(
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
                        other[index].avatar,
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
                                other[index].name,
                                style: TextStyle(
                                    color: ColorPallet().mainColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(28)
                                ),
                              ),
                              other[index].approvedProfile ?
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
                                other[index].createDateTime,
                                style: TextStyle(
                                    color: Color(0xff989898),
                                    fontWeight: FontWeight.w500,
                                    fontSize: ScreenUtil().setSp(22)
                                ),
                              ),
                              other[index].topicName != '' ?
                              Text(
                                ' . ${other[index].topicName}',
                                style: TextStyle(
                                    color: Color(0xff989898),
                                    fontWeight: FontWeight.w500,
                                    fontSize: ScreenUtil().setSp(22)
                                ),
                              ) : SizedBox.shrink(),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child:  CommentShareExpScreen(
                                  shareId: other[index].id,
                                  sharingExperiencePresenter: _sharingExperiencePresenter,
                                  isSelf: false,
                                  indexShareExp: index,
                                )
                            )
                        );
                      },
                      child: Text(
                        other[index].text,
                        style: TextStyle(
                            color: Color(0xff0C0C0D),
                            fontWeight: FontWeight.w500,
                            fontSize: ScreenUtil().setSp(24)
                        ),
                      )
                  ),
                  other[index].image != '' ?
                   GestureDetector(
                     onTap: (){
                       Navigator.push(context,
                           PageTransition(
                               type: PageTransitionType.bottomToTop,
                               child:  CommentShareExpScreen(
                                 shareId: other[index].id,
                                 sharingExperiencePresenter: _sharingExperiencePresenter,
                                 isSelf: false,
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
                           imageUrl: '$womanUrl/shareeexperiencev2/file/${other[index].image}',
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
                                      shareId: other[index].id,
                                      sharingExperiencePresenter: _sharingExperiencePresenter,
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
                                        shareId: other[index].id,
                                        sharingExperiencePresenter: _sharingExperiencePresenter,
                                        isSelf: false,
                                        indexShareExp: index,
                                      )
                                  )
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  other[index].commentCount.toString(),
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
                                other[index].likeCount.toString(),
                                style: TextStyle(
                                    color: Color(0xff0C0C0D),
                                    fontWeight: FontWeight.w500,
                                    fontSize: ScreenUtil().setSp(28)
                                ),
                              ),
                              SizedBox(width: ScreenUtil().setWidth(3)),
                              other[index].state == 1 ?
                              GestureDetector(
                                onTap: (){
                                  AnalyticsHelper().log(AnalyticsEvents.ShareExpPg_RemoveLike_Icon_Clk,parameters: {'shareId' : other[index].id});
                                  _sharingExperiencePresenter.removeLikeShareExp(index, context,true,false);
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
                                    AnalyticsHelper().log(AnalyticsEvents.ShareExpPg_Like_Icon_Clk,parameters: {'shareId' : other[index].id});
                                    _sharingExperiencePresenter.likeShareExp(index,context,false);
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
                                other[index].disliked.toString(),
                                style: TextStyle(
                                    color: Color(0xff0C0C0D),
                                    fontWeight: FontWeight.w500,
                                    fontSize: ScreenUtil().setSp(28)
                                ),
                              ),
                              SizedBox(width: ScreenUtil().setWidth(3)),
                              other[index].state == 2 ?
                              GestureDetector(
                                onTap: (){
                                  AnalyticsHelper().log(AnalyticsEvents.ShareExpPg_RemoveDislike_Icon_Clk,parameters: {'shareId' : other[index].id});
                                  _sharingExperiencePresenter.removeLikeShareExp(index, context,false,false);
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
                                  AnalyticsHelper().log(AnalyticsEvents.ShareExpPg_Dislike_Icon_Clk,parameters: {'shareId' : other[index].id});
                                  _sharingExperiencePresenter.disLikeShareExp(index, context,false);
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
                  // !(index == other.length - 1)  ?
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //       bottom: ScreenUtil().setWidth(20),
                  //       top: ScreenUtil().setWidth(15)
                  //   ),
                  //   child: Divider(
                  //     color: Color(0xff000000).withOpacity(0.2),
                  //   ),
                  // ) : SizedBox(height: ScreenUtil().setHeight(20)),
                  Align(
                    alignment: Alignment.center,
                    child: StreamBuilder(
                      stream: _sharingExperiencePresenter.isMoreOtherLoadingObserve,
                      builder: (context,AsyncSnapshot<bool>isMoreLoading){
                        if(isMoreLoading.data != null){
                          if(isMoreLoading.data!){
                            return  Padding(
                                padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                                child:  LoadingViewScreen(
                                  color: ColorPallet().mainColor,
                                  width: index == other.length - 1  ? ScreenUtil().setWidth(70) : 0.0,
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
            )
            : SizedBox.shrink();
          },
        ),
        SizedBox(height: ScreenUtil().setHeight(120)),
      ],
    );
  }

  @override
  void onError(msg) {

  }

  @override
  void onSuccess(value) {

  }


}