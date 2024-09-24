import 'dart:async';

import 'package:flutter/services.dart';

class FinishTask {
  static const MethodChannel _channel =
  const MethodChannel('action_manage_overlay');
  static finishTask()async{
    await _channel.invokeMethod("finishTask");
  }

}
