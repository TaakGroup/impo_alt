import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:impo/src/architecture/presenter/support_presenter.dart';
import 'package:impo/src/architecture/view/support_view.dart';
import 'package:impo/src/components/animations.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/expert_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/firebase_analytics_helper.dart';
import 'package:impo/src/models/support/support_category_model.dart';
import 'package:impo/src/models/support/support_hostory_model.dart';
import 'package:impo/src/screens/home/tabs/profile/supportOnline/pages/chat_support_screen.dart';
import 'package:impo/src/screens/home/tabs/profile/supportOnline/pages/support_history_screen.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:page_transition/page_transition.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../widget/banner_contact_support_widget.dart';

class SupportScreen extends StatefulWidget{
  final String? categoryId;
  final bool? fromNotify;

  SupportScreen({Key? key,this.categoryId,this.fromNotify}):super(key:key);

  @override
  State<StatefulWidget> createState() => SupportScreenState();
}

class SupportScreenState extends State<SupportScreen> with TickerProviderStateMixin implements SupportView{

  late SupportPresenter _supportPresenter;

  SupportScreenState(){
    _supportPresenter = SupportPresenter(this);
  }

  Animations _animations =  Animations();
  late AnimationController animationController;

  bool isLoading=true;
  int modePress = 0;

  @override
  void initState() {
    AnalyticsHelper().log(AnalyticsEvents.SupportPg_Self_Pg_Load);
    animationController = _animations.pressButton(this);
    _supportPresenter.getAllCategory(context,categoryId: widget.categoryId!);
    super.initState();
  }

  @override
  void dispose() {
    _animations.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop()async{
    AnalyticsHelper().log(AnalyticsEvents.SupportPg_Back_NavBar_Clk);
    if(widget.fromNotify!){
      Navigator.pushReplacement(
          context,
          PageTransition(
              child: SupportScreen(
                categoryId: '',
                fromNotify: false,
              ),
              type: PageTransitionType.fade
          )
      );
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
   ///  ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return  WillPopScope(
      onWillPop: _onWillPop,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child:  Scaffold(
          backgroundColor: Colors.white,
          body:
          Stack(
            children: [
              StreamBuilder(
                stream: _supportPresenter.isLoadingObserve,
                builder: (context,AsyncSnapshot<bool>snapshotIsLoading){
                  if(snapshotIsLoading.data != null){
                    if(!snapshotIsLoading.data!){
                      return  StreamBuilder(
                        stream: _supportPresenter.allCategoryObserve,
                        builder: (context,AsyncSnapshot<SupportCategoryModel>snapshotAllCategory){
                          if(snapshotAllCategory.data != null){
                            if(snapshotAllCategory.data!.url != ''){
                              return Column(
                                children: [
                                  CustomAppBar(
                                    messages: false,
                                    profileTab: true,
                                    icon: 'assets/images/ic_arrow_back.svg',
                                    titleProfileTab: 'صفحه قبل',
                                    subTitleProfileTab: 'پشتیبانی',
                                    onPressBack: (){
                                      AnalyticsHelper().log(AnalyticsEvents.SupportPg_Back_Btn_Clk);
                                      if(widget.fromNotify!){
                                        Navigator.pushReplacement(
                                            context,
                                            PageTransition(
                                                child: SupportScreen(
                                                  categoryId: '',
                                                  fromNotify: false,
                                                ),
                                                type: PageTransitionType.fade
                                            )
                                        );
                                      }else{
                                        Navigator.pop(context);
                                      }
                                    },
                                    historySupport: true,
                                    supportPresenter: _supportPresenter,
                                  ),
                                  SizedBox(height: ScreenUtil().setWidth(20)),
                                  Expanded(
                                    child: WebViewWidget(
                                      controller: _supportPresenter.webViewController,
                                    ),
                                  ),
                                  // StreamBuilder(
                                  //   stream: _supportPresenter.webViewIsLoadingObserve,
                                  //   builder: (context,webViewLoading){
                                  //     if(webViewLoading.data != null){
                                  //       if(webViewLoading.data){
                                  //         return Center( child: CircularProgressIndicator()
                                  //         );
                                  //       }else{
                                  //         return ;
                                  //       }
                                  //     }else{
                                  //       return Container();
                                  //     }
                                  //   },
                                  // ),
                                  SizedBox(height: ScreenUtil().setWidth(250))
                                ],
                              );
                            }else{
                              return categoryItems(snapshotAllCategory.data!);
                            }
                          }else{
                            return Container();
                          }
                        },
                      );
                    }else{
                      return StreamBuilder(
                        stream: _supportPresenter.tryButtonErrorObserve,
                        builder: (context,AsyncSnapshot<bool>snapshotTryButton) {
                          if (snapshotTryButton.data != null) {
                            if (snapshotTryButton.data!) {
                              return Padding(
                                  padding: EdgeInsets.only(
                                      right: ScreenUtil().setWidth(80),
                                      left: ScreenUtil().setWidth(80),
                                      top: ScreenUtil().setWidth(200)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      StreamBuilder(
                                        stream: _supportPresenter.valueErrorObserve,
                                        builder: (context,AsyncSnapshot<String>snapshotValueError) {
                                          if (snapshotValueError.data != null) {
                                            return Text(
                                              snapshotValueError.data!,
                                              textAlign: TextAlign.center,
                                                style:  context.textTheme.bodyMedium!.copyWith(
                                                  color: Color(0xff707070),
                                                )
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                      Padding(
                                          padding:
                                          EdgeInsets.only(top: ScreenUtil().setWidth(32)),
                                          child: ExpertButton(
                                            title: 'تلاش مجدد',
                                            onPress: () {
                                              _supportPresenter.getAllCategory(context,categoryId: widget.categoryId!);
                                            },
                                            enableButton: true,
                                            isLoading: false,
                                          ))
                                    ],
                                  ));
                            } else {
                              return Center(child: LoadingViewScreen(color: ColorPallet().mainColor));
                            }
                          } else {
                            return Container();
                          }
                        },
                      );
                    }
                  }else{
                    return Container();
                  }
                },
              ),
              BannerContactSupportWidget(
                supportPresenter: _supportPresenter,
                onPress: (){
                  AnalyticsHelper().log(AnalyticsEvents.SupportPg_ContactSupport_Btn_Clk);
                },
              )
            ],
          )
        ),
      ),
    );
  }

  Widget categoryItems(SupportCategoryModel category){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(
            messages: false,
            profileTab: true,
            icon: 'assets/images/ic_arrow_back.svg',
            titleProfileTab: 'صفحه قبل',
            subTitleProfileTab: 'پشتیبانی',
            onPressBack: (){
              AnalyticsHelper().log(AnalyticsEvents.SupportPg_Back_Btn_Clk);
              if(widget.fromNotify!){
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        child: SupportScreen(
                          categoryId: '',
                          fromNotify: false,
                        ),
                        type: PageTransitionType.fade
                    )
                );
              }else{
                Navigator.pop(context);
              }
            },
            historySupport: true,
            supportPresenter: _supportPresenter,
          ),
          Padding(
            padding:  EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(30)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.categoryId == '' ?
                SizedBox(height: ScreenUtil().setWidth(20))
                : SizedBox.shrink(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.categoryId == '' ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ' تیکت‌های فعال',
                          style: context.textTheme.labelLargeProminent,
                        ),
                        StreamBuilder(
                          stream: _animations.squareScaleBackButtonObserve,
                          builder: (context,AsyncSnapshot<double>snapshotScale){
                            if(snapshotScale.data != null){
                              return Transform.scale(
                                scale: modePress == 1 ? snapshotScale.data : 1.0,
                                child: GestureDetector(
                                  onTap: ()async{
                                    setState(() {
                                      modePress = 1;
                                    });
                                    await  animationController.reverse();
                                    Navigator.push(context,
                                        PageTransition(
                                            type: PageTransitionType.fade,
                                            child:  SupportHistoryScreen(
                                              supportPresenter: _supportPresenter,
                                              // dashboardPresenter: widget.presenter,
                                            )
                                        )
                                    );
                                  },
                                  child: Text(
                                    'مشاهده همه',
                                    style: context.textTheme.labelMedium!.copyWith(
                                      color: ColorPallet().mainColor,
                                      decoration: TextDecoration.underline,
                                      decorationColor: ColorPallet().mainColor
                                    ),
                                  ),
                                ),
                              );
                            }else{
                              return Container();
                            }
                          },
                        )
                      ],
                    )
                    : SizedBox.shrink(),
                    StreamBuilder(
                      stream: _supportPresenter.historySupportsObserve,
                      builder: (context,AsyncSnapshot<List<SupportHistoryModel>>snapshotHistories){
                        if(snapshotHistories.data != null){
                          if(snapshotHistories.data!.length != 0){
                            return  ListView.builder(
                              addAutomaticKeepAlives: false,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: ScreenUtil().setWidth(15)),
                              itemCount: 1,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context,int index){
                                return  boxHistory(snapshotHistories.data![index],index,snapshotHistories.data!.length);
                              },
                            );
                          }else{
                            return SizedBox.shrink();
                          }
                        }else{
                          return  Container();
                        }
                      },
                    ),
                  ],
                ),
                Text(
                  category.describtion,
                  style: context.textTheme.bodySmall,
                ),
                SizedBox(height: ScreenUtil().setWidth(25)),
                Text(
                  category.title,
                  style: context.textTheme.labelMedium,
                ),
                ListView.builder(
                  itemCount: category.items.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setWidth(20)
                  ),
                  itemBuilder: (context,index){
                    return StreamBuilder(
                      stream: _animations.squareScaleBackButtonObserve,
                      builder: (context,AsyncSnapshot<double>snapshotScale){
                        if(snapshotScale.data != null){
                          return Transform.scale(
                            scale:  modePress == 1 ? category.items[index].isSelected? snapshotScale.data : 1.0 : 1.0,
                            child: GestureDetector(
                                onTap: (){
                                  for(int i=0 ; i<category.items.length ; i++){
                                    if(this.mounted){
                                      setState(() {
                                        category.items[i].isSelected = false;
                                      });
                                    }
                                  }
                                  setState(() {
                                    modePress = 1;
                                  });
                                  animationController.reverse();
                                  if(this.mounted){
                                    setState(() {
                                      category.items[index].isSelected = ! category.items[index].isSelected;
                                    });
                                  }
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: SupportScreen(
                                            categoryId: category.items[index].id,
                                            fromNotify: false,
                                          ),
                                          type: PageTransitionType.fade
                                      )
                                  );
                                  AnalyticsHelper().log(AnalyticsEvents.SupportPg_CategoriesList_Item_Clk,
                                      parameters: {
                                        'id' : category.items[index].id
                                      });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(25),
                                      vertical: ScreenUtil().setWidth(30)
                                  ),
                                  margin: EdgeInsets.only(
                                      bottom: ScreenUtil().setWidth(15)
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color(0xffF8F8F8),
                                      borderRadius: BorderRadius.circular(12)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          category.items[index].title,
                                          style: context.textTheme.bodySmall,
                                        ),
                                      ),
                                      SizedBox(width: ScreenUtil().setWidth(20)),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Color(0xff4B454D),
                                      )
                                    ],
                                  ),
                                )
                            ),
                          );
                        }else{
                          return Container();
                        }
                      },
                    );
                  },
                ),
                SizedBox(height: ScreenUtil().setWidth(250))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget boxHistory(SupportHistoryModel history,index,totalLength){
    return Container(
        margin: EdgeInsets.only(
            right: ScreenUtil().setWidth(10),
            left: ScreenUtil().setWidth(10),
            bottom: ScreenUtil().setWidth(30)
        ),
        decoration:  BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0xff5F9BDF).withOpacity(0.3),
                blurRadius: 5.0,
              )
            ],
            borderRadius: BorderRadius.circular(20)
        ),
        child:  Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(7),
          child:  InkWell(
            onTap: (){
              AnalyticsHelper().log(AnalyticsEvents.SupportHistoryPg_HistoryList_Item_Clk,
                  parameters: {
                    'id' : history.id
                  });
              Navigator.pushReplacement(context,
                  PageTransition(
                      type: PageTransitionType.bottomToTop,
                      child:  ChatSupportScreen(
                        supportPresenter: _supportPresenter,
                        chatId: history.id,
                        fromNotify: false,
                        // dashboardPresenter: widget.presenter,
                      )
                  )
              );
            },
            splashColor: Color(0xffA684EB).withOpacity(0.2),
            borderRadius: BorderRadius.circular(7),
            child:  Container(
              padding: EdgeInsets.all(
                  ScreenUtil().setWidth(20)
              ),
              child:  Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                            'assets/images/impo_icon.png'
                        ),
                      ),
                      SizedBox(width: ScreenUtil().setWidth(20)),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${history.categoryName != '' ? history.categoryName : 'دسته بندی عمومی'}',
                              overflow: TextOverflow.ellipsis,
                              style:  context.textTheme.labelMediumProminent,
                            ),
                            Text(
                              history.text,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:  context.textTheme.bodySmall!.copyWith(
                                color: Color(0xff4B454D),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenUtil().setHeight(30)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '${history.time} ${history.date}',
                        style:  context.textTheme.labelSmallProminent!.copyWith(
                          color:  ColorPallet().gray.withOpacity(0.6),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          history.status == 3 ?
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(10)
                            ),
                            height: ScreenUtil().setWidth(30),
                            width: ScreenUtil().setWidth(3),
                            color: Color(0xff9F9F9F).withOpacity(0.3),
                          ) :  Container(),
                          Row(
                            children: [
                              Text(
                                history.statusText,
                                style: context.textTheme.bodySmall!.copyWith(
                                  color: Color(int.parse(history.statusColor)),
                                ),
                              ),
                              // history.status == 2 ?
                              Padding(
                                padding: EdgeInsets.only(
                                    right: ScreenUtil().setWidth(3)
                                ),
                                child: SvgPicture.asset(
                                  'assets/images/ic_need_expert.svg',
                                  width: ScreenUtil().setWidth(22),
                                  height: ScreenUtil().setWidth(22),
                                  color: Color(int.parse(history.statusColor)),
                                ),
                              )
                                  // : Container()
                            ],
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        )
    );
  }

  Color checkColorStateHistory(int state){
    if(state == 1){
      return Color(0xffFF6A88);
    } else{
      return ColorPallet().gray.withOpacity(0.5);
    }
  }

  String checkTextStateHistory(int state){
    if(state == 1){
      return 'بسته شده';
    }else{
      return 'درحال بررسی';
    }
  }

  @override
  void onError(msg) {}

  @override
  void onSuccess(value) {}

}
