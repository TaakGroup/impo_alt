import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/view/themes/styles/decorations.dart';
import 'package:impo/src/features/index/controller/story_controller.dart';
import 'package:impo/src/screens/home/tabs/main/widget/story_page.dart';
import 'package:story_view/models/story_model.dart';
import 'package:story_view/story_view.dart';

import '../../data/models/story_widget_model.dart';

class StoriesWidget extends StatelessWidget {
  final StoryWidgetModel model;

  const StoriesWidget({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: Decorations.pagePaddingHorizontal,
          child: Text(
            model.title,
            style: context.textTheme.titleMedium,
          ),
        ),
        SizedBox(height: 12),
        GetBuilder<StoryServiceController>(
          builder: (controller) {
            return StoryListView(
              stories: model.stories,
              spacing: 12,
              visitedOpacity: 0.5,
              viewedColor: Color(0xfff9f9f9),
              notViewedColor: Colors.red,
              textStyle: context.textTheme.labelSmall,
              onStoryPressed: (_) => Get.to(
                StoryPage(
                  stories: model.stories,
                  index: model.stories.indexOf(_),
                  onStoryShow: (StoryModel storyModel) {
                    StoryModel result = model.stories.firstWhere((element) => element.id == storyModel.id);
                    SchedulerBinding.instance.addPostFrameCallback(
                      (_) {
                        result.isViewed = true;
                        model.stories.sort((a, b) => a.isViewed ? 1 : -1);
                        controller.seenStory(storyModel.id);
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
