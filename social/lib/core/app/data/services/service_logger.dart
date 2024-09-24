import 'package:dio/dio.dart';
import '../../../app.dart';
import '../../utils/helper/box_helpers.dart';

class ServiceLogger extends Interceptor {
  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    App.logger.i('REQUEST[${options.method}] => PATH: ${options.path} [HAS TOKEN: ${BoxHelper.hasToken}]');
    if (options.data != null) App.logger.v(options.data);

    return super.onRequest(options, handler);
  }

  @override
  onResponse(response, ResponseInterceptorHandler handler) {
    App.logger.i('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    App.logger.v(response.data);

    return super.onResponse(response, handler);
  }

  @override
  onError(DioError err, ErrorInterceptorHandler handler) {
    App.logger.e('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.baseUrl + err.requestOptions.path}');
    return super.onError(err, handler);
  }
}
