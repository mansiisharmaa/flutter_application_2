import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionHelper {
  static Future<bool> checkCallingPermissions(BuildContext context, {required bool isVideo}) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      if (isVideo) Permission.camera,
    ].request();

    bool micGranted = statuses[Permission.microphone]?.isGranted ?? false;
    bool camGranted = !isVideo || (statuses[Permission.camera]?.isGranted ?? false);

    if (micGranted && camGranted) return true;

   
    if (statuses[Permission.microphone]!.isPermanentlyDenied ||
        (isVideo && statuses[Permission.camera]!.isPermanentlyDenied)) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Permissions Required'),
            content: const Text('Camera and Microphone permissions are required for calling. Please enable them in app settings.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(onPressed: () => openAppSettings(),
               child: const Text('Open Settings')),
            ],
          ),
        );
      }
      return false;
    }
    return false;
  }
}