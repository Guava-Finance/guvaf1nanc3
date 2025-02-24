import 'dart:async';

import 'package:dio/dio.dart';
import 'package:guavafinance/core/resources/analytics/logger/logger.dart';
import 'package:guavafinance/core/resources/encryption/encrypt.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NetworkInterceptor {
  late EncryptionService encryptionService;

  NetworkInterceptor({
    required this.dio,
  }) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: onRequestInterceptors,
        onResponse: onResponseInterceptors,
        onError: onErrorInterceptorHandler,
      ),
    );

    // todo: Change to proper encryptionkey gotten from .env
    encryptionService = EncryptionService(encryptionKey: 'LoremIspum');
  }

  final Dio dio;

  String token = '';

  Map<String, DateTime> responsesTime = {};

  onRequestInterceptors(
    RequestOptions options,
    RequestInterceptorHandler requestInterceptorHandler,
  ) async {
    responsesTime[options.path] = DateTime.now();
    Map<String, dynamic> logData = {};

    await setToken(options);
    logData['REQUEST_DATA'] = options.data;

    // Encrypt request data if it exists
    if (options.data != null) {
      options.data = encryptionService.encryptData(options.data);
    }

    logData['METHOD'] = options.method;
    logData['URL'] = '${options.baseUrl}${options.path}';
    logData['EXTRA'] = options.extra;
    logData['ENCRYPTED_REQUEST_DATA'] = options.data;

    AppLogger.log(logData);

    return requestInterceptorHandler.next(options); //continue
  }

  onResponseInterceptors(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final resTime = DateTime.now().difference(
      responsesTime[response.requestOptions.path] as DateTime,
    );

    Map<String, dynamic> logData = {};

    logData['RESPONSE_DATA'] = response.data;

    /// Response is decrypted at this point
    if (response.data != null) {
      response.data = encryptionService.decryptData(response.data);
    }

    logData['BASEURL'] = response.requestOptions.baseUrl;
    logData['ENDPOINT'] = response.requestOptions.path;
    logData['RESPONSE_DATA'] = response.data;
    logData['ENCRYPTED_RESPONSE_TIME'] = resTime;

    responsesTime.remove(response.requestOptions.path);

    AppLogger.log(logData);

    return handler.next(response);
  }

  onErrorInterceptorHandler(DioException e, handler) {
    Map<String, dynamic> errorLogs = {};

    final resTime = DateTime.now().difference(
      responsesTime[e.requestOptions.path] as DateTime,
    );

    errorLogs['RESPONSE_DATA'] = e.response?.data;

    /// Response is decrypted at this point
    if (e.response?.data != null) {
      e.response!.data = encryptionService.decryptData(e.response!.data);
    }

    errorLogs['METHOD'] = e.requestOptions.method;
    errorLogs['PATH'] = e.requestOptions.path;
    errorLogs['BASE_URL'] = e.requestOptions.baseUrl;
    errorLogs['MESSAGE'] = e.message;
    errorLogs['ERROR'] = e.error;
    errorLogs['ENCRYPTION_RESPONSE_DATA'] = e.response?.data;
    errorLogs['RESPONSE_TIME'] = resTime;

    responsesTime.remove(e.requestOptions.path);

    AppLogger.log(errorLogs);

    return handler.next(e); //continue
  }

  Future<dynamic> get(
    String endpoint, {
    bool isProtected = true,
    bool isFormData = false,
  }) async {
    Response response = await dio.get(
      // todo: Call baseURL from enviroment
      '$endpoint',
      options: Options(headers: {
        if (isProtected) 'Authorization': 'Bearer $token',
        'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
      }),
    );

    return response.data;
  }

  Future<dynamic> post(
    String endpoint, {
    required Map<String, dynamic> data,
    bool isProtected = true,
    bool isFormData = false,
  }) async {
    Response response = await dio.post(
      '$endpoint',
      data: isFormData ? FormData.fromMap(data) : data,
      options: Options(headers: {
        if (isProtected) 'Authorization': 'Bearer $token',
        'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
      }),
    );

    return response.data;
  }

  Future<dynamic> patch(
    String endpoint, {
    required Map<String, dynamic> data,
    bool isProtected = true,
    bool isFormData = false,
  }) async {
    Response response = await dio.patch(
      '$endpoint',
      data: isFormData ? FormData.fromMap(data) : data,
      options: Options(headers: {
        if (isProtected) 'Authorization': 'Bearer $token',
        'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
      }),
    );

    return response.data;
  }

  Future<dynamic> delete(
    String endpoint, {
    bool isProtected = true,
    bool isFormData = false,
  }) async {
    Response response = await dio.delete(
      '$endpoint',
      options: Options(headers: {
        if (isProtected) 'Authorization': 'Bearer $token',
        'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
      }),
    );

    return response.data;
  }

  setToken(RequestOptions options) {
    // todo: get token from secured storage
  }
}
