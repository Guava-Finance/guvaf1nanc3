import 'package:guava/core/resources/network/state.dart';
import 'package:guava/core/resources/network/wrapper.dart';
import 'package:guava/core/resources/services/storage.dart';
import 'package:guava/features/home/data/datasources/remote/remote.dart';
import 'package:guava/features/home/domain/repositories/repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(
    remoteDataSource: ref.watch(homeRemoteDatasourceProvider),
    storageService: ref.watch(securedStorageServiceProvider),
    wrapper: ref.watch(networkExceptionWrapperProvider),
  );
});

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.wrapper,
    required this.storageService,
  });

  final HomeRemoteDatasource remoteDataSource;
  final NetworkExceptionWrapper wrapper;
  final SecuredStorageService storageService;

  @override
  Future<AppState> getBalance(String address) async {
    final result = await wrapper.format(() async {
      return await remoteDataSource.getBalance(address);
    });

    return result;
  }

  @override
  Future<AppState> getExchangeRate(String currencyCode) async {
    final result = await wrapper.format(() async {
      return await remoteDataSource.getExchangeRate(currencyCode);
    });

    return result;
  }

  @override
  Future<AppState> checkUsername(String username) async {
    return await wrapper.format(() async {
      return await remoteDataSource.checkUsername(username);
    });
  }

  @override
  Future<AppState> setUsername(String wallet, String username) async {
    return await wrapper.format(() async {
      return await remoteDataSource.setUsername(wallet, username);
    });
  }
}
