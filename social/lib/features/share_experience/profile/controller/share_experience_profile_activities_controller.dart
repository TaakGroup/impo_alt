import 'package:get/get.dart';
import 'package:social/core/app/utils/mixin/handle_failure_mixin.dart';
import 'package:taakitecture/taakitecture.dart';

import '../../social/controller/share_experience_controller.dart';
import '../../social/data/models/share_experience_comment_model.dart';

class ShareExperienceProfileActivitiesController extends BaseController with ScrollMixin, HandleFailureMixin {
  int pageNo = 0;
  final int pageSize = 5;
  bool isInitialLoading = false;
  RxBool isPaginationLoading = false.obs;
  int totalCount = double.maxFinite.toInt();
  (String userId, String title) args = Get.arguments;
  List<ShareExperienceCommentModel> items = [];

  ShareExperienceProfileActivitiesController(super.remoteRepository);

  static ShareExperienceProfileActivitiesController get to => Get.find();

  @override
  onInit() {
    getActivities();

    super.onInit();
  }

  getActivities() => find('${args.$1}/$pageNo/$pageSize');

  onRefresh() {
    pageNo = 0;

    isInitialLoading = true;

    totalCount = double.maxFinite.toInt();

    items.clear();

    getActivities();
  }

  @override
  onLoading() {
    if (isInitialLoading) {
      super.onLoading();
    } else {
      isPaginationLoading.value = true;
    }
  }

  @override
  onSuccess(result) {
    items.addAll(result.list);
    totalCount = result.totalCount;
    isPaginationLoading.value = false;
    isInitialLoading = false;
    return super.onSuccess(result);
  }

  @override
  Future<void> onEndScroll() async {
    if (totalCount > pageNo * pageSize) {
      pageNo++;
      isPaginationLoading.value = true;
      getActivities();
    }
  }

  @override
  Future<void> onTopScroll() async {}

  deleteExperience(comment) async {
    await ShareExperienceController.to.deleteExperience(comment);
    onRefresh();
  }
}
