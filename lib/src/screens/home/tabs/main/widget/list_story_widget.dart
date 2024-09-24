import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:impo/src/architecture/presenter/dashboard_presenter.dart';
import 'package:impo/src/components/colors.dart';
import 'package:get/get.dart';
import 'package:impo/src/models/story_model.dart';
import 'package:impo/src/screens/home/tabs/main/widget/story_page.dart';
import 'package:impo/src/core/app/view/themes/styles/text_theme.dart';
import 'package:page_transition/page_transition.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/data/locator.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:story_view/models/story_model.dart';
import 'package:story_view/widgets/story_list_view.dart';

class ListStoryWidget extends StatefulWidget {
  final DashboardPresenter? dashboardPresenter;
  const ListStoryWidget({Key? key, this.dashboardPresenter}) : super(key: key);

  @override
  State<ListStoryWidget> createState() => ListStoryWidgetState();
}

class ListStoryWidgetState extends State<ListStoryWidget> {


   late StoryViewModel story;

  @override
  void initState() {
    // stories = [for (var mapJson in json['stories']) StoryModel.fromJson(mapJson)];
    story = widget.dashboardPresenter!.getStories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              right: ScreenUtil().setWidth(38),
              bottom: ScreenUtil().setWidth(15),
          ),
          child: Text(
            story.text,
            style: context.textTheme.labelLargeProminent
          ),
        ),
        StoryListView(
            stories: story.items,
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(30)
            ),
            visitedOpacity: 0.5,
            viewedColor: Color(0xfff9f9f9),
            notViewedColor: ColorPallet().mainColor,
            spacing: 12,
            textStyle: context.textTheme.labelSmall,
            onStoryPressed: (_){
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child:  StoryPage(
                        stories: story.items,
                        index : story.items.indexOf(_),
                        onStoryShow: (StoryModel storyModel){
                          showStory(storyModel.id);
                          StoryModel result = story.items.firstWhere((element) => element.id == storyModel.id);
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              result.isViewed = true;
                              story.items.sort((a, b) => a.isViewed ? 1 : -1);
                            });
                          });
                        },
                      )
                  )
              );
            }
        )
      ],
    );
  }

   showStory(String id) async {
    print('showStory');
    print(id);
     var register = locator<RegisterParamModel>();
     Map<String,dynamic>? responseBody = await Http().sendRequest(
         womanUrl, 'story/view/$id', 'POST', {}, register.register.token!);
     print(responseBody);
   }

}
