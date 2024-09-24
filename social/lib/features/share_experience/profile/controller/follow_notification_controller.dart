import 'package:get/get.dart';
import 'package:taakitecture/taakitecture.dart';

class FollowNotificationController extends BaseController {
  FollowNotificationController(super.remoteRepository);

  static FollowNotificationController get to => Get.find();

  activeNotification(String userId) => find('$userId/notification/active');

  inactiveNotification(String userId) => find('$userId/notification/inactive');

  onNotificationChange(String userId, bool active) => active ? activeNotification(userId) : inactiveNotification(userId);
}
