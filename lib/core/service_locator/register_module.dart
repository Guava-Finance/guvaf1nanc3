import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
        ),
      );

  @preResolve
  Future<Mixpanel> get mixPanel => Mixpanel.init(
        // todo: put our Mixpanel here
        '',
        trackAutomaticEvents: true,
      );
}
