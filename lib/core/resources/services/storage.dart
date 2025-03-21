import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:guava/core/resources/services/encrypt.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
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

  Future<void> removeFromStorage(String key, {bool removeAll = false}) async {
    await secureStorage.delete(key: key);

    if (removeAll) await secureStorage.deleteAll();
  }
}
