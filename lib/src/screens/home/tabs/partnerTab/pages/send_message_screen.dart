import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/sendMessage_presenter.dart';
import 'package:impo/src/architecture/view/sendMessage_view.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/expert_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/partner/get_messages_partner_model.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import '../../../../../firebase_analytics_helper.dart';

class SendMessageScreen extends StatefulWidget{
  final randomMessage;

  SendMessageScreen({Key? key,this.randomMessage}):super(key:key);

  @override
  State<StatefulWidget> createState() => SendMessageScreenState();
}

class SendMessageScreenState extends State<SendMessageScreen>with TickerProviderStateMixin implements SendMessageView{

  late SendMessagePresenter _presenter;


  SendMessageScreenState(){
    _presenter = SendMessagePresenter(this);
  }

  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.SendMessagePg_Self_Pg_Load);
    _presenter.getMessages();
    super.initState();
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.SendMessagePg_Back_NavBar_Clk);
    Navigator.of(context).popUntil(ModalRoute.withName("/Page1"));
    return Future.value(false);
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
          body: Column(
            children: [
              CustomAppBar(
                messages: false,
                profileTab: true,
                icon: 'assets/images/ic_arrow_back.svg',
                titleProfileTab: 'صفحه قبل',
                subTitleProfileTab: 'ارسال پیام',
                onPressBack: (){
                  AnalyticsHelper().log(AnalyticsEvents.SendMessagePg_Back_Btn_Clk);
                  Navigator.of(context).popUntil(ModalRoute.withName("/Page1"));
                },
              ),
              StreamBuilder(
                stream: _presenter.isLoadingObserve,
                builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                  if(snapshotIsLoading.data != null){
                    if(!snapshotIsLoading.data!){
                      return StreamBuilder(
                        stream: _presenter.messagesObserve,
                        builder: (context,AsyncSnapshot<List<GetMessagesPartnerModel>>snapshotMessages){
                          if(snapshotMessages.data != null){
                            return Expanded(
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child:  Padding(
                                        padding: EdgeInsets.only(
                                            top: ScreenUtil().setWidth(50)
                                        ),
                                        child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: ScreenUtil().setWidth(380),
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/images/ic_send_message.svg',
                                                width: ScreenUtil().setWidth(160),
                                                height: ScreenUtil().setWidth(160),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                bottom: ScreenUtil().setWidth(40),
                                              ),
                                              child: Text(
                                                'ارسال پیام به همدل',
                                                style: context.textTheme.titleMedium!.copyWith(
                                                  color: ColorPallet().mainColor,
                                                )
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    snapshotMessages.data!.length != 0 ?
                                    ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.only(
                                        top:  ScreenUtil().setWidth(30),
                                      ),
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshotMessages.data!.length,
                                      itemBuilder: (context,index){
                                        return !snapshotMessages.data![index].fromMan ?
                                        Container(
                                          padding: EdgeInsets.only(
                                              right: ScreenUtil().setWidth(30),
                                              left: ScreenUtil().setWidth(20),
                                              top:  ScreenUtil().setWidth(20),
                                              bottom: ScreenUtil().setWidth(5),
                                              // vertical: ScreenUtil().setWidth(20)
                                          ),
                                          margin: EdgeInsets.only(
                                            top:  ScreenUtil().setWidth(30),
                                            left: ScreenUtil().setWidth(50),
                                            right: ScreenUtil().setWidth(50),
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                                bottomRight: Radius.circular(7)
                                            ),
                                            border: Border.all(
                                                color: ColorPallet().mainColor,
                                                width: ScreenUtil().setWidth(2.5)
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                  snapshotMessages.data![index].text,
                                                  textAlign: TextAlign.justify,
                                                  style: context.textTheme.bodyMedium,
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Text(
                                                  snapshotMessages.data![index].createTime,
                                                  textAlign: TextAlign.justify,
                                                  style: context.textTheme.labelSmall!.copyWith(
                                                    color: ColorPallet().gray.withOpacity(0.6),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ) :
                                        Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              padding: EdgeInsets.only(
                                                left: ScreenUtil().setWidth(20),
                                                right: ScreenUtil().setWidth(30),
                                                top: ScreenUtil().setWidth(35),
                                                bottom: ScreenUtil().setWidth(5),
                                              ),
                                              margin: EdgeInsets.only(
                                                top:  ScreenUtil().setWidth(50),
                                                left: ScreenUtil().setWidth(50),
                                                right: ScreenUtil().setWidth(50),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(20),
                                                    bottomLeft: Radius.circular(7),
                                                    topRight: Radius.circular(20),
                                                    bottomRight: Radius.circular(20)
                                                ),
                                                border: Border.all(
                                                    color: Color(0xff565AA7),
                                                    width: ScreenUtil().setWidth(2.5)
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment: Alignment.topRight,
                                                    child:     Text(
                                                      snapshotMessages.data![index].text,
                                                      textAlign: TextAlign.justify,
                                                      style:context.textTheme.bodyMedium,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: Alignment.bottomLeft,
                                                    child: Text(
                                                      snapshotMessages.data![index].createTime,
                                                      textAlign: TextAlign.justify,
                                                      style: context.textTheme.labelSmall!.copyWith(
                                                        color: ColorPallet().gray.withOpacity(0.6),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: ScreenUtil().setWidth(20),
                                                  right: ScreenUtil().setWidth(90)
                                              ),
                                              width: ScreenUtil().setWidth(300),
                                              color: Colors.white,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/images/ic_profile_partner.svg',
                                                    width: ScreenUtil().setWidth(50),
                                                    height: ScreenUtil().setWidth(50),
                                                    colorFilter: ColorFilter.mode(
                                                        Color(0xff565AA7),
                                                      BlendMode.srcIn
                                                    ),
                                                  ),
                                                  SizedBox(width: ScreenUtil().setWidth(20)),
                                                  Text(
                                                    'پیام همدل شما',
                                                    style: context.textTheme.labelMediumProminent,
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    )
                                        :
                                    Container(),
                                    snapshotMessages.data!.length != 0 ?
                                    !snapshotMessages.data![snapshotMessages.data!.length-1].fromMan &&
                                        !snapshotMessages.data![snapshotMessages.data!.length-1].readFlag ?
                                    disableSendMessage() :
                                    enableSendMessage() :
                                    enableSendMessage()
                                  ],
                                )
                            );
                          }else{
                            return Container();
                          }
                        },
                      );
                    }else{
                      return  Expanded(
                          child: Center(
                              child: StreamBuilder(
                                stream: _presenter.tryButtonErrorObserve,
                                builder: (context,AsyncSnapshot<bool>snapshotTryButton){
                                  if(snapshotTryButton.data != null){
                                    if(snapshotTryButton.data!){
                                      return  Padding(
                                          padding: EdgeInsets.only(
                                              right: ScreenUtil().setWidth(80),
                                              left: ScreenUtil().setWidth(80),
                                              top: ScreenUtil().setWidth(200)

                                          ),
                                          child:  Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              StreamBuilder(
                                                stream: _presenter.valueErrorObserve,
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
                                                      _presenter.getMessages();
                                                    },
                                                    enableButton: true,
                                                    isLoading: false,
                                                  )
                                              )
                                            ],
                                          )
                                      );
                                    }else{
                                      return Center(
                                        child:  LoadingViewScreen(
                                            color: ColorPallet().mainColor
                                        ),
                                      );
                                    }
                                  }else{
                                    return  Container();
                                  }
                                },
                              )
                          )
                      );
                    }
                  }else{
                    return Container();
                  }
                },
              ),
              StreamBuilder(
                stream: _presenter.isLoadingObserve,
                builder: (context,AsyncSnapshot<bool>snapshotLoading){
                  if(snapshotLoading.data != null){
                    if(!snapshotLoading.data!){
                      return StreamBuilder(
                        stream: notReadMessageObserve,
                        builder: (context,snapshotNotReadMessage){
                          if(snapshotNotReadMessage.data != null){
                            if(snapshotNotReadMessage.data != 0){
                              return   Padding(
                                  padding: EdgeInsets.only(
                                      top: ScreenUtil().setWidth(50),
                                      bottom: ScreenUtil().setWidth(20)
                                  ),
                                  child: CustomButton(
                                      title: 'پیام جدید',
                                      onPress: (){
                                        _presenter.getMessages();
                                      },
                                      colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                                      borderRadius: 10.0,
                                      enableButton: true,
                                      isLoadingButton: false
                                  )
                              );
                            }else{
                              return Container();
                            }
                          }else{
                            return Container();
                          }
                        },
                      );
                    }else{
                      return Container();
                    }
                  }else{
                    return Container();
                  }
                },
              )
            ],
          ),
        ),
      )
    );
  }


  Widget disableSendMessage(){
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setWidth(80)
        ),
        child: Text(
          'تا زمانی که همدلت پیامت رو نخونه\nامکان ارسال پیام جدید نیست',
          textAlign: TextAlign.center,
          style: context.textTheme.bodyLarge,
        ),
      ),
    );
  }


  Widget enableSendMessage(){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(50),
            left: ScreenUtil().setWidth(50),
            right: ScreenUtil().setWidth(50),
          ),
          child: DottedBorder(
            color:  ColorPallet().gray.withOpacity(0.3),
            radius: Radius.circular(15),
            dashPattern: [8,5],
            borderType: BorderType.RRect,
            strokeWidth: 1,
            child:   Container(
                height: ScreenUtil().setWidth(200),
                padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(10),
                    bottom: ScreenUtil().setWidth(10)
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
                        onChanged: (String value){
                          _presenter.onChangeTextField(value);
                        },
                        autofocus: true,
                        maxLines: 5,
                        maxLength: 3000,
                        style:  context.textTheme.bodyMedium,
                        decoration:  InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                            hintText: 'برای همدل خود یک پیام ارسال کنید',
                            hintStyle:  context.textTheme.bodyMedium!.copyWith(
                              color: ColorPallet().gray.withOpacity(0.5),
                            ),
                            contentPadding:  EdgeInsets.only(
                              right: ScreenUtil().setWidth(10),
                              left: ScreenUtil().setWidth(15),
                              bottom: ScreenUtil().setWidth(35),
                              top: ScreenUtil().setWidth(5),
                            )
                        ),
                      ),
                    )
                )
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(50),
                bottom: ScreenUtil().setWidth(20)
            ),
            child: StreamBuilder(
              stream: _presenter.isLoadingButtonObserve,
              builder: (context,snapshotIsLoadingButton){
                if(snapshotIsLoadingButton.data != null){
                  return StreamBuilder(
                    stream: _presenter.textMessageObserve,
                    builder: (context,AsyncSnapshot<String>snapshotTextMessage){
                      if(snapshotTextMessage.data != null){
                        return CustomButton(
                          title: 'ارسال پیام',
                          onPress: (){
                            if(snapshotTextMessage.data!.length != 0){
                              AnalyticsHelper().log(AnalyticsEvents.SendMessagePg_SendMessage_Btn_Clk);
                              _presenter.createMessage(context);
                            }
                          },
                          colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
                          borderRadius: 10.0,
                          enableButton: snapshotTextMessage.data!.length != 0 ? true : false,
                          isLoadingButton: snapshotIsLoadingButton.data,
                        );
                      }else{
                        return Container();
                      }
                    },
                  );
                }else{
                  return Container();
                }
              },
            )
        )
      ],
    );
  }

  @override
  void onError(msg) {

  }

  @override
  void onSuccess(value) {

  }

}