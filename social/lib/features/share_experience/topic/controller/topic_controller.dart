import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social/features/share_experience/controller/new_experience_controller.dart';
import 'package:social/features/share_experience/view/pages/new_experience_page.dart';
import '../../../../core/app/constants/app_routes.dart';
import '../../profile/data/models/profile_model.dart';
import '../../social/controller/base_share_experience_controller.dart';
import '../../social/data/models/share_experience_comment_model.dart';
import '../../social/data/models/share_experience_topic_model.dart';

class TopicController extends BaseShareExperienceController {
  final GlobalKey<SliverAnimatedListState> listKey = GlobalKey<SliverAnimatedListState>();
  final (ShareExperienceTopicModel topic, ProfileModel profile, List<ShareExperienceTopicModel> topics) arg = Get.arguments;

  TopicController(super.remoteRepository);

  static TopicController get to => Get.find();

  @override
  String get path => 'topic/${topic.id}';

  late ShareExperienceTopicModel topic;

  List<ShareExperienceTopicModel> get topics => arg.$3;

  ProfileModel get profile => arg.$2;

  @override
  void onInit() {
    topic = arg.$1;

    super.onInit();

    change(null, status: RxStatus.loading());

    getExperiences();
  }

  @override
  onLoading() {
    if (isInitialLoading) {
      change(null, status: RxStatus.loading());
    } else {
      isPaginationLoading.value = true;
    }
  }

  @override
  onSuccess(result) {
    topic = result.currentTopic;

    super.onSuccess(result);
  }

  // Future<void> pullToRefresh() async {
  //   change(null, status: RxStatus.loading());
  //   final request = await find('$path/0/$pageSize');
  //
  //   return request.fold(
  //     (l) {},
  //     (r) async {
  //       totalCount = r.totalCount;
  //       List<ShareExperienceCommentModel> newItems = r.list.where((element) => !items.contains(element)).toList();
  //
  //       if (newItems.isNotEmpty) {
  //         items = [...newItems, ...items];
  //         listKey.currentState!.insertAllItems(0, newItems.length);
  //       }
  //
  //       if (totalCount == 0) {
  //         change(items, status: RxStatus.empty());
  //       }
  //     },
  //   );
  // }

  newExperience() async {
    final bool? hasNewExperience = await Get.to(
      NewExperiencePage(
        profile: arg.$2,
        topicId: topic.id,
      ),
      transition: Transition.downToUp,
    );

    NewExperienceController.to.resetExperience();

    if (hasNewExperience == true) onRefresh();
  }

  onComment(ShareExperienceCommentModel comment) => Get.toNamed(
        AppRoutes.comment,
        arguments: (comment, arg.$2, arg.$3),
      )?.then((value) => onRefresh());
}
