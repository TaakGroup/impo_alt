// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:impo/src/architecture/presenter/sharing_experience_presenter.dart';
// import 'package:impo/src/components/animations.dart';
// import 'package:impo/src/components/colors.dart';
// import 'package:impo/src/components/custom_appbar.dart';
// import 'package:impo/src/components/dialogs/qus_dialog.dart';
// import 'package:impo/src/components/loading_view_screen.dart';
// import 'package:impo/src/firebase_analytics_helper.dart';
// import 'package:impo/src/models/sharing_experience/self_experience_model.dart';
// import 'package:impo/src/screens/home/tabs/main/sharing_experience/comment_share_exp_screen.dart';
// import 'package:page_transition/page_transition.dart';
//
// import '../../../../../components/expert_button.dart';
//
// class SelfShareExpScreen extends StatefulWidget{
//   final SharingExperiencePresenter sharingExperiencePresenter;
//
//
//   SelfShareExpScreen({Key key,this.sharingExperiencePresenter}):super(key:key);
//
//   @override
//   State<StatefulWidget> createState() => SelfShareExpScreenState();
// }
//
// class SelfShareExpScreenState extends State<SelfShareExpScreen> with TickerProviderStateMixin{
//
//
//   AnimationController animationControllerScaleButton;
//   Animations animations =  Animations();
//   int modePress = 0;
//   ScrollController scrollController = ScrollController();
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   void initState() {
//     AnalyticsHelper().log(AnalyticsEvents.SelfShareExpPg_Self_Pg_Load);
//     AnalyticsHelper().enableEventsList([AnalyticsEvents.SelfShareExpPg_AllSelfExp_List_Scr]);
//     widget.sharingExperiencePresenter.savePosition();
//     animationControllerScaleButton = animations.pressButton(this);
//     widget.sharingExperiencePresenter.initialDialogScale(this);
//     widget.sharingExperiencePresenter.getSelfShareExperience(state: 0);
//     scrollController.addListener(_listener);
//     super.initState();
//   }
//
//   void _listener() {
//     AnalyticsHelper().log(AnalyticsEvents.SelfShareExpPg_AllSelfExp_List_Scr,remainEventActive: false);
//     if (scrollController.position.atEdge) {
//       widget.sharingExperiencePresenter.moreLoadGetSelfExp();
//     }
//   }
//
//   @override
//   void dispose() {
//     animationControllerScaleButton.dispose();
//     scrollController.dispose();
//     super.dispose();
//   }
//
//   Future<bool> _onWillPop()async{
//     AnalyticsHelper().log(AnalyticsEvents.SelfShareExpPg_Back_NavBar_Clk);
//     widget.sharingExperiencePresenter.scrollController.jumpTo(widget.sharingExperiencePresenter.keepPosition);
//     Navigator.pop(context);
//     return Future.value(false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
//     timeDilation = .5;
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Scaffold(
//           key: _scaffoldKey,
//           backgroundColor: Colors.white,
//           body: Stack(
//             children: [
//               StreamBuilder(
//                 stream: widget.sharingExperiencePresenter.isLoadingObserve,
//                 builder: (context,snapshotIsLoading){
//                   if(snapshotIsLoading.data != null){
//                     if(!snapshotIsLoading.data){
//                       return SingleChildScrollView(
//                         controller: scrollController,
//                         child: StreamBuilder(
//                           stream: widget.sharingExperiencePresenter.selfExperiencesObserve,
//                           builder: (context,AsyncSnapshot<List<SelfExperienceModel>>snapshotSelf){
//                             if(snapshotSelf.data != null){
//                               return Column(
//                                 children: [
//                                   Padding(
//                                       padding: EdgeInsets.only(
//                                           bottom: ScreenUtil().setWidth(15)
//                                       ),
//                                       child: CustomAppBar(
//                                         messages: false,
//                                         profileTab: true,
//                                         icon: 'assets/images/ic_arrow_back.svg',
//                                         titleProfileTab: 'صفحه قبل',
//                                         subTitleProfileTab: 'تجربه‌های من',
//                                         onPressBack: (){
//                                           AnalyticsHelper().log(AnalyticsEvents.SelfShareExpPg_Back_Btn_Clk);
//                                           widget.sharingExperiencePresenter.scrollController.jumpTo(widget.sharingExperiencePresenter.keepPosition);
//                                           Navigator.pop(context);
//                                         },
//                                         infoShareExp: true,
//                                       )
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: ScreenUtil().setWidth(30)
//                                     ),
//                                     child: ListView.builder(
//                                       itemCount: snapshotSelf.data.length,
//                                       shrinkWrap: true,
//                                       addAutomaticKeepAlives: false,
//                                       primary: false,
//                                       physics: NeverScrollableScrollPhysics(),
//                                       itemBuilder: (context,int index){
//                                         return Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             GestureDetector(
//                                               onTap: (){
//                                                 Navigator.push(context,
//                                                     PageTransition(
//                                                         type: PageTransitionType.bottomToTop,
//                                                         child:  CommentShareExpScreen(
//                                                           shareId: snapshotSelf.data[index].id,
//                                                           sharingExperiencePresenter: widget.sharingExperiencePresenter,
//                                                           isSelf: true,
//                                                         )
//                                                     )
//                                                 );
//                                               },
//                                               child: Text(
//                                                 snapshotSelf.data[index].text,
//                                                 style: TextStyle(
//                                                     color: Color(0xff0C0C0D),
//                                                     fontWeight: FontWeight.w500,
//                                                     fontSize: ScreenUtil().setSp(24)
//                                                 ),
//                                               ),
//                                             ),
//                                             Text(
//                                               snapshotSelf.data[index].createDateTime,
//                                               style: TextStyle(
//                                                   color: Color(0xffABABAB),
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: ScreenUtil().setSp(22)
//                                               ),
//                                             ),
//                                             SizedBox(height: ScreenUtil().setHeight(20)),
//                                             Row(
//                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               children: [
//                                                 StreamBuilder(
//                                                   stream: animations.squareScaleBackButtonObserve,
//                                                   builder: (context,snapshotScale){
//                                                     if(snapshotScale.data != null){
//                                                       return Transform.scale(
//                                                         scale: snapshotSelf.data[index].selected && modePress == 0 ? snapshotScale.data : 1.0,
//                                                         child: GestureDetector(
//                                                           onTap: (){
//                                                             setState(() {
//                                                               modePress = 0;
//                                                             });
//                                                             animationControllerScaleButton.reverse();
//                                                             for(int i=0 ; i <snapshotSelf.data.length; i++){
//                                                               if(snapshotSelf.data[i].selected){
//                                                                 snapshotSelf.data[i].selected = false;
//                                                               }
//                                                             }
//
//                                                             snapshotSelf.data[index].selected = !snapshotSelf.data[index].selected;
//                                                             AnalyticsHelper().log(AnalyticsEvents.SelfShareExpPg_RemoveExp_Btn_Clk);
//                                                             widget.sharingExperiencePresenter.showExpDialog(index);
//                                                           },
//                                                           child: SvgPicture.asset(
//                                                             'assets/images/ic_delete.svg',
//                                                             width: ScreenUtil().setWidth(45),
//                                                             height: ScreenUtil().setWidth(45),
//                                                           ),
//                                                         ),
//                                                       );
//                                                     }else{
//                                                       return Container();
//                                                     }
//                                                   },
//                                                 ),
//                                                 Row(
//                                                   mainAxisAlignment: MainAxisAlignment.end,
//                                                   children: [
//                                                     Row(
//                                                       children: [
//                                                         GestureDetector(
//                                                           onTap: (){
//                                                             Navigator.push(context,
//                                                                 PageTransition(
//                                                                     type: PageTransitionType.bottomToTop,
//                                                                     child:  CommentShareExpScreen(
//                                                                       shareId: snapshotSelf.data[index].id,
//                                                                       sharingExperiencePresenter: widget.sharingExperiencePresenter,
//                                                                       isSelf: true,
//                                                                     )
//                                                                 )
//                                                             );
//                                                           },
//                                                           child: Text(
//                                                             snapshotSelf.data[index].commentCount.toString(),
//                                                             style: TextStyle(
//                                                                 color: Color(0xff0C0C0D),
//                                                                 fontWeight: FontWeight.w500,
//                                                                 fontSize: ScreenUtil().setSp(28)
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         SizedBox(width: ScreenUtil().setWidth(3)),
//                                                         SvgPicture.asset(
//                                                           'assets/images/comment.svg',
//                                                           color: Color(0xff707070),
//                                                           width: ScreenUtil().setWidth(45),
//                                                           height: ScreenUtil().setWidth(45),
//                                                         )
//                                                       ],
//                                                     ),
//                                                     SizedBox(width: ScreenUtil().setWidth(30)),
//                                                     Row(
//                                                       children: [
//                                                         Text(
//                                                           snapshotSelf.data[index].likeCount.toString(),
//                                                           style: TextStyle(
//                                                               color: Color(0xff0C0C0D),
//                                                               fontWeight: FontWeight.w500,
//                                                               fontSize: ScreenUtil().setSp(28)
//                                                           ),
//                                                         ),
//                                                         SizedBox(width: ScreenUtil().setWidth(3)),
//                                                         SvgPicture.asset(
//                                                           'assets/images/like_empty.svg',
//                                                           color: Color(0xff707070),
//                                                           width: ScreenUtil().setWidth(45),
//                                                           height: ScreenUtil().setWidth(45),
//                                                         )
//                                                       ],
//                                                     ),
//                                                     SizedBox(width: ScreenUtil().setWidth(30)),
//                                                     Row(
//                                                       children: [
//                                                         Text(
//                                                           snapshotSelf.data[index].disliked.toString(),
//                                                           style: TextStyle(
//                                                               color: Color(0xff0C0C0D),
//                                                               fontWeight: FontWeight.w500,
//                                                               fontSize: ScreenUtil().setSp(28)
//                                                           ),
//                                                         ),
//                                                         SizedBox(width: ScreenUtil().setWidth(3)),
//                                                         SvgPicture.asset(
//                                                           'assets/images/dislike_empty.svg',
//                                                           color: Color(0xff707070),
//                                                           width: ScreenUtil().setWidth(45),
//                                                           height: ScreenUtil().setWidth(45),
//                                                         )
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                             !(index == snapshotSelf.data.length - 1)  ?
//                                             Padding(
//                                               padding: EdgeInsets.only(
//                                                 bottom: ScreenUtil().setWidth(20),
//                                                 top: ScreenUtil().setWidth(15)
//                                               ),
//                                               child: Divider(
//                                                 color: Color(0xff000000).withOpacity(0.2),
//                                               ),
//                                             ) : SizedBox(height: ScreenUtil().setHeight(20)),
//                                             Align(
//                                               alignment: Alignment.center,
//                                               child: StreamBuilder(
//                                                 stream: widget.sharingExperiencePresenter.isMoreSelfLoadingObserve,
//                                                 builder: (context,isMoreLoading){
//                                                   if(isMoreLoading.data != null){
//                                                     if(isMoreLoading.data){
//                                                       return  Padding(
//                                                           padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
//                                                           child:  LoadingViewScreen(
//                                                             color: ColorPallet().mainColor,
//                                                             width: index == snapshotSelf.data.length - 1  ? ScreenUtil().setWidth(70) : 0.0,
//                                                           )
//                                                       );
//                                                     }else{
//                                                       return  Container();
//                                                     }
//                                                   }else{
//                                                     return Container();
//                                                   }
//                                                 },
//                                               ),
//                                             )
//                                           ],
//                                         );
//                                       },
//                                     ),
//                                   )
//                                 ],
//                               );
//                             }else{
//                               return Container();
//                             }
//                           },
//                         )
//                       );
//                     }else{
//                       return Center(
//                           child: StreamBuilder(
//                             stream: widget.sharingExperiencePresenter.tryButtonErrorObserve,
//                             builder: (context, snapshotTryButton) {
//                               if (snapshotTryButton.data != null) {
//                                 if (snapshotTryButton.data) {
//                                   return Padding(
//                                       padding: EdgeInsets.only(
//                                           right: ScreenUtil().setWidth(80),
//                                           left: ScreenUtil().setWidth(80)),
//                                       child: Column(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: <Widget>[
//                                           StreamBuilder(
//                                             stream: widget.sharingExperiencePresenter.valueErrorObserve,
//                                             builder: (context, snapshotValueError) {
//                                               if (snapshotValueError.data != null) {
//                                                 return Text(
//                                                   snapshotValueError.data,
//                                                   textAlign: TextAlign.center,
//                                                   style: TextStyle(
//                                                       color: Color(0xff707070),
//                                                       fontWeight: FontWeight.w500,
//                                                       fontSize: ScreenUtil().setSp(34)),
//                                                 );
//                                               } else {
//                                                 return Container();
//                                               }
//                                             },
//                                           ),
//                                           Padding(
//                                               padding:
//                                               EdgeInsets.only(top: ScreenUtil().setWidth(120)),
//                                               child: ExpertButton(
//                                                 title: 'تلاش مجدد',
//                                                 onPress: () {
//                                                   widget.sharingExperiencePresenter.getSelfShareExperience(state: 0);
//                                                 },
//                                                 enableButton: true,
//                                                 isLoading: false,
//                                               )
//                                           )
//                                         ],
//                                       )
//                                   );
//                                 } else {
//                                   return LoadingViewScreen(color: ColorPallet().mainColor);
//                                 }
//                               } else {
//                                 return Container();
//                               }
//                             },
//                           ));
//                     }
//                   }else{
//                     return Container();
//                   }
//                 },
//               ),
//               StreamBuilder(
//                 stream: widget.sharingExperiencePresenter.isShowDeleteExpDialogObserve,
//                 builder: (context,snapshotIsShowDialog){
//                   if(snapshotIsShowDialog.data != null){
//                     if(snapshotIsShowDialog.data){
//                       return  StreamBuilder(
//                         stream: widget.sharingExperiencePresenter.isLoadingButtonObserve,
//                         builder: (context,snapshotIsLoading){
//                           if(snapshotIsLoading.data != null){
//                             return QusDialog(
//                               scaleAnim: widget.sharingExperiencePresenter.dialogScaleObserve,
//                               onPressCancel: (){
//                                 AnalyticsHelper().log(AnalyticsEvents.SelfShareExpPg_RemoveExpNoDlg_Btn_Clk);
//                                 widget.sharingExperiencePresenter.onPressCancelExpDialog();
//                               },
//                               value: "مطمئنی می‌خوای تجربه‌ت رو پاک کنی؟",
//                               yesText: 'آره پاک میکنم',
//                               noText: 'نه',
//                               onPressYes: (){
//                                 if(!snapshotIsLoading.data){
//                                   AnalyticsHelper().log(AnalyticsEvents.SelfShareExpPg_RemoveExpYesDlg_Btn_Clk);
//                                   widget.sharingExperiencePresenter.deleteExp(_scaffoldKey.currentContext);
//                                 }
//                               },
//                               isIcon: true,
//                               colors: [Colors.white,Colors.white],
//                               topIcon: 'assets/images/ic_delete_dialog.svg',
//                               isLoadingButton: snapshotIsLoading.data,
//                             );
//                           }else{
//                             return Container();
//                           }
//                         },
//                       );
//                     }else{
//                       return  Container();
//                     }
//                   }else{
//                     return  Container();
//                   }
//                 },
//               ),
//             ],
//           )
//         ),
//       ),
//     );
//   }
//
// }