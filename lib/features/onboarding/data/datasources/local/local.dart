import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deviceInfoProvider = Provider<DeviceInfoPlugin>(
  (ref) => DeviceInfoPlugin(),
);

final localDatasourceProvider = Provider<LocalDatasource>((ref) {
  return LocalDatasourceImpl(infoPlugin: ref.read(deviceInfoProvider));
});

abstract class LocalDatasource {
  Future<Map<String, dynamic>> getDeviceInformation();
}

class LocalDatasourceImpl extends LocalDatasource {
  LocalDatasourceImpl({
    required this.infoPlugin,
  });

  final DeviceInfoPlugin infoPlugin;

  @override
  Future<Map<String, dynamic>> getDeviceInformation() async {
    Map<String, dynamic> data = {};

    if (Platform.isAndroid) {
      final device = await infoPlugin.androidInfo;

      data.addAll(device.data);
    } else {
      final device = await infoPlugin.iosInfo;

      data.addAll(device.data);
    }

    return data;
  }
}
