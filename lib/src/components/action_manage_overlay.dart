import 'dart:async';

import 'package:flutter/services.dart';

class ActionManageOverlay {
  static const MethodChannel _channel =
  const MethodChannel('action_manage_overlay');

  static Future<bool> get canDrawOverlays async {
    final bool per = await _channel.invokeMethod('getPermissionOverlay');
    return per;
  }

  static goToSettingPermissionOverlay()async{
    await _channel.invokeMethod("goToSettingPermissionOverlay");
  }

}
