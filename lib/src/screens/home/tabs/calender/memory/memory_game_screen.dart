


import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:impo/src/architecture/presenter/memory_presenter.dart';
import 'package:impo/src/architecture/view/memory_view.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/expert_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/memory/memort_get_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/home/tabs/calender/memory/add_memory_screen.dart';
import 'package:impo/src/screens/home/tabs/calender/memory/profile_memory_screen.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../firebase_analytics_helper.dart';

class MemoryGameScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => MemoryGameScreenState();
}

class MemoryGameScreenState extends State<MemoryGameScreen>  with TickerProviderStateMixin implements MemoryView{

  late MemoryPresenter _presenter;
  Animations _animations =  Animations();
  late AnimationController animationControllerScaleButtons;
  late ScrollController _scrollController ;
  late AnimationController _controller;
  bool scrollUp = true;
  double width = 230.0;
  String name = '';


  MemoryGameScreenState(){
    _presenter = MemoryPresenter(this);
  }



  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.MemoryGamePg_Self_Pg_Load);
    _presenter.getMemories(state: 0);
    animationControllerScaleButtons = _animations.pressButton(this);
    setName();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      upperBound: 1.0,
      lowerBound: 0.0
    );
    _controller.forward();
    _scrollController = ScrollController()
      ..addListener(() async{
        if(_scrollController.position.userScrollDirection == ScrollDirection.forward){
          if(this.mounted){
            setState(() {
              // scrollUp = true;
              width = 230;
            });
          }
          _controller.forward();
        }else if(_scrollController.position.userScrollDirection == ScrollDirection.reverse){
          if(this.mounted){
            setState(() {
              // scrollUp = false;
              width = 70;
            });
          }
          _controller.reverse();
        }
      });
    super.initState();
  }

  setName(){
    var registerInfo = locator<RegisterParamModel>();
    setState(() {
      name = registerInfo.register.name!;
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.MemoryGamePg_Back_NavBar_Clk);
    Navigator.of(context).popUntil(ModalRoute.withName("/Page1"));
    return Future.value(false);
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
            body: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBar(
                      messages: false,
                      profileTab: true,
                      icon: 'assets/images/ic_arrow_back.svg',
                      titleProfileTab: 'صفحه قبل',
                      subTitleProfileTab: 'خاطره‌بازی',
                      onPressBack: (){
                        AnalyticsHelper().log(AnalyticsEvents.MemoryGamePg_Back_Btn_Clk);
                        _onWillPop();
                      },
                    ),
                    StreamBuilder(
                      stream: _presenter.isLoadingObserve,
                      builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                        if(snapshotIsLoading.data != null){
                          if(!snapshotIsLoading.data!){
                            return StreamBuilder(
                              stream: _presenter.memoriesObserve,
                              builder: (context,AsyncSnapshot<List<MemoryGetModel>>snapshotMemories){
                                if(snapshotMemories.data != null){
                                  if(snapshotMemories.data!.length != 0){
                                    return  Expanded(
                                      child: Column(
                                        children: [
                                          SizedBox(height: ScreenUtil().setHeight(30)),
                                          Expanded(
                                              child: StreamBuilder(
                                                stream: _presenter.counterMoreLoadObserve,
                                                builder: (context,counterMoreLoad){
                                                  if(counterMoreLoad.data != null){
                                                    return   ListView.builder(
                                                      controller: _scrollController,
                                                      addAutomaticKeepAlives: false,
                                                      padding: EdgeInsets.only(
                                                          top: 0,
                                                          bottom: ScreenUtil().setWidth(100)
                                                      ),
                                                      itemCount: snapshotMemories.data!.length,
                                                      itemBuilder: (context,int index){
                                                        if(index == snapshotMemories.data!.length-1){
                                                          _presenter.moreLoadGetTickets();
                                                        }
                                                        return  Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            index == 0 ?
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                right: ScreenUtil().setWidth(50),
                                                              ),
                                                              child: Text(
                                                                'خاطره‌بازی',
                                                                style: context.textTheme.titleSmall!.copyWith(
                                                                  color: ColorPallet().gray,
                                                                ),
                                                              ),
                                                            ) : Container(width: 0,height: 0,),
                                                            boxMemory(snapshotMemories.data![index],index,snapshotMemories.data!.length)
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }else{
                                                    return  Container();
                                                  }
                                                },
                                              )
                                          )
                                        ],
                                      )
                                    );
                                  }else{
                                    return noMemories();
                                  }
                                }else{
                                  return  Container();
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
                                               top: ScreenUtil().setWidth(200),
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
                                                        _presenter.getMemories(state: 0);
                                                      },
                                                      enableButton: true,
                                                      isLoading: false,
                                                    )
                                                )
                                              ],
                                            )
                                        );
                                      }else{
                                        return  Center(
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
                              ),
                            );
                          }
                        }else{
                          return  Container();
                        }
                      },
                    ),
                  ],
                ),
                StreamBuilder(
                  stream: _presenter.memoriesObserve,
                  builder: (context,AsyncSnapshot<List<MemoryGetModel>>snapshotMemories){
                    if(snapshotMemories.data != null){
                      if(snapshotMemories.data!.length != 0){
                        return  StreamBuilder(
                          stream: _animations.squareScaleBackButtonObserve,
                          builder: (context,AsyncSnapshot<double>snapshotScale){
                            if(snapshotScale.data != null){
                              return Transform.scale(
                                scale: snapshotScale.data,
                                child: GestureDetector(
                                    onTap: ()async{
                                      AnalyticsHelper().log(AnalyticsEvents.MemoryGamePg_Startthememorygame_Btn_Clk);
                                      await animationControllerScaleButtons.reverse();
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                            child: AddMemoryScreen(
                                              memoryPresenter: _presenter,
                                            ),
                                            type: PageTransitionType.fade,
                                          )
                                      );
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: ScreenUtil().setWidth(60),
                                            right: ScreenUtil().setWidth(50)
                                        ),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(13),
                                          child:  Container(
                                              decoration:  BoxDecoration(
                                                  borderRadius: BorderRadius.circular(13),
                                                  gradient:  LinearGradient(
                                                      colors: [
                                                        ColorPallet().mentalMain,
                                                        ColorPallet().mentalHigh,
                                                      ],
                                                      begin: Alignment.centerRight,
                                                      end: Alignment.centerLeft
                                                  )
                                              ),
                                            child: AnimatedSize(
                                                // vsync: this,
                                                alignment: Alignment.centerRight,
                                                duration: Duration(milliseconds: 800),
                                                reverseDuration: Duration(milliseconds: 800),
                                                child: Container(
                                                  height: ScreenUtil().setWidth(70),
                                                  width: ScreenUtil().setWidth(width),
                                                    padding: EdgeInsets.only(
                                                        right: ScreenUtil().setWidth(10),
                                                        left:  width == 230 ? ScreenUtil().setWidth(20) : ScreenUtil().setWidth(0),
                                                    ),
                                                  decoration:  BoxDecoration(
                                                      borderRadius: BorderRadius.circular(13),
                                                      color: Colors.transparent
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                        size: ScreenUtil().setWidth(50),
                                                      ),
                                                      width == 230 ?
                                                      Text(
                                                        'خاطره جدید',
                                                        style:  context.textTheme.labelLarge!.copyWith(
                                                          color: Colors.white,
                                                        ),
                                                      )   :  Container(width: 0,height: 0,)
                                                    ],
                                                  )
                                                )
                                            )
                                          )
                                        )
                                    )
                                ),
                              );
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
            )
        ),
      )
    );
  }

  noMemories(){
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtil().setWidth(50)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child:  Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(430),
                  ),
                  child: SvgPicture.asset(
                    'assets/images/ic_big_memory.svg',
                    width: ScreenUtil().setWidth(140),
                    height: ScreenUtil().setWidth(140),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(20)
                  ),
                  child: Text(
                    'از روزهای خوب، فقط خاطره‌های قشنگشه که میمونه😍\nمی‌تونی اینجا خاطرات قشنگت رو با ${_presenter.getPartnerName()} به اشتراک بذاری و هر دو از دیدنش لذت ببرید🌹❤️',
                    textAlign: TextAlign.center,
                    style:  context.textTheme.labelMediumProminent!.copyWith(
                      color: ColorPallet().gray,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(80),
              bottom: ScreenUtil().setWidth(100)
            ),
            child: SvgPicture.asset(
              'assets/images/ic_no_memory.svg',
              width: ScreenUtil().setWidth(500),
              height: ScreenUtil().setWidth(500),
            ),
          ),
          StreamBuilder(
            stream: _animations.squareScaleBackButtonObserve,
            builder: (context,AsyncSnapshot<double>snapshotScale){
              if(snapshotScale.data != null){
                return Transform.scale(
                  scale: snapshotScale.data,
                  child: GestureDetector(
                    onTap: ()async{
                      AnalyticsHelper().log(AnalyticsEvents.MemoryGamePg_Startthememorygame_Btn_Clk);
                      await animationControllerScaleButtons.reverse();
                      Navigator.push(
                        context,
                        PageTransition(
                            child: AddMemoryScreen(
                              memoryPresenter: _presenter,
                            ),
                          type: PageTransitionType.fade,
                        )
                      );
                    },
                    child:  Container(
                        height: ScreenUtil().setWidth(70),
                        width: ScreenUtil().setWidth(380),
                        decoration:  BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            gradient:  LinearGradient(
                                colors: [
                                  ColorPallet().mentalMain,
                                  ColorPallet().mentalHigh,
                                ],
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft
                            )
                        ),
                        child:   Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: ScreenUtil().setWidth(50),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(15)),
                            Text(
                              'خاطره‌بازی رو شروع کن',
                              style:  context.textTheme.labelLarge!.copyWith(
                                color: Colors.white,
                              ),
                            )
                          ],
                        )
                    ),
                  ),
                );
              }else{
                return Container();
              }
            },
          )
        ],
      ),
    );
  }

  boxMemory(MemoryGetModel memoryModel,index,totalLength){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(70)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              memoryModel.isDate && index != 0 ?
                  Padding(
                    padding: EdgeInsets.only(
                      top: ScreenUtil().setWidth(0),
                    ),
                    child: Divider(color: ColorPallet().gray,height: ScreenUtil().setHeight(2),),
                  )
                  : Container(width: 0,height: 0,),
              memoryModel.isDate ?
                  Padding(
                    padding: EdgeInsets.only(
                      top: ScreenUtil().setWidth(30)
                    ),
                    child: Text(
                      memoryModel.date,
                      style:context.textTheme.labelMediumProminent!.copyWith(
                        color: ColorPallet().mainColor,
                      ),
                    ),
                  ) : Container(width: 0,height: 0,),
                  GestureDetector(
                    onTap: (){
                      AnalyticsHelper().log(
                          AnalyticsEvents.MemoryGamePg_MemoryList_Item_Clk,
                          parameters: {
                            'id' : memoryModel.id
                          }
                      );
                      Navigator.push(
                        context,
                        PageTransition(
                            child: ProfileMemoryScreen(
                              memoryPresenter: _presenter,
                              memoryGetModel: memoryModel,
                            ),
                            type: PageTransitionType.fade
                        )
                      );
                    },
                    child: Column(
                      children: [
                        FutureBuilder(
                          future: _presenter.getToken(),
                          builder: (context,snapshotToken){
                            if(snapshotToken.data != null){
                              return Container(
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil().setWidth(20)
                                  ),
                                  // height: MediaQuery.of(context).size.width,
                                  // width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xff9EABD1).withOpacity(0.2),
                                        blurRadius: 10.0
                                      )
                                    ]
                                  ),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: FadeInImage(
                                        height: MediaQuery.of(context).size.width - ScreenUtil().setWidth(140),
                                        width: MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                        image: memoryModel.localPath == null ?
                                            loadImageNetwork(memoryModel.fileName,snapshotToken.data)
                                                : memoryModel.localPath == '' ?
                                            loadImageNetwork(memoryModel.fileName,snapshotToken.data)
                                                : FileImage(
                                          File(memoryModel.localPath!),
                                        ),
                                        placeholder: AssetImage(
                                          'assets/images/ic_placeholder_memory.png',
                                        ),
                                      ),
                                    ),
                                  )
                              );
                            }else{
                              return Container();
                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setWidth(10)
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: ScreenUtil().setWidth(17),
                                height: ScreenUtil().setWidth(17),
                                margin: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(20)
                                ),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [ColorPallet().mentalMain,ColorPallet().mentalHigh]
                                    ),
                                    shape: BoxShape.circle
                                ),
                              ),
                              SizedBox(width: ScreenUtil().setWidth(20),),
                              Flexible(
                                child: Text(
                                  memoryModel.title,
                                  style: context.textTheme.labelLargeProminent,
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: ScreenUtil().setWidth(17),
                              height: ScreenUtil().setWidth(17),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle
                              ),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(20),),
                            Flexible(
                              child:  Padding(
                                padding: EdgeInsets.only(
                                    bottom: ScreenUtil().setWidth(40)
                                ),
                                child: Text(
                                  memoryModel.text,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.textTheme.bodyMedium!.copyWith(
                                    color: ColorPallet().gray,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
            ],
          ),
        ),
        StreamBuilder(
          stream: _presenter.isMoreLoadingObserve,
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


   loadImageNetwork(fileName,token){
   return fileName == null ?
   AssetImage(
     'assets/images/ic_placeholder_memory.png',
   ) : fileName == ''?
   AssetImage(
     'assets/images/ic_placeholder_memory.png',
   ) :     NetworkImage(
       '$mediaUrl/woman/$fileName',
       headers: {"Authorization": "Bearer $token"}
   ) ;
  }

  @override
  void onError(msg) {

  }

  @override
  void onSuccess(value) {

  }

}