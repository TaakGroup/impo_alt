//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:impo/src/architecture/presenter/expert_presenter.dart';
// import 'package:impo/src/components/animations.dart';
// import 'package:impo/src/components/colors.dart';
// import 'package:impo/src/components/custom_appbar.dart';
// import 'package:impo/src/components/custom_button.dart';
// import 'package:impo/src/components/expert_button.dart';
// import 'package:impo/src/components/loading_view_screen.dart';
// import 'package:impo/src/data/messages/messages.dart';
// import 'package:impo/src/models/expert/info.dart';
// import 'package:impo/src/models/expert/price_list_model.dart';
// import 'package:impo/src/screens/home/tabs/profile/enter_face_code_screen.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
//
// class ShopScreen extends StatefulWidget{
//   final ExpertPresenter expertPresenter;
//   final fromScreen;
//   final name;
//   ShopScreen({Key key,this.expertPresenter,this.fromScreen,this.name}):super(key:key);
//   @override
//   State<StatefulWidget> createState() => ShopScreenState();
// }
//
// class ShopScreenState extends State<ShopScreen> with TickerProviderStateMixin{
//
//
//   Animations _animations =  Animations();
//   AnimationController _animationController;
//
//   bool interfaceVisibility = false;
//   int modePress = 0;
//   List<Color> colors = [
//     ColorPallet().mentalHigh.withOpacity(0.1),
//     ColorPallet().mentalHigh.withOpacity(0.1),
//     ColorPallet().powerHigh.withOpacity(0.1),
//     ColorPallet().emotionalHigh.withOpacity(0.1),
//   ];
//   List<Color> textColor = [
//     ColorPallet().mentalMain,
//     ColorPallet().mentalMain,
//     ColorPallet().powerMain,
//     ColorPallet().emotionalMain,
//   ];
//
//   List<String>  icons =  [
//     'assets/images/ic_takhfif_1.svg',
//     'assets/images/ic_takhfif_1.svg',
//     'assets/images/ic_takhfif_2.svg',
//     'assets/images/ic_takhfif_3.svg',
//   ];
//
//   @override
//   void initState() {
//     // print(widget.randomMessage);
//     getInterfaceVisibility();
//     widget.expertPresenter.initPanelController();
//     widget.expertPresenter.getPriceList();
//     _animationController = _animations.pressButton(this);
//     _animations.shakeError(this);
//     widget.expertPresenter.initUniLinks(_animations,widget.fromScreen,context,widget.expertPresenter,widget.name);
//     super.initState();
//   }
//
//   getInterfaceVisibility()async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if(prefs.getBool('interfaceVisibility') != null){
//       if(this.mounted){
//         setState(() {
//           interfaceVisibility = prefs.getBool('interfaceVisibility');
//         });
//       }
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
//     timeDilation = 0.5;
//     return  WillPopScope(
//       onWillPop: widget.expertPresenter.onWillPopShopScreen,
//       child:   Directionality(
//         textDirection: TextDirection.rtl,
//         child:  Scaffold(
//             backgroundColor: Colors.white,
//             body:   Stack(
//               children: <Widget>[
//                 Column(
//                   children: <Widget>[
//                     Padding(
//                         padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(20)),
//                         child:  StreamBuilder(
//                           stream: widget.expertPresenter.infoAdviceObserve,
//                           builder: (context,AsyncSnapshot<InfoAdviceModel>snapshotInfo){
//                             return CustomAppBar(
//                               messages: false,
//                               profileTab: true,
//                               subTitleProfileTab: 'ایمپو بانک',
//                               isPolar: snapshotInfo.data != null ? true : null,
//                               valuePolar:  snapshotInfo.data != null ? snapshotInfo.data.types.length != 0 ? snapshotInfo.data.currentValue.toString() : null : null,
//                               titleProfileTab: 'صفحه قبل',
//                               icon: 'assets/images/ic_arrow_back.svg',
//                               onPressBack: (){
//                                 Navigator.pop(context);
//                               },
//                               polarHistory: true,
//                               pressShop : false,
//                               expertPresenter: widget.expertPresenter,
//                             );
//                           },
//                         )
//                     ),
//                     Expanded(
//                       child: StreamBuilder(
//                         stream: widget.expertPresenter.priceListObserve,
//                         builder: (context,AsyncSnapshot<PriceModel>snapshotPrice){
//                           if(snapshotPrice.data != null){
//                             return ListView(
//                               padding: EdgeInsets.zero,
//                               shrinkWrap: true,
//                               children: <Widget>[
//                                 Align(
//                                   alignment: Alignment.center,
//                                   child: Stack(
//                                     alignment: Alignment.bottomCenter,
//                                     children: [
//                                       Padding(
//                                         padding: EdgeInsets.only(
//                                           top: ScreenUtil().setWidth(20),
//                                           left: ScreenUtil().setWidth(280),
//                                         ),
//                                         child: SvgPicture.asset(
//                                           'assets/images/ic_big_shop.svg',
//                                           width: ScreenUtil().setWidth(110),
//                                           height: ScreenUtil().setWidth(110),
//                                         ),
//                                       ),
//                                       Text(
//                                         'ایمپو بانک',
//                                         textAlign: TextAlign.center,
//                                         style:  TextStyle(
//                                             color: ColorPallet().mainColor,
//                                             fontSize: ScreenUtil().setSp(44),
//                                             fontWeight: FontWeight.w800
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: ScreenUtil().setHeight(20)),
//                                 Padding(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: ScreenUtil().setWidth(20)
//                                     ),
//                                     child:  Text(
//                                       snapshotPrice.data.description,
//                                       textAlign: TextAlign.center,
//                                       style:  TextStyle(
//                                           color: ColorPallet().gray,
//                                           fontSize: ScreenUtil().setSp(30),
//                                           fontWeight: FontWeight.w500
//                                       ),
//                                     )
//                                 ),
//                                 SizedBox(height: ScreenUtil().setHeight(20)),
//                                 interfaceVisibility ?
//                                 StreamBuilder(
//                                   stream:  _animations.squareScaleBackButtonObserve,
//                                   builder: (context,snapshotScale){
//                                     if(snapshotScale.data != null){
//                                       return  Transform.scale(
//                                         scale:  modePress == 1 ? snapshotScale.data : 1.0,
//                                         child:  GestureDetector(
//                                           onTap: ()async{
//                                             if(this.mounted){
//                                               setState(() {
//                                                 modePress =1;
//                                               });
//                                             }
//                                             await _animationController.reverse();
//                                             Navigator.push(
//                                                 context,
//                                                 PageTransition(
//                                                     type: PageTransitionType.fade,
//                                                     child:  EnterFaceCodeScreen()
//                                                 )
//                                             );
//                                           },
//                                           child:  Image.asset(
//                                             'assets/images/baner_interface.png',
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       );
//                                     }else{
//                                       return  Container();
//                                     }
//                                   },
//                                 )
//                                     :  Container(),
//                                 Text(
//                                   '(هر پولار معادل ${snapshotPrice.data.polarPrice} ${snapshotPrice.data.unitPrice} است)',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     color: ColorPallet().gray.withOpacity(0.5),
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: ScreenUtil().setSp(30)
//                                   ),
//                                 ),
//                                 SizedBox(height: ScreenUtil().setHeight(20)),
//                                 StreamBuilder(
//                                   stream: widget.expertPresenter.isLoadingObserve,
//                                   builder: (context,snapshotIsLoading){
//                                     if(snapshotIsLoading.data != null){
//                                       if(!snapshotIsLoading.data){
//                                         return  GridView.builder(
//                                           shrinkWrap: true,
//                                           physics: NeverScrollableScrollPhysics(),
//                                           padding: EdgeInsets.only(
//                                               top: ScreenUtil().setWidth(10)
//                                           ),
//                                           // padding: EdgeInsets.zero,
//                                           itemCount: snapshotPrice.data.prices.length,
//                                           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1.4),
//                                           itemBuilder: (context,index){
//                                             return  StreamBuilder(
//                                               stream: _animations.squareScaleBackButtonObserve,
//                                               builder: (context,snapshotScale){
//                                                 if(snapshotScale.data != null){
//                                                   return  Transform.scale(
//                                                     scale: snapshotPrice.data.prices[index].selected && modePress == 0 ? snapshotScale.data : 1.0,
//                                                     child:  GestureDetector(
//                                                         onTap: ()async{
//                                                           if(this.mounted){
//                                                             setState(() {
//                                                               modePress =0;
//                                                             });
//                                                           }
//                                                           for(int i=0 ; i<snapshotPrice.data.prices.length ; i++){
//                                                             if(this.mounted){
//                                                               setState(() {
//                                                                 snapshotPrice.data.prices[i].selected = false;
//                                                               });
//                                                             }
//                                                           }
//                                                           await _animationController.reverse();
//                                                           if(this.mounted){
//                                                             setState(() {
//                                                               snapshotPrice.data.prices[index].selected = ! snapshotPrice.data.prices[index].selected;
//                                                             });
//                                                           }
//                                                           widget.expertPresenter.onPressBuyPolar(snapshotPrice.data.prices[index],_animations);
//                                                         },
//                                                         child:  Stack(
//                                                           alignment: Alignment.center,
//                                                           children: <Widget>[
//                                                             Container(
//                                                               margin: EdgeInsets.only(
//                                                                   left: ScreenUtil().setWidth(30),
//                                                                   right: ScreenUtil().setWidth(30),
//                                                                   bottom: ScreenUtil().setWidth(50)
//                                                               ),
//                                                               padding: EdgeInsets.only(
//                                                                   top: ScreenUtil().setWidth(20)
//                                                               ),
//                                                               decoration:  BoxDecoration(
//                                                                   color: Colors.white,
//                                                                   borderRadius: BorderRadius.circular(15),
//                                                                   boxShadow: [
//                                                                     BoxShadow(
//                                                                         color: Color(0xff5F9BDF).withOpacity(0.2),
//                                                                         blurRadius: 5.0
//                                                                     )
//                                                                   ]
//                                                               ),
//                                                               child:  Column(
//                                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                 children: <Widget>[
//                                                                   Padding(
//                                                                     padding: EdgeInsets.symmetric(
//                                                                       horizontal: ScreenUtil().setWidth(15),
//                                                                     ),
//                                                                     child:   Row(
//                                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                                       children: <Widget>[
//                                                                         Flexible(
//                                                                           child:  Row(
//                                                                             children: <Widget>[
//                                                                               Flexible(
//                                                                                 child:   Text(
//                                                                                   snapshotPrice.data.prices[index].polarCount.toString(),
//                                                                                   style:  TextStyle(
//                                                                                       color: ColorPallet().black,
//                                                                                       fontSize: ScreenUtil().setSp(40),
//                                                                                       fontWeight: FontWeight.w500
//                                                                                   ),
//                                                                                 ),
//                                                                               ),
//                                                                               Text(
//                                                                                 ' پولار',
//                                                                                 style:  TextStyle(
//                                                                                     color: ColorPallet().black,
//                                                                                     fontSize: ScreenUtil().setSp(34),
//                                                                                     fontWeight: FontWeight.w400
//                                                                                 ),
//                                                                               ),
//                                                                             ],
//                                                                           ),
//                                                                         ),
//                                                                         Flexible(
//                                                                           child:  Container(
//                                                                               padding: EdgeInsets.symmetric(
//                                                                                   vertical: ScreenUtil().setWidth(5),
//                                                                                   horizontal: ScreenUtil().setWidth(10)
//                                                                               ),
//                                                                               decoration:  BoxDecoration(
//                                                                                 // color: generateColorBox(index)[1],
//                                                                                   color: colors[snapshotPrice.data.prices[index].counterForColor],
//                                                                                   borderRadius: BorderRadius.circular(15)
//                                                                               ),
//                                                                               child:  Center(
//                                                                                 child:  Text(
//                                                                                   'خرید',
//                                                                                   style:  TextStyle(
//                                                                                       color: textColor[snapshotPrice.data.prices[index].counterForColor],
//                                                                                       fontSize: ScreenUtil().setSp(28),
//                                                                                       fontWeight: FontWeight.w400
//                                                                                   ),
//                                                                                 ),
//                                                                               )
//                                                                           ),
//                                                                         )
//                                                                       ],
//                                                                     ),
//                                                                   ),
//                                                                   Align(
//                                                                     alignment: Alignment.bottomLeft,
//                                                                     child:  Container(
//                                                                       padding: EdgeInsets.symmetric(
//                                                                           horizontal: ScreenUtil().setWidth(30),
//                                                                           // vertical: ScreenUtil().setWidth(15)
//                                                                       ),
//                                                                       height: ScreenUtil().setWidth(95),
//                                                                       decoration:  BoxDecoration(
//                                                                           color: colors[snapshotPrice.data.prices[index].counterForColor],
//                                                                           borderRadius: BorderRadius.only(
//                                                                               topRight: Radius.circular(15),
//                                                                               bottomLeft: Radius.circular(15)
//                                                                           )
//                                                                       ),
//                                                                       child: Column(
//                                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                                         children: [
//                                                                           snapshotPrice.data.prices[index].price != snapshotPrice.data.prices[index].realPrice ?
//                                                                           Stack(
//                                                                             alignment: Alignment.center,
//                                                                             children: [
//                                                                               Text(
//                                                                                 '${snapshotPrice.data.prices[index].realPrice}',
//                                                                                 style:  TextStyle(
//                                                                                     color: ColorPallet().gray,
//                                                                                     fontSize: ScreenUtil().setSp(26),
//                                                                                     fontWeight: FontWeight.w400
//                                                                                 ),
//                                                                               ),
//                                                                               Container(
//                                                                                 color: ColorPallet().gray.withOpacity(0.9),
//                                                                                 height: ScreenUtil().setWidth(2),
//                                                                                 width: ScreenUtil().setWidth(90),
//                                                                               )
//                                                                             ],
//                                                                           ): Container(width: 0,height: 0,),
//                                                                           Text(
//                                                                             '${snapshotPrice.data.prices[index].price} ${snapshotPrice.data.unitPrice}',
//                                                                             style:  TextStyle(
//                                                                                 color: textColor[snapshotPrice.data.prices[index].counterForColor],
//                                                                                 fontSize: ScreenUtil().setSp(28),
//                                                                                 fontWeight: FontWeight.w500
//                                                                             ),
//                                                                           ),
//                                                                         ],
//                                                                       )
//                                                                     ),
//                                                                   )
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                             Container(
//                                                               margin: EdgeInsets.only(
//                                                                   left: ScreenUtil().setWidth(170),
//                                                                   top: ScreenUtil().setWidth(10)
//                                                               ),
//                                                               child:  SvgPicture.asset(
//                                                                 icons[snapshotPrice.data.prices[index].counterForColor],
//                                                                 width: ScreenUtil().setWidth(55),
//                                                                 height: ScreenUtil().setWidth(55),
//                                                               ),
//                                                             )
//                                                           ],
//                                                         )
//                                                     ),
//                                                   );
//                                                 }else{
//                                                   return  Container();
//                                                 }
//                                               },
//                                             );
//                                           },
//                                         );
//                                       }else{
//                                         return   Center(
//                                             child:  StreamBuilder(
//                                               stream: widget.expertPresenter.tryButtonErrorObserve,
//                                               builder: (context,snapshotTryButton){
//                                                 if(snapshotTryButton.data != null){
//                                                   if(snapshotTryButton.data){
//                                                     return  Padding(
//                                                         padding: EdgeInsets.only(
//                                                             right: ScreenUtil().setWidth(80),
//                                                             left: ScreenUtil().setWidth(80)
//                                                         ),
//                                                         child:  Column(
//                                                           mainAxisAlignment: MainAxisAlignment.center,
//                                                           children: <Widget>[
//                                                             StreamBuilder(
//                                                               stream: widget.expertPresenter.valueErrorObserve,
//                                                               builder: (context,snapshotValueError){
//                                                                 if(snapshotValueError.data != null){
//                                                                   return   Text(
//                                                                     snapshotValueError.data,
//                                                                     textAlign: TextAlign.center,
//                                                                     style:  TextStyle(
//                                                                         color: Color(0xff707070),
//                                                                         fontWeight: FontWeight.w500,
//                                                                         fontSize: ScreenUtil().setSp(34)
//                                                                     ),
//                                                                   );
//                                                                 }else{
//                                                                   return  Container();
//                                                                 }
//                                                               },
//                                                             ),
//                                                             Padding(
//                                                                 padding: EdgeInsets.only(
//                                                                     top: ScreenUtil().setWidth(120)
//                                                                 ),
//                                                                 child:    ExpertButton(
//                                                                   title: 'تلاش مجدد',
//                                                                   onPress: (){
//                                                                     widget.expertPresenter.getPriceList();
//                                                                   },
//                                                                   enableButton: true,
//                                                                   isLoading: false,
//                                                                 )
//                                                             )
//                                                           ],
//                                                         )
//                                                     );
//                                                   }else{
//                                                     return  LoadingViewScreen(
//                                                         color: ColorPallet().mainColor
//                                                     );
//                                                   }
//                                                 }else{
//                                                   return  Container();
//                                                 }
//                                               },
//                                             )
//                                         );
//                                       }
//                                     }else{
//                                       return  Container();
//                                     }
//                                   },
//                                 )
//                               ],
//                             );
//                           }else{
//                             return Container();
//                           }
//                         },
//                       ),
//                     )
//                   ],
//                 ),
//                 SlidingUpPanel(
//                   controller: widget.expertPresenter.panelController,
//                   backdropEnabled: true,
//                   minHeight: 0,
//                   backdropColor: Colors.black,
//                   padding: EdgeInsets.zero,
//                   maxHeight: MediaQuery.of(context).size.height / 2.2,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30)
//                   ),
//                   panel:  Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         margin: EdgeInsets.only(
//                             top: ScreenUtil().setWidth(15)
//                         ),
//                         height: ScreenUtil().setWidth(5),
//                         width: ScreenUtil().setWidth(100),
//                         decoration:  BoxDecoration(
//                             color: Color(0xff707070).withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(15)
//                         ),
//                       ),
//                       Flexible(
//                           child:  notPolarPanel()
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//         ),
//       )
//     );
//   }
//
//   Widget notPolarPanel(){
//     return  StreamBuilder(
//       stream: widget.expertPresenter.priceListObserve,
//       builder: (context,AsyncSnapshot<PriceModel>snapshotUnitPrice){
//         if(snapshotUnitPrice.data != null){
//           return StreamBuilder(
//             stream: widget.expertPresenter.selectedPolarObserve,
//             builder: (context,AsyncSnapshot<PriceListModel>selectedPolar){
//               if(selectedPolar.data != null){
//                 return  Padding(
//                     padding: EdgeInsets.only(
//                       top: ScreenUtil().setWidth(30),
//                     ),
//                     child:  Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Padding(
//                           padding: EdgeInsets.only(
//                             right: ScreenUtil().setWidth(50),
//                             left: ScreenUtil().setWidth(50),
//                           ),
//                           child:  Text(
//                             'ایمپویی عزیز می‌تونی از اینجا پولار خریداری کنی',
//                             textAlign: TextAlign.center,
//                             style:  TextStyle(
//                               color: ColorPallet().gray,
//                               fontWeight: FontWeight.w400,
//                               fontSize: ScreenUtil().setSp(32),
//                             ),
//                           ),
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: ScreenUtil().setWidth(150)
//                               ),
//                               child:  Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Text(
//                                     'پولار انتخاب شده',
//                                     style:  TextStyle(
//                                       color: ColorPallet().gray,
//                                       fontWeight: FontWeight.w400,
//                                       fontSize: ScreenUtil().setSp(30),
//                                     ),
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Text(
//                                         selectedPolar.data.polarCount.toString(),
//                                         style:  TextStyle(
//                                             color: ColorPallet().black,
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: ScreenUtil().setSp(44)
//                                         ),
//                                       ),
//                                       SizedBox(width: ScreenUtil().setWidth(10),),
//                                       Image.asset(
//                                         'assets/images/ic_polar.png',
//                                         width: ScreenUtil().setWidth(60),
//                                         height: ScreenUtil().setWidth(60),
//                                       )
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                             SizedBox(height: ScreenUtil().setHeight(30)),
//                             Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: ScreenUtil().setWidth(150)
//                               ),
//                               child:   Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Text(
//                                     'مبلغ',
//                                     style:  TextStyle(
//                                       color: ColorPallet().mainColor,
//                                       fontWeight: FontWeight.w400,
//                                       fontSize: ScreenUtil().setSp(32),
//                                     ),
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Text(
//                                         selectedPolar.data.price.toString(),
//                                         style:  TextStyle(
//                                             color: ColorPallet().mainColor,
//                                             fontWeight: FontWeight.w700,
//                                             fontSize: ScreenUtil().setSp(40)
//                                         ),
//                                       ),
//                                       SizedBox(width: ScreenUtil().setWidth(10),),
//                                       Text(
//                                         snapshotUnitPrice.data.unitPrice,
//                                         style:  TextStyle(
//                                             color: ColorPallet().mainColor,
//                                             fontWeight: FontWeight.w400,
//                                             fontSize: ScreenUtil().setSp(34)
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               margin: EdgeInsets.only(
//                                   top: ScreenUtil().setWidth(30)
//                               ),
//                               height: ScreenUtil().setWidth(3.5),
//                               width: MediaQuery.of(context).size.width - ScreenUtil().setWidth(150),
//                               decoration:  BoxDecoration(
//                                   color: Color(0xff707070).withOpacity(0.2)
//                               ),
//                             )
//                           ],
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(
//                               bottom: ScreenUtil().setWidth(20)
//                           ),
//                           child:  Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               StreamBuilder(
//                                 stream: widget.expertPresenter.isLoadingButton,
//                                 builder: (context,snapshotIsLoading){
//                                   if(snapshotIsLoading.data != null){
//                                     return   CustomButton(
//                                       title: 'پرداخت',
//                                       onPress: (){
//                                         if(!snapshotIsLoading.data){
//                                           widget.expertPresenter.payFinancial(_animations,selectedPolar.data.polarCount);
//                                         }
//                                       },
//                                       colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
//                                       enableButton: true,
//                                       isLoadingButton: snapshotIsLoading.data,
//                                     );
//                                   }else{
//                                     return  Container();
//                                   }
//                                 },
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.only(
//                                   top: ScreenUtil().setWidth(20),
//                                 ),
//                                 child: AnimatedBuilder(
//                                     animation: _animations.animationShakeError,
//                                     builder: (buildContext, child) {
//                                       if (_animations.animationShakeError.value < 0.0) print('${_animations.animationShakeError.value + 8.0}');
//                                       return  StreamBuilder(
//                                         stream: _animations.isShowErrorObserve,
//                                         builder: (context,AsyncSnapshot<bool> snapshot){
//                                           if(snapshot.data != null){
//                                             if(snapshot.data){
//                                               return  StreamBuilder(
//                                                   stream: _animations.errorTextObserve,
//                                                   builder: (context,snapshot){
//                                                     return Container(
//                                                         padding: EdgeInsets.only(left: _animations.animationShakeError.value + 4.0, right: 4.0 -_animations.animationShakeError.value),
//                                                         child: Text(
//                                                           snapshot.data != null ? snapshot.data : '',
//                                                           style:  TextStyle(
//                                                               color: Color(0xffEE5858),
//                                                               fontSize: ScreenUtil().setWidth(26),
//                                                               fontWeight: FontWeight.w700
//                                                           ),
//                                                         )
//                                                     );
//                                                   }
//                                               );
//                                             }else {
//                                               return  Opacity(
//                                                 opacity: 0.0,
//                                                 child:  Container(
//                                                   child:  Text(''),
//                                                 ),
//                                               );
//                                             }
//                                           }else{
//                                             return  Opacity(
//                                               opacity: 0.0,
//                                               child:  Container(
//                                                 child:  Text(''),
//                                               ),
//                                             );
//                                           }
//                                         },
//                                       );
//                                     }),
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     )
//                 );
//               }else{
//                 return  Container();
//               }
//             },
//           );
//         }else{
//           return Container();
//         }
//       },
//     );
//   }
//
//
// }