
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/profile_presenter.dart';
import 'package:impo/src/architecture/view/profile_view.dart';
import 'package:impo/src/components/calender.dart';
import 'package:impo/src/components/circle_check_radio_widget.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/text_field_area.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/item_radio_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/home/tabs/profile/edit_profile.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../../../../firebase_analytics_helper.dart';

class EditValueScreen extends StatefulWidget{

  final modeChangeValue;
  final ProfilePresenter? presenter;
  final TextEditingController? nameController;
  final TextEditingController? birthDayController;
  final TextEditingController? sexController;
  final TextEditingController? countryController;
  final TextEditingController? intentionInstallController;

  EditValueScreen({Key? key,this.modeChangeValue,this.nameController,
    this.birthDayController,this.sexController,this.countryController,
    this.presenter,this.intentionInstallController}):super(key:key);

  @override
  State<StatefulWidget> createState() => EditValueScreenState();
}

class EditValueScreenState extends State<EditValueScreen> implements ProfileView{

  late ProfilePresenter _presenter;

  EditValueScreenState(){
    _presenter = ProfilePresenter(this);
  }


  // DataBaseProvider db  =  DataBaseProvider();
  // Map<String,dynamic> register = {};
  late String title;
  bool visibilityKeyBoard = false;
  List<String> yesOrNo = ['ندارم','دارم'];
  List<String> countries = ['ایران','افغانستان'];
  late int indexList;
  // String name;
  // String birthday;
  // String sex;
  // String country;
  bool readOnly = false;
  late Calender calender;
  late Jalali birthDateTime;
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
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    checkVisibilityKeyBoard();
    if(widget.modeChangeValue == 2){
      AnalyticsHelper().enableEventsList([AnalyticsEvents.EditValueSexTpPg_SexTpList_Picker_Scr]);
    }else if(widget.modeChangeValue == 3){
      AnalyticsHelper().enableEventsList([AnalyticsEvents.EditValueCountryPg_CountryList_Picker_Scr]);
    }
    // getRegisters();
    // checkVisibilityKeyBoard();
    setDefaultValue();
    super.initState();
  }

  //   getRegisters()async{
  //     var registerInfo =  locator<RegisterParamModel>();
  //     register['name'] = registerInfo.register.name;
  //     register['nationality'] = registerInfo.register.nationality;
  //     register['circleDay'] = registerInfo.register.circleDay;
  //     register['periodDay'] = registerInfo.register.periodDay;
  //     register['token'] = registerInfo.register.token;
  //     register['typeSex'] = registerInfo.register.sex;
  //     register['lastPeriod'] = registerInfo.register.lastPeriod;
  //     register['birthDay'] =registerInfo.register.birthDay;
  // }

  setDefaultValue(){
    if(widget.modeChangeValue == 0){
      // name = widget.nameController.text;
      title = 'دوست داری با چه اسم قشنگی تو ایمپو صدات کنیم؟';
    }else if(widget.modeChangeValue == 1){
      title = 'توی کدوم سال و ماه و روز، دنیا رو با اومدنت قشنگ‌تر کردی ؟';
      String birthday = widget.birthDayController!.text;
      List date = birthday.split('/');

      birthDateTime = Jalali(
          int.parse(date[0]),
          int.parse(date[1]),
          int.parse(date[2])
      );

    }else if(widget.modeChangeValue == 2){
      title = '${widget.presenter!.getRegister().name} جان آیا رابطه جنسی داری ؟';
      // sex = widget.sexController.text;
      if(widget.sexController!.text == 'رابطه جنسی دارم'){
        indexList = 1;
      }else if(widget.sexController!.text == 'رابطه جنسی ندارم'){
        indexList = 0;
      }
    }else if(widget.modeChangeValue == 3){
      title = 'ایمپویی عزیز لطفا کشور خود را انتخاب کنید';
      // country = widget.countryController.text;
      if(widget.countryController!.text == 'ایران'){
        indexList = 0;
      }else if(widget.countryController!.text == 'افغانستان'){
        indexList = 1;
      }
    }else{
      title = 'ایمپو چطور میتونه بهت کمک کنه؟';
      if(widget.intentionInstallController!.text == 'انتخاب کنید'){

      }else if(widget.intentionInstallController!.text == 'اقدام به بارداری'){
        enableButton = true;
        for(int i=0 ; i<items.length ; i++){
          if(items[i].periodStatus == 2){
            setState(() {
              items[i].selected = true;
            });
          }
        }
      }else if(widget.intentionInstallController!.text == 'پیشگیری از بارداری'){
        enableButton = true;
        for(int i=0 ; i<items.length ; i++){
          if(items[i].periodStatus == 1){
            setState(() {
              items[i].selected = true;
            });
          }
        }
      }
    }


  }

  checkVisibilityKeyBoard(){
    KeyboardVisibilityController().onChange.listen((bool visible) {
      if(mounted){
        if(visible){
          Timer(Duration(milliseconds: 50),(){
              if(scrollController.hasClients){
                scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500),curve: Curves.ease);
              }
          });
        }
      }
    });
  }

  back(){

    // if(widget.modeChangeValue == 0){
    //   widget.nameController.text = name ;
    //
    // }else if(widget.modeChangeValue == 1){
    //   widget.birthDayController.text = birthday ;
    //
    // }else if(widget.modeChangeValue == 2){
    //   widget.sexController.text = sex ;
    // }else if(widget.modeChangeValue == 3){
    //   widget.countryController.text = country;
    // }else{
    //
    // }

    Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child:   EditProfile(
              presenter: widget.presenter,
            )
        )
    );

  }

  Future<bool> _onWillPop()async{
    switch(widget.modeChangeValue){
      case 0: AnalyticsHelper().log(AnalyticsEvents.EditValueNamePg_Back_NavBar_Clk);
      break;
      case 1:  AnalyticsHelper().log(AnalyticsEvents.EditValueBirthdayPg_Back_NavBar_Clk);
      break;
      case 2: AnalyticsHelper().log(AnalyticsEvents.EditValueSexTpPg_Back_NavBar_Clk);
      break;
      case 3:AnalyticsHelper().log(AnalyticsEvents.EditValueCountryPg_Back_NavBar_Clk);
      break;
      case 4:AnalyticsHelper().log(AnalyticsEvents.EditValueGoalInstallPg_Back_NavBar_Clk);
      break;
    }
    back();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return  WillPopScope(
      onWillPop: _onWillPop,
      child:  Directionality(
          textDirection: TextDirection.rtl,
          child:  Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body:  SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                   CustomAppBar(
                     messages: false,
                     profileTab: true,
                     isEmptyLeftIcon: true,
                     icon: 'assets/images/ic_arrow_back.svg',
                     titleProfileTab: 'صفحه قبل',
                     subTitleProfileTab: widget.modeChangeValue == 0 ?
                     'نام' : widget.modeChangeValue == 1 ?
                     'تاریخ تولد' : widget.modeChangeValue == 2 ?
                     'وضعیت رابطه' : widget.modeChangeValue == 3 ?'کشور' :
                     'هدف نصب',
                     onPressBack: (){
                       switch(widget.modeChangeValue){
                         case 0: AnalyticsHelper().log(AnalyticsEvents.EditValueNamePg_Back_Btn_Clk);
                         break;
                         case 1:  AnalyticsHelper().log(AnalyticsEvents.EditValueBirthdayPg_Back_Btn_Clk);
                         break;
                         case 2: AnalyticsHelper().log(AnalyticsEvents.EditValueSexTpPg_Back_Btn_Clk);
                         break;
                         case 3:AnalyticsHelper().log(AnalyticsEvents.EditValueCountryPg_Back_Btn_Clk);
                         break;
                         case 4:AnalyticsHelper().log(AnalyticsEvents.EditValueGoalInstallPg_Back_Btn_Clk);
                         break;
                       }
                       back();
                     },
                   ),
                   SizedBox(height: ScreenUtil().setWidth(100)),
                   Column(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: <Widget>[
                       Padding(
                         padding: EdgeInsets.symmetric(
                             horizontal: ScreenUtil().setWidth(50)
                         ),
                         child: Column(
                           children: [
                             Text(
                               title,
                               textAlign: TextAlign.center,
                               style:  context.textTheme.labelMediumProminent!.copyWith(
                                 color: ColorPallet().gray,
                               ),
                             ),
                             widget.modeChangeValue == 4 ?
                             Text(
                               'اگه بدونیم ایمپو رو با چه هدفی نصب کردی، بهتر می‌تونیم کمکت کنیم',
                               textAlign: TextAlign.center,
                               style:  context.textTheme.bodySmall!.copyWith(
                                 color: ColorPallet().gray,
                               ),
                             ) : SizedBox.shrink()
                           ],
                         ),
                       ),
                       SizedBox(height: ScreenUtil().setWidth(100)),
                       widget.modeChangeValue == 0 ?
                       TextFieldArea(
                         isEmail: true,
                         label: 'نام',
                         // maxLength: 15,
                         textController: widget.nameController,
                         readOnly: false,
                         editBox: false,
                         bottomMargin: 0,
                         topMargin: 100,
                         notFlex: true,
                         obscureText: false,
                         keyboardType: TextInputType.emailAddress,
                         maxLength: 15,
                       )
                           : widget.modeChangeValue == 1 ?
                        Padding(
                         padding: EdgeInsets.symmetric(
                           horizontal: ScreenUtil().setWidth(10),
                         ),
                         child: calender = Calender(
                           isBirthDate: true,
                           // mode: 1,
                           maxDate: Jalali(
                               Jalali.now().year - 6,
                               12,
                               29
                           ),
                           minDate: Jalali(
                               Jalali.now().year - 65,
                               1,
                               1
                           ),
                           dateTime: birthDateTime,
                           // controller: widget.birthDayController,
                           ///   RegisterParamViewModel: register,
                         )
                       )
                           : widget.modeChangeValue == 4 ?
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
                                     style: context.textTheme.bodyMedium,
                                   ),
                                   CircleCheckRadioWidget(
                                     isSelected: items[index].selected,
                                   ),
                                 ],
                               ),
                             ),
                           );
                         },
                       )
                         :
                         Container(
                           alignment: Alignment.center,
                           height: ScreenUtil().setWidth(220),
                           child:  Center(
                             child:  NotificationListener<OverscrollIndicatorNotification>(
                               onNotification: (overscroll){
                                 overscroll.disallowIndicator();
                                 return true;
                               },
                               child: Theme(
                                 data: ThemeData(
                                   cupertinoOverrideTheme: CupertinoThemeData(
                                       textTheme: CupertinoTextThemeData(
                                         pickerTextStyle: TextStyle(color: ColorPallet().mainColor),
                                       )
                                   )
                                 ),
                                 child:   CupertinoPicker(
                                     scrollController: FixedExtentScrollController(initialItem:indexList),
                                     itemExtent: ScreenUtil().setWidth(100),
                                     onSelectedItemChanged: (index){
                                       if(widget.modeChangeValue == 2){
                                         AnalyticsHelper().log(AnalyticsEvents.EditValueSexTpPg_SexTpList_Picker_Scr,remainEventActive: false);
                                       }else if(widget.modeChangeValue == 3){
                                         AnalyticsHelper().log(AnalyticsEvents.EditValueCountryPg_CountryList_Picker_Scr,remainEventActive: false);
                                       }
                                       indexList = index;
                                     },
                                     children: List.generate(widget.modeChangeValue == 2 ? yesOrNo.length : countries.length, (index){
                                       return  Center(
                                         child:  Text(
                                           widget.modeChangeValue == 2 ? yesOrNo[index] : countries[index],
                                           style:  context.textTheme.bodyMedium!.copyWith(
                                               color: ColorPallet().mainColor
                                           ),
                                         ),
                                       );
                                     })
                                 ),
                               )
                             )
                           )
                       ),
                       Padding(
                         padding: EdgeInsets.only(
                           top: ScreenUtil().setWidth(100)
                         ),
                         child: StreamBuilder(
                           stream: _presenter.isLoadingObserve,
                           builder: (context,snapshotIsLoading){
                             if(snapshotIsLoading.data != null){
                               return CustomButton(
                                 title: 'ثبت ویرایش',
                                 onPress: onPressEdit,
                                 enableButton: widget.modeChangeValue != 4 ?
                                 true : enableButton,
                                 isLoadingButton: snapshotIsLoading.data,
                                 colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                               );
                             }else{
                               return Container();
                             }
                           },
                         ),
                       )
                     ],
                   ),
                ],
              ),
            ),
          )
      )
    );
  }

  onPressEdit(){

    switch (widget.modeChangeValue){

      case 0:
        AnalyticsHelper().log(AnalyticsEvents.EditValueNamePg_Edit_Btn_Clk);
        changeName();
      break;



      case 1:
        AnalyticsHelper().log(AnalyticsEvents.EditValueBirthdayPg_Edit_Btn_Clk);
        changeBirthDay();
      break;



      case 2:
        AnalyticsHelper().log(AnalyticsEvents.EditValueSexTpPg_Edit_Btn_Clk);
        changeSex();
      break;

      case 3:
        AnalyticsHelper().log(AnalyticsEvents.EditValueCountryPg_Edit_Btn_Clk);
        changeCountry();
        break;

      case 4:
        if(enableButton){
          AnalyticsHelper().log(AnalyticsEvents.EditValueGoalInstallPg_Edit_Btn_Clk);
          changeIntentionInstall();
        }
        break;

    }


  }

  changeName()async{
    var registerInfo = locator<RegisterParamModel>();
    RegisterParamViewModel register = registerInfo.register;

    Map<String,dynamic> generalInfo = {
      'name' : widget.nameController!.text,
      'periodDay' : register.periodDay,
      'circleDay' :  register.circleDay,
      'lastPeriod' : register.lastPeriod,
      'birthDay' : register.birthDay,
      'typeSex' :  register.sex,
      'nationality' : register.nationality,
      'token' :   register.token,
      'calendarType' : register.calendarType,
      'periodStatus' : register.periodStatus,
    };

    await _presenter.setGeneralInfo(generalInfo,context,widget.presenter!,false);
  }

  changeBirthDay()async{
    var registerInfo = locator<RegisterParamModel>();
    RegisterParamViewModel register = registerInfo.register;

    // print(calender.getDateTime());
    widget.birthDayController!.text = calender.getDateTime().toString().replaceAll('Jalali', '').replaceAll('(', '').replaceAll(')', '').replaceAll(',','/');

    Map<String,dynamic> generalInfo = {
      'name' : register.name,
      'periodDay' : register.periodDay,
      'circleDay' :  register.circleDay,
      'lastPeriod' : register.lastPeriod,
      'birthDay' : widget.birthDayController!.text,
      'typeSex' :  register.sex,
      'nationality' : register.nationality,
      'token' :   register.token,
      'calendarType' : register.calendarType,
      'periodStatus' : register.periodStatus,
    };
    await _presenter.setGeneralInfo(generalInfo,context,widget.presenter!,false,updateBio: true);
  }

  changeSex()async{
    var registerInfo = locator<RegisterParamModel>();
    RegisterParamViewModel register = registerInfo.register;

    Map<String,dynamic> generalInfo = {
      'name' : register.name,
      'periodDay' : register.periodDay,
      'circleDay' :  register.circleDay,
      'lastPeriod' : register.lastPeriod,
      'birthDay' : register.birthDay,
      'typeSex' :  indexList,
      'nationality' : register.nationality,
      'token' :   register.token,
      'calendarType' : register.calendarType,
      'periodStatus' : register.periodStatus,
    };
    await _presenter.setGeneralInfo(generalInfo,context,widget.presenter!,false,updateBio: true);
  }

  changeCountry()async{
    var registerInfo = locator<RegisterParamModel>();
    RegisterParamViewModel register = registerInfo.register;

    Map<String,dynamic> generalInfo = {
      'name' : register.name,
      'periodDay' : register.periodDay,
      'circleDay' :  register.circleDay,
      'lastPeriod' : register.lastPeriod,
      'birthDay' : register.birthDay,
      'typeSex' :  register.sex,
      'nationality' : indexList == 0 ? 'IR' : 'AF',
      'token' :   register.token,
      'calendarType' : register.calendarType,
      'periodStatus' : register.periodStatus,
    };
    await _presenter.setGeneralInfo(generalInfo,context,widget.presenter!,false);
  }


  changeIntentionInstall()async{
    var registerInfo = locator<RegisterParamModel>();
    RegisterParamViewModel register = registerInfo.register;
    int _periodStatus = 0;

    for(int i=0 ; i<items.length ; i++){
      if(items[i].selected){
        _periodStatus = items[i].periodStatus!;
      }
    }

    Map<String,dynamic> generalInfo = {
      'name' : register.name,
      'periodDay' : register.periodDay,
      'circleDay' :  register.circleDay,
      'lastPeriod' : register.lastPeriod,
      'birthDay' : register.birthDay,
      'typeSex' :  register.sex,
      'nationality' : register.nationality,
      'token' :   register.token,
      'calendarType' : register.calendarType,
      'periodStatus' : _periodStatus,
    };

    await _presenter.setGeneralInfo(generalInfo,context,widget.presenter!,false);
  }




  @override
  void onError(msg) {

  }

  @override
  void onSuccess(msg){

  }

}