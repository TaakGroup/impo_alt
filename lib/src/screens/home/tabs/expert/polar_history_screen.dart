

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/expert_presenter.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/expert_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/expert/info.dart';
import 'package:impo/src/models/expert/polar_history_model.dart';

class PolarHistoryScreen extends StatefulWidget{
  final ExpertPresenter? expertPresenter;

  PolarHistoryScreen({Key? key,this.expertPresenter}):super(key:key);

  @override
  State<StatefulWidget> createState() => PolarHistoryScreenState();
}

class PolarHistoryScreenState extends State<PolarHistoryScreen>{

  @override
  void initState() {
    widget.expertPresenter!.getTurnover(state: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(20)),
                child:  StreamBuilder(
                  stream: widget.expertPresenter!.infoAdviceObserve,
                  builder: (context,AsyncSnapshot<InfoAdviceModel>snapshotInfo){
                    return CustomAppBar(
                      messages: false,
                      profileTab: true,
                      subTitleProfileTab: 'ایمپو بانک',
                      isPolar: snapshotInfo.data != null ? true : null,
                      valuePolar:  snapshotInfo.data != null ? snapshotInfo.data!.types.length != 0 ? snapshotInfo.data!.currentValue.toString() : null : null,
                      titleProfileTab: 'صفحه قبل',
                      icon: 'assets/images/ic_arrow_back.svg',
                      onPressBack: (){
                        Navigator.pop(context);
                      },
                      expertPresenter: widget.expertPresenter!,
                    );
                  },
                )
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(350),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/ic_big_history_polar.svg',
                            width: ScreenUtil().setWidth(180),
                            height: ScreenUtil().setWidth(180),
                          ),
                        ),
                        Text(
                          'گردش پولار شما',
                          textAlign: TextAlign.center,
                          style:  context.textTheme.titleMedium!.copyWith(
                            color: ColorPallet().gray,
                          )
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(20)),
                  StreamBuilder(
                    stream: widget.expertPresenter!.isLoadingObserve,
                    builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                      if(snapshotIsLoading.data != null){
                        if(!snapshotIsLoading.data!){
                          return   StreamBuilder(
                            stream: widget.expertPresenter!.polarHistoriesObserve,
                            builder: (context,AsyncSnapshot<List<PolarHistoryModel>>snapshotPolarHistories){
                              if(snapshotPolarHistories.data != null){
                                // if(snapshotPolarHistories.data!.length != 0){
                                //   return  StreamBuilder(
                                //     stream: widget.expertPresenter!.counterMoreLoadObserve,
                                //     builder: (context,counterMoreLoad){
                                //       if(counterMoreLoad.data != null){
                                //         return   GridView.builder(
                                //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1.25),
                                //           addAutomaticKeepAlives: false,
                                //           shrinkWrap: true,
                                //           physics: NeverScrollableScrollPhysics(),
                                //           padding: EdgeInsets.only(
                                //               top: ScreenUtil().setWidth(15),
                                //               right: ScreenUtil().setWidth(15),
                                //               left: ScreenUtil().setWidth(15),
                                //           ),
                                //           itemCount: snapshotPolarHistories.data!.length,
                                //           itemBuilder: (context,int index){
                                //             if(index == snapshotPolarHistories.data!.length-1){
                                //               widget.expertPresenter!.moreLoadGetPolarHistory();
                                //             }
                                //             return  boxPolarHistories(snapshotPolarHistories.data![index],index,snapshotPolarHistories.data!.length);
                                //           },
                                //         );
                                //       }else{
                                //         return  Container();
                                //       }
                                //     },
                                //   );
                                // }else{
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      top: ScreenUtil().setWidth(MediaQuery.of(context).size.height/2 - 70),
                                      right: ScreenUtil().setWidth(30),
                                      left: ScreenUtil().setWidth(30)
                                    ),
                                      child:  Text(
                                        'ایمپویی عزیز شما تا الان تراکنشی در اپلیکیشن ایمپو نداشته‌اید 🌺',
                                        textAlign: TextAlign.center,
                                        style: context.textTheme.bodyMedium!.copyWith(
                                          color: ColorPallet().gray,
                                        )
                                      )
                                  );
                                // }
                              }else{
                                return  Container();
                              }
                            },
                          );
                        }else{
                          return  StreamBuilder(
                            stream: widget.expertPresenter!.tryButtonErrorObserve,
                            builder: (context,AsyncSnapshot<bool>snapshotTryButton){
                              if(snapshotTryButton.data != null){
                                if(snapshotTryButton.data!){
                                  return  Padding(
                                      padding: EdgeInsets.only(
                                          right: ScreenUtil().setWidth(80),
                                          left: ScreenUtil().setWidth(80),
                                          top: ScreenUtil().setWidth(200)
                                      ),
                                      child:  Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          StreamBuilder(
                                            stream: widget.expertPresenter!.valueErrorObserve,
                                            builder: (context,AsyncSnapshot<String>snapshotValueError){
                                              if(snapshotValueError.data != null){
                                                return   Text(
                                                  snapshotValueError.data!,
                                                  textAlign: TextAlign.center,
                                                    style:  context.textTheme.bodyMedium!.copyWith(
                                                      color: Color(0xff707070),
                                                    )
                                                );
                                              }else{
                                                return  Container();
                                              }
                                            },
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: ScreenUtil().setWidth(32)
                                              ),
                                              child:    ExpertButton(
                                                title: 'تلاش مجدد',
                                                onPress: (){
                                                  widget.expertPresenter!.getTurnover(state: 0);
                                                },
                                                enableButton: true,
                                                isLoading: false,
                                              )
                                          )
                                        ],
                                      )
                                  );
                                }else{
                                  return Center(
                                    child:  LoadingViewScreen(
                                        color: ColorPallet().mainColor
                                    ),
                                  );
                                }
                              }else{
                                return  Container();
                              }
                            },
                          );
                        }
                      }else{
                        return  Container();
                      }
                    },
                  ),
                ],
              )
            ),
          ],
        ),
      ) ,
    );
  }



}

