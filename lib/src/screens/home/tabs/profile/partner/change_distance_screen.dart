import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/partner_presenter.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/screens/home/tabs/profile/partner/partner_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:impo/src/screens/home/home.dart';
import '../../../../../architecture/presenter/partner_tab_presenter.dart';
import '../../../../../firebase_analytics_helper.dart';
import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';

class ChangeDistanceScreen extends StatefulWidget{
  final distanceType;
  final PartnerPresenter? presenter;
  final PartnerTabPresenter? partnerTabPresenter;
  final bool? isEdit;
  ChangeDistanceScreen({Key? key,this.distanceType,this.presenter,this.partnerTabPresenter,this.isEdit}):super (key:key);

  @override
  State<StatefulWidget> createState() => ChangeDistanceScreenState();
}

class ChangeDistanceScreenState extends State<ChangeDistanceScreen>{

  late int indexList;
  List<String> yesOrNo = ['نزدیک به هم','دور از هم'];

  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.ChangeDistancePg_Self_Pg_Load);
    AnalyticsHelper().enableEventsList([AnalyticsEvents.ChangeDistancePg_DistanceTpList_Picker_Scr]);
    setDefaultValue();
    super.initState();
  }

  setDefaultValue(){
    if(this.mounted){
      setState(() {
        indexList = widget.distanceType != null ? widget.distanceType : 0;
      });
    }
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.ChangeDistancePg_Back_NavBar_Clk);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.isEdit!){
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child:  PartnerScreen()
            )
        );
      }else{
        Navigator.pushReplacement(context,
            PageTransition(
                settings: RouteSettings(name: "/Page1"),
                type: PageTransitionType.topToBottom,
                child:  FeatureDiscovery(
                    recordStepsInSharedPreferences: true,
                    child: Home(
                      indexTab: 2,
                      register: true,
                      isChangeStatus: false,
                    )
                )
            )
        );
      }
    });
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = 0.5;
    return  WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child:  Scaffold(
          backgroundColor: Colors.white,
          body:  Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
               CustomAppBar(
                messages: false,
                profileTab: true,
                icon: 'assets/images/ic_arrow_back.svg',
                titleProfileTab: 'صفحه قبل',
                subTitleProfileTab: 'نوع رابطه',
                 isEmptyLeftIcon: true,
                onPressBack: (){
                  AnalyticsHelper().log(AnalyticsEvents.ChangeDistancePg_Back_Btn_Clk);
                  Navigator.pop(context);
                },
              ),
               Flexible(
                 child: Padding(
                   padding:  EdgeInsets.only(
                       top: ScreenUtil().setWidth(100)
                   ),
                   child:  Column(
                     children: <Widget>[
                       Flexible(
                         flex: 2,
                         child: Text(
                           'ایمپویی عزیز\nلطفا نوع رابطه خود را انتخاب کنید',
                           textAlign: TextAlign.center,
                           style: context.textTheme.bodyLarge,
                         ),
                       ),
                       Flexible(
                         flex: 2,
                         child: Align(
                           alignment: Alignment.center,
                           child:  Container(
                               alignment: Alignment.center,
                               height: ScreenUtil().setWidth(220),
                               child:  Center(
                                   child:  NotificationListener<OverscrollIndicatorNotification>(
                                     onNotification: (overscroll) {
                                       overscroll.disallowIndicator();
                                       return true;
                                     },
                                     child:   CupertinoPicker(
                                         scrollController: FixedExtentScrollController(initialItem:indexList),
                                         itemExtent: ScreenUtil().setWidth(110),
                                         onSelectedItemChanged: (index){
                                           AnalyticsHelper().log(AnalyticsEvents.ChangeDistancePg_DistanceTpList_Picker_Scr,remainEventActive: false);
                                           indexList = index;
                                         },
                                         children: List.generate(yesOrNo.length, (index){
                                           return  Center(
                                             child:  Text(
                                               yesOrNo[index],
                                               style: context.textTheme.labelLarge!.copyWith(
                                                   color: ColorPallet().mainColor
                                               ),
                                             ),
                                           );
                                         })
                                     ),
                                   )
                               )
                           ),
                         ),
                       ),
                       Flexible(
                           child:   Padding(
                               padding: EdgeInsets.only(
                                   top: ScreenUtil().setWidth(0)
                               ),
                               child:  widget.isEdit! ?
                               StreamBuilder(
                                 stream: widget.presenter!.isLoadingButtonObserve,
                                 builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                                   if(snapshotIsLoading.data != null){
                                     if(!snapshotIsLoading.data!){
                                       return   CustomButton(
                                         title: 'ثبت ویرایش',
                                         onPress: onPressEdit,
                                         enableButton: true,
                                         colors: [
                                           ColorPallet().mentalHigh,ColorPallet().mentalMain
                                         ],
                                       );
                                     }else{
                                       return  LoadingViewScreen(
                                         color: ColorPallet().mainColor,
                                         width: ScreenUtil().setWidth(80),
                                       );
                                     }
                                   }else{
                                     return  Container();
                                   }
                                 },
                               ) :
                               StreamBuilder(
                                 stream: widget.partnerTabPresenter!.isLoadingButtonObserve,
                                 builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                                   if(snapshotIsLoading.data != null){
                                     if(!snapshotIsLoading.data!){
                                       return   CustomButton(
                                         title: 'تایید',
                                         onPress: onPressAccept,
                                         enableButton: true,
                                         colors: [
                                           ColorPallet().mentalHigh,ColorPallet().mentalMain
                                         ],
                                       );
                                     }else{
                                       return  LoadingViewScreen(
                                         color: ColorPallet().mainColor,
                                         width: ScreenUtil().setWidth(80),
                                       );
                                     }
                                   }else{
                                     return  Container();
                                   }
                                 },
                               ),
                           )
                       )
                     ],
                   ),
                 ),
               ),
               Container()
            ],
          ),
        ),
      ),
    );
  }

  onPressEdit(){
    AnalyticsHelper().log(AnalyticsEvents.ChangeDistancePg_Edit_Btn_Clk);
    widget.presenter!.changeDistanceType(indexList,context);
  }

  onPressAccept(){
    AnalyticsHelper().log(AnalyticsEvents.ChangeDistancePg_Accept_Btn_Clk);
    widget.partnerTabPresenter!.acceptPartner(context,indexList);
  }

}