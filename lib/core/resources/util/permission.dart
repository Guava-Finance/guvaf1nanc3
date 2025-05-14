import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guava/core/routes/router.dart';
import 'package:permission_handler/permission_handler.dart';

final permissionManagerProvider = Provider<PermissionManager>((ref) {
  return PermissionManager();
});

/// A utility class for handling app permissions
class PermissionManager {
  static final PermissionManager _instance = PermissionManager._internal();

  factory PermissionManager() => _instance;

  PermissionManager._internal();

  /// Request a specific permission
  Future<PermissionStatus> requestPermission(Permission permission) async {
    return await permission.request();
  }

  /// Request multiple permissions at once
  Future<Map<Permission, PermissionStatus>> requestPermissions(
      List<Permission> permissions) async {
    return await permissions.request();
  }

  /// Check if a specific permission is granted
  Future<bool> isPermissionGranted(Permission permission) async {
    return await permission.isGranted;
  }

  /// Request camera permission
  Future<PermissionStatus> requestCameraPermission() async {
    return await requestPermission(Permission.camera);
  }

  /// Request notification permission
  Future<PermissionStatus> requestNotificationPermission() async {
    return await requestPermission(Permission.notification);
  }

  Future<bool> verifyPermission(
    Permission permission, [
    AppSettingsType? settingsType,
  ]) async {
    // Check if already granted to avoid unnecessary request
    if (await permission.isGranted) return true;

    // Request the permission
    final status = await permission.request();

    // If granted, return true immediately
    if (status.isGranted) return true;

    // If denied in any form and settingsType provided, open settings
    if (settingsType != null) {
      await AppSettings.openAppSettings(type: settingsType);
    }

    // Return false for any denial state
    return false;
  }

  /// Request both camera and notification permissions
  Future<Map<Permission, PermissionStatus>>
      requestCameraAndNotificationPermissions() async {
    return await requestPermissions([
      Permission.camera,
      Permission.photos,
      Permission.videos,
      Permission.mediaLibrary,
      Permission.notification,
    ]);
  }

  /// Check if camera permission is granted
  Future<bool> hasCameraPermission() async {
    return await isPermissionGranted(Permission.camera);
  }

  /// Check if notification permission is granted
  Future<bool> hasNotificationPermission() async {
    return await isPermissionGranted(Permission.notification);
  }
  
  /// Show permission request dialog with rationale
  Future<PermissionStatus> requestPermissionWithRationale({
    required Permission permission,
    required String title,
    required String rationale,
    String allowButtonText = 'Allow',
    String denyButtonText = 'Deny',
  }) async {
    final status = await permission.status;

    // If already granted, return status
    if (status.isGranted) return status;

    // If denied, show rationale dialog before requesting
    if (status.isDenied) {
      final bool shouldRequest = await showDialog(
            context: navkey.currentContext!,
            builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(rationale),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(denyButtonText),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(allowButtonText),
                ),
              ],
            ),
          ) ??
          false;

      if (shouldRequest) {
        return await permission.request();
      }
      return status;
    }

    // If permanently denied, prompt to open settings
    if (status.isPermanentlyDenied) {
      final bool openSettings = await showDialog(
            context: navkey.currentContext!,
            builder: (context) => AlertDialog(
              title: const Text('Permission Required'),
              content: Text(
                '''Permission is permanently denied. Please open settings to grant permission manually.''',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Open Settings'),
                ),
              ],
            ),
          ) ??
          false;

      if (openSettings) {
        await openAppSettings();
      }
      return status;
    }

    // For other cases, just request the permission
    return await permission.request();
  }
}
