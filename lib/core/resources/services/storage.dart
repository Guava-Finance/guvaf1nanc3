import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:guava/core/resources/services/encrypt.dart';

final flutterSecuredStorage = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  ),
);

final securedStorageServiceProvider = Provider<SecuredStorageService>(
  (ref) => SecuredStorageService(
    secureStorage: ref.watch(flutterSecuredStorage),
    encryptionService: ref.watch(encryptionServiceProvider),
  ),
);

class SecuredStorageService {
  SecuredStorageService({
    required this.secureStorage,
    required this.encryptionService,
  });

  final FlutterSecureStorage secureStorage;
  final EncryptionService encryptionService;

  Future<void> writeToStorage({
    required String key,
    required String value,
  }) async {
    /// encrypt the value before saving to storage
    final encryptedData = encryptionService.encryptData(value);

    return await secureStorage.write(key: key, value: encryptedData);
  }

  Future<String?> readFromStorage(String key) async {
    final String? data = await secureStorage.read(key: key);

    if (data != null) {
      final decryptedData = encryptionService.decryptData(data);

      return decryptedData;
    }

    return null;
  }

  Future<bool> doesExistInStorage(String key) async {
    return await secureStorage.containsKey(key: key);
  }

  Future<void> removeFromStorage({String? key, bool removeAll = false}) async {
    if (key != null) await secureStorage.delete(key: key);

    if (removeAll) await secureStorage.deleteAll();
  }
}
