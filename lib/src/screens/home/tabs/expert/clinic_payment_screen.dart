
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/expert_presenter.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../components/animations.dart';
import '../../../../components/colors.dart';
import '../../../../components/custom_button.dart';
import '../../../../data/http.dart';
import '../../../../firebase_analytics_helper.dart';
import '../../../../models/expert/ticket_info_model.dart';

class ClinicPaymentScreen extends StatefulWidget{
  final ExpertPresenter? expertPresenter;
  final ticketId;
  final TicketInfoAdviceModel? ticketInfoAdviceModel;

  ClinicPaymentScreen({Key? key,this.expertPresenter,this.ticketId,this.ticketInfoAdviceModel}) : super(key:key);

  @override
  State<StatefulWidget> createState() => ClinicPaymentScreenState();
}

class ClinicPaymentScreenState extends State<ClinicPaymentScreen> with TickerProviderStateMixin{

  Animations _animations =  Animations();

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.ClinicPaymentPg_Back_NavBar_Clk);
    return Future.value(true);
  }

  @override
  void initState() {
    _animations.shakeError(this);
    widget.expertPresenter!.discountCodeController = TextEditingController(text: widget.ticketInfoAdviceModel!.info.discountCode);
    widget.expertPresenter!.setLoadings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = 0.5;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: StreamBuilder(
            stream: widget.expertPresenter!.ticketInfoObserve,
            builder: (context,AsyncSnapshot<TicketInfoAdviceModel>snapshotTicketInfo){
              if(snapshotTicketInfo.data != null){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child:    ListView(
                        padding: EdgeInsets.zero,
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
                                AnalyticsHelper().log(AnalyticsEvents.ClinicPaymentPg_Back_Btn_Clk);
                                Navigator.pop(context);
                              },
                              expertPresenter: widget.expertPresenter!,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: ScreenUtil().setWidth(30)
                              ),
                              child: Text(
                                'مشاوره آنلاین با پزشک',
                                textAlign: TextAlign.center,
                                style: context.textTheme.labelMediumProminent
                              ),
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setWidth(20)),
                          StreamBuilder(
                            stream: widget.expertPresenter!.selectedDoctorObserve,
                            builder: (context,AsyncSnapshot<DoctorInfoModel>snapshotSelectedDoctorInfo){
                              if(snapshotSelectedDoctorInfo.data != null){
                                DoctorInfoModel doctorInfo = snapshotSelectedDoctorInfo.data!;
                                return Padding(
                                  padding: EdgeInsets.only(
                                    right: ScreenUtil().setWidth(30)
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: ScreenUtil().setWidth(140),
                                        width: ScreenUtil().setWidth(140),
                                        decoration:  BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Color(0xffF2F2F2),
                                                width: ScreenUtil().setWidth(2)
                                            ),
                                            image:  DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  '$mediaUrl/file/${doctorInfo.image}',
                                                )
                                            )
                                        ),
                                      ),
                                      SizedBox(width: ScreenUtil().setWidth(16)),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${doctorInfo.firstName} ${doctorInfo.lastName}',
                                            style: context.textTheme.labelMediumProminent
                                          ),
                                          Text(
                                            doctorInfo.speciliaty,
                                            style: context.textTheme.labelSmall
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }else{
                                return Container();
                              }
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setWidth(25),
                                bottom: ScreenUtil().setWidth(10)
                            ),
                            child: Divider(
                              color: Color(0xffF8F8F8),
                              thickness: 4,
                            ),
                          ),
                          discountBox(snapshotTicketInfo.data!),
                          Padding(
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setWidth(25),
                                bottom: ScreenUtil().setWidth(10)
                            ),
                            child: Divider(
                              color: Color(0xffF8F8F8),
                              thickness: 4,
                            ),
                          ),
                          // doctorBox(snapshotTicketInfo.data.info.dr[0]),
                          payBox(snapshotTicketInfo.data!),
                          Padding(
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setWidth(25),
                                bottom: ScreenUtil().setWidth(10)
                            ),
                            child: Divider(
                              color: Color(0xffF8F8F8),
                              thickness: 4,
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setWidth(15)),
                          supportBox(snapshotTicketInfo.data!),
                          SizedBox(height: ScreenUtil().setWidth(50)),
                        ],
                      ),
                    ),
                    payButton(snapshotTicketInfo.data!)
                  ],
                );
              }else{
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget discountBox(TicketInfoAdviceModel ticketInfo){
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(30)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'کد تخفیف',
            style: context.textTheme.labelMediumProminent
          ),
          SizedBox(height: ScreenUtil().setWidth(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child:  Container(
                    height: ScreenUtil().setWidth(80),
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setWidth(0),
                    ),
                    decoration:  BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:  ColorPallet().gray.withOpacity(0.3),
                        ),
                        boxShadow:  [
                          BoxShadow(
                              color: Color(0xff989898).withOpacity(0.15),
                              blurRadius: 5.0
                          )
                        ]

                    ),
                    child:  Center(
                        child:  Theme(
                          data: Theme.of(context).copyWith(
                            textSelectionTheme: TextSelectionThemeData(
                                selectionColor: Color(0xffaaaaaa),
                                cursorColor: ColorPallet().mainColor
                            ),
                          ),
                          child:  TextField(
                            autofocus: false,
                            maxLength: 20,
                            enableInteractiveSelection: false,
                            style:  context.textTheme.labelMedium,
                            controller: widget.expertPresenter!.discountCodeController,
                            decoration:  InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              hintText: 'کد تخفیف',
                              hintStyle:  context.textTheme.labelMedium!.copyWith(
                                color: ColorPallet().gray.withOpacity(0.5),
                              ),
                              contentPadding:  EdgeInsets.only(
                                right: ScreenUtil().setWidth(20),
                                left: ScreenUtil().setWidth(10),
//                                                  bottom: ScreenUtil().setWidth(20),
//                                          top: ScreenUtil().setWidth(20),
                              ),
                            ),
                          ),
                        )
                    )
                ),
              ),
              SizedBox(width: ScreenUtil().setWidth(20)),
              Flexible(
                child: StreamBuilder(
                  stream: widget.expertPresenter!.isLoadingDiscountButtonObserve,
                  builder: (context,snapshotIsLoadingDiscountButton){
                    if(snapshotIsLoadingDiscountButton.data != null){
                      return CustomButton(
                        title: 'اعمال تخفیف',
                        margin: 0,
                        height: ScreenUtil().setWidth(80),
                        colors: [Color(0xff8925D1),Color(0xff8925D1)],
                        enableButton: true,
                        borderRadius: 10.0,
                        isLoadingButton: snapshotIsLoadingDiscountButton.data,
                        onPress: (){
                          if(!widget.expertPresenter!.isLoadingButton.stream.value){
                            AnalyticsHelper().log(AnalyticsEvents.ClinicPaymentPg_applyDiscount_Btn_Clk);
                            widget.expertPresenter!.applyDiscount(ticketInfo);
                          }
                        },
                        textStyle: context.textTheme.labelMedium!.copyWith(
                          color: Colors.white
                        ),
                      );
                    }else{
                      return Container();
                    }
                  },
                ),
              )
            ],
          ),
          SizedBox(height:ScreenUtil().setWidth(5)),
          StreamBuilder(
            stream: widget.expertPresenter!.validApplyDiscountObserve,
            builder: (context,AsyncSnapshot<bool>snapshotValidDiscount){
              if(snapshotValidDiscount.data != null){
                return Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: snapshotValidDiscount.data! ? Color(0xff8925D1) :  Color(0xffEE5858),
                      size: ScreenUtil().setWidth(25),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(5),),
                    Text(
                      ticketInfo.info.discountMessage,
                      style:context.textTheme.labelSmall!.copyWith(
                        color: snapshotValidDiscount.data! ? Color(0xff8925D1) :  Color(0xffEE5858),
                      ),
                    )
                  ],
                );
              }else{
                return Container();
              }
            },
          )
        ],
      ),
    );
  }

  Widget payBox(TicketInfoAdviceModel ticketInfo){
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(30)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اطلاعات پرداخت',
            style: context.textTheme.labelMediumProminent
          ),
          SizedBox(height: ScreenUtil().setWidth(15)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'هزینه مشاوره',
                style: context.textTheme.labelMedium
              ),
              Text(
                '${ticketInfo.info.price} ${ticketInfo.info.priceUnit}',
                  style: context.textTheme.labelMedium
              ),
            ],
          ),
          SizedBox(height: ScreenUtil().setWidth(12)),
          ticketInfo.info.discountString != '' ?
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ticketInfo.info.discountString,
                  style: context.textTheme.labelMedium
              ),
              Text(
                '${ticketInfo.info.discountPrice} ${ticketInfo.info.priceUnit}',
                  style: context.textTheme.labelMedium
              ),
            ],
          ) : Container(),
          ticketInfo.info.discountString != '' ?
          SizedBox(height: ScreenUtil().setWidth(12)) : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'اعتبار شما',
                  style: context.textTheme.labelMedium
              ),
              Text(
                '${ticketInfo.info.currentValue} ${ticketInfo.info.priceUnit}',
                  style: context.textTheme.labelMedium
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(25),
              bottom: ScreenUtil().setWidth(13),
            ),
            color: Color(0xffE4E4E4),
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'قابل پرداخت',
                style: context.textTheme.labelSmallProminent
              ),
              Text(
                '${ticketInfo.info.payPrice} ${ticketInfo.info.priceUnit}',
                style: context.textTheme.labelSmallProminent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget payButton(TicketInfoAdviceModel ticketInfo){
    return   StreamBuilder(
      stream: widget.expertPresenter!.isLoadingButtonObserve,
      builder: (context,snapshotIsLoadingButton){
        if(snapshotIsLoadingButton.data != null){
          return  Padding(
            padding: EdgeInsets.only(
                bottom: ScreenUtil().setWidth(30)
            ),
            child: CustomButton(
              title: ticketInfo.info.submit,
              margin: 30,
              // height: ScreenUtil().setWidth(50),
              colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
              enableButton: true,
              isLoadingButton: snapshotIsLoadingButton.data,
              onPress: (){
                if(!widget.expertPresenter!.isLoadingDiscountButton.stream.value){
                  AnalyticsHelper().log(AnalyticsEvents.ClinicPaymentPg_sendQuestion_Btn_Clk);
                  widget.expertPresenter!.createTicketNewClinic(context,
                      widget.expertPresenter!,widget.ticketId,_animations);
                }
              },
            ),
          );
        }else{
          return Container();
        }
      },
    );
  }

  Widget supportBox(TicketInfoAdviceModel ticketInfo){
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(30)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ticketInfo.info.support.title,
            style: context.textTheme.labelSmallProminent
          ),
          SizedBox(height: ScreenUtil().setWidth(15)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(15),
              vertical: ScreenUtil().setWidth(20)
            ),
            decoration: BoxDecoration(
              color: Color(0xffF8F8F8),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${ticketInfo.info.support.helper}:',
                    style: context.textTheme.labelSmall
                ),
                GestureDetector(
                  onTap: (){
                    AnalyticsHelper().log(AnalyticsEvents.ClinicPaymentPg_callSupport_Btn_Clk);
                    _makePhoneCall('tel:${ticketInfo.info.support.phone}');
                  },
                  child: Row(
                    children: [
                      Text(
                        ticketInfo.info.support.phone,
                        style: context.textTheme.labelSmallProminent!.copyWith(
                          color: Color(0xff8925D1),
                        )
                      ),
                      SizedBox(width: ScreenUtil().setWidth(5)),
                      Icon(
                        Icons.headset_mic,
                        color: Color(0xff8925D1),
                        size: ScreenUtil().setWidth(30),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }


  Future<void> _makePhoneCall(String url) async {

    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
  }

}