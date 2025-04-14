import 'dart:developer';

import 'package:guava/core/resources/env/env.dart';
import 'package:guava/core/resources/services/encrypt.dart';

void main(List<String> args) {
  EncryptionService encryptionService = EncryptionService(
    encryptionKey: Env.aesEncryptionKey,
    iv: Env.aesEncryptionIv,
  );

  final data = {
    'address':
        'MBs/iBX+Fr/fZdn5hAPG3AdYUgTOVMfSJky5lQHW2iSofwIHKctdvAAafQ4SGo0o'
  };

  print('Decrytped message: ${encryptionService.decryptData(data)}');
}
