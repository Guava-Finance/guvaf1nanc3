import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/resources/network/interceptor.dart';

final dashboardRemoteProvider = Provider<DashboardRemoteDataSource>((ref) {
  return DashboardRemoteDataSourceImpl(
    network: ref.watch(networkInterceptorProvider),
  );
});

abstract class DashboardRemoteDataSource {}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final NetworkInterceptor network;

  DashboardRemoteDataSourceImpl({
    required this.network,
  });
}
