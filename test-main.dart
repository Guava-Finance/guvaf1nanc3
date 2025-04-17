import 'package:guava/core/resources/env/env.dart';
import 'package:guava/core/resources/services/encrypt.dart';

void main(List<String> args) {
  EncryptionService encryptionService = EncryptionService(
    encryptionKey: Env.aesEncryptionKey,
    iv: Env.aesEncryptionIv,
  );

  final data = {
    'address': 'cCZv5KDIpZmY2kK5KXtm1itLET5ydtp7raWoK/VSXks=',
  };

  print('Decrytped message: ${encryptionService.decryptData(data)}');
}
