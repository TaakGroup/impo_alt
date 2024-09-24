import 'package:dio/dio.dart';
import 'package:impo/src/core/app/utiles/helper/box_helpers.dart';
import '../../interfaces/device_info/i_device_info.dart';
import '../../interfaces/package_info/i_package_info.dart';
import 'package:get/get.dart';


class ServiceLifecycle extends Interceptor {
  // IDeviceInfo iDeviceInfo = Get.find<IDeviceInfo>();
  // IPackageInfo packageInfo = Get.find<IPackageInfo>();

  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (BoxHelper.hasToken) options.headers['Authorization'] = "Bearer ${BoxHelper.getToken}";
    // options.headers['X-Device-Name'] = await iDeviceInfo.getDeviceModel();
    // options.headers['X-App-Version'] = await packageInfo.getSoftwareVersion();
    // options.headers['X-Date-Time'] = DateTime.now().toString();

    return super.onRequest(options, handler);
  }

  @override
  onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response!.statusCode == 401) {
      // TODO: RestartWidget.restartApp(Get.context!);
    }
    return super.onError(err, handler);
  }
}
