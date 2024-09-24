import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/profile_presenter.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/text_field_area.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/home/tabs/profile/edit_value_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:impo/src/screens/home/tabs/profile/my_impo_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../firebase_analytics_helper.dart';

class EditProfile extends StatefulWidget{
  final ProfilePresenter? presenter;

  EditProfile({Key? key,this.presenter}):super(key:key);

  @override
  State<StatefulWidget> createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile>{

  TextEditingController? nameController;
  TextEditingController? countryController;
  TextEditingController? birthdayController;
  TextEditingController? sexController;
  TextEditingController? intentionInstallController;

  late String name;
  late String birthday;
  late String sex;
  late String intentionInstall;
  String userName = '';
  late RegisterParamViewModel registers;

  @override
  void initState() {
    getProfiles();
    super.initState();
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.EditProfilePg_Back_NavBar_Clk);
    Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 500),
            child: MyImpoScreen(
              presenter: widget.presenter!,
            )
        )
    );
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
          backgroundColor: Colors.white,
          body:  Column(
            children: <Widget>[
               Padding(
                padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(0)),
                child:  CustomAppBar(
                  messages: false,
                  profileTab: true,
                  isEmptyLeftIcon: true,
                  icon: 'assets/images/ic_arrow_back.svg',
                  titleProfileTab: 'صفحه قبل',
                  subTitleProfileTab: 'اطلاعات کاربری',
                  onPressBack: (){
                    AnalyticsHelper().log(AnalyticsEvents.EditProfilePg_Back_Btn_Clk);
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            duration: Duration(milliseconds: 500),
                            child: MyImpoScreen(
                              presenter: widget.presenter!,
                            )
                        )
                    );
                  },
                ),
              ),
               Padding(
                padding:  EdgeInsets.only(
                    top: ScreenUtil().setWidth(50)
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(380),
                        ),
                        child: SvgPicture.asset(
                          'assets/images/ic_big_myimpo.svg',
                          width: ScreenUtil().setWidth(180),
                          height: ScreenUtil().setWidth(180),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: ScreenUtil().setWidth(20),
                        ),
                        child: Text(
                          'اطلاعات کاربری',
                          style:  context.textTheme.headlineMedium!.copyWith(
                            color: ColorPallet().gray,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(60)
                ),
                child:  Text(
                  userName,
                  style:  context.textTheme.titleSmall!.copyWith(
                    color: ColorPallet().gray.withOpacity(0.5),
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(30)),
               Flexible(
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFieldArea(
                        label: 'نام',
                        textController: nameController,
                        readOnly: true,
                        editBox: true,
                        onPressEdit: (){
                          AnalyticsHelper().log(AnalyticsEvents.EditProfilePg_EditName_Btn_Clk);
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 500),
                                  child: EditValueScreen(
                                    modeChangeValue: 0,
                                    nameController: nameController,
                                    presenter: widget.presenter!,
                                  )
                              )
                          );
                        },
                        bottomMargin: 60,
                        topMargin: 0,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                      ),
                      TextFieldArea(
                        label: 'کشور',
                        textController: countryController,
                        readOnly: true,
                        editBox: true,
                        onPressEdit: (){
                          AnalyticsHelper().log(AnalyticsEvents.EditProfilePg_EditCountry_Btn_Clk);
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 500),
                                  child: EditValueScreen(
                                    modeChangeValue: 3,
                                    countryController: countryController,
                                    presenter: widget.presenter!,
                                  )
                              )
                          );
                        },
                        bottomMargin: 60,
                        topMargin: 0,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                      ),
                      TextFieldArea(
                        label: 'تاریخ تولد',
                        textController: birthdayController,
                        readOnly: true,
                        editBox: true,
                        onPressEdit: (){
                          AnalyticsHelper().log(AnalyticsEvents.EditProfilePg_EditBirthday_Btn_Clk);
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 500),
                                  child: EditValueScreen(
                                    modeChangeValue: 1,
                                    birthDayController: birthdayController,
                                    presenter: widget.presenter!,
                                  )
                              )
                          );
                        },
                        bottomMargin: 60,
                        topMargin: 0,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                      ),
                      TextFieldArea(
                        label: 'وضعیت رابطه',
                        textController: sexController,
                        readOnly: true,
                        editBox: true,
                        onPressEdit: (){
                          AnalyticsHelper().log(AnalyticsEvents.EditProfilePg_EditSexTp_Btn_Clk);
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 500),
                                  child: EditValueScreen(
                                    modeChangeValue: 2,
                                    sexController: sexController,
                                    presenter: widget.presenter!,
                                  )
                              )
                          );
                        },
                        bottomMargin: 60,
                        topMargin: 0,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                      ),
                      widget.presenter!.getRegister().status == 1 ?
                      TextFieldArea(
                        label: 'هدف نصب',
                        textController: intentionInstallController,
                        readOnly: true,
                        editBox: true,
                        onPressEdit: (){
                          AnalyticsHelper().log(AnalyticsEvents.EditProfilePg_GoalInstall_Btn_Clk);
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 500),
                                  child: EditValueScreen(
                                    modeChangeValue: 4,
                                    intentionInstallController: intentionInstallController,
                                    presenter: widget.presenter!,
                                  )
                              )
                          );
                        },
                        bottomMargin: 60,
                        topMargin: 0,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                      ) :
                          SizedBox.shrink()
                    ],
                  )
              )
            ],
          ),
        ),
      )
    );
  }

  getProfiles()async{
    // DataBaseProvider db  =  DataBaseProvider();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName')!;
   registers =  widget.presenter!.getRegister();


   setState(() {
     nameController =  TextEditingController(text: registers.name);
     if(registers.nationality == 'IR'){
       countryController =  TextEditingController(text: 'ایران');
     }else{
       countryController =  TextEditingController(text: 'افغانستان');
     }
     name = registers.name!;
     birthdayController =  TextEditingController(text: registers.birthDay!.replaceAll(',', '/').replaceAll(' ', ''));
     birthday = registers.birthDay!.replaceAll(',', '/');

     if(registers.sex == 1){
       sexController =  TextEditingController(text: 'رابطه جنسی دارم');
       sex = 'رابطه جنسی دارم';
     }else{
       sexController =  TextEditingController(text: 'رابطه جنسی ندارم');
       sex = 'رابطه جنسی ندارم';
     }

     if(registers.periodStatus == 1){
       intentionInstallController = TextEditingController(text: 'پیشگیری از بارداری');
       intentionInstall = 'پیشگیری از بارداری';
     }else if(registers.periodStatus == 2){
       intentionInstallController = TextEditingController(text: 'اقدام به بارداری');
       intentionInstall = 'اقدام به بارداری';
     }else{
       intentionInstallController = TextEditingController(text: 'انتخاب کنید');
       intentionInstall = 'انتخاب کنید';
     }

   });


  }

}