
import 'social_platform_interface.dart';

class Social {
  Future<String?> getPlatformVersion() {
    return SocialPlatform.instance.getPlatformVersion();
  }
}
