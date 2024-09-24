import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/daily_message_presenter.dart';
import 'package:impo/src/architecture/presenter/partner_tab_presenter.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/expert_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/models/challenge/archive_challenge_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social/chat_application.dart';
import '../../../../../components/colors.dart';

class ArchiveDailyMessageScreen extends StatefulWidget{
  final DailyMessagePresenter? dailyMessagePresenter;
  final PartnerTabPresenter? partnerTabPresenter;

  ArchiveDailyMessageScreen({Key? key,this.dailyMessagePresenter,this.partnerTabPresenter}):super(key:key);

  @override
  State<StatefulWidget> createState() => ArchiveDailyMessageScreenState();
}

class ArchiveDailyMessageScreenState extends State<ArchiveDailyMessageScreen> with TickerProviderStateMixin {

  Animations animations =  Animations();
  late AnimationController animationControllerScaleButton;
  int? modePress;



  @override
  void initState() {
    widget.dailyMessagePresenter!.getArchives(state: 0);
    animationControllerScaleButton = animations.pressButton(this);
    super.initState();
  }

  @override
  void dispose() {
    animationControllerScaleButton.dispose();
    // widget.dailyMessagePresenter!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Directionality(
      textDirection: TextDirection.rtl,
      child:  Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(40)
              ),
              child: StreamBuilder(
                stream: widget.dailyMessagePresenter!.isLoadingObserve,
                builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                  if(snapshotIsLoading.data != null){
                    return StreamBuilder(
                        stream: widget.dailyMessagePresenter!.archiveChallengeObserve,
                        builder: (context,AsyncSnapshot<ArchiveChallengeModel>archive){
                          if(archive.data != null){
                            if(!snapshotIsLoading.data!){
                              return Column(
                                children: [
                                  SizedBox(height: ScreenUtil().setWidth(40)),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      StreamBuilder(
                                        stream: animations.squareScaleBackButtonObserve,
                                        builder: (context,AsyncSnapshot<double>snapshotScale){
                                          if(snapshotScale.data != null){
                                            return Transform.scale(
                                              scale:  modePress == 0 ? snapshotScale.data : 1.0,
                                              child: GestureDetector(
                                                  onTap: ()async{
                                                    setState(() {
                                                      modePress = 0;
                                                    });
                                                    await animationControllerScaleButton.reverse();
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    width: ScreenUtil().setWidth(85),
                                                    height: ScreenUtil().setWidth(85),
                                                    decoration: BoxDecoration(
                                                        color: Colors.transparent,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Color(0xffEFEFEF)
                                                        )
                                                    ),
                                                    child: Center(
                                                        child: Icon(
                                                          Icons.arrow_back_rounded,
                                                          size: ScreenUtil().setWidth(55),
                                                          color: ColorPallet().black,
                                                        )
                                                    ),
                                                  )
                                              ),
                                            );
                                          }else{
                                            return Container();
                                          }
                                        },
                                      ),
                                      SizedBox(width: ScreenUtil().setWidth(15)),
                                      Text(
                                        archive.data!.title,
                                        style: context.textTheme.titleSmall,
                                      )
                                    ],
                                  ),
                                  SizedBox(height: ScreenUtil().setWidth(40)),
                                  archive.data!.totalCount != 0 ?
                                  Expanded(
                                    child:  StreamBuilder(
                                      stream: widget.dailyMessagePresenter!.itemsArchiveChallengeObserve,
                                      builder: (context,AsyncSnapshot<List<ItemsArchiveChallengeModel>>snapshotItems){
                                        if(snapshotItems.data != null){
                                          return ListView.builder(
                                            addAutomaticKeepAlives: false,
                                            padding: EdgeInsets.only(top: ScreenUtil().setWidth(15)),
                                            itemCount: snapshotItems.data!.length,
                                            itemBuilder: (context,int index){
                                              if(index == snapshotItems.data!.length-1){
                                                widget.dailyMessagePresenter!.moreLoadGetArchives();
                                              }
                                              return  itemArchive(snapshotItems.data!,index,snapshotItems.data!.length);
                                            },
                                          );
                                        }else{
                                          return  Container();
                                        }
                                      },
                                    ),
                                  ) :
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context).size.height/6
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/images/empty_archive_challenge.webp',
                                            width: ScreenUtil().setWidth(250),
                                            height: ScreenUtil().setWidth(250),
                                          ),
                                          SizedBox(height: ScreenUtil().setWidth(20)),
                                          Text(
                                            'هنوز چالشی رو با پارتنرت انجام ندادی ',
                                            style: context.textTheme.bodyMedium,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }else{
                              return Center(
                                  child: StreamBuilder(
                                    stream: widget.dailyMessagePresenter!.tryButtonErrorObserve,
                                    builder: (context,AsyncSnapshot<bool>snapshotTryButton) {
                                      if (snapshotTryButton.data != null) {
                                        if (snapshotTryButton.data!) {
                                          return Padding(
                                              padding: EdgeInsets.only(right: ScreenUtil().setWidth(80), left: ScreenUtil().setWidth(80)),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  StreamBuilder(
                                                    stream: widget.dailyMessagePresenter!.valueErrorObserve,
                                                    builder: (context,AsyncSnapshot<String>snapshotValueError) {
                                                      if (snapshotValueError.data != null) {
                                                        return Text(
                                                          snapshotValueError.data!,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              color: Color(0xff707070),
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: ScreenUtil().setSp(34)),
                                                        );
                                                      } else {
                                                        return Container();
                                                      }
                                                    },
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(top: ScreenUtil().setWidth(120)),
                                                      child: ExpertButton(
                                                        title: 'تلاش مجدد',
                                                        onPress: () {
                                                          widget.dailyMessagePresenter!.getArchives(state: 0);
                                                        },
                                                        enableButton: true,
                                                        isLoading: false,
                                                      ))
                                                ],
                                              ));
                                        } else {
                                          return LoadingViewScreen(color: ColorPallet().mainColor);
                                        }
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ));
                            }
                          }else{
                            return Container();
                          }
                        }
                    );
                  }else{
                    return Container();
                  }
                },
              )
          ),
        ),
      ),
    );
  }

  Widget itemArchive(List<ItemsArchiveChallengeModel> items,index,totalLength){
    return Column(
      children: [
        StreamBuilder(
            stream: animations.squareScaleBackButtonObserve,
            builder: (context,AsyncSnapshot<double>snapshotScale){
              if(snapshotScale.data != null){
                return Transform.scale(
                  scale:  modePress == 1 && items[index].selected ? snapshotScale.data : 1.0,
                  child: GestureDetector(
                    onTap: ()async{
                      for(int i=0 ; i<items.length ; i++){
                        items[i].selected = false;
                      }
                      items[index].selected = !items[index].selected;
                      setState(() {
                        modePress = 1;
                      });
                      await animationControllerScaleButton.reverse();
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: ChatApp(
                                back: (bool hasPartnerFromChat){
                                  if(hasPartnerFromChat){
                                    Navigator.pop(context);
                                  }else{
                                    widget.partnerTabPresenter!.getManInfo(context,false);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }
                                },
                                baseUrl: womanUrl,
                                baseMediaUrl: mediaUrl,
                                token: widget.dailyMessagePresenter!.getRegisters().token!,
                                id: items[index].id,
                              )
                          )
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(30),
                        vertical: ScreenUtil().setWidth(20),
                      ),
                      margin: EdgeInsets.only(
                          bottom: ScreenUtil().setWidth(40)
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: modePress == 1 && snapshotScale.data != 1
                                  && items[index].selected ?
                              ColorPallet().mainColor : Color(0xffEFEFEF),
                              width: ScreenUtil().setWidth(2)
                          ),
                          color: Colors.transparent
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Padding(
                                            padding:  EdgeInsets.only(
                                                right: ScreenUtil().setWidth(65)
                                            ),
                                            child: boxAvatar(items[index].womanAvatar),
                                          ),
                                          boxAvatar(items[index].manAvatar),
                                        ],
                                      ),
                                      SizedBox(height: ScreenUtil().setWidth(20)),
                                      Text(
                                        items[index].title,
                                        style: context.textTheme.labelMedium!.copyWith(
                                            color: ColorPallet().mainColor
                                        ),
                                      )
                                    ],
                                  ),
                                  VerticalDivider(
                                    color: Color(0xffEFEFEF),
                                    thickness: ScreenUtil().setWidth(2),
                                  ),
                                  Flexible(
                                    child: Text(
                                      items[index].text,
                                      style: context.textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(100),
                              height: ScreenUtil().setWidth(100),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorPallet().mainColor.withOpacity(0.08),
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: ColorPallet().mainColor,
                                size: ScreenUtil().setWidth(55),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }else{
                return Container();
              }
            }
        ),
        StreamBuilder(
          stream: widget.dailyMessagePresenter!.isMoreLoadingObserve,
          builder: (context,AsyncSnapshot<bool>isMoreLoading){
            if(isMoreLoading.data != null){
              if(isMoreLoading.data!){
                return  Padding(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                    child:  LoadingViewScreen(
                      color: ColorPallet().mainColor,
                      width: index == totalLength-1 ?ScreenUtil().setWidth(70) : 0.0,
                    )
                );
              }else{
                return  Container();
              }
            }else{
              return  Padding(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                  child:  LoadingViewScreen(
                    color: ColorPallet().mainColor,
                    width: index == totalLength-1 ?ScreenUtil().setWidth(70) : 0.0,
                  )
              );
            }
          },
        )
      ],
    );
  }

  Widget boxAvatar(String image){
    return Container(
      width: ScreenUtil().setWidth(80),
      height: ScreenUtil().setWidth(80),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
              color: Color(0xffCFC2FF)
          ),
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(image)
          )
      ),
    );
  }


}