import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'dart:convert';

import 'package:hashlib/hashlib.dart';

class EncryptionService {
  final Key _key;
  final IV _iv;

  // Main constructor
  EncryptionService({required String encryptionKey})
      : _key = _generateKey(encryptionKey),
        _iv = IV.fromLength(16); // AES block size is 16 bytes

  // Generate a 256-bit key from any input string
  static Key _generateKey(String input) {
    // Hash the input to get exactly 32 bytes (256 bits)
    List<int> keyBytes = sha256.convert(utf8.encode(input)).bytes;
    return Key(Uint8List.fromList(keyBytes));
  }

  // Encrypt data
  dynamic encryptData(dynamic data) {
    if (data is String) {
      return _encryptString(data);
    } else if (data is Map<String, dynamic>) {
      return _encryptMap(data);
    } else if (data is List<dynamic>) {
      return data.map((item) => encryptData(item)).toList();
    } else {
      return encryptData(jsonEncode(data));
    }
  }

  // Decrypt data
  dynamic decryptData(dynamic data) {
    if (data is String) {
      return _decryptString(data);
    } else if (data is Map<String, dynamic>) {
      return _decryptMap(data);
    } else if (data is List<dynamic>) {
      return data.map((item) => decryptData(item)).toList();
    } else {
      return encryptData(jsonDecode(data));
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
    try {
      final encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
      final decrypted = encrypter.decrypt64(encryptedText, iv: _iv);
      return decrypted;
    } catch (e) {
      // If we can't decrypt it, return the original
      return encryptedText;
    }
  }

  // Encrypt a map
  Map<String, dynamic> _encryptMap(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is String) {
        return MapEntry(key, _encryptString(value));
      } else {
        return MapEntry(key, encryptData(value));
      }
    });
  }

  // Decrypt a map
  Map<String, dynamic> _decryptMap(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is String) {
        try {
          return MapEntry(key, _decryptString(value));
        } catch (e) {
          return MapEntry(key, value);
        }
      } else {
        return MapEntry(key, decryptData(value));
      }
    });
  }

  // Get the current IV as base64 string
  String getIVBase64() {
    return _iv.base64;
  }

  // Internal constructor with explicit key and IV
  EncryptionService._internal(this._key, this._iv);

  // Factory method to create instance with specific IV
  factory EncryptionService.withIV(
      {required String encryptionKey, required String ivBase64}) {
    final key = _generateKey(encryptionKey);
    final iv = IV.fromBase64(ivBase64);

    // Validate IV length
    if (iv.bytes.length != 16) {
      throw ArgumentError('IV must be exactly 16 bytes (128 bits)');
    }

    return EncryptionService._internal(key, iv);
  }

  // Create an instance with a specific key and generate a fresh IV
  factory EncryptionService.withKey({required String encryptionKey}) {
    return EncryptionService(encryptionKey: encryptionKey);
  }
}
