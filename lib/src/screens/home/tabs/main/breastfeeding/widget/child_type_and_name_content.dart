
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/dashboard_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/text_field_area.dart';
import 'package:get/get.dart';

import '../../../../../../firebase_analytics_helper.dart';

class ChildTypeAndNameContent extends StatefulWidget {
  final DashboardPresenter? dashboardPresenter;
  final Animations? animations;

  ChildTypeAndNameContent({Key? key, this.dashboardPresenter, this.animations})
      : super(key: key);

  @override
  _ChildTypeAndNameContentState createState() =>
      _ChildTypeAndNameContentState();
}

class _ChildTypeAndNameContentState extends State<ChildTypeAndNameContent> {
  bool isLoading = false;
  bool isAnim = false;
  int typeChildIndex = 0;



  @override
  void initState() {
    super.initState();
    //  widget.animations.shakeError(this);

    // _controller=TextEditingController(text: registerInfo.register.childName);
  }

  @override
  Widget build(BuildContext context) {
   /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedSize(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        child: StreamBuilder(
            stream: widget.dashboardPresenter!.childTypeSelectedObserve,
            builder: (context, snapshotChildTypeSelected) {
              if (snapshotChildTypeSelected.data != null) {
                return Container(
                  height:
                  isAnim || snapshotChildTypeSelected.data == 2 ? 140 : 240,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ScreenUtil().setHeight(45)),
                      Padding(
                        padding:
                        EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                        child: specificationItems(),
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(70),
                      ),
                      snapshotChildTypeSelected.data == 2
                          ? Container()
                          : Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: ScreenUtil().setWidth(20)),
                              child: Text(
                                'اسم قدم نو رسیده قشنگتون چیه؟',
                                textAlign: TextAlign.start,
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: ColorPallet().gray,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setWidth(20),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                ScreenUtil().setWidth(20)),
                            height: ScreenUtil().setWidth(90),
                            child: TextFieldArea(
                              notFlex: true,
                              isEmail: true,
                              inputReminder: true,
                              label: 'نام',
                              // textController: snapshotChildNameSelected.data,
                              onChanged: (value) {
                                widget.dashboardPresenter!.onChangeChildName(value);
                              },
                              textController: widget.dashboardPresenter!.childNameController,
                              readOnly: false,
                              editBox: false,
                              bottomMargin: 0,
                              topMargin: 0,
                              obscureText: false,
                              keyboardType: TextInputType.text,
                              maxLength: 15,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: AnimatedBuilder(
                                animation: widget.animations!.animationShakeError,
                                builder: (buildContext, child) {
                                  if (widget.animations!.animationShakeError.value <
                                      0.0)
                                    print(
                                        '${widget.animations!.animationShakeError.value + 8.0}');
                                  return StreamBuilder(
                                    stream: widget
                                        .animations!.isShowErrorObserve,
                                    builder: (context,
                                        AsyncSnapshot<bool> snapshot) {
                                      if (snapshot.data != null) {
                                        if (snapshot.data!) {
                                          return StreamBuilder(
                                              stream: widget.animations!.errorTextObserve,
                                              builder:
                                                  (context, AsyncSnapshot<String>snapshot) {
                                                return Container(
                                                    margin: EdgeInsets.symmetric(
                                                        horizontal:
                                                        ScreenUtil()
                                                            .setWidth(
                                                            65)),
                                                    padding: EdgeInsets.only(
                                                        left: widget.animations!.animationShakeError.value +
                                                            4.0,
                                                        right: 4.0 -
                                                            widget.animations!.animationShakeError.value),
                                                    child: Text(
                                                      snapshot.data != null
                                                          ? snapshot.data!
                                                          : '',
                                                      style: context.textTheme.bodySmall!.copyWith(
                                                        color: Color(
                                                            0xffEE5858),
                                                      ),
                                                    ));
                                              });
                                        } else {
                                          return Opacity(
                                            opacity: 0.0,
                                            child: Container(
                                              child: Text(''),
                                            ),
                                          );
                                        }
                                      } else {
                                        return Opacity(
                                          opacity: 0.0,
                                          child: Container(
                                            child: Text(''),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                }),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil().setWidth(50),
                      ),
                    ],
                  ),
                );
              } else
                return Container();
            }),
      ),
    );
  }

  Widget specificationItems() {
    List specificationBabyModel =
        widget.dashboardPresenter!.specificationBabyModel;
    return Row(
      children: List.generate(
          3,
              (index) => GestureDetector(
            onTap: () async {
              setState(() {
                typeChildIndex = index;

                for (int i = 0; i < specificationBabyModel.length; i++) {
                  specificationBabyModel[i].selected = false;
                }
                specificationBabyModel[index].selected =
                !specificationBabyModel[index].selected;
              });

              widget.dashboardPresenter!.onChangeChildType(index);
              typeChildIndex == 2
                  ? setState(() {
                isAnim = true;
              })
                  : setState(() {
                isAnim = false;
              });
              if(typeChildIndex == 0){
                AnalyticsHelper().log(AnalyticsEvents.SetBrstfeedPg_Girl_Btn_Clk_BtmSht);
              }else if(typeChildIndex == 1){
                AnalyticsHelper().log(AnalyticsEvents.SetBrstfeedPg_Boy_Btn_Clk_BtmSht);
              }else{
                AnalyticsHelper().log(AnalyticsEvents.SetBrstfeedPg_TwinsOrMore_Btn_Clk_BtmSht);
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(8)),
              child: Container(
                width: ScreenUtil().setWidth(220),
                height: ScreenUtil().setWidth(66),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                      color: !specificationBabyModel[index].selected
                          ? ColorPallet().mentalMain
                          : Colors.white),
                  gradient: LinearGradient(
                      colors: specificationBabyModel[index].selected
                          ? [
                        ColorPallet().mentalHigh,
                        ColorPallet().mentalMain,
                      ]
                          : [Colors.white, Colors.white]),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(10),
                      vertical: ScreenUtil().setWidth(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          specificationBabyModel[index].title,
                          textAlign: TextAlign.center,
                          style: context.textTheme.labelMedium!.copyWith(
                            color: specificationBabyModel[index].selected
                                ? Colors.white
                                : ColorPallet().mentalMain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
