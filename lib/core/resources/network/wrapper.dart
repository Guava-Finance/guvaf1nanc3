import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/analytics/logger/logger.dart';
import 'package:guava/core/resources/network/state.dart';

final networkExceptionWrapperProvider = Provider<NetworkExceptionWrapper>(
  (ref) => NetworkExceptionWrapper(),
);

class NetworkExceptionWrapper {
  NetworkExceptionWrapper();

  Future<bool> _isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<AppState> format(Function function) async {
    if (await _isConnected()) {
      try {
        return LoadedState(await function.call());
      } on DioException catch (e, s) {
        FirebaseCrashlytics.instance.recordError(
          e,
          s,
          reason: 'a fatal error on dio error',
          fatal: true,
        );

        if (e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionTimeout) {
          return ErrorState('Connection timed out');
        }

        if (e.response == null || e.response!.data == null) {
          return ErrorState(
            e.response?.data['message'] ?? e.message ?? 'Something went wrong',
          );
        }

        if (e.response?.statusCode == 400 || e.response?.statusCode == 401) {
          AppLogger.log(e);
          AppLogger.log(e.message);

          return ErrorState(e.response?.data['message']);
        }

        return ErrorState(
          e.message ?? e.response?.data['message'] ?? 'Something went wrong',
        );
      } catch (e, s) {
        FirebaseCrashlytics.instance.recordError(
          e,
          s,
          reason: 'a fatal error - on catch block',
          fatal: true,
        );

        return ErrorState(e.toString());
      }
    } else {
      FirebaseCrashlytics.instance.log('no internet');
      return NoInternetState('No internet access.');
    }
  }
}
