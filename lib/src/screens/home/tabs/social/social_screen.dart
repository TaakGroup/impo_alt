
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';
import 'package:impo/src/components/colors.dart';
import 'package:impo/src/components/custom_appbar.dart';
import 'package:impo/src/components/custom_button.dart';
import 'package:impo/src/components/loading_view_screen.dart';
import 'package:get/get.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/blogs/blog_feed_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/screens/home/home.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../architecture/presenter/expert_presenter.dart';
import '../../../../firebase_analytics_helper.dart';
import '../../../../models/advertise_model.dart';
import '../expert/clinic_question_screen.dart';


class SocialScreen extends StatefulWidget{
  final ExpertPresenter? expertPresenter;

  SocialScreen({Key? key,this.expertPresenter}):super(key:key);

  @override
  State<StatefulWidget> createState() => SocialScreenState();

}

class SocialScreenState extends State<SocialScreen>{


  var client = http.Client();
  bool isLoading = false;
  bool isTryBtn = false;
  List<BlogFeedModel> feeds = [];
  @override
  void initState() {
    parsRssFed();
    getAdvertise();
    super.initState();
  }

  AdvertiseViewModel? showAds;
  getAdvertise() {
    var advertiseInfo = locator<AdvertiseModel>();
    List<AdvertiseViewModel> allAds = advertiseInfo.advertises;
    List<AdvertiseViewModel> blogUpAds = [];
    if (allAds.length != 0) {
      for (int i = 0; i < allAds.length; i++) {
        if (allAds[i].place == 4) {
          blogUpAds.add(allAds[i]);
        }
      }
      if (blogUpAds.isNotEmpty) {
        if (blogUpAds.length > 1) {
          final _random = Random();
          showAds = blogUpAds[_random.nextInt(blogUpAds.length)];
        } else {
          showAds = blogUpAds[0];
        }
      }
    }
  }

  clickOnBanner(String id) async {
    var register = locator<RegisterParamModel>();
    Map responseBody = await Http().sendRequest(
        womanUrl, 'report/msgmotival/$id', 'POST', {}, register.register.token!);
    print(responseBody);
  }


  Future<bool> _launchURLAdv(String url,String? id) async {
    if(id != null){
      if(id != ''){
        clickOnBanner(id);
      }
    }
    String httpUrl = '';
    if(url.startsWith('http')){
      httpUrl = url;
    }else{
      httpUrl = 'https://$url';
    }
    if (!await launchUrl(Uri.parse(httpUrl))) throw 'Could not launch $httpUrl';
    // if (await canLaunch(httpUrl)) {
    //   await launch(httpUrl);
    // } else {
    //   throw 'Could not launch $httpUrl';
    // }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return  Scaffold(
      backgroundColor: Colors.white,
      body:  Column(
        children: <Widget>[
          CustomAppBar(
            messages: false,
            profileTab: false,
            icon:  'assets/images/ic_event_calendar.svg',
            titleProfileTab: 'صفحه قبل',
            subTitleProfileTab: 'درباره ما',
            onPressBack: (){
              Navigator.pushReplacement(context,
                  PageTransition(
                      settings: RouteSettings(name: "/Page1"),
                      type: PageTransitionType.topToBottom,
                      child:  FeatureDiscovery(
                          recordStepsInSharedPreferences: true,
                          child: Home(
                            indexTab: 0,
                            register: true,
                            isChangeStatus: false,
                            // isLogin: false,
                          )
                      )
                  )
              );
            },
          ),
          showAds != null ?
          Padding(
              padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(40),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: ScreenUtil().setWidth(160),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        placeholder: 'assets/images/place_holder_adv.png' ,
                        image:'$mediaUrl/file/${showAds!.image}',
                      ),
                      // Image.network(
                      //   '$mediaUrl/file/${snapshotAdv.data.image}',
                      // ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        // splashColor: Colors.lightGreenAccent,
                        onTap: (){
                          if(showAds!.typeLink == 1 || showAds!.typeLink == 2){
                            AnalyticsHelper().log(AnalyticsEvents.BlogPg_AdvBanner_Banner_Clk);
                            if(showAds!.typeLink == 1){
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child:  ClinicQuestionScreen(
                                          expertPresenter: widget.expertPresenter,
                                          bodyTicketInfo: json.decode(showAds!.link),
                                          // ticketId: ticketsModel.ticketId,
                                        )
                                    )
                                );
                            }
                            if(showAds!.typeLink == 2){
                              if(showAds!.link != ''){
                                Timer(Duration(milliseconds: 300),(){
                                  _launchURLAdv(showAds!.link,showAds!.id);
                                });
                              }
                            }
                          }
                        },
                        child: Container(
                          height: ScreenUtil().setWidth(145),
                        )
                    ),
                  )
                ],
              )
            // Ink.image(
            //   image: NetworkImage(
            //     '$mediaUrl/file/${snapshotAdv.data.image}',
            //   ),
            //   fit: BoxFit.cover,
            //   child: InkWell(
            //     onTap: (){
            //       print('dsds');
            //     },
            //   ),
            // )
          ) :
              Container(),
          SizedBox(height: ScreenUtil().setHeight(10)),
          Expanded(
              child: !isLoading ?
              feeds.length != 0 ?
              ListView.builder(
                itemCount: feeds.length,
                itemBuilder: (context,index){
                  return itemArticle(index);
                },
              ) :  Center(
                child:  Text(
                  'مقاله ای یافت نشد',
                  style:  context.textTheme.bodyLarge,
                ),
              )
                  :  Center(
                child: isTryBtn ?
                Padding(
                    padding: EdgeInsets.only(
                        right: ScreenUtil().setWidth(80),
                        left: ScreenUtil().setWidth(80),
                        top: ScreenUtil().setWidth(200)
                    ),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید',
                          textAlign: TextAlign.center,
                            style:  context.textTheme.bodyMedium!.copyWith(
                              color: Color(0xff707070),
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setWidth(32)
                            ),
                            child:    CustomButton(
                              title: 'تلاش مجدد',
                              onPress: (){
                                parsRssFed();
                              },
                              margin: 15,
                              enableButton: true,
                              isLoadingButton: false,
                            )
                        )
                      ],
                    )
                )
                    :   LoadingViewScreen(
                  color: ColorPallet().mainColor,
                ),
              )
          )
        ],
      ),
    );
  }

  parsRssFed()async{
    var registerInfo =locator<RegisterParamModel>();
    if(this.mounted){
      setState(() {
        isLoading = true;
        isTryBtn = false;
      });
    }
    try{
      Map<String,dynamic>? responseBody = await Http().sendRequest(
          womanUrl,
          'info/posts',
          'POST',
          {},
          registerInfo.register.token!
      );
      if(responseBody != null){
        if(responseBody['valid']){
          if(this.mounted){
            setState(() {
              isLoading = false;
            });
          }
          responseBody['items'].forEach((item){
            feeds.add(
                BlogFeedModel.fromJson(item)
            );
          });
        }else{
          if(this.mounted){
            setState(() {
              isTryBtn = true;
            });
          }
        }
      }else{
        if(this.mounted){
          setState(() {
            isTryBtn = true;
          });
        }
      }
    }catch(e){
      debugPrint(e.toString());
      if(this.mounted){
        setState(() {
          isTryBtn = true;
        });
      }
    }

  }

  Widget itemArticle(index){
    return  Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(
              bottom: ScreenUtil().setWidth(50),
              left: ScreenUtil().setWidth(40),
              right: ScreenUtil().setWidth(40),
            ),
            child:    Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height:  MediaQuery.of(context).size.width/1.5,
                        decoration:  BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: ColorPallet().mainColor.withOpacity(0.2),
                                blurRadius: 5.0
                            )
                          ],
                        ),
                        child:  ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                          ),
                          child: FadeInImage.assetNetwork(
                            fit: BoxFit.cover,
                            placeholder: 'assets/images/place_holder_articel.png' ,
                            image: feeds[index].image,
                          ),
                        )
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(20)
                      ),
                      width: MediaQuery.of(context).size.width,
                      // height: ScreenUtil().setWidth(145),
                      decoration:  BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: ColorPallet().mainColor.withOpacity(0.2),
                              blurRadius: 5.0,
                              offset: Offset(0.0, 1)
                          )
                        ],
                      ),
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(height : ScreenUtil().setWidth(15)),
                          Text(
                            feeds[index].title,
                            style:  context.textTheme.bodyMedium,
                          ),
                          SizedBox(height : ScreenUtil().setWidth(10)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                feeds[index].date,
                                style:  context.textTheme.bodySmall!.copyWith(
                                  color: ColorPallet().gray.withOpacity(0.6),
                                ),
                              ),
                              //  Text(
                              //   feeds[index].creator,
                              //   style:  TextStyle(
                              //       color: ColorPallet().gray.withOpacity(0.6),
                              //       fontSize: ScreenUtil().setSp(28),
                              //       fontFamily: FontFamily().iranYekanMedium
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(height : ScreenUtil().setWidth(15)),
                        ],
                      ),
                    )
                  ],
                ),
                Material(
                  color: Colors.transparent,
                  child:  InkWell(
                    onTap: (){
                      AnalyticsHelper().log(
                          AnalyticsEvents.BlogPg_BlogList_Item_Clk,
                        parameters: {
                            'linkBlog' : feeds[index].link
                        }
                      );
                      _launchURL(feeds[index].link);
                    },
                    borderRadius: BorderRadius.circular(10),
                    splashColor: Colors.white.withOpacity(0.4),
                    child:  Container(
                      width: MediaQuery.of(context).size.width,
                      height:  MediaQuery.of(context).size.width/1.5 + ScreenUtil().setWidth(145),
                    ),
                  ),
                )
              ],
            )
        ),
        index == feeds.length-1 ?
        Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(10),
              bottom:  ScreenUtil().setWidth(30),
            ),
            child:  CustomButton(
              onPress: (){
                _launchURL("https://impo.app/blogs/");
              },
              colors: [ColorPallet().mentalHigh,ColorPallet().mentalMain],
              borderRadius: 10.0,
              margin: 80,
              enableButton: true,
              title: 'مشاهده بیشتر',
            )
        ) :  Container()

      ],
    );
  }

  _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
  }

}



// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';
// import 'package:impo/src/components/colors.dart';
// import 'package:impo/src/components/custom_appbar.dart';
// import 'package:impo/src/components/expert_button.dart';
// import 'package:impo/src/components/loading_view_screen.dart';
// import 'package:impo/src/screens/home/home.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:webfeed/webfeed.dart';
// import 'package:impo/src/models/blog_feed_model.dart';
// import 'package:impo/src/models/register_parameters_model.dart';
// import 'package:impo/src/components/custom_button.dart';
//
// class SocialScreen extends StatefulWidget{
//
//
//   @override
//   State<StatefulWidget> createState() => SocialScreenState();
//
// }
//
// class SocialScreenState extends State<SocialScreen>{
//
//
//   var client = http.Client();
//   bool isLoading = false;
//   bool isTryBtn = false;
//   List<BlogFeedModel> feeds = [];
//   List<String> icons = [
//     'assets/images/wave_article_1.png',
//     'assets/images/wave_article_1.png',
//     'assets/images/wave_article_2.png',
//     'assets/images/wave_article_3.png',
//     'assets/images/wave_article_4.png',
//     'assets/images/wave_article_5.png',
//     'assets/images/wave_article_6.png',
//   ];
//   int counter = 0;
//   @override
//   void initState() {
//     parsRssFed();
//     super.initState();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
//     return new Scaffold(
//       backgroundColor: Colors.white,
//       body: new Column(
//         children: <Widget>[
//           new CustomAppBar(
//             messages: false,
//             profileTab: false,
//             icon: 'assets/images/event.png',
//             titleProfileTab: 'صفحه قبل',
//             subTitleProfileTab: 'درباره ما',
//             onPressBack: (){
//               Navigator.pushReplacement(context,
//                   PageTransition(
//                       type: PageTransitionType.topToBottom,
//                       child:  FeatureDiscovery(
//                           recordStepsInSharedPreferences: true,
//                           child: Home(
//                             indexTab: 0,
// //                             register: true,
//                           )
//                       )
//                   )
//               );
//             },
//           ),
//           new SizedBox(height: ScreenUtil().setHeight(35)),
//           new Expanded(
//               child: !isLoading ?
//               feeds.length != 0 ?
//               new ListView.builder(
//                 itemCount: feeds.length,
//                 itemBuilder: (context,index){
//                   return itemArticle(index);
//                 },
//               ) : new Center(
//                 child: new Text(
//                   'مقاله ای یافت نشد',
//                   style: new TextStyle(
//                       color: ColorPallet().black,
//                       fontSize: ScreenUtil().setSp(28)
//                   ),
//                 ),
//               )
//                   : new Center(
//                 child: isTryBtn ?
//                 new Padding(
//                     padding: EdgeInsets.only(
//                         right: ScreenUtil().setWidth(80),
//                         left: ScreenUtil().setWidth(80)
//                     ),
//                     child: new Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         new Text(
//                           'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید',
//                           textAlign: TextAlign.center,
//                           style: new TextStyle(
//                               color: Color(0xff707070),
//                               fontWeight: FontWeight.w500,
//                               fontSize: ScreenUtil().setSp(34)
//                           ),
//                         ),
//                         new Padding(
//                             padding: EdgeInsets.only(
//                                 top: ScreenUtil().setWidth(120)
//                             ),
//                             child:   new ExpertButton(
//                               title: 'تلاش مجدد',
//                               onPress: (){
//                                 parsRssFed();
//                               },
//                               enableButton: true,
//                               isLoading: false,
//                             )
//                         )
//                       ],
//                     )
//                 )
//                     :  new LoadingViewScreen(
//                   color: ColorPallet().mainColor,
//                 ),
//               )
//           )
//         ],
//       ),
//     );
//   }
//
//   parsRssFed()async{
//     if(this.mounted){
//       setState(() {
//         isLoading = true;
//         isTryBtn = false;
//       });
//     }
//     try{
//       var response = await client.get(Uri.parse('https://impo.app/blog/feed/?show_images=true'));
//       if(response.statusCode == 200){
//         RssFeed channel = RssFeed.parse(response.body);
//         if(this.mounted){
//           setState(() {
//             isLoading = false;
//           });
//         }
//
//         for(int i=0 ; i<channel.items.length ; i++){
//           if(channel.items[i].description.split('"')[1].startsWith('http') && channel.items[i].title != 'بلاگ'){
//             counter++;
//             if(counter == 7){
//               counter = 1;
//             }
//             feeds.add(BlogFeedModel.fromJson(
//                 channel.items[i].description.split('"')[1],
//                 channel.items[i].title,
//                 channel.items[i].dc.creator,
//                 channel.items[i].pubDate,
//                 channel.items[i].link,
//                 counter,
//             )
//             );
//           }
//         }
//         // print(feeds[0].image);
//         // print(feeds[3].title);
//         // print(feeds[3].date);
//         // print(feeds[3].creator);
//         // print(feeds[3].link);
//       }else{
//         if(this.mounted){
//           setState(() {
//             isTryBtn = true;
//           });
//         }
//       }
//     }catch(e){
//       debugPrint(e.toString());
//       if(this.mounted){
//         setState(() {
//           isTryBtn = true;
//         });
//       }
//     }
//
//   }
//
//   Widget itemArticle(index){
//     return new Column(
//       children: <Widget>[
//         new Padding(
//             padding: EdgeInsets.only(
//               bottom: ScreenUtil().setWidth(50),
//               left: ScreenUtil().setWidth(40),
//               right: ScreenUtil().setWidth(40),
//             ),
//             child:   new Stack(
//               children: <Widget>[
//                 new Column(
//                   children: <Widget>[
//                     new Container(
//                         width: MediaQuery.of(context).size.width,
//                         height:  MediaQuery.of(context).size.width/1.5,
//                         decoration: new BoxDecoration(
//                           borderRadius: BorderRadius.only(
//                             topRight: Radius.circular(10),
//                             topLeft: Radius.circular(10),
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                                 color: ColorPallet().mainColor.withOpacity(0.2),
//                                 blurRadius: 5.0
//                             )
//                           ],
//                           //      image: new DecorationImage(
//                           //     fit: BoxFit.cover,
//                           //     image: NetworkImage(
//                           //         feeds[index].image
//                           //     )
//                           // )
//                         ),
//                         child: new ClipRRect(
//                           borderRadius: BorderRadius.only(
//                             topRight: Radius.circular(10),
//                             topLeft: Radius.circular(10),
//                           ),
//                           child: FadeInImage.assetNetwork(
//                             fit: BoxFit.cover,
//                             placeholder: 'assets/images/place_holder_articel.png' ,
//                             image: feeds[index].image,
//                           ),
//                         )
//                     ),
//                     new Container(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: ScreenUtil().setWidth(20)
//                       ),
//                       width: MediaQuery.of(context).size.width,
//                       height: ScreenUtil().setWidth(145),
//                       decoration: new BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.only(
//                             bottomRight: Radius.circular(10),
//                             bottomLeft: Radius.circular(10),
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                                 color: ColorPallet().mainColor.withOpacity(0.2),
//                                 blurRadius: 5.0,
//                                 offset: Offset(0.0, 1)
//                             )
//                           ],
//                           image: new DecorationImage(
//                               fit: BoxFit.cover,
//                               image: AssetImage(
//                                   icons[feeds[index].counterForIcon]
//                               )
//                           )
//                       ),
//                       child: new Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           new SizedBox(height : ScreenUtil().setWidth(20)),
//                           new Text(
//                             feeds[index].title,
//                             style: new TextStyle(
//                                 color: Colors.black87,
//                                 fontSize: ScreenUtil().setSp(30),
//                                 fontWeight: FontWeight.bold
//                             ),
//                           ),
//                           new SizedBox(height : ScreenUtil().setWidth(20)),
//                           new Row(
//                             children: <Widget>[
//                               // new Text(
//                               //   feeds[index].creator,
//                               //   style: new TextStyle(
//                               //       color: ColorPallet().black,
//                               //       fontSize: ScreenUtil().setSp(28)
//                               //   ),
//                               // ),
//                               // new Text(
//                               //   ' / ',
//                               //   style: new TextStyle(
//                               //       color: ColorPallet().black,
//                               //       fontSize: ScreenUtil().setSp(28)
//                               //   ),
//                               // ),
//                               new Text(
//                                 feeds[index].date,
//                                 style: new TextStyle(
//                                     color: ColorPallet().black,
//                                     fontSize: ScreenUtil().setSp(28)
//                                 ),
//                               ),
//                             ],
//                           ),
//                           new SizedBox(height : ScreenUtil().setWidth(30)),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//                 new Material(
//                   color: Colors.transparent,
//                   child: new InkWell(
//                     onTap: (){
//                       _launchURL(feeds[index].link);
//                     },
//                     borderRadius: BorderRadius.circular(10),
//                     splashColor: Colors.white.withOpacity(0.4),
//                     child: new Container(
//                       width: MediaQuery.of(context).size.width,
//                       height:  MediaQuery.of(context).size.width/1.5 + ScreenUtil().setWidth(145),
//                     ),
//                   ),
//                 )
//               ],
//             )
//         ),
//         index == feeds.length-1 ?
//         new Padding(
//             padding: EdgeInsets.only(
//               top: ScreenUtil().setWidth(10),
//               bottom:  ScreenUtil().setWidth(30),
//             ),
//             child: new CustomButton(
//               onPress: (){
//                 _launchURL('https://impo.app/blog/page/2/');
//               },
//               title: 'مشاهده بیشتر',
//             )
//         ) : new Container()
//
//       ],
//     );
//   }
//
//   _launchURL(url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
// }

