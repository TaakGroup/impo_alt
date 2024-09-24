import 'package:dio/dio.dart';
import 'package:taakitecture/core/interfaces/client.dart';
import '../../config/app_setting.dart';
import 'service_lifecycle.dart';
import 'service_logger.dart';

class DioClient extends IClient {
  final Dio _dio = Dio();

  DioClient() {
    _dio.options.baseUrl = AppSetting.baseUrl;
    _dio.interceptors.add(ServiceLifecycle());
    _dio.interceptors.add(ServiceLogger());
  }

  @override
  delete(String path, {Map<String, dynamic>? data, Map<String, String>? query}) async =>
      (await _dio.delete(path, data: data, queryParameters: query)).data;

  @override
  get(String path, Map<String, dynamic>? query) async {
    var response  = await _dio.get(Uri(path: path, queryParameters: query).toString());
    return response.data;
  }

  @override
  post(String path, {Map<String, dynamic>? data, Map<String, String>? query}) async {
    var response = await _dio.post(Uri(path: path, queryParameters: query).toString(), data: data);
    return response.data;
  }

  @override
  put(String path, {Map<String, dynamic>? data, Map<String, String>? query}) async =>
      (await _dio.put(Uri(path: path, queryParameters: query).toString(), data: data)).data;

  @override
  upload(String path, {required formData, Map<String, String>? query, Function(int, int)? onSendProgress}) async {
    final response = await _dio.post(
      Uri(path: path, queryParameters: query).toString(),
      data: formData,
    );

    if (response.data is String?) {
      return {'name': response.data, 'valid': response.data != null && response.data.isNotEmpty};
    } else {
      return response.data;
    }
  }
}

class MediaClient extends IClient {
  final Dio _dio = Dio();

  MediaClient() {
    _dio.options.baseUrl = AppSetting.baseUrl;
    _dio.interceptors.add(ServiceLifecycle());
    _dio.interceptors.add(ServiceLogger());
  }

  @override
  delete(String path, {Map<String, dynamic>? data, Map<String, String>? query}) async => (await _dio.delete(path, data: data)).data;

  @override
  get(String path, Map<String, dynamic>? query) async => (await _dio.get(path)).data;

  @override
  post(String path, {Map<String, dynamic>? data, Map<String, String>? query}) async => (await _dio.post(path, data: data)).data;

  @override
  put(String path, {Map<String, dynamic>? data, Map<String, String>? query}) async => (await _dio.put(path, data: data)).data;

  @override
  upload(String path, {required formData, Map<String, String>? query, Function(int, int)? onSendProgress}) async {
    final response = await _dio.put(
      path,
      data: formData,
      onSendProgress: onSendProgress,
    );

    if (response.data is String?) {
      return {'name': response.data, 'valid': response.data != null && response.data.isNotEmpty};
    } else {
      return response.data;
    }
  }
}
