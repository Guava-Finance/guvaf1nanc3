import 'package:encrypt/encrypt.dart';

class EncryptionService {
  final Key _key;
  final IV _iv;

  EncryptionService({required String encryptionKey})
      : _key = Key.fromUtf8(encryptionKey),
        _iv = IV.fromLength(64);

  // Encrypt data
  dynamic encryptData(dynamic data) {
    if (data is String) {
      return _encryptString(data);
    } else if (data is Map<String, dynamic>) {
      return _encryptMap(data);
    } else if (data is List<dynamic>) {
      return data.map((map) => _encryptMap(map)).toList();
    } else {
      throw ArgumentError('Unsupported data type for encryption');
    }
  }


  // Decrypt data
  dynamic decryptData(dynamic data) {
    if (data is String) {
      return _decryptString(data);
    } else if (data is Map<String, dynamic>) {
      return _decryptMap(data);
    } else if (data is List<dynamic>) {
      return data.map((map) => _decryptMap(map)).toList();
    } else {
      throw ArgumentError('Unsupported data type for decryption');
    }
  }

  // Encrypt a string
  String _encryptString(String text) {
    final encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(text, iv: _iv);

    return encrypted.base64;
  }

  // Decrypt a string
  String _decryptString(String encryptedText) {
    final encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
    final decrypted = encrypter.decrypt64(encryptedText, iv: _iv);

    return decrypted;
  }

  // Encrypt a map
  Map<String, dynamic> _encryptMap(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is String) {
        return MapEntry(key, _encryptString(value));
      } else {
        // return MapEntry(key, value);
        return MapEntry(key, encryptData(value));
      }
    });
  }

  // Decrypt a map
  Map<String, dynamic> _decryptMap(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is String) {
        return MapEntry(key, _decryptString(value));
      } else {
        return MapEntry(key, decryptData(value));
        // return MapEntry(key, value);
      }
    });
  }
}
