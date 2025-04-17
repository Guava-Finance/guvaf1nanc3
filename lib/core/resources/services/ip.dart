import 'package:dio/dio.dart';
import 'package:guava/features/onboarding/data/models/ip_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final ipInfoServiceProvider = Provider<IpInfoService>((ref) => IpInfoService());

class IpInfoService {
  Future<IpInfo> getIpAddress() async {
    final data = await Dio().get('https://ipinfo.io/json');

    return IpInfo.fromJson(data.data);
  }
}
