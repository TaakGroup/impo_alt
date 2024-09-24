
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/memory_presenter.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:get/get.dart';

import '../../../../../firebase_analytics_helper.dart';

class SendCommentScreen extends StatefulWidget{
  final id;
  final MemoryPresenter? memoryPresenter;
  SendCommentScreen({Key? key,this.id,this.memoryPresenter}):super(key: key);
  @override
  State<StatefulWidget> createState() => SendCommentScreenState();
}

class SendCommentScreenState extends State<SendCommentScreen> with TickerProviderStateMixin{

  TextEditingController controller = TextEditingController();

  String text = '';

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.SendCommitPg_Back_NavBar_Clk);
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
          body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child:  ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    CustomAppBar(
                      messages: false,
                      profileTab: true,
                      icon: 'assets/images/ic_arrow_back.svg',
                      titleProfileTab: 'صفحه قبل',
                      subTitleProfileTab: 'خاطره‌بازی',
                      onPressBack: (){
                        AnalyticsHelper().log(AnalyticsEvents.SendCommitPg_Back_Btn_Clk);
                        Navigator.pop(context);
                      },
                    ),
                    Align(
                      alignment: Alignment.center,
                      child:  Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setWidth(40),
                            bottom: ScreenUtil().setWidth(40)
                        ),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(300),
                              ),
                              child: SvgPicture.asset(
                                'assets/images/ic_big_memory.svg',
                                width: ScreenUtil().setWidth(140),
                                height: ScreenUtil().setWidth(140),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: ScreenUtil().setWidth(20),
                              ),
                              child: Text(
                                'نظرت چیه؟',
                                style:  context.textTheme.titleMedium!.copyWith(
                                  color: ColorPallet().mainColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'حست به این خاطره چیه؟',
                        style: context.textTheme.bodyLarge!.copyWith(
                          color: ColorPallet().gray,
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(80),
                          right: ScreenUtil().setWidth(60),
                          left: ScreenUtil().setWidth(60),
                        ),
                        height: ScreenUtil().setWidth(200),
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setWidth(10),
                            bottom: ScreenUtil().setWidth(10)
                        ),
                        decoration:  BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color:  ColorPallet().gray.withOpacity(0.2),
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
                                controller: controller,
                                maxLines: 5,
                                maxLength: 3000,
                                onChanged: (value){
                                  if(this.mounted){
                                    setState(() {
                                      text = value;
                                    });
                                  }
                                },
                                style: context.textTheme.bodyMedium,
                                decoration:  InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'حست به این خاطره رو اینجا بنویس',
                                    counterText: '',
                                    hintStyle:  context.textTheme.bodyMedium!.copyWith(
                                      color: ColorPallet().gray.withOpacity(0.5),
                                    ),
                                    contentPadding:  EdgeInsets.only(
                                      right: ScreenUtil().setWidth(10),
                                      left: ScreenUtil().setWidth(15),
                                      bottom: ScreenUtil().setWidth(35),
                                    )
                                ),
                              ),
                            )
                        )
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setWidth(30),
                      bottom: ScreenUtil().setWidth(80)
                  ),
                  child: StreamBuilder(
                    stream: widget.memoryPresenter!.isLoadingButtonObserve,
                    builder: (context,snapshotIsLoadingButton){
                      if(snapshotIsLoadingButton.data != null){
                        return CustomButton(
                          title: 'نظرت چیه؟',
                          onPress: (){
                            if(text.length != 0){
                              AnalyticsHelper().log(AnalyticsEvents.SendCommitPg_whatdoyouthink_Btn_Clk);
                              widget.memoryPresenter!.sendComment(widget.id, text, context);
                            }
                          },
                          colors: [Color(0xffFFA5FC),ColorPallet().mainColor],
                          borderRadius: 10.0,
                          enableButton: text.length != 0 ?
                          true : false,
                          isLoadingButton: snapshotIsLoadingButton.data,
                        );
                      }else{
                        return Container();
                      }
                    },
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
  
}