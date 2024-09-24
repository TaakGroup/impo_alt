import 'package:flutter/services.dart';


enum FixtureSetup { useFixture, doNotUseFixture, setAsDefault }

enum BaseUrlSetup { useLocalUrl, useServerUrl, useServerIP }

enum ShowServiceDetail { notShow, showSend, showReceive, showAll }

class AppSetting {

  // DATASOURCE SETUP
  static const FixtureSetup _fixtureSetup = FixtureSetup.setAsDefault;
  static const BaseUrlSetup _baseUrlSetup = BaseUrlSetup.useLocalUrl;
  static const ShowServiceDetail showServiceDetail = ShowServiceDetail.showAll;

  static const String _socketLocalUrl = '';
  static const String _socketServerUrl = '';
  static const String _serverUrl = 'https://impox.weareimpo.ir';
  static const String _serverIP = 'http://185.252.28.158:3274';//148:5015
  static const String _localUrl = 'http://195.88.208.143:8080'; //StageUrl
  // static const String _localUrl = 'http://172.20.255.148:5224';

  // VIEW
  static List<DeviceOrientation> orientation = [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown];
  static const double mobileSize = 360;
  static const double tabletSize = 480;

  // SETTING HELPER FUNCTION
  static String get baseUrl {
    if (_baseUrlSetup == BaseUrlSetup.useServerIP && _serverIP.isNotEmpty) {
      return _serverIP;
    } else if (_baseUrlSetup == BaseUrlSetup.useServerUrl && _serverUrl.isNotEmpty) {
      return _serverUrl;
    } else if (_baseUrlSetup == BaseUrlSetup.useLocalUrl && _localUrl.isNotEmpty) {
      return _localUrl;
    } else {
      throw Exception('No BaseUrl Exception!');
    }
  }

  static String get socketUrl {
    if (_baseUrlSetup == BaseUrlSetup.useServerIP || _baseUrlSetup == BaseUrlSetup.useServerUrl) {
      return _socketServerUrl;
    } else {
      return _socketLocalUrl;
    }
  }

  static bool? get useFixture {
    switch (_fixtureSetup) {
      case FixtureSetup.useFixture:
        return true;
      case FixtureSetup.doNotUseFixture:
        return false;
      default:
        return null;
    }
  }

  static bool get showReceive {
    return showServiceDetail == ShowServiceDetail.showReceive || showServiceDetail == ShowServiceDetail.showAll;
  }

  static bool get showSend {
    return showServiceDetail == ShowServiceDetail.showSend || showServiceDetail == ShowServiceDetail.showAll;
  }
}