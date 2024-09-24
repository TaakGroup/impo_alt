import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/subscribe_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/subscribe/subscribes_get_model.dart';

class SubOrganizationalWidget extends StatefulWidget{

  final SubscribePresenter? subscribePresenter;

  SubOrganizationalWidget({Key? key,this.subscribePresenter}) : super(key:key);

  @override
  State<StatefulWidget> createState() => SubOrganizationalWidgetState();
}

class SubOrganizationalWidgetState extends State<SubOrganizationalWidget> with TickerProviderStateMixin{

  Animations _animations =  Animations();

  @override
  void initState() {
    _animations.shakeError(this);
    widget.subscribePresenter!.subOrganizationalTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   ///  ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = .5;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
          child: StreamBuilder(
            stream: widget.subscribePresenter!.subscribeObserve,
            builder: (context,AsyncSnapshot<SubscribesGetModel>snapshotSub){
              if(snapshotSub.data != null){
                return Column(
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
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil().setWidth(15),
                        top: ScreenUtil().setWidth(10)  
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          snapshotSub.data!.upTextOrganization,
                          style: context.textTheme.labelLarge,
                        ),
                      ),
                    ),
                    Container(
                        height: ScreenUtil().setWidth(80),
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
                                // maxLength: 20,
                                controller: widget.subscribePresenter!.subOrganizationalTextController,
                                enableInteractiveSelection: false,
                                style:  context.textTheme.bodySmall,
                                decoration:  InputDecoration(
                                  counterText: '',
                                  border: InputBorder.none,
                                  hintText: snapshotSub.data!.hintTextOrganization,
                                  hintStyle: context.textTheme.bodySmall!.copyWith(
                                    color: ColorPallet().gray.withOpacity(0.5),
                                  ),
                                  contentPadding:  EdgeInsets.only(
                                    right: ScreenUtil().setWidth(20),
                                    left: ScreenUtil().setWidth(10),
                                    bottom: ScreenUtil().setWidth(20),
//                                          top: ScreenUtil().setWidth(20),
                                  ),
                                ),
                              ),
                            )
                        )
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child:  AnimatedBuilder(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CustomButton(
                          title: 'انصراف',
                          textColor: Color(0xff4B454D),
                          onPress: (){
                            widget.subscribePresenter!.panelController.close();
                          },
                          margin: 10,
                          colors: [Colors.transparent,Colors.transparent],
                          borderRadius: 10.0,
                          enableButton: true,
                        ),
                        Flexible(
                          child: StreamBuilder(
                            stream: widget.subscribePresenter!.isLoadingOrganizationButtonObserve,
                            builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                              if(snapshotIsLoading.data != null){
                                if(!snapshotIsLoading.data!){
                                  return  CustomButton(
                                    title: 'تایید',
                                    onPress: (){
                                      widget.subscribePresenter!.acceptOrganization(_animations,context);
                                    },
                                    margin: 10,
                                    colors: [ColorPallet().mainColor,ColorPallet().mainColor],
                                    borderRadius: 10.0,
                                    enableButton: true,
                                  );
                                }else{
                                  return  Center(
                                      child:  LoadingViewScreen(color: ColorPallet().mainColor,)
                                  );
                                }
                              }else{
                                return  Container();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(35),
                          bottom: ScreenUtil().setWidth(15),
                      ),
                      height: ScreenUtil().setWidth(1),
                      decoration:  BoxDecoration(
                          color: Color(0xff707070).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15)
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: ScreenUtil().setWidth(30)
                        ),
                        child: Text(
                          snapshotSub.data!.downTextOrganization,
                          //'در صورت وجود هرگونه مشکل با شماره 05191014180 تماس بگیر',
                          style: context.textTheme.labelSmall,
                        ),
                      ),
                    ),
                  ],
                );
              }else{
                return Container();
              }
            },
          )
        )
    );
  }

}