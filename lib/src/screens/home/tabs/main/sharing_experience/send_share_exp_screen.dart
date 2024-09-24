import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/sharing_experience_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/circle_check_radio_widget.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/models/expert/upload_file_model.dart';
import 'package:impo/src/models/sharing_experience/all_share_experience_get_model.dart';
import 'package:impo/src/models/sharing_experience/topic_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SendShareExpScreen extends StatefulWidget{
  final SharingExperiencePresenter? sharingExperiencePresenter;
  final bool? isComment;
  final bool? fromTopicScreen;
  SendShareExpScreen({Key? key,this.sharingExperiencePresenter,this.isComment,this.fromTopicScreen}):super(key: key);

  @override
  State<StatefulWidget> createState() => SendShareExpScreenState();
}

class SendShareExpScreenState extends State<SendShareExpScreen> with TickerProviderStateMixin{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> _onWillPop()async{
    /// AnalyticsHelper().log(AnalyticsEvents.TopicShareExpPg_Back_NavBar_Clk);
    Navigator.pop(context);
    return Future.value(false);
  }

  Animations animations = Animations();
  late AnimationController animationControllerScaleButton;
  var focusNode = FocusNode();
  int modePress = 0;

  @override
  void initState() {
    widget.sharingExperiencePresenter!.clearUploadFiles();
    widget.sharingExperiencePresenter!.initPanelController();
    changeTopicName();
    focusNode.requestFocus();
    animationControllerScaleButton = animations.pressButton(this);
    super.initState();
  }

  TopicModel? selectTopic;

  changeTopicName(){
    List<TopicModel> topics = widget.sharingExperiencePresenter!.topics.stream.value;
    for(int i=0 ;i<topics.length; i++){
      if(topics[i].selected){
        setState(() {
          selectTopic = topics[i];
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                StreamBuilder(
                  stream: widget.sharingExperiencePresenter!.allExperiencesObserve,
                  builder: (context,AsyncSnapshot<AllShareExperienceGetModel>snapshotAllExp){
                    if(snapshotAllExp.data != null){
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                                    bottom: ScreenUtil().setWidth(15)
                                ),
                                child: CustomAppBar(
                                  messages: false,
                                  profileTab: true,
                                  icon: 'assets/images/ic_arrow_back.svg',
                                  titleProfileTab: 'صفحه قبل',
                                  subTitleProfileTab: 'اشتراک تجربه',
                                  onPressBack: (){
                                    ///AnalyticsHelper().log(AnalyticsEvents.ShareExpPg_Back_Btn_Clk);
                                    Navigator.pop(context);
                                  },
                                  infoShareExp: true,
                                )
                            ),
                            StreamBuilder(
                              stream: widget.sharingExperiencePresenter!.topicsObserve,
                              builder: (context,AsyncSnapshot<List<TopicModel>>topics){
                                if(topics.data != null){
                                  return Padding(
                                    padding:  EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setWidth(30)
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'تجربه جدید',
                                          style: TextStyle(
                                              color: ColorPallet().mainColor,
                                              fontSize: ScreenUtil().setSp(30),
                                              fontWeight: FontWeight.w700
                                          ),
                                        ),
                                        SizedBox(height: ScreenUtil().setHeight(20)),
                                        StreamBuilder(
                                          stream: animations.squareScaleBackButtonObserve,
                                          builder: (context,AsyncSnapshot<double>snapshotScale){
                                            if(snapshotScale.data != null){
                                              return Transform.scale(
                                                scale: snapshotScale.data,
                                                child: GestureDetector(
                                                  onTap: (){
                                                    animationControllerScaleButton.reverse();
                                                    setState(() {
                                                      modePress = 1;
                                                    });
                                                    widget.sharingExperiencePresenter!.openSlidingPanel();
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: ScreenUtil().setHeight(5)
                                                    ),
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: ScreenUtil().setWidth(20),
                                                        vertical: ScreenUtil().setWidth(15)
                                                    ),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(24),
                                                        border: Border.all(
                                                            color: Color(0xffF4F4F4)
                                                        )
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SvgPicture.asset(
                                                                'assets/images/topic.svg'
                                                            ),
                                                            SizedBox(width: ScreenUtil().setWidth(10)),
                                                            Text(
                                                              selectTopic != null ? selectTopic!.name:
                                                              'انتخاب تالار تجربه',
                                                              style: TextStyle(
                                                                  color: Color(0xff202020),
                                                                  fontSize: ScreenUtil().setSp(26),
                                                                  fontWeight: FontWeight.w500
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Icon(
                                                            Icons.keyboard_arrow_down
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }else{
                                              return Container();
                                            }
                                          },
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: ScreenUtil().setWidth(20),
                                              vertical: ScreenUtil().setWidth(15)
                                          ),
                                          margin: EdgeInsets.only(
                                              top: ScreenUtil().setWidth(15)
                                          ),
                                          decoration: BoxDecoration(
                                              color: Color(0xffF9F9F9),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(12),
                                                  bottomRight: Radius.circular(12),
                                                  bottomLeft: Radius.circular(12)
                                              )
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Theme(
                                                data: Theme.of(context).copyWith(
                                                  textSelectionTheme: TextSelectionThemeData(
                                                      selectionColor: Color(0xffaaaaaa),
                                                      cursorColor: ColorPallet().mainColor
                                                  ),
                                                ),
                                                child:  TextFormField(
                                                  autofocus: false,
                                                  focusNode: focusNode,
                                                  onChanged: (value){
                                                    if(widget.isComment!){
                                                      widget.sharingExperiencePresenter!.onChangeCommentTextField(value,context);
                                                    }else{
                                                      widget.sharingExperiencePresenter!.onChangeTextField(value,context);
                                                    }
                                                  },
                                                  style:  TextStyle(
                                                      fontSize: ScreenUtil().setSp(28),
                                                      color: Color(0xff0C0C0D),
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                  maxLength: 300,
                                                  maxLines: 4,
                                                  decoration:  InputDecoration(
                                                    isDense: true,
                                                    counterText: '',
                                                    border: InputBorder.none,
                                                    hintText: widget.isComment! ?
                                                    'نظرت رو در مورد این تجربه بنویس' :
                                                    selectTopic != null ? selectTopic!.inputText
                                                        :snapshotAllExp.data!.inputText,
                                                    hintStyle:  TextStyle(
                                                        fontSize: ScreenUtil().setSp(26),
                                                        color: ColorPallet().gray,
                                                        fontWeight: FontWeight.w400
                                                    ),
                                                    contentPadding: EdgeInsets.zero,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: ScreenUtil().setHeight(20)),
                                              StreamBuilder(
                                                stream: widget.sharingExperiencePresenter!.uploadFilesObserve,
                                                builder: (context,AsyncSnapshot<List<UploadFileModel>>snapshotUploadFiles){
                                                  if(snapshotUploadFiles.data != null){
                                                    if(snapshotUploadFiles.data!.length == 0){
                                                      return Padding(
                                                        padding:  EdgeInsets.only(
                                                            left: ScreenUtil().setWidth(120)
                                                        ),
                                                        child: CustomButton(
                                                          onPress: (){
                                                            widget.sharingExperiencePresenter!.openSlidingPanel();
                                                            setState(() {
                                                              modePress = 0;
                                                            });
                                                          },
                                                          height: ScreenUtil().setWidth(80),
                                                          // height: ScreenUtil().setWidth(200),
                                                          margin: 0,
                                                          colors: [Colors.transparent,Colors.transparent],
                                                          borderColor: Color(0xffCBCBCB),
                                                          child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                SvgPicture.asset(
                                                                  'assets/images/add_photo.svg',
                                                                  width: ScreenUtil().setWidth(45),
                                                                  height: ScreenUtil().setWidth(45),
                                                                  fit: BoxFit.cover,
                                                                ),
                                                                Text(
                                                                  'یک عکس برای تجربه‌ت انتخاب کن',
                                                                  textAlign: TextAlign.center,
                                                                  style:  TextStyle(
                                                                    color: ColorPallet().mainColor,
                                                                    fontWeight: FontWeight.w700,
                                                                    fontSize: ScreenUtil().setSp(26),
                                                                  ),
                                                                ),
                                                              ]
                                                          ),
                                                          borderRadius: 24.0,
                                                          enableButton: true,
                                                        ),
                                                      );
                                                    }else{
                                                      return ListView.builder(
                                                        shrinkWrap: true,
                                                        physics: NeverScrollableScrollPhysics(),
                                                        padding: EdgeInsets.only(
                                                          bottom: ScreenUtil().setWidth(20),
                                                        ),
                                                        itemCount: snapshotUploadFiles.data!.length,
                                                        itemBuilder: (context,index){
                                                          return   snapshotUploadFiles.data![index].type == 0 ?
                                                          Stack(
                                                            alignment: Alignment.bottomRight,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius: BorderRadius.circular(16),
                                                                child: Image.file(
                                                                  File(snapshotUploadFiles.data![index].fileName.path),
                                                                  fit: BoxFit.cover,
                                                                  height: ScreenUtil().setWidth(400),
                                                                  width: MediaQuery.of(context).size.width,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:  EdgeInsets.only(
                                                                    left: MediaQuery.of(context).size.width/2 - ScreenUtil().setWidth(50),
                                                                    right: ScreenUtil().setWidth(30),
                                                                    bottom: ScreenUtil().setWidth(15)
                                                                ),
                                                                child: CustomButton(
                                                                  onPress: (){
                                                                    widget.sharingExperiencePresenter!.cancelUpload(snapshotUploadFiles.data![index].fileName.path,snapshotUploadFiles.data![index].fileNameForSend);
                                                                  },
                                                                  height: ScreenUtil().setWidth(70),
                                                                  // height: ScreenUtil().setWidth(200),
                                                                  margin: 0,
                                                                  colors: [Color(0xfff9f9f9),Color(0xfff9f9f9)],
                                                                  borderColor: Color(0xffCBCBCB),
                                                                  child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        SvgPicture.asset(
                                                                          'assets/images/ic_delete.svg',
                                                                          colorFilter: ColorFilter.mode(
                                                                              ColorPallet().mainColor,
                                                                              BlendMode.srcIn
                                                                          ),
                                                                          width: ScreenUtil().setWidth(35),
                                                                          height: ScreenUtil().setWidth(35),
                                                                          fit: BoxFit.cover,
                                                                        ),
                                                                        SizedBox(width: ScreenUtil().setWidth(5)),
                                                                        Text(
                                                                          'پاک کردن عکس',
                                                                          textAlign: TextAlign.center,
                                                                          style:  TextStyle(
                                                                            color: ColorPallet().mainColor,
                                                                            fontWeight: FontWeight.w700,
                                                                            fontSize: ScreenUtil().setSp(22),
                                                                          ),
                                                                        ),
                                                                      ]
                                                                  ),
                                                                  borderRadius: 24.0,
                                                                  enableButton: true,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                              :
                                                          Container(
                                                            height: ScreenUtil().setWidth(100),
                                                            width:  ScreenUtil().setWidth(100),
                                                            margin: EdgeInsets.only(
                                                                right: ScreenUtil().setWidth(20)
                                                            ),
                                                            decoration:  BoxDecoration(
                                                                borderRadius: BorderRadius.circular(10),
                                                                image:  DecorationImage(
                                                                    fit: BoxFit.fitHeight,
                                                                    image: AssetImage(
                                                                      'assets/images/ic_pdf.png',
                                                                    )
                                                                )
                                                            ),
//                                                  )
                                                          );
                                                        },
                                                      );
                                                    }
                                                  }else{
                                                    return Container();
                                                  }
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }else{
                                  return Container();
                                }
                              },
                            )
                            // Spacer(),
                          ],
                        ),
                      );
                    }else{
                      return Container();
                    }
                  },
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width/2,
                      left: ScreenUtil().setWidth(30),
                      bottom: ScreenUtil().setWidth(30),
                    ),
                    child: StreamBuilder(
                      stream: widget.sharingExperiencePresenter!.textSendObserve,
                      builder: (context,AsyncSnapshot<String>snapshotTextSend){
                        if(snapshotTextSend.data != null){
                          return StreamBuilder(
                            stream: widget.sharingExperiencePresenter!.isLoadingButtonObserve,
                            builder: (context,snapshotIsLoadingButton){
                              if(snapshotIsLoadingButton.data != null){
                                return CustomButton(
                                  title: 'ثبت تجربه',
                                  onPress: (){
                                    if(snapshotTextSend.data!.length >= 5){
                                      ///AnalyticsHelper().log(AnalyticsEvents.ShareExpPg_SendExp_Btn_Clk);
                                      widget.sharingExperiencePresenter!.sendShareExp(context,widget.fromTopicScreen!);
                                    }
                                  },
                                  height: ScreenUtil().setWidth(80),
                                  // height: ScreenUtil().setWidth(200),
                                  margin: 0,
                                  colors: [ColorPallet().mainColor,ColorPallet().mainColor],
                                  borderRadius: 32.0,
                                  isLoadingButton: snapshotIsLoadingButton.data,
                                  enableButton: snapshotTextSend.data!.length >=5 ? true : false,
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
                    ),
                  ),
                ),
                SlidingUpPanel(
                    controller: widget.sharingExperiencePresenter!.panelController,
                    backdropEnabled: true,
                    minHeight: 0,
                    backdropColor: Colors.black,
                    padding: EdgeInsets.zero,
                    maxHeight: modePress == 0 ?
                    MediaQuery.of(context).size.height / 5 : MediaQuery.of(context).size.height / 1.5,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)
                    ),
                    panel:  modePress == 0 ? attachPanel() : topicPanel()
                ),
              ],
            )
        ),
      ),
    );
  }

  Widget attachPanel(){
    return  Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setWidth(30),
          left: ScreenUtil().setWidth(50),
          right: ScreenUtil().setWidth(50)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: itemAttach(
                'assets/images/ic_camera.svg',
                'دوربین',
                    (){
                  ///AnalyticsHelper().log(AnalyticsEvents.AddMemoryPg_CameraUploadImage_Btn_Clk);
                  widget.sharingExperiencePresenter!.closeSlidingPanel();
                  widget.sharingExperiencePresenter!.getFileImage(1,context);
                }
            ),
          ),
          SizedBox(width: ScreenUtil().setWidth(80)),
          Flexible(
            child: itemAttach(
                'assets/images/ic_gallery.svg',
                'گالری',
                    (){
                  ///AnalyticsHelper().log(AnalyticsEvents.AddMemoryPg_GalleryUploadImage_Btn_Clk);
                  widget.sharingExperiencePresenter!.closeSlidingPanel();
                  widget.sharingExperiencePresenter!.getFileImage(0,context);
                }
            ),
          ),
        ],
      ),
    );
  }

  Widget itemAttach(String icon,String title,onPress){
    return  Column(
      children: <Widget>[
        Container(
            height: ScreenUtil().setWidth(110),
            width: ScreenUtil().setWidth(110),
            decoration:  BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xff5F9BDF).withOpacity(0.25),
                      blurRadius: 5.0
                  )
                ]
            ),
            child:  Material(
              color: Colors.transparent,
              child:  InkWell(
                splashColor: Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(50),
                onTap: (){
                  onPress();
                },
                child:  Center(
                    child:  Container(
                      height: ScreenUtil().setWidth(50),
                      width: ScreenUtil().setWidth(50),
                      child:  SvgPicture.asset(
                        icon,

                      ),
                    )
                ),
              ),
            )
        ),
        SizedBox(height: ScreenUtil().setWidth(15)),
        Text(
          title,
          style:  TextStyle(
              color: ColorPallet().black,
              fontSize: ScreenUtil().setSp(26),
              fontWeight: FontWeight.w400
          ),
        )
      ],
    );
  }

  Widget topicPanel(){
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: ScreenUtil().setWidth(6),
            width: ScreenUtil().setWidth(100),
            margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(15)
            ),
            decoration: BoxDecoration(
              color: Color(0xffF8F8F8),
              borderRadius: BorderRadius.circular(40)
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(30)),
          Padding(
            padding:  EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(30)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'انتخاب تالار برای گفتگو',
                  style: TextStyle(
                      color: Color(0xff202020),
                      fontSize: ScreenUtil().setSp(28),
                      fontWeight: FontWeight.w700
                  ),
                ),
                Icon(
                    Icons.keyboard_arrow_down
                )
              ],
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(30)),
          Padding(
            padding:  EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(30)
            ),
            child: StreamBuilder(
              stream: widget.sharingExperiencePresenter!.topicsObserve,
              builder: (context,AsyncSnapshot<List<TopicModel>>topics){
                if(topics.data != null){
                  return  Column(
                    children: List.generate(topics.data!.length, (index) =>
                    GestureDetector(
                      onTap: (){
                        widget.sharingExperiencePresenter!.onPressListTopic(index);
                        changeTopicName();
                        widget.sharingExperiencePresenter!.closeSlidingPanel();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(15),
                          vertical: ScreenUtil().setWidth(20)
                        ),
                        margin: EdgeInsets.only(
                          bottom: ScreenUtil().setWidth(15)
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: topics.data![index].selected ? ColorPallet().mainColor : Color(0xffEFEFEF)
                          )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleCheckRadioWidget(
                                  isSelected: topics.data![index].selected,
                                ),
                                SizedBox(width: ScreenUtil().setWidth(10)),
                                Text(
                                  topics.data![index].name,
                                  style: TextStyle(
                                      color: Color(0xff202020),
                                      fontSize: ScreenUtil().setSp(26),
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ],
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                topics.data![index].image,
                                fit: BoxFit.cover,
                                width: ScreenUtil().setWidth(100),
                                height: ScreenUtil().setWidth(100),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
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
    );
  }

}