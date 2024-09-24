import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:impo/src/core/app/data/network/mobile_network_info.dart';
import 'package:impo/src/core/app/data/network/web_network_info.dart';
import 'package:impo/src/core/app/data/services/client.dart';
import 'package:impo/src/core/app/interfaces/device_info/i_device_info.dart';
import 'package:impo/src/core/app/interfaces/device_info/implementation/device_info_plus.dart';
import 'package:impo/src/core/app/interfaces/package_info/i_package_info.dart';
import 'package:impo/src/core/app/interfaces/package_info/implementation/package_info_plus.dart';
import 'package:taakitecture/taakitecture.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<INetworkInfo>(getNetworkInfo(), permanent: true);
    Get.put<IDeviceInfo>(DeviceInfoPlus(), permanent: true);
    Get.put<IPackageInfo>(PackageInfoPlus(), permanent: true);
    Get.put<IClient>(DioClient());
  }

  INetworkInfo getNetworkInfo() {
    if (kIsWeb) {
      return WebNetworkInfo();
    } else {
      return MobileNetworkInfo();
    }
  }
}