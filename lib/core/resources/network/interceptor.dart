import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/encryption/encrypt.dart';
import 'package:guava/core/resources/env/env.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NetworkInterceptor {
  late EncryptionService encryptionService;

  FirebasePerformance performance = FirebasePerformance.instance;

  late HttpMetric metric;

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

    encryptionService = EncryptionService(
      encryptionKey: Env.aesEncryptionKey,
    );
  }

  final Dio dio;

  String token = '';

  Map<String, DateTime> responsesTime = {};

  onRequestInterceptors(
    RequestOptions options,
    RequestInterceptorHandler requestInterceptorHandler,
  ) async {
    metric = performance.newHttpMetric(
      '${options.baseUrl}/${options.path}',
      whatHttpMethod(options.method),
    );

    await metric.start();

    metric.responseContentType = options.headers['Content-Type'];
    // metric.httpResponseCode = options.statusCode;
    // metric.responsePayloadSize = options.contentLength;

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
  ) async {
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

    await metric.stop();

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
    String? baseUrl,
  }) async {
    String bUrl = baseUrl ?? Env.baseUrl;

    HttpMetric metric = performance.newHttpMetric(
      '$bUrl$endpoint',
      HttpMethod.Get,
    );

    metric.putAttribute('endpoint', endpoint);

    // Start the trace
    await metric.start();

    Response response = await dio.get(
      // todo: Call baseURL from enviroment
      '$bUrl$endpoint',
      options: Options(headers: {
        if (isProtected) 'Authorization': 'Bearer $token',
        'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
      }),
    );

    await metric.stop();

    return response.data;
  }

  Future<dynamic> post(
    String endpoint, {
    required Map<String, dynamic> data,
    bool isProtected = true,
    bool isFormData = false,
    String? baseUrl,
  }) async {
    String bUrl = baseUrl ?? Env.baseUrl;

    HttpMetric metric = performance.newHttpMetric(
      '$bUrl$endpoint',
      HttpMethod.Post,
    );

    metric.putAttribute('endpoint', endpoint);

    // Start the trace
    await metric.start();

    Response response = await dio.post(
      '$bUrl$endpoint',
      data: isFormData ? FormData.fromMap(data) : data,
      options: Options(headers: {
        if (isProtected) 'Authorization': 'Bearer $token',
        'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
      }),
    );

    await metric.stop();

    return response.data;
  }

  Future<dynamic> patch(
    String endpoint, {
    required Map<String, dynamic> data,
    bool isProtected = true,
    bool isFormData = false,
    String? baseUrl,
  }) async {
    String bUrl = baseUrl ?? Env.baseUrl;

    HttpMetric metric = performance.newHttpMetric(
      '$bUrl$endpoint',
      HttpMethod.Patch,
    );

    metric.putAttribute('endpoint', endpoint);

    // Start the trace
    await metric.start();

    Response response = await dio.patch(
      '$bUrl$endpoint',
      data: isFormData ? FormData.fromMap(data) : data,
      options: Options(headers: {
        if (isProtected) 'Authorization': 'Bearer $token',
        'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
      }),
    );

    await metric.stop();

    return response.data;
  }

  Future<dynamic> delete(
    String endpoint, {
    bool isProtected = true,
    bool isFormData = false,
    String? baseUrl,
  }) async {
    String bUrl = baseUrl ?? Env.baseUrl;

    HttpMetric metric = performance.newHttpMetric(
      '$bUrl$endpoint',
      HttpMethod.Delete,
    );

    metric.putAttribute('endpoint', endpoint);

    // Start the trace
    await metric.start();

    Response response = await dio.delete(
      '$bUrl$endpoint',
      options: Options(headers: {
        if (isProtected) 'Authorization': 'Bearer $token',
        'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
      }),
    );

    await metric.stop();

    return response.data;
  }

  setToken(RequestOptions options) {
    // todo: get token from secured storage
    options.headers = {};
  }
}

HttpMethod whatHttpMethod(String method) {
  return switch (method.toUpperCase()) {
    'GET' => HttpMethod.Get,
    'POST' => HttpMethod.Post,
    'PATCH' => HttpMethod.Patch,
    'DELETE' => HttpMethod.Delete,
    'PUT' => HttpMethod.Put,
    String() => HttpMethod.Post,
  };
}
