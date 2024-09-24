import 'package:flutter_test/flutter_test.dart';
import 'package:social/social.dart';
import 'package:social/social_platform_interface.dart';
import 'package:social/social_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSocialPlatform
    with MockPlatformInterfaceMixin
    implements SocialPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SocialPlatform initialPlatform = SocialPlatform.instance;

  test('$MethodChannelSocial is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSocial>());
  });

  test('getPlatformVersion', () async {
    Social socialPlugin = Social();
    MockSocialPlatform fakePlatform = MockSocialPlatform();
    SocialPlatform.instance = fakePlatform;

    expect(await socialPlugin.getPlatformVersion(), '42');
  });
}
