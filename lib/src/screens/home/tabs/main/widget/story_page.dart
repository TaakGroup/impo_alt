import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/components/colors.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:story_view/models/story_events.dart';
import 'package:story_view/models/story_model.dart';
import 'package:story_view/story_view.dart';
import 'package:url_launcher/url_launcher.dart';


class StoryPage extends StatefulWidget {

  final List<StoryModel>? stories;
  int? index;
  final Function(StoryModel)? onStoryShow;

   StoryPage({Key? key,this.stories, this.index, this.onStoryShow}) : super(key: key);

  @override
  State<StoryPage> createState() => StoryPageState();
}

class StoryPageState extends State<StoryPage> {

   late StoryController controller;

  @override
  void initState() {
    print('********************************************');
    print(widget.stories![widget.index!].duration);
    controller = StoryController();
   Timer(Duration(milliseconds: 100),(){
     controller.jumpTo(widget.index!);
   });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    timeDilation = 1.0;
    return Scaffold(
      body: StoryView(
        profilePadding: EdgeInsets.only(
            top: ScreenUtil().setWidth(100),
            right: ScreenUtil().setWidth(35)
        ),
        avatar: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Image.asset(
            'assets/images/impo_icon.png',
          ),
        ),
        title: Text(
            'impo.app',
             style: context.textTheme.labelSmallProminent,
        ),
        leading: SizedBox(),
        mark: SizedBox(),
        controller: controller,
        indicatorColor: Colors.white38,
        indicatorForegroundColor: Colors.white,
        inline: true,
        onStoryShow: (StoryModel storyModel){
          if(widget.index == -1 || widget.stories!.indexOf(storyModel) == widget.index){
            widget.onStoryShow!(storyModel);
            widget.index = -1;
          }
        },
        onComplete: () => Navigator.pop(context),
        // onStoryShow: (value) => OnboardingController.to.currentStory = stories.indexOf(value.view),
        storyItems: [
          for (int index = 0; index < widget.stories!.length; index++)
            StoryItem.fromModel(
              widget.stories![index],
              controller,
              onButtonPressed: (LinkModel link) {
                print(link.url);
                _launchURL(Uri.parse(link.url!));
              },
              buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: ColorPallet().mainColor,
                padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setWidth(20),
                  horizontal: ScreenUtil().setWidth(30),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                elevation: 5.0,
                textStyle: context.textTheme.labelLarge,
              ),
            )
        ],
        showShadow: true,
      ),
    );
  }


   Future<bool> _launchURL(url) async {

     if (!await launchUrl(url)) throw 'Could not launch $url';
     return true;
   }
  
}
