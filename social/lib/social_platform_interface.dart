import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'social_method_channel.dart';

abstract class SocialPlatform extends PlatformInterface {
  /// Constructs a SocialPlatform.
  SocialPlatform() : super(token: _token);

  static final Object _token = Object();

  static SocialPlatform _instance = MethodChannelSocial();

  /// The default instance of [SocialPlatform] to use.
  ///
  /// Defaults to [MethodChannelSocial].
  static SocialPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SocialPlatform] when
  /// they register themselves.
  static set instance(SocialPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
