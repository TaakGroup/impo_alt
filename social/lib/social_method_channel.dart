import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'social_platform_interface.dart';

/// An implementation of [SocialPlatform] that uses method channels.
class MethodChannelSocial extends SocialPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('social');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
