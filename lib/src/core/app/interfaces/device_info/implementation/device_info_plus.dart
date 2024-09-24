import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:social/core/app.dart';
import '../i_device_info.dart';

class DeviceInfoPlus implements IDeviceInfo {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String deviceName = '';
  String deviceVersion = '';
  String identifier = '';

  @override
  Future<String> getDeviceModel() async {
    try {
      if (kIsWeb) {
        return 'Web';
      }

      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.release;
        identifier = build.id;
        //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor!;
        //UUID for iOS
      }
      return '$deviceName $deviceVersion $identifier';
      // return 'HelloWorld'; //for Test
    } on PlatformException {
      App.logger.e('Failed to get platform version');
      return '';
    }
  }

  @override
  Future<int> getAndroidApiNumber() async {
    return (await deviceInfoPlugin.androidInfo).version.sdkInt ?? -1;
  }
}
