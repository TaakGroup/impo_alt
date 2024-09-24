import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import '../../../components/circle_check_radio_widget.dart';
import '../../../models/subscribe/subscribtions_packages_model.dart';


class ItemsSub extends StatelessWidget {
  final SubscribtionsPackagesModel? item;
  final onPress;

  const ItemsSub({Key? key,this.onPress,this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: onPress,
          child: Container(
            // alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(20)),
            height: ScreenUtil().setWidth(110),
            width: MediaQuery.of(context).size.width - ScreenUtil().setWidth(60),
            decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                // color: item.isFree ?
                // ColorPallet().mentalMain : ColorPallet().emotionalMain,
                color: item!.isFree || item!.isSpecific ?
                Color(0xff7C74E9) : Colors.white,
                border: Border.all(
                  color:item!.selected ? Color(0xffC30081):
                  item!.isFree || item!.isSpecific ? Colors.transparent : Colors.transparent,
                  width: item!.selected ? ScreenUtil().setWidth(3)
                      : item!.isFree || item!.isSpecific ? 0 : ScreenUtil().setWidth(1)
                )
                // gradient: LinearGradient(
                //   colors: item.isFree ?
                //       [ColorPallet().mentalMain,ColorPallet().mentalMain] :
                //        item.isSpecific ?
                //       [ColorPallet().mainColor,Color(0xff950e68)]  :
                //        [ColorPallet().emotionalMain,ColorPallet().emotionalMain]
                // )
            ),
            child:   Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(30)
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  item!.isSpecific ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(20)
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            color: Colors.white
                        ),
                        child: Text(
                          item!.specificText,
                          style: context.textTheme.labelSmall!.copyWith(
                            color: Color(0xffC30081),
                          ),
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setWidth(10)),
                      itemtext(context)
                    ],
                  ) :
                  itemtext(context),
                  item!.value != item!.realValue ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              right: ScreenUtil().setWidth(8)
                            ),
                            child: Text(
                              item!.realValueText,
                              style: context.textTheme.labelSmall!.copyWith(
                                color: item!.isSpecific || item!.isFree ?
                                Colors.white: Color(0xffCBCBCB),
                              ),
                            ),
                          ),
                          RotationTransition(
                            turns: AlwaysStoppedAnimation(170 / 360),
                            child: Container(
                              margin: EdgeInsets.only(
                                top: ScreenUtil().setWidth(2)
                              ),
                              width: ScreenUtil().setWidth(75),
                              height: ScreenUtil().setWidth(1),
                              color: item!.isFree || item!.isSpecific ?
                              Color(0xffA7A1FE) : Color(0xffEF4056),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            item!.valueText,
                            style: context.textTheme.labelMediumProminent!.copyWith(
                              color: item!.isSpecific || item!.isFree ? Colors.white :
                              Color(0xffC0007D),
                            ),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(5)),
                          !item!.isFree ? Text(
                            item!.unit,
                            style:context.textTheme.labelMediumProminent!.copyWith(
                              color: item!.isSpecific || item!.isFree ? Colors.white :
                              Color(0xffC0007D),
                            ),
                          ) : Container(width: 0,height: 0,),
                        ],
                      )
                    ],
                  ) :
                  Row(
                    children: [
                      Text(
                        item!.valueText,
                        style: context.textTheme.labelMediumProminent!.copyWith(
                          color: item!.isSpecific || item!.isFree ? Colors.white : Color(0xffC0007D),
                        ),
                      ),
                      SizedBox(width: ScreenUtil().setWidth(8)),
                      !item!.isFree ? Text(
                        item!.unit,
                        style: context.textTheme.labelMediumProminent!.copyWith(
                          color: item!.isSpecific || item!.isFree ? Colors.white : Color(0xffC0007D),
                        ),
                      ) : Container(width: 0,height: 0,),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // Container(
        //   height: ScreenUtil().setWidth(130),
        //   margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
        //   width: MediaQuery.of(context).size.width - ScreenUtil().setWidth(60),
        //   decoration:  BoxDecoration(
        //       borderRadius: BorderRadius.circular(20),
        //       color: Colors.transparent
        //   ),
        //   child: Material(
        //     borderRadius: BorderRadius.circular(20),
        //     color: Colors.transparent,
        //     child: InkWell(
        //       borderRadius: BorderRadius.circular(20),
        //       splashColor: Colors.white.withOpacity(0.4),
        //       onTap: onPress,
        //       child: Container(
        //         width: MediaQuery.of(context).size.width - ScreenUtil().setWidth(100),
        //         decoration:  BoxDecoration(
        //             borderRadius: BorderRadius.circular(20),
        //             color: Colors.transparent
        //         ),
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Align(
        //               alignment: Alignment.topLeft,
        //               child:  SvgPicture.asset(
        //                 "assets/images/ic_topLeft_expert.svg",
        //                 width: ScreenUtil().setWidth(80),
        //                 height: ScreenUtil().setWidth(80),
        //               ),
        //             ),
        //             Padding(
        //               padding: EdgeInsets.only(
        //                   right: ScreenUtil().setWidth(7),
        //                   bottom: ScreenUtil().setWidth(7)
        //               ),
        //               child: Align(
        //                   alignment: Alignment.bottomRight,
        //                   child:  SvgPicture.asset(
        //                     "assets/images/ic_bottomRight_expert.svg",
        //                     width: ScreenUtil().setWidth(40),
        //                     height: ScreenUtil().setWidth(40),
        //                   )
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }

  Widget itemtext(BuildContext context){
    return  Row(
      children: [
        CircleCheckRadioWidget(
          isSelected: item!.selected,
        ),
        SizedBox(width: ScreenUtil().setWidth(15)),
        Text(
          item!.text,
          style:  context.textTheme.labelMediumProminent!.copyWith(
            color: item!.isSpecific || item!.isFree ? Colors.white : Color(0xff0C0C0D),
          ),
        )
      ],
    );
  }
}
