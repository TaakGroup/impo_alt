import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:impo/src/core/app/interfaces/device_info/i_device_info.dart';
import 'package:impo/src/core/app/utiles/helper/box_helpers.dart';
import 'package:impo/src/data/http.dart';
import 'package:logger/logger.dart';

import 'app/config/app_setting.dart';

class App {
  static late String phoneModel;
  // static AppLinks appLinks = AppLinks();
  // static ReceivePort port = ReceivePort();
  static late String baseUrl = womanUrl;
  static late String baseMediaUrl = mediaUrl;
  static GetStorage box = GetStorage();
  static Logger logger = Logger(
    printer: PrettyPrinter(
      printEmojis: false,
      printTime: false,
      methodCount: 0,
      noBoxingByDefault: true,
    ),
  );

  static Future init() async {
    if(!Get.testMode) {
      phoneModel = await Get.find<IDeviceInfo>().getDeviceModel();
      // await AndroidAlarmManager.initialize();
      await initBox();
      // initDeepLink();
    }
  }

  // static initReminderIsolate() {
  //   IsolateNameServer.registerPortWithName(port.sendPort, AppConstants.alarmIsolateName);
  // }
  //
  static onAppStart() {
    SystemChrome.setPreferredOrientations(AppSetting.orientation);
  }

  static Future initBox() async {
    await GetStorage.init();
    box = GetStorage();
  }
  //
  // static Future initDeepLink() async {
  //   try {
  //     appLinks.uriLinkStream.listen(onLinking);
  //     debugPrint('$kDebugPrintTagIdentifier Deep linking listener initialized.');
  //   } catch (_) {
  //     debugPrint('$kDebugPrintTagIdentifier Deep linking listener initialization failed.');
  //   }
  // }
  //
  // static void onLinking(Uri uri) {
  //   try {
  //     Get.toNamed(uri.path);
  //     debugPrint('$kDebugPrintTagIdentifier Deep link navigated to $uri.');
  //   } catch (_) {
  //     debugPrint('$kDebugPrintTagIdentifier Deep linking navigated to $uri failed.');
  //   }
  // }
}