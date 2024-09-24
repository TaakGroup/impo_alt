import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:impo/src/architecture/presenter/partner_tab_presenter.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/firebase_analytics_helper.dart';
import 'package:impo/src/models/partner/get_requests_model.dart';
import 'package:impo/src/models/partner/partner_slider_model.dart';
import 'package:impo/src/screens/home/tabs/partnerTab/widgets/partner_carousel_slider_with_indicator.dart';
import 'package:impo/src/screens/home/tabs/profile/partner/change_distance_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/partner/partner_screen.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

class NoPartnerWidget extends StatelessWidget{

  final PartnerTabPresenter? partnerTabPresenter;

  const NoPartnerWidget({Key? key,
    this.partnerTabPresenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PartnerCarouselSliderWithIndicator(
          itemBuilder: (context, index, realIndex) =>
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  partnerSliderList[index].image!,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
          itemCount: partnerSliderList.length,
        ),
        SizedBox(height: ScreenUtil().setWidth(50),),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(30)
          ),
          child: Text(
              '${partnerTabPresenter!.getName()} برای شروع همدلی و استفاده از ویژگی‌های بالا، پارتنرت رو اضافه کن',
              textAlign: TextAlign.center,
              style: context.textTheme.labelMedium
          ),
        ),
        SizedBox(height: ScreenUtil().setWidth(20),),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(30)
          ),
          child: CustomButton(
            onPress: ()  {
              AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_AddPartner_Btn_Clk);
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: PartnerScreen(
                          partnerTabPresenter: partnerTabPresenter!)
                  )
              );
            },
            margin: 0,
            height: ScreenUtil().setWidth(75),
            colors: [ColorPallet().mainColor, ColorPallet().mainColor],
            borderRadius: 20.0,
            enableButton: true,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline_outlined,
                    color: Colors.white,
                    size: ScreenUtil().setWidth(40),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(5)),
                  Text(
                      'شروع همدلی و اضافه‌کردن پارتنر',
                      textAlign: TextAlign.center,
                      style:  context.textTheme.labelLarge!.copyWith(
                        color:  Colors.white,
                      )
                  ),

                ]
            ),
          ),
        ),
        SizedBox(height: ScreenUtil().setWidth(30)),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(30)
          ),
          child: CustomButton(
            onPress: ()  {
              // AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_AddPartner_Btn_Clk);
              _launchURL('https://impo.app/sympathy/');
            },
            margin: 0,
            height: ScreenUtil().setWidth(75),
            colors: [Colors.white,Colors.white],
            borderRadius: 20.0,
            enableButton: true,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'چطور همدلم رو اضافه کنم؟',
                      textAlign: TextAlign.center,
                      style:  context.textTheme.labelMedium
                  ),
                  SizedBox(width: ScreenUtil().setWidth(5)),
                  Text(
                      'اینجا کلیک کن',
                      textAlign: TextAlign.center,
                      style:  context.textTheme.labelMedium!.copyWith(
                        color:  ColorPallet().mainColor,
                      )
                  ),

                ]
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(30),
              bottom: ScreenUtil().setWidth(20)
          ),
          child: Divider(
            color: Color(0xffF8F8F8),
            thickness: 4,
          ),
        ),
        StreamBuilder(
          stream: partnerTabPresenter!.requestsObserve,
          builder: (context,AsyncSnapshot<List<GetRequestsModel>>snapshotRequests){
            if(snapshotRequests.data != null){
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(30)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                              'درخواست ها',
                              style: context.textTheme.labelMediumProminent!.copyWith(
                                color: Color(0xffCBCBCB),
                              )
                          ),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(10)),
                        StreamBuilder(
                          stream: partnerTabPresenter!.isLoadingRefreshIconObserve,
                          builder: (context,AsyncSnapshot<bool>snapshotIsLoadingRefreshIcon){
                            if(snapshotIsLoadingRefreshIcon.data != null){
                              if(!snapshotIsLoadingRefreshIcon.data!){
                                return GestureDetector(
                                  onTap: (){
                                    AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_RefreshRequests_Icon_Clk);
                                    partnerTabPresenter!.getRequest(true,context);
                                  },
                                  child: Container(
                                      width: ScreenUtil().setWidth(40),
                                      height: ScreenUtil().setWidth(40),
                                      child:  SvgPicture.asset(
                                        'assets/images/ic_refresh.svg',
                                        fit: BoxFit.fitHeight,
                                      )
                                  ),
                                );
                              }else{
                                return LoadingViewScreen(
                                  color: Color(0xffB8B8B8),
                                  width: ScreenUtil().setWidth(30),
                                  lineWidth: ScreenUtil().setWidth(3.5),
                                );
                              }
                            }else{
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setWidth(20)),
                    snapshotRequests.data!.length != 0
                        ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: snapshotRequests.data!.length,
                      itemBuilder: (context,index){
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: ScreenUtil().setWidth(20)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  snapshotRequests.data![index].isRecv ?
                                  snapshotRequests.data![index].name :
                                  'درخواست به ${snapshotRequests.data![index].name}',
                                  style: context.textTheme.labelMedium
                              ),
                              Row(
                                children: [
                                  CustomButton(
                                    onPress: ()  {
                                      if(snapshotRequests.data![index].isRecv){
                                        AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_RejectPartner_Btn_Clk);
                                      }else{
                                        AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_CancelPartner_Btn_Clk);
                                      }
                                      partnerTabPresenter!.selectedPartner = snapshotRequests.data![index];
                                      partnerTabPresenter!.rejectPartnerShowDialog();
                                    },
                                    margin: 0,
                                    height: ScreenUtil().setWidth(50),
                                    colors: [Colors.white,Colors.white],
                                    borderColor: Color(0xff000000).withOpacity(0.09),
                                    borderRadius: 20.0,
                                    enableButton: true,
                                    title: snapshotRequests.data![index].isRecv ? 'رد کردن' : 'انصراف',
                                    textColor: Color(0xff0C0C0D),
                                    textStyle: context.textTheme.labelMedium,
                                    padding: ScreenUtil().setWidth(20),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(10),),
                                  CustomButton(
                                    onPress: ()  {
                                      if(snapshotRequests.data![index].isRecv){
                                        partnerTabPresenter!.selectedPartner = snapshotRequests.data![index];
                                        showBottomSheetAcceptPartner(context);
                                        // AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_AcceptPartner_Btn_Clk);
                                        // Navigator.pushReplacement(
                                        //     context,
                                        //     PageTransition(
                                        //         type: PageTransitionType.fade,
                                        //         duration: Duration(milliseconds: 500),
                                        //         child: ChangeDistanceScreen(
                                        //           partnerTabPresenter: widget.partnerTabPresenter!,
                                        //           isEdit: false,
                                        //         )
                                        //     )
                                        // );
                                      }
                                    },
                                    margin: 0,
                                    height: ScreenUtil().setWidth(50),
                                    colors: [ColorPallet().mainColor,ColorPallet().mainColor],
                                    borderColor: Color(0xff000000).withOpacity(0.09),
                                    borderRadius: 20.0,
                                    textStyle: context.textTheme.labelMedium!.copyWith(
                                        color: Colors.white
                                    ),
                                    enableButton: snapshotRequests.data![index].isRecv ? true : false,
                                    title: snapshotRequests.data![index].isRecv ? 'قبول کردن' : 'در انتظار',
                                    padding: ScreenUtil().setWidth(20),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ) :
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                          'هیچ درخواستی موجود نیست',
                          style: context.textTheme.labelMedium
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setWidth(80),),
                  ],
                ),
              );
            }else{
              return Container();
            }
          },
        )
      ],
    );
  }

  showBottomSheetAcceptPartner(context){
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(30)
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height /2.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(15)
                      ),
                      height: ScreenUtil().setWidth(5),
                      width: ScreenUtil().setWidth(100),
                      decoration:  BoxDecoration(
                          color: Color(0xff707070).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15)
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setWidth(20)),
                    Text(
                        'با قبول کردن درخواست همدلی ${partnerTabPresenter!.selectedPartner.name} اجازه دسترسی به قسمت های زیر رو بهش میدی',
                        textAlign: TextAlign.start,
                        style: context.textTheme.labelMediumProminent
                    ),
                    Column(
                      children: List.generate(
                          partnerTabPresenter!.acceptPartnerAccess.length, (index) =>
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: ScreenUtil().setWidth(12)
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: ScreenUtil().setWidth(15),
                                  height: ScreenUtil().setWidth(15),
                                  decoration: BoxDecoration(
                                      color: Color(0xff0C0C0D),
                                      shape: BoxShape.circle
                                  ),
                                ),
                                SizedBox(width: ScreenUtil().setWidth(15)),
                                Text(
                                    partnerTabPresenter!.acceptPartnerAccess[index],
                                    style: context.textTheme.labelMedium
                                )
                              ],
                            ),
                          )
                      ),
                    ),
                    Text(
                        'لازمه بدونی پارتنرت به یادداشت‌هات، مشاوره‌های آنلاینت در کلینیک و نشانه‌هایی که انتخاب کردی دسترسی نداره',
                        style: context.textTheme.labelSmall!.copyWith(
                          color: Color(0xffBA1A1A),
                        )
                    ),
                    SizedBox(height: ScreenUtil().setWidth(35)),
                    CustomButton(
                      onPress: ()  {
                        AnalyticsHelper().log(AnalyticsEvents.PartnerTabPg_AcceptPartner_Btn_Clk);
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 500),
                                child: ChangeDistanceScreen(
                                  partnerTabPresenter: partnerTabPresenter!,
                                  isEdit: false,
                                )
                            )
                        );
                      },
                      margin: 100,
                      height: ScreenUtil().setWidth(75),
                      colors: [Colors.white,Colors.white],
                      borderColor: Color(0xff000000).withOpacity(0.09),
                      borderRadius: 20.0,
                      enableButton: true,
                      textColor: ColorPallet().mainColor,
                      title: 'تایید همدلی',
                    ),
                    SizedBox(height: ScreenUtil().setWidth(50)),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<bool> _launchURL(String url) async {
    String httpUrl = '';
    if(url.startsWith('http')){
      httpUrl = url;
    }else{
      httpUrl = 'https://$url';
    }
    if (!await launch(httpUrl)) throw 'Could not launch $httpUrl';
    return true;
  }
  
}