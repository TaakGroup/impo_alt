import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/expert_presenter.dart';
import 'package:get/get.dart';
import 'package:impo/src/screens/home/tabs/expert/item_doctor_widget.dart';
import '../../../../components/colors.dart';
import '../../../../components/custom_appbar.dart';
import '../../../../components/expert_button.dart';
import '../../../../components/loading_view_screen.dart';
import '../../../../firebase_analytics_helper.dart';
import '../../../../models/expert/ticket_info_model.dart';

class DoctorListScreen extends StatefulWidget {
  final ExpertPresenter? expertPresenter;
  const DoctorListScreen({Key? key,this.expertPresenter}) : super(key: key);

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.DoctorListPg_Back_NavBar_Clk);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: Colors.white,
            body:   StreamBuilder(
              stream: widget.expertPresenter!.isLoadingObserve,
              builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                if(snapshotIsLoading.data != null){
                  if(!snapshotIsLoading.data!){
                    return StreamBuilder(
                      stream: widget.expertPresenter!.ticketInfoObserve,
                      builder: (context,AsyncSnapshot<TicketInfoAdviceModel>snapshotTicketInfo){
                        if(snapshotTicketInfo.data != null){
                          return  ListView(
                            padding: EdgeInsets.zero,
                            // shrinkWrap: true,
                            addAutomaticKeepAlives: false,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
                                child:  CustomAppBar(
                                  messages: true,
                                  profileTab: true,
                                  subTitleProfileTab: "کلینیک",
                                  valuePolar: snapshotTicketInfo.data!.currentValue.toString(),
                                  titleProfileTab: 'صفحه قبل',
                                  icon: 'assets/images/ic_arrow_back.svg',
                                  isPolar: true,
                                  onPressBack: (){
                                    AnalyticsHelper().log(AnalyticsEvents.DoctorListPg_Back_Btn_Clk);
                                    Navigator.pop(context);
                                  },
                                  expertPresenter: widget.expertPresenter!,
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
                                    child: Text(
                                      '${widget.expertPresenter!.getName()} عزیز می‌تونی از لیست مشاوران ما یکی رو انتخاب کنی',
                                      style: context.textTheme.bodyMedium,
                                    ),
                                  ),
                                  SizedBox(height: ScreenUtil().setWidth(30)),
                                  ListView.builder(
                                    primary: false,
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: snapshotTicketInfo.data!.info.dr.length,
                                    itemBuilder: (context,index){
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: ScreenUtil().setWidth(20)
                                        ),
                                        child: ItemDoctorWidget(
                                            doctorInfo: snapshotTicketInfo.data!.info.dr[index],
                                            changeSelected: (){
                                              AnalyticsHelper().log(
                                                  AnalyticsEvents.DoctorListPg_DoctorList_Item_Clk,
                                                  parameters: {
                                                    'id' : snapshotTicketInfo.data!.info.dr[index].id
                                                  }
                                              );
                                              widget.expertPresenter!.changeSelectedDoctor(index,context);
                                            },
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: ScreenUtil().setWidth(30)),
                                ],
                              )
                            ],
                          );
                        }else{
                          return Container();
                        }
                      },
                    );
                  }else{
                    return  Center(
                        child:  StreamBuilder(
                          stream: widget.expertPresenter!.tryButtonErrorObserve,
                          builder: (context,AsyncSnapshot<bool>snapshotTryButton){
                            if(snapshotTryButton.data != null){
                              if(snapshotTryButton.data!){
                                return  Padding(
                                    padding: EdgeInsets.only(
                                        right: ScreenUtil().setWidth(80),
                                        left: ScreenUtil().setWidth(80),
                                        top : ScreenUtil().setWidth(200)
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
                                                widget.expertPresenter!.getDoctorInfo();
                                              },
                                              enableButton: true,
                                              isLoading: false,
                                            )
                                        )
                                      ],
                                    )
                                );
                              }else{
                                return  LoadingViewScreen(
                                    color: ColorPallet().mainColor
                                );
                              }
                            }else{
                              return  Container();
                            }
                          },
                        )
                    );
                  }
                }else{
                  return Container();
                }
              },
            )
        )
      ),
    );
  }
}
