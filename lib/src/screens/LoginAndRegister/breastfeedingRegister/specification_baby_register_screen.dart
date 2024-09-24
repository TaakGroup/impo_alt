import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/item_birth_or_cycle.dart';
import 'package:impo/src/components/text_field_area.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/LoginAndRegister/breastfeedingRegister/type_birth_register_screen.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:page_transition/page_transition.dart';

import '../../../firebase_analytics_helper.dart';


class SpecificationBabyRegisterScreen extends StatefulWidget {
  @override
  State<SpecificationBabyRegisterScreen> createState() => SpecificationBabyRegisterScreenState();
}

class SpecificationBabyRegisterScreenState extends State<SpecificationBabyRegisterScreen> with TickerProviderStateMixin {

  List<ItemsToggle> specificationBabyModel = [
    ItemsToggle(title: "دختر", selected: true),
    ItemsToggle(title: "پسر", selected: false),
    ItemsToggle(title: "دوقلو یا بیشتر", selected: false),
  ];

  int typeChildIndex = 0;
  Animations _animations =  Animations();

  TextEditingController? nameController;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    _animations.shakeError(this);
  }

  @override
  void dispose() {
    _animations.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.SpecificationBabyRegPg_Back_NavBar_Clk);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
   ///  ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  messages: false,
                  profileTab: true,
                  icon: 'assets/images/ic_arrow_back.svg',
                  titleProfileTab: 'صفحه قبل',
                  subTitleProfileTab: '',
                  onPressBack: () {
                    AnalyticsHelper().log(AnalyticsEvents.SpecificationBabyRegPg_Back_Btn_Clk);
                    nameController!.clear();
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(180),
                    right: ScreenUtil().setWidth(50),
                    left: ScreenUtil().setWidth(80),
                  ),
                  child: Text(
                    'جنسیت کوچولوی قشنگت رو انتخاب کن:',
                    textAlign: TextAlign.center,
                    style: context.textTheme.labelLargeProminent!.copyWith(
                      color: ColorPallet().gray,
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(45)),
                Padding(
                  padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                  child: specificationItems(),
                ),
                SizedBox(
                  height: ScreenUtil().setWidth(80),
                ),
                typeChildIndex == 2
                    ? Container()
                    :
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: ScreenUtil().setWidth(50)
                      ),
                      child: Text(
                        'اسم قدم نو رسیده قشنگت چیه؟',
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: ColorPallet().gray,
                        ),
                      ),
                    ),
                    TextFieldArea(
                      notFlex: true,
                      isEmail: true,
                      label: 'نام',
                      textController: nameController,
                      readOnly: false,
                      editBox: false,
                      bottomMargin: 10,
                      topMargin: 30,
                      obscureText: false,
                      keyboardType: TextInputType.text,
                      maxLength: 15,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child:  Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setWidth(15)
                        ),
                        child: AnimatedBuilder(
                            animation: _animations.animationShakeError,
                            builder: (buildContext, child) {
                              if (_animations.animationShakeError.value < 0.0) print('${_animations.animationShakeError.value + 8.0}');
                              return  StreamBuilder(
                                stream: _animations.isShowErrorObserve,
                                builder: (context,AsyncSnapshot<bool> snapshot){
                                  if(snapshot.data != null){
                                    if(snapshot.data!){
                                      return  StreamBuilder(
                                          stream: _animations.errorTextObserve,
                                          builder: (context,AsyncSnapshot<String>snapshot){
                                            return Container(
                                                margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(65)),
                                                padding: EdgeInsets.only(left: _animations.animationShakeError.value + 4.0, right: 4.0 -_animations.animationShakeError.value),
                                                child: Text(
                                                  snapshot.data != null ? snapshot.data! : '',
                                                  style:  context.textTheme.bodySmall!.copyWith(
                                                    color: Color(0xffEE5858),
                                                  ),
                                                )
                                            );
                                          }
                                      );
                                    }else {
                                      return  Opacity(
                                        opacity: 0.0,
                                        child:  Container(
                                          child:  Text(''),
                                        ),
                                      );
                                    }
                                  }else{
                                    return  Opacity(
                                      opacity: 0.0,
                                      child:  Container(
                                        child:  Text(''),
                                      ),
                                    );
                                  }
                                },
                              );
                            }),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setWidth(80),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(0)),
                  child: CustomButton(
                    title: 'تایید',
                    onPress: accept,
                    colors: [ColorPallet().mentalHigh, ColorPallet().mentalMain],
                    borderRadius: 10.0,
                    enableButton: true,
                  ),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget specificationItems() {
    return Row(
      children: List.generate(
          3,
              (index) => GestureDetector(
            onTap: () {
              nameController!.clear();
              setState(() {
                typeChildIndex = index;
                for (int i = 0;
                i < specificationBabyModel.length;
                i++) {
                  specificationBabyModel[i].selected = false;
                }
                specificationBabyModel[index].selected =
                !specificationBabyModel[index].selected!;
              });
              if(typeChildIndex == 0){
                AnalyticsHelper().log(AnalyticsEvents.SpecificationBabyRegPg_Girl_Btn_Clk);
              }else if(typeChildIndex == 1){
                AnalyticsHelper().log(AnalyticsEvents.SpecificationBabyRegPg_Boy_Btn_Clk);
              }else{
                AnalyticsHelper().log(AnalyticsEvents.SpecificationBabyRegPg_TwinsOrMore_Btn_Clk);
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
                      color: !specificationBabyModel[index].selected!
                          ? ColorPallet().mentalMain
                          : Colors.white),
                  gradient: LinearGradient(
                      colors: specificationBabyModel[index].selected!
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
                          specificationBabyModel[index].title!,
                          textAlign: TextAlign.center,
                          style: context.textTheme.labelMedium!.copyWith(
                            color: specificationBabyModel[index]
                                .selected!
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

  accept() {
    if(typeChildIndex !=2 && nameController!.text.length == 0){
      _animations.showShakeError('اسم فرزندت رو وارد نکردی!');
    }else{
      _animations.showShakeError('');
      int childTypeBaby = 0;
      var registerInfo = locator<RegisterParamModel>();

      if (typeChildIndex == 0) childTypeBaby = 1;
      if (typeChildIndex == 1) childTypeBaby = 2;
      if (typeChildIndex == 2) {
        childTypeBaby = 4;
        nameController!.clear();
      }

      registerInfo.setChildType(childTypeBaby);
      registerInfo.setChildName(nameController!.text ?? "");
      AnalyticsHelper().log(AnalyticsEvents.SpecificationBabyRegPg_Accept_Btn_Clk);
      Navigator.push(
          context,
          PageTransition(
              child: TypeBirthRegisterScreen(),
              type: PageTransitionType.fade
          )
      );
    }

  }

}
