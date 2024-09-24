//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:impo/src/architecture/presenter/dashboard_presenter.dart';
// import 'package:impo/src/components/animations.dart';
//
// class MyChangesDialog extends StatefulWidget{
//   final scaleAnim;
//   final DashboardPresenter? dashboardPresenter;
//   final onClose;
//   MyChangesDialog({Key? key,this.scaleAnim,this.dashboardPresenter,this.onClose}):super(key:key);
//
//   @override
//   State<StatefulWidget> createState() => MyChangesDialogState();
// }
//
// class MyChangesDialogState extends State<MyChangesDialog>{
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
//
//   @override
//   Widget build(BuildContext context) {
//     /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
//     return  Stack(
//       children: <Widget>[
//         GestureDetector(
//           onTap: (){
//             widget.onClose();
//                },
//           child: Container(
//             decoration:  BoxDecoration(
//                 color: Colors.white.withOpacity(.9)
//             ),
//           ),
//         ),
//         StreamBuilder(
//           stream: widget.scaleAnim,
//           builder: (context,AsyncSnapshot<double> snapshotScale){
//             if(snapshotScale.data != null){
//               return  Transform.scale(
//                 scale: snapshotScale.data,
//                 child: Stack(
//                   alignment: Alignment.topCenter,
//                   children: <Widget>[
//                     Container(
//                         height: MediaQuery.of(context).size.height / 1.8,
//                         margin: EdgeInsets.only(
//                             top: ScreenUtil().setWidth(100),
//                             right: ScreenUtil().setWidth(100),
//                             left: ScreenUtil().setWidth(100)
//                         ),
//                         padding: EdgeInsets.only(
//                             top: ScreenUtil().setWidth(130)
//                         ),
//                         decoration:  BoxDecoration(
//                             borderRadius: BorderRadius.circular(30),
//                             color: Colors.white
//                         ),
//                         child:  Padding(
//                           padding: EdgeInsets.only(
//                             right: ScreenUtil().setWidth(50),
//                             left: ScreenUtil().setWidth(50),
//                           ),
//                           child:  Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               SizedBox(height: ScreenUtil().setHeight(25)),
//                               SizedBox(height: ScreenUtil().setHeight(30)),
//                             ],
//                           ),
//                         )
//                     ),
// //                     Container(
// //                         height: ScreenUtil().setWidth(230),
// // //                                width: ScreenUtil().setWidth(300),
// //                         child:  SvgPicture.asset(
// //                           generateIcons(),
// //                           // fit: BoxFit.fill,
// //                         )
// //                     )
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
// }