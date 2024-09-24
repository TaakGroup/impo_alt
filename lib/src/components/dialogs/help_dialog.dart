//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:impo/src/components/animations.dart';
// import 'package:impo/src/components/colors.dart';
// import 'package:impo/src/models/dashboard/help_dashboard_model.dart';
//
// class HelpDialog extends StatefulWidget{
//
//   final scaleAnim;
//   final value;
//   final okText;
//   final onPressOk;
//   final List<Color>? colors;
//
//   HelpDialog({Key? key,this.scaleAnim,this.value,this.okText,this.onPressOk,this.colors}):super(key:key);
//
//   @override
//   State<StatefulWidget> createState() => HelpDialogState();
// }
//
// class HelpDialogState extends State<HelpDialog> with TickerProviderStateMixin{
//
//   late AnimationController animationControllerScaleButtons;
//   Animations _animations =  Animations();
//
//   @override
//   void initState() {
//     animationControllerScaleButtons = _animations.pressButton(this);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     animationControllerScaleButtons.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
//     timeDilation = 0.5;
//     return  Stack(
//       children: <Widget>[
//          GestureDetector(
//           onTap: (){
//             widget.onPressOk();
// ;          },
//           child: Container(
//             decoration:  BoxDecoration(
//                 color: Colors.white.withOpacity(.9)
//             ),
//           ),
//         ),
//          StreamBuilder(
//           stream: widget.scaleAnim,
//           builder: (context,AsyncSnapshot<double>snapshotScale){
//             if(snapshotScale.data != null){
//               return  Transform.scale(
//                 scale: snapshotScale.data,
//                 child:  Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                      Stack(
//                       alignment: Alignment.topCenter,
//                       children: <Widget>[
//                          Container(
//                             height: MediaQuery.of(context).size.height / 1.8,
//                             margin: EdgeInsets.only(
//                                 top: ScreenUtil().setWidth(100),
//                                 right: ScreenUtil().setWidth(80),
//                                 left: ScreenUtil().setWidth(80)
//                             ),
//                             padding: EdgeInsets.only(
//                                 top: ScreenUtil().setWidth(130)
//                             ),
//                             decoration:  BoxDecoration(
//                                 borderRadius: BorderRadius.circular(30),
//                                 gradient: LinearGradient(
//                                     colors:
//                                     generateColors(),
//                                     begin: beginGradient(),
//                                     end: endGradient()
//                                 )
//                             ),
//                             child:  Padding(
//                               padding: EdgeInsets.only(
//                                 right: ScreenUtil().setWidth(50),
//                                 left: ScreenUtil().setWidth(50),
//                               ),
//                               child:  Column(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                    SizedBox(height: ScreenUtil().setHeight(25)),
//                                    Text(
//                                     generateTitles(),
//                                     textAlign: TextAlign.center,
//                                     style:  TextStyle(
//                                         color: Colors.white,
//                                         fontSize: ScreenUtil().setSp(55),
//                                         fontWeight: FontWeight.w700,
//                                         height: ScreenUtil().setWidth(3)
//                                     ),
//                                   ),
//                                    Text(
//                                     generateSubTitles(),
//                                     textAlign: TextAlign.center,
//                                     style:  TextStyle(
//                                         color: Colors.white,
//                                         fontSize: ScreenUtil().setSp(28),
//                                         fontWeight: FontWeight.w700,
//                                         height: ScreenUtil().setWidth(3)
//                                     ),
//                                   ),
//                                    SizedBox(height: ScreenUtil().setHeight(30)),
//                                    StreamBuilder(
//                                     stream: _animations.squareScaleBackButtonObserve,
//                                     builder: (context,AsyncSnapshot<double>snapshotScaleYes){
//                                       if(snapshotScaleYes.data != null){
//                                         return  Transform.scale(
//                                           scale: snapshotScaleYes.data ,
//                                           child:  GestureDetector(
//                                             onTap: ()async{
//                                               await animationControllerScaleButtons.reverse();
//                                               widget.onPressOk();
//                                             },
//                                             child:  Container(
//                                               padding: EdgeInsets.symmetric(
//                                                   horizontal: ScreenUtil().setWidth(100),
//                                                   vertical: ScreenUtil().setWidth(20)
//                                               ),
//                                               decoration:  BoxDecoration(
//                                                 color: Colors.white,
//                                                 borderRadius: BorderRadius.circular(10),
//                                               ),
//                                               child:  Text(
//                                                 widget.okText,
//                                                 style:  TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: ScreenUtil().setSp(36),
//                                                     fontWeight: FontWeight.w500
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       }else{
//                                         return  Container();
//                                       }
//                                     },
//                                   ),
//                                    SizedBox(height: ScreenUtil().setHeight(30)),
//                                 ],
//                               ),
//                             )
//                         ),
//                         Container(
//                             height: ScreenUtil().setWidth(230),
// //                                width: ScreenUtil().setWidth(300),
//                             child:  SvgPicture.asset(
//                               generateIcons(),
//                               // fit: BoxFit.fill,
//                             )
//                         )
// //                          Stack(
// //                           alignment: Alignment.bottomCenter,
// //                           children: <Widget>[
// //                              Container(
// //                               width: ScreenUtil().setWidth(260),
// //                               height: ScreenUtil().setWidth(260),
// //                               decoration:  BoxDecoration(
// //                                   shape: BoxShape.circle,
// //                                   color: Colors.white,
// //                                   boxShadow: [
// //                                     BoxShadow(
// //                                         color: ColorPallet().periodLight.withOpacity(.3),
// //                                         blurRadius: 10
// //                                     )
// //                                   ]
// //                               ),
// //                             ),
// //                              Container(
// //                                 height: ScreenUtil().setWidth(230),
// // //                                width: ScreenUtil().setWidth(300),
// //                                 child:  SvgPicture.asset(
// //                                   generateIcons(),
// //                                   fit: BoxFit.fill,
// //                                 )
// //                             )
// //                           ],
// //                         ),
//                       ],
//                     ),
//                      Padding(
//                         padding: EdgeInsets.only(
//                           left: ScreenUtil().setWidth(110),
//                           right: ScreenUtil().setWidth(110),
//                         ),
//                         child:  Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: List.generate(helpDashboards.length, (index) {
//                               return  GestureDetector(
//                                 onTap: (){
//
//                                   for(int i=0 ; i<helpDashboards.length ; i++){
//                                     helpDashboards[i].selected = false;
//                                   }
//
//                                   setState(() {
//                                     helpDashboards[index].selected = !helpDashboards[index].selected;
//                                   });
//                                 },
//                                 child:  Container(
//                                     width: helpDashboards[index].selected ? ScreenUtil().setWidth(130) : ScreenUtil().setWidth(100) ,
//                                     height:  helpDashboards[index].selected ? ScreenUtil().setWidth(130) : ScreenUtil().setWidth(100),
//                                     margin: EdgeInsets.only(
//                                         top: helpDashboards[index].selected ? 0 : ScreenUtil().setWidth(0)
//                                     ),
//                                     child: Image.asset(
//                                       helpDashboards[index].selected ? helpDashboards[index].selectedIcon! :helpDashboards[index].circleIcon! ,
//                                       fit: BoxFit.fitHeight,
//                                       color: index == 3 ? ColorPallet().normalDeep : null,
//                                     )
//                                 ),
//                               );
//                             })
//                         )
//                     )
//                   ],
//                 ),
//               );
//             }else{
//               return  Container();
//             }
//           },
//         )
//       ],
//     );
//   }
//
//   List<Color> generateColors(){
//
//     for(int i=0 ; i<helpDashboards.length ; i++){
//       if(helpDashboards[i].selected){
//         return helpDashboards[i].colors!;
//       }
//     }
//
//     return [
//       ColorPallet().periodDeep,
//       ColorPallet().periodLight
//     ];
//
//   }
//
//    String generateTitles(){
//
//     for(int i=0 ; i<helpDashboards.length ; i++){
//       if(helpDashboards[i].selected){
//         return helpDashboards[i].title!;
//       }
//     }
//
//     return '';
//
//   }
//
//
//   String generateSubTitles(){
//
//     for(int i=0 ; i<helpDashboards.length ; i++){
//       if(helpDashboards[i].selected){
//         return helpDashboards[i].subTitle!;
//       }
//     }
//
//     return '';
//
//   }
//
//
//   String generateIcons(){
//
//     for(int i=0 ; i<helpDashboards.length ; i++){
//       if(helpDashboards[i].selected){
//         return helpDashboards[i].icon!;
//       }
//     }
//
//     return 'assets/images/ic_help_normal.svg';
//
//   }
//
//   Alignment beginGradient(){
//
//     for(int i=0 ; i<helpDashboards.length ; i++){
//       if(helpDashboards[i].selected){
//         return Alignment.bottomRight;
//       }else{
//         return Alignment.bottomLeft;
//       }
//     }
//
//     return Alignment.bottomLeft;
//
//   }
//
//   Alignment endGradient(){
//
//     for(int i=0 ; i<helpDashboards.length ; i++){
//       if(helpDashboards[i].selected){
//         return Alignment.topLeft;
//       }else{
//         return Alignment.topRight;
//       }
//     }
//
//     return Alignment.topRight;
//
//
//   }
//
// }