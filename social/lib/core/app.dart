import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:social/core/app/utils/helper/box_helpers.dart';
import 'package:flutter/scheduler.dart';

class App {
  static late String baseUrl;
  static late String baseMediaUrl;
  static GetStorage box = GetStorage();
  static Logger logger = Logger(
    printer: PrettyPrinter(
      printEmojis: false,
      printTime: false,
      methodCount: 0,
      noBoxingByDefault: true,
    ),
  );



  static onAppStart(BuildContext context, String token, url, medialUrl) {
    timeDilation = 1;
    baseUrl = url;
    baseMediaUrl = medialUrl;
    initBox().then((value) => BoxHelper.setToken(token));
  }

  static Future initBox() async {
    await GetStorage.init();
    box = GetStorage();
  }
}
