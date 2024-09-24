

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/register_presenter.dart';
import 'package:impo/src/architecture/view/register_view.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/bottom_text_register.dart';
import 'package:impo/src/components/circle_check_radio_widget.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/item_radio_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/LoginAndRegister/globalRegister/select_status_screen.dart';
import 'package:impo/src/screens/LoginAndRegister/identity/set_password_screen.dart';
import 'package:impo/src/screens/LoginAndRegister/menstruationRegister/periodDay_register_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../../../firebase_analytics_helper.dart';

class IntentionInstallScreen extends StatefulWidget{

  final phoneOrEmail;

  IntentionInstallScreen({Key? key,this.phoneOrEmail}):super(key:key);

  @override
  State<StatefulWidget> createState() => IntentionInstallScreenState();
}

class IntentionInstallScreenState extends State<IntentionInstallScreen>with TickerProviderStateMixin implements RegisterView{

  late RegisterPresenter _presenter;

  IntentionInstallScreenState(){
    _presenter = RegisterPresenter(this);
  }

  bool enableButton = false;
  List<ItemRadioModel> items = [
    ItemRadioModel(
      title: 'پیشگیری از بارداری',
      periodStatus: 1,
      selected: false,
    ),
    ItemRadioModel(
      title: 'اقدام به بارداری',
      periodStatus: 2,
      selected: false,
    )
  ];

  @override
  void initState() {
    //AnalyticsHelper().log(AnalyticsEvents.SexualRegPg_Cont_Btn_Clk);
    super.initState();
  }

  Future<bool> _onWillPop()async{
   // AnalyticsHelper().log(AnalyticsEvents.SexualRegPg_Back_NavBar_Clk);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.5;
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
          textDirection: TextDirection.rtl,
          child:  Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              body:
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(120),
                          bottom: ScreenUtil().setWidth(80)
                      ),
                      height: ScreenUtil().setWidth(180),
                      width: ScreenUtil().setWidth(180),
                      child:  Image.asset(
                        'assets/images/file.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil().setWidth(100),
                        right: ScreenUtil().setWidth(50),
                        left: ScreenUtil().setWidth(50),
                      ),
                      child:   Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'ایمپو چطور میتونه بهت کمک کنه؟',
                            textAlign: TextAlign.center,
                              style: context.textTheme.labelLarge
                          ),
                          SizedBox(height: ScreenUtil().setWidth(8)),
                          Text(
                            'اگه بدونیم ایمپو رو با چه هدفی نصب کردی، بهتر می‌تونیم کمکت کنیم',
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodySmall!.copyWith(
                              color: ColorPallet().gray,
                            )
                          ),
                        ],
                      )
                    ),
                    // SizedBox(height: ScreenUtil().setHeight(100)),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: items.length,
                      itemBuilder: (context,int index){
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              if(!enableButton){
                                enableButton = true;
                              }
                              for(int i=0 ; i < items.length ; i++){
                                items[i].selected = false;
                              }
                              items[index].selected = true;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              right: ScreenUtil().setWidth(40),
                              left: ScreenUtil().setWidth(40),
                              bottom: ScreenUtil().setWidth(30),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(40),
                              vertical: ScreenUtil().setWidth(50)
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: items[index].selected ? ColorPallet().mainColor
                                    : Color(0xffEFEFEF)
                              )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  items[index].title!,
                                  style: context.textTheme.labelLarge!.copyWith(
                                    color:  Color(0xff1C1B1E),
                                  )
                                ),
                                CircleCheckRadioWidget(
                                  isSelected: items[index].selected,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.center,
                      child:  StreamBuilder(
                        stream: _presenter.isLoadingObserve,
                        builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                          if(snapshotIsLoading.data != null){
                            if(!snapshotIsLoading.data!){
                              return  Padding(
                                padding: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(100),
                                ),
                                child:  CustomButton(
                                  title: 'ادامه',
                                  onPress: (){
                                    if(enableButton){
                                      pressNext();
                                    }
                                  },
                                  colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                                  borderRadius: 10.0,
                                  enableButton: enableButton,
                                ),
                              );
                            }else{
                              return  Padding(
                                padding: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(100),
                                    bottom: ScreenUtil().setWidth(30)
                                ),
                                child:  LoadingViewScreen(
                                    color: ColorPallet().mainColor
                                ),
                              );
                            }
                          }else{
                            return  Container();
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
                child: BottomTextRegister(),
              )
          )
      ),
    );
  }

  pressNext(){
    int periodStatus = 0;
    for(int i=0 ; i<items.length ; i++){
      if(items[i].selected){
        periodStatus = items[i].periodStatus!;
      }
    }

    print(periodStatus);
    var registerInfo = locator<RegisterParamModel>();
    registerInfo.setPeriodStatus(periodStatus);

    Navigator.push(
        context,
        PageTransition(
            child: PeriodDayRegisterScreen(
              phoneOrEmail: widget.phoneOrEmail,
              hasAbortion: false,
            ),
            type: PageTransitionType.fade
        )
    );

  }

  @override
  void onError(msg) {

  }

  @override
  void onSuccess(msg)async{

  }


}