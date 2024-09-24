//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:impo/src/architecture/presenter/register_presenter.dart';
// import 'package:impo/src/architecture/view/register_view.dart';
// import 'package:impo/src/components/animations.dart';
// import 'package:impo/src/components/bottom_text_register.dart';
// import 'package:impo/src/components/colors.dart';
// import 'package:impo/src/components/custom_button.dart';
// import 'package:impo/src/components/loading_view_screen.dart';
// import 'package:impo/src/data/local/save_data_offline_mode.dart';
// import 'package:impo/src/data/locator.dart';
// import 'package:impo/src/models/register/register_parameters_model.dart';
// import 'package:impo/src/screens/LoginAndRegister/globalRegister/birthday_register_screen.dart';
//
// import '../../../firebase_analytics_helper.dart';
//
// class NationalityRegisterScreen extends StatefulWidget{
//
//   // final Map registerParamViewModel;
//   final phoneOrEmail;
//   // final interfaceCode;
//
//   NationalityRegisterScreen({Key? key,this.phoneOrEmail}):super(key:key);
//
//   @override
//   State<StatefulWidget> createState() => NationalityRegisterScreenState();
// }
//
// class NationalityRegisterScreenState extends State<NationalityRegisterScreen> with TickerProviderStateMixin implements RegisterView{
//   late RegisterPresenter _presenter;
//
//   NationalityRegisterScreenState(){
//     _presenter = RegisterPresenter(this);
//   }
//
//
//   List<String> countries = ['ایران','افغانستان'];
//
//   late AnimationController animationControllerScaleSendButton;
//
// //  Map<String,dynamic> RegisterParamViewModel = {};
//
//
//   Animations _animations = new Animations();
//
//   int indexList = 0 ;
//
// //  CircleModel circleModel;
//
//   Map<String,dynamic> circles = {};
//
//   late DateTime lastPeriod ;
//
//   @override
//   void initState() {
//     AnalyticsHelper().log(AnalyticsEvents.NationalityRegPg_Cont_Btn_Clk);
//     animationControllerScaleSendButton = _animations.pressButton(this);
//     super.initState();
//   }
//
//   Future<bool> _onWillPop()async{
//     AnalyticsHelper().log(AnalyticsEvents.NationalityRegPg_Back_NavBar_Clk);
//     return Future.value(true);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     timeDilation = 0.5;
//     /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
//     return  WillPopScope(
//       onWillPop: _onWillPop,
//       child: Directionality(
//           textDirection: TextDirection.rtl,
//           child:  Scaffold(
//             resizeToAvoidBottomInset: true,
//             backgroundColor: Colors.white,
//             body:  SingleChildScrollView(
//               child:  Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.only(
//                         top: ScreenUtil().setWidth(120),
//                         bottom: ScreenUtil().setWidth(80)
//                     ),
//                     height: ScreenUtil().setWidth(180),
//                     width: ScreenUtil().setWidth(180),
//                     child:  Image.asset(
//                       'assets/images/file.png',
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(
//                         bottom: ScreenUtil().setWidth(100)
//                     ),
//                     child:   Text(
//                       'ایمپویی عزیز لطفا کشور خود را انتخاب کنید',
//                       textAlign: TextAlign.center,
//                       style:  TextStyle(
//                           color: ColorPallet().gray,
//                           fontSize: ScreenUtil().setSp(32),
//                           fontWeight: FontWeight.w800
//                       ),
//                     ),
//                   ),
//                   Container(
//                       alignment: Alignment.center,
//                       height: ScreenUtil().setWidth(220),
//                       child:  Center(
//                           child:  NotificationListener<OverscrollIndicatorNotification>(
//                             onNotification: (overscroll) {
//                               overscroll.disallowIndicator();
//                               return true;
//                             },
//                             child:   CupertinoPicker(
//                                 scrollController: FixedExtentScrollController(initialItem:0),
//                                 itemExtent: ScreenUtil().setWidth(110),
//                                 onSelectedItemChanged: (index){
//                                   indexList = index;
//                                 },
//                                 children: List.generate(countries.length, (index){
//                                   return  Center(
//                                     child:  Text(
//                                       countries[index],
//                                       style:  TextStyle(
//                                           fontFamily: 'IRANYekan',
//                                           fontSize: ScreenUtil().setSp(34),
//                                           fontWeight: FontWeight.w700,
//                                           color: ColorPallet().mainColor
//                                       ),
//                                     ),
//                                   );
//                                 })
//                             ),
//                           )
//                       )
//                   ),
//                   Align(
//                     alignment: Alignment.center,
//                     child:  StreamBuilder(
//                       stream: _presenter.isLoadingObserve,
//                       builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
//                         if(snapshotIsLoading.data != null){
//                           if(!snapshotIsLoading.data!){
//                             return  Padding(
//                               padding: EdgeInsets.only(
//                                   top: ScreenUtil().setWidth(150),
//                                   bottom: ScreenUtil().setWidth(30)
//                               ),
//                               child:  CustomButton(
//                                 title: 'ادامه',
//                                 onPress: (){
//                                   _presenter.enterSelectCountry(countries[indexList]);
//                                 },
//                                 colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
//                                 borderRadius: 10.0,
//                                 enableButton: true,
//                               ),
//                             );
//                           }else{
//                             return  Padding(
//                               padding: EdgeInsets.only(
//                                   top: ScreenUtil().setWidth(100),
//                                   bottom: ScreenUtil().setWidth(30)
//                               ),
//                               child:  LoadingViewScreen(
//                                   color: ColorPallet().mainColor
//                               ),
//                             );
//                           }
//                         }else{
//                           return  Container();
//                         }
//                       },
//                     ),
//                   )
//                 ],
//               ),
//             ),
//               bottomNavigationBar: Padding(
//                 padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
//                 child: BottomTextRegister(),
//               )
//           )
//       ),
//     );
//   }
//
//   @override
//   void onError(msg) {
//
//   }
//
//   @override
//   void onSuccess(msg){
//     String nat = '';
//
//     // if(msg == 'ایران') widget.registerParamViewModel['nationality'] = 'IR';
//     //
//     // if(msg == 'افغانستان') widget.registerParamViewModel['nationality'] = 'AF';
//
//     if(msg == 'ایران') nat = 'IR';
//
//     if(msg == 'افغانستان') nat = 'AF';
//
//     var registerInfo = locator<RegisterParamModel>();
//     registerInfo.setNationality(nat);
//     SaveDataOfflineMode().saveNationality();
//
//
//     Navigator.push(context,
//       PageRouteBuilder(
//         transitionDuration: Duration(seconds: 2),
//         pageBuilder: (_, __, ___) => BirthdayRegisterScreen(
//           // registerParamViewModel: widget.registerParamViewModel,
//           // interfaceCode: widget.interfaceCode,
//           phoneOrEmail: widget.phoneOrEmail,
//         ),
//       ),
//     );
//
//
//   }
//
//
//
// }